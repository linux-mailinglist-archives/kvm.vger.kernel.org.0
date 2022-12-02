Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D798640AD5
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 17:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234169AbiLBQb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 11:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233779AbiLBQb3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 11:31:29 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099AE880FC
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 08:31:23 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id v3so4791133pgh.4
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 08:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RsaZyzKJOuyFVoAfYZw39HCTNem7JcJUeEd5tgG0e8Y=;
        b=JuBGytq8t5tr5SVnzdgiUWfOnnv3YoaxJ/EPOkhREUxf0Lu7Q36UoNdircCDscdJe1
         Ne3pPvJP46804SbaTNQC7CD0nyOf+6DUf7RttT6MnjeqYf2tKeLulPmMzXN6C0vzpI5a
         kmqZ1b2nEnQBpLkucgI+K9CNuj0M6idXU9Z/tpGiUmJvFfSAKZUEJ0tYDDD5QTm1XgZh
         KUg4c1fCmmWL1AfPqQe/Q+7M8gt59bLLwzR5wrgb2mkyqnFKW9rqK8zn1jiKosWg6tGN
         xvGvpF7x1Z6otoY0Ddi4ibaMdJj9vaSCpFDZW9nFUZDm9ecAOG+G1OAJWfl9eXVsVqrU
         2Qew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RsaZyzKJOuyFVoAfYZw39HCTNem7JcJUeEd5tgG0e8Y=;
        b=IbYgC9RWwG4cKK7yts+OPGChZQN0F3tgYO+xAhON/T/IH9lpDsLNRA261dkD7k5Vq3
         TXR1bgsznB7ecYK6neh3aNPiEboUf5u6QLdHD+4u1zO7JhKsnS8wqFJLI9AOIV+epjXq
         qjpWaofPEPtzhd1/MdAezrgu1AIWZSzTrzG2DiMR2KEOFPdqbSUXin8fGMvQp7yll1OU
         RKbmSN1/AoBqXn0g0ulFKFmnFrgXS7eGVfCIcgMmKDKt74RV9kgAvAuRFve2qE7qf7mW
         7VmmJpYid49Yjws2eTVBcFT2ZWxRG+X6e/rzqQrE2Q+q4DTXVY0B3HYK/863f7tz2903
         yy8Q==
X-Gm-Message-State: ANoB5pmYM1CR/RnBKm3B3ni9wlfQd6ilgpApjymp1mQ/TvIHIwJkm9fv
        7BFuhqvoVdeJzqYZtFht2noDSQ==
X-Google-Smtp-Source: AA0mqf5YDkgE2z83Sno75+zaFki0bhnK0sTw98u0yDu/SzUnzr69GggIhlhUBJVYlhlyDIQeZ9Y6nA==
X-Received: by 2002:a65:5601:0:b0:43c:4eef:bac7 with SMTP id l1-20020a655601000000b0043c4eefbac7mr46619641pgs.356.1669998682344;
        Fri, 02 Dec 2022 08:31:22 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g204-20020a6252d5000000b005756a67e227sm5438977pfb.90.2022.12.02.08.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 08:31:21 -0800 (PST)
Date:   Fri, 2 Dec 2022 16:31:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "paul@xen.org" <paul@xen.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "anup@brainfault.org" <anup@brainfault.org>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "farosas@linux.ibm.com" <farosas@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "Yao, Yuan" <yuan.yao@intel.com>,
        "alexandru.elisei@arm.com" <alexandru.elisei@arm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "atishp@atishpatra.org" <atishp@atishpatra.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v2 42/50] KVM: Disable CPU hotplug during hardware
 enabling/disabling
Message-ID: <Y4ooVrDTkscy68vg@google.com>
References: <20221130230934.1014142-1-seanjc@google.com>
 <20221130230934.1014142-43-seanjc@google.com>
 <8b1053781e859aa95a08c10b0e8a06912a2b42a2.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b1053781e859aa95a08c10b0e8a06912a2b42a2.camel@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 02, 2022, Huang, Kai wrote:
> On Wed, 2022-11-30 at 23:09 +0000, Sean Christopherson wrote:
> > From: Chao Gao <chao.gao@intel.com>
> > 
> > Disable CPU hotplug when enabling/disabling hardware to prevent the
> > corner case where if the following sequence occurs:
> > 
> >   1. A hotplugged CPU marks itself online in cpu_online_mask
> >   2. The hotplugged CPU enables interrupt before invoking KVM's ONLINE
> >      callback
> >   3  hardware_{en,dis}able_all() is invoked on another CPU
> > 
> > the hotplugged CPU will be included in on_each_cpu() and thus get sent
> > through hardware_{en,dis}able_nolock() before kvm_online_cpu() is called.
> 
> Should we explicitly call out what is the consequence of such case, otherwise
> it's hard to tell whether this truly is an issue?
>
> IIUC, since now the compatibility check has already been moved to
> kvm_arch_hardware_enable(), the consequence is hardware_enable_all() will fail
> if the now online cpu isn't compatible, which will results in failing to create
> the first VM.  This isn't ideal since the incompatible cpu should be rejected to
> go online instead.

Actually, in that specific scenario, KVM should not reject the CPU.  E.g. if KVM
is autoloaded (common with systemd and/or qemu-kvm installed), but not used by
userspace, then KVM is overstepping by rejecting the incompatible CPU since the
user likely cares more about onlining a CPU than they do about KVM.

> > KVM currently fudges around this race by keeping track of which CPUs have
> > done hardware enabling (see commit 1b6c016818a5 "KVM: Keep track of which
> > cpus have virtualization enabled"), but that's an inefficient, convoluted,
> > and hacky solution.

...

> > +	/*
> > +	 * Compatibility checks are done when loading KVM and when enabling
> > +	 * hardware, e.g. during CPU hotplug, to ensure all online CPUs are
> > +	 * compatible, i.e. KVM should never perform a compatibility check on
> > +	 * an offline CPU.
> > +	 */
> > +	WARN_ON(!cpu_online(cpu));
> 
> IMHO this chunk logically should belong to previous patch.  IIUC disabling CPU
> hotplug during hardware_enable_all() doesn't have relationship to this WARN().

Hmm, yeah, I agree.  I'll move it.

> >  static int hardware_enable_all(void)
> >  {
> >  	int r = 0;
> >  
> > +	/*
> > +	 * When onlining a CPU, cpu_online_mask is set before kvm_online_cpu()
> > +	 * is called, and so on_each_cpu() between them includes the CPU that
> > +	 * is being onlined.  As a result, hardware_enable_nolock() may get
> > +	 * invoked before kvm_online_cpu(), which also enables hardware if the
> > +	 * usage count is non-zero.  Disable CPU hotplug to avoid attempting to
> > +	 * enable hardware multiple times.
> 
> It won't enable hardware multiple times, right?  Since hardware_enable_nolock()
> has below check:
> 
>         if (cpumask_test_cpu(cpu, cpus_hardware_enabled))                      
>                 return;                                                        
>                                                                                                                                                    
>         cpumask_set_cpu(cpu, cpus_hardware_enabled);     
> 
> IIUC the only issue is the one that I replied in the changelog.
> 
> Or perhaps I am missing something?

You're not missing anything in terms of code.  What the comment means by "attempting"
in this case is calling hardware_enable_nolock().  As called out in the changelog,
guarding against this race with cpus_hardware_enabled is a hack, i.e. KVM should
not have to rely on a per-CPU flag.

 : KVM currently fudges around this race by keeping track of which CPUs have
 : done hardware enabling (see commit 1b6c016818a5 "KVM: Keep track of which
 : cpus have virtualization enabled"), but that's an inefficient, convoluted,
 : and hacky solution.

I actually considered removing the per-CPU flag, but decided not to because it's
simpler to blast

	on_each_cpu(hardware_disable_nolock, ...)

in kvm_reboot() and if enabling hardware fails on one or more CPUs, and taking a
#UD on VMXOFF in the latter case is really unnecessary, i.e. the flag is nice to
have for other reasons.

That said, after this patch, KVM should be able to WARN in the enable path.  I'll
test that and do a more thorough audit; unless I'm missing something, I'll add a
patch to do:

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b8c6bfb46066..ee896fa2f196 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5027,7 +5027,7 @@ static int kvm_usage_count;
 
 static int __hardware_enable_nolock(void)
 {
-       if (__this_cpu_read(hardware_enabled))
+       if (WARN_ON_ONCE(__this_cpu_read(hardware_enabled)))
                return 0;
 
        if (kvm_arch_hardware_enable()) {

