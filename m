Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76D3E74386C
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 11:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjF3Jf0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 05:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbjF3Jew (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 05:34:52 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA23035A0;
        Fri, 30 Jun 2023 02:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688117689; x=1719653689;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J39gEdD9+655ZLzYGKNubscq4mmfboTRVlkM+2X+PrU=;
  b=Oy79NFQD0etho8H2DtcSubAbp6EkLQYVcAlx7KjB8AdFyqKyNwI4deKW
   D2SPLsm+f26RawNnOt8Rgt+wkSY8kMBX3XeN+tgVSGvYQ1Jy/DE7vX/mW
   L+8bcIHrptmPutkh2HRZ1FrdgY4Q7DLn1Mh/9Z60JH/VTCkPj4n1r8uVD
   WdOr1GymzwlToXEtctReowRJzn4izT8qLBVFMxHfHa/XlbcVPRSrQL8Gu
   o2JFkTTbsPxv44K2Jja+5AHRZPoCTYqx5h8LdOMaolidtQmc9v7WhmxuB
   MYkBmr0eBvhuKWjjwGzokmnq/4eoFIqichLjmcPREE7RAZi0ktyJEn+zz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="359836341"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="359836341"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 02:34:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="830867220"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="830867220"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 30 Jun 2023 02:34:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 02:34:48 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 30 Jun 2023 02:34:48 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 30 Jun 2023 02:34:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B9qTj4cwZSaMH+Zt1vYx0zWQEiW8k6I+5jiJJzChJhcdnVQXOu7Iay79ReOh9+h+Wy1MPktF/AMmN8ZcN+vH2T0ufWkiEYutpgU7ag4YL8H4bnUDQUmPoLk1ll4OymRpvecwpUAwYsulq1LUPZ0T3xUv8G/wLmFWe9JozxiSwuLelkZ/TCXNyiybkhqpGxEr95IWCyerVSA4Pjx/J6Uj4Jg4Wlk5Ahy49CnUktdPIMRxY7TzBGodUB3Cunfzunc1ek2GrEfWWHP6iJKwOmsFkSibD9YvazAliVTMhovu4I/L2J9vPKpXAWKZTXpVnAhGXGuZa6X0uVigLx414jMqQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PU4+FpFqDBu6f9oRV/k6mfbhl89W2ZlpcvlZm0SH3jo=;
 b=XTq13zFhGqKz2zkxnGpJDiMIseKRidLjvZ8AHBtUwVosIMZUarB5s/+LXxRy5hgN81UBH5K5AZWcX/Tx3KGg0AIdSZtlb+PDzuW75Poa60R3xJ0dBp2sc18Iar35LERKiRqEUaP7iN4QLJqHgLGOCvbMfL31vA9i9uDylRNmY7lQLD0RT/b4s5pyBx9XID6o1AgJ5eOBLP5COOLLlASDNBz9P6GfZ7sODQr2rZahmotYdmx57UO8KDKSL+TugWRq6Exa5muzwjwS8EBddQoHsz01ds7EMykE52tm65YQiegh9NeCCAIvQDqdzIynGawFMwxWvrf9wY5K3E5iGxgbIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SJ0PR11MB4878.namprd11.prod.outlook.com (2603:10b6:a03:2d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Fri, 30 Jun
 2023 09:34:40 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6544.012; Fri, 30 Jun 2023
 09:34:40 +0000
Message-ID: <0a98683f-3e60-1f1b-55df-f2a781929fdf@intel.com>
Date:   Fri, 30 Jun 2023 17:34:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 10/21] KVM:x86: Add #CP support in guest exception
 classification
To:     Sean Christopherson <seanjc@google.com>
CC:     Chao Gao <chao.gao@intel.com>, <pbonzini@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <peterz@infradead.org>, <rppt@kernel.org>,
        <binbin.wu@linux.intel.com>, <rick.p.edgecombe@intel.com>,
        <john.allen@amd.com>, <gil.neiger@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-11-weijiang.yang@intel.com>
 <ZH73kDx6VCaBFiyh@chao-email>
 <21568052-eb0f-a8d6-5225-3b422e9470e9@intel.com>
 <ZIulniryqlj0hLnt@google.com>
 <dfdf6d93-a68c-bb07-e59e-8d888dd6ebb6@intel.com>
 <ZIywqx6xTAMFyDPT@google.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZIywqx6xTAMFyDPT@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0025.apcprd02.prod.outlook.com
 (2603:1096:4:195::21) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SJ0PR11MB4878:EE_
X-MS-Office365-Filtering-Correlation-Id: 73f1c035-df95-41ab-ca08-08db794d3a15
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cq4whBAnZAXAalbd5xckFysrk9AXx9sRNdhhxP0EWEJftgoUhexQuxNtERN3nCxzY3Ygqo05d1whbVpD1CXbfJf7FKeb5I59luWPUPiC/MhtB8WR/meqiy2TXwGAGl2KtXNl2TJUCIi42I+JEWknuCMjWYincHOvuTSO0dJ2ze0TH4xVsrZjRTc6rpNro5Ho200+WJcVGrT8xxt49wtC5DLr5YOYOvYfHlacAWdgcX84a4dvtIFzL41oUPf1HF9C8jyPn/5i4rVraMZ1H6cK1pUKa1qrhEcID5P8Mv2z0eULG6L2GLtgH3po2XC1+F5pxx8Zl+dafke2t2N0iqQTdXl2FNg47UfOTasGh5N28o1pNn6MP5ucbQvstwW9Mym1TRWHR0xLJ9Cl3xiqqsFNI0YT2ZnA74cquRefdxbqWwqSlWMQVEtXhDVQeysiaRcUOprz9D/85G8/+Gv4qQlA/p1wFgyR4jbaOrUwmW9z2jcUP2nc9Wjg6uAzSwhqKkkFXJjKNdtrOQFY6cXm7gslSkI7vDPveDog0XoLgzMJiPdiztDrGlQTQKhYNhr9dRFkCoqdV9SD58H0J4uF41BrADbWwuHxQP3xixo/fznoNirFTHYlP5Ypqkn7ZnjpIZPjmsz3hxGj9OhvCPnxo56rrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(346002)(396003)(366004)(39860400002)(451199021)(53546011)(6506007)(36756003)(66556008)(6486002)(83380400001)(478600001)(26005)(2616005)(6666004)(6512007)(186003)(2906002)(86362001)(316002)(5660300002)(66476007)(82960400001)(31696002)(66946007)(8676002)(6916009)(41300700001)(4326008)(38100700002)(8936002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z293d2dvMHkwMVI0MmhSSUtHT1g4WDRSSW4zR2RaMHlCaUk5dzBIcm9PeUI0?=
 =?utf-8?B?T1h3WGdESndzMTJ5aDBqYktqSTNpS1RyTk1rUzBTdHNGM0ZXYTVCUmdnL3ZN?=
 =?utf-8?B?MGdEZXFlQmNwbUxXZ2MrcWxVVXNTRDM2a0xOaUs4SDRWOW9mV2lONjVwUkdF?=
 =?utf-8?B?SWcvV2svd1doTmF1QmhGLzl3K3Y5Rmt6VHhtZ0RYV29nVGQ2c1M3V0hQTDRZ?=
 =?utf-8?B?UEQrd1hPbkdUYWlKaW5ZSTlGKzhVTXkySDQ0bHJuOHZPS0xUZHZVVHQ5NU43?=
 =?utf-8?B?SkhBY3NMRDF2MUxHeUVYaTBxS09IRjJtTElMTWJpREpJcDhzUk41YnV6aHVB?=
 =?utf-8?B?TmdNRUVmQ0N3WUN1a3NDdFVMR3QxZDZCU2hpSGJFQXVWU1FqM2I4RWNuRlNZ?=
 =?utf-8?B?UjVaN1habzF1VWJoY0doZEdzYUJNb2tId2FudXNyRTdBL3BPWnMwTUNiVVd1?=
 =?utf-8?B?aE80Y01yb1gwWFk0UWpicWlmK2pwYWxVc0lRK1FjbUw1aVk2TWlpSnZuekI5?=
 =?utf-8?B?NEhtYkQzMUsxczZSaFBSUyt3d3BjK3Mvb3FCYit4M2hJbDhhU3ZXOEwrU005?=
 =?utf-8?B?M3I5MXRTZ21OOGM4VVdJelpTYTcvOGdaME5mZytzSGx1aUFmbzM1UUZGUkR5?=
 =?utf-8?B?czlsbjg1RnBYMDVzQWE1UlZDcHNFaGlNTW1uRDNtUFZ0MnVQd2RPa3NxVmNX?=
 =?utf-8?B?RlRhN0ltSjZ6NVBGZk51Sm95d3FHZE9RVUsvNzE2cGFkYTloemcyMkVnNDlq?=
 =?utf-8?B?WlRvaXdMYmtEcVMrMzBpNHdvQWR0RUEvYThWKzFYazJxOXhZVUxONGJvbkk4?=
 =?utf-8?B?bzNCcndZei9VYzArS3RiT1p5SkRYZGlRL3k3eEJxZmtGUEFrMkk1TEZXai9B?=
 =?utf-8?B?aVNka005a0VTdVlmOFFBOFZZZTVZMHdjbWhxS1lNZGt5NnlXY2VoM0h6K0RF?=
 =?utf-8?B?RjFJelhNZzBBMUVObTZldHFRN2cyUXZUNVdQc2JYQ0twNjN0WnNIdGgrOFZO?=
 =?utf-8?B?UjFtL2RJR05JenoxTG1BY05ZVE9KbElyMjFOSDFwcnRTWkkvSURwR2hKRlVo?=
 =?utf-8?B?UDlCSmpWckx0LzFIcjZGS0hqQTlQS2szbVI1RDRzNmNyOG9jdmlWMzdLRi9L?=
 =?utf-8?B?SHNaQ0JVODJZMSsvYkZvVEp6MEtBZFFaMGNMSUs0TThrWFRITHVJWFAwS2hv?=
 =?utf-8?B?YzJJZmQrK1NIZ3owZzhONVlFaHduMnJ0NjNwRVBJY0kvYmFNRDhWQzN3T3hN?=
 =?utf-8?B?bmZzSW0rK09WMlp3QUwyMEIxc0c4ODF2dEhNbTFCclRRUlZ6WTZIbWRXSEs2?=
 =?utf-8?B?UTdqam9SWWUySmdSQ1NjcmFINHFmSXF5QUhBclo4MHBvUlhjV0dka29lcUpq?=
 =?utf-8?B?VnZQMGlSVkpVR0F5U0xkaTlXQmd2Um03ZXpVN2ZmbTZnMmdoendIcEdJUEhv?=
 =?utf-8?B?dmc1YWJsbXNXYzVraVM5NTduNC9ZYUpNdU0veElmdmNFNjI0L0N2Y2x0Y2hC?=
 =?utf-8?B?VVdSblIwS0pxMncvMHJPOGZHVXlIOC9BMFJ3cENwVVE3bzhCR20ya1IwNG1T?=
 =?utf-8?B?N2NkZEJLeXhKbnlKcEFEUHRuaTZHYjhZR0Qvb2JyVmxFWjgxV1d0OGlNUW9H?=
 =?utf-8?B?MW9TcGJCWFVSc0lML3JxSjRZb0FKNk85YW1aSkNlWnRvM2JvSVErd0tMcmI1?=
 =?utf-8?B?c2k5c1F1OU9OUDFZbjA4c2R0VWpCcTBaWm9qSmI1OVRsRWhGMUQ5YlQ5cU9m?=
 =?utf-8?B?VWk2ZVpmUmpHbmR0RGI3UzhXOVNIcWdPakQ3MkQyOXdXb0ZESlZqKzdmbFdU?=
 =?utf-8?B?bHlQZzJqMnFVMW00c3J2dHN6N05pWko0THRGMm56eXRHd3ZUb2N2VENOa3k1?=
 =?utf-8?B?U1VISnphWExLV2JvVENwdHJLUC9wZjY0T3RrSEIzeDRLMittekU1cm9LSWsx?=
 =?utf-8?B?a21QdXRvNHhyb1Q3Wkl1dTNvQ29mTDMzZS9qYlZtVnhGUnBCZG4wcS9vVHQr?=
 =?utf-8?B?Vk1GTDErcmhuNWZ1RkVrOC8yNkh5TEZnSzBBRGNGL2ZENy9vMm5Tblo2bnd5?=
 =?utf-8?B?RWtwaFk0MzdTOWZDd0lKVDJQY2t4S0QvWk9QNFBSNkpuckRRZ0VoVnEyaWNy?=
 =?utf-8?B?RXJpbGNac1JGUW5sY3VBYXFwYTRwbjR6SHc5Nlo2U3pNMWEwMzc1UjE5OVdq?=
 =?utf-8?B?M2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 73f1c035-df95-41ab-ca08-08db794d3a15
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2023 09:34:40.0567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9LNpYPm8iR64MGF4UnNZcW/eEo6dzPgzjVrLDYVpL7UyBN76SDLRFdYt35EwV42SjsUM9mFBkZRoZ+qBClnp/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4878
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/17/2023 2:57 AM, Sean Christopherson wrote:
> On Fri, Jun 16, 2023, Weijiang Yang wrote:
>> On 6/16/2023 7:58 AM, Sean Christopherson wrote:
>>> On Thu, Jun 08, 2023, Weijiang Yang wrote:
>>>> On 6/6/2023 5:08 PM, Chao Gao wrote:
>>>>> On Thu, May 11, 2023 at 12:08:46AM -0400, Yang Weijiang wrote:
>>>>>> Add handling for Control Protection (#CP) exceptions(vector 21).
>>>>>> The new vector is introduced for Intel's Control-Flow Enforcement
>>>>>> Technology (CET) relevant violation cases.
>>>>>>
>>>>>> Although #CP belongs contributory exception class, but the actual
>>>>>> effect is conditional on CET being exposed to guest. If CET is not
>>>>>> available to guest, #CP falls back to non-contributory and doesn't
>>>>>> have an error code.
>>>>> This sounds weird. is this the hardware behavior? If yes, could you
>>>>> point us to where this behavior is documented?
>>>> It's not SDM documented behavior.
>>> The #CP behavior needs to be documented.  Please pester whoever you need to in
>>> order to make that happen.
>> Do you mean documentation for #CP as an generic exception or the behavior in
>> KVM as this patch shows?
> As I pointed out two *years* ago, this entry in the SDM
>
>    — The field's deliver-error-code bit (bit 11) is 1 if each of the following
>      holds: (1) the interruption type is hardware exception; (2) bit 0
>      (corresponding to CR0.PE) is set in the CR0 field in the guest-state area;
>      (3) IA32_VMX_BASIC[56] is read as 0 (see Appendix A.1); and (4) the vector
>      indicates one of the following exceptions: #DF (vector 8), #TS (10),
>      #NP (11), #SS (12), #GP (13), #PF (14), or #AC (17).
>
> needs to read something like
>
>    — The field's deliver-error-code bit (bit 11) is 1 if each of the following
>      holds: (1) the interruption type is hardware exception; (2) bit 0
>      (corresponding to CR0.PE) is set in the CR0 field in the guest-state area;
>      (3) IA32_VMX_BASIC[56] is read as 0 (see Appendix A.1); and (4) the vector
>      indicates one of the following exceptions: #DF (vector 8), #TS (10),
>      #NP (11), #SS (12), #GP (13), #PF (14), #AC (17), or #CP (21)[1]
>
>      [1] #CP has an error code if and only if IA32_VMX_CR4_FIXED1 enumerates
>          support for the 1-setting of CR4.CET.

Hi, Sean,

I sent above change request to Gil(added in cc), but he shared different 
opinion on this issue:


"It is the case that all CET-capable parts enumerate IA32_VMX_BASIC[56] 
as 1.

  However, there were earlier parts without CET that enumerated 
IA32_VMX_BASIC[56] as 0.

  On those parts, an attempt to inject an exception with vector 21 (#CP) 
with an error code would fail.

(Injection of exception 21 with no error code would be allowed.)

  It may make things clearer if we document the statement above (all 
CET-capable parts enumerate IA32_VMX_BASIC[56] as 1).

I will see if we can update future revisions of the SDM to clarify this."


Then if this is the case,  kvm needs to check IA32_VMX_BASIC[56] before 
inject exception to nested VM.

And this patch could be removed, instead need another patch like below:

diff --git a/arch/x86/include/asm/msr-index.h 
b/arch/x86/include/asm/msr-index.h
index ad35355ee43e..6b33aacc8587 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1076,6 +1076,7 @@
  #define VMX_BASIC_MEM_TYPE_MASK    0x003c000000000000LLU
  #define VMX_BASIC_MEM_TYPE_WB    6LLU
  #define VMX_BASIC_INOUT        0x0040000000000000LLU
+#define VMX_BASIC_CHECK_ERRCODE    0x0140000000000000LLU

  /* Resctrl MSRs: */
  /* - Intel: */
diff --git a/arch/x86/kvm/vmx/capabilities.h 
b/arch/x86/kvm/vmx/capabilities.h
index 85cffeae7f10..4b1ed4dc03bc 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -79,6 +79,11 @@ static inline bool cpu_has_vmx_basic_inout(void)
      return    (((u64)vmcs_config.basic_cap << 32) & VMX_BASIC_INOUT);
  }

+static inline bool cpu_has_vmx_basic_check_errcode(void)
+{
+    return    (((u64)vmcs_config.basic_cap << 32) & 
VMX_BASIC_CHECK_ERRCODE);
+}
+
  static inline bool cpu_has_virtual_nmis(void)
  {
      return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS &&
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 78524daa2cb2..92aa4fc3d233 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1227,9 +1227,9 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx 
*vmx, u64 data)
  {
      const u64 feature_and_reserved =
          /* feature (except bit 48; see below) */
-        BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |
+        BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) | BIT_ULL(56) |
          /* reserved */
-        BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56);
+        BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 57);
      u64 vmx_basic = vmcs_config.nested.basic;

      if (!is_bitwise_subset(vmx_basic, data, feature_and_reserved))
@@ -2873,7 +2873,8 @@ static int nested_check_vm_entry_controls(struct 
kvm_vcpu *vcpu,
          should_have_error_code =
              intr_type == INTR_TYPE_HARD_EXCEPTION && prot_mode &&
              x86_exception_has_error_code(vector);
-        if (CC(has_error_code != should_have_error_code))
+        if (!cpu_has_vmx_basic_check_errcode() &&
+            CC(has_error_code != should_have_error_code))
              return -EINVAL;

          /* VM-entry exception error code */
@@ -6986,6 +6987,8 @@ static void nested_vmx_setup_basic(struct 
nested_vmx_msrs *msrs)

      if (cpu_has_vmx_basic_inout())
          msrs->basic |= VMX_BASIC_INOUT;
+    if (cpu_has_vmx_basic_check_errcode())
+        msrs->basic |= VMX_BASIC_CHECK_ERRCODE;
  }

  static void nested_vmx_setup_cr_fixed(struct nested_vmx_msrs *msrs)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d70f2e94b187..95c0eab7805c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2748,7 +2748,7 @@ static int setup_vmcs_config(struct vmcs_config 
*vmcs_conf,
      rdmsrl(MSR_IA32_VMX_MISC, misc_msr);

      vmcs_conf->size = vmx_msr_high & 0x1fff;
-    vmcs_conf->basic_cap = vmx_msr_high & ~0x1fff;
+    vmcs_conf->basic_cap = vmx_msr_high & ~0x7fff;

      vmcs_conf->revision_id = vmx_msr_low;


