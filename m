Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E714C6CC85F
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 18:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjC1QsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 12:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbjC1QsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 12:48:17 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1604D61A8
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 09:48:16 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id i7so15945667ybt.0
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 09:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680022095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hqjMvaLDfnVK/y/k0tCfZPzOD0WMWLp677CWGc7a374=;
        b=XjAzXOf+OAujAkz7gfYD9bViHIA/QbQ9fEmMRBGih1etPRYe3XSRXx8jsEfsHq+Cc8
         Lo6WN0cMuzrd7f03oONWR+iWbra8k2QOSOM8gtzuBzmpo8LSH38sCgqN99bCpd2OL9kd
         Sfur1RxCgss2GoIXOY2oiiZVVk+jrkzn55G7fHYBFycKcekFx+FXzsti9M2u1anHE04N
         6SuCO8jfie1AJRT+iz8A1GQ6mInDoVJOCrYDx4crSxbwnGbd8hUXxdGMOA3pfKxkytC/
         +4GwwvNB9LQNo6IpTf5gWxgGsvjLoxPBDyHQrdmAWEywIRt23Ug1TI8MDvyoOwEJPz29
         wb1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680022095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hqjMvaLDfnVK/y/k0tCfZPzOD0WMWLp677CWGc7a374=;
        b=2gi2MrErV2enZrr2R1nYfS1vUvU/LHgYPdEv5CHUTwlPH/1zJYoWZhPmSeEOndv/02
         aI5WkmSGlRMTIgQA6Y0IRcqC8Q7phlqmYog8fuPm4MkhiGTX2Or0i/wyVTJSs6lPSfSY
         EQuJPLE0f77g1GgOQFpoGMxGfRbfUQxNenY58UjLsix5JjA76G3tHcaqc7DAkH8aa7Sr
         rFGNqrcXEcU1tia1sHYTDfL+5SdbiA/UGLjNrPDmDXLaSQJz8bQNp4smzBZasrn/hSF2
         8n10KZFKjiDkTLGU11OJghC70z9SHroqGXx9kWiWLcZSaLqnFqAcKt00cBUXXw6Am3SX
         MEJA==
X-Gm-Message-State: AAQBX9cp5b0S6wHRoiCMiQ8pttc6+G84B/8qb45Yi8FK8f8MKOq/OD8+
        Y3MX5TqacKSAHDxyGZ/94PWf2AFSEmyypYlxPdGE6Q==
X-Google-Smtp-Source: AKy350bjSmjCodaksLx+hSuUtpW5oB+G2DqmMThD/W+KhVBLprn2VUun8xaj/BSYCiPWYx2j+YNCZlePSB5YhiMnkj0=
X-Received: by 2002:a05:6902:102b:b0:b6c:48c3:3c1c with SMTP id
 x11-20020a056902102b00b00b6c48c33c1cmr10837614ybt.13.1680022094777; Tue, 28
 Mar 2023 09:48:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com> <20230306224127.1689967-12-vipinsh@google.com>
 <ZBzL1Awe7S00dPUP@google.com>
In-Reply-To: <ZBzL1Awe7S00dPUP@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 28 Mar 2023 09:47:38 -0700
Message-ID: <CAHVum0c7pLnYYHhzPPQSbSb1NoeW9hBbidd9i8fHSEazPaSJbA@mail.gmail.com>
Subject: Re: [Patch v4 11/18] KVM: x86/mmu: Add documentation of NUMA aware
 page table capability
To:     David Matlack <dmatlack@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23, 2023 at 2:59=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Mon, Mar 06, 2023 at 02:41:20PM -0800, Vipin Sharma wrote:
> > Add documentation for KVM_CAP_NUMA_AWARE_PAGE_TABLE capability and
> > explain why it is needed.
> >
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst | 29 +++++++++++++++++++++++++++++
> >  1 file changed, 29 insertions(+)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/ap=
i.rst
> > index 62de0768d6aa..7e3a1299ca8e 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -7669,6 +7669,35 @@ This capability is aimed to mitigate the threat =
that malicious VMs can
> >  cause CPU stuck (due to event windows don't open up) and make the CPU
> >  unavailable to host or other VMs.
> >
> > +7.34 KVM_CAP_NUMA_AWARE_PAGE_TABLE
> > +------------------------------
> > +
> > +:Architectures: x86
> > +:Target: VM
> > +:Returns: 0 on success, -EINVAL if vCPUs are already created.
> > +
> > +This capability allows userspace to enable NUMA aware page tables allo=
cations.
>
> Call out that this capability overrides task mempolicies. e.g.
>
>   This capability causes KVM to use a custom NUMA memory policy when
>   allocating page tables. Specifically, KVM will attempt to co-locate
>   page tables pages with the memory that they map, rather than following
>   the mempolicy of the current task.
>
> > +NUMA aware page tables are disabled by default. Once enabled, prior to=
 vCPU
> > +creation, any page table allocated during the life of a VM will be all=
ocated
>
> The "prior to vCPU creation" part here is confusing because it sounds
> like you're talking about any page tables allocated before vCPU
> creation. Just delete that part and put it in a separate paragraph.
>
>  KVM_CAP_NUMA_AWARE_PAGE_TABLE must be enabled before any vCPU is
>  created, otherwise KVM will return -EINVAL.
>
> > +preferably from the NUMA node of the leaf page.
> > +
> > +Without this capability, default feature is to use current thread memp=
olicy and
>
> s/default feature is to/KVM will/
>
> > +allocate page table based on that.
>
> s/and allocate page table based on that./to allocate page tables./
>
> > +
> > +This capability is useful to improve page accesses by a guest. For exa=
mple, an
>
> nit: Be more specific about how.
>
>  This capability aims to minimize the cost of TLB misses when a vCPU is
>  accessing NUMA-local memory, by reducing the number of remote memory
>  accesses needed to walk KVM's page tables.
>
> > +initialization thread which access lots of remote memory and ends up c=
reating
> > +page tables on local NUMA node, or some service thread allocates memor=
y on
> > +remote NUMA nodes and later worker/background threads accessing that m=
emory
> > +will end up accessing remote NUMA node page tables.
>
> It's not clear if these examples are talking about what happens when
> KVM_CAP_NUMA_AWARE_PAGE_TABLE is enabled or disabled.
>
> Also it's important to distinguish virtual NUMA nodes from physical NUMA
> nodes and where these "threads" are running. How about this:
>
>  For example, when KVM_CAP_NUMA_AWARE_PAGE_TABLE is disabled and a vCPU
>  accesses memory on a remote NUMA node and triggers a KVM page fault,
>  KVM will allocate page tables to handle that fault on the node where
>  the vCPU is running rather than the node where the memory is allocated.
>  When KVM_CAP_NUMA_AWARE_PAGE_TABLE is enabled, KVM will allocate the
>  page tables on the node where the memory is located.
>
>  This is intended to be used in VM configurations that properly
>  virtualize NUMA. i.e. VMs with one or more virtual NUMA nodes, each of
>  which is mapped to a physical NUMA node. With this capability enabled
>  on such VMs, any guest memory access to virtually-local memory will be
>  translated through mostly[*] physically-local page tables, regardless
>  of how the memory was faulted in.
>
>  [*] KVM will fallback to allocating from remote NUMA nodes if the
>  preferred node is out of memory. Also, in VMs with 2 or more NUMA
>  nodes, higher level page tables will necessarily map memory across
>  multiple physical nodes.
>
> > So, a multi NUMA node
> > +guest, can with high confidence access local memory faster instead of =
going
> > +through remote page tables first.
> > +
> > +This capability is also helpful for host to reduce live migration impa=
ct when
> > +splitting huge pages during dirty log operations. If the thread splitt=
ing huge
> > +page is on remote NUMA node it will create page tables on remote node.=
 Even if
> > +guest is careful in making sure that it only access local memory they =
will end
> > +up accessing remote page tables.
>
> Please also cover the limitations of this feature:
>
>  - Impact on remote memory accesses (more expensive).
>  - How KVM handles NUMA node exhaustion.
>  - How high-level page tables can span multiple nodes.
>  - What KVM does if it can't determine the NUMA node of the pfn.
>  - What KVM does for faults on GPAs that aren't backed by a pfn.
>

Thanks for the suggestions, I will incorporate them in the next version.
