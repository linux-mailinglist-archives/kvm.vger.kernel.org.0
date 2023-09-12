Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE9979C3B7
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 05:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241200AbjILDIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 23:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235370AbjILDH4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 23:07:56 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051891847BB;
        Mon, 11 Sep 2023 18:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694483284; x=1726019284;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5cvYCzadl2SnE5hP3+G9QNhDTtdJBA1K1aAXx8q51tA=;
  b=gh7dZKsAdKngW/pRqGntpIQfv7XO2DVsxSi6YWTp+aHmpzRUkXVi66H6
   37x7DOsbO3jos1Xy70nT+9SV9BDD1QGAcbRkSrqQ9HG4XFkJQTZ+T4Wag
   BY9j4x+DJUMHAepcabbax7xTQ19Vd2Ovhbh+fqqUrYfawBTkIY2NhnPv9
   IfdlDJN2oPu/tgB0NLvAFaf4YC0KWSLKHd0VDV6Oa/NoqecPsSOQePGOQ
   B76EK9dt3GSHm7zS2hCMGIPvnOQc87EapfZ2jzsQWOF+zaW3gGh9W3Clj
   aWORcY08d2mS2AkGbb1W66Nu73/BkVEPZ1lU0TplxSGhzLYk73l6Mb/vw
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="368507146"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="368507146"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 18:48:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="736956452"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="736956452"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2023 18:48:03 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 11 Sep 2023 18:48:02 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 11 Sep 2023 18:48:02 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 11 Sep 2023 18:47:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W3RifcXNuLaXr2A+0PwDIZMA9AVYOaX+ujy+i7ccqd702OxMQbDziMahbkjtY9kJlp9PNIriQTfXrKqsbCKQlf/5jBC1bvunZmqoEDoMyEz/JmpD1ewT06CtauKgZCiaK6hHfZylv5EihKVgAD8rm8XqA/titEMMmATYnOKfwFtx6XWTFI/SpNmrt5zQXLbdqyzvTmq3eeYuyWNUJN9/6cV2hMVmrIWOd3b5AO/DtwTe8S8DkDPltjg1JSKuCnQSadt0wtFNonVWHgKeP585OUEEym24t8PE87Am0i/Fd1Vkji0+gSIiewOu+S+sEoffsap+U684BzU2+ZBFRMolDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XlktrlwE2z5jC+9qFQDw/KgPtGkAWk9jnizYQ2434Z4=;
 b=iNxGXRbw+dtOEzZoQ823XzzOiqacWjBtOnvha1IW1GDlZi4pP4zJL6ALdS1Y7UgRSZstj1Bf73JmYE8xqTws9twypg5MdKY9Gc1tT1hr0+ILFgAtrMekvF+w04ZBwPzd5v761eCfXxHTKrw7gSTpzPavV8bqwzLbQ3VELKQVnG8QPb4tvOWc11dlc2/CFzaAg9hsNslpOF/DtVN2ZsJ4gO88C4BCYoXB6oTynIhjgT11m+89N2tXyC5DE/tRZ8eimk/WTN8DEU7usf0ZvVh+u6IDemDzoPOwx7UF7tcD15CPyqTvMVkz+WwbkYnLLrdwNN4zcBR7M5OVL5EoYLBmeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by MW4PR11MB6885.namprd11.prod.outlook.com (2603:10b6:303:21b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Tue, 12 Sep
 2023 01:47:55 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5d9f:7e54:4218:159f]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5d9f:7e54:4218:159f%7]) with mapi id 15.20.6768.029; Tue, 12 Sep 2023
 01:47:55 +0000
Date:   Tue, 12 Sep 2023 09:47:43 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Manali Shukla <manali.shukla@amd.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>,
        <linux-doc@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <x86@kernel.org>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <bp@alien8.de>, <santosh.shukla@amd.com>, <ravi.bangoria@amd.com>,
        <thomas.lendacky@amd.com>, <nikunj@amd.com>
Subject: Re: [PATCH 01/13] KVM: Add KVM_GET_LAPIC_W_EXTAPIC and
 KVM_SET_LAPIC_W_EXTAPIC for extapic
Message-ID: <ZP/DP+JotXLQUsEP@chao-email>
References: <20230904095347.14994-1-manali.shukla@amd.com>
 <20230904095347.14994-2-manali.shukla@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230904095347.14994-2-manali.shukla@amd.com>
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|MW4PR11MB6885:EE_
X-MS-Office365-Filtering-Correlation-Id: b7fee3a7-3a1b-4f3b-ad35-08dbb3324896
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nx+Mtvo+wFdQx6wSL9h71eSTaldJq6eYaCTuO0mpgc/4INDp1cjTEmtLpekFdpbuDEZ2PR0yi/+AN+x4XOKRZALXApyKlfEvZ03a3q1X5EnbOER+pn/RJ24rKGtpj/Yi8lKNa9aXgu8IE6jQHgEP1G8tX00zkDt4UWD5VmGVvgYjpBWS8XrPygYSJGjmz1aE4pwX+wRyZxjOWkpikcG8B9CX4ZdHCGzHGU3tr2/Nfqi6IqamTbzPEc0u9HqF8PJTtMSf5wAk4rF0A6tN9Ajh7sOhGmaOibiZzV21o6X9OCC7JHETGzfeG/ssv6igRrqxY+vpk63tenr9Q+WsD9ak4O/WnC9DeHJQxaFICCevTr0EyFEntP4DWDUUWD3dtRkSy4nsZehSI8Jh3flGt6EovjyIpJw2HWu1JvE9bcVkJxeu/Bifida9U4jlaYN5q8/BXFJs7i8jbzR/+DcLzPrOk6mm7wXKTuCP0WXJw8vp0p2BsgCsgsgDtnGvo3dzQrx9jnzryhHHwSKTYQN4dC8x+U7exdkilwoMO9SfnZm9bW8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(376002)(346002)(396003)(136003)(39860400002)(366004)(1800799009)(451199024)(186009)(5660300002)(6512007)(6666004)(6486002)(6506007)(86362001)(82960400001)(38100700002)(33716001)(26005)(9686003)(478600001)(83380400001)(66476007)(4326008)(8936002)(66946007)(8676002)(41300700001)(44832011)(7416002)(2906002)(316002)(6916009)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OJbBWZEGLnaEAo1hKB5MHxWImfNKWCYXN2mGMV7rW/qu1jGCQf/fiEcv3tV3?=
 =?us-ascii?Q?Y0MnPWEtOuuQq6kz2gxxucB7NsBjZU0NEP5YHX887tMrxdS605SBRyyuzy49?=
 =?us-ascii?Q?Xe0keRcqOomHggQc8TOd5jh46W0FMr2VJ8K8850LJaTBEniLyXnR069Q+V6f?=
 =?us-ascii?Q?KY0CBpPZ79i37vFF7Fgz2KtKT1D6iYT9khLONru7PiIui9QOjHvO1DBOqMm8?=
 =?us-ascii?Q?Nbw40Iq+biD9JyuTebDiFUCdTsT204RoHol3lctobvvTRUkHh41zgpqvztBE?=
 =?us-ascii?Q?3ZA7i4aLBCI8TNi63GoK++ATjyeFuxmmPjBcWWkhWt6rqDzpmCl8k8xAZMrd?=
 =?us-ascii?Q?zUTahYRAzrKiPUXDk9XUaxaf76eUvx1VQuBQMH7s6s5foPnFXl0I0vJw2kxY?=
 =?us-ascii?Q?NqVY0ekQf/vpVs088o0uk6sX69zC2m4T/te1BlKXDB2SL0P1HmzJGJ+BlEQW?=
 =?us-ascii?Q?fRtPuh0wt76v3sbkvFQ3G4LCY24jzuYS0WKxTnIRqvmZ6IanZIWQcow9rfBd?=
 =?us-ascii?Q?XVPnv8SBuZ6W0TWU11ziHIwBYBhdcvG756D1f7GB1t2wZT5Uy//QrAeCR7W/?=
 =?us-ascii?Q?MVlFKgqf65Rd7fehUBHWXi/pKwxogsw+1/rsubApSYNXpdtiQEPpMxJLS1Wp?=
 =?us-ascii?Q?B2AcyIbeNKf3ICS8wghmVPX1X0vPMKOZFdTfXf6nbl8aI/d3pFY2XeSeo/Q+?=
 =?us-ascii?Q?TzWPRu/oIPOw9gM3THdFzJXLu845Y+ZrFiPE++AQKWovj2YdNyTUKSSI5XP1?=
 =?us-ascii?Q?zR5cjoMDHFoboDu3fQznIXj+Kj3339aXSS9+FhB6yzQV19FD06aIuCTbg1/2?=
 =?us-ascii?Q?HqXR8YctFYZSi6Js/l0TShkfz55aKJ1eLux5NnacY/c1mYgdQCfFvuvkOkNe?=
 =?us-ascii?Q?Ya0rijqhBgZHoJsyulNztompimoceASDxpZhGu0cZckKT3jYJbXMaz0yKjUE?=
 =?us-ascii?Q?/ApNIovMfCdltE8T1/YiwZb2UdaovUK8RWeIYjGLU5w73NDtu/GDT5WqgDXs?=
 =?us-ascii?Q?NIGQaQfmwjipR1d2D/9bYBWGOxLuqNHHDQ4HYoyOfg/4sjNvsfPPEQXIBvtR?=
 =?us-ascii?Q?WItQLPsE1VlubQ4I0/HHrgxRLvLy5U4Eo9zO9areBm9pzbhkpEvhNeElgU1t?=
 =?us-ascii?Q?7aRIRIjiQRZZMdMuty0mwcyBXHusP1YxPLDAVj1NO64GxmSnx9vjQrQadEQg?=
 =?us-ascii?Q?6kQt+jMG34aEtjSJ1GQ/54IpmChOydgqIScXrCELsHijq2s0uZHyXoUovX8Q?=
 =?us-ascii?Q?pCEEpVKEhfcG2lSOJYg98Qk+xC572IwxtjpNm9QmCUu3uKVFK1yVlGFRngdC?=
 =?us-ascii?Q?eqZK6eKKWoOwawpslKyhSnngOZDrUXPrfZRNm/bApgX3vI25fsE2B+s5Lntt?=
 =?us-ascii?Q?4yzkliH3HkcnF1UDt8RpDat9EqhxWVctJKTITNnV+Mqzaxmkq9nm4iuWbLby?=
 =?us-ascii?Q?cYam8StAOOIZbq9DBY1ZskUNeP1pOuyc37pSiFJJ8dh/vs5MfYqnbXAbfzGb?=
 =?us-ascii?Q?zldssprKR5dOG59v9wJLGPRedpDFdfNQqf+ZywWVwsiaBQB4k+0vIxPoncE1?=
 =?us-ascii?Q?lV6cR2j5rv8wwN0NNZYZX4fsAKaBQItkwUeKpcrn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b7fee3a7-3a1b-4f3b-ad35-08dbb3324896
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 01:47:55.4092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nhOViMtszLwG8TttzEugxQi54B2d+6ZN1PWQCtpwBITPZrDaTQh6+t8tlpyL26oNaPWMTeM8jd35hO/npWI6dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6885
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 04, 2023 at 09:53:35AM +0000, Manali Shukla wrote:
>There are four additional extended LVT registers available in extended
>APIC register space which can be used for additional interrupt sources
>like instruction based sampling and many more.
>
>Please refer to AMD programmers's manual Volume 2, Section 16.4.5 for
>more details on extapic.
>https://bugzilla.kernel.org/attachment.cgi?id=304653
>
>Adds two new vcpu-based IOCTLs to save and restore the local APIC
>registers with extended APIC register space for a single vcpu. It
>works same as KVM_GET_LAPIC and KVM_SET_LAPIC IOCTLs. The only
>differece is the size of APIC page which is copied/restored by kernel.
>In case of KVM_GET_LAPIC_W_EXTAPIC and KVM_SET_LAPIC_W_EXTAPIC IOCTLs,
>kernel copies/restores the APIC page with extended APIC register space
>located at APIC offsets 400h-530h.
>
>KVM_GET_LAPIC_W_EXTAPIC and KVM_SET_LAPIC_W_EXTAPIC IOCTLs are used
>when extended APIC is enabled in the guest.
>
>Document KVM_GET_LAPIC_W_EXTAPIC, KVM_SET_LAPIC_W_EXTAPIC ioctls.
>
>Signed-off-by: Manali Shukla <manali.shukla@amd.com>
>---
> Documentation/virt/kvm/api.rst  | 23 +++++++++++++++++++++++
> arch/x86/include/uapi/asm/kvm.h |  5 +++++
> arch/x86/kvm/lapic.c            | 12 +++++++-----
> arch/x86/kvm/lapic.h            |  6 ++++--
> arch/x86/kvm/x86.c              | 24 +++++++++++++-----------
> include/uapi/linux/kvm.h        | 10 ++++++++++
> 6 files changed, 62 insertions(+), 18 deletions(-)
>
>diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>index 73db30cb60fb..7239d4f1ecf3 100644
>--- a/Documentation/virt/kvm/api.rst
>+++ b/Documentation/virt/kvm/api.rst
>@@ -1961,6 +1961,18 @@ error.
> Reads the Local APIC registers and copies them into the input argument.  The
> data format and layout are the same as documented in the architecture manual.
> 
>+::
>+
>+  #define KVM_APIC_EXT_REG_SIZE 0x540
>+  struct kvm_lapic_state_w_extapic {
>+        __u8 regs[KVM_APIC_EXT_REG_SIZE];
>+  };

The size of this new structure is also hard-coded. Do you think it is better to
make the new structure extensible so that next time KVM needn't add more uAPIs
for future local APIC extensions?
