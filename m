Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF2757AAB5
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 01:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235993AbiGSXy4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 19:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiGSXyz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 19:54:55 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC1F32057;
        Tue, 19 Jul 2022 16:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658274895; x=1689810895;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=aqsfJe34HmS8HnvW2mJHKpwVN/eAmyfAu5CYq9PPFsQ=;
  b=HvjhOfU9pbWLAYKzJNaUynsl15Al0xAyU95YsRLBD0EmLFOUbaxMvfQz
   4Adi/dsgfR+/lBqG+nPK6cSKDT2eKrSL64Ne2kyuAb5l6MT2Nzkhczihl
   CcC0sZtJX66mtKH5NVkmHVOusFEqZKgqFO4jGleQKUWc6bGMhDIOgLqWB
   Y67BXytBcJKkHe+aC5fuG+vZHjVWcprwjPJWzhxIT/GFIVC9LvSuEKk2/
   e7zcp63fOuJZi/6ZvQSj06MGJZoEZmlQF4WAJrrJcn+H6qKT4XOycheAp
   hNGdwqz5pxjJZEzDm4byPSxLz5qBH5wVXSSEFFh2dtwEpHVQQWMN9+SVi
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="287382262"
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="287382262"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 16:54:54 -0700
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="843843471"
Received: from ecurtis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.162.137])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 16:54:49 -0700
Message-ID: <b14ef9354392474b0988dde063bdb186a48424a8.camel@intel.com>
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
Date:   Wed, 20 Jul 2022 11:54:47 +1200
In-Reply-To: <baaae4b3-7f7d-b193-3546-70170b8b460d@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <f4bff93d83814ea1f54494f51ce3e5d954cf0f5b.1655894131.git.kai.huang@intel.com>
         <43a67bfe-9707-33e0-2574-1e6eca6aa24b@intel.com>
         <5ebd7c3cfb3ab9d77a2577c4864befcffe5359d4.camel@intel.com>
         <173b20166a77012669fdc2c600556fca0623d0b1.camel@intel.com>
         <baaae4b3-7f7d-b193-3546-70170b8b460d@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-07-19 at 10:46 -0700, Dave Hansen wrote:
> On 7/13/22 04:09, Kai Huang wrote:
> ...
> > "TDX doesn=E2=80=99t support adding or removing CPUs from TDX security =
perimeter. The
> > BIOS should prevent CPUs from being hot-added or hot-removed after plat=
form
> > boots."
>=20
> That's a start.  It also probably needs to say that the security
> perimeter includes all logical CPUs, though.

To me it is kinda implied.  But I have sent email to TDX spec owner to see
whether we can say it more explicitly.

>=20
> >  static int acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
> >  {
> > @@ -819,6 +820,12 @@ int acpi_map_cpu(acpi_handle handle, phys_cpuid_t =
physid,
> > u32 acpi_id,
> >  {
> >         int cpu;
> > =20
> > +       if (platform_tdx_enabled()) {
> > +               pr_err("BIOS bug: CPU (physid %u) hot-added on TDX enab=
led
> > platform. Reject it.\n",
> > +                               physid);
> > +               return -EINVAL;
> > +       }
>=20
> Is this the right place?  There are other sanity checks in
> acpi_processor_hotadd_init() and it seems like a better spot.

It has below additional check:

        if (invalid_phys_cpuid(pr->phys_id))
                return -ENODEV;
       =20
        status =3D acpi_evaluate_integer(pr->handle, "_STA", NULL, &sta);
        if (ACPI_FAILURE(status) || !(sta & ACPI_STA_DEVICE_PRESENT))
                return -ENODEV;


I don't know exactly when will the first "invalid_phys_cpuid()" case happen=
, but
the CPU is enumerated as "present" only after the second check.  I.e. if BI=
OS is
buggy and somehow sends a ACPI CPU hot-add event to kernel w/o having the C=
PU
being actually hot-added, the kernel just returns -ENODEV here.

So to me, adding to acpi_map_cpu() is more reasonable, because by reaching =
here,
it is sure that a real CPU is being hot-added.


>=20
> >         cpu =3D acpi_register_lapic(physid, acpi_id, ACPI_MADT_ENABLED)=
;
> >         if (cpu < 0) {
> >                 pr_info("Unable to map lapic to logical cpu number\n");
> > @@ -835,6 +842,10 @@ EXPORT_SYMBOL(acpi_map_cpu);
> > =20
> >  int acpi_unmap_cpu(int cpu)
> >  {
> > +       if (platform_tdx_enabled())
> > +               pr_err("BIOS bug: CPU %d hot-removed on TDX enabled pla=
tform.
> > TDX is broken. Please reboot the machine.\n",
> > +                               cpu);
> > +
> >  #ifdef CONFIG_ACPI_NUMA
> >         set_apicid_to_node(per_cpu(x86_cpu_to_apicid, cpu), NUMA_NO_NOD=
E);
> >  #endif
>=20

