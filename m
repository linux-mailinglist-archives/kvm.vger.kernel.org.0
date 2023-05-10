Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651E16FE4FC
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 22:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbjEJUYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 16:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjEJUYI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 16:24:08 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD1B1FDF
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 13:24:06 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9659443fb56so1201046566b.2
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 13:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683750245; x=1686342245;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e9tsDGYXv+bEoxWcAObPjFgV7/FfCrcTsVECGRiJ1t0=;
        b=AL2r2UGoudGyCqFXk6I5lQAfnNT7p0RV0gE0GRm9cnCWHsR+/38A9Lv7Gu9Vw5DRER
         Zh27WSmnEr8cs09vPvgOfkVdmHn7DdaxvYYaFaxFNW20enEEZvGvUhrRFuH7pdUwknih
         PW0HZdgZziZjPCCkUb5Gm6maFS1Qd3pqCosq9D/P5jjUKzRuHi+tLM7GwCL5Hro7GF9Y
         R7Ib5ie69pVs+fNwCIrJBK0mJAM8iAfNWt1C0twqR/jJMU5sLiRaUl3qwEtXNRf6behR
         WhVHf7Pwyp3LS+II30xWKZs5ZDAW7iMyjdf2ZB9SI5Y+rgh9SPDn3DlIvqvrcRDMhinK
         QEvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683750245; x=1686342245;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e9tsDGYXv+bEoxWcAObPjFgV7/FfCrcTsVECGRiJ1t0=;
        b=e9LH3RMrUf6kQSC7DZUYILeqe/qBx297/v4Nd4KKcGZgzIfGTi0O1bAprZsgEbFl9e
         c2gar4kTYHm93H+8xvNf7al/pNb4xbyHrdrsVHRG9/BVvNh57gbE5n+rq/i0SEKGzklJ
         tKylCde8GzwQX659D4VJdhmMue0T88q9z0taeoBuhm9Z1YylYyaup1FE0t6XZsQL7Qj1
         5P6Zos4mAYWZZTnaE227a6awpxBgOun64YXMvttYyMe6zVRcjjwgUXe3FFZCEhDPMT7C
         dS64OozWNtLAaR24WWtMFQJHSS2kG5mJd5cLcQbZDshmknzyWQA+GkJ8Vt1vxvmWoufB
         L4Xg==
X-Gm-Message-State: AC+VfDy3dUk5Ah7usD2ipV4C1mEP0OgXZ3ut7nrviHwOAnEBldm+ui9w
        kxv/cLsIGgmc/5dVT5R891BtEqLRz25WnHdPx01W+w==
X-Google-Smtp-Source: ACHHUZ5W0ZwEAWGEeIx+PgUo5yUgC9JzyXmdtX2yCRiaP5fyrb23haIMEGI1FbsZeyTbWNWF3iC0JIvucvZS/Xtl7TE=
X-Received: by 2002:a17:907:a40d:b0:969:83c7:7357 with SMTP id
 sg13-20020a170907a40d00b0096983c77357mr9344482ejc.6.1683750244850; Wed, 10
 May 2023 13:24:04 -0700 (PDT)
MIME-Version: 1.0
References: <20221202061347.1070246-1-chao.p.peng@linux.intel.com>
 <ZD1oevE8iHsi66T2@google.com> <658018f9-581c-7786-795a-85227c712be0@redhat.com>
 <ZD12htq6dWg0tg2e@google.com> <1ed06a62-05a1-ebe6-7ac4-5b35ba272d13@redhat.com>
 <ZD2bBB00eKP6F8kz@google.com> <9efef45f-e9f4-18d1-0120-f0fc0961761c@redhat.com>
 <ZD86E23gyzF6Q7AF@google.com> <5869f50f-0858-ab0c-9049-4345abcf5641@redhat.com>
 <ZEM5Zq8oo+xnApW9@google.com> <CAGtprH_+bF4VZg2ps6CM8vjJVvShsvSGAvaLfTedts4cKqhSUw@mail.gmail.com>
In-Reply-To: <CAGtprH_+bF4VZg2ps6CM8vjJVvShsvSGAvaLfTedts4cKqhSUw@mail.gmail.com>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Wed, 10 May 2023 13:23:53 -0700
Message-ID: <CAGtprH9PG8p2Mq0_pjmQKkF+zKkvGXxi+bffmHY=EbfbtvNjkQ@mail.gmail.com>
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        dhildenb@redhat.com, Quentin Perret <qperret@google.com>,
        tabba@google.com, Michael Roth <michael.roth@amd.com>,
        wei.w.wang@intel.com, Mike Rapoport <rppt@kernel.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Wed, May 10, 2023 at 10:26=E2=80=AFAM Vishal Annapurve <vannapurve@googl=
e.com> wrote:
>
> On Fri, Apr 21, 2023 at 6:33=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > ...
> > cold.  I poked around a bit to see how we could avoid reinventing all o=
f that
> > infrastructure for fd-only memory, and the best idea I could come up wi=
th is
> > basically a rehash of Kirill's very original "KVM protected memory" RFC=
[3], i.e.
> > allow "mapping" fd-only memory, but ensure that memory is never actuall=
y present
> > from hardware's perspective.
> >
>
> I am most likely missing a lot of context here and possibly venturing
> into an infeasible/already shot down direction here. But I would still
> like to get this discussed here before we move on.
>
> I am wondering if it would make sense to implement
> restricted_mem/guest_mem file to expose both private and shared memory
> regions, inline with Kirill's original proposal now that the file
> implementation is controlled by KVM.
>
> Thinking from userspace perspective:
> 1) Userspace creates guest mem files and is able to mmap them but all
> accesses to these files result into faults as no memory is allowed to
> be mapped into userspace VMM pagetables.
> 2) Userspace registers mmaped HVA ranges with KVM with additional
> KVM_MEM_PRIVATE flag
> 3) Userspace converts memory attributes and this memory conversion
> allows userspace to access shared ranges of the file because those are
> allowed to be faulted in from guest_mem. Shared to private conversion
> unmaps the file ranges from userspace VMM pagetables.
> 4) Granularity of userspace pagetable mappings for shared ranges will
> have to be dictated by KVM guest_mem file implementation.
>
> Caveat here is that once private pages are mapped into userspace view.
>
> Benefits here:
> 1) Userspace view remains consistent while still being able to use HVA ra=
nges
> 2) It would be possible to use HVA based APIs from userspace to do
> things like binding.
> 3) Double allocation wouldn't be a concern since hva ranges and gpa
> ranges possibly map to the same HPA ranges.
>

I realize now that VFIO IOMMU mappings are not associated with
userspace MMU in any way. So this approach does leave the gap of not
being able to handle modifications of IOMMU mappings when HVA mappings
are modified in userspace page tables. I guess this could be a good
enough reason to give up on this option.


> >
> > Code is available here if folks want to take a look before any kind of =
formal
> > posting:
> >
> >         https://github.com/sean-jc/linux.git x86/kvm_gmem_solo
> >
> > [1] https://lore.kernel.org/all/ff5c5b97-acdf-9745-ebe5-c6609dd6322e@go=
ogle.com
> > [2] https://lore.kernel.org/all/20230418-anfallen-irdisch-6993a61be10b@=
brauner
> > [3] https://lore.kernel.org/linux-mm/20200522125214.31348-1-kirill.shut=
emov@linux.intel.com
