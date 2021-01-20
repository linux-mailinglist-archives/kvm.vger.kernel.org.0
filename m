Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2332FC64B
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 02:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbhATBOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 20:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729246AbhATBOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 20:14:35 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3D6C061573
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 17:13:55 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id n7so14135361pgg.2
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 17:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LbrB+4hBFfY1b4S9nQZrJqW6y4BpWyRafcJJN86RQm0=;
        b=ZBwz00YWmDJicFydsf3OnyNkQhb1TYHGNQwSv0LX7h1Z0uHe0PENX+xlbfUIL5C1Kr
         8K/fMxTwhSXNVSBOx58wsj2dZI89AhRrg4VtqgoYUnCyE4ggWKxgMSTzkNkWy8JOXCve
         dPBNvbkur0z+AW/hXNLkjbo6VGlS1N/+aG9JIg4B5+P/Z5hwYuvxI8ego1KzUyY8tVyN
         U5nkBpCxUqp5EoJzZEf9CJbjm+moSqToMdd8z14G90nnzPiAyiLq93lixACACRpS2U/t
         1/ertp/SYCHvOvnSiUh1oi9oM6085eRWyQra/b9jjfkU06WSjLiUDnKKHcutlw4lzNbs
         D6Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LbrB+4hBFfY1b4S9nQZrJqW6y4BpWyRafcJJN86RQm0=;
        b=J05u/P+m7jFNOfdkm7fgfzuNR5P5M/Koe9uiwbwjCMRK2Dy7yuxDV+A6mO7yKhN4BT
         yTla97vFiNy+iTdZdTJ19NkyB+9fzrQBEJdq8I19Gm/8KmEVk/6+bGheM7JoadHaDiFc
         0Cn1v+3liB9dlvGO42UGemwBBk+3sZM36E/JwKwd9sfeCql9GuW0G3N1eNnnsWX9bySP
         uziR4uivM0Ybvf3YSffVHUJv+nR/yY5yZ/3RMk3yzhFLjZ6JxM5CrMNi4w1g9I9Q8mgX
         NdfJSj5LVRXoQEAUt910OX0aclVtiDiw1ziWlmI9HzIJYPvWEAwsuJ7iYQZ5OqWhHNUB
         3p7A==
X-Gm-Message-State: AOAM530MGe3EjwM2jfn2egpSImiGQ7dbZKsL50qYXk+ye74Fg5ijNtFx
        562MWWEeC1IFOPkrniIniP+8Mg==
X-Google-Smtp-Source: ABdhPJzF25cY4pSdzS61sqXxO/zBeDkhnV56fO5UhbvMZOHz8G4oGxVj19n7F7u1XHWZY1uCLCvFXQ==
X-Received: by 2002:a62:1516:0:b029:1b6:8e43:dad7 with SMTP id 22-20020a6215160000b02901b68e43dad7mr6916153pfv.64.1611105234641;
        Tue, 19 Jan 2021 17:13:54 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id g201sm307734pfb.81.2021.01.19.17.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 17:13:53 -0800 (PST)
Date:   Tue, 19 Jan 2021 17:13:47 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: Re: [PATCH] KVM: x86/pmu: Fix HW_REF_CPU_CYCLES event
 pseudo-encoding in intel_arch_events[]
Message-ID: <YAeDy66f13uLMrwU@google.com>
References: <20201230081916.63417-1-like.xu@linux.intel.com>
 <1ff5381c-3057-7ca2-6f62-bbdcefd8e427@linux.intel.com>
 <YAHRMK5SmrmMx8hg@google.com>
 <b3623ea4-b2a1-e825-68f9-d97a6e7a07f4@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3623ea4-b2a1-e825-68f9-d97a6e7a07f4@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021, Xu, Like wrote:
> On 2021/1/16 1:30, Sean Christopherson wrote:
> > On Fri, Jan 15, 2021, Like Xu wrote:
> > > > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> > > > index a886a47daebd..013e8d253dfa 100644
> > > > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > > > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > > > @@ -29,7 +29,7 @@ static struct kvm_event_hw_type_mapping intel_arch_events[] = {
> > > >    	[4] = { 0x2e, 0x41, PERF_COUNT_HW_CACHE_MISSES },
> > > >    	[5] = { 0xc4, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
> > > >    	[6] = { 0xc5, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
> > > > -	[7] = { 0x00, 0x30, PERF_COUNT_HW_REF_CPU_CYCLES },
> > > > +	[7] = { 0x00, 0x03, PERF_COUNT_HW_REF_CPU_CYCLES },
> > In a follow up patch, would it be sane/appropriate to define these magic numbers
> > in asm/perf_event.h and share them between intel_perfmon_event_map and
> > intel_arch_events?  Without this patch, it's not at all obvious that these are
> > intended to align with the Core (arch?) event definitions.
> 
> The asm/perf_event.h is x86 generic and svm has a amd_perfmon_event_map.

Ugh, duh.

> How about adding an interface similar to perf_get_x86_pmu_capability()
> so that we can use magic numbers directly from the host perf ?
> (it looks we may have a performance drop, compared to static array)

Alternatively, you could use the existing event_map() to generate
intel_arch_events[] during init.  That might be easier since, AFAICT, the array
indices have different meaning for KVM than for perf.

Honestly, unless there are going to be new arch events in the near-ish future,
it may not be worth the effort at this point.  Until now, the above table hadn't
changed in over five years.  I.e. don't put a bunch of effort into this unless
you want to :-)
