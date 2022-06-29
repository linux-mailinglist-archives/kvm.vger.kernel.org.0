Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B5B55FB88
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 11:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbiF2JNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 05:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiF2JN2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 05:13:28 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9F927B0E;
        Wed, 29 Jun 2022 02:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656494008; x=1688030008;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=zOHATe1LWt9PXvV1uvutZ31aBHVhiH/1Whjdlp8A67Q=;
  b=kXOlX4aJ9fhJs3QvQyg23Ee0m0uR6FNjeIAVVNRTe4bkOZWKFe/QQGFs
   m4uswRTtCuviAySOght8nGyqr4xOICO8JvqkxlEQRN9Tgwq0SwcjLuExd
   diynBMiBB3zSfmvzPkAyBDxu9eLpjMID2F2Z6+en9nr4Oxps6eqwFhZ/p
   dMJmQfBTfNwwYHM8WHcZ7E1qJeOC/751QOL4leZ4QwXF/2mLGpTF5Jnxd
   U2LcS4b9jlxRKTDg0kFQI5qeAiHZynRmJBnc8jJueOg75q3TWezxPDJSN
   Prbrrd+rQsRKaIDJCL/VPRfDD7bB/OGjFmZAM/hrZSvnpjPOEL4DEgy16
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="270744415"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="270744415"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 02:13:27 -0700
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="917533030"
Received: from gregantx-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.119.76])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 02:13:23 -0700
Message-ID: <3ec0ce3857dbcad8706ae0690d66b54a478c9769.camel@intel.com>
Subject: Re: [PATCH v5 03/22] cc_platform: Add new attribute to prevent ACPI
 memory hotplug
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
        isaku.yamahata@intel.com, Tom Lendacky <thomas.lendacky@amd.com>
Date:   Wed, 29 Jun 2022 21:13:21 +1200
In-Reply-To: <20220629104850.07559fee@redhat.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <87dc19c47bad73509359c8e1e3a81d51d1681e4c.1655894131.git.kai.huang@intel.com>
         <CAJZ5v0jEJNdmkidvcOiRn+OVt01D5095t+nyXaJHKsqEAOvcBQ@mail.gmail.com>
         <20220628140112.661154cf@redhat.com>
         <ceb320a00eebd29d2031b94b6123ff31ba74c313.camel@intel.com>
         <20220629104850.07559fee@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-06-29 at 10:48 +0200, Igor Mammedov wrote:
> > Hi Rafael,=C2=A0 Igor,
> >=20
> > On my test machine, the acpi_memory_device_add() is not called for syst=
em
> > memory.=C2=A0 It probably because my machine doesn't have memory device=
 in ACPI.
> >=20
> > I don't know whether we can have any memory device in ACPI if such memo=
ry is
> > present during boot?=C2=A0 Any comments here?
>=20
> I don't see anything in ACPI spec that forbids memory device being presen=
t at
> boot.
> Such memory may also be present in E820, but in QEMU is not done as linux=
 used
> to
> online all E820 memory as normal which breaks hotplug. And I don't know i=
f it
> still true.
>=20
> Also NVDIMMs also use memory device, so they may be affected by this patc=
h as
> well.

AFAICT NVDIMM uses different device ID so won't be impacted.  But right the=
re's
no specification around "whether firmware will create ACPI memory device fo=
r
boot-time present memory", so I guess we need to treat it is possible.  So =
I
agree having the check at the beginning of acpi_memory_device_add() looks
incorrect. =20

Also as Christoph commented I'll give up introducing new CC attribute.

>=20
> >=20
> > And CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED is only true on TDX bare-metal
> > system,
> > but cannot be true in Qemu guest.=C2=A0 But yes if this flag ever becom=
es true in
>=20
> that's temporary, once TDX support lands in KVM/QEMU, this patch will sil=
ently
> break usecase.

I don't think so.  KVM/Qemu won't expose TDX to guest, so this code won't b=
e
true in guest.

--=20
Thanks,
-Kai


