Return-Path: <kvm+bounces-1937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B5237EED97
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 09:33:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B38192811E4
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 08:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEB7A3C28;
	Fri, 17 Nov 2023 08:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IrzHVopD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50268D4F;
	Fri, 17 Nov 2023 00:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700210019; x=1731746019;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9fAl1ssgyAW1N8b7oKgYYrYcXXvVYl9J4rKJ5h3HmX4=;
  b=IrzHVopDw78QOqXtHWl+UDLmECMpjQRUtW6/wGW+Z8quUW08m7BsDSN/
   1NZ1E+wSKyLoKCwe5pglqyFqKsJ7B0Nb9z79v2mU/wu2tt/bE/vvz1wOr
   oDURMYdQyJYUXHXC6euKTHNkIFZ/U/majqfmkCHkv5jD6KL61I6Mcbd/O
   MfYVkSzh0urrHABVlUj/bZdrL0ZoBIczZdv40w0tgppdwUN9gnZdMPlPr
   gI3OamsWf1n+O6I3KqecFcYS1lJ4pr7NqXwmyHfuiQgaix2mDgWmRUKmA
   ef2JjNVmZ/rAgwgjveu3emHgaxbYwyqq1KJ+IXcyYjkLlBVd33S3iLtkj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="370618358"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="370618358"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 00:33:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="6960612"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Nov 2023 00:33:38 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 17 Nov 2023 00:33:37 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Fri, 17 Nov 2023 00:33:37 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Fri, 17 Nov 2023 00:33:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CyptoxWLA9hhZQZszzyldZASPerBGGZHjKWeUpxkoPPuqoNAFLtDFzjOakEgHK2CRuin/JAp60OAqOBM1T+sOVXdmAzXN1qLfkGfn2SBlMVDzZUBvamjJRh4Dfhe57nEulMSBCoOSWdeaaynwNxBUYod84s2GXkLm73O4bDyjc0tFivsk/9fc67jeFVgSXA56kngddl+1VOwCpA2hQJr3FGN31YtHrWhvCS3i0TSQL6kqUarNhskORCr6N81XxuSUzKiEtkMm0z5zqoenhMrARjMtP6KKkqsuIt9GD28t5nm9iDyjLPqrnBZMlm09rG5zz48HufxzFqH6AvAhWWHug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cv7pt9ZXLOV36Zq2vAqsGy0meIIPRdoWCyvy9m3M1Zs=;
 b=B8wPrkLTfeGuVYzMl1yL9ARm7eix2YdKsNV6wZYZfuMw1xmHF1McKJUgz61OQ7Hki/YnNy2f1Qs7fSoMAoe7iuefY2uk9c+PGsjda5tMFg6Vc5MutB3MzZk2/bsabNaz9yv8eGY2l/DsooIr7Wun3BC3HP9JKFbML9mZMBc2s4D4A+76HjuU6t2nIOpjOQUcIC7HKlv0hb9btkqtJ6EvzVpIAufR5MxCqWufHW8da1gtDZbAMq/HQ2kNCwh0eCqzww0RxSwFwhWcEC3lxCL78d2bOSHNoaVouRuMaS+RDI2Pleqzps3ozI9L/HcbenQ30Ia4nuWRlzilNSszluqHrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA0PR11MB8398.namprd11.prod.outlook.com (2603:10b6:208:487::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.21; Fri, 17 Nov
 2023 08:33:35 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7002.015; Fri, 17 Nov 2023
 08:33:35 +0000
Message-ID: <c9401dbf-88a0-404d-a8d3-33f0e712cda3@intel.com>
Date: Fri, 17 Nov 2023 16:33:27 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/9] KVM: x86: Initialize guest cpu_caps based on guest
 CPUID
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>
References: <20231110235528.1561679-1-seanjc@google.com>
 <20231110235528.1561679-4-seanjc@google.com>
 <c9f65fc1-ab55-4959-a8ec-390aee51ee3a@intel.com>
 <ZVaXroTZQi1IcTvm@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZVaXroTZQi1IcTvm@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0062.apcprd02.prod.outlook.com
 (2603:1096:4:54::26) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA0PR11MB8398:EE_
X-MS-Office365-Filtering-Correlation-Id: 9293818f-107b-44b1-adcc-08dbe747e35d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pQ7Wt/w7l+aS2F1gL9Jwb25iHJT8HsuKeFdWW3y344RT9kgeqcT965rmYeZ8sY5nK7EPlLeGHuEeW6lmxj/uDOWr2+JpsJPvazudKbmBpKhV8XHF4nIp7V0CViZfnVWAGu/MKjX36RrlbCWNOIeO7oS02HhdSUGVwegcubqIoyg2xBuSylESv8LZL9CVTNi/6jWBUyvSq1E3v5rKu1tKLixO3PTyHz0Ajf+Qy+eUJ/R1OwPmJi6FQVrZ7HUoT1tRcxlw0J1MSkp/3ZhKEUlD7FNXcloahEFLRSm4Hk+6FjVQW4IysiNMM6HL9x8JCV7C2yu35WAzS/4QfQLSc+vnSMwPy+Ft8l5ulrYEroRI4l2egcUGd3F/rJiGwYZW7HIouKBtJRLv1q8hKlToKZVFygow80xISAWltLQCCgzeOjhUpbL7CCSdye9pNHkeCEjo13E/tOj5snpa1kkA909vjTT0xl4i0N6jpWZWNLHw+J0MZOPmGWThjvyt+qHs0wfqTnhJVjhZ2pjmjDceyOCtE2C0NNsr9rFyzEJszrEYRezGiOAJ75Jdx0qsKSwCsZE8tl0unenbXT2JxEkqmX/YDSOpODwUyPAlgdcTgoaqyjgZMB9oMf0rvr2TlJ0p9FgGhw0vOIwnvP8FS8jNrAWnoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(376002)(39860400002)(346002)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(36756003)(26005)(6512007)(6666004)(53546011)(2616005)(83380400001)(5660300002)(8936002)(8676002)(41300700001)(478600001)(4326008)(2906002)(6486002)(316002)(66476007)(66556008)(54906003)(6916009)(82960400001)(66946007)(86362001)(38100700002)(6506007)(31696002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dzZkTjVBTXU5RlVlTFp2SVAvb21EL0VKb2J4RC9EaHhtOUZod09GRjluTlFZ?=
 =?utf-8?B?VGY5OHFhaWNBalcwYnorTGJ4eEZMdWhQaTlWazgzaDZUUXFwWjBvZ1l3aHRh?=
 =?utf-8?B?NjlRQlVYZHFtMG9lemkzOGw2NG9ONVhnMDlqbGFvc0lpQVhnMXhSdXZ6Nmxz?=
 =?utf-8?B?ZFpPbXNLZUMvVzc5b0tPNFYxWjFjNXdiTmtKYXhNZnE2d1dlSmpvQkhacXVo?=
 =?utf-8?B?NjN5ampBOXJzbCtMNnJEREp6endXRTViSVB4Y0lzcGdpUnFoWkdrSVN0czlL?=
 =?utf-8?B?dVpZUk9QZFQwZi8yNTFGbjQzOTlzRkxqalFZK0pycDBUbDR0Z0xoLy94eS9x?=
 =?utf-8?B?UVg5bEhMcUdMa05jS1N2YlBGWFlET0ozWlkrdnlyK1V2bW11TENZVS9GSTZZ?=
 =?utf-8?B?RXhnaE5CUjhjOEpsTytFbCsvOFBKMkNTVHMvakxpeFBtYkRrWHJHNzRKS3F3?=
 =?utf-8?B?STByNVV5RHA4ZkJObnY4NHZ4U1V4TjhiZktmWXgweXRzcmVwTFFRUXAvM2xW?=
 =?utf-8?B?U1NIRWhLamhaU3RZMUhpSVV1SXZNblR5ZGpMTTllNTBEYStlR0ViYjZyMEZR?=
 =?utf-8?B?THBZK1pIQmhlbUVFMStWa2Y0UDNaczMxRHY1eklNRDBZVUY1S21qdXU1WU9y?=
 =?utf-8?B?bmxNRS81SCtYNVcyYmhtN1ZMaWdwYVlRS0xRN2dSWHVPYVJXZkVUL3d6YVhh?=
 =?utf-8?B?a2NYYXBHSXB3YXZpZlE2SGRNbU5nRlIveVNBZlUvWFJjQkc2UGZNWHZkWTNr?=
 =?utf-8?B?bnlEbmdaTnYwbE1uOVFqM092cjM3Z3Y0SUVmUXk3djVjUENBaW1SR3ZYZFN3?=
 =?utf-8?B?cyszNU8rZ0QzT2ZNaFdSRThCNXFVSzRMRmdUVGJrTmhvM0RNRFowbUtYTjFs?=
 =?utf-8?B?YmFUcmFoYjdNNkpOZTl5WUJJL3YwMGdFWStSa0FmYms4a1lZM0g3cm1VU3Bt?=
 =?utf-8?B?N01pby9vVXpWUWZCclczZ2NpYVZFLzlwb0grK3k5UWMwOUhnUGJUbTNZSEY4?=
 =?utf-8?B?U2FySTVlMS9Sc2FOR05RQ29HQ3FYUTJ5a29zclRvd2twK3o5KzRHWjZJWlBX?=
 =?utf-8?B?SEY5Q1lLYWR6RVhaQzhJRk5XSEx3Um5LQzNrM1pBVVJaeHpGMkVGNzgrMFBw?=
 =?utf-8?B?eHFvMGl2dkM5K1VRSGhwMnh6WVRlODVVRWtiUXhPelloUVd4WWJmaHZBNFZG?=
 =?utf-8?B?VGJvTU1WYXEyRS9HNWdhdGN0UXJWWkJsL0JubVl2akR3WlFoZEc2cnVVSlRq?=
 =?utf-8?B?SE13TUNkRTk1SHBoZTZBbFlRdHl3b0VjUzdMTzNkblpoalhsbjh0SllKR1lG?=
 =?utf-8?B?RmFlb3RUNkhwUjQ1RlBmcGtFcEY3RVFST3RPdkV6UENVS0R5TjZqYWFZSWVI?=
 =?utf-8?B?K0dmdHBMdXp1UTdBWVR3dU9vbzF6SGpPSkVTYzBmeE1FWTE1N0oxcng1aWs5?=
 =?utf-8?B?OVpqVG9aK01DbXphV05JbE9MeEgySGtCZjJ3NFdPeWVmOW15cktTLy85Q2ov?=
 =?utf-8?B?cUdCeHRiMVRFV0ZmQjFidVQ2K1RCS3d0UHdWV1pWWkVibkkyL1NFL1VKSXVh?=
 =?utf-8?B?YkdoMy9zT0NMdTFIZXkxY2VzRWZGcXh3eWpId1dPN09mUmFvL2crdC9yTUFN?=
 =?utf-8?B?d0FMSDZ0V2daZzBXY3F0aWlVY3R4SU5TUytHRmY0dUFIY2IzSDBubjlPUHdw?=
 =?utf-8?B?UjRrd1RCQ3hvVjNnc25UNk40QTZpR1dYTHRVZVFDU1RIelo1LzA1L1NTdDdD?=
 =?utf-8?B?WWhSckxWa0RoNHB1S0x1aDZ2UUNLdGt4U05VNUQwb0RvMW9XRlZTOVVUVHlj?=
 =?utf-8?B?ZUJBZG5lbUsyUStmQTQ1OWZZYjQ1SlIwS0FEdjdHYTY3bFQrdHorZUZpcElj?=
 =?utf-8?B?dFFBbDI1dE40NXBoZy9ld1VPSkZJNnpkWlZKU05Qa2FzMWJLelA3amlqVHZM?=
 =?utf-8?B?U01TSmgwdy9ncWtPNmZOS3c1NTNaeHg2SksrQ21EQ2FmOGdyZE93V0lVaFNh?=
 =?utf-8?B?MTRWTzQ2ZTZYckRxY25FajBleGdLY0tIMEVPL2puSmpxTlFsVDBhczFvRVpJ?=
 =?utf-8?B?STFCamw3YVp4cEduMmFFTlgyRmFuVjVheGkzejRQTkFMc0M4YjREcXZUWU15?=
 =?utf-8?B?cmpwYlc4Q3NjWUxQbHUxL2ZBZmpCK1VUWDNRWVVWZ0FwcXVjTGpURDIySjRl?=
 =?utf-8?B?dUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9293818f-107b-44b1-adcc-08dbe747e35d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2023 08:33:35.1356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dD8aa1eYTGFsJUDHO7GW/ukvEgs5R0tRypan4tBNO+U9mOKE+AU+erpxEbQhAN8/UeTwP1ZQrwHEIJbiSU5KHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8398
X-OriginatorOrg: intel.com

On 11/17/2023 6:29 AM, Sean Christopherson wrote:
> On Thu, Nov 16, 2023, Weijiang Yang wrote:
>> On 11/11/2023 7:55 AM, Sean Christopherson wrote:
>>
>> [...]
>>
>>> -static __always_inline void guest_cpu_cap_check_and_set(struct kvm_vcpu *vcpu,
>>> -							unsigned int x86_feature)
>>> +static __always_inline void guest_cpu_cap_clear(struct kvm_vcpu *vcpu,
>>> +						unsigned int x86_feature)
>>>    {
>>> -	if (kvm_cpu_cap_has(x86_feature) && guest_cpuid_has(vcpu, x86_feature))
>>> +	unsigned int x86_leaf = __feature_leaf(x86_feature);
>>> +
>>> +	reverse_cpuid_check(x86_leaf);
>>> +	vcpu->arch.cpu_caps[x86_leaf] &= ~__feature_bit(x86_feature);
>>> +}
>>> +
>>> +static __always_inline void guest_cpu_cap_change(struct kvm_vcpu *vcpu,
>>> +						 unsigned int x86_feature,
>>> +						 bool guest_has_cap)
>>> +{
>>> +	if (guest_has_cap)
>>>    		guest_cpu_cap_set(vcpu, x86_feature);
>>> +	else
>>> +		guest_cpu_cap_clear(vcpu, x86_feature);
>>> +}
>> I don't see any necessity to add 3 functions, i.e., guest_cpu_cap_{set, clear, change}, for
> I want to have equivalents to the cpuid_entry_*() APIs so that we don't end up
> with two different sets of names.  And the clear() API already has a second user.
>
>> guest_cpu_cap update. IMHO one function is enough, e.g,:
> Hrm, I open coded the OR/AND logic in cpuid_entry_change() to try to force CMOV
> instead of Jcc.  That honestly seems like a pointless optimization.  I would
> rather use the helpers, which is less code.
>
>> static __always_inline void guest_cpu_cap_update(struct kvm_vcpu *vcpu,
>>                                                   unsigned int x86_feature,
>>                                                   bool guest_has_cap)
>> {
>>          unsigned int x86_leaf = __feature_leaf(x86_feature);
>>
>> reverse_cpuid_check(x86_leaf);
>>          if (guest_has_cap)
>>                  vcpu->arch.cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
>> else
>>                  vcpu->arch.cpu_caps[x86_leaf] &= ~__feature_bit(x86_feature);
>> }
>>
>>> +
>>> +static __always_inline void guest_cpu_cap_restrict(struct kvm_vcpu *vcpu,
>>> +						   unsigned int x86_feature)
>>> +{
>>> +	if (!kvm_cpu_cap_has(x86_feature))
>>> +		guest_cpu_cap_clear(vcpu, x86_feature);
>>>    }
>> _restrict is not clear to me for what the function actually does -- it
>> conditionally clears guest cap depending on KVM support of the feature.
>>
>> How about renaming it to guest_cpu_cap_sync()?
> "sync" isn't correct because it's not synchronizing with KVM's capabilitiy, e.g.
> the guest capability will remaing unset if the guest CPUID bit is clear but the
> KVM capability is available.
>
> How about constrain()?
I don't know, just feel we already have guest_cpu_cap_{set, clear, change}, here the name cannot exactly match the behavior of the function, maybe guest_cpu_cap_filter()? But just ignore the nit, up to you to decide the name :-)


