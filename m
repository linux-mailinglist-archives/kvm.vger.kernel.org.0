Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B568138B268
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 17:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240238AbhETPEG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 11:04:06 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:33305 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231330AbhETPEE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 11:04:04 -0400
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 May 2021 11:04:04 EDT
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4E06219409C2;
        Thu, 20 May 2021 10:56:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 20 May 2021 10:56:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=0XKNL7YZ691EHtFvC6KzkvGYHe5z3roIn3UQ0rlEtnM=; b=tgS5bYhV
        mZo58dJtKTN5BR366Z/irlcasJZT4cxXCMPCoQwx0zKMFsRDx8A9+xhQdXwsLRoB
        xPjXLGw/TapcFnj6feWzDIkisi3nJZrm+E0gpgPSidZRJysojk24FGd5o+X8YNIl
        OwZDBOolw4O+JhMgTEiGAC4QUE6pHDyzd6BYZff0v94hUmNeMpc4whd9WJzbK2HO
        esHsMKxKV552dXggzlgNB+ZjhveGN/BlnALYDxW6pMxY9t5FVXU6K6OlXGxNgi/k
        TTUHIbHRQHmghNE3k5kc3sZr6hp2r4Wqq5lD1GpkPykxRLjlCKc0ie+mOIbxS26j
        pTWzoIB3JofCPQ==
X-ME-Sender: <xms:s3imYAUxL4iZ8FzUGdti-Do0jNX8ZHiqd6NirnZUA4mAUkP3J7xP0Q>
    <xme:s3imYEl5tDAsyveEVXIVRkf4cgP95ooMC5cxakBNBYiuSwl4k-0EqgKuiCnnOC2Gv
    hhLkIuIcNYla5KX2SA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejuddgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucfkphepkedurddukeejrddviedrvdefkeenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghvihgurdgv
    ughmohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:s3imYEaSe_abHYRgc_uOIKK6QyPKPU-7ddz2vK7bj5JYjjhfHNOiKQ>
    <xmx:s3imYPWXc8m_bHHu2ePp69xm24hzAhfkgnkM2lkB3UjUrIMI1-39gA>
    <xmx:s3imYKmV3Wh_F4Lj69o1EbOnHdwUsNEXAEZDBtB_Ila73nnx5COKwQ>
    <xmx:s3imYAldnz52TaQZe05zcf6SL5J64nEaZpjh0-xcg0q-Zqd4DBOORA>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Thu, 20 May 2021 10:56:50 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 874f0275;
        Thu, 20 May 2021 14:56:47 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Babu Moger <babu.moger@amd.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [RFC PATCH 1/7] target/i386: Declare constants for XSAVE offsets
Date:   Thu, 20 May 2021 15:56:41 +0100
Message-Id: <20210520145647.3483809-2-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210520145647.3483809-1-david.edmondson@oracle.com>
References: <20210520145647.3483809-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Declare and use manifest constants for the XSAVE state component
offsets.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 target/i386/cpu.h | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index e6836393f7..1fb732f366 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1305,6 +1305,22 @@ typedef struct XSavePKRU {
     uint32_t padding;
 } XSavePKRU;
 
+#define XSAVE_FCW_FSW_OFFSET    0x000
+#define XSAVE_FTW_FOP_OFFSET    0x004
+#define XSAVE_CWD_RIP_OFFSET    0x008
+#define XSAVE_CWD_RDP_OFFSET    0x010
+#define XSAVE_MXCSR_OFFSET      0x018
+#define XSAVE_ST_SPACE_OFFSET   0x020
+#define XSAVE_XMM_SPACE_OFFSET  0x0a0
+#define XSAVE_XSTATE_BV_OFFSET  0x200
+#define XSAVE_AVX_OFFSET        0x240
+#define XSAVE_BNDREG_OFFSET     0x3c0
+#define XSAVE_BNDCSR_OFFSET     0x400
+#define XSAVE_OPMASK_OFFSET     0x440
+#define XSAVE_ZMM_HI256_OFFSET  0x480
+#define XSAVE_HI16_ZMM_OFFSET   0x680
+#define XSAVE_PKRU_OFFSET       0xa80
+
 typedef struct X86XSaveArea {
     X86LegacyXSaveArea legacy;
     X86XSaveHeader header;
@@ -1325,19 +1341,19 @@ typedef struct X86XSaveArea {
     XSavePKRU pkru_state;
 } X86XSaveArea;
 
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, avx_state) != 0x240);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, avx_state) != XSAVE_AVX_OFFSET);
 QEMU_BUILD_BUG_ON(sizeof(XSaveAVX) != 0x100);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, bndreg_state) != 0x3c0);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, bndreg_state) != XSAVE_BNDREG_OFFSET);
 QEMU_BUILD_BUG_ON(sizeof(XSaveBNDREG) != 0x40);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, bndcsr_state) != 0x400);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, bndcsr_state) != XSAVE_BNDCSR_OFFSET);
 QEMU_BUILD_BUG_ON(sizeof(XSaveBNDCSR) != 0x40);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, opmask_state) != 0x440);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, opmask_state) != XSAVE_OPMASK_OFFSET);
 QEMU_BUILD_BUG_ON(sizeof(XSaveOpmask) != 0x40);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, zmm_hi256_state) != 0x480);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, zmm_hi256_state) != XSAVE_ZMM_HI256_OFFSET);
 QEMU_BUILD_BUG_ON(sizeof(XSaveZMM_Hi256) != 0x200);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, hi16_zmm_state) != 0x680);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, hi16_zmm_state) != XSAVE_HI16_ZMM_OFFSET);
 QEMU_BUILD_BUG_ON(sizeof(XSaveHi16_ZMM) != 0x400);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, pkru_state) != 0xA80);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, pkru_state) != XSAVE_PKRU_OFFSET);
 QEMU_BUILD_BUG_ON(sizeof(XSavePKRU) != 0x8);
 
 typedef enum TPRAccess {
-- 
2.30.2

