Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A341D712A78
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 18:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236875AbjEZQRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 12:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236867AbjEZQRm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 12:17:42 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9AF10A
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 09:17:40 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-64d138bd73aso771770b3a.0
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 09:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685117860; x=1687709860;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Av6JSvpMO31Ef3i0iy17brBR0RWdNZk95Vd+S8B8AUc=;
        b=vaLEOccsUzwsXjxN6+ipAFfkVqlek/jd/yllU+PFPnwfKzzLiIW04gWP16FAWyn07h
         cJkdAGEH9RwOUPpdoDeWaXRRm9mwG5ngD5+x0S3MbatsUMPf2uIdg0WIUGRev4cqQ4iA
         br5wfncZfH/9vtOY93NqR4eYYYYhQzgqbzOWomSkIPShylzxsuyxf638P1W4yqll5QZX
         44qFeMBCyFRkFPLs4CwQjtDYXG+DgfkkPlqKmV3AftZbeT7OJGfkI0C1P/WT5bz2lo0R
         jcThLiH4h7z2PilqMUdz+hxku8ZlhDagvF/ZGamCn+GJMVJQ3WUQL3wV/5yuOq01BuLu
         VkeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685117860; x=1687709860;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Av6JSvpMO31Ef3i0iy17brBR0RWdNZk95Vd+S8B8AUc=;
        b=jwSGNi++fJeWedK2xAmNI7NGlYC/tIttaqxC6tFv6D5HLpIUeIKQ+Jy3Kg+c4Kzyzl
         N4u5qosvHRYwjl7ANGtwUXBQnJ5ZJfnsRld9+sZ8MSDg7BZXKJYqA0JCXKA4puXWbXsm
         BL0PCE5abpaipT5/X8bbDAhqx+Ve8B/dmEH4gMOL+g4D7icAOALwlwLl0JI708JR3wCR
         87FJJ86JoDblb5LZRwRYaX9FqOPX1BAXopXshjKgOe4YbrbNIU8hgcrF0YXUM1SwxiZM
         YZyCZ5+MLn2eRh7dxcq9/LHHxHTcbWIOhFqY6pFvwNMDKUiQLb8VSK+vmOU5rRs/CFnz
         vRSQ==
X-Gm-Message-State: AC+VfDzXRimHr/1qoiOf/UA9wIRr6FdW9e26cFo1uO1F6RSTdCwzHqBR
        /JDxGPFY5TXVX7EVyXPowHLPqEuDzQc=
X-Google-Smtp-Source: ACHHUZ7+KLogkIR5R8qITQLoZ5UJBXPfzR+K+/t8Xuc4wOawfri/OQJgTOKb3jzwzW5RCJgPpLwlOs2SNDs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:b95:b0:63b:526c:ab09 with SMTP id
 g21-20020a056a000b9500b0063b526cab09mr1098287pfj.0.1685117860053; Fri, 26 May
 2023 09:17:40 -0700 (PDT)
Date:   Fri, 26 May 2023 09:17:38 -0700
In-Reply-To: <016686aa-fedc-08bf-df42-9451bba9f82e@rbox.co>
Mime-Version: 1.0
References: <20230525183347.2562472-1-mhal@rbox.co> <20230525183347.2562472-2-mhal@rbox.co>
 <ZG/4UN2VpZ1a6ek1@google.com> <016686aa-fedc-08bf-df42-9451bba9f82e@rbox.co>
Message-ID: <ZHDbos7Kf2aX/zyg@google.com>
Subject: Re: [PATCH 1/3] KVM: x86: Fix out-of-bounds access in kvm_recalculate_phys_map()
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 26, 2023, Michal Luczaj wrote:
> On 5/26/23 02:07, Sean Christopherson wrote:
> > On Thu, May 25, 2023, Michal Luczaj wrote:
> >> @@ -265,10 +265,14 @@ static int kvm_recalculate_phys_map(struct kvm_apic_map *new,
> >>  		 * mapped, i.e. is aliased to multiple vCPUs.  The optimized
> >>  		 * map requires a strict 1:1 mapping between IDs and vCPUs.
> >>  		 */
> >> -		if (apic_x2apic_mode(apic))
> >> +		if (apic_x2apic_mode(apic)) {
> >> +			if (x2apic_id > new->max_apic_id)
> >> +				return -EINVAL;
> > 
> > Hmm, disabling the optimized map just because userspace created a new vCPU is
> > unfortunate and unnecessary.  Rather than return -EINVAL and only perform the
> > check when x2APIC is enabled, what if we instead do the check immediately and
> > return -E2BIG?  Then the caller can retry with a bigger array size.  Preemption
> > is enabled and retries are bounded by the number of possible vCPUs, so I don't
> > see any obvious issues with retrying.
> 
> Right, that makes perfect sense.
> 
> Just a note, it changes the logic a bit:
> 
> - x2apic_format: an overflowing x2apic_id won't be silently ignored.

Nit, I wouldn't describe the current behavior as silently ignored.  KVM doesn't
ignore the case, KVM instead disables the optimized map.

> - !x2apic_format: -E2BIG even for !apic_x2apic_mode() leads to an realloc
> instead of "new->phys_map[xapic_id] = apic" right away.
> 
> > @@ -228,6 +228,12 @@ static int kvm_recalculate_phys_map(struct kvm_apic_map *new,
> >  	u32 xapic_id = kvm_xapic_id(apic);
> >  	u32 physical_id;
> >  
> > +	if (WARN_ON_ONCE(xapic_id >= new->max_apic_id))
> > +		return -EINVAL;
>
> Shouldn't it be ">" instead of ">="?

/facepalm

Yes, I was reading it as the number of IDs, not the max.

> That said, xapic_id > new->max_apic_id means something terrible has happened as
> kvm_xapic_id() returns u8 and max_apic_id should never be less than 255. Does
> this qualify for KVM_BUG_ON?

I don't think so?  The intent of the WARN is mostly to document that KVM always
allocates enough space for xAPIC IDs, and to guard against that changing in the
future.  In the latter case, there's no need to kill the VM despite there being
a KVM bug since running with the optimized map disabled is functionally ok.

If the WARN fires because of host data corruption, then so be it.

> > +	if (x2apic_id >= new->max_apic_id)
> > +		return -E2BIG;
> 
> Probably ">"?

Ya.

> > @@ -366,6 +371,7 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
> >  	unsigned long i;
> >  	u32 max_id = 255; /* enough space for any xAPIC ID */
> >  	bool xapic_id_mismatch = false;
> > +	int r;
> >  
> >  	/* Read kvm->arch.apic_map_dirty before kvm->arch.apic_map.  */
> >  	if (atomic_read_acquire(&kvm->arch.apic_map_dirty) == CLEAN)
> > @@ -386,6 +392,7 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
> >  		return;
> >  	}
> >  
> > +retry:
> >  	kvm_for_each_vcpu(i, vcpu, kvm)
> >  		if (kvm_apic_present(vcpu))
> >  			max_id = max(max_id, kvm_x2apic_id(vcpu->arch.apic));
> > @@ -404,9 +411,13 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
> >  		if (!kvm_apic_present(vcpu))
> >  			continue;
> >  
> > -		if (kvm_recalculate_phys_map(new, vcpu, &xapic_id_mismatch)) {
> > +		r = kvm_recalculate_phys_map(new, vcpu, &xapic_id_mismatch);
> > +		if (r) {
> >  			kvfree(new);
> >  			new = NULL;
> > +			if (r == -E2BIG)
> > +				goto retry;
> > +
> >  			goto out;
> >  		}
> 
> Maybe it's not important, but what about moving xapic_id_mismatch
> (re)initialization after "retry:"?

Oof, good catch.  I think it makes sense to move max_id (re)initialization too,
even though I can't imagine it would matter in practice.
