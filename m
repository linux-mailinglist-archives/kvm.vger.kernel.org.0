Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94521282798
	for <lists+kvm@lfdr.de>; Sun,  4 Oct 2020 02:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgJDAZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 20:25:55 -0400
Received: from smtprelay0121.hostedemail.com ([216.40.44.121]:52464 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726108AbgJDAZz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 3 Oct 2020 20:25:55 -0400
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Oct 2020 20:25:55 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave08.hostedemail.com (Postfix) with ESMTP id 46545182D5153;
        Sun,  4 Oct 2020 00:18:15 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id DF96F180A7FE1;
        Sun,  4 Oct 2020 00:18:13 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:541:988:989:1260:1311:1314:1345:1437:1515:1534:1538:1567:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3871:3872:3876:4605:5007:6119:6261:6737:7903:8603:10004:10848:11026:11658:11914:12048:12297:12679:12895:13069:13311:13357:13894:14384:14394:21080:21451:21627:30054:30089,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: hall06_1c073fd271b1
X-Filterd-Recvd-Size: 1595
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf15.hostedemail.com (Postfix) with ESMTPA;
        Sun,  4 Oct 2020 00:18:11 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org, rcu@vger.kernel.org,
        linux-mm@kvack.org
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] treewide: Make definitions of struct kernel_param_ops const
Date:   Sat,  3 Oct 2020 17:18:05 -0700
Message-Id: <cover.1601770305.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using const is good as it reduces data size.

Joe Perches (4):
  KVM: PPC: Book3S HV: Make struct kernel_param_ops definition const
  kvm x86/mmu: Make struct kernel_param_ops definitions const
  rcu/tree: Make struct kernel_param_ops definitions const
  mm/zswap: Make struct kernel_param_ops definitions const

 arch/powerpc/kvm/book3s_hv.c | 2 +-
 arch/x86/kvm/mmu/mmu.c       | 4 ++--
 kernel/rcu/tree.c            | 4 ++--
 mm/zswap.c                   | 6 +++---
 4 files changed, 8 insertions(+), 8 deletions(-)

-- 
2.26.0

