Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A8F55B78D
	for <lists+kvm@lfdr.de>; Mon, 27 Jun 2022 07:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbiF0FGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 01:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232646AbiF0FGB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 01:06:01 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409C95F53;
        Sun, 26 Jun 2022 22:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656306358; x=1687842358;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=0mUOvxc+ZUex0L9Vx4tMzGBNSSGLbqJptTbWN4fqt6E=;
  b=jX35jm+pqWi9XEWOSMjX5AiBSuzDA5jHHUy+XhB48GN+QYN2b+/bJjol
   ln2IgvXJhOArhGpqnoM8lrbW9UO05fZRaTDFqCsq28M9l5AXKHTCbcP2w
   vr6bM7dIO5eBNtVdQ9LfFM0GTr2CrG2PHWWu81/0xiiFk8v45x/dhi1lD
   8QifAngCUis6N81WbbX2ffuKkF72gcNj7o1zj6yXNPms0Sj4jXlWCg+Jj
   JPopXK5F7XhKZGnzfHBSY9evpHEG8tb9UWOlDeuyG+mkdFBH5D5pmgU49
   ciIzffE49Bdwk3e9lvD9NQkCxX5Xm6nuJ71QtuOsRcPhmr361V35qg3aw
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10390"; a="282447445"
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="282447445"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2022 22:05:57 -0700
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="646248669"
Received: from fzaeni-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.88.6])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2022 22:05:52 -0700
Message-ID: <5ebd7c3cfb3ab9d77a2577c4864befcffe5359d4.camel@intel.com>
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
Date:   Mon, 27 Jun 2022 17:05:50 +1200
In-Reply-To: <43a67bfe-9707-33e0-2574-1e6eca6aa24b@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <f4bff93d83814ea1f54494f51ce3e5d954cf0f5b.1655894131.git.kai.huang@intel.com>
         <43a67bfe-9707-33e0-2574-1e6eca6aa24b@intel.com>
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

On Fri, 2022-06-24 at 11:57 -0700, Dave Hansen wrote:
> On 6/22/22 04:15, Kai Huang wrote:
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
>=20
> So, the kernel is now declaring ACPI CPU hotplug and TDX to be
> incompatible and even BUG()'ing if we see them together.  Has anyone
> told the firmware guys about this?  Is this in a spec somewhere?  When
> the kernel goes boom, are the firmware folks going to cry "Kernel bug!!"?
>=20
> This doesn't seem like something the kernel should be doing unilaterally.

TDX doesn't support ACPI CPU hotplug (both hot-add and hot-removal) is an
architectural behaviour.  The public specs doesn't explicitly say  it, but =
it is
implied:

1) During platform boot MCHECK verifies all logical CPUs on all packages th=
at
they are TDX compatible, and it keeps some information, such as total CPU
packages and total logical cpus at some location of SEAMRR so it can later =
be
used by P-SEAMLDR and TDX module.  Please see "3.4 SEAMLDR_SEAMINFO" in the=
 P-
SEAMLDR spec:

https://cdrdv2.intel.com/v1/dl/getContent/733584

2) Also some SEAMCALLs must be called on all logical CPUs or CPU packages t=
hat
the platform has (such as such as TDH.SYS.INIT.LP and TDH.SYS.KEY.CONFIG),
otherwise the further step of TDX module initialization will fail.

Unfortunately there's no public spec mentioning what's the behaviour of ACP=
I CPU
hotplug on TDX enabled platform.  For instance, whether BIOS will ever get =
the
ACPI CPU hot-plug event, or if BIOS gets the event, will it suppress it.  W=
hat I
got from Intel internally is a non-buggy BIOS should never report such even=
t to
the kernel, so if kernel receives such event, it should be fair enough to t=
reat
it as BIOS bug.

But theoretically, the BIOS isn't in TDX's TCB, and can be from 3rd party..

Also, I was told "CPU hot-plug is a system feature, not a CPU feature or In=
tel
architecture feature", so Intel doesn't have an architectural specification=
 for
CPU hot-plug.=20

At the meantime, I am pushing Intel internally to add some statements regar=
ding
to the TDX and CPU hotplug interaction to the BIOS write guide and make it
public.  I guess this is the best thing we can do.

Regarding to the code change, I agree the BUG() isn't good.  I used it beca=
use:
1) this basically on a theoretical problem and shouldn't happen in practice=
; 2)
because there's no architectural specification regarding to the behaviour o=
f TDX
when CPU hot-removal, so I just used BUG() in assumption that TDX isn't saf=
e to
use anymore.

But Rafael doesn't like current code change either. I think maybe we can ju=
st
disable CPU hotplug code when TDX is enabled by BIOS (something like below)=
:

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

This approach is cleaner I think, but we won't be able to report "BIOS bug"=
 when
ACPI CPU hotplug happens.  But to me it's OK as perhaps it's arguable to tr=
eat
it as BIOS bug (as theoretically BIOS can be from 3rd party).=C2=A0

What's your opinion?

--=20
Thanks,
-Kai


