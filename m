Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D876F629B
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 03:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjEDBVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 21:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjEDBVQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 21:21:16 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E147CB4;
        Wed,  3 May 2023 18:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683163275; x=1714699275;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=NmhLfDzGygnWUKJeuMdz6hYEBeQeCuLwmGbFXpmbYog=;
  b=dHsYt4dVHD6sJelv8eomL1raMTaw6vQVnSNvSxxsIOZSEhpdsSyriG/A
   0o4wDKGapLmvN+vvY8SljqdxMNr6EdTpQtzMoL4K7CFs9tl30s/xjr5+/
   MEngvVVS4PGthkCcrAogapzuJAhDo3GE+rh3JrxnLo+8HZajie7f5gkmQ
   Fud7vi7p/Kk90QzckLTPVtGaSAgEHQtAEoZpLZQCqyNtWBEgTrWcAtWuE
   dlHJHQz5AeO45dK1LSI2t5GWXbej7jPy2gkM4fC4INLIHA4NmITWSG9wr
   w3zm1Vnly8QTNcDyEcaS+O0ZN4hthJck2LUdJHIs0p2nIRwvLZmLypgzE
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="350887783"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="350887783"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 18:21:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="1026733328"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="1026733328"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 03 May 2023 18:21:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 18:21:00 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 18:21:00 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 18:21:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CbP2LvxZl6j2UbUXpH3qFWL/PdrHSrFSW/NyjjVkWzX2JWACunKqwBicONYNJaJIbu9DkywJ4/s/4ARWtMgouGh4pBe2iL+FPRHpg9jLctux2F2p5ktVIN9B96BMaoVnt5CUjCASiLUJ8c3tCTAPLKSLcofm61QiDqMja6lmffu3yQ8NYPu5OQS9K1f7iAtCev7VJxA80A9bj16IrDOVdPbwk0InkGW+3aHDcwLI8ldcZsx7NA5AN0N2fc3tQbOl4RdTFvA8K03QbLBK4fTLmbhJJUP+UGBsGBfLNPcPJvFD5b+OZ8KlMNJXg3UIIDKAhWQmDMrKozh9bIuBVpzjJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r/YorxuGtyashbXzgdsz3vA9f+Nfpiy54j+dFQPVAGA=;
 b=Uh87kcFi4u6YhFLD2HZz1rKT6IN1Ol8kChFBCI8TnayxxTaHlvSYHIamxXqZTCGGtYco4Z03c5QTbb7O1zBIjbJBJ+7mNv0Iu7PEwttiMjOsyES9OShp3EAw8vV2nW3eZ2rbfh7HEAc1lVTR0htEd1hKF8ZleqkU+APyWyy7X4KxdRbBbe7f3wsaXSM/NLNIYjFlGTpAONSwuIQWBOjujSr8khIrMGOR99DbHGN6lsWlJNElaB65L4ZRfifMedAi7q6Td8QG8wCJsO1dW8QCY5K6++ZtEZ2ZMbPVF0g5wkAqt2Q1+jLB/Tt+WJrXjdRIhELdr3uSHgo42wF3dpAkHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by BY1PR11MB8031.namprd11.prod.outlook.com (2603:10b6:a03:529::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Thu, 4 May
 2023 01:20:53 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::1ff:c7e7:87de:6d97]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::1ff:c7e7:87de:6d97%5]) with mapi id 15.20.6363.026; Thu, 4 May 2023
 01:20:53 +0000
Message-ID: <c9747bd0-2a1e-a7ef-4775-b5ca7c00b24e@intel.com>
Date:   Thu, 4 May 2023 09:20:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 21/21] KVM:x86: Support CET supervisor shadow stack MSR
 access
Content-Language: en-US
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "john.allen@amd.com" <john.allen@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
 <20230421134615.62539-22-weijiang.yang@intel.com>
 <175c826d59f1ac77fa588908d3768ffc2e79268e.camel@intel.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <175c826d59f1ac77fa588908d3768ffc2e79268e.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR06CA0193.apcprd06.prod.outlook.com (2603:1096:4:1::25)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|BY1PR11MB8031:EE_
X-MS-Office365-Filtering-Correlation-Id: 2282fd95-f552-44c0-4754-08db4c3dcd61
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kx5MwzFLE+2+PHLpWmbMI9Rd5oT0eoasxGJH4prfvUf70ZDvLplSq33Sh2mTq2Rhhw0K1i2duc3Yajn3wHDm6Q3n1UYZ7K1x99hWKx27kt1JOLGa7mPGo0sJRLvmTeJDim21J9kFqxLCgAdFS4Fjnz4005hS3bnCwtRhPaFtzBI3cTjTQ+HRHxqcZIjtdLEEfktPeuuVoqdt9qF9hgVnggqAkPSOLRmw8tUVoIdRmmXHWIdZkVbJ/1CT3L3RhKOOeubXoG+NxUmy8eQRYAU5OjQM9jvK8uB11UtR+gg0q2I3dvcwiHZFfL+AMgcYfRQ4YCETLvKovjXfTQYZzVDY9ZwuV3HqjmrWvwZsMccecyEvJxgv23auKDVJYEcvzsw5AAp0Uqa4s1K+zXdDBOCyaht4FPmmZpImpVZn5blPVrm2MQxn5BWn5i72aPsj4k6WCnowNt9ZciyTqYwAJSccOLzhC2kSCtcsgz4ZTQ68Wn2xAMkJb3BwLcQpAIxx/jlWN7X5pv+rrtl8q5H4MUiUgdWvTTEUowLAzjpTec3gtufLUsP/COSNIQa9OknMg1t6irkLPt63j0EpvD5ExC2KsnVY2nOz7WwfVLnC+jR2ViPl44tChWQJMLBdky5iNbuNGfKJhVMt/814yYEiAofMm11GsOqllJW8Qtu9fW1aQw0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(396003)(366004)(376002)(346002)(451199021)(8676002)(8936002)(6666004)(36756003)(86362001)(316002)(41300700001)(6486002)(31696002)(66476007)(66556008)(66946007)(82960400001)(921005)(5660300002)(478600001)(38100700002)(2906002)(31686004)(110136005)(6512007)(2616005)(6506007)(186003)(53546011)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWMyWTNIMTcwQndJc0RzRlBka0pQcmNGcVFvOWh6NGkxRk5UVW9GdVFEUU1P?=
 =?utf-8?B?Qml4OSt6eWdiRHVxNE5KNjVpb2RvZWVKUnlrS01TUmI3RDl5NmtpUVlkQVRu?=
 =?utf-8?B?Qyt5L0ZCNkU3MEZKY1pHR21PTVNoU1RQOU5DSnBxOXNkMEhTaEJxUWRsLzNv?=
 =?utf-8?B?K0twbnk0MVlaT1RXVUlKdFRySElvNWEyTENZUUlqRG5TclJ6S3oyZUsyOVlD?=
 =?utf-8?B?WndpZnhXOVZGTnNkcFpjYVlLaWMrV0VNRGtTcnRWS3Z4dk0xaUtSWUtRbmZ5?=
 =?utf-8?B?SFlWblUzeVIzVkpoOER5a2hOeGVScWhjb2t2Qzk1M21DVmdRS0x4MkVLUSti?=
 =?utf-8?B?TDlXSHJabmVJSDNyNmVZQzF4cnlmKzYwM2grSDZrbE5QOCtncStvT3FhTW92?=
 =?utf-8?B?Tml2M0dtTzNlc1o5Wmk5K1N6VEo2Zll2dW5qcmNxaG5NVW9PMjJFQTQ2cWVa?=
 =?utf-8?B?ZmJ1QWFwNEFDeUZQdW5Fb2psTm1HZ2ZBQlNudVovbjBtM1MxYmZXVVFoSVNh?=
 =?utf-8?B?Z3RDSG9GVGFxbHpxeGNVRk1LT1BUaUNHUmlEZXhPbHpsVm1hOXo4SnpyMHRK?=
 =?utf-8?B?enU2dW9oZDMzL0VHKzJSSC9LdDZsNWQyT1hwSWtvRW5mYnljRWJSTEF5TDF0?=
 =?utf-8?B?RmpJMGgrUS9kaFc0eGduNjN5TEVEb2FSZ25sTzkrU1NxQmJpSkV2ZlMxNmJa?=
 =?utf-8?B?aHZuSzYyUy9GcitMYVVGMkVZbGgvdmcyRVVPNjVhZ3p3V1U3b1lVWi9NdUlD?=
 =?utf-8?B?MUc0WDhnZ0p3Y0hOU3E1eFdPWGRrd0drUGFmK3A4eWFmR3ptQVNPQmJncXdo?=
 =?utf-8?B?b0dva3lFY2FtNVdURnduWTZQcS9pTVdOOWVSWG1vc29Send6U0JTWWZjL3pU?=
 =?utf-8?B?QTJuVHkvQzkvYzFDM3lKUHBRUWhRcGZoaDBGZnAvVi9JSGFDemU2bmZYNDFU?=
 =?utf-8?B?UnBjenFGa1ZJK3UzTE9Gb3pWZ1dzT3BzSUI4WkFiK2h4V1VBUVRoMm5ielFI?=
 =?utf-8?B?b0FObStUL0lCVW55ZVZTWXBmUjFYUk1MWUhRZkdBTlFKK2dONWd0bUFoYlp3?=
 =?utf-8?B?aGJRdmkzV2xHTFF2a2dXbzhuQzBnSmhFaHFOeW02TG1RWXIvK3d1QWJOUlY5?=
 =?utf-8?B?cnlNSXdZUy9IRzJ5UlliZVBVVGtJQlZGRXJITkJOcUtWN0Fpc01CMGxJQUNq?=
 =?utf-8?B?VlhkMkNteG5NeUdUbk15MTVkU2srdnJyaFpkVDZadktrWVRQdEpyWDNIT2Mv?=
 =?utf-8?B?U256MXFiUHpHMW5CZTRqREpFYkZEK0MxdDFPQS9SKzVTVXR3VWFyNTNham9F?=
 =?utf-8?B?Rk4rVm5Mc21Pc2JkYmExazNHZDY0d1I2WU1BVDk3eUY0NjFTbWlWNGVPc0hX?=
 =?utf-8?B?cFNrQkVSaHBEOVMzeDVNekNDZXZaUmc0RXp1UGNkQzMxZWpiT3I4TUFGbU05?=
 =?utf-8?B?eFJob21QQTRjajdsaVdzRGRhd0V3NGdZb2k5ZnBKZ1Q5d2hWVXMxcUlPWHA4?=
 =?utf-8?B?RFkvbVhmc2VuMjVsUXU5NnZjaTVsSGtGdXUzMUhuK3hiYXVrekJabXVwSHcw?=
 =?utf-8?B?K1VTeFpCMTZtUzZkaGNJZ3N2OXduZG9wd3lhQzNGMlA5UDFTZzdkSlB0Q1Fl?=
 =?utf-8?B?cWVjTXlqMXkwaUpucm5oYmpRaC8xdDVEWjRlSXh0SFJJTFVaN1JzZTZkQlIx?=
 =?utf-8?B?dWplK1RDQk1IVmJxOHJWQlBNYm1BN0Q5Si80Y3lmajFRZXlYdktvZnFFaTNT?=
 =?utf-8?B?RlRaSHRzZSs0TjRTWTdlL0NrUlBnOUxIYzlLQnpuZ3ZTNm5RVG4vV0FwWW5S?=
 =?utf-8?B?MXRQcEpXNWYrT0hkbm9rS0k4WE1VUnQ2dVpWQ2xMVndFakQ4ekt1Vmc5eTlw?=
 =?utf-8?B?Wk5xVkFpUFRuSkw5L3E3Mmp2dUcxUEdod1NLbzF3U3pnd0FPREtWNVNwZjUw?=
 =?utf-8?B?WE5WNGFqTFVqSklDdklCdXJOU2dEWG5venllSFJQaFVUY04xWW4rRGlGNnFE?=
 =?utf-8?B?dDNaamNrUCtZdGZBUXh5MkkxVms0U1BsK2hxUjJ3NHRBWHFneFpXemZMckQx?=
 =?utf-8?B?WCtjVUJuMXFxMVJnU01LSGNkRktwK0JScFZOUnZPN20rakJBWGF6N0p1TjJl?=
 =?utf-8?B?ZFg2RHhXNktpTkVEblVya3hGcXFZWHQ5bEIrWTJtZTl1eHp5bjBFaXQ5N0xx?=
 =?utf-8?B?eWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2282fd95-f552-44c0-4754-08db4c3dcd61
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 01:20:52.9585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lcgk2O4oMHdhm/7eOGl9hSGLkFtbao0FfPi0ZJTRGBIMcGex7JOUo1N6qZEESSjYaV0ToxMYcYDF9RpzMc/+dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8031
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/4/2023 1:07 AM, Edgecombe, Rick P wrote:
> On Fri, 2023-04-21 at 09:46 -0400, Yang Weijiang wrote:
>> +
>> +       incpt = !is_cet_state_supported(vcpu,
>> XFEATURE_MASK_CET_KERNEL);
>> +       incpt |= !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
>> +
>> +       vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
>> MSR_TYPE_RW, incpt);
>> +       vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
>> MSR_TYPE_RW, incpt);
>> +       vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
>> MSR_TYPE_RW, incpt);
>> +       vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
>> MSR_TYPE_RW, incpt);
>>   }
> Why is this tied to XFEATURE_MASK_CET_KERNEL? I don't know how the SVM
> side works, but the host kernel doesn't use this xfeature. Just not
> clear on what the intention is. Why not use
> kvm_cet_kernel_shstk_supported() again?

I don't know how SVM supports supervisor SHSTK either, here just follows 
the spec.

to add the dependency check. Maybe you're right, I need to use 
kvm_cet_kernel_shstk_supported()

in my patch set and leave the work to SVM enabling patches. I'll change 
it, thanks!


