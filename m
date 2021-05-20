Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94C538B26A
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 17:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241551AbhETPEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 11:04:09 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:52437 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231685AbhETPEE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 11:04:04 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 56E2E1940A0B;
        Thu, 20 May 2021 10:56:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 20 May 2021 10:56:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Hr4iM646kasccUxgmKw/2QSUyPNh4wX4TMC/iX7h5gc=; b=S94S+mhm
        K4BFsevzNShq1Y8SChBB5fSD7H64ytDFQmPzSvcurdPIfOEqnFwKW7EFZupxrGm8
        7SOY0gc/4eK0WFuz4z/woIaAqTedX7v0ilsvNCyqHi2HmkZXKd6FfyVz1DFE9q+B
        i4IhJe8KJgrP+NICwDCSV7Zu09QPmdDhjcUF/r20L1OzY6olUpNqfyUiuVfkvW8p
        ddwlkbcv9z7AxB75VV6lNrJF9bFXXlSvcFh2ZLRV7d/eozC+kDf0kCI5RnE8i95e
        mmu/792LUYL9J4GYH2Cxls5NLyMj7tdheWzMLyVx1ZfTAoMDTBiuUG1BM6LXEnbw
        cZMy8KLVQfdxfg==
X-ME-Sender: <xms:tnimYFJzu7OfnJ4e7cvqiyKdLo2t7XCQ-zVOinqy6Ya2g7Nvd3VTLg>
    <xme:tnimYBLi-aP7Qc_-rSmSR9y7ezYvtv9gQ3w9n8eJ-YApvt8ml9Xx-RpVTuZ9RvCDB
    SFLSpPAPabr5w7X9jM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejuddgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucfkphepkedurddukeejrddviedrvdefkeenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghvihgurdgv
    ughmohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:tnimYNvFeU7ztCK_cYVUPFxboyebgdKwjGTdvztmucQjd8c9ZsdySg>
    <xmx:tnimYGZsY2alru_nhXu30reiwcoG3L5YBgwj-plLjx_IqTDYKpVe7w>
    <xmx:tnimYMaPBIrMiRJ9IKLWytZXzdgwSsCy1DaU-9V2iM1HK8q59PU-wQ>
    <xmx:tnimYMoJGsGrU1GPF42iJ7P4dCxGryJEthB0l2qOzaZbQtMqJPT8kA>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Thu, 20 May 2021 10:56:53 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 08649ddb;
        Thu, 20 May 2021 14:56:48 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Babu Moger <babu.moger@amd.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [RFC PATCH 6/7] target/i386: Adjust AMD XSAVE PKRU area offset in CPUID leaf 0xd
Date:   Thu, 20 May 2021 15:56:46 +0100
Message-Id: <20210520145647.3483809-7-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210520145647.3483809-1-david.edmondson@oracle.com>
References: <20210520145647.3483809-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD stores the pkru_state at a different offset to Intel, so update
the CPUID leaf which indicates such.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 target/i386/cpu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 4f481691b4..9340a477a3 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1397,7 +1397,7 @@ typedef struct ExtSaveArea {
     uint32_t offset, size;
 } ExtSaveArea;
 
-static const ExtSaveArea x86_ext_save_areas[] = {
+static ExtSaveArea x86_ext_save_areas[] = {
     [XSTATE_FP_BIT] = {
         /* x87 FP state component is always enabled if XSAVE is supported */
         .feature = FEAT_1_ECX, .bits = CPUID_EXT_XSAVE,
@@ -6088,6 +6088,11 @@ static void x86_cpu_filter_features(X86CPU *cpu, bool verbose)
             mark_unavailable_features(cpu, FEAT_7_0_EBX, CPUID_7_0_EBX_INTEL_PT, prefix);
         }
     }
+
+    if (IS_AMD_CPU(env)) {
+        x86_ext_save_areas[XSTATE_PKRU_BIT].offset =
+            offsetof(X86XSaveArea, amd.pkru_state);
+    }
 }
 
 static void x86_cpu_hyperv_realize(X86CPU *cpu)
-- 
2.30.2

