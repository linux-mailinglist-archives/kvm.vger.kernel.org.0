Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A102F5352D9
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 19:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344066AbiEZRqI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 13:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbiEZRqH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 13:46:07 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD924BE12
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:46:05 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c14so2280636pfn.2
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lR55KWHpwOSoAaEcAhUaanK61f3OnOi2XMTeLGzu9bs=;
        b=qd2Nc2X6/wdyIcNOv6Qo21ywbsrEF7C3ZUibw8TjkKBbBqTfs2l9K4fn4Ak7BleH01
         vy4BW2kiEGSc1b3i7JEgNUDiWVfzE7L7DgGSKdKYHblfxehyiY61zL09dPJOW7v+PuOw
         Mjy3SBfQhLJOUUgfiCU0JFq/bWOHFkp/MC7s3o5u5oXQI9Xn/R9wFWipEpSJffv6BYLW
         7OiCenQD8xeU6h7NC0kUsr2KkhQl3h4glIoLdl15/VLaZlqbY5ITzioREoitptfZA3Bh
         +KU30/d4VJ5VNoCSU5Wd5GYywl9/zmvoOG1my93UWBb1uhliafe+WTLkksheUBFLza1z
         9dGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lR55KWHpwOSoAaEcAhUaanK61f3OnOi2XMTeLGzu9bs=;
        b=0VEiMjLIWCCNr3H/YKCpOfcMU6nvU/wTXZoUEPyC6597BSCvsDIQFxlpQ3zs0d8scW
         z+eXc4MXSE9A84FKuYZzMS8WSfjDbUUpwWcXm5M4rN2rD+LOi2jxwg2u2bd82LCPxZTy
         kWNNdN+EF8q3bsPw2J+opzqoqMEZSfwLPaUUUemrrumF8V1VOqSOIWYyfW2CbqzFrhlQ
         f/8Hp5gE9uCe9VblKBZxWHjD7dEIZ7ML8KmIUJJoiLgj9pJNQw5BPSvoi3IC6wAbKbAY
         c+hxkqS5KHdYevskRc5jZ3qslNOdkwigqQuqWRqEgb7APouIJRjkYXEuVM4PjVvw0Xzo
         bxjA==
X-Gm-Message-State: AOAM530F1N4cJNaVFbjc3V8zpSSityIiOdAnk58RYPs1N7R3g2JkhF2m
        du/LO1UdqVJlHxgxVJINxlYRAQ==
X-Google-Smtp-Source: ABdhPJxeCNOJBurSjZVZAqpmB0YPDCFgRWdF850TiVKMA3ibaVXiRCJLewc2vNot4EAVqViJt4f+Kw==
X-Received: by 2002:a05:6a00:1790:b0:519:139d:705d with SMTP id s16-20020a056a00179000b00519139d705dmr4787769pfg.71.1653587164997;
        Thu, 26 May 2022 10:46:04 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id r4-20020aa79624000000b0050dc76281fdsm1765809pfg.215.2022.05.26.10.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 10:46:04 -0700 (PDT)
Date:   Thu, 26 May 2022 17:46:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Shivam Kumar <shivam.kumar1@nutanix.com>, pbonzini@redhat.com,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v4 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <Yo+82LjHSOdyxKzT@google.com>
References: <20220521202937.184189-1-shivam.kumar1@nutanix.com>
 <20220521202937.184189-2-shivam.kumar1@nutanix.com>
 <87h75fmmkj.wl-maz@kernel.org>
 <bf24e007-23fd-2582-ec0c-5e79ab0c7d56@nutanix.com>
 <878rqomnfr.wl-maz@kernel.org>
 <Yo+gTbo5uqqAMjjX@google.com>
 <877d68mfqv.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877d68mfqv.wl-maz@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022, Marc Zyngier wrote:
> On Thu, 26 May 2022 16:44:13 +0100,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > On Thu, May 26, 2022, Marc Zyngier wrote:
> > > > >> +{
> > > > >> +	struct kvm_run *run = vcpu->run;
> > > > >> +	u64 dirty_quota = READ_ONCE(run->dirty_quota);
> > > > >> +	u64 pages_dirtied = vcpu->stat.generic.pages_dirtied;
> > > > >> +
> > > > >> +	if (!dirty_quota || (pages_dirtied < dirty_quota))
> > > > >> +		return 1;
> > > > > What happens when page_dirtied becomes large and dirty_quota has to
> > > > > wrap to allow further progress?
> > > > Every time the quota is exhausted, userspace is expected to set it to
> > > > pages_dirtied + new quota. So, pages_dirtied will always follow dirty
> > > > quota. I'll be sending the qemu patches soon. Thanks.
> > > 
> > > Right, so let's assume that page_dirtied=0xffffffffffffffff (yes, I
> > > have dirtied that many pages).
> > 
> > Really?  Written that many bytes from a guest?  Maybe.  But actually
> > marked that many pages dirty in hardware, let alone in KVM?  And on
> > a single CPU?
> >
> > By my back of the napkin math, a 4096 CPU system running at 16ghz
> > with each CPU able to access one page of memory per cycle would take
> > ~3 days to access 2^64 pages.
> > 
> > Assuming a ridiculously optimistic ~20 cycles to walk page tables,
> > fetch the cache line from memory, insert into the TLB, and mark the
> > PTE dirty, that's still ~60 days to actually dirty that many pages
> > in hardware.
> > 
> > Let's again be comically optimistic and assume KVM can somehow
> > propagate a dirty bit from hardware PTEs to the dirty bitmap/ring in
> > another ~20 cycles.  That brings us to ~1200 days.
> > 
> > But the stat is per vCPU, so that actually means it would take
> > ~13.8k years for a single vCPU/CPU to dirty 2^64 pages... running at
> > a ludicrous 16ghz on a CPU with latencies that are a likely an order
> > of magnitude faster than anything that exists today.
> 
> Congratulations, you can multiply! ;-)

Don't ask me how long it took for me do to that math :-D

> It just shows that the proposed API is pretty bad, because instead of
> working as a credit, it works as a ceiling, based on a value that is
> dependent on the vpcu previous state (forcing userspace to recompute
> the next quota on each exit),

My understanding is that intended use case is dependent on previous vCPU state by
design.  E.g. a vCPU that is aggressively dirtying memory will be given a different
quota than a vCPU that has historically not dirtied much memory.

Even if the quotas are fixed, "recomputing" the new quota is simply:

	run->dirty_quota = run->dirty_quota_exit.count + PER_VCPU_DIRTY_QUOTA

The main motivation for the ceiling approach is that it's simpler for KVM to implement
since KVM never writes vcpu->run->dirty_quota.  E.g. userspace may observe a "spurious"
exit if KVM reads the quota right before it's changed by userspace, but KVM doesn't
have to guard against clobbering the quota.

A credit based implementation would require (a) snapshotting the credit at
some point during of KVM_RUN, (b) disallowing changing the quota credit while the
vCPU is running, or (c) an expensive atomic sequence (expensive on x86 at least)
to avoid clobbering an update from userspace.  (a) is undesirable because it delays
recognition of the new quota, especially if KVM doesn't re-read the quota in the
tight run loop.  And AIUI, changing the quota while the vCPU is running is a desired
use case, so that rules out (b).  The cost of (c) is not the end of the world, but
IMO the benefits are marginal.

E.g. if we go with a request-based implementation where kvm_vcpu_check_dirty_quota()
is called in mark_page_dirty_in_slot(), then the ceiling-based approach is:

  static void kvm_vcpu_is_dirty_quota_exhausted(struct kvm_vcpu *vcpu)
  {
        u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);

	if (!dirty_quota || (vcpu->stat.generic.pages_dirtied < dirty_quota))
		return;

	/*
	 * Snapshot the quota to report it to userspace.  The dirty count will
	 * captured when the request is processed.
	 */
	vcpu->dirty_quota = dirty_quota;
	kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu);
  }

whereas the credit-based approach would need to be something like:

  static void kvm_vcpu_is_dirty_quota_exhausted(struct kvm_vcpu *vcpu)
  {
        u64 old_dirty_quota;

	if (!READ_ONCE(vcpu->run->dirty_quota_enabled))
		return;

	old_dirty_quota = atomic64_fetch_add_unless(vcpu->run->dirty_quota, -1, 0);

	/* Quota is not yet exhausted, or was already exhausted. */
	if (old_dirty_quota != 1)
		return;

	/*
	 * The dirty count will be re-captured in dirty_count when the request
	 * is processed so that userspace can compute the number of pages that
	 * were dirtied after the quota was exhausted.
	 */
	vcpu->dirty_count_at_exhaustion = vcpu->stat.generic.pages_dirtied;
	kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu);
  }

> and with undocumented, arbitrary limits as a bonus.

Eh, documenting that userspace needs to be aware of a theoretically-possible wrap
is easy enough.  If we're truly worried about a wrap scenario, it'd be trivial to
add a flag/ioctl() to let userspace reset vcpu->stat.generic.pages_dirtied.
