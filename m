Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1A177511A
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 05:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjHIDBG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 23:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjHIDBD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 23:01:03 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244E11BE5;
        Tue,  8 Aug 2023 20:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691550062; x=1723086062;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Nj5RmB+f/uIJIl+Y1iSyd9KwuZHYAGzX506DXJx2aSE=;
  b=RRhTQu6Dzyjehgfd2n1IOZZR8gqd8fb8Qg+tHi8cPBcm/Tt8iLX0nVu4
   OwqWqMw6zcuOUM/jb40DoTk7ygo+FCdXsbH9GQmVx6IH+E3dYyG4tyddJ
   8K0HW9mhatQQRC/PdUukOAlDmTCDc4C9kf9pObK3gkTke9lfLYLcrZFaa
   RUumNdClN3BIObSLghBaRfSNJJMiZFWvGj6Iupb/FcJ70y4IX9lzkpWCj
   r6IgejKtx8+7HwqPk4COonpz1LgbMJwODftj5pl6CSxBwXy+7H3ofD7Wq
   meW+oGCIymrMUmb5+nmux4mL1dtuHKgkGA+/ZV0kHxXDb5l5tnE++PJG6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="368467488"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="368467488"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 20:01:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="905457166"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="905457166"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 08 Aug 2023 20:01:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 20:00:59 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 8 Aug 2023 20:00:59 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 8 Aug 2023 20:00:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LVcQ/IOYL7W9CWaDSHQWhiouR0Hc3fVHShfZOqldbBLHyAzhj0haoH24a7i9qpTJ4CIvQ3MI/qKOVudb6J1UqVDv86of1sLWJoKhhlonzRqQhCPLtFn/dqlr1xab7x9R0AO5OztLSIcPHAKDMhtAN9prTsGroRlzWK30HpFkCZW1rBqh3bA3Ivsrl0ZPts9LFmUIT8TCNPyPuTpZf1evlKiGiLr/y0rm1mwloLaz7VY9VBTyk6KRZJY8n/UFyLibDIc2e88SpZOxNqiojoh25bGFBXDMgu79Pd25KB+OL4oLyW7RZo3q+b7Z9SdF68iYwQEHPS908M03GdmvRQfLtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+mE93wIR4yo1+znsAPfhzRindPv76tBMuutlW/XVEA4=;
 b=V0Yj5OIzUO2UfEyVpm0kJfBH8ZLGuY50ka9+HtRyzlbQAVLiwFAkkauKbW70H9J0OCk7v16k+9j3VEf0HhF1Q89ab4G7Pnhuslsb7av2oR7avQ3ftWWwXqE987aO5dFIbgGtY90/u0w+pct34wssbjSo7Ad8iqP9ShpHVYVwEeIq1DvdwoSce/k6UtHoEvh+Vi4PNui+PLRBmj+bXOfsqCfikrrhCPiGRsyh3HQVGBmuUUt9fTc0RytRfR34g8otafIwt9IEmi/EfmyM0bdDD+PutviRn9M8kTp9SzShLS9Q07nG6/aPXHpztBeENtVqhvNh6/0LnoAFNwVKMJbhaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA1PR11MB7810.namprd11.prod.outlook.com (2603:10b6:208:3f3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Wed, 9 Aug
 2023 03:00:51 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%6]) with mapi id 15.20.6652.026; Wed, 9 Aug 2023
 03:00:51 +0000
Message-ID: <93eb5aa1-4cde-875d-5acc-5d697834b170@intel.com>
Date:   Wed, 9 Aug 2023 11:00:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v5 18/19] KVM:nVMX: Refine error code injection to nested
 VM
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <chao.gao@intel.com>, <binbin.wu@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-19-weijiang.yang@intel.com>
 <ZM1vvHXCOtbHVX8z@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZM1vvHXCOtbHVX8z@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ME4P282CA0012.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:90::22) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA1PR11MB7810:EE_
X-MS-Office365-Filtering-Correlation-Id: 1078ef77-0b7a-47f3-42f2-08db9884d72c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JpVB97UaGhIsoRfds9l+TXZ1tmp7dSqnYUvCwSRIhsNUmPR0N27btk30Wvez3J0X1rRUaNasIq3lKfUucKAZvCR2dAs0GYtuJrdb4bMUmndZorBJfqeiH6n5l+GXDH2d/7dDA4jtHMK7rGbuw37xTuJWbz+hiwxu73f8CdDCFXfHLM7yzDcxFDlQ4tGcSF8K5APF3WlP+C6H2k9I0fH+VqQ8WCAobk1yvL/zpNg8mkGl/CW4vA2+rjaim5ADvRZdx7aK4hZExCMseOzd6Rl8ycQrp4xHQM/2NBzTemxqypawXxMck+9H0cSR7///caHUANlti53RqKrEibjLuVBMjKusms76dlpwnPwWjr7jbgpDRW1kJC4diDRF7m9PII54n75nj8vuYxrdrKLw3aOieVr7Ip7BfEdvA+mLeB27g7zQrUc9TjwieEL6eKAK1wSbjeFS+e6wHGKGsW4jYOAQJMMWxS0Mizdyp1rwpAKOPh/XLVlYzpzmZRYbm0UTJPcjbGru+uN8wCmJ8IrKLjup+L6o3ofnt3ESu/SBAZKj5EG8Av7S4AFipC2+PBtSEi3eJf1z9scavw6z8PunFw64NKM2n0o4K+aCZwK9IFoz00HIk7oA3uIARemeCqAuk0Aw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(346002)(39860400002)(396003)(186006)(1800799006)(451199021)(83380400001)(31686004)(2616005)(2906002)(4326008)(6916009)(5660300002)(8936002)(38100700002)(8676002)(316002)(66476007)(66556008)(66946007)(86362001)(31696002)(966005)(6512007)(82960400001)(478600001)(6666004)(6486002)(41300700001)(26005)(53546011)(6506007)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXlwUSs4L0ZCZ1BFbXJ5aUJyOUJEYUVTd2tLN0tVYVdYWjlUeEtDUm9zb3dp?=
 =?utf-8?B?SjJ0dXRYUVd5OVBVclpLTkNMRVZjcVBPMTI5SERpNlNuZDd1SDMxcUlHOFlZ?=
 =?utf-8?B?NGwzQmtHUzdiTnJiQjY1cHpMaFYwdFpnSTA3ZWZEQUFQcm5lbGZrbngzVE5C?=
 =?utf-8?B?U1ZORFBzU0o4b2NoYUoxcXlERTlWUjNnVzRqN25DelpicDdiUUF5ZWY2Slhk?=
 =?utf-8?B?OTAxaVZMY0Z6VTk3VDdJb0JzZWpWYk82Q2VnU2RFOHVaMFdWYUlFTmdxYkhG?=
 =?utf-8?B?N3lpSVV6VWRpV0ZVOGxqVWdlZnN1ZzlnYjlrYjdBUTJZWWcxdlU5TXl4b2tZ?=
 =?utf-8?B?amdEU3Q2eC8wWEl2b1luU1BvTFlzZmExSTJkS1d5Vy9XLzlJTlRiS3FKbHp2?=
 =?utf-8?B?Y0NKOFVXR0ZNNnlKbzI5YXZzeVFrb0VIZXljbndqRkh5aE1QM2FJWC8yWTNV?=
 =?utf-8?B?U0pHUkpFQjZYdzAwRFBzQ3NEOW9KTmNLTGNpbTJGTG9OdS9kQWxtNGhyUXUx?=
 =?utf-8?B?Q25tOVp6eVVhMEFzTXk2R0JsTGVWSUpPc1VHaUJBVFRWUkxqcHMvUFEvWWxv?=
 =?utf-8?B?V2l5blVmbm5jejBLTysxOTZhK09EWTFMWnY4Q2lObWcxK09nL09lSkpvWnVE?=
 =?utf-8?B?R0VsSUhMZVFMWlhiYXVNbGZJYnY5NDVNV2dNb0l2cTROaENpWGlxVnBJMWYy?=
 =?utf-8?B?WFI4NHFZN2NRZFQ0b3RlVDUxT0k3ZW9LWnh3ZC8wSWhmWWlEMDFBZFBzWW01?=
 =?utf-8?B?REkya1BaTDlkSTcwam9hcjAyTWpVUnlGR1NZbloyeUV3eG03cTNFa2lBL0N4?=
 =?utf-8?B?RDljcGljT3RBcjZOdEhxR0h3WVBqcE90R3R1cGMxbUluSnMzTldnMDRmTWlj?=
 =?utf-8?B?Nld2cjVUZExHL05oYXJZZFpyVGkzenRvZUpJWjJvaU0vUVEyRmExSzhvd0FU?=
 =?utf-8?B?bCtMNHVBYUhoSUxJdDltSzA2ZVJ6QVNKRU9qa0xYNGs0Y3JKZ0JzbUJvWlRK?=
 =?utf-8?B?QkF1YXNpd2svUmZJbFlVYThVN1RmcmNoaysxZTFOeXhuOXRKdUNZR2JCS1hZ?=
 =?utf-8?B?c0d4R1JEK1pNRGkyQXhBZ1hOMWpDdE1vKzFST3pwVTJpTE90WUxEM29GbzRX?=
 =?utf-8?B?T0Z4NHI3Q1BrUXZ4ZVF6V3VLVGtnZmZDbW9oQmZDZngxZjMyRFd5WUYxZjlJ?=
 =?utf-8?B?TFRpUUdlQWVVU2crSTBuSXcxNEx2T3JJSWlyTzB2Qi9EQXZXREl3QlNHdnVR?=
 =?utf-8?B?UWtvZjBiZkRZeXVUUXh5SkQrMzRBTGg0R3RaTWx4Ti9KNnRpck5YQ1kwWU91?=
 =?utf-8?B?RlJ4S0E1K2o5WTRPVGF5NUdYYzhYTmtHY3ppMjZVU3owSDBONE9zTlN4T2N3?=
 =?utf-8?B?NExnQjgvVE12Nm1uczdudkVtdERmbmlzYmxaMVJhY2k0M3ltTTBsdk4rMHFt?=
 =?utf-8?B?SGdoNVRFS2RSOEc2YjFiUkl4SEtyZXVjRFJpdW5ZSFpDTUo5cVhvWDE5bkpB?=
 =?utf-8?B?Ti9RWVRYeDdZWkF6ZENnay9tb1pQVVRxaVRzcUc2eDZoRGh4b21rcTluZ1NT?=
 =?utf-8?B?eXVtRkdNb1NPRGNmWXc4dG1KTm9nT3hoNXdhOUlJbGJzalUvbkNKZTRCcCtH?=
 =?utf-8?B?WGVjczMybWF5K09vQnNZeWJKMmtNRGdRTjRXRDhtME1MTU9SZ3pEQlg0OXht?=
 =?utf-8?B?TFhXMWdrdk5hMm9tejR4Z09yL2NPbkM2eHpMNGNCOThod2tvcDJxVGFHQjhD?=
 =?utf-8?B?eUFTMDB6TWdlTUo0d1luWWJkTUs4SHYvM0F2RVYwZmJ3cTRnTU5zK0RFbW5y?=
 =?utf-8?B?M1pJTys1RjhZMnZVakJpZjdoOXFjZmN2QTJmZVlzcUtGbitzSkh2RUV3VWlz?=
 =?utf-8?B?OUlzL3ZQaE5BUmZmbzE1OS84a0gzSnltTmJtRElyM3c0K1Zpb3N3UHVzeVlX?=
 =?utf-8?B?RTdycnBSL2x5b1p3UlVBbUVUOWk4c01SbElERDB2b3p4MlpDak9HL1pEV0xh?=
 =?utf-8?B?MEkzZ2VTWE1DVVpZTlhZb1hhKy80M0dZT1FNWkdqWGFKM3dnMmY3U0hVSnU2?=
 =?utf-8?B?QXlBVWM0eENhVFhVeW84cFg1N3FIZ0kvOGlkM1BqTlZHaE5CV2orSUlIWjN0?=
 =?utf-8?B?R1RFOXdjVDdKa3IvR1RvSUx6SnBrRzY5WDNzN1Y2MHVOUG9PSWpmMkxSOEVC?=
 =?utf-8?B?UVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1078ef77-0b7a-47f3-42f2-08db9884d72c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 03:00:51.7381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ue6pc5FFUCx9oegdiiALPQdcCwFGeJxhcpCL3LJ1/BVHAHMEr9pGgLUuqxvYzm6uuJ+wC7amejhUOS4xbbsEUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7810
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/5/2023 5:38 AM, Sean Christopherson wrote:
> This is not "refinement", this is full on supporting a new nVMX feature.  Please
> phrase the shortlog accordingly, e.g. something like this (it's not very good,
> but it's a start).
>
>    KVM: nVMX: Add support for exposing "No PM H/W error code checks" to L1
>
> Regarding shortlog, please update all of them in this series to put a space after
> the colon, i.e. "KVM: VMX:" and "KVM: x86:", not "KVM:x86:".
OK, will update this part.
>>   static void nested_vmx_setup_cr_fixed(struct nested_vmx_msrs *msrs)
>> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
>> index 96952263b029..1884628294e4 100644
>> --- a/arch/x86/kvm/vmx/nested.h
>> +++ b/arch/x86/kvm/vmx/nested.h
>> @@ -284,6 +284,13 @@ static inline bool nested_cr4_valid(struct kvm_vcpu *vcpu, unsigned long val)
>>   	       __kvm_is_valid_cr4(vcpu, val);
>>   }
>>   
>> +static inline bool nested_cpu_has_no_hw_errcode(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
>> +
>> +	return vmx->nested.msrs.basic & VMX_BASIC_NO_HW_ERROR_CODE;
> The "CC" part of my suggestion is critical to this being sane.  As is, this reads
> "nested CPU has no hardware error code", which is not even remotely close to the
> truth.
Understood, I was not aware of the essence of "CC".
> static inline bool nested_cpu_has_no_hw_errcode_cc(struct kvm_vcpu *vcpu)
> {
> 	return to_vmx(vcpu)->nested.msrs.basic & VMX_BASIC_NO_HW_ERROR_CODE_CC;
> }
>
> [*] https://lore.kernel.org/all/ZJ7vyBw1nbTBOfuf@google.com

