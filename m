Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC21A771416
	for <lists+kvm@lfdr.de>; Sun,  6 Aug 2023 10:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjHFIzT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Aug 2023 04:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjHFIzR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Aug 2023 04:55:17 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B469FA;
        Sun,  6 Aug 2023 01:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691312116; x=1722848116;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aKQ2Su66GifFndlfMVGJYcNS0FQwiEurVVW0vgyr2ZM=;
  b=Lzeusjb/PNVgf5nBXmSwRK6NbjMTnWyVyZCMzs0IBMHWNw1JryZC6kkL
   ahkpMQHw4c2e5yUv+XcsSSb2om6s7oZQvEubZZ9GY87ZzlTDycTubX0ny
   tLu2Vh5ECxYgKOUkkNL4bvTX9JruiI1bt+2RvW9VEVmu0EWVofHbGKzXP
   mmR92xnZoI4yMCdBhp0Wzfa207Lbyr25l+n7DbKhzLunD15WDp3aqtX6s
   neS6Q3DUq/Vcph2Ithj5HfmK3xJWyNT66qWtfQlT20CYXFSaIlUUzwjli
   jyMefwj+Uu6+OAPK3GKKYr1gEy7XLhTGJKd/h0TlLYYjwnZzny78OFH/c
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10793"; a="350678653"
X-IronPort-AV: E=Sophos;i="6.01,259,1684825200"; 
   d="scan'208";a="350678653"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2023 01:55:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10793"; a="765627434"
X-IronPort-AV: E=Sophos;i="6.01,259,1684825200"; 
   d="scan'208";a="765627434"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 06 Aug 2023 01:55:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 6 Aug 2023 01:55:01 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sun, 6 Aug 2023 01:55:01 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Sun, 6 Aug 2023 01:55:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mv+7tsLCktDRXa/abbY3Ive/NzTkKthf3t6AQVUp6lQs7hPgDjDNcOz9s530eA0d9n5/ITIST/bOf+Sf1yelfYWuWtIqyYGasJXszGG6tH7QaFhgYVs8DCBtNI+t4AR5wAk0fXZXM/mNvl8okpvS/kj+/Ke+2XrwBbKamYAdvfWP8Kq2/ps6SAlxDsAV06jE3MdCNyiizPh+XADJpX18bnQ6xsMwcrpgJJ40OS6qATfDVJAfQkl1T/IttcEtKlvarieluh+x+m0c+2UkN2H9W4+SftLvKui/DSKbLVIGYJbqbK2yFdotvuCZEZWOf0FW+ZVQAIxH3B4/7PbhZRVGug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Cv4dBupEldnCqLKbcBcwugijThe+tuMJgJZPHMdhZc=;
 b=OvScWGwIt8aH8TzsYQ5o7M6H49USICBPy7RYqx5w/A/KWE++kbXJrGYpKreK8VeyWdaLRWr9qS7ENqyn/L0IZWK3JqJeuv/6KljIt1z5TBnUIidHNX56whorl9LEZgySJf0/hLkoEQVzcrellENYkVpHMonBv/V/WvDBvcko3Ui8JuTo6NHu7XmIGYfR3k+PXmZbbfca2c8LS9iQiUcAGj0UlgkEEuHP5PV1r2++yrhMptau1nhhhdoVM8uk5YrOMkquv2GmznCnJGHW5AzLOdMPfwkJ2d1kVL6mp6e+BxmVWiIJCwr2J9/8G6HGBb1abMXe2syI7XyZoT2E70qJmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CY5PR11MB6188.namprd11.prod.outlook.com (2603:10b6:930:24::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.25; Sun, 6 Aug
 2023 08:54:58 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%6]) with mapi id 15.20.6652.025; Sun, 6 Aug 2023
 08:54:58 +0000
Message-ID: <87788afa-8dec-a54a-c3f9-4b35fbcb03ae@intel.com>
Date:   Sun, 6 Aug 2023 16:54:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v5 08/19] KVM:x86: Report KVM supported CET MSRs as
 to-be-saved
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-9-weijiang.yang@intel.com>
 <ZMuDyzxqtIpeoy34@chao-email>
 <83d767df-c9ef-1bee-40c0-2360598aafa8@intel.com>
 <ZMyR5Ztfjd9EMgIR@chao-email>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZMyR5Ztfjd9EMgIR@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0006.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::14) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CY5PR11MB6188:EE_
X-MS-Office365-Filtering-Correlation-Id: 2aefa5e2-da33-49af-a8af-08db965acfda
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GgmGzbMQP4g0HpCJto5RvMSM6llFQdEvuq3wecrbihlffajGjCuussxtKDbziQR2b8PqGHGcvlUVGqLVpEkoJb2BFIhRldSvH+b7WrHQYX0b2TXg/8suKEPRNDKNs/UzuPXsbs5r+3NUwBduLIsKiijlWdS8sQeMhdrlaD40n1Mut4riPofjckuHmBALMStQRQTH1Le4NVvoN9E5VU7+niUH2+jE4C9FS1ll/xmG4QwyjOfX1IGnOMi+ZG1lA1gr8euA1Sf69XmhMKP98e84goUN/Ik8s/S6EBbJnVjknAklKJd1yuEcdk2j1/Qrb/vHaZvcThEcWO6alMGuRxMx+FgezOcf6v8L0SO3acml5eZfq1MD/ViIELIxawD4LChz03WIBBl1Dw6FKqXFr1SxI5sWo3CFqzOJ/Z1CL5aZ0zTP0JXFJAmcZQRAJhgyh3I3mPpvOCMTIyqRbVqExsjkL+ifbWHgek+07BT1CP8Gs6CIudQjUFyU/m7WeZ/LN4pbN94s2no1hNwfM8Mjaz1Y1h6B73FNGwSpZCEClHuMUPKBWHuwOYGgDb7P9JHeyF8kryrYBfrd5wlXLIEmcH+lWBBkXhFevooW/g4lQbPTJSkns0REfmmbVgWBZCZG/fhr+MhZc2nOIDrcuweyU/inRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(396003)(366004)(39860400002)(451199021)(1800799003)(186006)(6512007)(26005)(6506007)(53546011)(36756003)(37006003)(38100700002)(5660300002)(86362001)(31696002)(4326008)(6636002)(2906002)(66476007)(66556008)(66946007)(6862004)(41300700001)(8676002)(316002)(8936002)(6666004)(6486002)(478600001)(82960400001)(2616005)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dFpTVE4zeXdqYWVRZ1pIeGI4MlZSeHUwUlFWZmxCTlQrNWNiVnRDZE53bXV3?=
 =?utf-8?B?TENrcFVoT0VGQUtkQmx1NjFoaitJb0Rqd3JFU1BCV3Nmam5IN28xVGh0bVJm?=
 =?utf-8?B?bmNKZzJxdjRka2tPSHBLajlFQkNobHY1SWM3NWdTb1grRWlySGdXb09TUFRx?=
 =?utf-8?B?REZpVlUwNlRDenI3Z3B1R3VMZkQ3NUI0c2RFTjRaOVdlSE1YcEZrWUdPUys5?=
 =?utf-8?B?Q1ZxTlhORSt5L1RsVDRFc20ycERRYjVBS1ZMREtHa21hSDAzREluU00wQ014?=
 =?utf-8?B?YkRNRVk4SGptN0pMS2s0cTVQVXpMSFAvOXo2N1dsZDlPb0tDa3JrMmRzVUVq?=
 =?utf-8?B?TjhmZ2dMRFhqSVFGZ3g1cnFCdFhqdkRjbUtwTkxRTjV2UkNuTTExWHdjeWRT?=
 =?utf-8?B?clFXSzZxSE1KWFkvT2ZFMnVXbkZLUnRwbjVOQ2NWWXJxWUlMRFk1RlhBMFJQ?=
 =?utf-8?B?ZmhYZWUxNHNSVXN0WkNsQWo2RUY0Tks5cjZEdUwrK3ZuL0o2RnM5R0o3Ty9W?=
 =?utf-8?B?ZUtDMHQ0Q0pGSW16NzVCOUVtZ25FdHJUc2hNY2VFSHNCNHVsTFR3YXZGZ1ZJ?=
 =?utf-8?B?VG1heUl3WEpuNlBUNDJZMWZEeVR5YmhONGZYcllOdHBqeVdmZy9sd3l4SDlF?=
 =?utf-8?B?Q3JRbGhnU2Z3MFBBcTdGQitTK3ptQ3RvYjIzK0loR2VWNEdYSWJ3Y3dwMDFK?=
 =?utf-8?B?aUVNeDE0ZXNzRStLOXMvQ2Z4UTdCYWZxRkZldE9td04xRWdKTVN0eVVzdVkz?=
 =?utf-8?B?aDF5VUpoMUNjZGN6bmJ5YWRLOENVa3F5bzVhekg4ZldsOGI3V0Z1RW9JSkpP?=
 =?utf-8?B?VGZHQkROVnZRMUlITE45ZHd4cXZlUzlmUUJJQ1ZMT1RpVmFCWkx4S1JrTThJ?=
 =?utf-8?B?cUtGVkYycE1BRGk5ZGwwV0FOKytKYWVPZDRGbHovb2h2VTVLUW8wWkFWVE1I?=
 =?utf-8?B?NGVyVmFUYitSNWppbnUyaXg5N1ZnZ0NJUjExcEsxUnRkUmZNemw5NnQ3eWJC?=
 =?utf-8?B?eGRLa0NzYnltVnp2czFFTEJjNGhFRTc0Smo1elRnWXk1M01ydXBjZTAwSHlu?=
 =?utf-8?B?T05YdjMzNGNidnBoQjdIbDIzR1ExNlN0ZnpwUXhwdGQ0bHlET2hPVFMyUGI2?=
 =?utf-8?B?RUZBUU05bldsUWxsbVZUbldHSVVsRlNFUzdHbmZRTERTem9HRTFRT1hwVEVQ?=
 =?utf-8?B?a2Joc1hVL3pqS3MySUdveFF3bSs1NXIrU2sxTFhjTTc0MmpSYVgrTzh5SFcr?=
 =?utf-8?B?eUVLTmUzcy9CWVpJODIwbDRjbTVBN0dYZzlqVU1yL2lpVWZibkNnR1hlZEUr?=
 =?utf-8?B?V1dPblF4bmFOZkVBNnVWRkw5TlRvZVdrK1VmN3dRMDMwQUNqdzVudTcySTVw?=
 =?utf-8?B?QldnR3RQTitleGJzUkJDbk5DbDViQWtoaWNibHBWTU9nRjV6MkVzazZoZ1NF?=
 =?utf-8?B?RDZrdzZ5d09pcHN1SzY5R2UyR2VpN3BDU1J2N2RQVHlEa0cxVzNFODUvT3M0?=
 =?utf-8?B?SjIrQ2xOR2NSU1dhcUt6andzU08yZWRkQzArS3JVWkFVUitCUGgwcnZ4VE81?=
 =?utf-8?B?K1lHY2FXbzJiN2E1Sk1LUFVTUHNJRU5nRkwrTnZ3bXh6MkdBbDhuMS85cGVx?=
 =?utf-8?B?eUJpUUlmbm55a3pDNFE3TzFzd2hqalBJNlBQQnVVWmdVdWJHOXpZRDhrRUZK?=
 =?utf-8?B?OHZCb3JMV3EzTWw0Y1hZM09QS01MaW5iYTNScCtXTTlzMjJ5OUJ4SGxBcjdT?=
 =?utf-8?B?eTF3c2F0bjJIdTBUd1hTUHJrWXpvTEVsbGVZRGZMNjBhV2ZzVVh0N1RCbnlp?=
 =?utf-8?B?dkJ2R21mTWhVTzliNU44WXV4ZGpUVjBMb3ZSOW9hYk12S2g0K0wvUmxBb0Nn?=
 =?utf-8?B?ajZUSjVOSGU4bVNWeHBPdHhxb0JGNGZrSWlKdStIL1BJZEZtSTAyTlZhT2dO?=
 =?utf-8?B?bGZBTFBQSlhhRjUyb3paNU1RYzdjMTQrVkdMaGpCVU54UnhRMVE4T2VlU1ZD?=
 =?utf-8?B?RklHUlJLUXd1Yjd1S2d0NEVESmtZZTR4ZjVtZzY4KzQrYmVScWhrSkJ3d0l4?=
 =?utf-8?B?a3IzQTJrNFk1OVZ3MHNkZHUzaTFjV3ZZVHNsK3FOZWdqME51T3dRei9MSkht?=
 =?utf-8?B?QnFEQVhZS0g5RGFDR1FrbWJsL2Rra2tLdU5ONG84Ym9nNTkyN3FKRW51ZWtY?=
 =?utf-8?B?UUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aefa5e2-da33-49af-a8af-08db965acfda
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2023 08:54:58.4188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IRI7/jtfato4tYpNiSBSVlKwbkfHTsyGVvx6zbscRbUu776ciA72gi06GHFImV6qKJrMpuyuiZ1oeLMNaErR2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6188
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/2023 1:51 PM, Chao Gao wrote:
> On Fri, Aug 04, 2023 at 11:13:36AM +0800, Yang, Weijiang wrote:
>>>> @@ -7214,6 +7217,13 @@ static void kvm_probe_msr_to_save(u32 msr_index)
>>>> 		if (!kvm_caps.supported_xss)
>>>> 			return;
>>>> 		break;
>>>> +	case MSR_IA32_U_CET:
>>>> +	case MSR_IA32_S_CET:
>>>> +	case MSR_KVM_GUEST_SSP:
>>>> +	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
>>>> +		if (!kvm_is_cet_supported())
>>> shall we consider the case where IBT is supported while SS isn't
>>> (e.g., in L1 guest)?
>> Yes, but userspace should be able to access SHSTK MSRs even only IBT is exposed to guest so
>> far as KVM can support SHSTK MSRs.
> Why should userspace be allowed to access SHSTK MSRs in this case? L1 may not
> even enumerate SHSTK (qemu removes -shstk explicitly but keeps IBT), how KVM in
> L1 can allow its userspace to do that?
Hold on until host_initiated access is finalized.
>>>> +static inline bool kvm_is_cet_supported(void)
>>>> +{
>>>> +	return (kvm_caps.supported_xss & CET_XSTATE_MASK) == CET_XSTATE_MASK;
>>> why not just check if SHSTK or IBT is supported explicitly, i.e.,
>>>
>>> 	return kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
>>> 	       kvm_cpu_cap_has(X86_FEATURE_IBT);
>>>
>>> this is straightforward. And strictly speaking, the support of a feature and
>>> the support of managing a feature's state via XSAVE(S) are two different things.x
>> I think using exiting check implies two things:
>> 1. Platform/KVM can support CET features.
>> 2. CET user mode MSRs are backed by host thus are guaranteed to be valid.
>> i.e., the purpose is to check guest CET dependencies instead of features' availability.
> When KVM claims a feature is supported, it should ensure all its dependencies are
> met. that's, KVM's support of a feature also imples all dependencies are met.
> Function-wise, the two approaches have no difference. I just think checking
> KVM's support of SHSTK/IBT is more clear because the function name is
> kvm_is_cet_supported() rather than e.g., kvm_is_cet_state_managed_by_xsave().
OK, maybe the helper is not necessary anymore, I will remove it, thank you!
>> kvm_cpu_cap_has(X86_FEATURE_SHSTK) || kvm_cpu_cap_has(X86_FEATURE_IBT)
>>
>> only tells at least one of the CET features is supported by KVM.
>>
>>> then patch 16 has no need to do
>>>
>>> +	/*
>>> +	 * If SHSTK and IBT are not available in KVM, clear CET user bit in
>>> +	 * kvm_caps.supported_xss so that kvm_is_cet__supported() returns
>>> +	 * false when called.
>>> +	 */
>>> +	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
>>> +	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
>>> +		kvm_caps.supported_xss &= ~CET_XSTATE_MASK;

