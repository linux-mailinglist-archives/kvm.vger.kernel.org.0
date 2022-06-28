Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1DB55F216
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 01:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbiF1XtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 19:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiF1XtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 19:49:21 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4311538D9B;
        Tue, 28 Jun 2022 16:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656460160; x=1687996160;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=abqB8hsx2CRn5C6rESUaaRHsxya0aF2DV3aNj32CTmI=;
  b=HsYs0ddBNizdTeDhPvMflWgCL7HXrH4XYfBWagBHIagrbSeAZs2/tVwG
   zGGQkK32uY8S70fF5ugBZHgdpB2J8iJ3LxQxTQwKLjyFv4LmnaWfFY7ob
   sV0V66YXl2/lNdwvdidOtTTbTHKCGY791lLX2O2x9bC0i1SXN4QolQroj
   ZT6YZuKK2v+Zp7BSIDzVsvfGWW1i2IH4nMNBGlku+sbs2PGyzVmrDxQqT
   GARvdWfIVnsErQvfa4xLO2D4LJRNgI8dfglDLlI+ZELzTIXFnOcUzV660
   0mslW2bjJaFxOi5yYLu5r85iSmC56eE6rpPYgaHFq+LoC4uiAibj7Wgby
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="282971528"
X-IronPort-AV: E=Sophos;i="5.92,230,1650956400"; 
   d="scan'208";a="282971528"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 16:49:19 -0700
X-IronPort-AV: E=Sophos;i="5.92,230,1650956400"; 
   d="scan'208";a="917374680"
Received: from gregantx-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.119.76])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 16:49:16 -0700
Message-ID: <ceb320a00eebd29d2031b94b6123ff31ba74c313.camel@intel.com>
Subject: Re: [PATCH v5 03/22] cc_platform: Add new attribute to prevent ACPI
 memory hotplug
From:   Kai Huang <kai.huang@intel.com>
To:     Igor Mammedov <imammedo@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
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
        isaku.yamahata@intel.com, Tom Lendacky <thomas.lendacky@amd.com>
Date:   Wed, 29 Jun 2022 11:49:14 +1200
In-Reply-To: <20220628140112.661154cf@redhat.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <87dc19c47bad73509359c8e1e3a81d51d1681e4c.1655894131.git.kai.huang@intel.com>
         <CAJZ5v0jEJNdmkidvcOiRn+OVt01D5095t+nyXaJHKsqEAOvcBQ@mail.gmail.com>
         <20220628140112.661154cf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-28 at 14:01 +0200, Igor Mammedov wrote:
> On Wed, 22 Jun 2022 13:45:01 +0200
> "Rafael J. Wysocki" <rafael@kernel.org> wrote:
>=20
> > On Wed, Jun 22, 2022 at 1:16 PM Kai Huang <kai.huang@intel.com> wrote:
> > >=20
> > > Platforms with confidential computing technology may not support ACPI
> > > memory hotplug when such technology is enabled by the BIOS.  Examples
> > > include Intel platforms which support Intel Trust Domain Extensions
> > > (TDX).
> > >=20
> > > If the kernel ever receives ACPI memory hotplug event, it is likely a
> > > BIOS bug.  For ACPI memory hot-add, the kernel should speak out this =
is
> > > a BIOS bug and reject the new memory.  For hot-removal, for simplicit=
y
> > > just assume the kernel cannot continue to work normally, and just BUG=
().
> > >=20
> > > Add a new attribute CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED to indicate =
the
> > > platform doesn't support ACPI memory hotplug, so that kernel can hand=
le
> > > ACPI memory hotplug events for such platform.
> > >=20
> > > In acpi_memory_device_{add|remove}(), add early check against this
> > > attribute and handle accordingly if it is set.
> > >=20
> > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > ---
> > >  drivers/acpi/acpi_memhotplug.c | 23 +++++++++++++++++++++++
> > >  include/linux/cc_platform.h    | 10 ++++++++++
> > >  2 files changed, 33 insertions(+)
> > >=20
> > > diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memho=
tplug.c
> > > index 24f662d8bd39..94d6354ea453 100644
> > > --- a/drivers/acpi/acpi_memhotplug.c
> > > +++ b/drivers/acpi/acpi_memhotplug.c
> > > @@ -15,6 +15,7 @@
> > >  #include <linux/acpi.h>
> > >  #include <linux/memory.h>
> > >  #include <linux/memory_hotplug.h>
> > > +#include <linux/cc_platform.h>
> > >=20
> > >  #include "internal.h"
> > >=20
> > > @@ -291,6 +292,17 @@ static int acpi_memory_device_add(struct acpi_de=
vice *device,
> > >         if (!device)
> > >                 return -EINVAL;
> > >=20
> > > +       /*
> > > +        * If the confidential computing platform doesn't support ACP=
I
> > > +        * memory hotplug, the BIOS should never deliver such event t=
o
> > > +        * the kernel.  Report ACPI CPU hot-add as a BIOS bug and ign=
ore
> > > +        * the memory device.
> > > +        */
> > > +       if (cc_platform_has(c)) { =20
> >=20
> > Same comment as for the acpi_processor driver: this will affect the
> > initialization too and it would be cleaner to reset the
> > .hotplug.enabled flag of the scan handler.
>=20
> with QEMU, it is likely broken when memory is added as
>   '-device pc-dimm'
> on CLI since it's advertised only as device node in DSDT.
>=20
>=20

Hi Rafael,  Igor,

On my test machine, the acpi_memory_device_add() is not called for system
memory.  It probably because my machine doesn't have memory device in ACPI.

I don't know whether we can have any memory device in ACPI if such memory i=
s
present during boot?  Any comments here?

And CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED is only true on TDX bare-metal sys=
tem,
but cannot be true in Qemu guest.  But yes if this flag ever becomes true i=
n
guest, then I think we may have problem here.  I will do more study around =
ACPI.
Thanks for comments!

--=20
Thanks,
-Kai


