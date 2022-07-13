Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9555734F5
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 13:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbiGMLJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 07:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiGMLJj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 07:09:39 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB9BECB88;
        Wed, 13 Jul 2022 04:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657710577; x=1689246577;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=mluzyxZAImsv355695EcParOvoSEmCd7NTEboqAuATQ=;
  b=S1OZ1tH6c4XNbWkIUwmEYJmxtXV6n3OOQM1pfOpgStuIOweoj/gk2AWT
   inbOjwn9bq/Led7z3Pn1fmJ4uGZOOOAYMVC+hwglB8lRv5BGYVZI9NF9h
   BPjYRzwstJY9rF/UjN7kBqHomYwg+lyZBjApWUuHbkxCRm0CL6K24kpuJ
   P0zHcR5+2A/54OHNK2kIiSchHkwSBtTXqT/uJc1Bat9KqYOTQwC/LH7y3
   kMJGnS7aRvK9yZf4KetNG4mZWRqydpWKroghM9HYqDzai7UZv5wjeNutV
   xpgRPH3yR4PxHo5TrSL3iJfU/cR2KkR0Y0Kt9X1rXg7f9lDRTX/3k634K
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="264969301"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="264969301"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 04:09:34 -0700
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="622899198"
Received: from ifatima-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.1.196])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 04:09:29 -0700
Message-ID: <173b20166a77012669fdc2c600556fca0623d0b1.camel@intel.com>
Subject: Re: [PATCH v5 02/22] cc_platform: Add new attribute to prevent ACPI
 CPU hotplug
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-acpi@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, rdunlap@infradead.org, Jason@zx2c4.com,
        juri.lelli@redhat.com, mark.rutland@arm.com, frederic@kernel.org,
        yuehaibing@huawei.com, dongli.zhang@oracle.com
Date:   Wed, 13 Jul 2022 23:09:27 +1200
In-Reply-To: <5ebd7c3cfb3ab9d77a2577c4864befcffe5359d4.camel@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <f4bff93d83814ea1f54494f51ce3e5d954cf0f5b.1655894131.git.kai.huang@intel.com>
         <43a67bfe-9707-33e0-2574-1e6eca6aa24b@intel.com>
         <5ebd7c3cfb3ab9d77a2577c4864befcffe5359d4.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
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

On Mon, 2022-06-27 at 17:05 +1200, Kai Huang wrote:
> On Fri, 2022-06-24 at 11:57 -0700, Dave Hansen wrote:
> > On 6/22/22 04:15, Kai Huang wrote:
> > > Platforms with confidential computing technology may not support ACPI
> > > CPU hotplug when such technology is enabled by the BIOS.  Examples
> > > include Intel platforms which support Intel Trust Domain Extensions
> > > (TDX).
> > >=20
> > > If the kernel ever receives ACPI CPU hotplug event, it is likely a BI=
OS
> > > bug.  For ACPI CPU hot-add, the kernel should speak out this is a BIO=
S
> > > bug and reject the new CPU.  For hot-removal, for simplicity just ass=
ume
> > > the kernel cannot continue to work normally, and BUG().
> >=20
> > So, the kernel is now declaring ACPI CPU hotplug and TDX to be
> > incompatible and even BUG()'ing if we see them together.  Has anyone
> > told the firmware guys about this?  Is this in a spec somewhere?  When
> > the kernel goes boom, are the firmware folks going to cry "Kernel bug!!=
"?
> >=20
> > This doesn't seem like something the kernel should be doing unilaterall=
y.
>=20
> TDX doesn't support ACPI CPU hotplug (both hot-add and hot-removal) is an
> architectural behaviour.  The public specs doesn't explicitly say  it, bu=
t it is
> implied:
>=20
> 1) During platform boot MCHECK verifies all logical CPUs on all packages =
that
> they are TDX compatible, and it keeps some information, such as total CPU
> packages and total logical cpus at some location of SEAMRR so it can late=
r be
> used by P-SEAMLDR and TDX module.  Please see "3.4 SEAMLDR_SEAMINFO" in t=
he P-
> SEAMLDR spec:
>=20
> https://cdrdv2.intel.com/v1/dl/getContent/733584
>=20
> 2) Also some SEAMCALLs must be called on all logical CPUs or CPU packages=
 that
> the platform has (such as such as TDH.SYS.INIT.LP and TDH.SYS.KEY.CONFIG)=
,
> otherwise the further step of TDX module initialization will fail.
>=20
> Unfortunately there's no public spec mentioning what's the behaviour of A=
CPI CPU
> hotplug on TDX enabled platform.  For instance, whether BIOS will ever ge=
t the
> ACPI CPU hot-plug event, or if BIOS gets the event, will it suppress it. =
 What I
> got from Intel internally is a non-buggy BIOS should never report such ev=
ent to
> the kernel, so if kernel receives such event, it should be fair enough to=
 treat
> it as BIOS bug.
>=20
> But theoretically, the BIOS isn't in TDX's TCB, and can be from 3rd party=
..
>=20
> Also, I was told "CPU hot-plug is a system feature, not a CPU feature or =
Intel
> architecture feature", so Intel doesn't have an architectural specificati=
on for
> CPU hot-plug.=20
>=20
> At the meantime, I am pushing Intel internally to add some statements reg=
arding
> to the TDX and CPU hotplug interaction to the BIOS write guide and make i=
t
> public.  I guess this is the best thing we can do.
>=20
> Regarding to the code change, I agree the BUG() isn't good.  I used it be=
cause:
> 1) this basically on a theoretical problem and shouldn't happen in practi=
ce; 2)
> because there's no architectural specification regarding to the behaviour=
 of TDX
> when CPU hot-removal, so I just used BUG() in assumption that TDX isn't s=
afe to
> use anymore.

Hi Dave,

Trying to close how to handle ACPI CPU hotplug for TDX.  Could you give som=
e
suggestion?

After discussion with TDX guys, they have agreed they will add below to eit=
her
the TDX module spec or TDX whitepaper:

"TDX doesn=E2=80=99t support adding or removing CPUs from TDX security peri=
meter. The
BIOS should prevent CPUs from being hot-added or hot-removed after platform
boots."

This means if TDX is enabled in BIOS, a non-buggy BIOS should never deliver=
 ACPI
CPU hotplug event to kernel, otherwise it is a BIOS bug.  And this is only
related to whether TDX is enabled in BIOS, no matter whether the TDX module=
 has
been loaded/initialized or not.

So I think the proper way to handle is: we still have code to detect whethe=
r TDX
is enabled by BIOS (patch 01 in this series), and when ACPI CPU hotplug hap=
pens
on TDX enabled platform, we print out error message saying it is a BIOS bug=
.

Specifically, for CPU hot-add, we can print error message and reject the ne=
w
CPU.  For CPU hot-removal, when the kernel receives this event, the CPU hot=
-
removal has already handled by BIOS so the kernel cannot reject it.  So I t=
hink
we can either BUG(), or say "TDX is broken and please reboot the machine".

I guess BUG() would catch a lot of eyeball, so how about choose the latter,=
 like
below?

--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -799,6 +799,7 @@ static void __init acpi_set_irq_model_ioapic(void)
  */
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 #include <acpi/processor.h>
+#include <asm/tdx.h>
=20
 static int acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
 {
@@ -819,6 +820,12 @@ int acpi_map_cpu(acpi_handle handle, phys_cpuid_t phys=
id,
u32 acpi_id,
 {
        int cpu;
=20
+       if (platform_tdx_enabled()) {
+               pr_err("BIOS bug: CPU (physid %u) hot-added on TDX enabled
platform. Reject it.\n",
+                               physid);
+               return -EINVAL;
+       }
+
        cpu =3D acpi_register_lapic(physid, acpi_id, ACPI_MADT_ENABLED);
        if (cpu < 0) {
                pr_info("Unable to map lapic to logical cpu number\n");
@@ -835,6 +842,10 @@ EXPORT_SYMBOL(acpi_map_cpu);
=20
 int acpi_unmap_cpu(int cpu)
 {
+       if (platform_tdx_enabled())
+               pr_err("BIOS bug: CPU %d hot-removed on TDX enabled platfor=
m.
TDX is broken. Please reboot the machine.\n",
+                               cpu);
+
 #ifdef CONFIG_ACPI_NUMA
        set_apicid_to_node(per_cpu(x86_cpu_to_apicid, cpu), NUMA_NO_NODE);
 #endif


--=20
Thanks,
-Kai


