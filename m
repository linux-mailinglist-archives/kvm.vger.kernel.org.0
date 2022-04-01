Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1F04EF8F2
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 19:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349527AbiDARbC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 13:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348986AbiDARbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 13:31:00 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCF3139AD0
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 10:29:10 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-df22f50e0cso3443691fac.3
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 10:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WraNq3noA/oHiDCjdg83h3Em4sODbXuxqxGa7fOH8ng=;
        b=EsSECRyZjkVgBr1ClmR85DHg4N2nM7LFSOrbUSP+8C949qfg6GkveD5ES9E3SShZyZ
         l4IPUKyvTHVumFZ9Dx8c2Luhu6rpCOrogAIXZ802DTlPka7u7JKOfjUljz/BAuPdRO0x
         4Dx+gUlLKfDXSx2xVax3IkWYAy5V/cGSFOTK4dF1U80HifkUuGn0HWjfamK0JDGcBWM3
         Ba1L3XJpeR0xUZp61b3NslEhzWr+Y+33udJpb8HxjqcIjm2FNp8DihAabvqyCvze7b1N
         DusTQPre2DAIwUnKPYtCOWP0BS5ej/2M4GLYLKDgvgDq7cuq/+jceqBMy8B2vNCI5Tki
         IAVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WraNq3noA/oHiDCjdg83h3Em4sODbXuxqxGa7fOH8ng=;
        b=C2aH+2ThfbMo1/xk/FpCpgPuWfmx7d0yDLby/f2Zo8mBmtYSX05NMOI145ZKtOOURO
         jvXo7kpp28hAW5cRxOcsurX1gJ0J+T+c6SopKxXMY1K1+qYNqB/hN60+jsucs+DUr0F0
         DkMS63nDAhWn8Wg2mOfV8txQ6xXZsIcgTt67APp3PN1feSzT+2c9wjlhz9qArxsuXOyR
         8Yv0J0/Z9aNEKm1qR2Dq7XplrxfNq292Z8yd88LgklKgb+XvcAuY6Uhp+tYv3GQH8niS
         thIycbVvW7mE9VKxuI5AxFDkClj8ZEsG7Cs/BPlXrAYjTY6CTnA7s+vNpOBWpt3SgdKl
         PVbA==
X-Gm-Message-State: AOAM532RoAdJdSzvJQakKfb1vr/8HgowG0D2Sx1qJdqTIg0Z1rVJpfpR
        VSznjmzyKylUunVREZOQsXIXkOXNM/ROuJP/WeKYjQ==
X-Google-Smtp-Source: ABdhPJznFK2GQmOfuSdixOKziz2XOo/OGu52BVauEjLHcwnKrfyjITdvyw8UBW3cpa+rXmCw1sWOkZtnIbQUQLaG8SE=
X-Received: by 2002:a05:6870:40cc:b0:de:15e7:4df0 with SMTP id
 l12-20020a05687040cc00b000de15e74df0mr5635386oal.110.1648834149772; Fri, 01
 Apr 2022 10:29:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220308043857.13652-1-nikunj@amd.com> <YkIh8zM7XfhsFN8L@google.com>
 <c4b33753-01d7-684e-23ac-1189bd217761@amd.com> <YkSz1R3YuFszcZrY@google.com>
 <5567f4ec-bbcf-4caf-16c1-3621b77a1779@amd.com> <CAMkAt6px4A0CyuZ8h7zKzTxQUrZMYEkDXbvZ=3v+kphRTRDjNA@mail.gmail.com>
 <YkX6aKymqZzD0bwb@google.com>
In-Reply-To: <YkX6aKymqZzD0bwb@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 1 Apr 2022 10:28:58 -0700
Message-ID: <CAA03e5GXmo33OOyxb08L5Ztz1dP-OSsPzeo0HK73p9ShvnMmRg@mail.gmail.com>
Subject: Re: [PATCH RFC v1 0/9] KVM: SVM: Defer page pinning for SEV guests
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Gonda <pgonda@google.com>,
        "Nikunj A. Dadhania" <nikunj@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Bharata B Rao <bharata@amd.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Mingwei Zhang <mizhang@google.com>,
        David Hildenbrand <david@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Mar 31, 2022 at 12:01 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Mar 31, 2022, Peter Gonda wrote:
> > On Wed, Mar 30, 2022 at 10:48 PM Nikunj A. Dadhania <nikunj@amd.com> wrote:
> > > On 3/31/2022 1:17 AM, Sean Christopherson wrote:
> > > > On Wed, Mar 30, 2022, Nikunj A. Dadhania wrote:
> > > >> On 3/29/2022 2:30 AM, Sean Christopherson wrote:
> > > >>> Let me preface this by saying I generally like the idea and especially the
> > > >>> performance, but...
> > > >>>
> > > >>> I think we should abandon this approach in favor of committing all our resources
> > > >>> to fd-based private memory[*], which (if done right) will provide on-demand pinning
> > > >>> for "free".
> > > >>
> > > >> I will give this a try for SEV, was on my todo list.
> > > >>
> > > >>> I would much rather get that support merged sooner than later, and use
> > > >>> it as a carrot for legacy SEV to get users to move over to its new APIs, with a long
> > > >>> term goal of deprecating and disallowing SEV/SEV-ES guests without fd-based private
> > > >>> memory.
> > > >>
> > > >>> That would require guest kernel support to communicate private vs. shared,
> > > >>
> > > >> Could you explain this in more detail? This is required for punching hole for shared pages?
> > > >
> > > > Unlike SEV-SNP, which enumerates private vs. shared in the error code, SEV and SEV-ES
> > > > don't provide private vs. shared information to the host (KVM) on page fault.  And
> > > > it's even more fundamental then that, as SEV/SEV-ES won't even fault if the guest
> > > > accesses the "wrong" GPA variant, they'll silent consume/corrupt data.
> > > >
> > > > That means KVM can't support implicit conversions for SEV/SEV-ES, and so an explicit
> > > > hypercall is mandatory.  SEV doesn't even have a vendor-agnostic guest/host paravirt
> > > > ABI, and IIRC SEV-ES doesn't provide a conversion/map hypercall in the GHCB spec, so
> > > > running a SEV/SEV-ES guest under UPM would require the guest firmware+kernel to be
> > > > properly enlightened beyond what is required architecturally.
> > > >
> > >
> > > So with guest supporting KVM_FEATURE_HC_MAP_GPA_RANGE and host (KVM) supporting
> > > KVM_HC_MAP_GPA_RANGE hypercall, SEV/SEV-ES guest should communicate private/shared
> > > pages to the hypervisor, this information can be used to mark page shared/private.
> >
> > One concern here may be that the VMM doesn't know which guests have
> > KVM_FEATURE_HC_MAP_GPA_RANGE support and which don't. Only once the
> > guest boots does the guest tell KVM that it supports
> > KVM_FEATURE_HC_MAP_GPA_RANGE. If the guest doesn't we need to pin all
> > the memory before we run the guest to be safe to be safe.
>
> Yep, that's a big reason why I view purging the existing SEV memory management as
> a long term goal.  The other being that userspace obviously needs to be updated to
> support UPM[*].   I suspect the only feasible way to enable this for SEV/SEV-ES
> would be to restrict it to new VM types that have a disclaimer regarding additional
> requirements.
>
> [*] I believe Peter coined the UPM acronym for "Unmapping guest Private Memory".  We've
>     been using it iternally for discussion and it rolls off the tongue a lot easier than
>     the full phrase, and is much more precise/descriptive than just "private fd".

Can we really "purge the existing SEV memory management"? This seems
like a non-starter because it violates userspace API (i.e., the
ability for the userspace VMM to run a guest without
KVM_FEATURE_HC_MAP_GPA_RANGE). Or maybe I'm not quite following what
you mean by purge.

Assuming that UPM-based lazy pinning comes together via a new VM type
that only supports new images based on a minimum kernel version with
KVM_FEATURE_HC_MAP_GPA_RANGE, then I think this would like as follows:

1. Userspace VMM: Check SEV VM type. If type is legacy SEV type then
do upfront pinning. Else, skip up front pinning.
2. KVM: I'm not sure anything special needs to happen here. For the
legacy VM types, it can be configured to use legacy memslots,
presumably the same as non-CVMs will be configured. For the new VM
type, it should be configured to use UPM.
3. Control plane (thing creating VMs): Responsible for not allowing
legacy SEV images (i.e., images without KVM_FEATURE_HC_MAP_GPA_RANGE)
with the new SEV VM types that use UPM and have support for demand
pinning.

Sean: Did I get this right?
