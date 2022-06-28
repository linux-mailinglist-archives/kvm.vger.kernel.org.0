Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F35555D65A
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344244AbiF1KEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 06:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344169AbiF1KEx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 06:04:53 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2B22D1C9;
        Tue, 28 Jun 2022 03:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656410692; x=1687946692;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=V8xmQPHT1mCLQeDpG45Uq0txHRzx1XRmzSSIhRmQbPE=;
  b=GkEH+FWbUO+5DRLixED9hMGJit7an5JnpC03J0SDxipRWxYCAQel6D1v
   f1Ijs3R9g/NwuezbYLQ3vK1pFqqucR6qDp0gPZuCGCL/F18mR5qcTY20I
   7uSPZdcr4xBOojFR7cQsUYMgZ59pgBCAmWrdWaEZ2cIMmBqnq3BNOizO2
   OYQOLuXgHuasHg5qmahzEpz+ZyLumVSy6fIC0PB03gzXyYJQxjfHlyrt/
   k6eyZwo2NiBX1aWKnsDDDWrVo5gKTdzZhoyLyBRzgpOxN26AD93IzZbI+
   qQcYuDOhP+XP2glq6Z7kL9pg09aGyXMrYwTP1tSaKEQMRXS3nZ0bmtwT+
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="345695538"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="345695538"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 03:04:51 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="617134907"
Received: from nherzalx-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.96.221])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 03:04:45 -0700
Message-ID: <2b676b19db423b995a21c7f215ed117c345c60d9.camel@intel.com>
Subject: Re: [PATCH v5 02/22] cc_platform: Add new attribute to prevent ACPI
 CPU hotplug
From:   Kai Huang <kai.huang@intel.com>
To:     Igor Mammedov <imammedo@redhat.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
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
Date:   Tue, 28 Jun 2022 22:04:43 +1200
In-Reply-To: <20220627100155.71a7b34c@redhat.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <f4bff93d83814ea1f54494f51ce3e5d954cf0f5b.1655894131.git.kai.huang@intel.com>
         <CAJZ5v0jV8ODcxuLL+iSpYbW7w=GFtUSakN-n8CO5Zmun3K-Erg@mail.gmail.com>
         <d3ba563f3f4e7aaf90fb99d20c651b5751972f7b.camel@intel.com>
         <20220627100155.71a7b34c@redhat.com>
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

On Mon, 2022-06-27 at 10:01 +0200, Igor Mammedov wrote:
> On Thu, 23 Jun 2022 12:01:48 +1200
> Kai Huang <kai.huang@intel.com> wrote:
>=20
> > On Wed, 2022-06-22 at 13:42 +0200, Rafael J. Wysocki wrote:
> > > On Wed, Jun 22, 2022 at 1:16 PM Kai Huang <kai.huang@intel.com> wrote=
: =20
> > > >=20
> > > > Platforms with confidential computing technology may not support AC=
PI
> > > > CPU hotplug when such technology is enabled by the BIOS.  Examples
> > > > include Intel platforms which support Intel Trust Domain Extensions
> > > > (TDX).
> > > >=20
> > > > If the kernel ever receives ACPI CPU hotplug event, it is likely a =
BIOS
> > > > bug.  For ACPI CPU hot-add, the kernel should speak out this is a B=
IOS
> > > > bug and reject the new CPU.  For hot-removal, for simplicity just a=
ssume
> > > > the kernel cannot continue to work normally, and BUG().
> > > >=20
> > > > Add a new attribute CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED to indicate t=
he
> > > > platform doesn't support ACPI CPU hotplug, so that kernel can handl=
e
> > > > ACPI CPU hotplug events for such platform.  The existing attribute
> > > > CC_ATTR_HOTPLUG_DISABLED is for software CPU hotplug thus doesn't f=
it.
> > > >=20
> > > > In acpi_processor_{add|remove}(), add early check against this attr=
ibute
> > > > and handle accordingly if it is set.
> > > >=20
> > > > Also take this chance to rename existing CC_ATTR_HOTPLUG_DISABLED t=
o
> > > > CC_ATTR_CPU_HOTPLUG_DISABLED as it is for software CPU hotplug.
> > > >=20
> > > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > > ---
> > > >  arch/x86/coco/core.c          |  2 +-
> > > >  drivers/acpi/acpi_processor.c | 23 +++++++++++++++++++++++
> > > >  include/linux/cc_platform.h   | 15 +++++++++++++--
> > > >  kernel/cpu.c                  |  2 +-
> > > >  4 files changed, 38 insertions(+), 4 deletions(-)
> > > >=20
> > > > diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
> > > > index 4320fadae716..1bde1af75296 100644
> > > > --- a/arch/x86/coco/core.c
> > > > +++ b/arch/x86/coco/core.c
> > > > @@ -20,7 +20,7 @@ static bool intel_cc_platform_has(enum cc_attr at=
tr)
> > > >  {
> > > >         switch (attr) {
> > > >         case CC_ATTR_GUEST_UNROLL_STRING_IO:
> > > > -       case CC_ATTR_HOTPLUG_DISABLED:
> > > > +       case CC_ATTR_CPU_HOTPLUG_DISABLED:
> > > >         case CC_ATTR_GUEST_MEM_ENCRYPT:
> > > >         case CC_ATTR_MEM_ENCRYPT:
> > > >                 return true;
> > > > diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_proc=
essor.c
> > > > index 6737b1cbf6d6..b960db864cd4 100644
> > > > --- a/drivers/acpi/acpi_processor.c
> > > > +++ b/drivers/acpi/acpi_processor.c
> > > > @@ -15,6 +15,7 @@
> > > >  #include <linux/kernel.h>
> > > >  #include <linux/module.h>
> > > >  #include <linux/pci.h>
> > > > +#include <linux/cc_platform.h>
> > > >=20
> > > >  #include <acpi/processor.h>
> > > >=20
> > > > @@ -357,6 +358,17 @@ static int acpi_processor_add(struct acpi_devi=
ce *device,
> > > >         struct device *dev;
> > > >         int result =3D 0;
> > > >=20
> > > > +       /*
> > > > +        * If the confidential computing platform doesn't support A=
CPI
> > > > +        * memory hotplug, the BIOS should never deliver such event=
 to
> > > > +        * the kernel.  Report ACPI CPU hot-add as a BIOS bug and i=
gnore
> > > > +        * the new CPU.
> > > > +        */
> > > > +       if (cc_platform_has(CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED)) { =
=20
> > >=20
> > > This will affect initialization, not just hotplug AFAICS.
> > >=20
> > > You should reset the .hotplug.enabled flag in processor_handler to
> > > false instead. =20
> >=20
> > Hi Rafael,
> >=20
> > Thanks for the review.  By "affect initialization" did you mean this
> > acpi_processor_add() is also called during kernel boot when any logical=
 cpu is
> > brought up?  Or do you mean ACPI CPU hotplug can also happen during ker=
nel boot
> > (after acpi_processor_init())?
> >=20
> > I see acpi_processor_init() calls acpi_processor_check_duplicates() whi=
ch calls
> > acpi_evaluate_object() but I don't know details of ACPI so I don't know=
 whether
> > this would trigger acpi_processor_add().
> >=20
> > One thing is TDX doesn't support ACPI CPU hotplug is an architectural t=
hing, so
> > it is illegal even if it happens during kernel boot.  Dave's idea is th=
e kernel
> > should  speak out loudly if physical CPU hotplug indeed happened on (BI=
OS) TDX-
> > enabled platforms.  Otherwise perhaps we can just give up initializing =
the ACPI
> > CPU hotplug in acpi_processor_init(), something like below?
>=20
> The thing is that by the time ACPI machinery kicks in, physical hotplug
> has already happened and in case of (kvm+qemu+ovmf hypervisor combo)
> firmware has already handled it somehow and handed it over to ACPI.
> If you say it's architectural thing then cpu hotplug is platform/firmware
> bug and should be disabled there instead of working around it in the kern=
el.
>=20
> Perhaps instead of 'preventing' hotplug, complain/panic and be done with =
it.

Hi Igor,

Thanks for feedback.  Yes the current implementation actually reports CPU h=
ot-
add as BIOS bug.  I think I can report BIOS bug for hot-removal too.  And
currently I actually used BUG() for the hot-removal case.  For hot-add I di=
dn't
use BUG() but rejected the new CPU as the latter is more conservative.=20

Hi Rafael,

I am not sure I got what you mean by "This will affect initialization, not =
just
hotplug AFAICS", could you elaborate a little bit?  Thanks.


--=20
Thanks,
-Kai


