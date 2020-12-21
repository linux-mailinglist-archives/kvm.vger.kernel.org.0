Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E392DF751
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 01:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgLUAzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Dec 2020 19:55:13 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:38345 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725956AbgLUAzN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 20 Dec 2020 19:55:13 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 41FE1580415;
        Sun, 20 Dec 2020 19:54:07 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 20 Dec 2020 19:54:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=SIxHxyqyLzEhn
        mwwU1peHf9lIiT+tCzX4idpVxjYV5I=; b=hCb37zU6RaIxloQK3e0NxyXYgZ1ah
        M+CHJ56h7KjWkiIj1yTOWIImIsrZmNl1KBHZCrW5qvVXp13hEOS/OFUgQKA9Wevm
        HCj9M6CdP3N6V3wXv1iLiinByI1V2nyXM1K/dGECdpb66wPT39bVarN/aWuRq0Ne
        f4BFrEM1EQlJdgls0T9SucNtPVJQiNPQ5k4+NrUIb+tEaHrVAdSzX2Bbp4+Ks17g
        4S3oQ4ZrSHFXj0K29WIao4pWlU3wBW3L32H7hFB1fsVPh0cphq+qV6VcAt78RD2P
        P5HUQkMfkYgIQCtVbTw7FHxJo/Wla33sL06hd00nDiQ3Okg7pdRI+q5Ww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=SIxHxyqyLzEhnmwwU1peHf9lIiT+tCzX4idpVxjYV5I=; b=J516B6b1
        EWF9W4G3Pc1+T/hP3MX8LSQP7rTy/EZPJiYJbg5hN1whHrQrfQhM49UvAk8qxL5B
        wsPClC0yDXFsafmaFN8G0Tf+tEEJWDjzzn9FqeQ14SG68wJo4/R/7vZ6ojcpqmwO
        F3jqr7nCj7PX1iDwdnWOd30Sze80TlUdEhpMq8CbLieFuyj0G4RWIhZFn9siMOLL
        /oKRcqy+MFilMmZhbnNJwUDXv3PER3kj8t5MZ3WbpiRlRfofamMdq1vCDacIVysc
        BqxV81qXNrXRNofJ1cL5LbHrx4eXYY6J8ZjRvZrBY3WzvbdZL7byBWqJYXIetKFz
        cCJ/eQP85sLHJg==
X-ME-Sender: <xms:LvLfX938PLhgeipFtadziqmxVS1zJXUsJNiKOeiUxeQceK3MnbxL3A>
    <xme:LvLfX0FU2EbVn0NQ-a6lvmn-ZOJISLtbJvNTj2ntHTNhIM73Jmcx7ytA7zkQLiPs3
    TZlsGHF7sNEKut9VO4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtuddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeflihgrgihu
    nhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomheqnecugg
    ftrfgrthhtvghrnhepjeeihffgteelkeelffdukedtheevudejvdegkeekjeefhffhhfet
    udetgfdtffeunecukfhppeeghedrfeefrdehtddrvdehgeenucevlhhushhtvghrufhiii
    gvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjihgrgihunhdrhigrnhhgsehflhih
    ghhorghtrdgtohhm
X-ME-Proxy: <xmx:LvLfX96dGodvxPSFsjeJyyubxHi3F6wg_fLFTPHPbORCTl_uAr_a5g>
    <xmx:LvLfX60XtsHeMRQL4Utj1MYO3bcAcKIkDBmsqnmFj8jwx-lvJqL9sw>
    <xmx:LvLfXwFHjSnfzGgM2b0U58vSQwXUh_sgseHDKw2D0TWCneizdbvI4A>
    <xmx:L_LfX9cIQqstWgQWZz48P6GM9-PwF5m2x5xSk0hArElgpn_81HvJIoqr6cN9CVWn>
Received: from strike.U-LINK.com (li1000-254.members.linode.com [45.33.50.254])
        by mail.messagingengine.com (Postfix) with ESMTPA id 443E724005A;
        Sun, 20 Dec 2020 19:53:58 -0500 (EST)
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
Subject: [PATCH 4/9] libvhost-user: Include poll.h instead of sys/poll.h
Date:   Mon, 21 Dec 2020 08:53:13 +0800
Message-Id: <20201221005318.11866-5-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201221005318.11866-1-jiaxun.yang@flygoat.com>
References: <20201221005318.11866-1-jiaxun.yang@flygoat.com>
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
2.29.2

