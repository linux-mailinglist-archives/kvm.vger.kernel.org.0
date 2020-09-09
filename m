Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139802629CC
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 10:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730240AbgIIIMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 04:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729521AbgIIIMo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 04:12:44 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C387C061756;
        Wed,  9 Sep 2020 01:12:43 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id s13so1364164wmh.4;
        Wed, 09 Sep 2020 01:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zWDA6BwSldfyMXCEjHeoPUemwX4iXhVKjCMVzCIFz5o=;
        b=eE9pldJHq4R2SKBKiFAfarDVN9/9b/G25TWKtyLmKlNKXMTtmd3bAR9JVHBLsuXB9B
         /Dzxr9k78I1tRomZmNPTLz5TRFQFPoTUL+F53pmKs9/SxTOG5MsObYn9spCVCK7Dp//r
         Q3WNozbLYKxf2uVzUNgi65U0Lw9Rcm+PDwnlqksiVrC+MhQGipZlAJyzewLSNJO8BVL0
         dx0vGpDtmotN5QK9jQtDYbyQ0vr/dfaGh38SndjWhzUZfRZVVzv2Inov9DlpWGny/Hw1
         AOPeyY2gGILThE5vl83sJmyvgfUhZoPdQRPee5ptKBw/w42JZ46i1fLDxhQ2toLWurS9
         6yPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=zWDA6BwSldfyMXCEjHeoPUemwX4iXhVKjCMVzCIFz5o=;
        b=qjtl5Luv9Kc2OHNAYh1pyxKGNfG2ZVBLlw+Xn14DhTf9A9REpIgoUs11HJC7mvmNYn
         WCamVR348Mq98TYNQ5Ru8Lq5qKvZvPcr71K4baeAjqvSiFeK0FohTf7ZrCvgT1zH24ts
         abwpwPibK1JLjtPP9zvVGBd/TXFcwKCyEorKz9FhOasKE/ZIWTEJ2k/NpIizDKPXaR7n
         6t4Srj9Y2p6OVAZPfLO6bxXAoZj3eAydEJfYSNGmeEnKdHgGPi76DkrCAVMtgRtjK5qj
         2FSc8o9YeEGdiBBX2LyqG6F8wLsC3Op/zR8uL4rzhZOv3jttukdy+1BexkxzBhaJPYyS
         MEzg==
X-Gm-Message-State: AOAM531ZuufHO0LQExqsNySyBYQMVD45HP0iEaw3v6H7E80/N3yqW7Nl
        vVrMemazSYRS3X7sH7vOsds=
X-Google-Smtp-Source: ABdhPJzovEJ+yb8T6cY28y9nptnqhzwXad0TRIE9F+pM30PT4pIRe//ziWPukpq3Uj5mxKLQ7ObBRA==
X-Received: by 2002:a1c:4303:: with SMTP id q3mr2313548wma.158.1599639162215;
        Wed, 09 Sep 2020 01:12:42 -0700 (PDT)
Received: from gmail.com (54007801.dsl.pool.telekom.hu. [84.0.120.1])
        by smtp.gmail.com with ESMTPSA id b2sm2690916wmh.47.2020.09.09.01.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:12:41 -0700 (PDT)
Date:   Wed, 9 Sep 2020 10:12:39 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Will Deacon <will@kernel.org>
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 5.9
Message-ID: <20200909081239.GA2446260@gmail.com>
References: <20200805182606.12621-1-pbonzini@redhat.com>
 <20200908180939.GA2378263@gmail.com>
 <6a83e6f1e9c34e44ae818ef88ec185a7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a83e6f1e9c34e44ae818ef88ec185a7@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


* Christopherson, Sean J <sean.j.christopherson@intel.com> wrote:

> Ingo Molnar wrote:
> > * Paolo Bonzini <pbonzini@redhat.com> wrote:
> > 
> > > Paolo Bonzini (11):
> > >       Merge branch 'kvm-async-pf-int' into HEAD
> > 
> > kvmtool broke in this merge window, hanging during bootup right after CPU bringup:
> > 
> >  [    1.289404]  #63
> >  [    0.012468] kvm-clock: cpu 63, msr 6ff69fc1, secondary cpu clock
> >  [    0.012468] [Firmware Bug]: CPU63: APIC id mismatch. Firmware: 3f APIC: 14
> >  [    1.302320] kvm-guest: KVM setup async PF for cpu 63
> >  [    1.302320] kvm-guest: stealtime: cpu 63, msr 1379d7600
> > 
> > Eventually trigger an RCU stall warning:
> > 
> >  [   22.302392] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
> >  [   22.302392] rcu: 	1-...!: (68 GPs behind) idle=00c/0/0x0 softirq=0/0 fqs=0  (false positive?)
> > 
> > I've bisected this down to the above merge commit. The individual commit:
> > 
> >    b1d405751cd5: ("KVM: x86: Switch KVM guest to using interrupts for page ready APF delivery")
> > 
> > appears to be working fine standalone.
> > 
> > I'm using x86-64 defconfig+kvmconfig on SVM. Can send more info on request.
> > 
> > The kvmtool.git commit I've tested is 90b2d3adadf2.
> 
> Looks a lot like the lack of APIC EOI issue that Vitaly reported[*].
> 
> ---
>  arch/x86/kernel/kvm.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index d45f34cbe1ef..9663ba31347c 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -271,6 +271,8 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_asyncpf_interrupt)
>  	struct pt_regs *old_regs = set_irq_regs(regs);
>  	u32 token;
>  
> +	ack_APIC_irq();
> +
>  	inc_irq_stat(irq_hv_callback_count);
>  
>  	if (__this_cpu_read(apf_reason.enabled)) {
> --
> 
> [*] https://lkml.kernel.org/r/20200908135350.355053-1-vkuznets@redhat.com

Yep, this does the trick, thanks!

Tested-by: Ingo Molnar <mingo@kernel.org>

	Ingo
