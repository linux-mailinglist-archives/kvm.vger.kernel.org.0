Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF3A5161FA2
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 04:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgBRDoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 22:44:19 -0500
Received: from smtprelay0193.hostedemail.com ([216.40.44.193]:57946 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726166AbgBRDoT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Feb 2020 22:44:19 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 91814180AB5F9;
        Tue, 18 Feb 2020 03:44:17 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::,RULES_HIT:41:355:379:599:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3868:3870:3872:4321:5007:6737:10004:10400:10848:11026:11232:11473:11657:11658:11914:12048:12296:12297:12438:12740:12760:12895:13069:13255:13311:13357:13439:14659:14721:21080:21451:21611:21627:21990:30012:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: light90_4240633c2603e
X-Filterd-Recvd-Size: 1719
Received: from XPS-9350.home (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Tue, 18 Feb 2020 03:44:15 +0000 (UTC)
Message-ID: <0e28c46fe2361f0bedf438818eb7bfd1197706e2.camel@perches.com>
Subject: Re: [PATCH] KVM: VMX: replace "fall through" with "return true" to
 indicate different case
From:   Joe Perches <joe@perches.com>
To:     linmiaohe <linmiaohe@huawei.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Date:   Mon, 17 Feb 2020 19:42:53 -0800
In-Reply-To: <1581997168-20350-1-git-send-email-linmiaohe@huawei.com>
References: <1581997168-20350-1-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-02-18 at 11:39 +0800, linmiaohe wrote:
> The second "/* fall through */" in rmode_exception() makes code harder to
> read. Replace it with "return true" to indicate they are different cases
> and also this improves the readability.
[]
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
[]
> @@ -4495,7 +4495,7 @@ static bool rmode_exception(struct kvm_vcpu *vcpu, int vec)
>  		if (vcpu->guest_debug &
>  			(KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))
>  			return false;
> -		/* fall through */
> +		return true;

perhaps
		return !(vcpu->guest_debug & (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP));


