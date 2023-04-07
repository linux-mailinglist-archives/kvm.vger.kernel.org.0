Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE0B6DAEEE
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 16:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbjDGOpC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 10:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbjDGOpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 10:45:01 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E39FA
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 07:44:59 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id n3-20020a170903110300b001a50ede5078so1488645plh.8
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 07:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680878699;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gv6eZEPRoHwC1V+eZxjkjvEEaDAR56CuZbvvIwjon/E=;
        b=c8GStGHENBEjP8bjbhams8fpLgZjY6HZfrxyFX8rt4+dlyOm7p5rb+XBePUnNCEStr
         w8+WfuSn5dO+NiRbo+ChOabDyviGYrIB5i1ispRBIWO0yNrnrdal5Je2h+cMO++AAqEf
         EgZITFFY1nHa31im5YEUwTJvnSrsvN0dwuPe6EHBJGzJW69Bnat8FjN9lwwjZG4CAeSp
         LkVksEgvek5ysiT8+Vcf4VSn5duRN9qbl3UPTbsX9t/35sy4ytjfMtH3aodrpkRFH705
         Fhp9U6jAWnB7m6FdbuKWZIF9AJRIfvWtw+Z93qCgQfZogC3ZcwO+S6mbzmWdtHT/4xtw
         6g/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680878699;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gv6eZEPRoHwC1V+eZxjkjvEEaDAR56CuZbvvIwjon/E=;
        b=Jt5DHR4V0SqplEgykglxT4C3LoodR+wqRUYdM6pJKXa7yaYpxJUF+GcSP3Y6r6dOkm
         aZrsubWJ8b7+IdDDIO0F++/NZSqzs07BwFzh/enDo2VBy6TqpNnSzmmIvrJgvUCWAXKc
         mWUIG4UEGeDS14c0hma6juTNlMIDm9RUq85Pib7aKdCmC8k4APsGbbHyB+AtFNTH4TvG
         VJCZ0z5gtRkF0DyY9dinE5WioyF+tEN5D4T7FdfVbI3pVkE/HJwoB6FnVxkt7sxKA6Uh
         PdP5d3m1oC/cT8LLR8Ku50wROwMZUl0s3HairLGDhQbCbP33YAQ0PRxWhzBIkF5m0rCy
         8lvA==
X-Gm-Message-State: AAQBX9dLx2DiXeJh2echvcuUiOvsD/16JLkOZXPZ30qQFJzFIEuOxnqU
        f9BZST3a7cgIwkW1dFmJs1sYLKVtorw=
X-Google-Smtp-Source: AKy350YSwRq3OADo5G/ym7vokRAHIB96wcOcT3eqFqDZlY6eakqG7MNhVkZRGOQPI2dgFHK63yGf+NomaYs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:da8a:b0:1a2:8fa0:fbd7 with SMTP id
 j10-20020a170902da8a00b001a28fa0fbd7mr3954205plx.2.1680878699355; Fri, 07 Apr
 2023 07:44:59 -0700 (PDT)
Date:   Fri, 7 Apr 2023 07:44:57 -0700
In-Reply-To: <dfc5cba8-5efb-8ad6-01e0-2800290a9ac1@gmail.com>
Mime-Version: 1.0
References: <20230214050757.9623-1-likexu@tencent.com> <20230214050757.9623-12-likexu@tencent.com>
 <ZC9zSjZ7A47v7VCD@google.com> <dfc5cba8-5efb-8ad6-01e0-2800290a9ac1@gmail.com>
Message-ID: <ZDAsaXvx85x+n71S@google.com>
Subject: Re: [PATCH v4 11/12] KVM: x86/svm/pmu: Add AMD PerfMonV2 support
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 07, 2023, Like Xu wrote:
> On 7/4/2023 9:35 am, Sean Christopherson wrote:
> > On Tue, Feb 14, 2023, Like Xu wrote:
> > > +	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
> > > +		if (!msr_info->host_initiated)
> > > +			return 0; /* Writes are ignored */
> > 
> > Where is the "writes ignored" behavior documented?  I can't find anything in the
> > APM that defines write behavior.
> 
> KVM would follow the real hardware behavior once specifications stay silent
> on details or secret.

So is that a "this isn't actually documented anywhere" answer?  It's not your
responsibility to get AMD to document their CPUs, but I want to clearly document
when KVM's behavior is based solely off of observed hardware behavior, versus an
actual specification.

> How about this:
> 
> 	/*
> 	 * Note, AMD ignores writes to reserved bits and read-only PMU MSRs,
> 	 * whereas Intel generates #GP on attempts to write reserved/RO MSRs.
> 	 */

Looks good.

> > > +		pmu->nr_arch_gp_counters = min_t(unsigned int,
> > > +						 ebx.split.num_core_pmc,
> > > +						 kvm_pmu_cap.num_counters_gp);
> > > +	} else if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
> > >   		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS_CORE;
> > 
> > This needs to be sanitized, no?  E.g. if KVM only has access to 4 counters, but
> > userspace sets X86_FEATURE_PERFCTR_CORE anyways.  Hrm, unless I'm missing something,
> > that's a pre-existing bug.
> 
> Now your point is that if a user space more capbility than KVM can support,
> KVM should constrain it.
> Your previous preference was that the user space can set capbilities that
> evene if KVM doesn't support as long as it doesn't break KVM and host and the
> guest will eat its own.

Letting userspace define a "bad" configuration is perfectly ok, but KVM needs to
be careful not to endanger itself by consuming the bad state.  A good example is
the handling of nested SVM features in svm_vcpu_after_set_cpuid().  KVM lets
userspace define anything and everything, but KVM only actually tries to utilize
a feature if the feature is actually supported in hardware.

In this case, it's not clear to me that putting a bogus value into "nr_arch_gp_counters"
is safe (for KVM).  And AIUI, the guest can't actually use more than
kvm_pmu_cap.num_counters_gp counters, i.e. KVM isn't arbitrarily restricting the
setup.
