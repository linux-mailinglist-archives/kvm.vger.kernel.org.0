Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB64E764871
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 09:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbjG0HXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 03:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232457AbjG0HVO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 03:21:14 -0400
Received: from mgamail.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71534358B;
        Thu, 27 Jul 2023 00:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690442073; x=1721978073;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+sid2FzP7IXQ8oBWP0xd7L/COpOR/KJYFpW5UeyV0Ms=;
  b=MNGjZHX+K0oQ7SRwG4L2KCKnZKg9HkbdQMW8i2apLjPn2THEaZtPSf3H
   GZ63l+2eca1ZArtt5uRHC6M+4FKuFONagME2g/HsH9tzVLdHh65uifJei
   FoFTxidflkycSHiqst2/yDlxlmoOY6Fhm84YrfUtPdG6LuwmqNtpIAIcy
   crefFkpGrPs4rYyw4Z55mlbwZAQZ6p+XI8wPMfeDy1dBbPNOd4wcZfnPk
   9UIqb3QzgzUbBS+y6FuY97z+NAkRvq3Qq3rv7yO3MywadDaTjrAbFJjTP
   9MaszCQK50LrFeh8K7CJ8Tw3fbvztRYBNJwZ6rektXfBXEeOIyhMo/gah
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="347837599"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="347837599"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2023 00:13:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="756545853"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="756545853"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 27 Jul 2023 00:13:16 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 27 Jul 2023 00:13:15 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 27 Jul 2023 00:13:15 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 27 Jul 2023 00:13:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ip6vjBObrThqQEuKBjp1Lf+QX6q6smB9T5qShkQ3HRkvf7PbokTsZ7xN894/hgIfklqyZJ8sEFMqU/hzEwf8qxLjasB8KF5iH+1YkBjTmEcoRixmhIwuw3IUUfySLP/GxIItcOIpsowpwfcSinUfj0dwPnOY+1pbTJayZXTtq5D+SDLZX0gf3fvYX4JJVwLa6U3U60CrJRPou5m1GYAi6sWHJ9KAIA7CTf9xyBJWknRjqfpPJBq3xCwL0vh1uaw08BV9QK/OlOY71aC5KlEJNZJe7+OHooRNjiDon1AAg5RZQGKOai4WpMl+dTk061qU/beXY2kiVRWP48LdkJ9UcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AMsR3kL4YXZZeSwsYlrjTi9oKb/aYf5DUFlQkbkEKTs=;
 b=JeNHW1braqrOieDnGpAIchZcSMf1nuq8Lpcutkn/bFdl3QlgmYctGF+HSy3zqM77C986eNxytccFQLnXaqhgkel+2Bj6OsU1riLKp8wlp8IiWFa6LxJDDRoHfUJcwZ3CW4MZK652sskKxd9PErDPpb/3Bi6LM16CT3Y97W4c+8R4j5FOOkj8loU4ZRNNS/PGf+lQ4TB+e/TCI674nKgKSlb+Gzs/Y7jtpQGtlEIicCBoVNCaJxJ6r97SAAX4Q7XFiNRFbIi7zjoVnmTywhaIQUvVyM2nLOqGakmWe510+nsfWTGiOCowvcBEmDjwzVdB42LmYvb/cU3nmQ65AMaqkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SN7PR11MB8025.namprd11.prod.outlook.com (2603:10b6:806:2dc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Thu, 27 Jul
 2023 07:13:13 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37%6]) with mapi id 15.20.6631.026; Thu, 27 Jul 2023
 07:13:13 +0000
Message-ID: <d6d4ab42-49b3-5704-0c2b-e3b2a607d835@intel.com>
Date:   Thu, 27 Jul 2023 15:13:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 12/20] KVM:VMX: Introduce CET VMCS fields and control
 bits
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-13-weijiang.yang@intel.com>
 <ZMIAF40pG0WCgPNK@chao-email>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZMIAF40pG0WCgPNK@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0026.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::11) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SN7PR11MB8025:EE_
X-MS-Office365-Filtering-Correlation-Id: b7193a5e-f0be-4f81-2ff4-08db8e70f092
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: omtEOULzGrj8iuhxxIq2PgDVfLhWm7lMIOel9hP0luULtcMGNQF0fNwsRvvujdO9NWUODTJn/oUHxuc2hVK/ZNMbAj1+k5LJmt8p2axK7Vkum1GBgBTpL0Gg+GFIMLLdFKbLUtNIKl7x/qxin0nAcBiZlom1cEqwXXoEujIkjwRk32wcj6nK5+l5KvqX+yq9AKExBLdZdnn29MjzwHhVT7VT3Mu2QTBJuqL1oz7gRWlShZON/T6YL5n8EFbp6Oq0UstLhJkRoMFUzUIxEZulN2BfpR4E5/WZsMcmhQYzU/5stxIMG8Xf8CNdxdAogjP5k+r2aAbHm/etkTReBEYajnh+BwjXXc8JsaqVbZBhw5ecvfK01wkIiAd5cbcx09CqMsj2KtpvHfMUI414/kZPMsB/OPtO6vw9Wt/Gh0GB3QUIIvMXj3P5WPdg7haXX1BdHdacjn1XS4WPy/xIJrSaMntg+NmiPUl/onTdkACQeoaTQD9hJG6AL2lQpbiuHS+vi/gfVuf3NSHhAwiRIyfIN+hYL1ckKpcrHaycyu+kSu9pWANg7UAY0OllwKwLxN+4uMOdNCzwqza8Wqe8O9AQSF3wyzNUaID2iyoUPOqzUaoKVRXNK8CN+BFBfeNzBlgyw3iaNSIYRp1r6pkKdpMbGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(376002)(396003)(366004)(136003)(451199021)(82960400001)(86362001)(31696002)(36756003)(31686004)(38100700002)(37006003)(478600001)(2906002)(2616005)(26005)(53546011)(6506007)(186003)(6862004)(4326008)(8936002)(6636002)(8676002)(5660300002)(41300700001)(6666004)(83380400001)(316002)(66556008)(6486002)(66476007)(6512007)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUUzM1RYMDZEeUwvRmxQaXpjckZhbEhPamNMUXYrTmF0VUplSnBmY1FqS2Vp?=
 =?utf-8?B?VVpnQ0k3MW1rb2w1NnQwTVlDa3Z0L2FsQWkzb2ltVnk1WlJlc2hvR3J5NVJs?=
 =?utf-8?B?b083ZlFUdHdKcE15a04vbm92Q1NkRHREeDhRRWFFZmpESVlLMTkraUswRDRH?=
 =?utf-8?B?RkEyRWNKSXpWSDZVRVVlcG16MGNicTdFSzd2TGVibUpJVEsxc2xndXZWRVA2?=
 =?utf-8?B?RDQxZXJ4QmN0MXJOcmY3UldIUHZVTFJpL0hsREIyb3ZiY0J3TDZFNjAvekpW?=
 =?utf-8?B?b0lZcUhhTGtSUituNUd4UEJWSDMzNzhRcFlSZVZtY0NYQzJYaWlpSy9peWVJ?=
 =?utf-8?B?K1h5OTh4dWgycEFMR2hvQjA2MVE0VVNjbkZIalFjL3ZLWDRpQlhoWFF6dWh2?=
 =?utf-8?B?cks0ZHhENVF3RXFYYVF0QlpnMW9OTFlnNW5kS25FZTVDQWVHNnlkTi9ETzc1?=
 =?utf-8?B?T2RoUGVxUmdPRmtHM3REd0NnNUxCcDd1MDA0NzlFNGU5aEs1RDdxOWFwY204?=
 =?utf-8?B?S3R0YW15cjhsZ1U0N1Npd2xHazVPWTcyRWJGNGxGdzc2VGU1U3FVU1ZvWWlE?=
 =?utf-8?B?QWZXa3dncWtLZjFhbUN1ZkVSRDdmUW04SlU4VWhMMWZBV3gyYjVHVHBvVjFm?=
 =?utf-8?B?Tk1PUzB6azZZZnV3UC9ZdHFvdE81aGVEVHljamdnb2tpckMvM2tkV2hZa3BX?=
 =?utf-8?B?TmVFekY5b1FsYVovVHhQd3lEMGhGY0JlRDVGdEh4TnNrbnVrdGVsempFL1RU?=
 =?utf-8?B?eHd4Qmk0cUR6bmNBWFlxQ1hDSEVpQ3hueFNaMzFmM0ZOL2REVXBrR01pbzBp?=
 =?utf-8?B?T1daK05QTHRBK2dDRVBhVFEvTmlkclhJbCtmSlV1eU5UeDFmWHhjTkNNaGJp?=
 =?utf-8?B?REFtRHdWRjJFZTVOOVRkSTZuUE9jMVNIK2U4ZG5WQmhYd2VmQzdlelZybHY5?=
 =?utf-8?B?cWc3MDR3b1A4ME5Cd3d1ZmRKYS9leE44QU9UZjYzcGZ2eUF4T29SWTVJMUVl?=
 =?utf-8?B?YmZMK21xNVMvd0pPbitDTkxNWGJ5S0lSQmI0WEFSUmNGdno1OUFGMERuZTFL?=
 =?utf-8?B?eTR2OHhhdytLRDdNK090ODJwMEM1b01RVHprTlgyakR1byswdytRMzVuOENi?=
 =?utf-8?B?VHRKdXBGZ2p3YkdoVXRaeUNZQ2xKa3d1RmdxSHJyK3MvT2FUVU5HeG8zTldE?=
 =?utf-8?B?VklQS1orSmszOXNlZjJkMktQZ0R1cytpY0dieFFNRjJxZU1jUkloUjREWk53?=
 =?utf-8?B?bXZNTW1HMVV4cFVlTU9LdTJHZG1nRzRGTk0wOHdtVzNGcVpoYnF0dnQ5bWZG?=
 =?utf-8?B?c2hkbk9qQ0RXZit0TVM2TE1NNEIxRnBiU2pLWnlOdVdFMExvVGVHbkpTVDdY?=
 =?utf-8?B?VE95MnJveFdHbmF6VTIxTmlCU0EzMVZIMERKdEZwSEk0cUMreWE5NUdhRkNq?=
 =?utf-8?B?cExRS2J0bU1QQzdDWGdKelB5OElxR093eGJTWmdlWU9mWGMzQ1g0VjRaQ3A5?=
 =?utf-8?B?NGRMaC94dE8zcVd1ZU80WWhKcFJhNXZiL3QrZHZJZUJibWF5c25Rcm51SjV6?=
 =?utf-8?B?b29iMVB0bHg3cldxTXlxN3o2VjZqaW43b1pITk5GK3dITXpCdjRnbi80LzU3?=
 =?utf-8?B?ZmpYY1ZiWGlTRlZHdWM3Zys5Q090d1hGUFhZdENtdWwwZ3prTGhpZm5yMjZZ?=
 =?utf-8?B?eDMrT2d5bktGM0JoRUVIVHZCckVSbzVlS1VBVjNnMm9SbU11djJkWnMwcU5R?=
 =?utf-8?B?b1pXK1ZWbG9NVUl1Rldoc0FUU29zVWExNW5pRnZCQVdYVEVEOXV5YkFjQWxE?=
 =?utf-8?B?bzJlaTI5TDhvaFRxUVArVFN5aVVrK1Y2bTRHcWZzV3pRdG9MYkZKeGpsTUFT?=
 =?utf-8?B?bjZQdXFrRGZpWXJMS3FtblJUYU52SjdOd21UczJ4MzhKTmd3WUFrOHk5M1A2?=
 =?utf-8?B?T3JxdUgrR3RiK3VVNTd3MHBTTEtCSUsxREIvM1JlVWxTQW04d0RMclBPQ21r?=
 =?utf-8?B?UzBhZlNpZVZqTkFvZVVwTnV5YVI0aTRHKzZhSHpMdGJuU2EzMk1aTnFDQzUw?=
 =?utf-8?B?bHhWT01xVFpPaWY5SzBSMDVJZWFhT29SVnFNUldCUmpRRmtrcHd0Y2ppT0ZJ?=
 =?utf-8?B?cmp0RmViRncvOGFlUTZzWDB5Ry9RYTNpZUVtbXNGWm1MblBUK1U5aWkxeU9Z?=
 =?utf-8?B?NXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b7193a5e-f0be-4f81-2ff4-08db8e70f092
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 07:13:12.9614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KpCY4Klm/Q2Mrg1+DikKJlrcGZW/U3An2VHnmisZZ3ZLedR6En7RNYDFceWUzTV5CoCHuyEetJsAggqYQo/bVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8025
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/27/2023 1:26 PM, Chao Gao wrote:
> On Thu, Jul 20, 2023 at 11:03:44PM -0400, Yang Weijiang wrote:
>> Two XSAVES state bits are introduced for CET:
>>   IA32_XSS:[bit 11]: Control saving/restoring user mode CET states
>>   IA32_XSS:[bit 12]: Control saving/restoring supervisor mode CET states.
>>
>> Six VMCS fields are introduced for CET:
>>   {HOST,GUEST}_S_CET: Stores CET settings for kernel mode.
>>   {HOST,GUEST}_SSP: Stores shadow stack pointer of current active task/thread.
>>   {HOST,GUEST}_INTR_SSP_TABLE: Stores current active MSR_IA32_INT_SSP_TAB.
>>
>> On Intel platforms, two additional bits are defined in VM_EXIT and VM_ENTRY
>> control fields:
>> If VM_EXIT_LOAD_HOST_CET_STATE = 1, the host CET states are restored from
> Nit: s/VM_EXIT_LOAD_HOST_CET_STATE/VM_EXIT_LOAD_CET_STATE
>
> to align with the name you are actually using.
>
>> the following VMCS fields at VM-Exit:
>>   HOST_S_CET
>>   HOST_SSP
>>   HOST_INTR_SSP_TABLE
>>
>> If VM_ENTRY_LOAD_GUEST_CET_STATE = 1, the guest CET states are loaded from
> Nit: s/VM_ENTRY_LOAD_GUEST_CET_STATE/VM_ENTRY_LOAD_CET_STATE

Sure, will change it, thanks a lot!

>
>> the following VMCS fields at VM-Entry:
>>   GUEST_S_CET
>>   GUEST_SSP
>>   GUEST_INTR_SSP_TABLE
>>
>> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
>> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
>
>> [...]
