Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D757A367911
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 07:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhDVFEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 01:04:43 -0400
Received: from gimli.rothwell.id.au ([103.230.158.156]:38733 "EHLO
        gimli.rothwell.id.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbhDVFEm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 01:04:42 -0400
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Apr 2021 01:04:41 EDT
Received: from authenticated.rothwell.id.au (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.rothwell.id.au (Postfix) with ESMTPSA id 4FQlYC01crzyNW;
        Thu, 22 Apr 2021 14:58:06 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rothwell.id.au;
        s=201702; t=1619067495;
        bh=5Qm9fdL9JM0MCBkB07Q8K+HFThxx2f+WkF7TA94mSyU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RuQr3ZIc3vMel+d1Oe+xxE34mh0NlqwIV833pKPuu4joQU/pvUB1hgyduolmtscbt
         Op8qq0O9MAlx1H7p371Nhis5QzKt/gRf7zAdqWd/LrOuFtbb60RqJDME0E2dnabIQB
         yyU064eP+ATULrrhLix+XtNxuKp60oAURPpYDNSYVfd2l2IYum55bH7DGR5i7QKR+E
         vBvCWtPLOHRRqkVaU0uuZeR/mAX7BvHgoCHcsre+BkVzspPvXfSqL4IlHilD+xJOxe
         HXWMB6PNOJx6/B7+9pIje29lHsRb5h9RioCp5jdlApRH+zbe7JaXg7nVLqemAk1Nnz
         Pfd3bzRurTNDg==
Date:   Thu, 22 Apr 2021 14:58:05 +1000
From:   Stephen Rothwell <sfr@rothwell.id.au>
To:     Nadav Amit <namit@vmware.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: linux-next: manual merge of the kvm tree with the tip tree
Message-ID: <20210422145805.53ca36be@elm.ozlabs.ibm.com>
In-Reply-To: <142AD46E-6B41-49F3-90C1-624649A20764@vmware.com>
References: <20210422143056.62a3fee4@canb.auug.org.au>
        <142AD46E-6B41-49F3-90C1-624649A20764@vmware.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nadav,

On Thu, 22 Apr 2021 04:45:38 +0000 Nadav Amit <namit@vmware.com> wrote:
>
> >  static void __init kvm_smp_prepare_boot_cpu(void)
> >  {
> >  	/*
> > @@@ -655,15 -668,9 +673,9 @@@ static void __init kvm_guest_init(void
> > 
> >  	if (kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
> >  		has_steal_clock = 1;
> > -		pv_ops.time.steal_clock = kvm_steal_clock;
> > +		static_call_update(pv_steal_clock, kvm_steal_clock);  
> 
> I do not understand how this line ended in the merge fix though.
> 
> Not that it is correct or wrong, but it is not part of either of
> these 2 patches AFAIK.

It came from another patch that did not cause a conflict but ended up
in the diff output.

-- 
Cheers,
Stephen Rothwell
