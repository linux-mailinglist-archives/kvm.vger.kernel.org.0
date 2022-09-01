Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30EFE5A8D6C
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 07:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbiIAFjq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 01:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233093AbiIAFjp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 01:39:45 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6885A15A02;
        Wed, 31 Aug 2022 22:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662010196; x=1693546196;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=DPLKyzOm3ELsXfbdUH7Li/C9QHZDGB9be4FjB6q9qnE=;
  b=jpqWraSdq7pkwITD68dm/QVsRx9oSpbWMZhgXcZhYjJqUSmkOd32MVNG
   NlDVKAQw3PqnR8OxtaXXnplNCCD+gM+FwnffpfaYTqRblSoaT1yRM+cZv
   2GsbwCSW/TJofO0fuwUpDdKiX1SwOKz27YPaKLI4ejxcG2Ua/iCFYEmO1
   pGlYhmXnRp5KY4IN0MAZ9hNkXPLpVyHdcUutdjFOMtYAJ1HGfv7/nMmvt
   Mtb7XgSFxjz/76T0++KGSAfexvOKLOgewLEEXjymSFkIAKP2+fjAykyVz
   5gTML+utyH2YxOcRk5Qcm9n+sZtve/P0/whlRipdbubiGxWuXj/JsR6lT
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="276022009"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="276022009"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 22:29:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="788103820"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 31 Aug 2022 22:29:55 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 22:29:55 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 22:29:53 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 31 Aug 2022 22:29:53 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 31 Aug 2022 22:29:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VPTBqyMYlWBm5LxJJ86z0rh2/XG8rKhvZTFvouoDSobzCKgpGZUOo8qDvd7iq//cOc0kkFo9dZSUlZ6ElrPIGrllusWoV3G6KXdpMNRW5kr1TwdM5irb5LPrpx/f2tS89yU41IOSxydo0nv2CxwH95gcZI11Fjn2Z6foFmotL56p78Lmfoa1/IAzjuwF6X8Z8Er8SZ8g4l7Ejxc67WvanEAlLvHSHvAMGFfBHV2/W2Se1Hb6/IEOitsfgA5D12LaSdNYRDCnQeQz6tLeyK0FfoDOCcttaB606qNO2U0alMpYuHc3VfW1MRjxG7iiTCBPg/Fr8EG5x5Zg6XBOoVRaGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sGkXloklDybq6V+aLnp8y7osn1YsFuFI6lyNKlQdJv0=;
 b=B+zXV3HYzbSgmUwDME5a9xvb7Ltj9mOdGTkEMihZv4lTvxCr9/OO4+3dCqXItbXZHC6s1OPPSN2dr0pfr9dV03qeIccZoGy8wb9/UQ0BzqePQSkDAa0qyU+dJ9eyfxWgH76aAQe6dFbcMgIGoR60FgCPXQ96ALL9Mmm/nfKvjt6yM3r0XEoi/W37Y7FNwPxtbzjh7MSfjvdyYAqn50L7g8PvvOigN1t47YB2Jg4i6VrZpFn8nUheh1CiB38iX+G+YBbTubUqQa+xwWIDekokJjL4EjIibltPVys4Mn7vcklVrmwlzx3d6j53q9HQ5RfUDYRXb9sucWG4P9NMM35B7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by MW5PR11MB5785.namprd11.prod.outlook.com
 (2603:10b6:303:197::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Thu, 1 Sep
 2022 05:29:46 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e%7]) with mapi id 15.20.5566.021; Thu, 1 Sep 2022
 05:29:46 +0000
Date:   Thu, 1 Sep 2022 13:29:41 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     <isaku.yamahata@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>,
        "Will Deacon" <will@kernel.org>
Subject: Re: [PATCH v2 01/19] KVM: x86: Drop kvm_user_return_msr_cpu_online()
Message-ID: <YxBDRaAyRpyz/5Q+@gao-cwp>
References: <cover.1661860550.git.isaku.yamahata@intel.com>
 <f63a395ead4204d44cab3b734c99b07f54c38463.1661860550.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f63a395ead4204d44cab3b734c99b07f54c38463.1661860550.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG2PR04CA0176.apcprd04.prod.outlook.com
 (2603:1096:4:14::14) To MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ed42109-8858-4597-4378-08da8bdafb21
X-MS-TrafficTypeDiagnostic: MW5PR11MB5785:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A1ij599KFsKl7hEkGHjdhernxGsqnYCL4Dbtqj1e3TQL8mauARoPbObbXODoQ9ROu1vWz3NlcZ1HvNBW1gtVPhq+YSeoHZArmERrs6/u8lPeq4SWM6YbcSqHbZKdhKiP5523n7KGOr3ZkUd1zAuMBFjSkMPuQa8OMug2iSFzR437eOYbdKe2E2RONBTClp9l/DH7A8BERTnHE96Fe6NF2bXSGHAwZTmO+tlqjoqaZ7uDCDu7JucwTaO/zYpQiACc/3drr/ZpEGVcWpPuVXNPyAhKrdai1v7zj++0L5UGa37if9C1Zp9n7Be/Gfq3dqM2ey0Ofq4dW2/aEdK/XErnQJCumvVtjmqJfJyIBfoMKVOKWX36Mx/QD3YcXZQHBhlVOJ04zVv52on8XqiHJhQ/ddczhrkV4UMUfL+iqtlB0l7zl90gcKzRuYSUCP1SFnqPSYsT2bLW8PrM4YVr/SwJrw73NR4+WjqMeLYpiECIoEII52e2YA6Zj1swtJhfFoVeakK60mtW1VK8LALNfAc+5uD0qfdvaeII+zIGEozWceRnZI5NEilZBiKc+507Valt8JmTfNhBrNXxsf13GLQIE5qiMy10v3qNnJv7h6EkIp5XeO0fPlTKxMNfYqRXYlomYFA7ZMPxM3h3OkXRSPVrTn2YNW3T62w/fArkNSMKpdytGpPRXYD4vug4yga+PGdhv8vouprKiKznApywUVjf6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(136003)(39860400002)(376002)(366004)(396003)(33716001)(6512007)(44832011)(9686003)(38100700002)(6666004)(26005)(6506007)(2906002)(186003)(83380400001)(4326008)(66946007)(66556008)(316002)(66476007)(8676002)(5660300002)(82960400001)(6486002)(54906003)(41300700001)(6636002)(34206002)(478600001)(86362001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qwF9jb4SoFTj9DP+/Gfuci14XJiau0QoNkGp43ywt3ZnhVPN8NhMNHzdddVH?=
 =?us-ascii?Q?cLqY+m9ks/lQ/T8xKoZctouKB81NzTMZsx6+dVudkOSsn+YUmChM7V4VlWmW?=
 =?us-ascii?Q?K2lGdAO9j5w6yaajr7LZxcbZiVKPjJHQ1kZJbHF7AV5Eap3Un4YX+w2LeDOI?=
 =?us-ascii?Q?XGmhzy+PCZpx2NvKT3/CiKLA/T9us9FCmVRoDGOy4abAJYjTC37ztXAhmNtM?=
 =?us-ascii?Q?k5sjSCnVgsTYXclCvoQtoSu8TBc5i6nzZHOwkyQG7pMLS0R5kdmar+mHCqGo?=
 =?us-ascii?Q?I/+HxDF9wxGrzlgOYHZKtkc7ShUfxGt/FzidABGWxHRc5cs0qV4ddqIilSpy?=
 =?us-ascii?Q?jrjpqPzpfoBgfsiJYrEfBTRbWbydPhD0XICarYem35290bv0bgoQTHLQmRyS?=
 =?us-ascii?Q?UKYltzhLxyFSELEknIHcPyJjywm1DhETaHmL1um8Pz7F8d2X+K3iRIMHPj/R?=
 =?us-ascii?Q?NTwyTAFdJ2Cp60wpywT6Yq56vJMNFaKAIKO5ADI/cx5tl6jJmGR9wN9lMCK3?=
 =?us-ascii?Q?PgfnH1YaOV0fhzn8mm2OjzvgWyvRughEZuM7ZW/25k/+VhgIBE7L+rDe013b?=
 =?us-ascii?Q?tUVJdX5wXAuVdBOP8A33IEQ7YSx2QfdZNAhdBsB2Y2T2iomLZeKzDTcwTpk1?=
 =?us-ascii?Q?fk0lH04LxPCf7uOWS+46Q0KKlqwIPRy1Q8ReCNwgnLGpLu6b0JPQlUldmAqN?=
 =?us-ascii?Q?uVojW1WU8DxHLgXaez0qLCv6ZfNAdCBJPo6bfOX6aeoLK2isirLW0WG9gzrA?=
 =?us-ascii?Q?/yNHaajAAeziS6HEJzHGibj3TGZbP4WsdrOCa+PQHN6uMEEMXO3wgpZi9myp?=
 =?us-ascii?Q?MWFSrglYJ8i7Jm4xZnTw+P4fBFDDCzwmo4Q6Du9VKK9WDGONWcGS5aVW7169?=
 =?us-ascii?Q?PjLr9b5FTZppCkBMEYYJiwHO84fZKelkGnC7YqTFvVb8NEOFgjfDtNlHKeBP?=
 =?us-ascii?Q?vdcvWF3dedtA3VVICfE9kM1fdN3/EYM+M0fCaOjtiyWXvfLH8xx18bz5NqTJ?=
 =?us-ascii?Q?1Qv4ASYcRg3z5jxZZ+XlbMpqYomdLFC6X9RaYy+5e9UnSgtzBOS38LRSoiNM?=
 =?us-ascii?Q?MX96U76b+2E8pk5nWBq1nM9hurTwLHRFgEk/mtokKvVJniO2O1rOzoH+flrQ?=
 =?us-ascii?Q?LIBbQCFu5cmuKN0KN3ACz2iNsM8xKaRIxUTwrm/rzosL/gadPCF3R1n3g/X5?=
 =?us-ascii?Q?6ltp0t1D9JpYNZ8+P58b/RR0shHjYC7p3kYBmdMAf0kc3qEKdx25pd00xutb?=
 =?us-ascii?Q?FAgRxXlVbHtTtlRjkeO47o2RRfJpxHCN+D/lwfgI15+7/CoXJ82ievBXmN+s?=
 =?us-ascii?Q?AMKTPFF7ftjx0XsWpGy0tToBraMZ1SOxqyIQsNYIxXBWmos+W/L+zDhTaeH4?=
 =?us-ascii?Q?UsqzXxOmeL6+LxezDmzHkXipdiWnhoS2Br3UBtm+s21I0amlfDax+vAowvlq?=
 =?us-ascii?Q?HCZqGZJEszrQ8w7Ac3KMlVD0smKAKnd+3sznppzqPG2u/ZCw6P0eauEtGkJI?=
 =?us-ascii?Q?BaTBzuYw4/tJqjkY9pj1uC/n/ve76XydUX6oelfn78ntkvPOzbi2BB61MaE7?=
 =?us-ascii?Q?CZFBxlzTCloM+1KKT+agFRZ9zpLJJrwhpIxg7/9Z?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ed42109-8858-4597-4378-08da8bdafb21
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 05:29:45.9832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TpMg7wps7Rs3Hz0I4z5ePgrgqEJa+Ke97SC07J0lQs+rpAWduGqZ4OBSHbTeHy9SK2tM1Ad3uNcOvc86f/rCTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5785
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022 at 05:01:16AM -0700, isaku.yamahata@intel.com wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>
>
>KVM/X86 uses user return notifier to switch MSR for guest or user space.
>Snapshot host values on CPU online, change MSR values for guest, and
>restore them on returning to user space.  The current code abuses
>kvm_arch_hardware_enable() which is called on kvm module initialization or
>CPU online.
>
>Remove such the abuse of kvm_arch_hardware_enable by capturing the host
>value on the first change of the MSR value to guest VM instead of CPU
>online.
>
>Suggested-by: Sean Christopherson <seanjc@google.com>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>---
> arch/x86/kvm/x86.c | 43 ++++++++++++++++++++++++-------------------
> 1 file changed, 24 insertions(+), 19 deletions(-)
>
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 205ebdc2b11b..16104a2f7d8e 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -200,6 +200,7 @@ struct kvm_user_return_msrs {
> 	struct kvm_user_return_msr_values {
> 		u64 host;
> 		u64 curr;
>+		bool initialized;
> 	} values[KVM_MAX_NR_USER_RETURN_MSRS];

The benefit of having an "initialized" state for each user return MSR on
each CPU is small. A per-cpu state looks suffice. With it, you can keep
kvm_user_return_msr_cpu_online() and simply call the function from
kvm_set_user_return_msr() if initialized is false on current CPU.
