Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCF0646990
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 08:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiLHHOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 02:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiLHHOQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 02:14:16 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2425F958E;
        Wed,  7 Dec 2022 23:14:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CCHHnUUhT216LYj/xgNkV5LynygAagjb05mBG5DXCYT2CdItP/CWidpn7MXUCdt43V2jHahN9lP8ZhqlisdWPjkpWJYM4wyV57rD3TslCCMvvrBASrGHjJYIFncf7Z+LICNXFTvmvkkyBm8MOV0dvQd1c2WeXnIMGhSjtyMUm0SNpX2VnMsW1Lto0/TjobG4i5zR93b8Ig2gH0YKIcePSe5fC0HmsJlSlHlysYr945koSV4DXaNDuhhXSEERgRmci9Z/gjDvH+pDVSbzvFx43zmADkmaTXvNBR7VhkrkIf8aDJ43eQiCzB1pbApE/Zz3CxBK3JbE73ktIuSg0oGIZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G1nqxwgKBe4DWVol9V/aU0Ym9RA6gduSiC7SCvhU/6I=;
 b=PviXBD3fU1OH9l+6ySTWyWaDRPCxB8EX7RlPFcQYow3rTeArZW29m5zQ9dCqgGg0TLsxLml4TTjxKMk0YTLbhMKzmM/LnG/rArBluie54f70lVjVkmjOSgTty4Wd5hOE0gt81WmGrEFnQ9K8mkIRZ8HaN3qgoRnoLbK9Gl8VDz7r2KFuBwPXmaJQkfMdReuxbQXlpEIMJ5yXo6dXw1A2Mrjy3B+hOLBEfogOVaz23pIG/eXbh0WxDpsvVtT9QT3fi6LaoHjxCAA0ANT5BFbdj6Y4l4nY+xnBVIX8wLawUVhyCra+FcoAXgRGCdfKFTV6FzaxRM/ROQ3Q/vztTZkbxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G1nqxwgKBe4DWVol9V/aU0Ym9RA6gduSiC7SCvhU/6I=;
 b=A6eS7z6abR72a/jQDmcjhHathA3d/pq8nYPhke8fxY4lBNzjSGYBj/k2QP352jpUroLD3tLk+0+A0IDzsMTFqcS3C52DZAXGDl5p3zK8iOwLYO7lw79CW1NtvgqK1h4bAMNcvhmWACAKyxrD9fQ4ldJacusydPUyEhYvVprAkEs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 SA1PR12MB7101.namprd12.prod.outlook.com (2603:10b6:806:29d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 07:14:12 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::7dc4:8eb:cc3c:3cd4]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::7dc4:8eb:cc3c:3cd4%6]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 07:14:12 +0000
Message-ID: <ac5d066e-5c61-7afe-b496-8254633c24d1@amd.com>
Date:   Thu, 8 Dec 2022 18:14:01 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH kernel 3/3] x86/sev: Do not handle #VC for DR7 read/write
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Sterritt <sterritt@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20221201021948.9259-1-aik@amd.com>
 <20221201021948.9259-4-aik@amd.com> <Y4jmmfrUXAzydM0G@google.com>
 <Y5DjBAH1P38hjJRP@zn.tnic> <Y5Dke3WOpd8bJK9q@google.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <Y5Dke3WOpd8bJK9q@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5PR01CA0052.ausprd01.prod.outlook.com
 (2603:10c6:10:1fc::12) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|SA1PR12MB7101:EE_
X-MS-Office365-Filtering-Correlation-Id: 43443e19-a2af-4fed-a72c-08dad8ebcecb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 92kwf4MU/wYfCfweFsTe7pHUykpxTfdsVO4U+zJCi3IcDQ5ZNGnHAOlFThrfYmVcONLZkeWhDRyAHVKJSlcq12EsmTE/G+BGvrkjzAPKqO9qCM3BHtNlajy+lFRfYO3rNuPsrhs2U8czfr7OtKJTO0XUHtaU+iui3lb+nXm52sI6sIc5pZajO7aEFPBxFjWXcul1Xhjzi8/FiSD8ZsojI1psQ2yB8Mm7zBwffQuyoeYJlUrkmnYN7KzIbFwYvly9x97nVCgHIhU6mbpHyzODYVdmJrKpCisEAIjzf9wjcTnRppd7TIe4r4eS6d6C3l1N5o7PIhBk2JLl/Li++XfpOSK/xPcAkIrE6Sht7JSJIQ1O7M8RKhHl81vvwE06QzkEJOo1gG5sBqVJ+gaHpoNVoQpsw5cbxqtt3v5jB/tR5bH6JIIvNBbe9z3LUOMGZ7Fu6bmjEItRN5YtNbx7mQioi64D1QeeI5udiV/dZ3NDO0QgBNc27jJQ9KigrC+kJxAj83WPoYlJ+n42DWycdUkAaISbOVhMS9y5bBUjr7PDAtOGpt5qMaU9WpmP0WvkuH4QqGBfPqyJNEi/+2hsHehyRbZVO3S7nGcgS248YpRUlonW8tTIqHeQFfC/74hM00Q8Vt9agvd7CoPUnFxa7utyEiADX03foBWf6sWe8NqODd3th8v8LRCa9bCK9ibB1uyyG22AAze8kj5wpu/PrXgkIwvBfcMeAtQfG64GQKgoTZE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(376002)(39860400002)(396003)(136003)(451199015)(31686004)(31696002)(6486002)(478600001)(6506007)(53546011)(26005)(36756003)(38100700002)(6512007)(2616005)(186003)(5660300002)(316002)(41300700001)(4326008)(8936002)(6666004)(7416002)(66476007)(54906003)(8676002)(66946007)(2906002)(110136005)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dlc3TkpaNUc5VzgrU3FzdFdmU1ZXcjlGVHFpQ1pkNjBjUTRjOEZ0aXBoR3VJ?=
 =?utf-8?B?T3djdHpwRVRaQ3Rlbk9ldHdPMFRDOHhVeCtocVhVeTVDZk1XOXlWak0rbjhw?=
 =?utf-8?B?eWtHbEE1TENhRmdwWldxbVEvMURmYmV3cHBycHAxTWlxNEt6UjhrS09WTm9C?=
 =?utf-8?B?MjlDYXI1Vkh0L1krRVptRkZGakdYUVBJWnFxTGcvS2h1VU96cTFVSEFZa0Nj?=
 =?utf-8?B?QWJCZVZndmNvRHFKNTZCWjl1eUdFR0VMU3dndkV3QUtPSkgydFljOUx0YW9m?=
 =?utf-8?B?TzhXTm93TnlvK3F0NmhYdVFoZXk3NEpPUjZ6UXRWdGszOERGY3NzMlJUTUx3?=
 =?utf-8?B?UFhDZ3c3OWo4Tld6N2hOTjVTZFk2TS90Uml4MWdrMmR6cXJWbTRCYTN6dDUz?=
 =?utf-8?B?WkdRSnMvb293Z3FoSVdjMjBndG1neWtaYk5QT0hSaWhJNVlDRSt3MFplUWc3?=
 =?utf-8?B?WVdFUVUvSmR0cWlWN09kNzF0c0ZhekpsVWhUZGRvbXROdEszOU4ydXJTUW9U?=
 =?utf-8?B?UzB1UGF2L1huNERBSlR3RTZXQWtVZE56WjczNnQ5MEZRT2RQQkpkc2J6dFVK?=
 =?utf-8?B?Vld1blkxS0dXUUFibXg0ampuMDZaQ2dmSnVuUlhPWCt4eVk4NVR4NlZJNjlk?=
 =?utf-8?B?Ym9EU3hldml2eE9wQStxWTRqdmd6SW1ZVThuT1l1SVhDdGkzZUpPRnluL3RR?=
 =?utf-8?B?Snh5eDVaaHNKODcva3BVSnN3c3VnS0FySm1zZVVJMEs4cDJ5blFmQytIODRN?=
 =?utf-8?B?cXg5RXRuNHVaRHlOb21ISS8xQVdkZDkzaGk1R0hydVhhekIzN0tsVVd0Ymwv?=
 =?utf-8?B?dEpQaWhjcU14K3hMbTdCZThPREtsR2NFT3A5QlB2WjBFZnpPcDhZbG5ZMkhn?=
 =?utf-8?B?ejB0UnNXRWYvZlcvNW5MMXpEd0hlSWlhQjZlM3p4eVBPR2w4NGY2TENKbWF3?=
 =?utf-8?B?VmovNDJiRnpIaForUW81V2gzbEpRWGRqVWF5WURzWXVNV3NIbkJtclpsU09o?=
 =?utf-8?B?MCs4VkYrV3ExSDJWRG02N0U1c0ZNeUw3RDl6OXg4ZXBOL0xkTytnYkw0MHlE?=
 =?utf-8?B?V2VlNVZDbWZZMzg1SWhxM0lrbWM3VEZjUjg5aUdMN1F2UHlGUTJBNm5maE1K?=
 =?utf-8?B?QjQzUWhVTmhQb0VFczl6djQ5ZkxtQzBXbzQxczVWalU2M0hSb2VHNDdkellB?=
 =?utf-8?B?ajFuMWRUay82S0dvYlAxMDl4SXBsRmV2WCsra1NXaHlQa0xpNk1mb1ZHcEVB?=
 =?utf-8?B?d2RYSVhid08vN05oT1orR0pNZ1FobEgrekhTc2hTQzQxN0NxTDVIbFBIdndG?=
 =?utf-8?B?UEluUWNIZitjRVB4dk13Yk1yZ2JteDgrT1dNbk9OOWNhOUxYSGd5VW1iUUZt?=
 =?utf-8?B?Z0dWRHRGTWIwVWJVUkFmbDRnMlFyQk9FcmV3UXRHc2xHaWZzV1NTS3VHcGJn?=
 =?utf-8?B?emxzV3Q1TWJVM292TWhETUYzU20veUFlamVEMlFhUGJJS3RFelg3REpPMGRs?=
 =?utf-8?B?WjdnQkFIK09HQzQrb0ZJWWhMN2VrVVR0WFVBWG9Qc054b3BLQ3l2TDFvMXVS?=
 =?utf-8?B?d2RrVWhnSWZQWnpHSFhSVXJHUTh1QmFqOWI5cFFvdUJZVHQ5SWNmWmQzLzZO?=
 =?utf-8?B?ZzhlSmYyY1g0bUtobTFvUUdwZi93NERlTG80VEcrSi9DTm80MkNJZ2grdzVz?=
 =?utf-8?B?b1BVNE9sTGhHazBidGFKbHBDRndTaDQwcDZiZU45QmtIMEJkdnhJRnVLN2l6?=
 =?utf-8?B?ZnppbmltNGVhWEFDU0ZueUdCQWdWN255ajlEMWk2bFF2eVFSNmlXSmxoeG1h?=
 =?utf-8?B?VUtPTGsvS0VFaHpBWVZjbXplbnZUOUdUVk9ScFA5ZGxnMGY2R2tSY3BYcVhN?=
 =?utf-8?B?My85ZmhxTXFsT0NRR09TNHpqdmFoQkNlY2g3cDRMYUdodmxPdXl2Qk45Q3pn?=
 =?utf-8?B?WnZXMTVQdGlrWGluS0JjVHp2WXFVSE8xbjZWZ1gvdFNtMzcwZm1iOWF4d0po?=
 =?utf-8?B?b1ZOaUJSQUxjb3JySGlDN1dmQmRrMDh5M1VidXlRVW50NEd1YW91MS9qQnlU?=
 =?utf-8?B?R3BRWUdkTEFYbmxINk15TktyMUYvbVFrQVp2d1BUTEgwYlNJT2lhblJoYVJr?=
 =?utf-8?Q?zZrP0KpDeCmLHx9ZeYIEV0KfM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43443e19-a2af-4fed-a72c-08dad8ebcecb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 07:14:12.7369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JMSNwArLOFYxcIYoW0xoNdVrpTM0AmyBeeh4uD5sw7ntpD/Ja7x0mCei9EFrTJ6r0EzRja3YRU7TYdpcoMLwLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7101
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/12/22 06:07, Sean Christopherson wrote:
> On Wed, Dec 07, 2022, Borislav Petkov wrote:
>> On Thu, Dec 01, 2022 at 05:38:33PM +0000, Sean Christopherson wrote:
>>> Probably high time to add a helper/macro to convert the SEV_STATUS to
>>> the SEV_FEATURES field.
>>
>> Nah, there's a couple of
>>
>> MSR_AMD64_SEV*
>>
>> defines in arch/x86/include/asm/msr-index.h.
>>
>> Bit 5 should simply be added there.
> 
> Ah, yeah, that's much better.

Sorry, I am not following. How is moving the bit makes 
SEV_STATUS_TO_FEATURES() not needed?

When I am setting it in VMSA SEV_FEATURES - it is a bit 5.

Inside a SEV VM, it is SEV_STATUS MSR and there it is bit 7. Mentioned 
MSR_AMD64_SEV* are SEV_STATUS MSR bits.

Since the current patch is bad, I'd rather define the bit twice then:

arch/x86/include/asm/msr-index.h:
#define MSR_AMD64_SEV_FEAT_DEBUG_SWAP    BIT_ULL(7)

arch/x86/include/asm/svm.h
#define SVM_SEV_FEAT_DEBUG_SWAP         BIT(5)

as nothing really says that SEV_FEATURES is always going to be 
SEV_STATUS>>2, even though it is now.

Soooo what is acceptable solution here? Thanks,


-- 
Alexey
