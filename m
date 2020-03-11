Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB84D180F40
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 06:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgCKFHR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 01:07:17 -0400
Received: from smtprelay0162.hostedemail.com ([216.40.44.162]:51800 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728130AbgCKFHO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Mar 2020 01:07:14 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 4B629101684F2;
        Wed, 11 Mar 2020 05:07:13 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:541:800:960:967:973:982:988:989:1260:1311:1314:1345:1359:1437:1515:1534:1541:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2859:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6261:9025:9036:10004:11026:11658:11914:12043:12296:12297:12438:12555:12679:12895:12986:13069:13255:13311:13357:13894:14181:14384:14394:14721:21080:21433:21627:21811:21939:30054,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: queen12_21d50d9d4a639
X-Filterd-Recvd-Size: 2278
Received: from joe-laptop.perches.com (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Wed, 11 Mar 2020 05:07:12 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     linux-kernel@vger.kernel.org
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH -next 015/491] KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips): Use fallthrough;
Date:   Tue, 10 Mar 2020 21:51:29 -0700
Message-Id: <5a1ee76be0f502af626f50313456730d75fe424b.1583896348.git.joe@perches.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583896344.git.joe@perches.com>
References: <cover.1583896344.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert the various uses of fallthrough comments to fallthrough;

Done via script
Link: https://lore.kernel.org/lkml/b56602fcf79f849e733e7b521bb0e17895d390fa.1582230379.git.joe.com/

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/mips/kvm/emulate.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
index 754094..8c80333 100644
--- a/arch/mips/kvm/emulate.c
+++ b/arch/mips/kvm/emulate.c
@@ -64,7 +64,7 @@ static int kvm_compute_return_epc(struct kvm_vcpu *vcpu, unsigned long instpc,
 		switch (insn.r_format.func) {
 		case jalr_op:
 			arch->gprs[insn.r_format.rd] = epc + 8;
-			/* Fall through */
+			fallthrough;
 		case jr_op:
 			nextpc = arch->gprs[insn.r_format.rs];
 			break;
@@ -140,7 +140,7 @@ static int kvm_compute_return_epc(struct kvm_vcpu *vcpu, unsigned long instpc,
 		/* These are unconditional and in j_format. */
 	case jal_op:
 		arch->gprs[31] = instpc + 8;
-		/* fall through */
+		fallthrough;
 	case j_op:
 		epc += 4;
 		epc >>= 28;
@@ -1724,14 +1724,14 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 
 	case lhu_op:
 		vcpu->mmio_needed = 1;	/* unsigned */
-		/* fall through */
+		fallthrough;
 	case lh_op:
 		run->mmio.len = 2;
 		break;
 
 	case lbu_op:
 		vcpu->mmio_needed = 1;	/* unsigned */
-		/* fall through */
+		fallthrough;
 	case lb_op:
 		run->mmio.len = 1;
 		break;
-- 
2.24.0

