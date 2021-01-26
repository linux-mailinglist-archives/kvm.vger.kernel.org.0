Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4501E305D14
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 14:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313554AbhAZWgZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:36:25 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:47675 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389499AbhAZRer (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 12:34:47 -0500
X-Greylist: delayed 1632 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jan 2021 12:34:46 EST
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1l4RgD-00045p-EA; Tue, 26 Jan 2021 17:59:01 +0100
Received: from ukl by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1l4Rg3-0003hY-Ft; Tue, 26 Jan 2021 17:58:51 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Russell King <linux@armlinux.org.uk>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Vinod Koul <vkoul@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Eric Anholt <eric@anholt.net>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig.org@pengutronix.de>,
        Mike Leach <mike.leach@linaro.org>,
        Leo Yan <leo.yan@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
        dri-devel@lists.freedesktop.org, coresight@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-serial@vger.kernel.org,
        kvm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH v3 0/5] amba: minor fix and various cleanups
Date:   Tue, 26 Jan 2021 17:58:30 +0100
Message-Id: <20210126165835.687514-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig.org@pengutronix.de

Hello,

Changes since v2 sent with Message-Id:
20201124133139.3072124-1-uwe@kleine-koenig.org:

 - Rebase to v5.11-rc1 (which resulted in a few conflicts in
   drivers/hwtracing).
 - Add various Acks.
 - Send to more maintainers directly (which I think is one of the
   reasons why there are so few Acks).

For my taste patch 4 needs some more acks (drivers/char/hw_random,
drivers/dma, drivers/gpu/drm/pl111, drivers/i2c, drivers/mmc,
drivers/vfio, drivers/watchdog and sound/arm have no maintainer feedback
yet).

My suggestion is to let this series go in via Russell King (who cares
for amba). Once enough Acks are there I can also provide a tag for
merging into different trees. Just tell me if you prefer this solution.

Would be great if this could make it for v5.12, but I'm aware it's
already late in the v5.11 cycle so it might have to wait for v5.13.

Best regards
Uwe

Uwe Kleine-König (5):
  amba: Fix resource leak for drivers without .remove
  amba: reorder functions
  vfio: platform: simplify device removal
  amba: Make the remove callback return void
  amba: Make use of bus_type functions

 drivers/amba/bus.c                            | 234 +++++++++---------
 drivers/char/hw_random/nomadik-rng.c          |   3 +-
 drivers/dma/pl330.c                           |   3 +-
 drivers/gpu/drm/pl111/pl111_drv.c             |   4 +-
 drivers/hwtracing/coresight/coresight-catu.c  |   3 +-
 .../hwtracing/coresight/coresight-cpu-debug.c |   4 +-
 .../hwtracing/coresight/coresight-cti-core.c  |   4 +-
 drivers/hwtracing/coresight/coresight-etb10.c |   4 +-
 .../coresight/coresight-etm3x-core.c          |   4 +-
 .../coresight/coresight-etm4x-core.c          |   4 +-
 .../hwtracing/coresight/coresight-funnel.c    |   4 +-
 .../coresight/coresight-replicator.c          |   4 +-
 drivers/hwtracing/coresight/coresight-stm.c   |   4 +-
 .../hwtracing/coresight/coresight-tmc-core.c  |   4 +-
 drivers/hwtracing/coresight/coresight-tpiu.c  |   4 +-
 drivers/i2c/busses/i2c-nomadik.c              |   4 +-
 drivers/input/serio/ambakmi.c                 |   3 +-
 drivers/memory/pl172.c                        |   4 +-
 drivers/memory/pl353-smc.c                    |   4 +-
 drivers/mmc/host/mmci.c                       |   4 +-
 drivers/rtc/rtc-pl030.c                       |   4 +-
 drivers/rtc/rtc-pl031.c                       |   4 +-
 drivers/spi/spi-pl022.c                       |   5 +-
 drivers/tty/serial/amba-pl010.c               |   4 +-
 drivers/tty/serial/amba-pl011.c               |   3 +-
 drivers/vfio/platform/vfio_amba.c             |  15 +-
 drivers/video/fbdev/amba-clcd.c               |   4 +-
 drivers/watchdog/sp805_wdt.c                  |   4 +-
 include/linux/amba/bus.h                      |   2 +-
 sound/arm/aaci.c                              |   4 +-
 30 files changed, 157 insertions(+), 198 deletions(-)


base-commit: 5c8fe583cce542aa0b84adc939ce85293de36e5e
-- 
2.29.2

