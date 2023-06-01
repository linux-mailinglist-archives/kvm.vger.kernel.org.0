Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D069719DB5
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 15:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbjFANZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 09:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233698AbjFANZj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 09:25:39 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7709FE68;
        Thu,  1 Jun 2023 06:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685625910; x=1717161910;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wVPj7TTouWD4kBKv6S5VHhZLKNVFNc/KqYqpgJQFi/o=;
  b=Ve/C/4r2eYkuOWpxSIzYlVRsBJOe5WDGMD/8HpMy/74xUitZX0uOaQq7
   Xo8y8SpfMh7wQxmlhCCczlpYtuYpr97Lwcq00pMGYfK2B4cSGfkdQFd8K
   vrS9lYRk194YuavNm6SRx3kYNtEknpmnHQUWPmmwzivdqX9sNEjxhLnCK
   Dyp17gBj94S7jhv+nly7l3JGIwGyr4NqOgTmQYJ3hOqxRFImBkVR+QoSV
   qnvBeCFivA7rzLHTEQynSeEP/irJDHS38ntLZp04VZt0eUk5NtLhFkffY
   ddK2kTAWA8QRAlgk1Gt6mqxmyhfT1vGYyg1K3pQF2qtAvOg6xw2Jn/K/S
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="441917056"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="441917056"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 06:25:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="797150791"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="797150791"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Jun 2023 06:25:05 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 1 Jun 2023 06:25:04 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 1 Jun 2023 06:25:04 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 1 Jun 2023 06:25:04 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 1 Jun 2023 06:25:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UsOyTbUJnaOvUWPBs2hzK4sCb3wkGJ49N8C5AJ4APYHHQPuY6b4Q7BDN30NDPM1RkmHGexELq3JXv+s48dCDFEmP+/aLwj9j1nsoUULFO78bg/vHG/Mcf8xSo6gTXOIpliYampWBHdaNKUFEhADMgR6S4Sc8tPQbfspRa+i+ulK889xKHVn26v0CZcoKgJBoqmhe6zNudYT4k9TB1F0eWg+4PeaXNmIqby1jjlyi5c0yVEs4CAxVznuw0yfaGV3W6Upz/Suhsp2ftlwMLJxDcGDjOsWR6Bamu1ARFU+yFlegfPXG4srgzTTa3DBtnFJQhW1kEnAJbRfBSP2mo3QmKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P1HpM1LFRGmZYM6aBYfrYC18gvsGrPbfbr9LdyZOQzA=;
 b=bokXdltN+K9pHPJPUQtpMcl5EVJ1Cp2b7+f/azx4Yo3YOvv5N1nZ/XhUsd8WgjMo1MVImq64jNTcu0wLnv/162sgu2i4JtfVspXJkf/VLVaKwVYO0e7bf/YVwD3sYZ9mGZT6gTEoSI3ckaDs4wiOttZc3V32pxw69JzWzKz4y2XIVThGG8HZGc1kS064SvC/4wBvJ6nGlgwr7W5/ePWQFjsG785uMOKmFWaUsdyKe0NeWDFDmyasa6HagsuvMGuaH4Mx/uQDDdFeguuD0WpIdOWpomRsNCaakLRSBIZhOVmlL5j1yeOes8XFoYJVfsUcSmzanA/Vi358NxXxbYyT7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 SA2PR11MB4780.namprd11.prod.outlook.com (2603:10b6:806:11d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Thu, 1 Jun
 2023 13:24:36 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::14c:205:c858:1ef6]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::14c:205:c858:1ef6%7]) with mapi id 15.20.6411.021; Thu, 1 Jun 2023
 13:24:36 +0000
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
Thread-Index: AQHZkeUO9CJK5Ein70KPqCCkDQrVv691oygw
Date:   Thu, 1 Jun 2023 13:24:35 +0000
Message-ID: <DS0PR11MB63736AAA616C74E5F8316B1ADC499@DS0PR11MB6373.namprd11.prod.outlook.com>
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
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|SA2PR11MB4780:EE_
x-ms-office365-filtering-correlation-id: 54640215-4562-47c3-079a-08db62a38b50
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kG8YPpLPq7DrqeVN7+6A2qepRN0eemxh/fIMld2G8m43y81KVd4ynTCG/FWWI+xQHY1GvTOCtMi1U8/EuyINkA2lfQG1TFXvODsEjwMw6SbKPUXqdDkU3ION+FYdfwYOl/ME7r8gcomANOkQn7z/HiE6ZWHdDx9PHQCoIu34yKUKt2uhJzz9qgu7aaCohnCkQ5Bc0kIVLp+H+S//KIfN58Vx4xDLOYhkXWxuLV9Gj4bKiPPVUoEQAvcKDokZMG5g1FulbURJGEwae79P7nAZvtph/1CTemvRz4ykAnFFbIDq+hKTAAr2eFA+xZA9tQnqyCr0NlA9AdOS8dnTMHmEOo21QGGHe5pasy7AyFR0QxGG23J/ebp6TPHmoxxNPW2rEQE6sOxxvoi4G1AUFpGkyxmeJPPyF+gc6i1jkAonP6zkQJehYJDg8B79FOpgwjk9dmJO45/rQckG5UYOGB9IFRSf49BBXPvrCBA+7VPnP9r0jdorPgCQ2dTeiT5e6+C1EaP31eqP/EeSgAfaSmZu2CWWo2MdgHJC+fBg/NAIQ9KSf+gGRn7qW+Z5B+ct/tK0/mUyFI2u4yXpzG1S31a/QBWlETXpCcYQPckzsS37oRB2gupOBYRmuU+li1PEECaP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199021)(7696005)(41300700001)(9686003)(38070700005)(83380400001)(186003)(53546011)(33656002)(26005)(6506007)(2906002)(122000001)(82960400001)(38100700002)(55016003)(86362001)(8936002)(107886003)(52536014)(5660300002)(66446008)(66946007)(76116006)(110136005)(4326008)(316002)(66556008)(64756008)(66476007)(54906003)(478600001)(8676002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4Z9bi8xmmWXeai2X9wvtD9KKpp54Ad6UItMcxHSAA0PxJrImpt057nVp4Tnp?=
 =?us-ascii?Q?c0Nu56mqpC5UaHPvhk5/dSlIaqrgpIEw74Bhe+CFSzlgJb1yH92t1O10y88r?=
 =?us-ascii?Q?TxZZGeSKdZsmr9FZXVQQMU05IkOgfgFQfX6N1NBtWUDSjiJ8amFI0axyXwJF?=
 =?us-ascii?Q?7w9BlPTQYR92xk/Dr/jGnPgpv4glNhvLJ9BDF+8k8rHhOZZqTA+Zn4D7mBNC?=
 =?us-ascii?Q?Dg2JxTqiqDi+U0VWhr631rQJccEp9rRPozzMzRHuhOHeR1z1PtT5aWrJGSxg?=
 =?us-ascii?Q?W1eYzOVWvdNv6ip6EGTPxKm9bBqZsFgSCiRQobQWyRVEKneGGzH34ZAVfbub?=
 =?us-ascii?Q?B5Ln/51zVZc6+H+67V0D3Q9x3AUIfzg8jsKho3qHDYMSjrkDAEeXVuEvx9LC?=
 =?us-ascii?Q?Q2k7BQF+SwKySGvIX7EoUEtP5JPbth7tOf72ZLD0+85+udRUGEP27+MMyyW2?=
 =?us-ascii?Q?0ehwxULe0CQzM1M2jlx8n7YPMvibCEPusKPIC3+9fxOH6CRLBWjKaEbkeJms?=
 =?us-ascii?Q?UrQucL2ABYAsFPDhPRRtQUk19HQiey9oCcSY6/RZeYAm2K4JAs7TpOlcBquC?=
 =?us-ascii?Q?d/AvVbpfv7n6/LubIf6DrT0ZcHUBeVTBBP2VY8Rn/oMbahRJ8p41XIQSQQgD?=
 =?us-ascii?Q?56I3b/Q+96VFQKxLVYyz16U909r8pOS8s9xlJk7fXFSzPY5cprCO4OktgmEj?=
 =?us-ascii?Q?+jRBHJ+lQCc21TttK/2tiGOztsNrZlyd+Z4t6EHmVDcP2KeHm0OCoX/bNd2t?=
 =?us-ascii?Q?QY9pkHPBOkYj6eeG/7eNF8HHndBkD2grSi7jxJ0h0wKX/ipgW2Ul7RforBAV?=
 =?us-ascii?Q?9EZCFYvmgavM9sWqbebmEJeabkhh6s0QJIYtT4tuuQJO34/CXJ56KO4OxuNL?=
 =?us-ascii?Q?RO13akFB2iCCJJjcgwVIXnZf5t5jHfjyvSvPU6wcLtGSykjUCNsHTUGh8WSr?=
 =?us-ascii?Q?QyL77BN0fYVOHf6HqHsVKMlyardpgrNoBV0a9jCWQnaqe58do82AIEDVm7At?=
 =?us-ascii?Q?NshbeMQdBrpbCy9fZocgOW49B5aXesSjeod3xP3vQiOXPcts52iwuGq6ITkU?=
 =?us-ascii?Q?9GeUH+xI03CTHOSmSD+4N4CPQRXiZIS0/EjuC3MxgF84/qR1HHxSNCOkB3C9?=
 =?us-ascii?Q?H/JsjNI5zzdA0j5WKzJeQu01o7/ePdeBBQ90xGlvgg1hUiQD2vk/MMUfoDYg?=
 =?us-ascii?Q?GOgJVoiQdjyUAlsrHZ1/V8mNRctgC7bcbcMaX7/nWlpXfPAOdm8lb7AJ1dYy?=
 =?us-ascii?Q?0l9nkSsllvdx1lpCvfqZUrtXpsEIg1K0m33QETpl5+AbyYzhQV5bF+XCsZ6g?=
 =?us-ascii?Q?OlcMF99EgTkOZ9LUPDQi3uDext4CJzimG9PIL9ao50nlTFMJgLqZt9nqAuHb?=
 =?us-ascii?Q?PgdEsGFIxf6yEORYnoXePywZWHdY7YWaPFppe5iJv2Ba73DMvlPWtVzNeKgi?=
 =?us-ascii?Q?m/c452clIyk7nk0UAIoZ/HXRzBJowjLaHcYT/Ut4t7VA07SQXx1Q3ZlKOphe?=
 =?us-ascii?Q?YxGM1am8AlOcxZYDm/aydLQbw1ADS7nmtIKLze8ka5pryn1zaPOUBktwWcbd?=
 =?us-ascii?Q?xaSQwvw/7STlJhvkM1F0mBSvKdSjdTtLXlHvdEbZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54640215-4562-47c3-079a-08db62a38b50
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2023 13:24:35.9445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ywoZ3BONelMj7SgaR6woGc/S5BKGRjR96G+xlgQqc9sS1mRENY3K42niIe2AKB7e2SmUbtIbljJzQPSRA2sq6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4780
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

As discussed somewhere before, kvm_* is more common to be labelled for the
generic code. Would it be better to be named tdx_seamcall here?
