Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07366782C50
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 16:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbjHUOmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 10:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbjHUOmu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 10:42:50 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4000115
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 07:42:30 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bf703dd1c0so15796595ad.0
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 07:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692628950; x=1693233750;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AR0RjJtQ4jbaps5Qss/ICM2Xr4u5GSwen1y9lR5GJNU=;
        b=yZr9ifC1oJ3851c1QEBzwLDnbBmO/fLPz7OlYonWjqUikL6hAqH8u/LYwSD8ZKe6pD
         EqW2f1iAfsM+S4YDbQ9SnVzllVZLQhKAwMHHph9phX7p9FxSMETiOnNdDqTttvwruvd+
         6yydgITA/Xe6R8jV1gRLSidEuc5nqM6H3MOYNFqdPfxphcj9YF7ChMAUPgx49PFbv6yR
         I7WiVPfWxOUqFe+5oFocn0+nzPizZJzG0qoLaPo8JkphHjX4+g6bO3H9asXIt33o3ils
         1bvtaZVn7TViaPiJzMUBiS1JqPHWKejWT6CqSwVD3ah/WIKy5nZhnzS26Fvo6BqFNPvP
         Pocg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692628950; x=1693233750;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AR0RjJtQ4jbaps5Qss/ICM2Xr4u5GSwen1y9lR5GJNU=;
        b=Co2UALRBvMOjal29/mxEhYcUivpXhwVmMzJykirVyJz337yVFgycs82YfR/Vep7FRE
         1V9MSxjir0zlEjhp4XnVfxyzdJ0/JQzwXiGq3Vxibji6AgJT5fMr1tfBW0jXeWTrir3q
         3pQKKw+VdxWWwgbCMd57Mb4FPvHHuYn040Ws/fzx4o5dYyN9Gj9sGUjS4T4cu+sNOVid
         0hEh+T9dedzECNyonVlcQmUfMybhRgNr2lKoA+qbLb3t7ZkbV67LLnWvvtXx5jcG7ck5
         eAzKFBijK1iiG7qD4O7WkO1IfDOxR7JG848KNi+vh0IFHj6CGjo0/YROyr+EHkCCNFup
         LoSg==
X-Gm-Message-State: AOJu0YwTuPGw2XZldwdSm9+GVA7Nmi/r97gZRB2ttNS1tONDZ8K0/QQx
        mQHRYHjKbsPnJcIvUwfEOj6EtNJMGgs=
X-Google-Smtp-Source: AGHT+IEC+qozyNRvIPltiH3ul3i5rVi4vVuDAyC4VloCOa7LYkPDbctBI//9ISW5qNkoZ/M1zYnU/8iOFg0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:dace:b0:1bb:91c9:d334 with SMTP id
 q14-20020a170902dace00b001bb91c9d334mr3111000plx.0.1692628950096; Mon, 21 Aug
 2023 07:42:30 -0700 (PDT)
Date:   Mon, 21 Aug 2023 07:42:28 -0700
In-Reply-To: <CAL715WL9TJzDxZE8_gfhUQFGtOAydG0kyuSbzkqWTs3pc57j7A@mail.gmail.com>
Mime-Version: 1.0
References: <cover.1692119201.git.isaku.yamahata@intel.com>
 <b37fb13a9aeb8683d5fdd5351cdc5034639eb2bb.1692119201.git.isaku.yamahata@intel.com>
 <ZN+whX3/lSBcZKUj@google.com> <52c6a8a6-3a0a-83ba-173d-0833e16b64fd@amd.com>
 <ZN/0aefp2gw5wDXk@google.com> <CAL715WL9TJzDxZE8_gfhUQFGtOAydG0kyuSbzkqWTs3pc57j7A@mail.gmail.com>
Message-ID: <ZON31BHykA2JqquC@google.com>
Subject: Re: [PATCH 4/8] KVM: gmem: protect kvm_mmu_invalidate_end()
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Jacky Li <jackyli@google.com>, Ashish Kalra <ashish.kalra@amd.com>,
        isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 18, 2023, Mingwei Zhang wrote:
> +Jacky Li
>=20
> On Fri, Aug 18, 2023 at 3:45=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > > On a separate note here, the SEV hook blasting WBINVD is still causin=
g
> > > serious performance degradation issues with SNP triggered via
> > > AutoNUMA/numad/KSM, etc. With reference to previous discussions relat=
ed to
> > > it, we have plans to replace WBINVD with CLFLUSHOPT.
> >
> > Isn't the flush unnecessary when freeing shared memory?  My recollectio=
n is that
> > the problematic scenario is when encrypted memory is freed back to the =
host,
> > because KVM already flushes when potentially encrypted mapping memory i=
nto the
> > guest.
> >
> > With SNP+guest_memfd, private/encrypted memory should be unreachabled v=
ia the
> > hva-based mmu_notifiers.  gmem should have full control of the page lif=
ecycles,
> > i.e. can get the kernel virtual address as appropriated, and so it SNP =
shouldn't
> > need the nuclear option.
> >
> > E.g. something like this?
> >
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 07756b7348ae..1c6828ae391d 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -2328,7 +2328,7 @@ static void sev_flush_encrypted_page(struct kvm_v=
cpu *vcpu, void *va)
> >
> >  void sev_guest_memory_reclaimed(struct kvm *kvm)
> >  {
> > -       if (!sev_guest(kvm))
> > +       if (!sev_guest(kvm) || sev_snp_guest(kvm))
> >                 return;
> >
> >         wbinvd_on_all_cpus();
>=20
> I hope this is the final solution :)
>=20
> So, short answer: no.
>=20
> SNP+guest_memfd prevent untrusted host user space from directly
> modifying the data, this is good enough for CVE-2022-0171, but there
> is no such guarantee that the host kernel in some scenarios could
> access the data and generate dirty caches. In fact, AFAIC, SNP VM does
> not track whether each page is previously shared, isn't it? If a page
> was previously shared and was written by the host kernel or devices
> before it was changed to private. No one tracks it and dirty caches
> are there!

There's an unstated assumption that KVM will do CLFLUSHOPT (if necessary) f=
or
SEV-* guests when allocating into guest_memfd().

> So, to avoid any corner case situations like the above, it seems
> currently we have to retain the property: flushing the cache when the
> guest memory mapping leaves KVM NPT.

What I'm saying is that for guests whose private memory is backed by guest_=
memfd(),
which is all SNP guests, it should be impossible for memory that is reachab=
le via
mmu_notifiers to be mapped in KVM's MMU as private.  So yes, KVM needs to f=
lush
when memory is freed from guest_memfd(), but not for memory that is reclaim=
ed by
mmu_notifiers, i.e. not for sev_guest_memory_reclaimed().
