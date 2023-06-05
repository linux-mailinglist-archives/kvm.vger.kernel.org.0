Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B94722ACE
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 17:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbjFEPUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 11:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234755AbjFEPUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 11:20:34 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B59100;
        Mon,  5 Jun 2023 08:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685978427; x=1717514427;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gk78sYprnx5n6QVs5bBlZ+V8D0ozw2oW0DpThuY5vjg=;
  b=MwPW4e15IQk5BXw9zTlgnPoFWF30BkPlPo/egJx+Tg6iVo/FfIF4Hxbk
   uPzBPOp0v44xYNS6JmBPo88Eow9bvEF55nbYW4xSRmb+q0M2oRemClo/z
   aCCEsd7ifu7cjZV1NlsbSWdGjkS+enH9ZjthX8N2x/Qj+eC+Tq0H8Sow+
   zyvh4U5sBfK2Tq5B/Ku5Yogffkr4D4OecLunBTu3mIPp9As2QcPGbSGEd
   TCXCOCDUTKeiq1B2lEjyyBWSk5hVOCOOTAygZbMb/xIJtmAIZqcY4G1CP
   xGOIAzo5y/fuv4bWuFI9zFO1umtano5ZbLLbeqqPf78M+GA7F3xEqmk5l
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="345989015"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="345989015"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 08:20:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="659131197"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="659131197"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 05 Jun 2023 08:20:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 08:20:25 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 08:20:25 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 08:20:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZr3g02hv2vPUF4EZvzlubTyahedQcuV89BBvaNy4Y+Gup0nGhqd3ondHcF+CJkdR2ocRZqJ1ZpkS9vAIIPPpCddLKCN8YKWaDPl2nGVOynIM59g2UY6UHHf0csFrqbCMMOdRqU/ugdajUA9GviUXVJikbUGWd0OW+pvhzjjOA2BKUlUYZkONzLxfs6V2ZFLLDXVmz22dde0H1wLTok73tHMuMX6C4uA0Zgdzuka2U6UdfaeBQ33ID/TLu6PosgS1T1fBl8B4dAk9EyY7HBLkOpgXQj9+VZikdRzv94zF/LP2U+J230mTwzsxUKP00F6r4MVxAGAIeBJBj0HotJ+qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=04v/0PfOw+kM2WX0kXqG6yLccB/J5ilbBu6aoGA0buY=;
 b=SeLQvb1KSP+qZP180ha45Uh/h22A7edHF5noz6VLdwRtFM0MFE2gPJ8w+XdJG1lOHTFnBDx0dEd9MyFZoDM4PMWv7+sPp0LdEf14SkU6qzvfFtZoLgiFkl2qT7RaFMnJheolVqXXr6kIY8+loHCisQ0IQM/AQLNpf87xVBvZZ8mWBvixR0m2RyLxKP8WCXtUWNJhga0LeWWr3a0xfVpBDVa+7WFRVL8Zm5Cfiut++Rb54OoSWDIdvPSYcwwcNmBYehBCNpr2FeYQuMtFN3suU5lh4/tVjo1Jr1tvAejcO7PpXxoFb/PR+fvCOny89/h2GoLXbKUtzivkRLqwYDu91g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Mon, 5 Jun
 2023 15:20:20 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::e8f3:851f:3ddc:fdeb]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::e8f3:851f:3ddc:fdeb%6]) with mapi id 15.20.6455.028; Mon, 5 Jun 2023
 15:20:19 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        "Chen, Bo2" <chen.bo@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: RE: [PATCH v14 011/113] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Thread-Topic: [PATCH v14 011/113] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Thread-Index: AQHZkeUO9CJK5Ein70KPqCCkDQrVv697abhQ
Date:   Mon, 5 Jun 2023 15:20:19 +0000
Message-ID: <DS0PR11MB6373872D1536D6469B29159CDC4DA@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <37b118268ccf73d8e9cc1ef8f9fb7376fb732d60.1685333727.git.isaku.yamahata@intel.com>
In-Reply-To: <37b118268ccf73d8e9cc1ef8f9fb7376fb732d60.1685333727.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|PH8PR11MB6780:EE_
x-ms-office365-filtering-correlation-id: 39c2999b-b333-48f7-9c81-08db65d85fae
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t0lkMx3mF5X7hdWzcfyE0NNb3BtbwJgi0hufFu2C8PcHYon0OeqGM7OD8NeBmVsTPeDWjn2rJPBGukr30JXuimcFMbCG427HCnx899yAi2S4rUnrGTRdTJHWGdzoC4BBsYt/L70M/7km7WFsg8IFO1NcAShMZwQJ4iWTAzIj+iZCMlmwH/woZ1iWUZajAjj5t6obLLTP5h2U/rlLxk5PuEY+OwWQFUqVwsMqNdPGiC4HbosebkoOV2OVvmMN0h5MPbtvnus9FI8SkAEGZMKhkgJre6Wk7QQnby54zrlcT//vbKruT1XFjtxxfAodKZsA2/tWLlVJ/KDW8XoNTT7U5k7dcz8A4ZXYvNc9WRD/13ehkbmVZhRV2iBlfYmc0qGalMdpTkGXsYolEbvvutGutTn2uOkOz++/jKtMslivQdtX6NEudt3vHvbbss53Phx30NAzzZ1Im++R55uE3aYE7KjnY8RGcD9gyn4DM9xthxGqsmff1KzYR/Vv8pyWDaBb7O3TltVAcIz3dofYdcKqJzR2RpJwXV82uCLNHUW3RkKpGYaMHSL+5bLYjyn+GzfgP8ZVt6OvflIWEFkoNDsieO46dwxZKaC+4iUFjVZ8IHkXDU+LRaSw3lljKpRXgOGN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(396003)(39860400002)(136003)(366004)(451199021)(9686003)(53546011)(26005)(6506007)(38100700002)(83380400001)(41300700001)(7696005)(107886003)(186003)(71200400001)(478600001)(110136005)(54906003)(4326008)(66446008)(122000001)(64756008)(66476007)(66556008)(82960400001)(55016003)(316002)(66946007)(76116006)(5660300002)(8936002)(52536014)(8676002)(2906002)(86362001)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1E/g15wM5SIsCYCF7N4hSAvaKCKeRooxmmrevH0Ip/XN+TsX0ygf+fNM8+Oq?=
 =?us-ascii?Q?ROmJ+6RFsG5qNEXwi8GVYm0GZFTXT8pNdafKX7NcrkjJreBu9U/c19pfyb6j?=
 =?us-ascii?Q?+zd8VmCRMvb9BKLpsWFvB/fW2udwztiWEESWJ4u0SZqkXc3MsNcX/9d8ZzWQ?=
 =?us-ascii?Q?M8KNzOVKxBwjARwdPASuMnIm2Iv7owNuXREgkkhdlPoNaprCwKG2aF3n93Gb?=
 =?us-ascii?Q?DLNyqjz0jYRVQMpU1i3aGtjY5uRPWe1OVIFWWaMaj8mmZNJ0ptHFQZAfmyV8?=
 =?us-ascii?Q?m2OFJ6xx5wKkn2aGZR8ZTVxsjXKOdmbtWolkJ1alqmRpHyLgo7zNipvdbuUm?=
 =?us-ascii?Q?2feHqI5/BREefyJtkhAw9IoadF5LsvNWd8LXV2C4iMpN6yiizQfsQZ9UlDp7?=
 =?us-ascii?Q?PSLX6fXAJiY3n/GOu0FQTz5fH+W4eAWaGTSEsqnh0cKCL+PNsYdvd2lIWFIZ?=
 =?us-ascii?Q?nJRWRkm2kpscMQ0U4isyWUj04vNZcWsdfL/RDLhx8iALIOqpubtYHWe95yl3?=
 =?us-ascii?Q?R8k1Byfgp9Sg24JQIq29jm5i1wzCan+jD1Qi2jzhcFmroUpfdtW7Ln2gQ4tz?=
 =?us-ascii?Q?sNY1/UHfUqXiKUbMhvV6Qg1O38FFQsFcDY7tRSlkyHcyrF34m1aCCQ4+0pUW?=
 =?us-ascii?Q?IrA6nA8+pRYmpDy+mS+GE9IsPs+L4MozcqfHUO7hT924IfrmZUz3VQ+l0nE0?=
 =?us-ascii?Q?poNbqfSZvvVOOfz556thdLL3sxsVqttWbZhKCM3GYZlG4rNoY7rN6jdoP6WE?=
 =?us-ascii?Q?9/3e/oZEEG+MDq4fHAVJQLDTF5uh+j1amc+URjtwYCMy+zSPyUt4EPY2YOee?=
 =?us-ascii?Q?WiCB3ff8ys144IuypQK+Hkb+DEiXSeiR63mfEKZ+dJLhTRfiHLqNBLE3t0ZT?=
 =?us-ascii?Q?uF8TAIxSz4sXON2i7cH/LShO7B0v712hJ2lSssUKA/++BX0Q5527a+qPoshr?=
 =?us-ascii?Q?ZXecmFBuMI3Gp/RNWxkbgyGHHeIS39cxbq7m19XpDw3bQ1JH70wAdeNvBZCb?=
 =?us-ascii?Q?gelHUNLvu5ExqP4fWhPr97WUIsfVGi6Lwi91CaYNc9h6JSHbsrhNiSGtI3Pq?=
 =?us-ascii?Q?xD/Igd0vFBS5NeyI9zfXXY5iLBg4FaHrHcoE/SLmKaLvy5UcfarnvsRh3owX?=
 =?us-ascii?Q?l1ztthWYnHj0MnZO0VUbZ2tJEHvDxftF9iC58yeNcBsyibmVCGd7ZltmV2dD?=
 =?us-ascii?Q?eVbX8eVI/E+tB7eSb0Gujq7tP6evqowVQ1dfmEXtstyuer78kyxc2Yoq7xTt?=
 =?us-ascii?Q?hbppeqQ5B7udS4ngr5y/bsZfIZTQaCAQIU5mCT2WbX850ySVvFdpBnW3im1B?=
 =?us-ascii?Q?gu+rmiAowjlsMHByLWqCO89v+Qwb32T2i+tO7E5JPajHLDvXSu2tu/acdbdN?=
 =?us-ascii?Q?3kL8Nar5KHGP9Pcwc79oD0YNutDNrtbiLT9Mwt8DGIFP1PQ3OkXBr8+sSa2a?=
 =?us-ascii?Q?8tHFdLops948LIaTz3XRhLKhg46hviOpfmvN6KELJgKTU4OW48l8giaXSH5a?=
 =?us-ascii?Q?biQWuSGPZJWDMB/YQC/LFKaSMg2aB5PnNgYZgYduWPrchKd3Ndaps3t+q2S9?=
 =?us-ascii?Q?WbWS4hEPUO01qLKcGE+d0Qn/7TV4BzWPHE/nyaqe?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39c2999b-b333-48f7-9c81-08db65d85fae
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2023 15:20:19.5094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /Y160pT5Ym4kq8HGYpC1zhFyjleh4r2VJvbcJTZgkv1uFOkqUu12pJPwtgAihSyp59xlfL+6SBm1Fax3zY1Ftg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6780
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Monday, May 29, 2023 12:19 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>=20
> A VMM interacts with the TDX module using a new instruction (SEAMCALL).
> For instance, a TDX VMM does not have full access to the VM control
> structure corresponding to VMX VMCS.  Instead, a VMM induces the TDX
> module to act on behalf via SEAMCALLs.
>=20
> Export __seamcall and define C wrapper functions for SEAMCALLs for
> readability.
>=20
> Some SEAMCALL APIs donate host pages to TDX module or guest TD, and the
> donated pages are encrypted.  Such SEAMCALLs flush cache lines (typically=
 by
> movdir64b instruction), but some don't.  Those that don't clear cache lin=
es
> require the VMM to flush the cache lines to avoid cache line alias.
>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/tdx.h       |   4 +
>  arch/x86/kvm/vmx/tdx_ops.h       | 202
> +++++++++++++++++++++++++++++++
>  arch/x86/virt/vmx/tdx/seamcall.S |   2 +
>  arch/x86/virt/vmx/tdx/tdx.h      |   3 -
>  4 files changed, 208 insertions(+), 3 deletions(-)  create mode 100644
> arch/x86/kvm/vmx/tdx_ops.h
>=20
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h inde=
x
> 112a5b9bd5cd..6c01ab572c1f 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -104,10 +104,14 @@ static inline long tdx_kvm_hypercall(unsigned int
> nr, unsigned long p1,  bool platform_tdx_enabled(void);  int
> tdx_cpu_enable(void);  int tdx_enable(void);
> +u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
> +	       struct tdx_module_output *out);
>  #else	/* !CONFIG_INTEL_TDX_HOST */
>  static inline bool platform_tdx_enabled(void) { return false; }  static =
inline int
> tdx_cpu_enable(void) { return -EINVAL; }  static inline int tdx_enable(vo=
id)
> { return -EINVAL; }
> +static inline u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
> +			     struct tdx_module_output *out) { return
> TDX_SEAMCALL_UD; };
>  #endif	/* CONFIG_INTEL_TDX_HOST */
>=20
>  #endif /* !__ASSEMBLY__ */
> diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
> new file mode 100644 index 000000000000..893cc6c25f3b
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/tdx_ops.h
> @@ -0,0 +1,202 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* constants/data definitions for TDX SEAMCALLs */
> +
> +#ifndef __KVM_X86_TDX_OPS_H
> +#define __KVM_X86_TDX_OPS_H
> +
> +#include <linux/compiler.h>
> +
> +#include <asm/cacheflush.h>
> +#include <asm/asm.h>
> +#include <asm/kvm_host.h>
> +
> +#include "tdx_errno.h"
> +#include "tdx_arch.h"
> +#include "x86.h"
> +
> +static inline u64 kvm_seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
> +			       struct tdx_module_output *out) {
> +	u64 ret;
> +
> +	ret =3D __seamcall(op, rcx, rdx, r8, r9, out);
> +	if (unlikely(ret =3D=3D TDX_SEAMCALL_UD)) {
> +		/*
> +		 * TDX requires VMXON or #UD.  In the case of reboot or
> kexec,
> +		 * VMX is made off (VMXOFF) by kvm reboot notifier,
> +		 * kvm_reboot(), while TDs are still running.  The callers
> check
> +		 * the returned error and complain.  Suppress it by returning 0.
> +		 */

Curious how do the callers check the returned error when " Suppress
it by returning 0" here.


> +		kvm_spurious_fault();
> +		return 0;
> +	}
> +	return ret;
> +}
