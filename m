Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2A74EF9A2
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 20:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348873AbiDASVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 14:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346323AbiDASVr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 14:21:47 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366C637BF3
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 11:19:58 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id b188so3579029oia.13
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 11:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eHLXFPB43a0gnppLqjUxW0rgYvQoLtqoNm9fHewh/ZM=;
        b=JiGgFIpd74uTRA6V+9qW7DaMC71MtGGaxOvC6WdOCd/bXamUfcNrHIEpUkeLU0scEN
         XB48Iw+VG++iNY8mBwVBtxeGMTHwZ4OUvnlFoPFrHGPANQ954d3T4nY7AutwdgmUbAi+
         miYUwUzNFg7q9RxqPFL1qg/xEYlAjSIklEZbEaiDO3aQL5Wjw3fB/5jqZSfSJL9hUuMV
         GUxB/tqFZr9JT1xu2UdkWHDAQQL1CjDhPYthTfPMwTJyEErQyq5p5aBaZlpjmEkPL5cD
         Ok9XdzuLFDkopRQIO610cL0s0AO2OM+p4ndPP0GAUKq+vzbEKDQPcISmmRwHX+z8vpgd
         dFpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eHLXFPB43a0gnppLqjUxW0rgYvQoLtqoNm9fHewh/ZM=;
        b=SBG9hM8EASCfexYmWzUHZo+e+xOfQQBfQluXJ8MHv0Dk16v4Q4me596joNlSgprdBa
         SQDsfs+1zj+PnBLEFdEiH83PetlCdLffX2Hvs1IWb/6ztud4x4+rQ0d2+uSLkxYIgO1N
         UDeYsm5vn6V4tMlP9K1NPiNM/gdXP0nz9fAO2s11N0Tp8XcmYy3phs8aPh9jx6vN5Ful
         D3PuRnCptGY+d93RreQ3irUl/g9M8acCMjm18QhebixGf7T9rE98fistvCQalggvS5ii
         qZMzftqifVeWLMi2xbSkOzYqcndyO53cMoQW5E0qcxJ8FdVzkGLrul/nix4GHSVPKgyR
         uIuQ==
X-Gm-Message-State: AOAM531+X2I+x+0mhW1pVNb47Pu2dMXv3QJnxhNoOS5mhj31RcqSlZoU
        KJ43Xh9JGDAwLHU79beyGfgNs2ZOCRxIPdE2FLFAvw==
X-Google-Smtp-Source: ABdhPJzAra3XYpsanxy7lbMV6Dj0vB4VTMrYWik4wdND29JmH+6sY2++wMQxn5qSA0fDTBGh8r6x4Okf4wizD5UDOKQ=
X-Received: by 2002:a05:6808:11cc:b0:2d9:a01a:488f with SMTP id
 p12-20020a05680811cc00b002d9a01a488fmr5381769oiv.218.1648837197341; Fri, 01
 Apr 2022 11:19:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220308043857.13652-1-nikunj@amd.com> <YkIh8zM7XfhsFN8L@google.com>
 <c4b33753-01d7-684e-23ac-1189bd217761@amd.com> <YkSz1R3YuFszcZrY@google.com>
 <5567f4ec-bbcf-4caf-16c1-3621b77a1779@amd.com> <CAMkAt6px4A0CyuZ8h7zKzTxQUrZMYEkDXbvZ=3v+kphRTRDjNA@mail.gmail.com>
 <YkX6aKymqZzD0bwb@google.com> <CAA03e5GXmo33OOyxb08L5Ztz1dP-OSsPzeo0HK73p9ShvnMmRg@mail.gmail.com>
 <Ykc+QapbAdpd41PK@google.com>
In-Reply-To: <Ykc+QapbAdpd41PK@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 1 Apr 2022 11:19:46 -0700
Message-ID: <CAA03e5GMgQ73W7fk3SnMMdVgEmVUV7RjZNMv9MyDcZ8Cr=nPgg@mail.gmail.com>
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

On Fri, Apr 1, 2022 at 11:02 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 01, 2022, Marc Orr wrote:
> > On Thu, Mar 31, 2022 at 12:01 PM Sean Christopherson <seanjc@google.com> wrote:
> > > Yep, that's a big reason why I view purging the existing SEV memory management as
> > > a long term goal.  The other being that userspace obviously needs to be updated to
> > > support UPM[*].   I suspect the only feasible way to enable this for SEV/SEV-ES
> > > would be to restrict it to new VM types that have a disclaimer regarding additional
> > > requirements.
> > >
> > > [*] I believe Peter coined the UPM acronym for "Unmapping guest Private Memory".  We've
> > >     been using it iternally for discussion and it rolls off the tongue a lot easier than
> > >     the full phrase, and is much more precise/descriptive than just "private fd".
> >
> > Can we really "purge the existing SEV memory management"? This seems
> > like a non-starter because it violates userspace API (i.e., the
> > ability for the userspace VMM to run a guest without
> > KVM_FEATURE_HC_MAP_GPA_RANGE). Or maybe I'm not quite following what
> > you mean by purge.
>
> I really do mean purge, but I also really do mean "long term", as in 5+ years
> (probably 10+ if I'm being realistic).
>
> Removing support is completely ok, as is changing the uABI, the rule is that we
> can't break userspace.  If all users are migrated to private-fd, e.g. by carrots
> and/or sticks such as putting the code into maintenance-only mode, then at some
> point in the future there will be no users left to break and we can drop the
> current code and make use of private-fd mandatory for SEV/SEV-ES guests.

Ah, it makes sense now. Thanks!

> > Assuming that UPM-based lazy pinning comes together via a new VM type
> > that only supports new images based on a minimum kernel version with
> > KVM_FEATURE_HC_MAP_GPA_RANGE, then I think this would like as follows:
> >
> > 1. Userspace VMM: Check SEV VM type. If type is legacy SEV type then
> > do upfront pinning. Else, skip up front pinning.
>
> Yep, if by legacy "SEV type" you mean "SEV/SEV-ES guest that isn't required to
> use MAP_GPA_RANGE", which I'm pretty sure you do based on #3.

Yeah, that's exactly what I meant.

> > 2. KVM: I'm not sure anything special needs to happen here. For the
> > legacy VM types, it can be configured to use legacy memslots,
> > presumably the same as non-CVMs will be configured. For the new VM
> > type, it should be configured to use UPM.
>
> Correct, for now, KVM does nothing different for SEV/SEV-ES guests.
>
> > 3. Control plane (thing creating VMs): Responsible for not allowing
> > legacy SEV images (i.e., images without KVM_FEATURE_HC_MAP_GPA_RANGE)
> > with the new SEV VM types that use UPM and have support for demand
> > pinning.
> >
> > Sean: Did I get this right?
>
> Yep.

Thank you for verifying.
