Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C18B2F9A0D
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 07:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732711AbhARGlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 01:41:15 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:45561 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732710AbhARGkn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 01:40:43 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 5282216B4;
        Mon, 18 Jan 2021 01:39:06 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 18 Jan 2021 01:39:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=f02riIqmTLQjf
        sxRmbAMxWaoH+GGUs+3oNGVdaXSoVI=; b=lz/uwNtjyS4HJK6A9jLDosCCw2xu/
        lKGto8uYLz1han+qS4v8X4RhN1ETSsgaWTAwKmwGTQrMnrETkrb3L81AzHVeLQnP
        wHwjKoDf6w8kDMQ3uRC3tSeZHAnFbWb2ng0dsnfW9tfiTmCFSxgfYx22TpM8jPPf
        PyfdvSmnRDyrn7ws3cCqPYBmWNuc1/dE/MPMm0kafxzjOhxvPdRYV0TG/TEabjFv
        LpMbjJTyBKtJzK2a/r6aSPBQdvULxKG9byNOD07E//kUsrzJhUf4PrxEs+arzAer
        K8D1syicVce8HJNPNvZgDPfSR3zVNYQp2rd+qg10caMfOt0acgJBjYQbA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=f02riIqmTLQjfsxRmbAMxWaoH+GGUs+3oNGVdaXSoVI=; b=IItl3g64
        587aclrnXUPhADssPjQRWvNfM0ii43Rjnb0JCnBRL/SnduS5YKmswjKRF8VXkBl9
        l0vVfQgcJEQGlfXK2R+VDPSnKTlAEsWBHRxeIYgdPEarC4r44cOWwjmu1YhDxYUU
        I2UZssX6lde82ljHgxg97F9xF0IbXFk5S9nnke/KQEglnK92ri4GsSVI0W0ddtYX
        JihmSk3dRSH/4aEHL0IO4c2es4ndc/z5hACTayPKgIjfLGxOyth+GCOtmz5PpNMU
        FzvmRDAUX0xkFi1UmCzDVrNPzCOEP+BU7fXvOzqGrPQe34vymPbiMvAjyoY+k10z
        rhsofRywjHaxpw==
X-ME-Sender: <xms:CS0FYO1cJ7KEh2R5-sWcG-fdA_B8wsv3Vtdv2dJmykoehAcbhaWxgQ>
    <xme:CS0FYBGbsbAnWZQDbsK1IMHvd8MPZBnCfE9kd8rxRYkq7-GKZCMO9d83yEAEodeyf
    AfMOeWHdv6TQM1Ucxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdejgdeliecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomheplfhirgiguhhn
    ucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqeenucggtf
    frrghtthgvrhhnpedtveehvdefleeghfeuveffjeeuffetffekhfeviedujeeiieevuddv
    iedtheffjeenucffohhmrghinhepohhpvghnghhrohhuphdrohhrghenucfkphepudduie
    drvddvkedrkeegrddvnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghi
    lhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomh
X-ME-Proxy: <xmx:CS0FYG6k_HVbjyz-1sDMQH5mP-Z_ASBFPq0t2QeQVQbwVVbWXTqg0Q>
    <xmx:CS0FYP1CmHbAODeVPDsjuzW9ILgnAypeIwGw_ZjJ_dw3sBGkR4Xomg>
    <xmx:CS0FYBGYg653Q6CKtevhG7z7gRgoiEQRKxCnna6TEYZ8ZwSDQyZOsA>
    <xmx:CS0FYDEcWQVXPhChRaAlwqCaUxRbremDLrBt2-e6fcPIdEm9Jb9Tqhu0Qg1ZTnm1>
Received: from strike.U-LINK.com (unknown [116.228.84.2])
        by mail.messagingengine.com (Postfix) with ESMTPA id 97DE424005C;
        Mon, 18 Jan 2021 01:38:59 -0500 (EST)
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
Subject: [PATCH v2 7/9] accel/kvm: avoid using predefined PAGE_SIZE
Date:   Mon, 18 Jan 2021 14:38:06 +0800
Message-Id: <20210118063808.12471-8-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
References: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As per POSIX specification of limits.h [1], OS libc may define
PAGE_SIZE in limits.h.

PAGE_SIZE is used in included kernel uapi headers.

To prevent collosion of definition, we discard PAGE_SIZE from
defined by libc and take QEMU's variable.

[1]: https://pubs.opengroup.org/onlinepubs/7908799/xsh/limits.h.html

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 accel/kvm/kvm-all.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 389eaace72..3feb17d965 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -58,6 +58,9 @@
 /* KVM uses PAGE_SIZE in its definition of KVM_COALESCED_MMIO_MAX. We
  * need to use the real host PAGE_SIZE, as that's what KVM will use.
  */
+#ifdef PAGE_SIZE
+#undef PAGE_SIZE
+#endif
 #define PAGE_SIZE qemu_real_host_page_size
 
 //#define DEBUG_KVM
-- 
2.30.0

