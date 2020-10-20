Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B9D28279B
	for <lists+kvm@lfdr.de>; Sun,  4 Oct 2020 02:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgJDA2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 20:28:17 -0400
Received: from smtprelay0165.hostedemail.com ([216.40.44.165]:36944 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726108AbgJDA2R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 3 Oct 2020 20:28:17 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave07.hostedemail.com (Postfix) with ESMTP id 1A1FA18353D08
        for <kvm@vger.kernel.org>; Sun,  4 Oct 2020 00:18:22 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 1B41D12DA;
        Sun,  4 Oct 2020 00:18:21 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1311:1314:1345:1359:1515:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3872:3876:4321:5007:6120:6261:7901:10004:10848:11026:11657:11658:11914:12043:12048:12296:12297:12438:12555:12895:12986:13069:13161:13229:13311:13357:13894:14096:14181:14384:14394:14721:21080:21627,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: bikes15_230bc94271b1
X-Filterd-Recvd-Size: 2120
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf15.hostedemail.com (Postfix) with ESMTPA;
        Sun,  4 Oct 2020 00:18:19 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ben Gardon <bgardon@google.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] kvm x86/mmu: Make struct kernel_param_ops definitions const
Date:   Sat,  3 Oct 2020 17:18:07 -0700
Message-Id: <ed95eef4f10fc1317b66936c05bc7dd8f943a6d5.1601770305.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1601770305.git.joe@perches.com>
References: <cover.1601770305.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These should be const, so make it so.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 71aa3da2a0b7..6500dd681750 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -64,12 +64,12 @@ static uint __read_mostly nx_huge_pages_recovery_ratio = 60;
 static int set_nx_huge_pages(const char *val, const struct kernel_param *kp);
 static int set_nx_huge_pages_recovery_ratio(const char *val, const struct kernel_param *kp);
 
-static struct kernel_param_ops nx_huge_pages_ops = {
+static const struct kernel_param_ops nx_huge_pages_ops = {
 	.set = set_nx_huge_pages,
 	.get = param_get_bool,
 };
 
-static struct kernel_param_ops nx_huge_pages_recovery_ratio_ops = {
+static const struct kernel_param_ops nx_huge_pages_recovery_ratio_ops = {
 	.set = set_nx_huge_pages_recovery_ratio,
 	.get = param_get_uint,
 };
-- 
2.26.0

