Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2C037323B
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 00:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbhEDWLM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 18:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbhEDWLM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 18:11:12 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C561AC06174A
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 15:10:15 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id p17so14419plf.12
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 15:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1aLXxHaj5Rq1Gy8Fen+iPQHGbUG29jIsimexipAVSW8=;
        b=FAcOMbmD+46OKFgqYORs2t18fQo8LRey2ieRuWIH6JxAgIUWEmUNoIa6xAot1j9nSr
         oCzB/3WcSa32AOBgQQDaaGO59Bq0qQHqkNVBjKVWRC0eFx4SodCgw0AGvEBkUYGgaVXK
         VZIh8jAitG5nKodsUh9MdzxhNi8BJ3QBad1hRddDtVAhqhXhT6rg+sEpfS/JZlWF5Qd9
         LVqVqNSAzV8Ip2KZ8zOO+PB/JievXM+0j6Zhtjvp64pUgQ2FHmVZLGTRp8wqka5fbXvb
         jvFVccAQjMZIoq4a7n77JcFdGHSh8NLu+EWubkYDkDbJIepAEAyPwxyhPq8A/XH12/jR
         nsfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1aLXxHaj5Rq1Gy8Fen+iPQHGbUG29jIsimexipAVSW8=;
        b=b8t4YZbD7WW19Lq+jH59OULqgDKMi6u1c/i0c9hxGnEjsISlHWjhKf5COn7xat1HKn
         rqz0tJmbIlI54n8LchEvMtnTeFAg9P2vgqzMqMvOwiK0ArMDjK0phFIF8b6ab9zonKHN
         696/xJYWvDgMJjxut7o0jrxjK6PkpGkS/3oBo+K50Go8PMG2kKiosMGRoc83AWeMDEm2
         4CW7f3xjaw3/DT0/tqstXkuDbWtCKcJnMgMUPunxcr8WVtoZ6vro16/O8975dQfWL8zT
         kXWzg3QNzjdTOyQABbOe/d20nfu1bT86DGZAnIvWtdfkSJOeJNhv8/xlt4jbo5+V433H
         Du1g==
X-Gm-Message-State: AOAM53373DgoVx9vzBz0/qtWoWYa90/kD2A2SrQQSshfC9Dh1TAa92vx
        qj8ZbvS1anZ1fr3tGOj8A5T+kg==
X-Google-Smtp-Source: ABdhPJwF1qhw48/+7vzyhb89hqtof1Kr7Sj9/41FiQ+OKc8PlVYJC/94C6mpLxAM35Ty1D2+UrhJhw==
X-Received: by 2002:a17:902:9697:b029:ee:c7db:deea with SMTP id n23-20020a1709029697b02900eec7dbdeeamr16969279plp.83.1620166214999;
        Tue, 04 May 2021 15:10:14 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id 128sm13064700pfy.194.2021.05.04.15.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 15:10:14 -0700 (PDT)
Date:   Tue, 4 May 2021 22:10:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 03/15] KVM: SVM: Inject #UD on RDTSCP when it should be
 disabled in the guest
Message-ID: <YJHGQgEE3mqUhbAc@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
 <20210504171734.1434054-4-seanjc@google.com>
 <CALMp9eSvXRJm-KxCGKOkgPO=4wJPBi5wDFLbCCX91UtvGJ1qBg@mail.gmail.com>
 <YJHCadSIQ/cK/RAw@google.com>
 <CALMp9eSeeuXUXz+0J17b7Dk8pyy3XPgqUXKC5-V8Q7SRd7ykgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eSeeuXUXz+0J17b7Dk8pyy3XPgqUXKC5-V8Q7SRd7ykgA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 04, 2021, Jim Mattson wrote:
> On Tue, May 4, 2021 at 2:53 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, May 04, 2021, Jim Mattson wrote:
> > > On Tue, May 4, 2021 at 10:17 AM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > Intercept RDTSCP to inject #UD if RDTSC is disabled in the guest.
> > > >
> > > > Note, SVM does not support intercepting RDPID.  Unlike VMX's
> > > > ENABLE_RDTSCP control, RDTSCP interception does not apply to RDPID.  This
> > > > is a benign virtualization hole as the host kernel (incorrectly) sets
> > > > MSR_TSC_AUX if RDTSCP is supported, and KVM loads the guest's MSR_TSC_AUX
> > > > into hardware if RDTSCP is supported in the host, i.e. KVM will not leak
> > > > the host's MSR_TSC_AUX to the guest.
> > > >
> > > > But, when the kernel bug is fixed, KVM will start leaking the host's
> > > > MSR_TSC_AUX if RDPID is supported in hardware, but RDTSCP isn't available
> > > > for whatever reason.  This leak will be remedied in a future commit.
> > > >
> > > > Fixes: 46896c73c1a4 ("KVM: svm: add support for RDTSCP")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > > ---
> > > ...
> > > > @@ -4007,8 +4017,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > > >         svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
> > > >                              guest_cpuid_has(vcpu, X86_FEATURE_NRIPS);
> > > >
> > > > -       /* Check again if INVPCID interception if required */
> > > > -       svm_check_invpcid(svm);
> > > > +       svm_recalc_instruction_intercepts(vcpu, svm);
> > >
> > > Does the right thing happen here if the vCPU is in guest mode when
> > > userspace decides to toggle the CPUID.80000001H:EDX.RDTSCP bit on or
> > > off?
> >
> > I hate our terminology.  By "guest mode", do you mean running the vCPU, or do
> > you specifically mean running in L2?
> 
> I mean is_guest_mode(vcpu) is true (i.e. running L2).

No, it will not do the right thing, whatever "right thing" even means in this
context.  That's a pre-existing issue, e.g. INVCPID handling is also wrong.
I highly doubt VMX does, or even can, do the right thing either.

I'm pretty sure I lobbied in the past to disallow KVM_SET_CPUID* if the vCPU is
in guest mode since it's impossible to do the right thing without forcing an
exit to L1, e.g. changing MAXPHYSADDR will allow running L2 with an illegal
CR3, ditto for various CR4 bits.
