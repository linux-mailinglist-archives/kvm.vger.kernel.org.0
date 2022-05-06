Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE20F51CDCC
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 02:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238580AbiEFA0H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 20:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233532AbiEFA0F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 20:26:05 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649CB5DA28
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 17:22:23 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id cq17-20020a17090af99100b001dc0386cd8fso5503692pjb.5
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 17:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=78OPiVHfntqnRbOd9M747x82Ue0+DetsVmv4PON/95U=;
        b=zJdwUWEKBW78+NuXYF8y2nHSAnxLX7jPQLzHUIBL62jwfbrHF2xs++JGrtckXkxFxq
         CJpHUuISe2baxKxRRGseBtXIFiyaoOEcFw4ysBcufDVCzA0qIpc4FP402/7ZM1P6C/F4
         FjW0a4MBBcMW+VHiOKTNiV0JJq1WM1W61iUN44khJ0lhOpjkrZqGsDyrwvvb6p7mUVej
         m9EUnxwXxiolGp1TCpG5nQOsIbJ6FDmCQaQSurQIiT0OklR9qNFBZAk5GsqfAldv0t18
         2npuS5ccFS8a9tpRxlFaHL1+sG51E1eqMiCxUmpbemsdu8nt60IreiC4ibwblN2uxV03
         2j2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=78OPiVHfntqnRbOd9M747x82Ue0+DetsVmv4PON/95U=;
        b=RHWdFWqpbtIyqT9ZWAXeXNTQtNCyIHn8FYcMSg/Z4qnWcTiZd/D3b1gTEHhkDb+3oK
         5jSAdraF4nA6Ma5FXCd61m4ei1Uur8lP+4J7v/sVUKe+bEtB431M200kuYjol+fcRjQ8
         HrawlWXieCpO4BhNDX40vEpP75v2iDZC+JSa/g4DY+HcUFuXSJplbCIlH+C9SoG2e+iF
         9qfiHx2oL/kta7wUT6aJUdLpZBvh2U8ik45w7MFgFgOkFTlJHM2BKLKJBKbVR3v3lXh2
         lI8T541UaZZAdelLnAkLkEbuzJUXLEawcHDC7PI8TqXcskQumCBPX66FHFCkJjJs27EJ
         dwjA==
X-Gm-Message-State: AOAM533SHDE/kw5QaNnuZ7e2lV7k8uyzNzTcVQh/KAiQpsclOdUpSMq7
        tbS/ctM3vPbl2wS5zSUqojS6IhQ1JmTzjDbMbPoSQQ==
X-Google-Smtp-Source: ABdhPJzBWf/u1VdZiZTqpaAg2wWuN6pCvL4w34AITMKGTy+mt7a3urZiP6LJJbodclCm4CAOQ2PNrJCnVEr/JJdj+3w=
X-Received: by 2002:a17:902:da8b:b0:15e:c0e8:d846 with SMTP id
 j11-20020a170902da8b00b0015ec0e8d846mr871765plx.34.1651796542871; Thu, 05 May
 2022 17:22:22 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1649219184.git.kai.huang@intel.com> <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
 <ecf718abf864bbb2366209f00d4315ada090aedc.camel@intel.com>
 <de24ac7e-349c-e49a-70bb-31b9bc867b10@intel.com> <9b388f54f13b34fe684ef77603fc878952e48f87.camel@intel.com>
 <d98ca73b-2d2d-757d-e937-acc83cfedfb0@intel.com> <c90a10763969077826f42be6f492e3a3e062326b.camel@intel.com>
 <fc1ca04d94ad45e79c0297719d5ef50a7c33c352.camel@intel.com>
 <664f8adeb56ba61774f3c845041f016c54e0f96e.camel@intel.com>
 <1b681365-ef98-ec78-96dc-04e28316cf0e@intel.com> <8bf596b45f68363134f431bcc550e16a9a231b80.camel@intel.com>
 <6bb89ca6e7346f4334f06ea293f29fd12df70fe4.camel@intel.com>
 <CAPcyv4iP3hcNNDxNdPT+iB0E4aUazfqFWwaa_dtHpVf+qKPNcQ@mail.gmail.com> <cbb2ea1343079aee546fb44cd59c82f66c875d76.camel@intel.com>
In-Reply-To: <cbb2ea1343079aee546fb44cd59c82f66c875d76.camel@intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 5 May 2022 17:22:11 -0700
Message-ID: <CAPcyv4jNYqPA2HBaO+9a+ije4jnb6a3Sx_1knrmRF9HCCXQuqg@mail.gmail.com>
Subject: Re: [PATCH v3 00/21] TDX host kernel support
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Mike Rapoport <rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 5, 2022 at 3:14 PM Kai Huang <kai.huang@intel.com> wrote:
>
> Thanks for feedback!
>
> On Thu, 2022-05-05 at 06:51 -0700, Dan Williams wrote:
> > [ add Mike ]
> >
> >
> > On Thu, May 5, 2022 at 2:54 AM Kai Huang <kai.huang@intel.com> wrote:
> > [..]
> > >
> > > Hi Dave,
> > >
> > > Sorry to ping (trying to close this).
> > >
> > > Given we don't need to consider kmem-hot-add legacy PMEM after TDX module
> > > initialization, I think for now it's totally fine to exclude legacy PMEMs from
> > > TDMRs.  The worst case is when someone tries to use them as TD guest backend
> > > directly, the TD will fail to create.  IMO it's acceptable, as it is supposedly
> > > that no one should just use some random backend to run TD.
> >
> > The platform will already do this, right?
> >
>
> In the current v3 implementation, we don't have any code to handle memory
> hotplug, therefore nothing prevents people from adding legacy PMEMs as system
> RAM using kmem driver.  In order to guarantee all pages managed by page

That's the fundamental question I am asking why is "guarantee all
pages managed by page allocator are TDX memory". That seems overkill
compared to indicating the incompatibility after the fact.

> allocator are all TDX memory, the v3 implementation needs to always include
> legacy PMEMs as TDX memory so that even people truly add  legacy PMEMs as system
> RAM, we can still guarantee all pages in page allocator are TDX memory.

Why?

> Of course, a side benefit of always including legacy PMEMs is people
> theoretically can use them directly as TD guest backend, but this is just a
> bonus but not something that we need to guarantee.
>
>
> > I don't understand why this
> > is trying to take proactive action versus documenting the error
> > conditions and steps someone needs to take to avoid unconvertible
> > memory. There is already the CONFIG_HMEM_REPORTING that describes
> > relative performance properties between initiators and targets, it
> > seems fitting to also add security properties between initiators and
> > targets so someone can enumerate the numa-mempolicy that avoids
> > unconvertible memory.
>
> I don't think there's anything related to performance properties here.  The only
> goal here is to make sure all pages in page allocator are TDX memory pages.

Please reconsider or re-clarify that goal.

>
> >
> > No, special casing in hotplug code paths needed.
> >
> > >
> > > I think w/o needing to include legacy PMEM, it's better to get all TDX memory
> > > blocks based on memblock, but not e820.  The pages managed by page allocator are
> > > from memblock anyway (w/o those from memory hotplug).
> > >
> > > And I also think it makes more sense to introduce 'tdx_memblock' and
> > > 'tdx_memory' data structures to gather all TDX memory blocks during boot when
> > > memblock is still alive.  When TDX module is initialized during runtime, TDMRs
> > > can be created based on the 'struct tdx_memory' which contains all TDX memory
> > > blocks we gathered based on memblock during boot.  This is also more flexible to
> > > support other TDX memory from other sources such as CLX memory in the future.
> > >
> > > Please let me know if you have any objection?  Thanks!
> >
> > It's already the case that x86 maintains sideband structures to
> > preserve memory after exiting the early memblock code.
> >
>
> May I ask what data structures are you referring to?

struct numa_meminfo.

> Btw, the purpose of 'tdx_memblock' and 'tdx_memory' is not only just to preserve
> memblock info during boot.  It is also used to provide a common data structure
> that the "constructing TDMRs" code can work on.  If you look at patch 11-14, the
> logic (create TDMRs, allocate PAMTs, sets up reserved areas) around how to
> construct TDMRs doesn't have hard dependency on e820.  If we construct TDMRs
> based on a common 'tdx_memory' like below:
>
>         int construct_tdmrs(struct tdx_memory *tmem, ...);
>
> It would be much easier to support other TDX memory resources in the future.

"in the future" is a prompt to ask "Why not wait until that future /
need arrives before adding new infrastructure?"

> The thing I am not sure is Dave wants to keep the code minimal (as this series
> is already very big in terms of LoC) to make TDX running, and for now in
> practice there's only system RAM during boot is TDX capable, so I am not sure we
> should introduce those structures now.
>
> > Mike, correct
> > me if I am wrong, but adding more is less desirable than just keeping
> > the memblock around?
