Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC9B556F46
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 02:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbiFWAB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 20:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbiFWAB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 20:01:56 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5802403F8;
        Wed, 22 Jun 2022 17:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655942515; x=1687478515;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=T15ZJso/B5LUFRkGGDDvgKQQDe8xUIdacYkRiD8qF2I=;
  b=ZMC2niVbGOm+g78fKfNpWC//GvWPt7ogL/QM6Fn7QJXYLZz2rAQQaO7U
   PlORxsI0kiW9vPcSzdQL4r/QbUGMNFrXZnLuNzLOf+Nhi0JvxS6I0lVW9
   A0FNpwA+Pfq4VwMLgtRRDekTh0DHG4/tNoMEAa0o1u9+xiFVEhX7UjTYm
   bJ6hdllqnv6EZ7e6a9GLXPvYmBNCQJdw4zJTP21nwHZMuKoH82CM+ZCE1
   1i5MhJMgyafYK+qQlFPTx5eInKg7bn0r8bkuvDOHcB6eFKVNO2pafr48/
   tcjl24dtmJSX+GP5MaMpWkPFHVxcdQu+exO+2s45ENj6h/p4F6uB5JGqX
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="280627383"
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="280627383"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 17:01:55 -0700
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="644454589"
Received: from jmatsis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.178.197])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 17:01:50 -0700
Message-ID: <d3ba563f3f4e7aaf90fb99d20c651b5751972f7b.camel@intel.com>
Subject: Re: [PATCH v5 02/22] cc_platform: Add new attribute to prevent ACPI
 CPU hotplug
From:   Kai Huang <kai.huang@intel.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
Date:   Thu, 23 Jun 2022 12:01:48 +1200
In-Reply-To: <CAJZ5v0jV8ODcxuLL+iSpYbW7w=GFtUSakN-n8CO5Zmun3K-Erg@mail.gmail.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <f4bff93d83814ea1f54494f51ce3e5d954cf0f5b.1655894131.git.kai.huang@intel.com>
         <CAJZ5v0jV8ODcxuLL+iSpYbW7w=GFtUSakN-n8CO5Zmun3K-Erg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-06-22 at 13:42 +0200, Rafael J. Wysocki wrote:
> On Wed, Jun 22, 2022 at 1:16 PM Kai Huang <kai.huang@intel.com> wrote:
> >=20
> > Platforms with confidential computing technology may not support ACPI
> > CPU hotplug when such technology is enabled by the BIOS.  Examples
> > include Intel platforms which support Intel Trust Domain Extensions
> > (TDX).
> >=20
> > If the kernel ever receives ACPI CPU hotplug event, it is likely a BIOS
> > bug.  For ACPI CPU hot-add, the kernel should speak out this is a BIOS
> > bug and reject the new CPU.  For hot-removal, for simplicity just assum=
e
> > the kernel cannot continue to work normally, and BUG().
> >=20
> > Add a new attribute CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED to indicate the
> > platform doesn't support ACPI CPU hotplug, so that kernel can handle
> > ACPI CPU hotplug events for such platform.  The existing attribute
> > CC_ATTR_HOTPLUG_DISABLED is for software CPU hotplug thus doesn't fit.
> >=20
> > In acpi_processor_{add|remove}(), add early check against this attribut=
e
> > and handle accordingly if it is set.
> >=20
> > Also take this chance to rename existing CC_ATTR_HOTPLUG_DISABLED to
> > CC_ATTR_CPU_HOTPLUG_DISABLED as it is for software CPU hotplug.
> >=20
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/coco/core.c          |  2 +-
> >  drivers/acpi/acpi_processor.c | 23 +++++++++++++++++++++++
> >  include/linux/cc_platform.h   | 15 +++++++++++++--
> >  kernel/cpu.c                  |  2 +-
> >  4 files changed, 38 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
> > index 4320fadae716..1bde1af75296 100644
> > --- a/arch/x86/coco/core.c
> > +++ b/arch/x86/coco/core.c
> > @@ -20,7 +20,7 @@ static bool intel_cc_platform_has(enum cc_attr attr)
> >  {
> >         switch (attr) {
> >         case CC_ATTR_GUEST_UNROLL_STRING_IO:
> > -       case CC_ATTR_HOTPLUG_DISABLED:
> > +       case CC_ATTR_CPU_HOTPLUG_DISABLED:
> >         case CC_ATTR_GUEST_MEM_ENCRYPT:
> >         case CC_ATTR_MEM_ENCRYPT:
> >                 return true;
> > diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processo=
r.c
> > index 6737b1cbf6d6..b960db864cd4 100644
> > --- a/drivers/acpi/acpi_processor.c
> > +++ b/drivers/acpi/acpi_processor.c
> > @@ -15,6 +15,7 @@
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> >  #include <linux/pci.h>
> > +#include <linux/cc_platform.h>
> >=20
> >  #include <acpi/processor.h>
> >=20
> > @@ -357,6 +358,17 @@ static int acpi_processor_add(struct acpi_device *=
device,
> >         struct device *dev;
> >         int result =3D 0;
> >=20
> > +       /*
> > +        * If the confidential computing platform doesn't support ACPI
> > +        * memory hotplug, the BIOS should never deliver such event to
> > +        * the kernel.  Report ACPI CPU hot-add as a BIOS bug and ignor=
e
> > +        * the new CPU.
> > +        */
> > +       if (cc_platform_has(CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED)) {
>=20
> This will affect initialization, not just hotplug AFAICS.
>=20
> You should reset the .hotplug.enabled flag in processor_handler to
> false instead.

Hi Rafael,

Thanks for the review.  By "affect initialization" did you mean this
acpi_processor_add() is also called during kernel boot when any logical cpu=
 is
brought up?  Or do you mean ACPI CPU hotplug can also happen during kernel =
boot
(after acpi_processor_init())?

I see acpi_processor_init() calls acpi_processor_check_duplicates() which c=
alls
acpi_evaluate_object() but I don't know details of ACPI so I don't know whe=
ther
this would trigger acpi_processor_add().

One thing is TDX doesn't support ACPI CPU hotplug is an architectural thing=
, so
it is illegal even if it happens during kernel boot.  Dave's idea is the ke=
rnel
should  speak out loudly if physical CPU hotplug indeed happened on (BIOS) =
TDX-
enabled platforms.  Otherwise perhaps we can just give up initializing the =
ACPI
CPU hotplug in acpi_processor_init(), something like below?

--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -707,6 +707,10 @@ bool acpi_duplicate_processor_id(int proc_id)
 void __init acpi_processor_init(void)
 {
        acpi_processor_check_duplicates();
+
+       if (cc_platform_has(CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED))
+               return;
+
        acpi_scan_add_handler_with_hotplug(&processor_handler, "processor")=
;
        acpi_scan_add_handler(&processor_container_handler);
 }


>=20
> > +               dev_err(&device->dev, "[BIOS bug]: Platform doesn't sup=
port ACPI CPU hotplug.  New CPU ignored.\n");
> > +               return -EINVAL;
> > +       }
> > +

--=20
Thanks,
-Kai


