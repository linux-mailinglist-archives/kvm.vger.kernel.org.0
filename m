Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5032FBF71
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 19:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389029AbhASStw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 13:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392129AbhASSA2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 13:00:28 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2ABC0617BE
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 09:45:30 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id f11so22893578ljm.8
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 09:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rd3A8g1IdM0Da3ayDEEkpfl0IAd1dLONzNOBcV3ebWU=;
        b=HgxRSY1UqbS9/rhXLTNfxHXeBBzedejKfHX0k4UFydcfqonYyGAaZOkwTPWns4jkPQ
         esF/GfzCdXeprMZcR0ldlHasvbgdLzQUQKuoonWfyg/1PJiYiAQCs6nEFq4JCNR8UoZ6
         L6PyL622kWecWT47tVu+mk1cmbD2RTPlWjumHdsO+G0rhUhQvmeVflWNxLMaEi1TcrFh
         VEoIk82Z1RZibJHkxhJoWvXlijEayutV5Qeas5v5D4ueg87Fq9K4GiUyA/cnWqroNvz9
         QaepTABYH2v3/iunQHx1HEYEiJL77LViNqhc0EsnX8b1A80s0ELoGjKZWBLJngIbcwTJ
         w/cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rd3A8g1IdM0Da3ayDEEkpfl0IAd1dLONzNOBcV3ebWU=;
        b=EHaV72DPnB+K3+rKuqqs2ksBtqAa9DWqgNWAFp7tTaUzPitU5AgWZ0+5bHi37WG5/a
         gxcI57sBRld7uQWIEKkK9gJEfWZAQOX473CqT3C4agiHk/2TzTehRR+jocvV4+X36B2j
         jOQ8FZpl9qqjni8NK3vxIV+GrA0RNdpQjI766cDI25nFBDcAUlr2lUv4bbZwHo4iAdwr
         4zSmIS8hThZCOC1HQG8ur0q5gy1BZ1/0K2Mlsj0cZC8dM0JA7rcBVAFQvMxGlYPhGwKq
         mCVPq/xFMBxHMUmyDw35urI6pRfXAPKLJpdfWsgUcMpHXIAwfZm3NN8/rMyo0+R6FLu2
         iz0A==
X-Gm-Message-State: AOAM532EEnZ1UCZlOefWbX3rCoayj9ZyYmnk20hBBwid0v0pEPq8uNAq
        1gDVAwtQhWj+Fdv03WNS3WPUAvobl36g0V4D/0k1dA==
X-Google-Smtp-Source: ABdhPJyFFZcinaflCgiwdNd0xiMlKWjdDzL/Xpr4jPiXhnakZJ5AdohtfJ+lzfhFR9TjjIv+fAWjCZ2NgSAW2C3XYtE=
X-Received: by 2002:a05:651c:328:: with SMTP id b8mr2402570ljp.106.1611078328902;
 Tue, 19 Jan 2021 09:45:28 -0800 (PST)
MIME-Version: 1.0
References: <20210116023204.670834-1-vipinsh@google.com> <20210116023204.670834-3-vipinsh@google.com>
 <2a009bd9-fde5-4911-3525-e28379fe3be2@infradead.org>
In-Reply-To: <2a009bd9-fde5-4911-3525-e28379fe3be2@infradead.org>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 19 Jan 2021 09:45:12 -0800
Message-ID: <CAHVum0e8qY7Nt23wSXU7KON8qZ5c6gnNWf=i5BeYji2+735COw@mail.gmail.com>
Subject: Re: [Patch v5 2/2] cgroup: svm: Encryption IDs cgroup documentation.
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh <brijesh.singh@amd.com>, Jon <jon.grimm@amd.com>,
        Eric <eric.vantassell@amd.com>, pbonzini@redhat.com,
        Sean Christopherson <seanjc@google.com>,
        Tejun Heo <tj@kernel.org>, hannes@cmpxchg.org,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, corbet@lwn.net,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        Jim Mattson <jmattson@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        Matt Gingell <gingell@google.com>,
        David Rientjes <rientjes@google.com>,
        Dionna Glaze <dionnaglaze@google.com>, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021 at 9:55 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 1/15/21 6:32 PM, Vipin Sharma wrote:
> > Documentation of Encryption IDs controller. This new controller is used
> > to track and limit usage of hardware memory encryption capabilities on
> > the CPUs.
> >
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > Reviewed-by: David Rientjes <rientjes@google.com>
> > Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
> > ---
> >  .../admin-guide/cgroup-v1/encryption_ids.rst  |  1 +
> >  Documentation/admin-guide/cgroup-v2.rst       | 78 ++++++++++++++++++-
> >  2 files changed, 77 insertions(+), 2 deletions(-)
> >  create mode 100644 Documentation/admin-guide/cgroup-v1/encryption_ids.rst
> >
> > diff --git a/Documentation/admin-guide/cgroup-v1/encryption_ids.rst b/Documentation/admin-guide/cgroup-v1/encryption_ids.rst
> > new file mode 100644
> > index 000000000000..8e9e9311daeb
> > --- /dev/null
> > +++ b/Documentation/admin-guide/cgroup-v1/encryption_ids.rst
> > @@ -0,0 +1 @@
> > +/Documentation/admin-guide/cgroup-v2.rst
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > index 63521cd36ce5..72993571de2e 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -63,8 +63,11 @@ v1 is available under :ref:`Documentation/admin-guide/cgroup-v1/index.rst <cgrou
> >         5-7-1. RDMA Interface Files
> >       5-8. HugeTLB
> >         5.8-1. HugeTLB Interface Files
> > -     5-8. Misc
> > -       5-8-1. perf_event
> > +     5-9. Encryption IDs
> > +       5.9-1 Encryption IDs Interface Files
> > +       5.9-2 Migration and Ownership
> > +     5-10. Misc
> > +       5-10-1. perf_event
> >       5-N. Non-normative information
> >         5-N-1. CPU controller root cgroup process behaviour
> >         5-N-2. IO controller root cgroup process behaviour
> > @@ -2160,6 +2163,77 @@ HugeTLB Interface Files
> >       are local to the cgroup i.e. not hierarchical. The file modified event
> >       generated on this file reflects only the local events.
> >
> > +Encryption IDs
> > +--------------
> > +
> > +There are multiple hardware memory encryption capabilities provided by the
> > +hardware vendors, like Secure Encrypted Virtualization (SEV) and SEV Encrypted
> > +State (SEV-ES) from AMD.
> > +
> > +These features are being used in encrypting virtual machines (VMs) and user
> > +space programs. However, only a small number of keys/IDs can be used
> > +simultaneously.
> > +
> > +This limited availability of these IDs requires system admin to optimize
>
>                                                           admins
>
> > +allocation, control, and track the usage of the resources in the cloud
> > +infrastructure. This resource also needs to be protected from getting exhausted
> > +by some malicious program and causing starvation for other programs.
> > +
> > +Encryption IDs controller provides capability to register the resource for
>
>    The Encryption IDs controller provides the capability to register the resource for
>
> > +controlling and tracking through the cgroups.
>
>                             through cgroups.
>
> > +
> > +Encryption IDs Interface Files
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +
> > +Each encryption ID type have their own interface files,
>
>                            has its own
>
> > +encids.[ID TYPE].{max, current, stat}, where "ID TYPE" can be sev and
>
>                                                                      or
>
> > +sev-es.
> > +
> > +  encids.[ID TYPE].stat
> > +        A read-only flat-keyed single value file. This file exists only in the
> > +        root cgroup.
> > +
> > +        It shows the total number of encryption IDs available and currently in
> > +        use on the platform::
> > +          # cat encids.sev.stat
> > +          total 509
> > +          used 0
>
> This is described above as a single-value file...
>
> Is the max value a hardware limit or a software (flexible) limit?
>
>
> > +
> > +  encids.[ID TYPE].max
> > +        A read-write file which exists on the non-root cgroups. File is used to
> > +        set maximum count of "[ID TYPE]" which can be used in the cgroup.
> > +
> > +        Limit can be set to max by::
> > +          # echo max > encids.sev.max
> > +
> > +        Limit can be set by::
> > +          # echo 100 > encids.sev.max
> > +
> > +        This file shows the max limit of the encryption ID in the cgroup::
> > +          # cat encids.sev.max
> > +          max
> > +
> > +        OR::
> > +          # cat encids.sev.max
> > +          100
> > +
> > +        Limits can be set more than the "total" capacity value in the
> > +        encids.[ID TYPE].stat file, however, the controller ensures
> > +        that the usage never exceeds the "total" and the max limit.
> > +
> > +  encids.[ID TYPE].current
> > +        A read-only single value file which exists on non-root cgroups.
> > +
> > +        Shows the total number of encrypted IDs being used in the cgroup.
> > +
> > +Migration and Ownership
> > +~~~~~~~~~~~~~~~~~~~~~~~
> > +
> > +An encryption ID is charged to the cgroup in which it is used first, and
> > +stays charged to that cgroup until that ID is freed. Migrating a process
> > +to a different cgroup do not move the charge to the destination cgroup
>
>                          does
>
> > +where the process has moved.
> > +
> >  Misc
> >  ----
> >
> >
>
>
> --
> ~Randy
> You can't do anything without having to do something else first.
> -- Belefant's Law

Thank you, I will fix them in the next patch.
