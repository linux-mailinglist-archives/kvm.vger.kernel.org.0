Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2913556F4C
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 02:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237881AbiFWAJD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 20:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiFWAJC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 20:09:02 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A421F340FD;
        Wed, 22 Jun 2022 17:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655942941; x=1687478941;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=l51kT0hSlFet5bjbRgkKhIH8A9wUJZ5R6t4yBpcTrXM=;
  b=Op0iwc+sbfAGk1taOlz+4Rb0zutb68Nc2RsULQS10kZMJgJE9piV7xz+
   wEsqkCasYnb0vS9w2QSQTX/FLWw63rAC75NAk0TcTOqXBQ6rf4edGmT+f
   s9I/vP7fsjbOd4ee/Dd6ri1MCKcxBmsuVu6esGCcLdd4JvbidLfOB5sNf
   CA/LNQT2rGzrIrMuGHNiKNHl6EWPObSmMIcWDBcb5q74y2YtuXM1mxSGe
   /MXmMhdXF0gH/f6jZYxoH9yZaiWCt+HxKK3ukkpU1dzA4d8Oee0DSBt6W
   nY+G0XUe7fcBSIARe749cspljkMMsJFF0YxD7ZcAzsVMGQJu9plCDsoQu
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="260398867"
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="260398867"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 17:09:01 -0700
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="677816654"
Received: from jmatsis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.178.197])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 17:08:57 -0700
Message-ID: <198860d65d277dbd30552526a707576db4281b29.camel@intel.com>
Subject: Re: [PATCH v5 03/22] cc_platform: Add new attribute to prevent ACPI
 memory hotplug
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
        isaku.yamahata@intel.com, Tom Lendacky <thomas.lendacky@amd.com>
Date:   Thu, 23 Jun 2022 12:08:55 +1200
In-Reply-To: <CAJZ5v0jEJNdmkidvcOiRn+OVt01D5095t+nyXaJHKsqEAOvcBQ@mail.gmail.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <87dc19c47bad73509359c8e1e3a81d51d1681e4c.1655894131.git.kai.huang@intel.com>
         <CAJZ5v0jEJNdmkidvcOiRn+OVt01D5095t+nyXaJHKsqEAOvcBQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-06-22 at 13:45 +0200, Rafael J. Wysocki wrote:
> On Wed, Jun 22, 2022 at 1:16 PM Kai Huang <kai.huang@intel.com> wrote:
> >=20
> > Platforms with confidential computing technology may not support ACPI
> > memory hotplug when such technology is enabled by the BIOS.  Examples
> > include Intel platforms which support Intel Trust Domain Extensions
> > (TDX).
> >=20
> > If the kernel ever receives ACPI memory hotplug event, it is likely a
> > BIOS bug.  For ACPI memory hot-add, the kernel should speak out this is
> > a BIOS bug and reject the new memory.  For hot-removal, for simplicity
> > just assume the kernel cannot continue to work normally, and just BUG()=
.
> >=20
> > Add a new attribute CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED to indicate th=
e
> > platform doesn't support ACPI memory hotplug, so that kernel can handle
> > ACPI memory hotplug events for such platform.
> >=20
> > In acpi_memory_device_{add|remove}(), add early check against this
> > attribute and handle accordingly if it is set.
> >=20
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  drivers/acpi/acpi_memhotplug.c | 23 +++++++++++++++++++++++
> >  include/linux/cc_platform.h    | 10 ++++++++++
> >  2 files changed, 33 insertions(+)
> >=20
> > diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotp=
lug.c
> > index 24f662d8bd39..94d6354ea453 100644
> > --- a/drivers/acpi/acpi_memhotplug.c
> > +++ b/drivers/acpi/acpi_memhotplug.c
> > @@ -15,6 +15,7 @@
> >  #include <linux/acpi.h>
> >  #include <linux/memory.h>
> >  #include <linux/memory_hotplug.h>
> > +#include <linux/cc_platform.h>
> >=20
> >  #include "internal.h"
> >=20
> > @@ -291,6 +292,17 @@ static int acpi_memory_device_add(struct acpi_devi=
ce *device,
> >         if (!device)
> >                 return -EINVAL;
> >=20
> > +       /*
> > +        * If the confidential computing platform doesn't support ACPI
> > +        * memory hotplug, the BIOS should never deliver such event to
> > +        * the kernel.  Report ACPI CPU hot-add as a BIOS bug and ignor=
e
> > +        * the memory device.
> > +        */
> > +       if (cc_platform_has(CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED)) {
>=20
> Same comment as for the acpi_processor driver: this will affect the
> initialization too and it would be cleaner to reset the
> .hotplug.enabled flag of the scan handler.
>=20
>=20

Hi Rafael,

Thanks for review.  The same to the ACPI CPU hotplug handling, this is ille=
gal
also during kernel boot.  If we just want to disable, then perhaps somethin=
g
like below?

--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -366,6 +366,9 @@ static bool __initdata acpi_no_memhotplug;
=20
 void __init acpi_memory_hotplug_init(void)
 {
+       if (cc_platform_has(CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED))
+               acpi_no_memhotplug =3D true;
+
        if (acpi_no_memhotplug) {
                memory_device_handler.attach =3D NULL;
                acpi_scan_add_handler(&memory_device_handler);


--=20
Thanks,
-Kai


