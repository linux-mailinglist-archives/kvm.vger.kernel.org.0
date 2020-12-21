Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A982DF750
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 01:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgLUAzF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Dec 2020 19:55:05 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:48133 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725956AbgLUAzE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 20 Dec 2020 19:55:04 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id A75A4580416;
        Sun, 20 Dec 2020 19:53:58 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 20 Dec 2020 19:53:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=5v3r5xR/8KTgk
        2MbhP0S8UCpl80Myi9a3f0wzZyGpqA=; b=Ll6qfyAzCqncyQqoUVxe1hf+39LI0
        XjiP71boY/ACZyILIfRmcs324EGJVTqYXfd9dylw5YMF2p2xy41dUMtdxIt2XOi0
        MZ1TZ/7Q9kLyPsqBkWhuIB2hEKB/min5aK2WuM2DzqfjFzkcviB7Niw/YE8lx2Je
        It4TL4onsPqYmlkp1ILxa4yWrgGblKSZ/d1xIyF7EXPBlQkBJRyavt0bhrgvJVsQ
        x0FF9HoGYQbShjh6N8cpAKpu/wjh3QJu54Xv9xnJZTB0fRN+JU2oLL4KgPmnaiiC
        26clj8Bauxlg24NWNgcB1RQ5EvFr7GvkRO3DjSleXG2cw7SKSlAqUlPuA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=5v3r5xR/8KTgk2MbhP0S8UCpl80Myi9a3f0wzZyGpqA=; b=ZK74NNww
        ash4ckQMNi9Ch1J8uaUTnRG7Xncs9u++Emn+VSA7GxJElRGZ9EUtS6T800nSzaj4
        BDBaOdFtOTDtmIjCCBNBESR12rUVKFbOEKB8M5AeEW3OaZHYXPvM9ZR+D5gZtuQ+
        ktmWQLNbrjCwSWh4/wK3nMm9BqOfveH/m66TJnJeZwtwTq7Icz7rBNtzQH19JOQZ
        dgb612yIGCFTKJxuKpXIt5GMGaKJkNjwyJp7rxDZGrPetLuFs1yf7PdW6I9j9pbV
        onFVEgzkDsUH1xHlkBaIzfoLqfx0IkKVYi/vxjmBTAKmD5r/CIOIQyAX0ZYQvabV
        sLThOZdCmXD8eQ==
X-ME-Sender: <xms:JvLfXxHXQxaz0xiuBk9FI0jlzRAs121CB3RZ1d3cOneEGB0apahbmw>
    <xme:JvLfX2X0vbf3u0fz2QmZmQBjNN4xYTzTWFTznSKyhXNRVSZ2mHszWX4lH4AoSphcQ
    mXap8zPysds8XzjYvo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtuddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeflihgrgihu
    nhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomheqnecugg
    ftrfgrthhtvghrnhepjeeihffgteelkeelffdukedtheevudejvdegkeekjeefhffhhfet
    udetgfdtffeunecukfhppeeghedrfeefrdehtddrvdehgeenucevlhhushhtvghrufhiii
    gvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehjihgrgihunhdrhigrnhhgsehflhih
    ghhorghtrdgtohhm
X-ME-Proxy: <xmx:JvLfXzIl8L-1qgiHwB3Z70h2hJbLiWSLIHe-A-DB4WDUIH-FZ9ZjUQ>
    <xmx:JvLfX3EupmXK8vZDFFCBteTr-uE6ZwRYRg8i9VMwnSbRLj7UpoCvAA>
    <xmx:JvLfX3UQ65_geBCirbNcOU_oYmQU67GWZ7yS0i946imJn2avT_u53w>
    <xmx:JvLfX4sKs_aQSl3u9lFexAWcJO-5CrmtfCb4_RG41ElyJ3eS3hfRvK06UtrK8YfH>
Received: from strike.U-LINK.com (li1000-254.members.linode.com [45.33.50.254])
        by mail.messagingengine.com (Postfix) with ESMTPA id E929624005C;
        Sun, 20 Dec 2020 19:53:49 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        Kevin Wolf <kwolf@redhat.com>, Max Reitz <mreitz@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        Laurent Vivier <lvivier@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>,
        Alistair Francis <alistair@alistair23.me>, kvm@vger.kernel.org,
        qemu-block@nongnu.org, qemu-ppc@nongnu.org
Subject: [PATCH 3/9] configure/meson: Only check sys/signal.h on non-Linux
Date:   Mon, 21 Dec 2020 08:53:12 +0800
Message-Id: <20201221005318.11866-4-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201221005318.11866-1-jiaxun.yang@flygoat.com>
References: <20201221005318.11866-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

signal.h is equlevant of sys/signal.h on Linux, musl would complain
wrong usage of sys/signal.h.

In file included from /builds/FlyGoat/qemu/include/qemu/osdep.h:108,
                 from ../tests/qemu-iotests/socket_scm_helper.c:13:
/usr/include/sys/signal.h:1:2: error: #warning redirecting incorrect #include <sys/signal.h> to <signal.h> [-Werror=cpp]
    1 | #warning redirecting incorrect #include <sys/signal.h> to <signal.h>
      |  ^~~~~~~

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 meson.build | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/meson.build b/meson.build
index 372576f82c..1ef8722b3a 100644
--- a/meson.build
+++ b/meson.build
@@ -841,7 +841,10 @@ config_host_data.set('HAVE_DRM_H', cc.has_header('libdrm/drm.h'))
 config_host_data.set('HAVE_PTY_H', cc.has_header('pty.h'))
 config_host_data.set('HAVE_SYS_IOCCOM_H', cc.has_header('sys/ioccom.h'))
 config_host_data.set('HAVE_SYS_KCOV_H', cc.has_header('sys/kcov.h'))
-config_host_data.set('HAVE_SYS_SIGNAL_H', cc.has_header('sys/signal.h'))
+if targetos != 'linux'
+  # signal.h is equlevant of sys/signal.h on Linux
+  config_host_data.set('HAVE_SYS_SIGNAL_H', cc.has_header('sys/signal.h'))
+endif
 
 ignored = ['CONFIG_QEMU_INTERP_PREFIX'] # actually per-target
 arrays = ['CONFIG_AUDIO_DRIVERS', 'CONFIG_BDRV_RW_WHITELIST', 'CONFIG_BDRV_RO_WHITELIST']
-- 
2.29.2

