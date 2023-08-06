Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF98771422
	for <lists+kvm@lfdr.de>; Sun,  6 Aug 2023 11:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjHFJP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Aug 2023 05:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjHFJP1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Aug 2023 05:15:27 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13ED02118;
        Sun,  6 Aug 2023 02:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691313312; x=1722849312;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=G/xJ/YMQYF03RNK23g9FUesv2VwLuut0tQXgr0iHvJc=;
  b=dwtE8EgX0s4g4RX2TxS4wIHj19o2aJxbGP7ZYa5Wi4+zJpsWRrHcCosU
   Kmq1zvnnX6n/64A4BXAieiCv8nGNGZXJY+cNlWWMHj+ZvPdWJ8oWANmEI
   d62/246QCNEfPOHMi1G4E/ItheGuUPvdrKmxNtj98OHrmEYTzNINT5Yna
   UhPbr4IhY42ht5W1es/NA9s9/MBmzXrRDISsaQGiX2wKDkBDPVJYAGLSY
   znYdxlWqQ/6D5ztsXhAweB8iBcAYgR59MBrGeQkZDhhPr7BG8tYYTayS/
   83XUu+7uxgJ1xnbBtDYMWN/liQtBiWia1Ff27RLgnf+7T4MiIelv3OTY6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10793"; a="350680411"
X-IronPort-AV: E=Sophos;i="6.01,259,1684825200"; 
   d="scan'208";a="350680411"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2023 02:15:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10793"; a="904359872"
X-IronPort-AV: E=Sophos;i="6.01,259,1684825200"; 
   d="scan'208";a="904359872"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 06 Aug 2023 02:15:11 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 6 Aug 2023 02:15:10 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sun, 6 Aug 2023 02:15:10 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Sun, 6 Aug 2023 02:15:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1F3wOL/sc040NdrlTVLHuo4v1qz3D2QhzNhxBuc2VYzaF/8Tj5AVag0yhs+sptSCSYV2hpq0i8PgRcyo1JSmYqRuUuC0xXWvaFO9YH1N6xP1OVHV/X6l7hGpjbLWUMwy1hZc7JnyckuiuJQSQfVZA+AHbohePeYQBbR72K+czUcUVyX12exEU9FJaSwHFHCwpYwwhpmeYBsy6vTX4ZdRubWzPZ9/D9D25ksUKKRprPFMYTU2ZfzRmXk+HmGSABJHnu9QDaJLu9ZVlKgc865CTMPsxBoAzipSSacnlE8Spnt+exjI2JdcOU5SW/dWKg3v/jd7XCD2ODSfqY+Pv5zAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xJmSmINNox6zkxicFCEEfEvIn/bMcfVUHL/slaOJooQ=;
 b=XJsjYE9+n5dc7n3zjOGdP4QvabfJ4c1TTf5Kaw6pZxzqy9EDw+qa/e69Jmi6fDTySsTEvU/rM5mi6xRBCRw2NhBssxufuaaqoOxN55t9r0EvOAVLdsmq9RcY/ktsGzalnElF2xFzRxW1AZyoiAbeK1KYPyujaJLOigJb35I+6mysjGjvPONLfeYTPlS+kV9W4IRwp9C6K0l9GSQ/CTHzwr7HHkqf5g0x48opoKWUqVe+KZ0ekaoZ8OoDXTQ+cUmOm4X14jX36NYkHOaw8KZyT0TUA+asCbExZz0YNMPO4nF9oc/ScqzBgy7VDglmNAs4hnV3TckVCsxKvy05ZuiFYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS7PR11MB7782.namprd11.prod.outlook.com (2603:10b6:8:e0::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6652.25; Sun, 6 Aug 2023 09:15:07 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%6]) with mapi id 15.20.6652.025; Sun, 6 Aug 2023
 09:15:06 +0000
Message-ID: <bde22db8-a8ec-2097-14fd-0939e53c03be@intel.com>
Date:   Sun, 6 Aug 2023 17:14:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v5 12/19] KVM:x86: Save and reload SSP to/from SMRAM
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Chao Gao <chao.gao@intel.com>
CC:     <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-13-weijiang.yang@intel.com>
 <ZMyueOBXMwPkVk6J@chao-email> <ZM0YZgFsYWuBFOze@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZM0YZgFsYWuBFOze@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::9) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS7PR11MB7782:EE_
X-MS-Office365-Filtering-Correlation-Id: 608817eb-0514-4e91-4129-08db965d9ffc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zw3TfLBvp35ZtPX/6uWkBuUL4b/cSE/RM0hPn5gZp3Uf+m7kt0HqLhgTLCR4bHkK7oBC9NUhMDP9JNGGYjIxNHPK21k9qTWDjz2MDhpxe3p7tfDc6YjXtzHCRTKS//XbE8xsgH06SzV4UTvaQVq794x5c4iHmcxoQ/9fua5cH70GCYqgKo86DQkMSg3YgcazhDVm1PhtRL96/eQitv4DgV61YrGLicbXR201t+bTDEC7+l9zAmIus99f50QMFMJ3F8TDL6+YZgLroCtxkjO9ZpYoDzHUgcVqCCNYcS316NwAtyIST4+76tMzWpOP2BW4mtLpnWS/jqSIQlE2SCR1fPhRTGklggttqBnZxWHMXpmVrZZM4NzzT/nt+0ovv8KxFVxw00QaY11EdfxpxvJVR08VfLuhVfMtAAxhBeGPzyMOoCrU26YejFifj7D890zd9nk0SS0iy1BFJrULK9btyzgLvjFT7xGg/hnx8g8E9EfUQbXl3vRPEFPKalFJO+RGlAYC8SXgqrfAvriIthIo07z+2e2Lj1QBLfmGAGBmcxwRwBYTeBjb6dvuloInpzdwkGItB62ehqtRP+VnRCnWZDtZuRax7N0Ea+skA4j3PV9h3I5tzXubWPauovmJY87xShuQHt3axE9JaKfxWp6vpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(396003)(366004)(39860400002)(451199021)(1800799003)(186006)(6512007)(26005)(6506007)(53546011)(36756003)(110136005)(38100700002)(5660300002)(86362001)(31696002)(4326008)(6636002)(2906002)(66476007)(66556008)(66946007)(41300700001)(8676002)(316002)(8936002)(6666004)(6486002)(478600001)(82960400001)(2616005)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UldvazBMdDlxR1pjUWZOajMvcFNtcXpSQlNJUHlDMVBxMG84MkdYR3NPUjVR?=
 =?utf-8?B?RDhOTTdXY2pBeXY1SUhTYVhXZGlORlpSZ2Zid2hMQzl6elNJY29CbGNvVGpF?=
 =?utf-8?B?clE3NGZ2Vmc2bjdKTmhrZG4zNDZpZ09nVy9EbWFHYldHVTIzanNZNEttN21l?=
 =?utf-8?B?ems4Zk1wRDF4R0djTFUzb29lRUQxSTcraWl0K0NhUWhodnNDVHFSK3JvYVN3?=
 =?utf-8?B?ZVIrb2FSM3d2dGJmdFE2Rld3RjVOQSthVkhoeUJxc0FHSTdHRHc4U1lBenRL?=
 =?utf-8?B?SmZjUjJDaTI3QVMxUE12djlHZUNJY3hSSUM3TlpVZTNRU21tK0pEOHlBVldi?=
 =?utf-8?B?eGxqN0FwZVJMQkcrdjZMdXhsT1dpakFrMm9xUjNTdDZvNG0rVUVtUVdTU2FH?=
 =?utf-8?B?T1hHdXZmRkYrY3FRNGlCN3dvNm42NEZwaW10Q242RUQyVWN6UDdjbjhjbzBE?=
 =?utf-8?B?aS9NQ284enJvSXA3V05UZHlvdHBpb2FIc2VpM3QrdGlmSTl0ZGJVZEFxbEJq?=
 =?utf-8?B?eVBFVHAzVGdIQ1h1MWszWlBVYmpQbUNObzBDNnFuVGVBQ3MrUzcyNzF5Rjlk?=
 =?utf-8?B?eWNuZTlNRUZGNTk3R05qNDY1WDU3UWgyd3kxYlNsQlQyQUtFVUtuRlF2dUZu?=
 =?utf-8?B?dHhnNTJTRGtMM3FnSFlkUUVJaW1xd1ovSmZXOHVoeEVDOHBUUldUT2dQaXJu?=
 =?utf-8?B?RHVIWW8yZWxlSUZiOHk0RzEyNjVud0p3WnV3U2RQVG5NNXR2RU5QNlltQVpx?=
 =?utf-8?B?VUNUQWM0RGtySHdqRWR2TG5EZEt5a09OM3AvV2tHcnFoV3phdEZDdVU1dTdM?=
 =?utf-8?B?WUU0WkFHMEVBbEJTdkp0WGRJZTdtNms1Um9qM1lzTDBocWs4YnYrT3Qwdmt6?=
 =?utf-8?B?NjF4K0hCbnp6bHpQZ05UMzZGYm0wNmlQdUJpUGRQSVVheVFNWCsvMlp1cTRC?=
 =?utf-8?B?R2MyVUlKZlduWG9OV0srKzRSRTliRTNGTmUwbnJnaXJwamxUMDhkV1dycXlv?=
 =?utf-8?B?TDBDcmNMRSt1RlM0VzIyNEViTlRXQlZvVkU2c0hQdXRCWTVYR0htdlZhaEdI?=
 =?utf-8?B?QTRzUFhSWlcrT05rTkhDWU9oOE1ITlQ1SHBRR3NZdjZkV1ZDVTFPeENHd2hO?=
 =?utf-8?B?aDdVMFM3Tm02SHVYdzFOK1ViTWFnYU50dFI4cnVNREpPZ3NKK2JsL2o5STJM?=
 =?utf-8?B?ZC8zRmFCR0gxcGFqazFVN01vTkUrblpUNzdYRm1Nc0lxcHF0eXY3aGxsUWdJ?=
 =?utf-8?B?THIyaThMVTllZVorbmpYYitMMlZkRDBtb3FGVkVhM3NtbjdnRklMT1BEL0du?=
 =?utf-8?B?b1QzeXJwNVpGRVhPcFlnRWMveERNdFBiZ2U1QWxYNHF3Zk42YWk4eVg4dHgx?=
 =?utf-8?B?TUtEYytjTzFQUnd3M3FYVDZhQUZ0eEJIZ2dCOVkxTnN5c05MTkoxcHllZlRP?=
 =?utf-8?B?OWZGQ3o0eWVDdmR3elcwbFIwTVA2d2lJUDMxUnBLRGhYZHVsazVOOFBPZjRl?=
 =?utf-8?B?eXBZMnMxYmZmMkJQRWhJRlBNK29LdHNqbjlyMlZhMmFncTR3aWlhUWVXNnFu?=
 =?utf-8?B?M0RVdkhZNkdhc3JVdHBBVTVPSUZoa0xSRHJXN1ZuVTJPbnZydmZNT09Jek5X?=
 =?utf-8?B?b2kyNlB4a2pYQTZVeVkzZDdsZ1pwd0d1OXFvTWcvYnlIeFRTeElOUFhTKzJt?=
 =?utf-8?B?dlYwcVNNZzUvVytLQUhNTHVXSUt1cWJvcXV3cGxqcy91WUdzTUV4U0hGdXIv?=
 =?utf-8?B?a1c4a2xYSTNDK0M0SGlzSGNRY0hLTW8vMTgxZmEvMU1nRDNtak8yMkFOelM5?=
 =?utf-8?B?N2QyOEw4VXlSaUF0b2ROZVdlWmRDSGdxTm1wdklUN1dVbGMvaXpPQXpLMS9S?=
 =?utf-8?B?Q2pleWNrVlhENGZ6MkFSbDdTTEYxNFRjWUFCVzlEQis2d1JOb0xUV1VNZXVF?=
 =?utf-8?B?MXQyRGs1cWNRZzM2UU5qL1BvaWNyNmhZNW5KMi9kSEZ4NUk5MG5XZzdoMTlW?=
 =?utf-8?B?ZndpWHBaMTRuZ2x3dHFDVWsxLzFKVXNsUzJwWUV5cWFTaHhYVWsvOUs2VGQw?=
 =?utf-8?B?MkQxMmZjQTBMdVVvdWprWm9yczgrdjhCK29LUzd6cDRkL1pCSTZjSjlZMkkz?=
 =?utf-8?B?eEgzNGZiWEVvVXFPRW43QUJ2eE44SS93WTM5UDhwbURGNEJRYVZjMDY5M3pJ?=
 =?utf-8?B?aWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 608817eb-0514-4e91-4129-08db965d9ffc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2023 09:15:06.6758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tHzNDnak8nJEejTe8jIJ3LlZcsUZ49DjVULBL/iCnTPuyr+XCqRF3X5QBE0pDg39QpSMHrCjtG48ybBES21r3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7782
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

On 8/4/2023 11:25 PM, Sean Christopherson wrote:
> On Fri, Aug 04, 2023, Chao Gao wrote:
>> On Thu, Aug 03, 2023 at 12:27:25AM -0400, Yang Weijiang wrote:
>>> Save CET SSP to SMRAM on SMI and reload it on RSM.
>>> KVM emulates architectural behavior when guest enters/leaves SMM
>>> mode, i.e., save registers to SMRAM at the entry of SMM and reload
>>> them at the exit of SMM. Per SDM, SSP is defined as one of
>>> the fields in SMRAM for 64-bit mode, so handle the state accordingly.
>>>
>>> Check is_smm() to determine whether kvm_cet_is_msr_accessible()
>>> is called in SMM mode so that kvm_{set,get}_msr() works in SMM mode.
>>>
>>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>>> ---
>>> arch/x86/kvm/smm.c | 11 +++++++++++
>>> arch/x86/kvm/smm.h |  2 +-
>>> arch/x86/kvm/x86.c | 11 ++++++++++-
>>> 3 files changed, 22 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
>>> index b42111a24cc2..e0b62d211306 100644
>>> --- a/arch/x86/kvm/smm.c
>>> +++ b/arch/x86/kvm/smm.c
>>> @@ -309,6 +309,12 @@ void enter_smm(struct kvm_vcpu *vcpu)
>>>
>>> 	kvm_smm_changed(vcpu, true);
>>>
>>> +#ifdef CONFIG_X86_64
>>> +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
>>> +	    kvm_get_msr(vcpu, MSR_KVM_GUEST_SSP, &smram.smram64.ssp))
>>> +		goto error;
>>> +#endif
>> SSP save/load should go to enter_smm_save_state_64() and rsm_load_state_64(),
>> where other fields of SMRAM are handled.
> +1.  The right way to get/set MSRs like this is to use __kvm_get_msr() and pass
> %true for @host_initiated.  Though I would add a prep patch to provide wrappers
> for __kvm_get_msr() and __kvm_set_msr().  Naming will be hard, but I think we
> can use kvm_{read,write}_msr() to go along with the KVM-initiated register
> accessors/mutators, e.g. kvm_register_read(), kvm_pdptr_write(), etc.
>
> Then you don't need to wait until after kvm_smm_changed(), and kvm_cet_is_msr_accessible()
> doesn't need the confusing (and broken) SMM waiver, e.g. as Chao points out below,
> that would allow the guest to access the synthetic MSR.
>
> Delta patch at the bottom (would need to be split up, rebased, etc.).
Thanks! Will change the related stuffs per your suggestions!
>>> 	if (kvm_vcpu_write_guest(vcpu, vcpu->arch.smbase + 0xfe00, &smram, sizeof(smram)))
>>> 		goto error;
>>>
>>> @@ -586,6 +592,11 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
>>> 	if ((vcpu->arch.hflags & HF_SMM_INSIDE_NMI_MASK) == 0)
>>> 		static_call(kvm_x86_set_nmi_mask)(vcpu, false);
>>>
>>> +#ifdef CONFIG_X86_64
>>> +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
>>> +	    kvm_set_msr(vcpu, MSR_KVM_GUEST_SSP, smram.smram64.ssp))
>>> +		return X86EMUL_UNHANDLEABLE;
>>> +#endif
>>> 	kvm_smm_changed(vcpu, false);
>>>
>>> 	/*
>>> diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
>>> index a1cf2ac5bd78..1e2a3e18207f 100644
>>> --- a/arch/x86/kvm/smm.h
>>> +++ b/arch/x86/kvm/smm.h
>>> @@ -116,8 +116,8 @@ struct kvm_smram_state_64 {
>>> 	u32 smbase;
>>> 	u32 reserved4[5];
>>>
>>> -	/* ssp and svm_* fields below are not implemented by KVM */
>>> 	u64 ssp;
>>> +	/* svm_* fields below are not implemented by KVM */
>>> 	u64 svm_guest_pat;
>>> 	u64 svm_host_efer;
>>> 	u64 svm_host_cr4;
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 98f3ff6078e6..56aa5a3d3913 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -3644,8 +3644,17 @@ static bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu,
>>> 		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
>>> 			return false;
>>>
>>> -		if (msr->index == MSR_KVM_GUEST_SSP)
>>> +		/*
>>> +		 * This MSR is synthesized mainly for userspace access during
>>> +		 * Live Migration, it also can be accessed in SMM mode by VMM.
>>> +		 * Guest is not allowed to access this MSR.
>>> +		 */
>>> +		if (msr->index == MSR_KVM_GUEST_SSP) {
>>> +			if (IS_ENABLED(CONFIG_X86_64) && is_smm(vcpu))
>>> +				return true;
>> On second thoughts, this is incorrect. We don't want guest in SMM
>> mode to read/write SSP via the synthesized MSR. Right?
> It's not a guest read though, KVM is doing the read while emulating SMI/RSM.
>
>> You can
>> 1. move set/get guest SSP into two helper functions, e.g., kvm_set/get_ssp()
>> 2. call kvm_set/get_ssp() for host-initiated MSR accesses and SMM transitions.
> We could, but that would largely defeat the purpose of kvm_x86_ops.{g,s}et_msr(),
> i.e. we already have hooks to get at MSR values that are buried in the VMCS/VMCB,
> the interface is just a bit kludgy.
>   
>> 3. refuse guest accesses to the synthesized MSR.
> ---
>   arch/x86/include/asm/kvm_host.h |  8 +++++++-
>   arch/x86/kvm/cpuid.c            |  2 +-
>   arch/x86/kvm/smm.c              | 10 ++++------
>   arch/x86/kvm/x86.c              | 17 +++++++++++++----
>   4 files changed, 25 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f883696723f4..fe8484bc8082 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1939,7 +1939,13 @@ void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu);
>   
>   void kvm_enable_efer_bits(u64);
>   bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
> -int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data, bool host_initiated);
> +
> +/*
> + * kvm_msr_{read,write}() are KVM-internal helpers, i.e. for when KVM needs to
> + * get/set an MSR value when emulating CPU behavior.
> + */
> +int kvm_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data);
> +int kvm_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 *data);
>   int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data);
>   int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data);
>   int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 1a601be7b4fa..b595645b2af7 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1515,7 +1515,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>   		*edx = entry->edx;
>   		if (function == 7 && index == 0) {
>   			u64 data;
> -		        if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
> +		        if (!kvm_msr_read(vcpu, MSR_IA32_TSX_CTRL, &data) &&
>   			    (data & TSX_CTRL_CPUID_CLEAR))
>   				*ebx &= ~(F(RTM) | F(HLE));
>   		} else if (function == 0x80000007) {
> diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
> index e0b62d211306..8db12831877e 100644
> --- a/arch/x86/kvm/smm.c
> +++ b/arch/x86/kvm/smm.c
> @@ -275,6 +275,10 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
>   	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
>   
>   	smram->int_shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
> +
> +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK)
> +		KVM_BUG_ON(kvm_msr_read(vcpu, MSR_KVM_GUEST_SSP,
> +					&smram.smram64.ssp), vcpu->kvm));
>   }
>   #endif
>   
> @@ -309,12 +313,6 @@ void enter_smm(struct kvm_vcpu *vcpu)
>   
>   	kvm_smm_changed(vcpu, true);
>   
> -#ifdef CONFIG_X86_64
> -	if (guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
> -	    kvm_get_msr(vcpu, MSR_KVM_GUEST_SSP, &smram.smram64.ssp))
> -		goto error;
> -#endif
> -
>   	if (kvm_vcpu_write_guest(vcpu, vcpu->arch.smbase + 0xfe00, &smram, sizeof(smram)))
>   		goto error;
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2e200a5d00e9..872767b7bf51 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1924,8 +1924,8 @@ static int kvm_set_msr_ignored_check(struct kvm_vcpu *vcpu,
>    * Returns 0 on success, non-0 otherwise.
>    * Assumes vcpu_load() was already called.
>    */
> -int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
> -		  bool host_initiated)
> +static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
> +			 bool host_initiated)
>   {
>   	struct msr_data msr;
>   	int ret;
> @@ -1951,6 +1951,16 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
>   	return ret;
>   }
>   
> +int kvm_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 *data)
> +{
> +	return __kvm_get_msr(vcpu, index, data, true);
> +}
> +
> +int kvm_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data)
> +{
> +	return __kvm_get_msr(vcpu, index, data, true);
> +}
> +
>   static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
>   				     u32 index, u64 *data, bool host_initiated)
>   {
> @@ -4433,8 +4443,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			return 1;
>   		if (msr == MSR_IA32_PL0_SSP || msr == MSR_IA32_PL1_SSP ||
>   		    msr == MSR_IA32_PL2_SSP) {
> -			msr_info->data =
> -				vcpu->arch.cet_s_ssp[msr - MSR_IA32_PL0_SSP];
> +			msr_info->data = vcpu->arch.cet_s_ssp[msr - MSR_IA32_PL0_SSP];
>   		} else if (msr == MSR_IA32_U_CET || msr == MSR_IA32_PL3_SSP) {
>   			kvm_get_xsave_msr(msr_info);
>   		}
>
> base-commit: 82e95ab0094bf1b823a6f9c9a07238852b375a22

