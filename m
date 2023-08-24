Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC312786841
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 09:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240330AbjHXHZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 03:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240012AbjHXHZm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 03:25:42 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07059E6C
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 00:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692861937; x=1724397937;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=p9ilMfd7rWSQUwM2f/hIpvjr1INHxeXFUR5CpTtvLdM=;
  b=US9FGfF7MEkTnMSY/WKd5U9f3Fh8SnCDsIhSqccOh4dFmN1qRESJzMfg
   JoIp6AlT4CztyO8RZpSiu61VEO9OEi5gxy+tGF/a/YO6kGa6oHd+GgoNt
   LbbnQ2xqTfdG0f90nDBXvmOXNTwtWlSz4mjj+f4+iATP8T+6FW+2F4fsn
   4NPZ6FGQTGaH++ZVJqNGFbUasljgd1VYveafusfX9cugiZuXlJuFBv/59
   zKhM+ItyHYifRyGeW4J+tl+1i/QzUbXp6+N5WzzWKCWuDAP/ZQEEbvim5
   CiPqcB9g7fjU/hspq+9WzJh5n8+JFEAqYj25O/Ms8M43sIcbOWmvacQyn
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="373250864"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="373250864"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 00:25:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="736944330"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="736944330"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 24 Aug 2023 00:25:35 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 24 Aug 2023 00:25:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 24 Aug 2023 00:25:35 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 24 Aug 2023 00:25:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f3RjwBKmZicTl3yoma32bEFHM/zvvNCwS6sjuPxAayaBQsNHfOP/aphaF8CaARkWEGeTeLvZkCHmbe2o065MxOmea2EFbnw42WuHFxkxLJWN8vDOfccayFuKoB4YalG7elPNZeOoSZIkuBGKCl0BZqK/H4lJ4wPwSOrpVfrMmrxsT2N1dRXriKo3urkYWqnUZedQbOLc3vdkMCMNgKXTbeMT7uMWMSczO1xJcCr5WabooEBtfH3NYFVdfPBPA8Zwvz8At+LuQB+OR/XSlmDtXbnlG6uHPQy9gVd005RimxLpeJgd/BYqj/77gseQgwkNj3rDkOnX11n8cXRsO1gR1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Om7vmNAk9mnyAPyxnZfD7W1rebfdaM7UZkOTg7xGnmU=;
 b=YRUtFSwDNW7yPJE6yHC88YD4bGBKeNptiO0jfpgseGNoxlPPizkx5dTe7ebQS1oB6I9LB5lGdSZ/cEXGSVOi3mUOckYx9w5LAKzgeSmbI286ZO1Z8cHCo866WPbClE7P7GMP4lB7avrULdUbYWYUlzifAPW9l7mapAJo+ThjM4F5Osl8RmogL6APVXb4IiQrsUKtG03mnf17qOOCdnwyqVEqm+4UbwNPeyRxssZnxirBMX8ga9V8CvajHPcWvzfYcg9TWUDxUSjudKPBC5M1Rr8JzpzR5N6yAqtGfePByLgMUt4VzEtmccAzC0RFrG+wHr2V/Zz6GFXiYmAh/K4uwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH0PR11MB4902.namprd11.prod.outlook.com (2603:10b6:510:37::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Thu, 24 Aug
 2023 07:25:26 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%7]) with mapi id 15.20.6699.020; Thu, 24 Aug 2023
 07:25:26 +0000
Message-ID: <e8bfb368-2869-6ad3-35de-8f7ee5568661@intel.com>
Date:   Thu, 24 Aug 2023 15:25:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [kvm-unit-tests PATCH] x86:VMX: Fixup for VMX test failures
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        "Neiger, Gil" <gil.neiger@intel.com>
References: <20230720115810.104890-1-weijiang.yang@intel.com>
 <ZMqxxH5mggWYDhEx@google.com>
 <a5bc09c4-cc24-1e70-b70f-dbbce4251717@intel.com>
 <ZMvfxFgHlWMyrvbq@google.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZMvfxFgHlWMyrvbq@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0028.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::21) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH0PR11MB4902:EE_
X-MS-Office365-Filtering-Correlation-Id: cc726414-75ea-451c-5666-08dba473496b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J1WM776UIaRvUi0pR2yLTs+H1DbUet3zBdWYeC3+chop9gUF/rjLk+BL8ux8lg5VKpNj6vhNOcCCuTvEwbI1CdeOwQ4gy4MX2qiUAjmxvPDtanHNM4nA+NiBCHNXUzZrokSyKRjbsHPSlRw36W0R86olqq8LdgERON8vYcMSDNeCdqqPiEVNAxd+2/dlosqmD9NPhD21EHPaD6464e8KCjqFIccNtZ7jCnsXR4NEwzZH55YkRN4u4BuzDh8hhAFnZIvgJYfwAdPmCt4x9uYMnr+aP6mgOaUhOPxL4tWe23VfBGdW5maoi1ukTN26x9ciZrjPTsuhf7f/6pwUrsPPl16eH8S8HoVKca4CCHxaygldjatg+J/N0KNxXrgoLLkQgbH8jg8KgAog8cT9EP3ybBX64qTPUuhWTZHpDr1LcNpX7h3OqqpmcuCdYVKtFAPiJl+y9s/4p8FgVz6f8jO/RPP1ehiahiu+fdprNmfl8xtDJqZr72m1b6S8UZ4UWtn0XH0FpOQfA/Eh21eE6OOW1gYvuSpLRzPbaHYZalchrMCoheZBZuqFK7vWuzOq+CwA48X5VJ8EG7PdmFvkBVADFQgVDmNrLPnN8P+1FSEvtxyQEwoIMuGtHy/lkgfPQk6K1ZqWTE2CX7j8Q23nCZnGow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(396003)(39860400002)(376002)(366004)(451199024)(186009)(1800799009)(66946007)(66476007)(66556008)(316002)(6916009)(82960400001)(478600001)(26005)(38100700002)(6666004)(41300700001)(86362001)(31696002)(6486002)(6506007)(2906002)(6512007)(53546011)(31686004)(4326008)(8676002)(8936002)(2616005)(107886003)(5660300002)(83380400001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjZ5dDN4eTUzd2ljbUd4Q1FmM2Z6YTBTR0oyb255U0hBT3h4YkRrZTJQb1JO?=
 =?utf-8?B?Y2JLbzF1N0NUR0ZRNnRQalI0ZkEzTFN3M09NQ0h1V3RwUGJ4TTFuZDJ2aTRY?=
 =?utf-8?B?MlljTEMzaFJzM0lwQit3UWRtdUkwbEZBeWsvZVlEQVM4eVFGa2d5MXdBbUw4?=
 =?utf-8?B?SUJPWDBqTWJwNThvdmxYb3RUdGRPVmxkN2ZMUEozaytyUENQUkppY1FoUnRx?=
 =?utf-8?B?MHN2blQwL2NIazNlNWNPY001cHJuTmdKS0RBVThjTU8vaWRmNHljQUFjNFBt?=
 =?utf-8?B?R2JqUkJOQUYzQlA2VFg4ZkdTTjBCZWxHQ3FkTlVlRitPclJROXJjc3BmaVdX?=
 =?utf-8?B?MG5ITUpiUG9ydGp4M0pCSGZFMlNpdE1Eby80R01ET1FLcElXZ3U0eTZDNXNn?=
 =?utf-8?B?azZjcTZCbURRUFlmVG1JUDVjSlRuUG9EVDVaTHEycVZ3bVBOQkg2MmRJTUMr?=
 =?utf-8?B?bU51OEJrUFNYVnh1R0tqRzNHR3BuNThMRks0dFhWT0dhYys0TDhyOFJlWisv?=
 =?utf-8?B?ZFRaQjFmZFJFVG5GRXRGOUVKdnBmcjFGZ3pSOURrMFZZRDVpY2RwUTNQcmNO?=
 =?utf-8?B?YkVUNHEySkd5S2hQNStDZDRaWnNJdk94bkFLdkVMajV1L3FSVFVaV0h0TUE0?=
 =?utf-8?B?dUtDWWlPZlBtdEhsL1dPenZlaVhaRy9lOU1VZjNVMHMyVEdBUzB6ZElERHVG?=
 =?utf-8?B?MEVqQlpqYzIwTDBBb202YW0zd1ZvVUpFUUsxLzBlaGk0eEdXcWFlMWYzT2pI?=
 =?utf-8?B?Mm1nUkZjd2lDa3NiS29mRk1kSFRZbkxUMGhjeDVKY1FiQ05CT0w3S3RnbENN?=
 =?utf-8?B?NCt2cnByb1BYampwSGFtQ1BpMjU4UHh2RGlrTmpVZGhKZDNXZVdDODFnMmJJ?=
 =?utf-8?B?ODlBQXNwMVgyYXNOWkRTYWs1ZTBxM295TWMzVHVtNGVJUnZPOEdQZFdmTVd0?=
 =?utf-8?B?VTBrSlIrVmE4ZDBjR0tGNm5sRDFNSDFJMDR3SUl2emhzSGhsNXRmVUthbnFW?=
 =?utf-8?B?aDNBYVh2a1BRZHZXNG9HOTRBMHNQV1gxMHJqb01yMTN2Zy9QS1h1b3ExV3ow?=
 =?utf-8?B?UGtHeWlmRmZpZlU2UVlnczFKbVFHR3lOeXFpbmttRzFpdTVqcXJ0YUIrV3pN?=
 =?utf-8?B?NHlRdFQzK2NtN0JxUTU4L0taODl1ZHplL0hjWXJnR2hoQzExVUNCcTVvRkox?=
 =?utf-8?B?My9maFAwa3FudzdDZ0JaRUNqUEJONFEwcTVDcmRhekpVNlA1YUJlc2N2Z0ZG?=
 =?utf-8?B?Tk9zNVJ1a05EWGhudTNGVysrUzhxZWYzZm83RTlBL0ZNc3FreTdJcStWVTJh?=
 =?utf-8?B?SFF3UUdZVFdQb0w5U0tlY0tQUER3a2haWkFoWVpvaGRWMkljTVdJL2JLYTVH?=
 =?utf-8?B?SjQycDl2b2VjUEdBemdwUEJNUXlxajdtNzA0dlhUWlE2WEw5NjY0dTloNWs3?=
 =?utf-8?B?WjJXSWZIZm5tT1RRZHBMcU9FYUVsM2hvbEdJT213OHE4QjRGS0lCdU0vdjgx?=
 =?utf-8?B?U1BsditlSXpKbjNzRWdSSHRUZThZSXFzVXZOSlk0N0RZeTlldFFjNGpXSExR?=
 =?utf-8?B?Q2JtNnZoSVRIUXA4SGZHZzdIWDQvS1Q2RWtMVWRKVlNPVnlBSCtObEhHeFVS?=
 =?utf-8?B?QmFRNjk4bksyYnpIOStZcENRVzBuUnRnNTNkVEhXczFCaWZrSDczeW55bkFY?=
 =?utf-8?B?TFgxNjc5MHJvRHBmWHZ0V0Q5QWhpaWFzRTdOa1J1MXdhQjY3RnUweXZGaUlZ?=
 =?utf-8?B?WFBnYUJPUGcyejZnOGw5TlcxRkI0MDhHaUNnVTRnYzY4bmt5RVFma0pxQ2o0?=
 =?utf-8?B?OU03WFl0dDVHS2pVMXRCOFo5UHVnbnRGQWlqYStmQkFVRHNJeHpocTkvcTVl?=
 =?utf-8?B?Zys5YkhJVzFVU2dDTXMzRFk3eGJ4SjBMR1Y5c1RGeVA4SUp6T3ppaE1LdGRQ?=
 =?utf-8?B?MnBXVjZzZkVwdmVvWlJ6WjFlZ0tnVVpPU0VYWW1xN3lCRVY5emdOeUpyNE1t?=
 =?utf-8?B?cEphc0duWlRBMEhaOE9xMzdqVGVTZ1IyRVNTN2c4WkpvOTBIcTFmNWVSMmoz?=
 =?utf-8?B?L3d5Y2pHVFJQMnRPRi8xKzdROXM4RW5qcnVVc3lpWjAralNQTWxWYi82aVdW?=
 =?utf-8?B?dTBTbkVqT0QyckNrbnp3ZTF3ZkpEdFZ6dktyRlpmcm5HK1hvMFJobStqK2dw?=
 =?utf-8?B?UGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc726414-75ea-451c-5666-08dba473496b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2023 07:25:26.5216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U+4MM3jOnMTRI4EllbfxuqToHcgNeCVFgCp4tN24YFlGnZSxcD39dklkTyJqtVPBM28jHjkzforkTrP3vuXHAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4902
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/2023 1:11 AM, Sean Christopherson wrote:
> On Thu, Aug 03, 2023, Weijiang Yang wrote:
>> On 8/3/2023 3:43 AM, Sean Christopherson wrote:
>>>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>>>> index 7952ccb..b6d4982 100644
>>>> --- a/x86/vmx_tests.c
>>>> +++ b/x86/vmx_tests.c
>>>> @@ -4173,7 +4173,10 @@ static void test_invalid_event_injection(void)
>>>>    			    ent_intr_info);
>>>>    	vmcs_write(GUEST_CR0, guest_cr0_save & ~X86_CR0_PE & ~X86_CR0_PG);
>>>>    	vmcs_write(ENT_INTR_INFO, ent_intr_info);
>>>> -	test_vmx_invalid_controls();
>>>> +	if (basic.errcode)
>>>> +		test_vmx_valid_controls();
>>>> +	else
>>>> +		test_vmx_invalid_controls();
>>> This is wrong, no?  The consistency check is only skipped for PM, the above CR0.PE
>>> modification means the target is RM.
>> I think this case is executed with !CPU_URG, so RM is "converted" to PM because we
>> have below in KVM:
>>                  bool urg = nested_cpu_has2(vmcs12,
>> SECONDARY_EXEC_UNRESTRICTED_GUEST);
>>                  bool prot_mode = !urg || vmcs12->guest_cr0 & X86_CR0_PE;
>> ...
>>                  if (!prot_mode || intr_type != INTR_TYPE_HARD_EXCEPTION ||
>>                      !nested_cpu_has_no_hw_errcode(vcpu)) {
>>                          /* VM-entry interruption-info field: deliver error code */
>>                          should_have_error_code =
>>                                  intr_type == INTR_TYPE_HARD_EXCEPTION &&
>>                                  prot_mode &&
>> x86_exception_has_error_code(vector);
>>                          if (CC(has_error_code != should_have_error_code))
>>                                  return -EINVAL;
>>                  }
>>
>> so on platform with basic.errcode == 1, this case passes.
> Huh.  I get the logic, but IMO based on the SDM, that's a ucode bug that got
> propagated into KVM (or an SDM bug, which is my bet for how this gets treated).
>
> I verified HSW at least does indeed generate VM-Fail and not VM-Exit(INVALID_STATE),
> so it doesn't appear that KVM is making stuff (for once).  Either that or I'm
> misreading the SDM (definite possibility), but the only relevant condition I see is:
>
>    bit 0 (corresponding to CR0.PE) is set in the CR0 field in the guest-state area
>
> I don't see anything in the SDM that states the CR0.PE is assumed to be '1' for
> consistency checks when unrestricted guest is disabled.
>
> Can you bug a VMX architect again to get clarification, e.g. to get an SDM update?
> Or just point out where I missed something in the SDM, again...

Sorry for the delayed response! Also added Gil in cc.

I got reply from Gil as below:

"I am not sure whether you (or Sean) are referring to guest state or host state.
The IA32_VMX_CR0_FIXED0 and IA32_VMX_CR0_FIXED1 MSRs enumerate which bits must have fixed values in CR0 in VMX operation.
Every CPU that supports VMX operation (not just the first ones) should support these MSRs to set bits 0 and 31, corresponding to PE and PG.

Section 24.8 explains what this means:
1.    VMXON fails if attempting to activated VMX root operation when either of those bits is 0.
2.    Attempting to clear either bit (with MOV to CR) in VMX operation (root or non-root) will #GP.
3.    Attempting to clear either bit through VM entry (loading guest state) will cause the VM entry to fail (with what Sean calls “VM-Exit(INVALID_STATE)”).
4.    If a VM exit would clear either bit (loading host state), the VM entry that would indicate the host state will fail (with what Sean calls “VM-Fail”).

Exceptions to #2 and #3 are made only if “unrestricted guest” is 1. (If “unrestricted guest” is 0, the items above all apply.)

If “unrestricted guest” is 1, #2 is relaxed in VMX non-root operation (guest software can clear PE or PG with MOV to CR).
If “unrestricted guest” is 1, #3 is relaxed in that VM entry can load CR0 to clear either PE or PG (but cannot set PG without also setting PE).

I suppose that we could clarify that SDM to indicate that all VMX CPUs enumerate PE and PG as being VMX-fixed to 1 (despite the fact that many CPUs do support the 1-setting of “unrestricted guest”)."


