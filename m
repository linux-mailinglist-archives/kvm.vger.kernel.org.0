Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E2A589A19
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 11:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239068AbiHDJv0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 05:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiHDJvY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 05:51:24 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2059.outbound.protection.outlook.com [40.107.95.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4803F3FA11;
        Thu,  4 Aug 2022 02:51:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NYaiKd9o6iCJfql4fhdQnkslg57PHKqSfTXt4IOsnIKxBQ20iUu0yzwOaTCRQj1PzCEp8zB3Nnquq5hqcnxHLBwQCAka5unnAoVS69cdsrBaQv7SHzdGfZUWAjCf2i/Tz8qsHDXp7Y4hqMi9ddD8LpxuAWvrTLmlOX8KAPyYrFAMXbjyrMa4NHDvVxh7hBK4FXgaXniv/b2hzXZnZkILf+B3iSCGgq24FDb0QSjbM0zYGLhxvxweVko5jWh/DUVtID6eKkpQdClIZvx1zAiPONvW6xjO5QY5PwQAFjKEhkz+iDHl7QA8OOqz+7QsTgOTaaKLGK3TcRPJfxHmcuRoJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IYrH0GbjAPx27f65+2EdbbvvXdvHjHi+dfx0XO0cwwQ=;
 b=TNr5pT2nZgKMWWayiqGsfa8zDsNCO4T1KPiW/PfvFB8rIfwGZFfYRICrfhDjVo328BsZlQig0++29hwVKxxfGGkClfLXMBteM7umlxywYP0BYvDHgRha6BR9cRHNYZ05zqOZjsaesIJcGpXJeAA80QTgwq4+pn+GPdcjNBEkp6uwKJmLuqE6IYdcZl0+ha0ofI6vO5rCaDMyLdSxKkbzkpP68lhEdWs+/KsLyjUEiIqdUiQsQpdz5t4bHwh+uENP1g5T907cH3zqtDtlsSSV9IHb+MQRXa4GN/verRpA5tysGn+N9Qj7A3CHRJZzfcpeTj9BZ9kK0JB1CAy1ZVIf6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYrH0GbjAPx27f65+2EdbbvvXdvHjHi+dfx0XO0cwwQ=;
 b=FuaN9IM6d/sTMeIp56gnR5msYbmWKyGJIf6HsPhFNaMNVY0AYGu2qTp+64GfRbwNs11O5p82dozOQU0vD3wXAI71TCAuAs1vu0o5cSxEeIDYKE6mUPHeLNKzas6G3cPJ6Cf7OSpWYOG7b9+6/wNKbM5D72WLoz5NHmCL9aow4NU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by DM4PR12MB5086.namprd12.prod.outlook.com (2603:10b6:5:389::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 09:51:20 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a%8]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 09:51:20 +0000
Message-ID: <1782cdbb-8274-8c3d-fa98-29147f1e5d1e@amd.com>
Date:   Thu, 4 Aug 2022 15:21:08 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCHv2 4/7] KVM: SVM: Report NMI not allowed when Guest busy
 handling VNMI
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220709134230.2397-1-santosh.shukla@amd.com>
 <20220709134230.2397-5-santosh.shukla@amd.com> <Yth5hl+RlTaa5ybj@google.com>
 <20c2142a-ec88-02cf-01f2-cf7f8dfcef77@amd.com> <YuPxkMW2aZxrw57n@google.com>
From:   "Shukla, Santosh" <santosh.shukla@amd.com>
In-Reply-To: <YuPxkMW2aZxrw57n@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0204.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::14) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a859538c-9045-4683-4785-08da75fee1e7
X-MS-TrafficTypeDiagnostic: DM4PR12MB5086:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J9NGC4lpid0US3cNpFYFgnC6q/5IqSZnYtnMXCp+TTAmfSUiVCFdXn0s19TJXP88yMvpMQ3210tRTYpnED9lXy8RoxtD1nL+WidkGVfeOk4yi0FAXpL8J7PyPFZCf7sJ+34f/3F18xt6/tNQKqoaerLEnXGWnLrh5yIerVzFr0o38K0c1h/a4WE8rkv8aNM/Z3Jjx/bnk2b8FdYNqOYOKKsuZi/cBenFttn+2opKGdRl5D3DzC6hacOrUl6zxm/uHXOZ4Y6Efx+aq7hWq8y6ef6l0S/94d0eVAV4iMavL2uj50xyQ3oByO98q921VXa39yVkaBnH1v5+dqdkbpfWrLdqHmJKms3oaIF9aEvi1gCRLdeIPDkMKykQOgfZNpUV29nixswi5kMGUlzslSx+rgalGCNgpWRw0TuO3LvXDtDou+mUxfcaSSEbQR4O3Vavdh8IqSjGU7tk1J/H/VMAegD7+OgeZgzQLxuoslErOq4XYpug3DsNVgst/DfhURvqlm5MmBY7tnWBB38UqKN8Rb0HcbN01EW8cwqTpG3nS3UlvsdyHxQaUPC+DsrmOEIUhP5FsUqkwife3lcBZYEKu8ZNHA8fNuXX3YhSG9vAraNgNhVjUSO7lnuv5wdqaPEDilOlNATeJuMBEeRCT5O5y8jNOHwmU5XgNu5MPxxcqXUPKNjQ1p6tUE/Kl2564sBJGRzZLyPcnb0ER41W2/kLiXFh9ZGjMlhHMT9O595xpZ1dmfchInyqBjD8K150D0h8SicHd1FXQVxRmsx8ZDhGVXKo0dwZzXTvrhzqEMf7Qz+R+2ZOwOuarv18+l9QmBeHZn2GxcJPsXF7C4TrnmTUaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(376002)(346002)(39860400002)(396003)(6512007)(186003)(86362001)(478600001)(4326008)(8936002)(6486002)(66476007)(26005)(8676002)(66946007)(66556008)(5660300002)(83380400001)(6916009)(31686004)(2906002)(54906003)(38100700002)(53546011)(6506007)(41300700001)(6666004)(31696002)(36756003)(2616005)(316002)(55236004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U01Ralk3QW9QYzB3VWc0UElXM0VTMnJlb1IrbEl3SlllQkVkYzNuSEdOTlFk?=
 =?utf-8?B?TEduK1MxcldSYldldFlRNG1sUTU4V3RaWFEwdHhLZHpqTitTb3RtVUYxckF0?=
 =?utf-8?B?L0JrZG9lZ2pMaitXMFVkWDBPRnJMazkrUU9FeXNBWlRGdlZSSUxSeXZCckJQ?=
 =?utf-8?B?VGRqV2k0WUI5ZUJBMkZPL1dkV0dLRkNUQmlWK1pmbDFsMDFmWVVNYlRNekNS?=
 =?utf-8?B?T3hBaDM4dzNvbXlHKzZ1N2puYWhzc1AxWU9ucXFJVWRnRDk5K2dxTm1OYW5O?=
 =?utf-8?B?aDlEck5DdzEybzdlNU9RcHoxVWM0ZGw1L2NmZ2dSYlpaUlg1d0cvaFNsZCtt?=
 =?utf-8?B?RHNNTWVjc0xGN1hzdjZEVzNleWhjSStqWTVINkR5a3NOR2RBRVZoZnFVek1l?=
 =?utf-8?B?ajhjMVI2V0lJMC81SGlBMjZ3R1Y4QWNENWJKbmJjNG1adnZ4OWhTeThJS3Rs?=
 =?utf-8?B?Z3VMTFhMaUhQaUZhcElld253b3pkWVRBNHc3N0dxWGJFTDhNWjNlWVU2bTlH?=
 =?utf-8?B?dUhlUUFlcnpueXNpeWhBb1RydUZnbVpkOGthV0YwdTlyTDhIdnJRSmtxcTUv?=
 =?utf-8?B?TXIrR29YWjFoOFZJU1d5bk9OV09QU1JKYWVVRHoyNFBnM1F3S3V4M1MwWDdn?=
 =?utf-8?B?RnpIbWEvdnJwWlZTdEk5bmFVZHVHb3FKOWNIRkxUYUFFL1FaSVE2OTQzY05h?=
 =?utf-8?B?T292dzgwbmRGQjhOUEFqeElrT0U1c3dHTzFqanZVenNyczJ5QkwzTFB0VmRz?=
 =?utf-8?B?dmtZeFUxbXRtL2xsOXRHZ2hOejNsV0FDa1FvUzU4SkE4dkZrbzBRRmNmVUxy?=
 =?utf-8?B?RExTYjIrMEtrcW5sc1hLL0c0SDRXcTFTRWF4cU9PNUtvQnBxMVJndmlJd29B?=
 =?utf-8?B?Mi9TQW1GOEFGd2NiazR6YWZJMUFOaFVRQnVxcEt4VEtwUWdjNThjbERzU1BC?=
 =?utf-8?B?aWE4RkN5NHF1d01PUHdpdVBialR5WTJnd3JQd1lBOTFRR0h1aHNrT2FycVBo?=
 =?utf-8?B?U3NGMXp1cFJ6U0JHeWlYWERKNHNUOHQ4dkFTY3JaNmY2UXdQWmRZSjlBS2E5?=
 =?utf-8?B?RytYUlVlK2xmSGVabUpFUGd1MFEycmJEbTExV2JsOUZ0QXIwRU9JbkVudEtB?=
 =?utf-8?B?Q2pKRFZuczJnTmdUWmNzcngzelc3ZXpFK2xyMWZnc0xkdFh4aGozaWNCUy9j?=
 =?utf-8?B?VEsxeExyNlN2QXZIOUdqMlZrQXMrb1dub2V4aXBIWGNBVWcxOFBqeCtkdXhC?=
 =?utf-8?B?VUlEWHBtMHN6V3pVc0ZKK3RtdHAvb2UvTi9KUGRoUFRRcjRWc2VwWVZRZWxK?=
 =?utf-8?B?ZHIrQ1BiRzNiampyUlJNUlBsc3pqRTVuSm5LTVJ5czZaQXMrL1hnTlZNSy93?=
 =?utf-8?B?emJUT0xWV25vR3ROTFgzMTB2NW9WV0xYd1ljUDZZblltaEcxNXFxK3dJQUEx?=
 =?utf-8?B?V3BIdWhZVUtBdHRRVVp1ZGVPU2ZhYXQwNHppYmcrUkFza3VFSklYLzgrVHp6?=
 =?utf-8?B?d3A2YTY0ODZzZGloN1BrY2loRE8zaE9rREUvZWMraEx5RlczTEoxc0Q1T0Vx?=
 =?utf-8?B?UEY4M21TV1JZdlBpMXE0cC9SNVFUYldyQjJvK2dIQWlKZUt2anNPbGZTTVNi?=
 =?utf-8?B?UWROZTlyNDRtaVp1ci9lQjVQL3dKVXhjQXVUTnlyaUN3UnUwcWNoSnpmOElq?=
 =?utf-8?B?UlhDRTdSeEU4L0pjZ2xuSHcwZDRrUzJTelhzM2hiTVBnazRPTWxBK2tJRWFF?=
 =?utf-8?B?dlB5bWszR3F3ZlZWM2FvdFIxSFdMSnFFc3BzUnVYdUhhUFUweFZsWXRZUThJ?=
 =?utf-8?B?WG5JTVE2dENGeTBScWFtdVJpMDJLY2l3RWxrTXFyM1B0TVJsNGl1ay9VcTJQ?=
 =?utf-8?B?ZG1ZL09yR1d5OTd1eS81R3Y4cTB6c04rYkY1NnV0cFZhbHFhMFBnalgwNWdW?=
 =?utf-8?B?RnFFU0RDNXVGcXozMHgya1dFaC9hb1BrY0YrTmZBUmVQVnVNa2txaEpkbHA1?=
 =?utf-8?B?UkFsUFlWZTVWVXdpcDlJQUhlMkFWeFdQalZ6dzI1bFVzenFjQnNWaHo5aEdB?=
 =?utf-8?B?WDZxeGNjeXEvQ21KSVY0R0s1eWhvVVRhYVZSSzFiVXlVOFFTblcrNlgrUnV6?=
 =?utf-8?Q?yRT9h1KiOXVcKzXpVazLLxKpl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a859538c-9045-4683-4785-08da75fee1e7
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 09:51:20.1816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s5lFhkFQAVUWVenIyVKjJAue0OtdEwsdrcP987nxiQRp/o/EJSNAFS9/iH7S4E+3sTcE7MR4bH9Mp5XqDRyKmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5086
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/29/2022 8:11 PM, Sean Christopherson wrote:
> On Fri, Jul 29, 2022, Shukla, Santosh wrote:
>> Hello Sean,
>>
>> On 7/21/2022 3:24 AM, Sean Christopherson wrote:
>>> On Sat, Jul 09, 2022, Santosh Shukla wrote:
> 
> ...
> 
>>>> @@ -3609,6 +3612,9 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
>>>>  {
>>>>  	struct vcpu_svm *svm = to_svm(vcpu);
>>>>  
>>>> +	if (is_vnmi_enabled(svm))
>>>> +		return;
>>>
>>> Ugh, is there really no way to trigger an exit when NMIs become unmasked?  Because
>>> if there isn't, this is broken for KVM.
>>>
>>
>> Yes. there is.
>>
>> NMI_INTERCEPT will trigger VMEXIT when second NMI arrives while guest is busy handling first NMI.
> 
> But NMI_INTERCEPT only applies to "real" NMIs.  The scenario laid out below is where
> KVM wants to inject a virtual NMI without an associated hardware/real NMI, e.g. if
> multiple vCPUs send NMI IPIs to the target.
> 

Yes, HW supports above case. KVM can inject the pending virtual NMI while guest busy handling
current (virtual) NMI such that after guest finished handling.. HW will take
the pending virtual NMI on the IRET instruction (w/o vmexit).

Thanks,
Santosh

>> And in that scenario, Guest will exit with V_NMI_MASK set to 1, KVM can inject pending(Second)
>> NMI(V_NMI=1). Guest will resume handling the first NMI, then HW will
>> clear the V_NMI_MASK and later HW will take the pending V_NMI in side the guest. 
>>
>> I'll handle above case in v3.
>>
>> Thanks,
>> Santosh
>>
>>> On bare metal, if two NMIs arrive "simultaneously", so long as NMIs aren't blocked,
>>> the first NMI will be delivered and the second will be pended, i.e. software will
>>> see both NMIs.  And if that doesn't hold true, the window for a true collision is
>>> really, really tiny.
>>>
>>> But in KVM, because a vCPU may not be run a long duration, that window becomes
>>> very large.  To not drop NMIs and more faithfully emulate hardware, KVM allows two
>>> NMIs to be _pending_.  And when that happens, KVM needs to trigger an exit when
>>> NMIs become unmasked _after_ the first NMI is injected.
>>>
>>>> +
>>>>  	if ((vcpu->arch.hflags & (HF_NMI_MASK | HF_IRET_MASK)) == HF_NMI_MASK)
>>>>  		return; /* IRET will cause a vm exit */
>>>>  
>>>> -- 
>>>> 2.25.1
>>>>
