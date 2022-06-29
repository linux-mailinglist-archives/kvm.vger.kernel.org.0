Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C3655FBA0
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 11:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbiF2JSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 05:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiF2JSA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 05:18:00 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314762CCB5;
        Wed, 29 Jun 2022 02:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656494279; x=1688030279;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=M4aox62JIGpg6BWvZRuVLl3OKAsHPG5kA8/m6ocC2s4=;
  b=bXHF9d6/nspdF1zSW3NrdC24/oezUHKvuZe0tYp+sWBrda+d31hk/wbM
   dk8QbYGQTbQLPvZBV2uIzCsH/KLwWn0De/VhnJHGvS1HgmfrXkdPg2s2T
   S1aBiZZEbHCGD8HFMMXaBe+zfdbS7ukEUNHVrzGhOGx0VzH7j3eGATIDf
   1xL7cFF5Kcrf1nigSpOfJSa2C3nQ+qTjrepp/WriQddxl2xm4ygcpxCWA
   AXYUeLNivr0prkutSRNLFZOwjuD13pcdEuiBzjdtDgvIFzop23hz/Pu6W
   KJavLVjLQOvd76geKJTDRVrYiQW0OcCrtDmRX5ccFBzQVt4CLGKS1DoSY
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="345973995"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="345973995"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 02:17:58 -0700
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="617513347"
Received: from gregantx-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.119.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 02:17:51 -0700
Message-ID: <378228c30a12a12620fddd87d1c2c33fde07a25e.camel@intel.com>
Subject: Re: [PATCH v5 04/22] x86/virt/tdx: Prevent ACPI CPU hotplug and
 ACPI memory hotplug
From:   Kai Huang <kai.huang@intel.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     Chao Gao <chao.gao@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com
Date:   Wed, 29 Jun 2022 21:17:48 +1200
In-Reply-To: <20220629083555.wre7uab6schvifkg@yy-desk-7060>
References: <cover.1655894131.git.kai.huang@intel.com>
         <3a1c9807d8c140bdd550cd5736664f86782cca64.1655894131.git.kai.huang@intel.com>
         <20220624014112.GA15566@gao-cwp>
         <951da5eeb4214521635602ce3564246ad49018f5.camel@intel.com>
         <20220629083555.wre7uab6schvifkg@yy-desk-7060>
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

On Wed, 2022-06-29 at 16:35 +0800, Yuan Yao wrote:
> On Fri, Jun 24, 2022 at 11:21:59PM +1200, Kai Huang wrote:
> > On Fri, 2022-06-24 at 09:41 +0800, Chao Gao wrote:
> > > On Wed, Jun 22, 2022 at 11:16:07PM +1200, Kai Huang wrote:
> > > > -static bool intel_cc_platform_has(enum cc_attr attr)
> > > > +#ifdef CONFIG_INTEL_TDX_GUEST
> > > > +static bool intel_tdx_guest_has(enum cc_attr attr)
> > > > {
> > > > 	switch (attr) {
> > > > 	case CC_ATTR_GUEST_UNROLL_STRING_IO:
> > > > @@ -28,6 +31,33 @@ static bool intel_cc_platform_has(enum cc_attr a=
ttr)
> > > > 		return false;
> > > > 	}
> > > > }
> > > > +#endif
> > > > +
> > > > +#ifdef CONFIG_INTEL_TDX_HOST
> > > > +static bool intel_tdx_host_has(enum cc_attr attr)
> > > > +{
> > > > +	switch (attr) {
> > > > +	case CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED:
> > > > +	case CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED:
> > > > +		return true;
> > > > +	default:
> > > > +		return false;
> > > > +	}
> > > > +}
> > > > +#endif
> > > > +
> > > > +static bool intel_cc_platform_has(enum cc_attr attr)
> > > > +{
> > > > +#ifdef CONFIG_INTEL_TDX_GUEST
> > > > +	if (boot_cpu_has(X86_FEATURE_TDX_GUEST))
> > > > +		return intel_tdx_guest_has(attr);
> > > > +#endif
> > > > +#ifdef CONFIG_INTEL_TDX_HOST
> > > > +	if (platform_tdx_enabled())
> > > > +		return intel_tdx_host_has(attr);
> > > > +#endif
> > > > +	return false;
> > > > +}
> > >=20
> > > how about:
> > >=20
> > > static bool intel_cc_platform_has(enum cc_attr attr)
> > > {
> > > 	switch (attr) {
> > > 	/* attributes applied to TDX guest only */
> > > 	case CC_ATTR_GUEST_UNROLL_STRING_IO:
> > > 	...
> > > 		return boot_cpu_has(X86_FEATURE_TDX_GUEST);
> > >=20
> > > 	/* attributes applied to TDX host only */
> > > 	case CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED:
> > > 	case CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED:
> > > 		return platform_tdx_enabled();
> > >=20
> > > 	default:
> > > 		return false;
> > > 	}
> > > }
> > >=20
> > > so that we can get rid of #ifdef/endif.
> >=20
> > Personally I don't quite like this way.  To me having separate function=
 for host
> > and guest is more clear and more flexible.  And I don't think having
> > #ifdef/endif has any problem.  I would like to leave to maintainers.
>=20
> I see below statement, for you reference:
>=20
> "Wherever possible, don't use preprocessor conditionals (#if, #ifdef) in =
.c"
> From Documentation/process/coding-style.rst, 21) Conditional Compilation.
>=20
> >=20

This is perhaps a general rule.  If you take a look at existing code, you w=
ill
immediately find AMD has a #ifdef too:

static bool amd_cc_platform_has(enum cc_attr attr)
{
#ifdef CONFIG_AMD_MEM_ENCRYPT
        switch (attr) {
        case CC_ATTR_MEM_ENCRYPT:
                return sme_me_mask;

        case CC_ATTR_HOST_MEM_ENCRYPT:
                return sme_me_mask && !(sev_status & MSR_AMD64_SEV_ENABLED)=
;

        case CC_ATTR_GUEST_MEM_ENCRYPT:
                return sev_status & MSR_AMD64_SEV_ENABLED;

        case CC_ATTR_GUEST_STATE_ENCRYPT:
                return sev_status & MSR_AMD64_SEV_ES_ENABLED;

        /*
         * With SEV, the rep string I/O instructions need to be unrolled
         * but SEV-ES supports them through the #VC handler.
         */
        case CC_ATTR_GUEST_UNROLL_STRING_IO:
                return (sev_status & MSR_AMD64_SEV_ENABLED) &&
                        !(sev_status & MSR_AMD64_SEV_ES_ENABLED);

        default:
                return false;
        }
#else
        return false;
#endif
}

So I'll leave to maintainers.

Anyway as Christoph commented I'll give up introducing new CC attributes, s=
o
doesn't matter anymore.

--=20
Thanks,
-Kai


