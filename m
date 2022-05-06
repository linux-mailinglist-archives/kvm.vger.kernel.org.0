Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58B851CEC7
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 04:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387823AbiEFBTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 21:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387814AbiEFBTb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 21:19:31 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C7C47AE8
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 18:15:49 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id o69so5709287pjo.3
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 18:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BjYrUmm3gQyIDEnUysCtyi26iCeQZJHz2b8v2Ezb4IU=;
        b=znqizYiTQ8sUZIj4I4mqg2jBkSnSI7UXZ07MB/5isgB4i/PVxTQV/9UZpMuYdQE1//
         uFcZUMpoROkEDq+uCsgTmhJDYip5P2BwkL6X7/ZbNVfDpJJ2T8crnDzzAn6NweKvPlcM
         V0TrQcnvkkqHX2jRy0CWCRc/S77SI1i/5ALNnycThpzbEsiyHQwzakFhq+iamws7Paf+
         PruVdTTnCw8nmVwfmXZCkc1K3X0XcMiCW3Ot63aZpAn4YdVAnY8Z6t9vwMY/iaExVOv0
         kMn87QUGhqUPsKCp6lN559ANDnHz4XEkVGz3FIuj2rtiaG3DcGE6Wjwq77+M1i+jfaDB
         nfJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BjYrUmm3gQyIDEnUysCtyi26iCeQZJHz2b8v2Ezb4IU=;
        b=Ud9FeC1CTevBf98KuCCpFOIIInhPaXaQjUBXp1ocDqNneIkVq9fsZ+qhC5q0KsCnLt
         TrvM5vcSMUzRDPHmzT1jRj3WrOmj84SlJ7BavqHuammS6ozObXkOv4H9lYodugFw7ItJ
         42BDIpjbt/n6+DgAupetQ0AxSh25wPxsWnyjTdTb75rArY56lGTfItRrNo6zhLkPFqVw
         jNwPxQmUr1p14PdAhG8Tu61iHlojfg49QOi+e6Yd2IdZ9W27aK15ru9YGlC7DKbPQwP9
         i8m7MYFsvOOtIpOPwqweT+YLtnNMfxeJ4LJ3LZuUzoK9mDMm9oc/fpXOernVzfsaM6r0
         3Ybw==
X-Gm-Message-State: AOAM533jrZ9ywINzwy/iCsJwaMLG1i84mjisjbjxiqtBGZjVWOrnkinx
        aqfZ7NDmkx5RbcwRcLRXpxfkKTm2RXYqiCtGTlPZOw==
X-Google-Smtp-Source: ABdhPJzHTBOTmHf8WyAOEc2Vp3DxtmK+7dEWNxw45yMYh9y1AAqBkO6WJemntKuIs9mlJIgcrW2mII69LBzD/2EDiTE=
X-Received: by 2002:a17:902:ea57:b0:15a:6173:87dd with SMTP id
 r23-20020a170902ea5700b0015a617387ddmr933844plg.147.1651799749349; Thu, 05
 May 2022 18:15:49 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1649219184.git.kai.huang@intel.com> <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
 <ecf718abf864bbb2366209f00d4315ada090aedc.camel@intel.com>
 <de24ac7e-349c-e49a-70bb-31b9bc867b10@intel.com> <9b388f54f13b34fe684ef77603fc878952e48f87.camel@intel.com>
 <d98ca73b-2d2d-757d-e937-acc83cfedfb0@intel.com> <c90a10763969077826f42be6f492e3a3e062326b.camel@intel.com>
 <fc1ca04d94ad45e79c0297719d5ef50a7c33c352.camel@intel.com>
 <664f8adeb56ba61774f3c845041f016c54e0f96e.camel@intel.com>
 <1b681365-ef98-ec78-96dc-04e28316cf0e@intel.com> <8bf596b45f68363134f431bcc550e16a9a231b80.camel@intel.com>
 <6bb89ca6e7346f4334f06ea293f29fd12df70fe4.camel@intel.com>
 <CAPcyv4iP3hcNNDxNdPT+iB0E4aUazfqFWwaa_dtHpVf+qKPNcQ@mail.gmail.com>
 <cbb2ea1343079aee546fb44cd59c82f66c875d76.camel@intel.com>
 <CAPcyv4jNYqPA2HBaO+9a+ije4jnb6a3Sx_1knrmRF9HCCXQuqg@mail.gmail.com> <b40b3658e1fc7ec15d2adafe7f9562d42bc256f3.camel@intel.com>
In-Reply-To: <b40b3658e1fc7ec15d2adafe7f9562d42bc256f3.camel@intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 5 May 2022 18:15:38 -0700
Message-ID: <CAPcyv4hdM+0zntuTez9n1-dJ_ODsF_TxAct=VpTs-tWJzBPJqQ@mail.gmail.com>
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

On Thu, May 5, 2022 at 5:46 PM Kai Huang <kai.huang@intel.com> wrote:
>
> On Thu, 2022-05-05 at 17:22 -0700, Dan Williams wrote:
> > On Thu, May 5, 2022 at 3:14 PM Kai Huang <kai.huang@intel.com> wrote:
> > >
> > > Thanks for feedback!
> > >
> > > On Thu, 2022-05-05 at 06:51 -0700, Dan Williams wrote:
> > > > [ add Mike ]
> > > >
> > > >
> > > > On Thu, May 5, 2022 at 2:54 AM Kai Huang <kai.huang@intel.com> wrote:
> > > > [..]
> > > > >
> > > > > Hi Dave,
> > > > >
> > > > > Sorry to ping (trying to close this).
> > > > >
> > > > > Given we don't need to consider kmem-hot-add legacy PMEM after TDX module
> > > > > initialization, I think for now it's totally fine to exclude legacy PMEMs from
> > > > > TDMRs.  The worst case is when someone tries to use them as TD guest backend
> > > > > directly, the TD will fail to create.  IMO it's acceptable, as it is supposedly
> > > > > that no one should just use some random backend to run TD.
> > > >
> > > > The platform will already do this, right?
> > > >
> > >
> > > In the current v3 implementation, we don't have any code to handle memory
> > > hotplug, therefore nothing prevents people from adding legacy PMEMs as system
> > > RAM using kmem driver.  In order to guarantee all pages managed by page
> >
> > That's the fundamental question I am asking why is "guarantee all
> > pages managed by page allocator are TDX memory". That seems overkill
> > compared to indicating the incompatibility after the fact.
>
> As I explained, the reason is I don't want to modify page allocator to
> distinguish TDX and non-TDX allocation, for instance, having to have a ZONE_TDX
> and GFP_TDX.

Right, TDX details do not belong at that level, but it will work
almost all the time if you do nothing to "guarantee" all TDX capable
pages all the time.

> KVM depends on host's page fault handler to allocate the page.  In fact KVM only
> consumes PFN from host's page tables.  For now only RAM is TDX memory.  By
> guaranteeing all pages in page allocator is TDX memory, we can easily use
> anonymous pages as TD guest memory.

Again, TDX capable pages will be the overwhelming default, why are you
worried about cluttering the memory hotplug path for nice corner
cases.

Consider the fact that end users can break the kernel by specifying
invalid memmap= command line options. The memory hotplug code does not
take any steps to add safety in those cases because there are already
too many ways it can go wrong. TDX is just one more corner case where
the memmap= user needs to be careful. Otherwise, it is up to the
platform firmware to make sure everything in the base memory map is
TDX capable, and then all you need is documentation about the failure
mode when extending "System RAM" beyond that baseline.

> shmem to support a new fd-based backend which doesn't require having to mmap()
> TD guest memory to host userspace:
>
> https://lore.kernel.org/kvm/20220310140911.50924-1-chao.p.peng@linux.intel.com/
>
> Also, besides TD guest memory, there are some per-TD control data structures
> (which must be TDX memory too) need to be allocated for each TD.  Normal memory
> allocation APIs can be used for such allocation if we guarantee all pages in
> page allocator is TDX memory.

You don't need that guarantee, just check it after the fact and fail
if that assertion fails. It should almost always be the case that it
succeeds and if it doesn't then something special is happening with
that system and the end user has effectively opt-ed out of TDX
operation.

> > > allocator are all TDX memory, the v3 implementation needs to always include
> > > legacy PMEMs as TDX memory so that even people truly add  legacy PMEMs as system
> > > RAM, we can still guarantee all pages in page allocator are TDX memory.
> >
> > Why?
>
> If we don't include legacy PMEMs as TDX memory, then after they are hot-added as
> system RAM using kmem driver, the assumption of "all pages in page allocator are
> TDX memory" is broken.  A TD can be killed during runtime.

Yes, that is what the end user asked for. If they don't want that to
happen then the policy decision about using kmem needs to be updated
in userspace, not hard code that policy decision towards TDX inside
the kernel.
