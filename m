Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 416D16F7DBA
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 09:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbjEEHZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 03:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjEEHZI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 03:25:08 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C7EAD31;
        Fri,  5 May 2023 00:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683271507; x=1714807507;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yC9TDE8qNj2ywmUpGMmaPCz1aAD4vI5beCAgrXr3/RQ=;
  b=HhcYzUloZVakMd5kyPnn8L4YGGMb4NhtHI/+cW2GoLgmJi7wEhqjw2c/
   LJfy0MvCngLrEDAcTEw/rs0icG1bNY+lq4TtM1kMfaMuHBrzeJB1J8tbC
   fKnFBfpaS0GmUm5L7uSHzulkMTIlZt2iISgg/NmQejt2Zcv+g7HfSz1Vb
   sscAwv2iFLWyCtbWIH4zdB/oG15HyNVZHPDRWXJlCiheCW46oYvnJGxr4
   b8pPH4D0MkayZLkTLgOTpByJh2W0jF/6nBy547FCOZCuEJs0pm3OQPPnt
   GT7H5s5+XrpYtIajT/ThlkzLCEYzoeTUUrAJgDmI0ifSwx/KxRG3gf/zi
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10700"; a="435478354"
X-IronPort-AV: E=Sophos;i="5.99,251,1677571200"; 
   d="scan'208";a="435478354"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2023 00:25:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10700"; a="841583123"
X-IronPort-AV: E=Sophos;i="5.99,251,1677571200"; 
   d="scan'208";a="841583123"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 05 May 2023 00:24:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 5 May 2023 00:24:56 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 5 May 2023 00:24:56 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 5 May 2023 00:24:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fG9ZCQmrKb+nCbvSCosCbvxtV4QoxKjfU8t7nyhrem4Q64cS00CraQ6v+/Vxwiyhl+u4tV1oIcth/TO2qQCme3j24bl/t8nndY9yWciuXnDxZylIJ+HU0MaKDMkyJQcub9ghZfWckmJhSvp/y+OIKKyrBNBGJfFMLLFPA7NRtMtBe2VAw4msBmeDdpX5KTRneFNoyOqeKv850IQi6B1Ol3fL+uPveQPc2HPbSzLGWKZG8IqYwQWCDGUoEW6CwF2WCZq3J/U+8O5JIKuNOp/gKylyggO+9KX0pfWkNHlugJ664cwi8g9GIabpTV/nsb3M50jUg06jR5VFImVi5EtIXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z0EGSuxm9+eXN9D9qurk4S6gVAvVw5bNBJl00KIIQjs=;
 b=JAboqKQCfxCetpY+2JL1CwHER0wrg221vGBJ5F9AHj0aTEsO3dK1dBpO5HkcAI831cpd+MqyqwL+sZ4FtX717bYTIfzLCEB/F0JsLl4eKEg9oW3l3uvbxQmy4nA4uvsXjc1De79gJTiGMfBuBAtiheznPWPR9Ru/IZeQKqMPnjWIJFU/LSD4pdF6z8dtNmEYEcJw0UrRn5w462nCNPEe8DcUYC6b1tl6cR1qtOiVpfw7xdZFoV24gqzJFcoy+qFOjbI1XkRiaY2JZRAqA+4zXyvJ7LiwYcnGWeUxEwO9sEVKuQzgBusAQi4mZgt6ZeYdzg29i75mNLUgrhazG9jPgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by BN9PR11MB5467.namprd11.prod.outlook.com (2603:10b6:408:100::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.27; Fri, 5 May
 2023 07:24:50 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::1ff:c7e7:87de:6d97]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::1ff:c7e7:87de:6d97%5]) with mapi id 15.20.6363.027; Fri, 5 May 2023
 07:24:50 +0000
Message-ID: <259dc6f8-f774-b4ca-91fe-fa8bde2b71d8@intel.com>
Date:   Fri, 5 May 2023 15:24:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 12/21] KVM:x86: Add fault checks for guest CR4.CET
 setting
Content-Language: en-US
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <rick.p.edgecombe@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
 <20230421134615.62539-13-weijiang.yang@intel.com>
 <272d0366-cdf1-f668-9c20-c8631cd7f5eb@linux.intel.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <272d0366-cdf1-f668-9c20-c8631cd7f5eb@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR03CA0109.apcprd03.prod.outlook.com
 (2603:1096:4:91::13) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|BN9PR11MB5467:EE_
X-MS-Office365-Filtering-Correlation-Id: 8338bb2a-61ba-4866-2b3a-08db4d39cff6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v+y2WP1xXGMub3ioJB5j0kEO2lDD3LvHkxT48eSksbjLDqXJCE3uSP2ZHCS90eFVIpc/GSN3OyYzf55UqyBe8MA2KBMdtcyonn1FG4vwukDwEyaWvkm2HDQaGsBeTB47oLs9zM90JX8aqplibjIwzAeve+YMOLBosF++QPJYx1ZziE7LS2gVyGeNGGjc5vSjxqLlTIQ/RqFJTU+LVdKjbj8zjKR+4EWC/DcbV7LNG8s0eE2Rz92TyHQz4sBTR/sPDYEalrKVDSvnhQmwuE526WMiTAobjvsjyJ5KD7ENsTAmXOZfW+h1r+lbg6WI03pnTVYsSnjtp2ZvkTWyb6au98hQJ7xKfBITw7XhMW2+V2I7NE+6/oPCxMcKO/2iWpJOyBuLVn75S5O09hmQQveAM7MWt0mW0WaVrQY7QGi9ENvBXnz2rkXrdIMDUzb4rmYaccBFCmJMrTLXw5Dt7aIzIlz9qVJW0IdvGoqa8fwqZTSLe6EOgJfykw60IuLqUJQC7fL55/n0GcjYwyo5g/b18cr/yE4eUGGF0yn+V9GtUQcSlWuF9l6Fcu349Y7tiwX1pVFtX+D8uBECagIOiMY1AIz8oLtAsXMScgGF1RzUxvjHDABnJtGov4mvMnQJWCcBW21dPAFZFfqYbY2LEWSlkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(376002)(366004)(396003)(39860400002)(451199021)(31696002)(86362001)(36756003)(316002)(66946007)(66556008)(66476007)(6916009)(4326008)(478600001)(6486002)(6666004)(41300700001)(8676002)(8936002)(5660300002)(2906002)(82960400001)(38100700002)(186003)(2616005)(6512007)(6506007)(26005)(53546011)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmEzSHg1cDhaZE1xY3A0UWc5eUxDU3lwbUN1R1RCR3B2YmlmQjhoNHdQdGtp?=
 =?utf-8?B?R1oyaURRUitkajBmMVdaczdrNkpKME1zck0yOEpMMFRQZmtoeEh5SndFdnZU?=
 =?utf-8?B?bTB1WWFWNEl1bExKSVg3dE1BbWROMEZlbHl2bUllQm5IbFYwRzFJZ3o2MXIw?=
 =?utf-8?B?ZkFBV3Z1cllrYStGeXZpdWhTNmcrbGZQUHhFZWNzU0M2aEthR2RpQVEyNkxR?=
 =?utf-8?B?WStRYlBjRHRlbWFINWRiTVRIMXVmN2UydU5mY2NQSnNORXZqSEd4bENhRUxj?=
 =?utf-8?B?cnlQaTUyYzdSUmhHRDQvbXgxOERMeC9TNFB2M29BNG5NbVRUTExWS1dXbmFE?=
 =?utf-8?B?T3BZMWhMa0tTSlU4MmxlNENHMkpqaGMrZ3NhalVxTWJCclEwTUFSaTViaFJ1?=
 =?utf-8?B?RVBhNmdDNnlGeTRUMk04ZUhhUkZYT1hLR0hDTW1ucTFSaDJ3c3JTNGVLQ1hQ?=
 =?utf-8?B?cEZsRlp6eXhyaGJFVDJlSUQ2ZmUyTlFKSHhtd2dEajNiWjB6cmZNMGNhQTA1?=
 =?utf-8?B?QUR6WmQ5eWRaaWJpQjdzWmN4V0NwQktwNlU1WWE5cSswT1piaEh0bmpsdnl1?=
 =?utf-8?B?c2hRb2ZNS3ZlbVVaeE1acU5WaW9TT3NKdjdPRkc3SlBCa21tRkhLMVFGdHFM?=
 =?utf-8?B?ZTJ3OVg3WFd0dXgyd01HZ0k0VkVRbmNUQTA4UnF2NjE5b0xJYjZTZ0cxKzhT?=
 =?utf-8?B?ZnN2Y1NCbk9TNmxYSHBGbHVoRVRUTUJyMmdWWkdGYVpsRk9hOEZOL0Y2WmFu?=
 =?utf-8?B?RUZDK0xwczB5ZW9pSjFKZk8xUHZkSS9jUEJCVXdSd0ZaTUVQUzVROGU1Ylpk?=
 =?utf-8?B?bEdXQlVPSjUyMzZjU0VuaWRuemVuYzhuS1lidERxaFVnREFlVVhtWjhiUDBs?=
 =?utf-8?B?NW9xdzYxdWoramZReFN5NHhQMkt0cEhidXRscW1ENnpGWmg1VXg4YnZ0WVJF?=
 =?utf-8?B?eUw3ZitGUTBWVGNvekp0bXhqTUs1Z2VMQVV5SjhuT1VKUXlYYUx4eVN5aXZS?=
 =?utf-8?B?YTdRcDl0dStNTXRKb2ZNTDE1Y0JjZnl6bkdPZ0JUdkswdURhcFk0THhiNnpo?=
 =?utf-8?B?emJabkJxNHByWUdITERxT1kyWEJJVDZFUnJ2UFY2NzBNUTIxdFBkM0ViZHpW?=
 =?utf-8?B?Q3BzdEdKWk9mczFsRTZXNWwzS3FBRVlkU1lOdGVsWDlDSjdYSUVKbXR6SVNt?=
 =?utf-8?B?Q2llSkNIQnlqZWh5ZlJSQlM3Y1R4STlHM1RRWnpZVGpQS3h2MXJFUi8rNDhK?=
 =?utf-8?B?TFJmZkV1dUtRaVZ3bHNqMTByVG1iWDdSNTJMQUdQWkVEanB4VlpTMEZ4dm9S?=
 =?utf-8?B?NXJOTjNTbkpoOFpYM3NCRGNDazh1eE5mNmFXVlkzTDRvKzNJY0RhOUsvL2pW?=
 =?utf-8?B?WFpXRzlXTzRjd3NiNnJGcWFwYW8yWUs4WFNBY3dsc0hSaWE4V1QrclNicmxk?=
 =?utf-8?B?bmsyaTFnZEdoaUViYVdvUGN0TUZiMzliQVg4cTBSZ1pISHhrY3lzcWNka1pk?=
 =?utf-8?B?bDltRW56ajhvcGVMelBCUUVaRnUrQlRabDdsOVFxMFFUTnBYa0JyK1ltb3Q0?=
 =?utf-8?B?RVgwV2taQkpwd1lvcWF2ZTJRVkRhdzUvTGV1KzQrcFlaQ3RQeU83ZExZeHN1?=
 =?utf-8?B?RVRVek5kRXFXRHQzbGZaU0xyNHN4RGJEV28rVGY4U1JEODh6U2h2WWE1eklN?=
 =?utf-8?B?bHZCNERNTFViUjd4TW5GMUxhRXhoSEJxV0FNR1dQV3M3T2FtRkx5ZjAyVmZr?=
 =?utf-8?B?TTN2SkhFbnNYZWQzVWN6TnpPdG5uVitHc1ArUUhIUnJhcHlPRkphb2VxcHcw?=
 =?utf-8?B?VjZRVTY0UVFMY2RxRVlRck9VTnBwdVd4M1VSNG9GT1dUY2VyVzRwNVVVeXNX?=
 =?utf-8?B?VUdnQmV0eXFmRTB6QUVIcXROU0dad0czd00xaHZXRDJaWkdMSDV2RnlQVEdT?=
 =?utf-8?B?MWpUc1dmUytUcTZuWnA2RVE3N3NTbWVjZGcrMWFKM2tscW92cXBrMm5WME9i?=
 =?utf-8?B?Zm9STHc1RVVhcGdGL2hFalVHL2laV1I2RlV1N29QMmxwZHJsMEluVGJmeGNr?=
 =?utf-8?B?VE9ZY0F6SGlLcTY2U3Q3OGpWUUpHWFF2NlVtL09kNmF2MXE3V2YwamIxUmVn?=
 =?utf-8?B?SXo4Ykc2a2wrT2VkM1ZKQU94eVhOMUdONTdFYmsxd3pCTDBuV2xnTEM4ZzJ2?=
 =?utf-8?B?N3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8338bb2a-61ba-4866-2b3a-08db4d39cff6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2023 07:24:50.3572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BjLbsVbqLuOT1jWlc2MUlq++iWH3Jl0PUKcy+K1RHXRDpOZbmBX8CQfDskkPijh/8ItceaMnHo0252pBAHPyUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5467
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/5/2023 1:01 PM, Binbin Wu wrote:
>
>
> On 4/21/2023 9:46 PM, Yang Weijiang wrote: 
[...]
>> @@ -995,6 +995,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned 
>> long cr0)
>>           (is_64_bit_mode(vcpu) || kvm_is_cr4_bit_set(vcpu, 
>> X86_CR4_PCIDE)))
>>           return 1;
>>   +    if (!(cr0 & X86_CR0_WP) && kvm_read_cr4_bits(vcpu, X86_CR4_CET))
> You can use kvm_is_cr4_bit_set() instead of kvm_read_cr4_bits()

Good suggestion, thanks!

>
>> +        return 1;
>> +
>>       static_call(kvm_x86_set_cr0)(vcpu, cr0);
>>         kvm_post_set_cr0(vcpu, old_cr0, cr0);
>> @@ -1210,6 +1213,9 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned 
>> long cr4)
>>               return 1;
>>       }
>>   +    if ((cr4 & X86_CR4_CET) && !(kvm_read_cr0(vcpu) & X86_CR0_WP))
> You can use kvm_is_cr0_bit_set() to check X86_CR0_WP

OK.

>
>> +        return 1;
>> +
>>
[...]
>> @@ -536,6 +536,9 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 
>> index, u32 type);
>>           __reserved_bits |= X86_CR4_VMXE;        \
>>       if (!__cpu_has(__c, X86_FEATURE_PCID))          \
>>           __reserved_bits |= X86_CR4_PCIDE;       \
>> +    if (!__cpu_has(__c, X86_FEATURE_SHSTK) &&    \
>> +        !__cpu_has(__c, X86_FEATURE_IBT))        \
>> +        __reserved_bits |= X86_CR4_CET;        \
> IMO, it is a bit wired to split this part from the change of 
> CR4_RESERVED_BITS.

Make sense, will move these lines to other patch.

>
>
>> __reserved_bits;                                \
>>   })
>
