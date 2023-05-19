Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3AC570944B
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 11:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbjESJ6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 05:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjESJ6g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 05:58:36 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14FD10DC;
        Fri, 19 May 2023 02:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684490291; x=1716026291;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=pKegAsM1YPQp+7FPRc2c53d77wTgS5WSG8/Gu6oqfw0=;
  b=dF8vMjrHOhD+YhFKKskASUPFGem9msId8gG6AbKfCuEB6Rn6Tz4ekD3k
   RcC0AXdldW1knclT645tFlGwTlgeq79Eg9/zmVe9uM+B5+lYJCghsWUR2
   2FPBJZ/u57KioIJna1PdO/f+H2sgS/dz288Ye/fYDmeNgmgbotmkneTSg
   8axc4oMFg03VTOEKCJIERrHDVDJ7JiBmCq/3YsHRBBqj2a0abyD/Nlc+9
   a++YxT2yahrfXpocXyB/BxHMnX7piT07e842RFR/aQFmqtgDz30awvjcd
   AR6ZS09sdDqHUgQkXQeCS2bcH3Da8ezuNzwrQ3PvcKIxRMmG79BWxOsae
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="418026391"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="418026391"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 02:57:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="876793879"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="876793879"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 19 May 2023 02:57:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 19 May 2023 02:57:39 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 19 May 2023 02:57:39 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 19 May 2023 02:57:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYggfd3ezyVdfImP5MiVBrngjil7GAisXvv//+877G3KUAB/n/nxW149ofDj0Gyr6YX+Dpxi7kfGHzWHgJZ9YiWWeDhvCRXEnHQdTUHlAgHaXJNlWBRPeQSGUBKsB3oMjRD/sS/k9CHDOJs90xko/YXLBrd1QQYMzlWIFrxFdYkbcSDBlyMze3TZY/qYI8Y9sGi2Qfd9pFer56CaM3foLJ+tUGMtNhdCW3A+3F5jH6Y9BueHxFSRQNgyyXoLT1rmshz3uLV+nPkMKe6WHd25hPSHPXZ0P0CW0beFZ+9iy/69KtOlbse6O2m3yyY9TrEf3qZl/h7hWFjpdaQKCKxpJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zVnw4ZP990Z3MwIfX0ZoZ0rfn7le6pZE5GSmzlbCWWg=;
 b=fyt73aLB5N0LfJfwP++ThoZw5jnq7bjJpmL6/D4FkIeSYJ7CJmbs5vcXpvVtMZ4mFB4UhefGQcR7ZHSe94QPa0p3Fgl190HLKlHe11bGBS9p8iFAw97Wr4hyf0jFOyupH7JpWMs3nE1pgbKe1UkiGtmC7E0+8gfSYC4flAK0gmODeSFbT8noADveM3qGb9F7kM1vQ9tzaIDO/4nmNsbRAc1De6cMkbdjpVzpjB9epfuwnWojWtoazHI8TCVQtwHePSd84H48Ijsr/975I8QnLjJtTQ/22fV6Ow7bjqjISxwxt/zlOdE1RS6T1PFeFdw1itJ+6fEztHJxWLu3YDoAGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by BL1PR11MB5368.namprd11.prod.outlook.com (2603:10b6:208:311::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 09:57:32 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%2]) with mapi id 15.20.6411.019; Fri, 19 May 2023
 09:57:31 +0000
Date:   Fri, 19 May 2023 17:57:21 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
CC:     <kvm@vger.kernel.org>, Jiaan Lu <jiaan.lu@intel.com>,
        Zhang Chen <chen.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 06/11] KVM: x86: Advertise ARCH_CAP_VIRTUAL_ENUM
 support
Message-ID: <ZGdIASx1lTamNaDd@chao-email>
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-7-chao.gao@intel.com>
 <3b0f3295-27d7-4c83-e1cf-8494548ecf14@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3b0f3295-27d7-4c83-e1cf-8494548ecf14@intel.com>
X-ClientProxiedBy: SG2P153CA0052.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::21)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|BL1PR11MB5368:EE_
X-MS-Office365-Filtering-Correlation-Id: a7fff885-b773-400c-51b6-08db584f765f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k5ZgXRMkQ57pQl2RJzTW1bJmOoTgcYlKamfRcFq1mlglFeinj2VIpaKrODvxRGF5aHlBgshieS0bJchsg+VNydbSgonwyvmDszxSnJ+vPU24aryDuK6mTszGiL+olVfnsOTJPOFilDTe4nlGRj3qDlK6hmabWd53I8aZ0QghRrKdhud/bK7IWPxlBjfj7uqGZPPe+t9iPAn/4+OhujPVESiSP+/TP0KP6qAkAG+N/PDKvZUGDBqyXQQe06YvZF+zsC/iK51EnNvTx3cuIZA+paPaC67wljGh+LpGB5B9y6dvJYiIV5UR3EYdJ21R6CPHGya03v8Ynuh7VBwQi4w1YWqfQzdP8Ectvj6ro3Iv4ElZCC8Rd7GQdz+HnVSnFaAGJcsbwTDCI+U2mzcCNZQ3KcKPeTtf0dU0PHpw0Nka9APdmn33KqtwHWFoQVKoIrk+2Hjhrfxpw5xBtv3NG2oCjWYQ43C9ZB4elZ/kVBzbeLm9vMn9Dn1ZSdhWD+/7nz/Eqrzhvqm4V0TTPYKglDZuNsIQknTAtQg06hTEddRLXyfdrBT0xry+n7nhdjMvjW3N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(346002)(396003)(39860400002)(366004)(376002)(451199021)(6636002)(86362001)(2906002)(33716001)(8676002)(26005)(6862004)(8936002)(6512007)(6506007)(9686003)(44832011)(5660300002)(186003)(7416002)(54906003)(66946007)(316002)(41300700001)(66556008)(66476007)(478600001)(6666004)(82960400001)(6486002)(38100700002)(4326008)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XIz+abOPPR7iAWBRd1qOu74Lce+jTAPW+yMT8N3yIwlMcCEInFI/5MwAR+YY?=
 =?us-ascii?Q?DcEE0KSh5ts7CRucVAl+kgbzga2m6DD+cF4L6uNOKlK7iqJp3/xFlhPfK1eQ?=
 =?us-ascii?Q?nK8JgI5A0Ke6EpSNAPMUykp7eOzI9e4oswAwmiPWN8+gaWie61Uy+vnIlWvR?=
 =?us-ascii?Q?pWfODOnE5G95mEX/Hagp4nz5nXDKs2WxtxaMt/IStHzwC4wTG4w6AF/LaAyq?=
 =?us-ascii?Q?y5HXvp+5o833lDIE9ZERC8Wp/2giBh7/rIpjf6meJlDk8uLV+WJNr93DbD9e?=
 =?us-ascii?Q?BHROiB6tdC3vUO4bwFko8gMVNS5csCfYIRYRM/ryS3RmoINAI2qujIU8agPY?=
 =?us-ascii?Q?cDcXgggYgRX6yzM3YfycEtfR+wT6wAy20/rmoNNSrwS6O7kQ6l62pb6vej3n?=
 =?us-ascii?Q?lriRdh0WMJ43TarFBDHcWdbh8jMXl3G99TLF0F9svTMeU1Z+sYynDX1aSs0V?=
 =?us-ascii?Q?isvaUjWEvs5t5aDOeNN4ViKdbwYCp/fl2dFbR3rnzAf77wEezVDrFnSyIXfO?=
 =?us-ascii?Q?b3b5+Yr2U5khatsvtyJoiu8Bn9gvfPxN3YAp9sHQPgPg6Q3+G0K9/LgulJBE?=
 =?us-ascii?Q?3RfxyCo3e504+6S5SbmKph0fGpr63ibjBz85ajV97BrW10HdR1xcJWNTSoCW?=
 =?us-ascii?Q?6KDaPj15DEIr2bHu/iYeJxwOcbX2DzAcAYeGaVPyQWHyA1UbupFpPevcL5Is?=
 =?us-ascii?Q?VHCePSbAyuzZ8MKh3JTCDRmqmfUAb/r+AXNrzSgLR9heALYMjI0DaCF76CPS?=
 =?us-ascii?Q?LHCCYIGec8G43flBjjHMsfCcbyhhwII6CrVOqi+zK6f9Wbtx37Y954k0NQ5p?=
 =?us-ascii?Q?E5iHZjGxlQ5n98+ENpImwNDohrsMBogsdvg5Nl9tDVkfQcF/zyirnwmzAoVa?=
 =?us-ascii?Q?kPb8T0i2Lx39BC+poU8a+uRyrq3inBAJMACKXZSPtocGLtesAF/dK1hNhibR?=
 =?us-ascii?Q?4ghhq0RfVhVYFU/ET6qbLnB/iI92SCA6eZzo5KfGhUVZo756skPyYsQzeOKy?=
 =?us-ascii?Q?e+sP2qaJx2V0TggOytJFrB0b/8y0LD4JCG7f1FkOcYV+utHLjQ+8VnPzqN/b?=
 =?us-ascii?Q?AuSBj9Rq/6Z9m6tiFZfGMzQkRBdp+F/1cBwvlsXFKIp0jzIAAkWJa4C1Acb8?=
 =?us-ascii?Q?58SKssRv719IH/WX/ifRAIkvni50JFGq4V8ObCf6xv+4RnTKsB9MN8XDyhDm?=
 =?us-ascii?Q?VGBv5qBpMciZVO39qiGswbN6EB03Q8LjWh16GzOk0qjMj/NQYsFvV4TbIfIS?=
 =?us-ascii?Q?y39E7bdlhPdorM0mNulm5LYXkbtqItEMPwnkpL/WxG1rSf/0BGkmt6C3IY55?=
 =?us-ascii?Q?t3FKYSOO3y5s+uRyaPkggDN8ha06y33am3LRGmoDhzjZuiX4+2gNu+wMO5lT?=
 =?us-ascii?Q?9FuBE8wTIAv4DKznbIkKY6LAtqfrGoUokRtaWRIHHpVoJYiJJADWdho4xgp1?=
 =?us-ascii?Q?DxlclGBXkDuOVcg++eaaWfrtLuwj3pZ6L7YJlA1//JBCt7WkbHkWC2wclqtB?=
 =?us-ascii?Q?d0wrWEmZcj96DjUuTY9NMJtZ+UNRaRwRBArjxte61qOGdTS5aIzKDjc3jnFW?=
 =?us-ascii?Q?kTaS0uit9Oi8bbqAweo7BfGqr0cib7MC25ZHTfdj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a7fff885-b773-400c-51b6-08db584f765f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 09:57:31.7677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4SaW1dmMzqBqosB+ASo9XDCnxvkFMtOySSRvrsICVvuMLZZIOe4KEYmxLntHO59L0qWpHaKqJhjHc4tAj/lCWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5368
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 18, 2023 at 06:14:40PM +0800, Xiaoyao Li wrote:
>>   static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
>> @@ -1591,7 +1593,8 @@ static unsigned int num_msr_based_features;
>>   	 ARCH_CAP_SKIP_VMENTRY_L1DFLUSH | ARCH_CAP_SSB_NO | ARCH_CAP_MDS_NO | \
>>   	 ARCH_CAP_PSCHANGE_MC_NO | ARCH_CAP_TSX_CTRL_MSR | ARCH_CAP_TAA_NO | \
>>   	 ARCH_CAP_SBDR_SSDP_NO | ARCH_CAP_FBSDP_NO | ARCH_CAP_PSDP_NO | \
>> -	 ARCH_CAP_FB_CLEAR | ARCH_CAP_RRSBA | ARCH_CAP_PBRSB_NO)
>> +	 ARCH_CAP_FB_CLEAR | ARCH_CAP_RRSBA | ARCH_CAP_PBRSB_NO | \
>> +	 ARCH_CAP_VIRTUAL_ENUM)
>
>We cannot do it.
>
>Otherwise, an AMD L1 with X86_FEATURE_ARCH_CAPABILITIES configured is
>possible to expose MSR_VIRTUAL_ENUMERATION to L2 while no support for it.

How does AMD L1 see the ARCH_CAP_VIRTUAL_ENUM feature in the first
place? because ...

>
>>   static u64 kvm_get_arch_capabilities(void)
>>   {
>> @@ -1610,6 +1613,17 @@ static u64 kvm_get_arch_capabilities(void)
>>   	 */
>>   	data |= ARCH_CAP_PSCHANGE_MC_NO;
>> +	/*
>> +	 * Virtual enumeration is a paravirt feature. The only usage for now
>> +	 * is to bridge the gap caused by microarchitecture changes between
>> +	 * different Intel processors. And its usage is linked to "virtualize
>> +	 * IA32_SPEC_CTRL" which is a VMX feature. Whether AMD SVM can benefit
>> +	 * from the same usage and how to implement it is still unclear. Limit
>> +	 * virtual enumeration to VMX.
>> +	 */
>> +	if (static_call(kvm_x86_has_emulated_msr)(NULL, MSR_VIRTUAL_ENUMERATION))
>> +		data |= ARCH_CAP_VIRTUAL_ENUM;

the feature is exposed on Intel CPUs only.

Do you mean AMD L1 created on Intel L0? and Intel L0 even emulates
nested (SVM) support for the L1? This sounds a very contrived case.

>> +
>>   	/*
>>   	 * If we're doing cache flushes (either "always" or "cond")
>>   	 * we will do one whenever the guest does a vmlaunch/vmresume.
>
