#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QQuickStyle>


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    QQuickStyle::setStyle("Material");

    const QUrl url(QStringLiteral("qrc:/SubtitleProject/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
