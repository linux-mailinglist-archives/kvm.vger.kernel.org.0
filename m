Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01FA2F9A04
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 07:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732636AbhARGjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 01:39:42 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:37153 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732632AbhARGjk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 01:39:40 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 2B9C51685;
        Mon, 18 Jan 2021 01:38:33 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 18 Jan 2021 01:38:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=QGrARgnGjyQp2
        jNKv2fGZ+QG4BVHaGI9+gDNhbCJcKg=; b=o7Fy4nhxcw4xN5PZKm8cN4H3XurBl
        tCGyBmihky5l0w+LFsX1+Jc9M1PGTu8j6y+4+oC76ZbLNU+JMZ3FYzH0sOFADo2g
        H6oPmKakCTYJfaYLwRq+7NRtDyHqMrKrYofEizIjxcbJgAnHrnDL78B9Vyk4/Yc/
        GUcV7LSZAC+8BqRxRSGSxsUB64wopm47bE8mROx+yFEpwmdj3iq7FUwKydFCwEbC
        VSDDuS8Cn0rUnByLxb693Nz/DYcueDFS3IwQztRFECfxba+pYSwX4XrDlpXaczLH
        u3ew8RpiXSWNJPXpohCkOWh2R99IftoJLGNw2YE/xv4kjcvU1GznXflJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=QGrARgnGjyQp2jNKv2fGZ+QG4BVHaGI9+gDNhbCJcKg=; b=X6XbjIn8
        zzdxIaqWfegBBZYfl6zD/hyXx2JSH7sTD6Q+X62XcXeo6F01kR3gGQBc/yICbUiK
        lvwDSkkltphdo99qAvBnOo5RUeH1K1Sgg2C2bfbfEk8/cKk8I2d2Bw/OhOrOpyib
        JvJfdH1zuqbOOK0RdvGHtBoQ2IoJEel0/bu6UQpAT2esDPFeB2whE9XypZg495ka
        qFI4293EM8cob5t7SppXT2At6cpgfEOzWtPAh+HI4A7nSmumFIhHUayiWo6G4qax
        gD1ab1h/TIlndukNnl5Rlxp1mv6bqbze6ahhe/qm56RYHrteXbVuxgUrd+RJewLU
        9bcQ6Q0an/KLzg==
X-ME-Sender: <xms:6CwFYP-w4-dPfBc-cVehW3sm4oLLixI_nRq-AOND8QR_A85uYw6N5A>
    <xme:6CwFYLuSAeIggOABQEY9oRFIJll33NkIH6jvw6eLgTViulrEPpFq_WomFJsBzNqeh
    xzP068mYcxztsca-i8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdejgdeliecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomheplfhirgiguhhn
    ucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqeenucggtf
    frrghtthgvrhhnpeejiefhgfetleekleffudektdehvedujedvgeekkeejfefhhffhtedu
    tefgtdffueenucfkphepudduiedrvddvkedrkeegrddvnecuvehluhhsthgvrhfuihiivg
    epudenucfrrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihg
    ohgrthdrtghomh
X-ME-Proxy: <xmx:6CwFYNDTQwq9Zs9N_3Yv3rHusAxpcEDmcLVPGBu1PQcl5JLtTuySfg>
    <xmx:6CwFYLd70TegUCpygJnNxcFqhmfax7lR3TTzYncbrsKOFd-Wqu3LKA>
    <xmx:6CwFYEPbT_SAHAScLOmEebxNq6_typYJd89E0o3hzMr82x7U8bJVNA>
    <xmx:6CwFYJst-9J-s9Y--ZYOxuSv4lUzyNFjaU1wnfjVrK6wDS53JPB1wYm918l93KR3>
Received: from strike.U-LINK.com (unknown [116.228.84.2])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1E11D24005B;
        Mon, 18 Jan 2021 01:38:26 -0500 (EST)
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
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH v2 2/9] libvhost-user: Include poll.h instead of sys/poll.h
Date:   Mon, 18 Jan 2021 14:38:01 +0800
Message-Id: <20210118063808.12471-3-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
References: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Musl libc complains about it's wrong usage.

In file included from ../subprojects/libvhost-user/libvhost-user.h:20,
                 from ../subprojects/libvhost-user/libvhost-user-glib.h:19,
                 from ../subprojects/libvhost-user/libvhost-user-glib.c:15:
/usr/include/sys/poll.h:1:2: error: #warning redirecting incorrect #include <sys/poll.h> to <poll.h> [-Werror=cpp]
    1 | #warning redirecting incorrect #include <sys/poll.h> to <poll.h>
      |  ^~~~~~~

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 subprojects/libvhost-user/libvhost-user.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/subprojects/libvhost-user/libvhost-user.h b/subprojects/libvhost-user/libvhost-user.h
index 7d47f1364a..3d13dfadde 100644
--- a/subprojects/libvhost-user/libvhost-user.h
+++ b/subprojects/libvhost-user/libvhost-user.h
@@ -17,7 +17,7 @@
 #include <stdint.h>
 #include <stdbool.h>
 #include <stddef.h>
-#include <sys/poll.h>
+#include <poll.h>
 #include <linux/vhost.h>
 #include <pthread.h>
 #include "standard-headers/linux/virtio_ring.h"
-- 
2.30.0

