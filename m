Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1816762C867
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 19:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbiKPSzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 13:55:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239287AbiKPSy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 13:54:58 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2053.outbound.protection.outlook.com [40.107.101.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBFB654C1;
        Wed, 16 Nov 2022 10:53:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ro26fusu6otApd5rQyYgP3VO9GaYvQPdoW/alRZMoFKWTB/2ilZRnvEjrW4jFISugMGDOt5rOfTQCEjz50zPBs7fj0RJfdcdF8Go6rsJrhbJPna5CldsQmaD8yhoXn2TkVBToUU7fF1TJ2zP8vrrL3Z3sNqnx99aBUM98avN7Ewl/6Ujo5c+jNZXSUMe/8xZHkGccO4vUClgkIKO8dPD6MmRQ0VNtcj1xOiU2fa4kPLxKbrndi0s/2TfD+p3oaH+p9JuZc+HpMnlwltkI7Cnru2g4jPxYTV26mK/Bb9QNS+TZ8McfUlRZLS4J+7GssNuXcDSOFApshHN7RNuKjGU5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8UkIagF1d99o20SCsMaBbvUSNbhqPrZZV1gKvFDx5wE=;
 b=mmQdNhO13hu//f6EW7QfLUeEhgGCrNTycgx6ydEDSdmZ0V2k1cOY2elwTIeHicp+xKICOiSw7GpApZzHJ+vSHtt8+wRS7gzXnTLmjbj20fNuY/8i1e7fhRIGJQt+gH28EoRY/ZbfbgOCK+sdxEGQDwui9wKIbkAYSrBbmkyukfv5rl7HhkmVZFDbu/nLS72rFj7/NfXAkklYYHug5SmENV6HsPWWcTu54GscyRjAZx9z3ce9QMU5TWyuK4bqKLrF5qfSall1R9ffyBe+Miskq56A0h/oH2fr61qbTJbIvVx1D8hciNwbp8TCW/oSj2MuzJEMRhN5ROhdCc1ZBZBykA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8UkIagF1d99o20SCsMaBbvUSNbhqPrZZV1gKvFDx5wE=;
 b=N5rX13OWewBCgAd9Oh2qHJ4wFz6AVW3yD4Xdbr3IFf5HS/SOJaxNaNCo6lPMdtF5rKFEcGmRmavUIXMlZFm+Foy/+6TruO1j70pHVrn04HVz7JaIizkfaaTHK5fI4IPN5hmvfJq/anNPqiNmf8OXMTFsnJaCWVJbbJM2VxBPGZA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN7PR12MB8025.namprd12.prod.outlook.com (2603:10b6:806:340::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Wed, 16 Nov
 2022 18:53:43 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894%6]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 18:53:43 +0000
Message-ID: <834d41e7-44f8-53f9-a1fa-0cdb5aaff30f@amd.com>
Date:   Wed, 16 Nov 2022 12:53:36 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     Vlastimil Babka <vbabka@suse.cz>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org,
        "Kaplan, David" <David.Kaplan@amd.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Oscar Salvador <osalvador@suse.de>
References: <dc89b2f4-1053-91ac-aeac-bb3b25f9ebc7@amd.com>
 <Y2JS7kn8Q9P4rXso@zn.tnic> <c2ce6317-aa51-2a2b-2d75-ad1fd269f3fa@amd.com>
 <7882353e-2b13-d35a-b462-cef35ee56f51@suse.cz>
 <5b27a05e-09ad-9139-67b1-77b90731419f@amd.com>
 <9d9f1afe-c981-4df9-f012-89c4cb783cc3@amd.com>
 <973c6f79-38ad-aa30-bfec-c2a1c7db5d70@suse.cz>
 <8692e736-7518-d6d2-ae83-720e42e7a059@amd.com>
 <41b8c83e-2a1a-1dda-945e-99329ca8e7e9@suse.cz>
 <711e6027-1b4f-4aed-47a6-305396d05893@amd.com> <Y3Us9wSX9DrWqCyq@zn.tnic>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Y3Us9wSX9DrWqCyq@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR14CA0017.namprd14.prod.outlook.com
 (2603:10b6:208:23e::22) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SN7PR12MB8025:EE_
X-MS-Office365-Filtering-Correlation-Id: 4865fd36-edd4-48aa-5921-08dac803e21e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2zATeLJU0hDHEzzfM9zN/QCLXrAGNVZ+swOvnGDQ0ZBoxjY0LreZphjFj2U6ZzUmOcTp/BOi9Axo/39+0I3MMczHQMnCRwmacPwdQW6Qfzw7Aw9YQKjG/M3YiTfKCNL4QuVo+2JaFXuVJxZ+i9UQbriJJQp+VDsbb5qOPthWfRU3azFFLWQCMJf8+6hWNR4XutfgbAAg2iK1npKfQtz+OlS4b5zv/j18cQSmF491brApT6srX3LnDjpCHQEzKf6JC9oZya/TBySaC4mxz9RoXT9w5TAJFY/SKR4eQ9IBBCT2UKP3rVRycp07rqldgafUBWIU1grbMYgxQE9LQ9OnWfIhmBSqQP7s4NWtnD5dwMA6yQIxci7Rfi2+7KxjHvRUOV5S4541ReB2B45Qbrz+cyewcGBzhj4z5kn33n+keU6+5xGXd7ikd0iPSj9uycxTO+slU1jsbct7rTobITjQ7byjOoFRxh0b840UPQ+cZhjED8JYxDG+J/7eZSoJUSHkRlOPT1IKQliiNXuo55JwWO+DkETn2B2Oj8zd6mcmq1VxpUVggVp+0mzmVQsni14hL4k9WNwH3dKnliYI7ryJ154NRFB1Ija+/St86GceJlLgq6QW8ZzNnAsbeO1zWnXpvBuF2uJHnY/IRm3Yn4RkcaZ7U7zUAovA0nTH0dtTTm0IRByKiTGY+exlHwpeku+yjGiotT/+sq9Gv5/45fyNZUpwdNlk4gxuiPr3QX9f7qnmHJFlC8YKmHxBH/HvthLni7MIvJIqEyCl66OKOJB8EyDDraW/fyvN+2mX78QugUo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199015)(6666004)(83380400001)(86362001)(31686004)(6486002)(478600001)(36756003)(4326008)(66556008)(66476007)(8676002)(54906003)(6916009)(316002)(53546011)(66946007)(6506007)(2616005)(186003)(41300700001)(38100700002)(31696002)(2906002)(8936002)(5660300002)(7416002)(7406005)(26005)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TWJiaTluRTRRNkhGOVJhNGpOd3l6bit2Nlh0Mk8reE9UR2RYYXErcWhOQkdR?=
 =?utf-8?B?dFNSeit5ckJ4bSs0RzVDSjdIeThuc052Q3dLODNJTEhYYWhhbUtWZ1NqY05O?=
 =?utf-8?B?RjFqdVkrWG1zU1hCK3FkUkZYMGVSZ2hyZ3JaR3lWb1FNUEd0aW1rRnpyRlYw?=
 =?utf-8?B?WUUwcWEvOVM4emlGZHVrR3RwYU5vcEs3QVpaOFk4SDFqak5Kem85YlRDdFpM?=
 =?utf-8?B?R1ZCL0lWSHZ3cXRIbVh1WnRwQ1hMV05KMENweW9US204MGhiK0cxUlIybmlo?=
 =?utf-8?B?eHczUnJsaGRNYmNRVVh4TGlKTE02aFliM2JnNG5lbmxBdEFKUXZNTHZiOWx2?=
 =?utf-8?B?SkN3TXcveE51VkdZaWRRZi9MR0ZVV3RldzRHazRBWUp1QmQ5RkNxbFJ0cFF0?=
 =?utf-8?B?ZGF6cFg3RU1LTXMzUStPYUliYWE0bnVRUldsSWpoMnU1K1JSVUNMUWkzeTYr?=
 =?utf-8?B?Smp6ZUcrTjV1aWJ3MjV3NjdjcmJKZ2k4TUNLcjR1S2l1M2hWUHBqSkxPMzhD?=
 =?utf-8?B?NmpTWnQreDZISEYvRFhIcENXblR4Qi9UbzUvTnJTNkpsNjFWdVFxN25JK0Na?=
 =?utf-8?B?T0p0eENVNUJuVjFtMWxZVW5WYWExUTByS3lXT0Rad2w1VzVGRXlvZWdVcS9N?=
 =?utf-8?B?SjlZWVB3SGdSTFovRno4VnF2VWUxeWJiWmhQSWowa2RHaVlLSitxMXZVU3Rk?=
 =?utf-8?B?KzVVNHA1blhQcU56dWNvMVVIMkt3ZUtJcDNzZVVXczhucUZCeGwyUUJkVGRB?=
 =?utf-8?B?LzlIU2h1bmd3L0EyK3FGcnB1MFJqd0RUb0c4SXJheGpzZUxmYkJqS3NGYWZj?=
 =?utf-8?B?dkhtbkp3K0x5SmxlWWtyNC9MUUhsVHdFVHlYVXI5WTBTNDlmOTZ5aHlhNFVK?=
 =?utf-8?B?VHcrTkcyZElOWTdJTUs3L01wUVB2N2F3MzBjVWsvUklqUWVON2Rwa1NwTkJH?=
 =?utf-8?B?cGM0aDEyUmpzTXdnaFNWcGg1NkZtMnpjM2VkZ2JjZWdRcGx3N2R3Q3pEbEZl?=
 =?utf-8?B?V1A5Mm5UWGo5MGtCdWFLVmdIelhsam04VG1rSGxKaW12UktiNGprMjgweFV4?=
 =?utf-8?B?a3JKVnIza0dCN2JHZTExdmczSldjTTRpQSs2RUtqVDdYWENubG9zN0UxN1gv?=
 =?utf-8?B?dFZlbWUyTDcvWXM1QWN1dGJ5NWlTTXZ4WUVrOGFSQ0hKOWZCRFRiZ2dTNXdN?=
 =?utf-8?B?ODlIRXdzcmVYSUx2R0JVWmx1MFRHOU5kVHBvMHFsTWYveS9KN3prRjR6ZDdV?=
 =?utf-8?B?SW43Vjg4ZkZWLytHTUQ0aE1zY0FpbXl4OWwvK3Q1L3IvMWlmdnN0S2J0TDNt?=
 =?utf-8?B?WjI1Q0YyVEZZSXZFRWxhbHNCcittQmZlOWJkQXY2SGdZdDJKYUd4R3VJeFRQ?=
 =?utf-8?B?SjBncmV4aDNvcGU3UkYrcHZxVWtjM1A5czA5RUlwR0lHQmpqZFdUNG1YZHp2?=
 =?utf-8?B?M3lQTGN1a0dKWnVML1BqMWx5R1hwU3lVQy9CTVJCTC9qTU5LY21XZjd2MUZk?=
 =?utf-8?B?T3FublI0Wjl0MGFCTXRYQlozdHRreE5PRTdodHErc0p3N1lLUWJhNHEyWE8v?=
 =?utf-8?B?OGgrVGVSSS9rS21WZTI2VHhVSzI4SEFEbFBIbWUwVytzQlE5bS9oQm8wWHMy?=
 =?utf-8?B?RGVOekxZK3BRZnlUZWt4VWxrdS9haFhBMnppZ285UzB2UUVoeWxKNWRZRlh2?=
 =?utf-8?B?TXVsVGNxOHBtZjBUQXVTOVJCeHNoeUZQem15SmpMNnpwWU5UQjBwWjJaZmpL?=
 =?utf-8?B?Qkg1Tmp4Z25nVG1SdzBwSm4yQ25VajExcHdyTTQ0VDYvbFdWZzlqVll4UitZ?=
 =?utf-8?B?VnN4V1FxMlBkM1d0OER1eExheGoyTTZld1UxY2xOeXNXN1RMOEVhM0pHYUdh?=
 =?utf-8?B?UGJkNzRBcks5ODZrWE05NU4wVnlzWkVmMUxPK0prbmpOK1RUb1dyb3RRcWVi?=
 =?utf-8?B?WGVUVmFWZnA4akJqZkFWRDJUajMvSkI4MVJHNDhNUjJlamVVUVg1Qkhid0Z2?=
 =?utf-8?B?MG96TmJDdml2MnNQS1JYdTMvVG9Pb05ESkMvanNtekp5bW5LKy9URnR1eWVu?=
 =?utf-8?B?SkNNU2R5VnVIMEduTTlaV2tDNU9vRUJPc1FmdGE5TkFOSmNOVjcvUThBZHJq?=
 =?utf-8?Q?Av6H6hP5gIQORolV69nObEJ/i?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4865fd36-edd4-48aa-5921-08dac803e21e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 18:53:43.2318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LWyW+0x9LgX0hQQO5W0wVtDSC05iAXlY6fXbiE2T2SPzZNOwx6YbPNLZLDtIH5DaDYnnwo7ThdeFSlrJ0eadsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8025
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/2022 12:33 PM, Borislav Petkov wrote:
> On Wed, Nov 16, 2022 at 12:01:11PM -0600, Kalra, Ashish wrote:
>> Ok, so i will work on implementing this leaked pages list and put it on a
>> sev/snp associated structure.
> 
> See __sgx_sanitize_pages() and the poison list there, for an example.
> 
>> Also to add here, we will actually get a not-present #PF instead of the RMP
>> violation #PF on writing to these leaked pages, as these pages would have
>> been removed from the kernel direct map.
> 
> So if you do the list and still have the kernel raise a RMP fault for
> those pages, traversing that list in the RMP handler to check whether
> the page is there on it, should be a lot faster operation than doing the
> #PF thing and removing them from the direct map.
> 

Actually, these host allocated pages would have already been removed 
from the kernel direct map, when they were transitioned to the firmware 
state. So actually the not-present #PF fault will happen on any 
read/write access to these leaked pages instead of the RMP violation #PF 
(not-present #PF has higher priority than RMP violation #PF).

If these pages cannot be reclaimed, they are unsafe to use and cannot be 
added back to the kernel direct map.

Thanks,
Ashish

> And sorry for misleading you about UPM - we were thinking wrong
> yesterday.
> 
> Thx.
> 
