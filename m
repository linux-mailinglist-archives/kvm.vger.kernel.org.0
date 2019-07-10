Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04FEE646C7
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 15:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfGJNHR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 09:07:17 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41938 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfGJNHR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 09:07:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BEmTw1xYLeDb4aFN510BtEneL4dVYdCC7N+w5y2xum0=; b=fKaP4JOmW5uy+DvX4ab7skrVh
        e+T5TfS6+Nvk6VQjs7Bpwtdew1qGBGPSJ0ZA74fP2ApAd8bAEEaQxMsIWlj0NbT1c2DOptFkGvyDi
        zwE5VJJDmQuN5uMV4z/Rv6K67nLvJXqJlQnCoUWWAfbut0gX2oG74hn1loWxz/imsS99LkYI8qz4z
        39T/SEQcjhUP0ajstD6M1gRXE3FKG3tNr/Klpqd/L6bvtq4nest5sPFagf31wDQX4TMVS0EWL5OmA
        upsH5hy2PkSNjEbrglQ4Rith1WChVclgbWH8VY6P+39NHW5nKfd8jN0B4+mYzS+mWNemDwK75qN1s
        zFAzx8Eow==;
Received: from 177.43.30.58.dynamic.adsl.gvt.net.br ([177.43.30.58] helo=coco.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hlCJW-0004B3-Iw; Wed, 10 Jul 2019 13:07:14 +0000
Date:   Wed, 10 Jul 2019 10:07:10 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] Documentation: kvm: Convert cpuid.txt to .rst
Message-ID: <20190710100710.58443e79@coco.lan>
In-Reply-To: <20190709200721.16991-2-lnowakow@neg.ucsd.edu>
References: <20190709200721.16991-1-lnowakow@neg.ucsd.edu>
        <20190709200721.16991-2-lnowakow@neg.ucsd.edu>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Em Tue,  9 Jul 2019 13:07:19 -0700
Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu> escreveu:

> From: Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
> 
> Convert cpuid.txt to .rst format to be parsable by sphinx.
> 
> Change format and spacing to make function definitions and return values
> much more clear. Also added a table that is parsable by sphinx and makes
> the information much more clean. Updated Author email to their new
> active email address. Added license identifier with the consent of the
> author. 
> 
> Signed-off-by: Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
> ---
>  Changes since v2: 
>  + added updated Author email address
>  + changed table to simpler format
>  - removed function bolding from v1
>  Changes since v1:
>  + Converted doc to .rst format
>  
>  Documentation/virtual/kvm/cpuid.rst | 99 +++++++++++++++++++++++++++++
>  Documentation/virtual/kvm/cpuid.txt | 83 ------------------------
>  2 files changed, 99 insertions(+), 83 deletions(-)
>  create mode 100644 Documentation/virtual/kvm/cpuid.rst
>  delete mode 100644 Documentation/virtual/kvm/cpuid.txt

I strongly suggest to generate the diff with -M1, in order to show it
as a diff, instead of create/delete.

Btw, when applying on the top of linux-next, I got a merge conflict,
probably due to this patch:

	commit 9824c83f92bc8351dfb5c387436cc2816616fb4a
	Author: Paolo Bonzini <pbonzini@redhat.com>
	Date:   Tue Jul 2 18:57:29 2019 +0200

	    Documentation: kvm: document CPUID bit for MSR_KVM_POLL_CONTROL

which added a new flag (KVM_FEATURE_PV_POLL_CONTROL). There's also
another patch adding KVM_FEATURE_PV_SCHED_YIELD flag.

In order to check the results, I did already a rebase on the top a temp
branch on my experimental tree:

	https://git.linuxtv.org/mchehab/experimental.git/commit/?h=convert_rst_renames_next_v3&id=90330aba498e6d9d5258322d0006b3968e9a65a9

(please notice that this is not the upstream docs branch, so you
need to re-submit the patch to the ML)

With the rebase, for this 3 patch series:

Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

> 
> diff --git a/Documentation/virtual/kvm/cpuid.rst b/Documentation/virtual/kvm/cpuid.rst
> new file mode 100644
> index 000000000000..644c53687861
> --- /dev/null
> +++ b/Documentation/virtual/kvm/cpuid.rst
> @@ -0,0 +1,99 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +==============
> +KVM CPUID bits
> +==============
> +
> +:Author: Glauber Costa <glommer@gmail.com>
> +
> +A guest running on a kvm host, can check some of its features using
> +cpuid. This is not always guaranteed to work, since userspace can
> +mask-out some, or even all KVM-related cpuid features before launching
> +a guest.
> +
> +KVM cpuid functions are:
> +
> +function: KVM_CPUID_SIGNATURE (0x40000000)
> +
> +returns::
> +
> +   eax = 0x40000001
> +   ebx = 0x4b4d564b
> +   ecx = 0x564b4d56
> +   edx = 0x4d
> +
> +Note that this value in ebx, ecx and edx corresponds to the string "KVMKVMKVM".
> +The value in eax corresponds to the maximum cpuid function present in this leaf,
> +and will be updated if more functions are added in the future.
> +Note also that old hosts set eax value to 0x0. This should
> +be interpreted as if the value was 0x40000001.
> +This function queries the presence of KVM cpuid leafs.
> +
> +function: define KVM_CPUID_FEATURES (0x40000001)
> +
> +returns::
> +
> +          ebx, ecx
> +          eax = an OR'ed group of (1 << flag)
> +
> +where ``flag`` is defined as below:
> +
> +================================= =========== ================================
> +flag                              value       meaning
> +================================= =========== ================================
> +KVM_FEATURE_CLOCKSOURCE           0           kvmclock available at msrs
> +                                              0x11 and 0x12
> +
> +KVM_FEATURE_NOP_IO_DELAY          1           not necessary to perform delays 
> +                                              on PIO operations
> +
> +KVM_FEATURE_MMU_OP                2           deprecated
> +
> +KVM_FEATURE_CLOCKSOURCE2          3           kvmclock available at msrs
> +
> +                                              0x4b564d00 and 0x4b564d01
> +KVM_FEATURE_ASYNC_PF              4           async pf can be enabled by
> +                                              writing to msr 0x4b564d02
> +
> +KVM_FEATURE_STEAL_TIME            5           steal time can be enabled by
> +                                              writing to msr 0x4b564d03
> +
> +KVM_FEATURE_PV_EOI                6           paravirtualized end of interrupt
> +                                              handler can be enabled by
> +                                              writing to msr 0x4b564d04
> +
> +KVM_FEATURE_PV_UNHAULT            7           guest checks this feature bit
> +                                              before enabling paravirtualized
> +                                              spinlock support
> +
> +KVM_FEATURE_PV_TLB_FLUSH          9           guest checks this feature bit
> +                                              before enabling paravirtualized
> +                                              tlb flush
> +
> +KVM_FEATURE_ASYNC_PF_VMEXIT       10          paravirtualized async PF VM EXIT
> +                                              can be enabled by setting bit 2
> +                                              when writing to msr 0x4b564d02
> +
> +KVM_FEATURE_PV_SEND_IPI           11          guest checks this feature bit
> +                                              before enabling paravirtualized 
> +                                              sebd IPIs
> +
> +KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
> +                                              per-cpu warps are expeced in
> +                                              kvmclock
> +================================= =========== ================================
> +
> +::
> +
> +      edx = an OR'ed group of (1 << flag)
> +
> +Where ``flag`` here is defined as below:
> +
> +================== ============ =================================
> +flag               value        meaning
> +================== ============ =================================
> +KVM_HINTS_REALTIME 0            guest checks this feature bit to
> +                                determine that vCPUs are never
> +                                preempted for an unlimited time
> +                                allowing optimizations
> +================== ============ =================================
> diff --git a/Documentation/virtual/kvm/cpuid.txt b/Documentation/virtual/kvm/cpuid.txt
> deleted file mode 100644
> index 97ca1940a0dc..000000000000
> --- a/Documentation/virtual/kvm/cpuid.txt
> +++ /dev/null
> @@ -1,83 +0,0 @@
> -KVM CPUID bits
> -Glauber Costa <glommer@redhat.com>, Red Hat Inc, 2010
> -=====================================================
> -
> -A guest running on a kvm host, can check some of its features using
> -cpuid. This is not always guaranteed to work, since userspace can
> -mask-out some, or even all KVM-related cpuid features before launching
> -a guest.
> -
> -KVM cpuid functions are:
> -
> -function: KVM_CPUID_SIGNATURE (0x40000000)
> -returns : eax = 0x40000001,
> -          ebx = 0x4b4d564b,
> -          ecx = 0x564b4d56,
> -          edx = 0x4d.
> -Note that this value in ebx, ecx and edx corresponds to the string "KVMKVMKVM".
> -The value in eax corresponds to the maximum cpuid function present in this leaf,
> -and will be updated if more functions are added in the future.
> -Note also that old hosts set eax value to 0x0. This should
> -be interpreted as if the value was 0x40000001.
> -This function queries the presence of KVM cpuid leafs.
> -
> -
> -function: define KVM_CPUID_FEATURES (0x40000001)
> -returns : ebx, ecx
> -          eax = an OR'ed group of (1 << flag), where each flags is:
> -
> -
> -flag                               || value || meaning
> -=============================================================================
> -KVM_FEATURE_CLOCKSOURCE            ||     0 || kvmclock available at msrs
> -                                   ||       || 0x11 and 0x12.
> -------------------------------------------------------------------------------
> -KVM_FEATURE_NOP_IO_DELAY           ||     1 || not necessary to perform delays
> -                                   ||       || on PIO operations.
> -------------------------------------------------------------------------------
> -KVM_FEATURE_MMU_OP                 ||     2 || deprecated.
> -------------------------------------------------------------------------------
> -KVM_FEATURE_CLOCKSOURCE2           ||     3 || kvmclock available at msrs
> -                                   ||       || 0x4b564d00 and 0x4b564d01
> -------------------------------------------------------------------------------
> -KVM_FEATURE_ASYNC_PF               ||     4 || async pf can be enabled by
> -                                   ||       || writing to msr 0x4b564d02
> -------------------------------------------------------------------------------
> -KVM_FEATURE_STEAL_TIME             ||     5 || steal time can be enabled by
> -                                   ||       || writing to msr 0x4b564d03.
> -------------------------------------------------------------------------------
> -KVM_FEATURE_PV_EOI                 ||     6 || paravirtualized end of interrupt
> -                                   ||       || handler can be enabled by writing
> -                                   ||       || to msr 0x4b564d04.
> -------------------------------------------------------------------------------
> -KVM_FEATURE_PV_UNHALT              ||     7 || guest checks this feature bit
> -                                   ||       || before enabling paravirtualized
> -                                   ||       || spinlock support.
> -------------------------------------------------------------------------------
> -KVM_FEATURE_PV_TLB_FLUSH           ||     9 || guest checks this feature bit
> -                                   ||       || before enabling paravirtualized
> -                                   ||       || tlb flush.
> -------------------------------------------------------------------------------
> -KVM_FEATURE_ASYNC_PF_VMEXIT        ||    10 || paravirtualized async PF VM exit
> -                                   ||       || can be enabled by setting bit 2
> -                                   ||       || when writing to msr 0x4b564d02
> -------------------------------------------------------------------------------
> -KVM_FEATURE_PV_SEND_IPI            ||    11 || guest checks this feature bit
> -                                   ||       || before using paravirtualized
> -                                   ||       || send IPIs.
> -------------------------------------------------------------------------------
> -KVM_FEATURE_CLOCKSOURCE_STABLE_BIT ||    24 || host will warn if no guest-side
> -                                   ||       || per-cpu warps are expected in
> -                                   ||       || kvmclock.
> -------------------------------------------------------------------------------
> -
> -          edx = an OR'ed group of (1 << flag), where each flags is:
> -
> -
> -flag                               || value || meaning
> -==================================================================================
> -KVM_HINTS_REALTIME                 ||     0 || guest checks this feature bit to
> -                                   ||       || determine that vCPUs are never
> -                                   ||       || preempted for an unlimited time,
> -                                   ||       || allowing optimizations
> -----------------------------------------------------------------------------------



Thanks,
Mauro
