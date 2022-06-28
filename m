Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4ED55EB19
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 19:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbiF1ReK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 13:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbiF1ReJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 13:34:09 -0400
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F100E27FDA;
        Tue, 28 Jun 2022 10:34:07 -0700 (PDT)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-318889e6a2cso124507847b3.1;
        Tue, 28 Jun 2022 10:34:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SHw0pc+VB2/FYpO6oBuZ5Ng5KCvvlIFFOc8mnONyuyI=;
        b=EoN4OaMP33nLfABMjeLWwmqqgw8dskQ9qZv5Bt5ZU+tg9vDW+xYbJsPkKi7G4B3oMQ
         OhhMavMt8htM8LBQzv53/f1AQleBJV9rERUdl0zYD4Jb2MiXVG8awspkHjAU07yf7V8Q
         LhOstuHcNLNmOClGWbUG6wIJB9FAL2kyYTx8F0hV5kX5dl+QZeaRxl5Ewr6TVspBh1n6
         xFW45KXZjZj+0lCR5xRgrjpjQa6P2D0QFKlUjnI9VfUsYbQjmbOgUlGfk6Hsd0FXMdCg
         EMeK9fmFrvD3q6wbx6Y9jyaygmKfWWouzsqCDwl7klUFjfH6UM0mb0/qzLT5wPur0qbj
         H1jQ==
X-Gm-Message-State: AJIora+ZwEadRDVpwXaQ90SJZlAKK07zqAGfFjOS4ikkvaZ1MHvLnwnZ
        tTlW0Apk5d+ykeiU9lzNxPbwSO8cBr45K6dnETw=
X-Google-Smtp-Source: AGRyM1vOyMp+CQR3BYeweDLkOJAsZTQdHJbJw3oJpm23uUpa0F//Mh2xFsHMy0BA4th1hkimwosFIb4STwWhVUk2kSs=
X-Received: by 2002:a0d:d086:0:b0:31b:d0b2:e11f with SMTP id
 s128-20020a0dd086000000b0031bd0b2e11fmr10908606ywd.515.1656437647135; Tue, 28
 Jun 2022 10:34:07 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655894131.git.kai.huang@intel.com> <f4bff93d83814ea1f54494f51ce3e5d954cf0f5b.1655894131.git.kai.huang@intel.com>
 <CAJZ5v0jV8ODcxuLL+iSpYbW7w=GFtUSakN-n8CO5Zmun3K-Erg@mail.gmail.com>
 <d3ba563f3f4e7aaf90fb99d20c651b5751972f7b.camel@intel.com>
 <20220627100155.71a7b34c@redhat.com> <2b676b19db423b995a21c7f215ed117c345c60d9.camel@intel.com>
In-Reply-To: <2b676b19db423b995a21c7f215ed117c345c60d9.camel@intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 28 Jun 2022 19:33:56 +0200
Message-ID: <CAJZ5v0gtinPZnVKvZzJDc1Ph+DPdNWxVdwwqr32z1Tecx+Qm7Q@mail.gmail.com>
Subject: Re: [PATCH v5 02/22] cc_platform: Add new attribute to prevent ACPI
 CPU hotplug
To:     Kai Huang <kai.huang@intel.com>
Cc:     Igor Mammedov <imammedo@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm-devel <kvm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Len Brown <len.brown@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        isaku.yamahata@intel.com, Tom Lendacky <thomas.lendacky@amd.com>,
        Tianyu.Lan@microsoft.com, Randy Dunlap <rdunlap@infradead.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Yue Haibing <yuehaibing@huawei.com>, dongli.zhang@oracle.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 28, 2022 at 12:04 PM Kai Huang <kai.huang@intel.com> wrote:
>
> On Mon, 2022-06-27 at 10:01 +0200, Igor Mammedov wrote:
> > On Thu, 23 Jun 2022 12:01:48 +1200
> > Kai Huang <kai.huang@intel.com> wrote:
> >
> > > On Wed, 2022-06-22 at 13:42 +0200, Rafael J. Wysocki wrote:
> > > > On Wed, Jun 22, 2022 at 1:16 PM Kai Huang <kai.huang@intel.com> wrote:
> > > > >
> > > > > Platforms with confidential computing technology may not support ACPI
> > > > > CPU hotplug when such technology is enabled by the BIOS.  Examples
> > > > > include Intel platforms which support Intel Trust Domain Extensions
> > > > > (TDX).
> > > > >
> > > > > If the kernel ever receives ACPI CPU hotplug event, it is likely a BIOS
> > > > > bug.  For ACPI CPU hot-add, the kernel should speak out this is a BIOS
> > > > > bug and reject the new CPU.  For hot-removal, for simplicity just assume
> > > > > the kernel cannot continue to work normally, and BUG().
> > > > >
> > > > > Add a new attribute CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED to indicate the
> > > > > platform doesn't support ACPI CPU hotplug, so that kernel can handle
> > > > > ACPI CPU hotplug events for such platform.  The existing attribute
> > > > > CC_ATTR_HOTPLUG_DISABLED is for software CPU hotplug thus doesn't fit.
> > > > >
> > > > > In acpi_processor_{add|remove}(), add early check against this attribute
> > > > > and handle accordingly if it is set.
> > > > >
> > > > > Also take this chance to rename existing CC_ATTR_HOTPLUG_DISABLED to
> > > > > CC_ATTR_CPU_HOTPLUG_DISABLED as it is for software CPU hotplug.
> > > > >
> > > > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > > > ---
> > > > >  arch/x86/coco/core.c          |  2 +-
> > > > >  drivers/acpi/acpi_processor.c | 23 +++++++++++++++++++++++
> > > > >  include/linux/cc_platform.h   | 15 +++++++++++++--
> > > > >  kernel/cpu.c                  |  2 +-
> > > > >  4 files changed, 38 insertions(+), 4 deletions(-)
> > > > >
> > > > > diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
> > > > > index 4320fadae716..1bde1af75296 100644
> > > > > --- a/arch/x86/coco/core.c
> > > > > +++ b/arch/x86/coco/core.c
> > > > > @@ -20,7 +20,7 @@ static bool intel_cc_platform_has(enum cc_attr attr)
> > > > >  {
> > > > >         switch (attr) {
> > > > >         case CC_ATTR_GUEST_UNROLL_STRING_IO:
> > > > > -       case CC_ATTR_HOTPLUG_DISABLED:
> > > > > +       case CC_ATTR_CPU_HOTPLUG_DISABLED:
> > > > >         case CC_ATTR_GUEST_MEM_ENCRYPT:
> > > > >         case CC_ATTR_MEM_ENCRYPT:
> > > > >                 return true;
> > > > > diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
> > > > > index 6737b1cbf6d6..b960db864cd4 100644
> > > > > --- a/drivers/acpi/acpi_processor.c
> > > > > +++ b/drivers/acpi/acpi_processor.c
> > > > > @@ -15,6 +15,7 @@
> > > > >  #include <linux/kernel.h>
> > > > >  #include <linux/module.h>
> > > > >  #include <linux/pci.h>
> > > > > +#include <linux/cc_platform.h>
> > > > >
> > > > >  #include <acpi/processor.h>
> > > > >
> > > > > @@ -357,6 +358,17 @@ static int acpi_processor_add(struct acpi_device *device,
> > > > >         struct device *dev;
> > > > >         int result = 0;
> > > > >
> > > > > +       /*
> > > > > +        * If the confidential computing platform doesn't support ACPI
> > > > > +        * memory hotplug, the BIOS should never deliver such event to
> > > > > +        * the kernel.  Report ACPI CPU hot-add as a BIOS bug and ignore
> > > > > +        * the new CPU.
> > > > > +        */
> > > > > +       if (cc_platform_has(CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED)) {
> > > >
> > > > This will affect initialization, not just hotplug AFAICS.
> > > >
> > > > You should reset the .hotplug.enabled flag in processor_handler to
> > > > false instead.
> > >
> > > Hi Rafael,
> > >
> > > Thanks for the review.  By "affect initialization" did you mean this
> > > acpi_processor_add() is also called during kernel boot when any logical cpu is
> > > brought up?  Or do you mean ACPI CPU hotplug can also happen during kernel boot
> > > (after acpi_processor_init())?
> > >
> > > I see acpi_processor_init() calls acpi_processor_check_duplicates() which calls
> > > acpi_evaluate_object() but I don't know details of ACPI so I don't know whether
> > > this would trigger acpi_processor_add().
> > >
> > > One thing is TDX doesn't support ACPI CPU hotplug is an architectural thing, so
> > > it is illegal even if it happens during kernel boot.  Dave's idea is the kernel
> > > should  speak out loudly if physical CPU hotplug indeed happened on (BIOS) TDX-
> > > enabled platforms.  Otherwise perhaps we can just give up initializing the ACPI
> > > CPU hotplug in acpi_processor_init(), something like below?
> >
> > The thing is that by the time ACPI machinery kicks in, physical hotplug
> > has already happened and in case of (kvm+qemu+ovmf hypervisor combo)
> > firmware has already handled it somehow and handed it over to ACPI.
> > If you say it's architectural thing then cpu hotplug is platform/firmware
> > bug and should be disabled there instead of working around it in the kernel.
> >
> > Perhaps instead of 'preventing' hotplug, complain/panic and be done with it.
>
> Hi Igor,
>
> Thanks for feedback.  Yes the current implementation actually reports CPU hot-
> add as BIOS bug.  I think I can report BIOS bug for hot-removal too.  And
> currently I actually used BUG() for the hot-removal case.  For hot-add I didn't
> use BUG() but rejected the new CPU as the latter is more conservative.
>
> Hi Rafael,
>
> I am not sure I got what you mean by "This will affect initialization, not just
> hotplug AFAICS", could you elaborate a little bit?  Thanks.

So acpi_processor_add() is called for CPUs that are already present at
init time, not just for the hot-added ones.

One of the things it does is to associate an ACPI companion with the given CPU.

Don't you need that to happen?
