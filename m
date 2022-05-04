Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3A451A237
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 16:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351337AbiEDOfC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 10:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351330AbiEDOfB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 10:35:01 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA8719299
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 07:31:25 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id a11so1288178pff.1
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 07:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9iUGkhKiiAT2T4Pc3rEXAuHxa9x6mx+IUETLy182GSI=;
        b=FbxnqeiT9svwA2BU90ix2G4zW8IBbMDfv4x2lDk4YzSK38lXtu1MRv6PtcttUZ/08+
         YZz6u+it2BCSK4ZNcwGWhYjrJwkq4Rs9FJlqKMxjV3iZYNUdFKYq/rp4SOJX3DHAIqZJ
         +ke29wZw6f4MvRPg4UuSOi7Nl79L9SjphOdiTMY+pEQkg0PChlsuKwGlGr086wO+LMX5
         MC9LEVK66YfZw00e97YnfL4ONz2UnESwqME3QPR8BZfxwvq2aFj0CK3wv8dyf+nybt+1
         lpmQg40MoWatBcyaPwNbmF2bd0yZZpxy4uISSnC4cCUC7xDqEwjYJs9xdljVgbp4AvhB
         YlTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9iUGkhKiiAT2T4Pc3rEXAuHxa9x6mx+IUETLy182GSI=;
        b=FiP+ZwdiNnux0nj+Ud3Um4RtW5/JGxOWzhf5evkP48gvAMbesBPoyV3SO6p7gK3iES
         2hYnkg38y2hl4z0iHslhQRAq05eyGogOEX/NEmfjCIBvg/Ux35xPVpYCKqeWczty8Aga
         GRvSAxKSZ1Zht8hbIUy1tPlC1xdZB03Hq/qjAciNNyYkgJmfDDPjaVh0APXpoX8ZQRUz
         J5rHsr6NSP7VxC9xB5d673kKn+GcxpkpTyfrgeAxh0o0+T92VgvV+Nn6ZJrtzhABckX4
         1h24VXsjmMejN0GD63UYdREO/2A922gAAxJbYV5f/wZq7uL7ZW4WiPpc+L+KBYa1ZRFb
         LEGw==
X-Gm-Message-State: AOAM532OITdNhr7/Zja9p+azGN1CFLYX+wwu2ZnLExARizrOocUcyeJO
        Fg3VW5bjCk9AAwbCK9DLabclepHQQDZFVD/Uyqnc0rtwL/A=
X-Google-Smtp-Source: ABdhPJxugCz6IbhVw8abuYsJH861nxx8rmUGeHNyPcexunG973IaB1iJvs1UxjXMeg8FsfgmBJU86tz60Ix7E9ZZ0e8=
X-Received: by 2002:a05:6a02:283:b0:342:703e:1434 with SMTP id
 bk3-20020a056a02028300b00342703e1434mr17693010pgb.74.1651674684552; Wed, 04
 May 2022 07:31:24 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1649219184.git.kai.huang@intel.com> <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
 <ecf718abf864bbb2366209f00d4315ada090aedc.camel@intel.com>
 <de24ac7e-349c-e49a-70bb-31b9bc867b10@intel.com> <9b388f54f13b34fe684ef77603fc878952e48f87.camel@intel.com>
 <d98ca73b-2d2d-757d-e937-acc83cfedfb0@intel.com> <c90a10763969077826f42be6f492e3a3e062326b.camel@intel.com>
 <fc1ca04d94ad45e79c0297719d5ef50a7c33c352.camel@intel.com> <664f8adeb56ba61774f3c845041f016c54e0f96e.camel@intel.com>
In-Reply-To: <664f8adeb56ba61774f3c845041f016c54e0f96e.camel@intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 4 May 2022 07:31:13 -0700
Message-ID: <CAPcyv4jQ6C+vu3ALtG_3k483KYwYGB5gd_auUCeUNaJ=v4eTyQ@mail.gmail.com>
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
        Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 3, 2022 at 4:59 PM Kai Huang <kai.huang@intel.com> wrote:
>
> On Fri, 2022-04-29 at 13:40 +1200, Kai Huang wrote:
> > On Thu, 2022-04-28 at 12:58 +1200, Kai Huang wrote:
> > > On Wed, 2022-04-27 at 17:50 -0700, Dave Hansen wrote:
> > > > On 4/27/22 17:37, Kai Huang wrote:
> > > > > On Wed, 2022-04-27 at 14:59 -0700, Dave Hansen wrote:
> > > > > > In 5 years, if someone takes this code and runs it on Intel hardware
> > > > > > with memory hotplug, CPU hotplug, NVDIMMs *AND* TDX support, what happens?
> > > > >
> > > > > I thought we could document this in the documentation saying that this code can
> > > > > only work on TDX machines that don't have above capabilities (SPR for now).  We
> > > > > can change the code and the documentation  when we add the support of those
> > > > > features in the future, and update the documentation.
> > > > >
> > > > > If 5 years later someone takes this code, he/she should take a look at the
> > > > > documentation and figure out that he/she should choose a newer kernel if the
> > > > > machine support those features.
> > > > >
> > > > > I'll think about design solutions if above doesn't look good for you.
> > > >
> > > > No, it doesn't look good to me.
> > > >
> > > > You can't just say:
> > > >
> > > >   /*
> > > >    * This code will eat puppies if used on systems with hotplug.
> > > >    */
> > > >
> > > > and merrily await the puppy bloodbath.
> > > >
> > > > If it's not compatible, then you have to *MAKE* it not compatible in a
> > > > safe, controlled way.
> > > >
> > > > > > You can't just ignore the problems because they're not present on one
> > > > > > version of the hardware.
> > > >
> > > > Please, please read this again ^^
> > >
> > > OK.  I'll think about solutions and come back later.
> > > >
> >
> > Hi Dave,
> >
> > I think we have two approaches to handle memory hotplug interaction with the TDX
> > module initialization.
> >
> > The first approach is simple.  We just block memory from being added as system
> > RAM managed by page allocator when the platform supports TDX [1]. It seems we
> > can add some arch-specific-check to __add_memory_resource() and reject the new
> > memory resource if platform supports TDX.  __add_memory_resource() is called by
> > both __add_memory() and add_memory_driver_managed() so it prevents from adding
> > NVDIMM as system RAM and normal ACPI memory hotplug [2].
>
> Hi Dave,
>
> Try to close how to handle memory hotplug.  Any comments to below?
>
> For the first approach, I forgot to think about memory hot-remove case.  If we
> just reject adding new memory resource when TDX is capable on the platform, then
> if the memory is hot-removed, we won't be able to add it back.  My thinking is
> we still want to support memory online/offline because it is purely in software
> but has nothing to do with TDX.  But if one memory resource can be put to
> offline, it seems we don't have any way to prevent it from being removed.
>
> So if we do above, on the future platforms when memory hotplug can co-exist with
> TDX, ACPI hot-add and kmem-hot-add memory will be prevented.  However if some
> memory is hot-removed, it won't be able to be added back (even it is included in
> CMR, or TDMRs after TDX module is initialized).
>
> Is this behavior acceptable?  Or perhaps I have misunderstanding?

Memory online at boot uses similar kernel paths as memory-online at
run time, so it sounds like your question is confusing physical vs
logical remove. Consider the case of logical offline then re-online
where the proposed TDX sanity check blocks the memory online, but then
a new kernel is kexec'd and that kernel again trusts the memory as TD
convertible again just because it onlines the memory in the boot path.
For physical memory remove it seems up to the platform to block that
if it conflicts with TDX, not for the kernel to add extra assumptions
that logical offline / online is incompatible with TDX.
