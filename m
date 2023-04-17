Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFFAA6E4016
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 08:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjDQGtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 02:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbjDQGtT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 02:49:19 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9A4E9;
        Sun, 16 Apr 2023 23:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681714158; x=1713250158;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Q8Srhh9mlaTWSRBcBPDe/2AVdeGtBxBRyA5mzUBVGm8=;
  b=Jru8eBpg7b19vLWZeBgk0/BjMKXnuqdSyFmQXabFpZe8+OTppQ06x6Dl
   hDlThNXdtf395GUlPJfqadRO0zsiGsPNBIaV2v7d/K82YliNG39S+xbjc
   25dkt73xvmbSUhqzCEDqxlLcB2771P0mydSx0uh5+wiKnKhFVIWxociKM
   d/1yuhDnti0jvCUnFXCO+oSRk2nF0+O9aXBDybQ56mlbbbcmq/spOFfhD
   pPfz94OWuaXPIPaoD9sxpjo1ScpEWMzQRU+6FcNqoxc96FuoOJ3P69W4Y
   BOpeUYumUbA8yJOyeyl2VTvPMKce+F9VqpFCLb6d6j3QO/WMOj357d4ys
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="333615816"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="333615816"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2023 23:49:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="779950372"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="779950372"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Apr 2023 23:49:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 16 Apr 2023 23:49:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 16 Apr 2023 23:49:10 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 16 Apr 2023 23:49:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U1C0ILZydmFYtW+BhFQTTivztxDR5+l/tUYX2x4DlVVy2kz6l8MI1A0wjVhVZwpZYFlHxkuqPVigGcptyC85T/GY29lXsjMK2WnQjosC61qsXdvbiEtACrX4+mICEHj5+tBODGYcJP+piHnIMxwSZ9NAJkMQXI6INx68qXQPmQ/8rqQclyMWFeB6Y4hYJIfVCRCzdG0Al1TizG1Rh8KTVHZ3vmb4VB0lQwA9DK22w21J2rDYK9ycJY7Zr68biiXUonFtPNKDc+oc8lXoIWjVrcsm3Yslvp5kHjInBXF6DgiX+OwR7iOCKyUF3gYrdzQtN+0dZxCaurh4PVBwfmbq/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IvVlyQ/N59Js7w6Api+90cxFV0XJ58g9m+KRCRodCXM=;
 b=UVJzsBOLHQpZRXK6tb424ukPeHM2qsBARih+dj9yPjJUl3ieVsuHuGlf1Q9RHJltmLSsVq133P0PDhe0FeRiljef8LUyH/BU3/wo9QIjFKHAazPs0WCWi0Vatt5yO5d4H0Aa9ogSdBCsCJ+Xns9koUAxUqfLfE6PDL1NLV9gShxrqOGSNoyYFhH1/majzaHGC63LVBNv098e1zNJlGWzNzVz59Vc60WdVtKS3TAEzidtkux+Crr68ypiRwVp+4p9clb4mWIrnTQnWDP3IR+ZjKtgSqBvsCv3cN13LQlcUwzRtFMt0f5hxHKhkBtrt4vySSRlSZLFGGAOBITYonAJUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5045.namprd11.prod.outlook.com (2603:10b6:510:3f::11)
 by PH7PR11MB6380.namprd11.prod.outlook.com (2603:10b6:510:1f8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 06:49:08 +0000
Received: from PH0PR11MB5045.namprd11.prod.outlook.com
 ([fe80::deb3:2852:a71:ce73]) by PH0PR11MB5045.namprd11.prod.outlook.com
 ([fe80::deb3:2852:a71:ce73%3]) with mapi id 15.20.6298.030; Mon, 17 Apr 2023
 06:49:08 +0000
Message-ID: <c89c9d44-f9c4-2e48-ff0f-f0e070de6426@intel.com>
Date:   Mon, 17 Apr 2023 14:48:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [RFC PATCH v2 04/11] KVM: VMX: Add IA32_SPEC_CTRL virtualization
 support
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>, <kvm@vger.kernel.org>
CC:     Jiaan Lu <jiaan.lu@intel.com>, Zhang Chen <chen.zhang@intel.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-5-chao.gao@intel.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <20230414062545.270178-5-chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0019.apcprd02.prod.outlook.com
 (2603:1096:3:17::31) To PH0PR11MB5045.namprd11.prod.outlook.com
 (2603:10b6:510:3f::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5045:EE_|PH7PR11MB6380:EE_
X-MS-Office365-Filtering-Correlation-Id: bf4e63c0-d040-4227-1c0f-08db3f0fd782
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rrQuhvyZikcKhsX8YmRZVrTj4kByfhLTQ9WZFqWdTjk1flLUSGCRQPr/2B03gqSfJ9mtQ+QhRQS5YS1/fVRbUSoJS5OHTHkXaQV2D1HC/ReHl6HZ3rRhNcnRdhlVdv7ez6//9I/7nxxJzt5fFBpPHYmK7+1boEckWBHiOOVFr3X2Rd5NrPxrllOfF09+EK+bWNLyYPjMiZIxlsB/sgkt2basprEPkPSf1u1Y/aFxME5yaKcFUR3iKGU5KsJPmwnWXmnjY/Y3wcShJKB5NyEAVD+FZKpnevLNbb0y6XxF0d6IqV5UHLxJS5zh4g2jj3D4GWlIj1mQO0J5LPF/I7kZs2dXGlkwljDiNRQNeu7KMxEMK9leNkzpAIQiZvhb4Bm9WoHEMr/VvsseNKKiHu11ZraMvwqieiiEktVTG6yh533URKF7O2LufNuTPSILBVcEk9BUAwgzqyOdU1+U3c8KwUbtqV+o2D/4wvGafF9ZifRl/4X6uI66LMFfKKq0ryU9WNsUV9ltlpMSjRoOOoVxICfQH7K0H/kVeDBoNXsR/pdnVEMJwm9dEONc9mwqoXT8MJonNGYbnp5nXAw+LYtfoMgt1ymCroKcfwyCnD5UuoKhe4FgKr5sx0SjB+hrAbjrShiLzHJ2PxxdS2tg5xvpuYWjQyULeJLP+hg7ti5xYPE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5045.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(346002)(376002)(39860400002)(396003)(451199021)(86362001)(31696002)(83380400001)(36756003)(53546011)(26005)(6512007)(6506007)(186003)(2906002)(44832011)(7416002)(31686004)(2616005)(6486002)(5660300002)(38100700002)(6666004)(8936002)(8676002)(478600001)(54906003)(82960400001)(41300700001)(316002)(66946007)(66556008)(66476007)(4326008)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjhvU0ZDWlFZVWxabHdIOG5JNGlIK0F4S0pjK2c2SmZvb2NDQjN4MlVBV0U2?=
 =?utf-8?B?MjY5dXR0NXV1Uzdodkg4V0FYMmRndVVjY0Q3S1B1ei9XZGk5aFF2eXY1alBw?=
 =?utf-8?B?SFZCTlF2ZkwvZFh5UFBmNUV1emVuWkVYL3RhSTJpYkJGU0pXRHM1TG5aRHYw?=
 =?utf-8?B?bDE4UG04ODFneVpiazJlNDRDMGhLaDQvYXd4bStROTNnR2ZDT3JVMktlWDdB?=
 =?utf-8?B?Y0haL1ptUEF3NXNUUVRxVHk3dGlpQVZ1bUJHRE1OTFZRMjdYUDByNGZwMWNu?=
 =?utf-8?B?VmkwZmVzQk1ZVXBONEtkL21PbWxjcnlJb1l4cDdQTnB3bi9zemhSc1JOeDh1?=
 =?utf-8?B?ZVRBVHppZ29oVDFHTCtkYUNqSXdtQkZnUFl1TjBvUzlHb25yNlRGdnVjUGhY?=
 =?utf-8?B?c2d5MExoOGhDamNNa0x1cEphcXY4S1pNNDNIMjNLcTJjbW4rVWdVbGtkbzg4?=
 =?utf-8?B?Y0ViU2d1VTNva0tIY1ViQ2I4TmcvZE83K1VieGlRNmZnQ1JGNndLU1phb0d4?=
 =?utf-8?B?aHRCc3dnMTZOZEcvUElQMEY5LzVnQ1dZaFFhSHBQWStEUTdFTTVXR05EVUlG?=
 =?utf-8?B?THVzd3NxM1d5WCtXd3gzUG91Z2oxenhiTFc5ZldhSzhIV3pkdUZEUWt5b2NF?=
 =?utf-8?B?NG9JekRTY1d4SVNKVXd6K3F6SkJadnp0RTBOMm1WRURVamhrYVgxWmwvTkE1?=
 =?utf-8?B?YlpFSTJJWUZUTXhuVWtSVGRNWFdJVkFoQzAxcEJ5T2F4MzBSMUNDN2JlNUxq?=
 =?utf-8?B?ZDEyVlU5TS80Zk1BcU5Ydld2NGErYmRYd2dFQVQ3YU45bFd0SFZPSjFPWEwr?=
 =?utf-8?B?YTFRTGVSM1h2cGEvb25ha3EwZVVYNU1uVFU3V3Iyd1ptZmJCNXNWMkFzc2s4?=
 =?utf-8?B?bE9tYTloNGpjOWtueE9oNFVhbElkZVlPZlBuVHd5Mjd1SEVCNk92V1JDemR3?=
 =?utf-8?B?ODJ0NGV5amsyM2t4cmlWSzdUcnpGTmxuM0VJRnJqMkpXU2VJb21IM3Y0SVZk?=
 =?utf-8?B?Znd0WUkzNUo3UUI5b0UzR3pRWUhiUHR0S1dsSFhlazFoM1RIMnVRb1J6YjJG?=
 =?utf-8?B?TTFWaVFCUEZ6VDJjUVZrL2dyS29lYVQ3S2N6bkJYSFpSU08ydDl4aTYra2g2?=
 =?utf-8?B?T3JLMU94Z0tGcjBqR2JnbkY5NUtUeWw3UG9OZENTOEhuNGpnSy9wdWx2OU81?=
 =?utf-8?B?VzNaa3YreHNPdCtCNTZBU2xvdGJDTmliSFFsclhaSklMdGhDS1NDbVpPZytK?=
 =?utf-8?B?MGhCdTNQK1J0NUY3alNMLzYrK1VJVGl2STVoRE9UeWY5M0NJYVlMa3RCTHA5?=
 =?utf-8?B?U1hIVlZpN3V3dlBvWW5aYWhEamJpUGdicE52REdxbzRzeWVYU0hySll5NmpR?=
 =?utf-8?B?TUZIMTkveWJQa2tieS9vbTNFSVVhaFE1TzN4V0trWmRlOHJ3RFNyUlIrekJu?=
 =?utf-8?B?OXVUQ3JEd0c5eVI4Ym9BaVUzK1dsUEhWS3d2WFdBbHF0TE0zc08xSzIvLy9U?=
 =?utf-8?B?UFpOdldqa0dZQnVWT2s3bTFmS29ZcmlvOXo3TjdDaGJ2Rm9ISjB5cnk2d3g2?=
 =?utf-8?B?dkdKNm1GZTRXRTVVK2xPaFA2Mk9ndW4xU3g0YTlhbkxGZEJBNmFFbUtZbUM0?=
 =?utf-8?B?aEVYbDhrYmFhSGhLM1N3Z1NiOEo3VWgwYXNwUTlCMEZIRU1xZTEweGhKclFC?=
 =?utf-8?B?MkVEY291c1Bmc2VLNUVoUGQ0bGFBclJYcTFzc0hweCtLSDVFakhPNXpaNGNq?=
 =?utf-8?B?SnhUQ0hXSlBkWFY1VWRJSzlOZmVFcXdhbUdQQTgwVXZOdmNoTEVtc3Jqenlh?=
 =?utf-8?B?NVQ2ZTBndkR1TlVhWXB0ZUIwY1djbDJFS0hWdjZZOFJVZTRweVJzSWtCclhH?=
 =?utf-8?B?THBnR0RsRzhWSXBTRVpleG10MHU2Ynh2N25TUTcxZEI2NHo1Vm1YVWJOR0NY?=
 =?utf-8?B?Y21LVHZwenhRdkdMeVlYSW5hTmpCUmVjMjFwVG80MnN4eFNNVElrUUpGWm10?=
 =?utf-8?B?THZ3U1B3QUNaQS9LZ3NRcWlBQzB1VnJPZXZONzdsVjNabm1DeEJHZ3h3b1lV?=
 =?utf-8?B?UWMrTXBjdkJ5L0F3cFhhc0pnd1U0SjRxakUwZUlNVG1qZFBrb1UxK1pBU2NQ?=
 =?utf-8?Q?kBFzjnQ3HV/HpO6FvE/qaQ5MZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bf4e63c0-d040-4227-1c0f-08db3f0fd782
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5045.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 06:49:07.9594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3pPFROKarDNaLiEVtm37ZI+Kv1BDLK1FzUzq3dlLjiajghxML68rCq/ubs41e+/+em5gmPeBrSJ+qzLJNx/6Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6380
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/14/2023 2:25 PM, Chao Gao wrote:
> From: Zhang Chen <chen.zhang@intel.com>
> 
> Currently KVM disables interception of IA32_SPEC_CTRL after a non-0 is
> written to IA32_SPEC_CTRL by guest. Then, guest is allowed to write any
> value to hardware.
> 
> "virtualize IA32_SPEC_CTRL" is a new tertiary vm-exec control. This
> feature allows KVM to specify that certain bits of the IA32_SPEC_CTRL
> MSR cannot be modified by guest software.
> 
> Two VMCS fields are added:
> 
>   IA32_SPEC_CTRL_MASK:   bits that guest software cannot modify
>   IA32_SPEC_CTRL_SHADOW: value that guest software expects to be in the
> 			 IA32_SPEC_CTRL MSR
> 
> On rdmsr, the shadow value is returned. on wrmsr, EDX:EAX is written
> to the IA32_SPEC_CTRL_SHADOW and (cur_val & mask) | (EDX:EAX & ~mask)
> is written to the IA32_SPEC_CTRL MSR, where
>   * cur_val is the original value of IA32_SPEC_CTRL MSR
>   * mask is the value of IA32_SPEC_CTRL_MASK
> 
> Add a mask e.g., loaded_vmcs->spec_ctrl_mask to represent the bits guest
> shouldn't change. It is 0 for now and some bits will be added by
> following patches. Use per-vmcs cache to avoid unnecessary vmcs_write()
> on nested transition because the mask is expected to be rarely changed
> and the same for vmcs01 and vmcs02.
> 
> To prevent guest from changing the bits in the mask, enable "virtualize
> IA32_SPEC_CTRL" if supported or emulate its behavior by intercepting
> the IA32_SPEC_CTRL msr. Emulating "virtualize IA32_SPEC_CTRL" behavior
> is mainly to give the same capability to KVM running on potential broken
> hardware or L1 guests.
> 
> To avoid L2 evading the enforcement, enable "virtualize IA32_SPEC_CTRL"
> in vmcs02. Always update the guest (shadow) value of IA32_SPEC_CTRL MSR
> and the mask to preserve them across nested transitions. Note that the
> shadow value may be changed because L2 may access the IA32_SPEC_CTRL
> directly and the mask may be changed due to migration when L2 vCPUs are
> running.
> 
> Co-developed-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Zhang Chen <chen.zhang@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>

Duplicated SOB. Move the Co-developed-by down like other patches.

> Tested-by: Jiaan Lu <jiaan.lu@intel.com>
> ---
>  arch/x86/include/asm/vmx.h         |  5 ++++
>  arch/x86/include/asm/vmxfeatures.h |  2 ++
>  arch/x86/kvm/vmx/capabilities.h    |  5 ++++
>  arch/x86/kvm/vmx/nested.c          | 13 ++++++++++
>  arch/x86/kvm/vmx/vmcs.h            |  2 ++
>  arch/x86/kvm/vmx/vmx.c             | 34 ++++++++++++++++++++-----
>  arch/x86/kvm/vmx/vmx.h             | 40 +++++++++++++++++++++++++++++-
>  7 files changed, 94 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 498dc600bd5c..b9f88ecf20c3 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -81,6 +81,7 @@
>   * Definitions of Tertiary Processor-Based VM-Execution Controls.
>   */
>  #define TERTIARY_EXEC_IPI_VIRT			VMCS_CONTROL_BIT(IPI_VIRT)
> +#define TERTIARY_EXEC_SPEC_CTRL_VIRT		VMCS_CONTROL_BIT(SPEC_CTRL_VIRT)
>  
>  #define PIN_BASED_EXT_INTR_MASK                 VMCS_CONTROL_BIT(INTR_EXITING)
>  #define PIN_BASED_NMI_EXITING                   VMCS_CONTROL_BIT(NMI_EXITING)
> @@ -233,6 +234,10 @@ enum vmcs_field {
>  	TERTIARY_VM_EXEC_CONTROL_HIGH	= 0x00002035,
>  	PID_POINTER_TABLE		= 0x00002042,
>  	PID_POINTER_TABLE_HIGH		= 0x00002043,
> +	IA32_SPEC_CTRL_MASK             = 0x0000204A,
> +	IA32_SPEC_CTRL_MASK_HIGH        = 0x0000204B,
> +	IA32_SPEC_CTRL_SHADOW           = 0x0000204C,
> +	IA32_SPEC_CTRL_SHADOW_HIGH      = 0x0000204D,
>  	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
>  	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
>  	VMCS_LINK_POINTER               = 0x00002800,
> diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
> index c6a7eed03914..c70d0769b7d0 100644
> --- a/arch/x86/include/asm/vmxfeatures.h
> +++ b/arch/x86/include/asm/vmxfeatures.h
> @@ -89,4 +89,6 @@
>  
>  /* Tertiary Processor-Based VM-Execution Controls, word 3 */
>  #define VMX_FEATURE_IPI_VIRT		( 3*32+  4) /* Enable IPI virtualization */
> +#define VMX_FEATURE_SPEC_CTRL_VIRT	( 3*32+  7) /* Enable IA32_SPEC_CTRL virtualization */
> +
>  #endif /* _ASM_X86_VMXFEATURES_H */
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index 45162c1bcd8f..a7ab70b55acf 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -138,6 +138,11 @@ static inline bool cpu_has_tertiary_exec_ctrls(void)
>  		CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
>  }
>  
> +static __always_inline bool cpu_has_spec_ctrl_virt(void)

Do we need to use __always_inline to force generating inline code? or
just align with other cpu_has_xxx() functions, use inline annotation.

> +{
> +	return vmcs_config.cpu_based_3rd_exec_ctrl & TERTIARY_EXEC_SPEC_CTRL_VIRT;
> +}
> +
>  static inline bool cpu_has_vmx_virtualize_apic_accesses(void)
>  {
>  	return vmcs_config.cpu_based_2nd_exec_ctrl &

