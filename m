Return-Path: <kvm+bounces-5596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A32BF8236EF
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 22:11:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F71C2879B4
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 21:11:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70C9F1D697;
	Wed,  3 Jan 2024 21:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yc1kbZO4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337901D558
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 21:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbe47a05516so6372033276.3
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 13:10:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704316254; x=1704921054; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FBHxZQOqHKQWZQsNLhWIGO2APx/c3T+5AETXMz0BW6c=;
        b=Yc1kbZO4ea7AXmAsMqvcpf/ajIwTCNSgspDi2aFKYOGB6LkqZ+QzV1vXDcFOlvQ680
         x/yBbl9YapBZai778kLoNcHwXoC0gcpKokl7eHFfUndkY0Lm+gAbqd61iNpQ7iBH49fh
         arYdHmBNQmfhj8Duu2yJeKho8NCmGwen+PT2lMaOhUA8rjZKhdK4MBgGn1U6JvB9Issb
         exdmNFY0CtvKuD1ZUlQZ4w763RUltcos2qASJnrsmcxAmGt+LdMjvyzH2sAUKhhN6Mop
         yeXASdaEAQ58Ql+9ltjS1sTDpmlY3E4dLeQ/eoF17YgbjUPFOEiQJNN7U00J3MiojwrQ
         Jc0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704316254; x=1704921054;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FBHxZQOqHKQWZQsNLhWIGO2APx/c3T+5AETXMz0BW6c=;
        b=WMiMTXVJHgIFtxeVIjvssKPRCMzpelXOrQT+Ni4zBeepeTm9vDnk7ubomUvskTfi+S
         4wEPn8BYW5w241UC7BfxxvbfZfv8ru44sjo5zftLwne7rCsofW/LCiktKrKVSkxpFfky
         JxEsQex2FE+cYYK6Z5YEVAOkmOKGAEodKK1ageqnlyg7aqJDAFJWey25XOJPNyrLe5LP
         +AUvrRPkCVYOGlp2wZhmchk1CFdX0nbVLXxUQ2wFDgB3Zt75lI8fzNA58oyxjCmcw+KH
         wdJ0bSl9uAtIPgI43PKW17/diWEJBzsvzDdv9Lb5+UYQZFpUkAuTkNz/JMstcilB39G2
         eFgw==
X-Gm-Message-State: AOJu0Ywh0iKhfYr1Iph3/tGujRomspT8Y1k/IzQLdBU9bHuso83jw3xf
	EJnak/ML9/BbNg6/ouLCEJL1EihJ21Scj9DRvQ==
X-Google-Smtp-Source: AGHT+IGa4g+9oBnUZU56Lne58hJptqYE1No2WgZAgnwNtYkKBHjg5J2c+84iFOCcgyBQbiUr6wcroX8sUfg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9f03:0:b0:dbd:f0c7:8926 with SMTP id
 n3-20020a259f03000000b00dbdf0c78926mr6852351ybq.7.1704316254236; Wed, 03 Jan
 2024 13:10:54 -0800 (PST)
Date: Wed, 3 Jan 2024 13:10:52 -0800
In-Reply-To: <b82bb32b-3348-4c18-b07e-34f523ae93b5@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240102232136.38778-1-Ashish.Kalra@amd.com> <ZZSqkm5WNEUuuA_h@google.com>
 <b82bb32b-3348-4c18-b07e-34f523ae93b5@amd.com>
Message-ID: <ZZXNXNZkCW8e1G5i@google.com>
Subject: Re: [PATCH] x86/sev: Add support for allowing zero SEV ASIDs.
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	thomas.lendacky@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	joro@8bytes.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 03, 2024, Ashish Kalra wrote:
> Hello Sean,
> 
> On 1/2/2024 6:30 PM, Sean Christopherson wrote:
> > On Tue, Jan 02, 2024, Ashish Kalra wrote:
> > > @@ -2172,8 +2176,10 @@ void sev_vm_destroy(struct kvm *kvm)
> > >   void __init sev_set_cpu_caps(void)
> > >   {
> > > -	if (!sev_enabled)
> > > +	if (!sev_guests_enabled) {
> > Ugh, what a mess.  The module param will show sev_enabled=false, but the caps
> > and CPUID will show SEV=true.
> > 
> > And this is doubly silly because "sev_enabled" is never actually checked, e.g.
> > if misc cgroup support is disabled, KVM_SEV_INIT will try to reclaim ASIDs and
> > eventually fail with -EBUSY, which is super confusing to users.
> 
> But this is what we expect that KVM_SEV_INIT will fail. In this case,
> sev_asid_new() will not actually try to reclaim any ASIDs as sev_misc_cg_try_charge()
> will fail before any ASID bitmap walking/reclamation and return an error which
> will eventually return -EBUSY to the user.

Please read what I wrote.  "if misc cgroup support is disabled", i.e. if
CONFIG_CGROUP_MISC=n, then sev_misc_cg_try_charge() is a nop.

> > The other weirdness is that KVM can cause sev_enabled=false && sev_es_enabled=true,
> > but if *userspace* sets sev_enabled=false then sev_es_enabled is also forced off.
> But that is already the behavior without this patch applied.
> > 
> > In other words, the least awful option seems to be to keep sev_enabled true :-(
> > 
> > >   		kvm_cpu_cap_clear(X86_FEATURE_SEV);
> > > +		return;
> > This is blatantly wrong, as it can result in KVM advertising SEV-ES if SEV is
> > disabled by the user.
> No, this ensures that we don't advertise any SEV capability if neither
> SEV/SEV-ES or in future SNP is enabled.

No, it does not.  There is an early return statement here that prevents KVM from
invoking kvm_cpu_cap_clear() for X86_FEATURE_SEV_ES.  Do I think userspace will
actually be tripped up by seeing SEV_ES without SEV?  No.  Is it unnecessarily
confusing?  Yes.

> > > +	}
> > >   	if (!sev_es_enabled)
> > >   		kvm_cpu_cap_clear(X86_FEATURE_SEV_ES);
> > >   }
> > > @@ -2229,9 +2235,11 @@ void __init sev_hardware_setup(void)
> > >   		goto out;
> > >   	}
> > > -	sev_asid_count = max_sev_asid - min_sev_asid + 1;
> > > -	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
> > > -	sev_supported = true;
> > > +	if (min_sev_asid <= max_sev_asid) {
> > > +		sev_asid_count = max_sev_asid - min_sev_asid + 1;
> > > +		WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
> > > +		sev_supported = true;
> > > +	}
> > >   	/* SEV-ES support requested? */
> > >   	if (!sev_es_enabled)
> > > @@ -2262,7 +2270,8 @@ void __init sev_hardware_setup(void)
> > >   	if (boot_cpu_has(X86_FEATURE_SEV))
> > >   		pr_info("SEV %s (ASIDs %u - %u)\n",
> > >   			sev_supported ? "enabled" : "disabled",
> > > -			min_sev_asid, max_sev_asid);
> > > +			sev_supported ? min_sev_asid : 0,
> > > +			sev_supported ? max_sev_asid : 0);
> > I honestly think we should print the "garbage" values.  The whole point of
> > printing the min/max SEV ASIDs was to help users understand why SEV is disabled,
> > i.e. printing zeroes is counterproductive.
> > 
> > >   	if (boot_cpu_has(X86_FEATURE_SEV_ES))
> > >   		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
> > >   			sev_es_supported ? "enabled" : "disabled",
> > It's all a bit gross, but I think we want something like this (I'm definitely
> > open to suggestions though):
> > 
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index d0c580607f00..bfac6d17462a 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -143,8 +143,20 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
> >   static int sev_asid_new(struct kvm_sev_info *sev)
> >   {
> > -       int asid, min_asid, max_asid, ret;
> > +       /*
> > +        * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
> > +        * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.  Note, the
> > +        * min ASID can end up larger than the max if basic SEV support is
> > +        * effectively disabled by disallowing use of ASIDs for SEV guests.
> > +        */
> > +       unsigned int min_asid = sev->es_active ? 1 : min_sev_asid;
> > +       unsigned int max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
> > +       unsigned int asid;
> >          bool retry = true;
> > +       int ret;
> > +
> > +       if (min_asid > max_asid)
> > +               return -ENOTTY;
> 
> This will still return -EBUSY to user.

Huh?  The above is obviously -ENOTTY, and I don't see anything in the call stack
that will convert it to -EBUSY.

> This check here or the failure return from sev_misc_cg_try_charge() are quite
> similar in that sense.
> 
> My point is that the same is achieved quite cleanly with
> sev_misc_cg_try_charge() too.

"Without additional effort" is not synonymous with "cleanly".  Relying on an
accounting restriction that is completely orthogonal to basic functionality is
not "clean".

> >          WARN_ON(sev->misc_cg);
> >          sev->misc_cg = get_current_misc_cg();
> > @@ -157,12 +169,6 @@ static int sev_asid_new(struct kvm_sev_info *sev)
> >          mutex_lock(&sev_bitmap_lock);
> > -       /*
> > -        * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
> > -        * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
> > -        */
> > -       min_asid = sev->es_active ? 1 : min_sev_asid;
> > -       max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
> >   again:
> >          asid = find_next_zero_bit(sev_asid_bitmap, max_asid + 1, min_asid);
> >          if (asid > max_asid) {
> > @@ -2232,8 +2238,10 @@ void __init sev_hardware_setup(void)
> >                  goto out;
> >          }
> > -       sev_asid_count = max_sev_asid - min_sev_asid + 1;
> > -       WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
> > +       if (min_sev_asid <= max_sev_asid) {
> > +               sev_asid_count = max_sev_asid - min_sev_asid + 1;
> > +               WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
> > +       }
> >          sev_supported = true;
> >          /* SEV-ES support requested? */
> > @@ -2264,8 +2272,9 @@ void __init sev_hardware_setup(void)
> >   out:
> >          if (boot_cpu_has(X86_FEATURE_SEV))
> >                  pr_info("SEV %s (ASIDs %u - %u)\n",
> > -                       sev_supported ? "enabled" : "disabled",
> > -                       min_sev_asid, max_sev_asid);
> > +                       sev_supported ? (min_sev_asid <= max_sev_asid ? "enabled" : "unusable") : "disabled",
> > +                       sev_supported ? min_sev_asid : 0,
> > +                       sev_supported ? max_sev_asid : 0);
> 
> We are not showing min and max ASIDs for SEV as {0,0} with this patch as
> sev_supported is true ?

Yes, and that is deliberate.  See this from above:

 : I honestly think we should print the "garbage" values.  The whole point of  
 : printing the min/max SEV ASIDs was to help users understand why SEV is disabled,
 : i.e. printing zeroes is counterproductive.

