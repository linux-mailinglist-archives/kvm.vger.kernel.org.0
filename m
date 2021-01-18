Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63CEF2F9A05
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 07:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732639AbhARGjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 01:39:49 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:52029 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730636AbhARGjr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 01:39:47 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 3266D1679;
        Mon, 18 Jan 2021 01:38:40 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 18 Jan 2021 01:38:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=m0nUlI5kVEPZD
        2X5aInSXbR27bFcE8kwt/2olAPs5Ys=; b=OOweqU4vom2803WNTu/dQXB7Jh9xS
        DKVoe5QTQGemUEAc878M/+ilrlyuZZBPE5JkQcxgQlUjj5gfFt0DZjZne7wGuZX/
        ZyEs0Mj6aaO53K3H2wk4DesAlk1gI49SckxDdymMA3tBoe+FVMleO4gEGRExX8WW
        5sBjS+1a0E9IZA1xcY5s2E+jbPqczL8J9TMPYe1U0LVRi8Z9IGafQ6HUSdtL22LN
        8xgr71r8eWEkPE79vHX6VHhbgLTqbC/Q4Z1iYa6RghLWizxcdcQZETJV3RcECi45
        AKTkUdEb2kZu7RGiNqr3OLME42QFSImfjwXQ8P82+1l1qNlr0CuO1uT2w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=m0nUlI5kVEPZD2X5aInSXbR27bFcE8kwt/2olAPs5Ys=; b=OQB73Un0
        8ip0HFvMF1jTys7cMYkzLmxveWgnHDb9mBOTm2Zbthc7BmXSxWPKPsGfKmBk8Sxx
        V2wqsggWR5pvcUbVA5QdpvC4iVZa/OfmGdxonOXR7F2Z9pAVs5bBYfLa/C8NXplm
        j+KOFMA+NTdBafraTNDBKJURjdAr2q5l2Rbn/UggsYO3gKxPOfYiuHRF2ZR4vgMZ
        7z/olhrUpyFEF/khlR6qK9GslvB8a0K5F531+sw4zYLBXXULPv3GOygys2wN/nPH
        +dF6U4MVuJy4qVFI4bjY5+GcMWNMK2JsNFzjJ0e7Hlm1Mdj5upBCGaqNcsCQIqtj
        VhFkrEFqOUGoUg==
X-ME-Sender: <xms:7ywFYJYovDqfKjCbe0MH27opjT16f3DG6PsK2v58unrDMRAEjqIOGg>
    <xme:7ywFYAYo0tS69nSegiteRXolUc4L3nikFp0wf8nY5WALEL2Fc6pl_RA1rK0zFa0hu
    mQn0CR10hz0nvJ7_LE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdejgdeliecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomheplfhirgiguhhn
    ucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqeenucggtf
    frrghtthgvrhhnpeejiefhgfetleekleffudektdehvedujedvgeekkeejfefhhffhtedu
    tefgtdffueenucfkphepudduiedrvddvkedrkeegrddvnecuvehluhhsthgvrhfuihiivg
    epvdenucfrrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihg
    ohgrthdrtghomh
X-ME-Proxy: <xmx:7ywFYL_GWH43qw8iTJ0_JW0Q_WV37tUud1Hr3ZoBcz-p4eL8--59dA>
    <xmx:7ywFYHqlU63ixWF0CNXNBInOlIiU2_xDhtboUSL_Q2KXkvvEaKLSXg>
    <xmx:7ywFYErVBIjFII8aAtkNR8ub-oAa-AWxLAsR0xdnskm4bZmFwIBmcg>
    <xmx:7ywFYP_uSBt_dV-mftACShn8aGSFQae9Fi6lrONARZSTZsRt7qVrLtqI6625Ik5V>
Received: from strike.U-LINK.com (unknown [116.228.84.2])
        by mail.messagingengine.com (Postfix) with ESMTPA id D126224005C;
        Mon, 18 Jan 2021 01:38:32 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>, qemu-ppc@nongnu.org,
        Greg Kurz <groug@kaod.org>, Max Reitz <mreitz@redhat.com>,
        kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        Alistair Francis <alistair@alistair23.me>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-block@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Michael Forney <mforney@mforney.org>,
        Eric Blake <eblake@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH v2 3/9] osdep.h: Remove <sys/signal.h> include
Date:   Mon, 18 Jan 2021 14:38:02 +0800
Message-Id: <20210118063808.12471-4-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
References: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Forney <mforney@mforney.org>

Prior to 2a4b472c3c, sys/signal.h was only included on OpenBSD
(apart from two .c files). The POSIX standard location for this
header is just <signal.h> and in fact, OpenBSD's signal.h includes
sys/signal.h itself.

Unconditionally including <sys/signal.h> on musl causes warnings
for just about every source file:

  /usr/include/sys/signal.h:1:2: warning: #warning redirecting incorrect #include <sys/signal.h> to <signal.h> [-Wcpp]
      1 | #warning redirecting incorrect #include <sys/signal.h> to <signal.h>
        |  ^~~~~~~

Since there don't seem to be any platforms which require including
<sys/signal.h> in addition to <signal.h>, and some platforms like
Haiku lack it completely, just remove it.

Tested building on OpenBSD after removing this include.

Signed-off-by: Michael Forney <mforney@mforney.org>
Reviewed-by: Eric Blake <eblake@redhat.com>
[jiaxun.yang@flygoat.com: Move to meson]
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 meson.build          | 1 -
 include/qemu/osdep.h | 4 ----
 2 files changed, 5 deletions(-)

diff --git a/meson.build b/meson.build
index 3d889857a0..af2bc89741 100644
--- a/meson.build
+++ b/meson.build
@@ -1113,7 +1113,6 @@ config_host_data.set('HAVE_DRM_H', cc.has_header('libdrm/drm.h'))
 config_host_data.set('HAVE_PTY_H', cc.has_header('pty.h'))
 config_host_data.set('HAVE_SYS_IOCCOM_H', cc.has_header('sys/ioccom.h'))
 config_host_data.set('HAVE_SYS_KCOV_H', cc.has_header('sys/kcov.h'))
-config_host_data.set('HAVE_SYS_SIGNAL_H', cc.has_header('sys/signal.h'))
 
 ignored = ['CONFIG_QEMU_INTERP_PREFIX'] # actually per-target
 arrays = ['CONFIG_AUDIO_DRIVERS', 'CONFIG_BDRV_RW_WHITELIST', 'CONFIG_BDRV_RO_WHITELIST']
diff --git a/include/qemu/osdep.h b/include/qemu/osdep.h
index f9ec8c84e9..a434382c58 100644
--- a/include/qemu/osdep.h
+++ b/include/qemu/osdep.h
@@ -104,10 +104,6 @@ extern int daemon(int, int);
 #include <setjmp.h>
 #include <signal.h>
 
-#ifdef HAVE_SYS_SIGNAL_H
-#include <sys/signal.h>
-#endif
-
 #ifndef _WIN32
 #include <sys/wait.h>
 #else
-- 
2.30.0

