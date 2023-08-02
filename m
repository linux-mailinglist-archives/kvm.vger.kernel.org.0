Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C9F76CFF3
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 16:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbjHBOZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 10:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjHBOZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 10:25:14 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282AE26B6;
        Wed,  2 Aug 2023 07:25:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O3oZvi7r7q1R1SwzLroPiyqNE8hqNQBre8PA9GGW5DCL4Ob2B5l0H2WT8ac0D1+l5Xfs89jh8nMmZvuOqq4KzgSjCrve/1vm4Ulpl4ThY9pKtbfA6egEHrijS/k6dOZOCQ5eTnbzHpDVq1p0TrmugSJJ4Xi+gRCCe6Cj+sYAzQuRTWfi1cTFIcEBzAKrS7pVnV3M2bkJBXu9DuuVHIpmvLYUQDy4A4SU9ucsxU9BLSJsS5y6AzF0gogv2sJcEroouvxfLYfqBjm8eKViwexmSbFUp6gquQZq54tAWmX5uAEkF5JKOyTYoMl3ClsoHstsYn9LBrqtTC2gdUxWi31aAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=funUdl/wRolbrkz3qVbGl9HgvDel3BwESRjoM+sPZlU=;
 b=C+GjoTVz7v0uE2u/r4jbqcpJ7JUMyX5R8qB0FH5I3Mie6WP4Wm8KE8oPAm/Nk522gju0KUmyD5xtCuhIDmSChJ7zoC66RKI0wsBisqF71IFvsREs7+enu1+1zsQL39D5QovTXThfGPWVvrTjTvAAzElQT5TC1R2LWKUxo9aaCfbm/DtBGWP+XEJV5wabeJoR1OpOOvoAE9DPBFHcaXOnNc4IzW+ReQcfRxRk6mhcfZzgHdzrq1hZgM9GmES9LxaYAl7BbrFAox8aFCQBS6+oK8zcUT/OZkKIj1G//uRM8+Q4T7vak/V2w0eb3p53UPKMBsuIvDaihET2hlQZGEsywg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=funUdl/wRolbrkz3qVbGl9HgvDel3BwESRjoM+sPZlU=;
 b=H6lEtR42jT8GVY3aziWunFjv4sIqxd2/5KdWFbEQAYtmVYKD3EBrxbFAzttbiN2cpD44tyQtzvc4ZjBzj+R8KuBbH/srlZgnVkSsu4qdwiYFfLJtXW2J7TEVuWlQiG39x0XFaGokdhRuzQcwozft1u4EOjUQMat7NFm0ltXIBYE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by PH8PR12MB6985.namprd12.prod.outlook.com (2603:10b6:510:1bc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Wed, 2 Aug
 2023 14:25:10 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6631.045; Wed, 2 Aug 2023
 14:25:10 +0000
Message-ID: <bbc52f40-2661-3fa2-8e09-bec772728812@amd.com>
Date:   Wed, 2 Aug 2023 09:25:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [Question] int3 instruction generates a #UD in SEV VM
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-coco@lists.linux.dev
References: <8eb933fd-2cf3-d7a9-32fe-2a1d82eac42a@mail.ustc.edu.cn>
 <ZMfFaF2M6Vrh/QdW@google.com> <4ebb3e20-a043-8ad3-ef6c-f64c2443412c@amd.com>
 <544b7f95-4b34-654d-a57b-3791a6f4fd5f@mail.ustc.edu.cn>
 <ZMpEUVsv5hSmrcH8@iZuf6hx7901barev1c282cZ> <ZMphvF+0H9wHQr5B@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <ZMphvF+0H9wHQr5B@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0190.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::15) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|PH8PR12MB6985:EE_
X-MS-Office365-Filtering-Correlation-Id: 0098d137-256a-4364-bdab-08db93644712
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9qecuz1QgkhFWgzfvYETieEoDVPQ5C22Oz49rm8eAtxl0XhcKxQsNibGtgBi2StTM7zcxQlpk39sZKCp8DJAzFofePSe7WOEgk1NLSBnf2sTO7oqXnxoVTtYUH7jOkBLydsJKxX7euP8eIK6jblj+DUtwyfZ+gn7Pd5xryEQKLSowWvOOmuq9dlIDUetkhEhcaqRkngn8q18kC9rExQuZAvaS47mQTLXXOQXjeWKwzLNc9YuB2pLeENUcMH4DJvX67G80gih70tgkv7QNvkTI+M0zodUJwQf2UzrKlJskvGJYwFdb5kMy8aU+iHdwbSlqEnCDihYc/yjBxjSdnqpHQZkUs8VwE9+O1T/tylnkiVNkKCpGfe8Bv831fJ++iucgJ30Pp5bR/EIF/DNp+ogHDfWcBL/ZRqNnCY6w5edofIyB+s5vXiyxjR6Mjyvx8Y1lqKIdw3tNBN3bGt9BStn0DRVD47zWeKZhoUugADfnX5AcOetQhSqKsYP7iBRryapXKcLp4+2EwLdaPML5O6QlbxxUQfmxQOYOsXaRz510Dej/1pSI46D5ozhw+BsvYO5gqb/J04BuMqjaBX9HS/sG3lwdEf4xnpBkQi5ZfAlTSh08UrMnUsQozewXGlqO6PiM1zMVZA0xykbcDm3P7vRew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(451199021)(8936002)(8676002)(31686004)(5660300002)(316002)(41300700001)(66556008)(4326008)(66946007)(2906002)(66476007)(26005)(6506007)(38100700002)(53546011)(2616005)(110136005)(83380400001)(6512007)(6486002)(86362001)(31696002)(6666004)(36756003)(186003)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXIvOGhQRmZvYktGTlRZNnZKOUxmR0lUd0x6QWV6ZGtLbEc0ZVJTMjBVNnhU?=
 =?utf-8?B?U3FJUnZSbENldjh5N0NuYXJhZFdCZGI4bWQ4Y0lEcnRTUWxUeWExV2paSkcy?=
 =?utf-8?B?dXFSUnhMN0U5aEJ3OGNsaUJYalFweXY1SnliUnp3WXpTSjRaME5nUW1iam1u?=
 =?utf-8?B?cGZTa2dwSXdmNEVUT0l4d2RZYWdYbXZ6RjVsS0FDT2FHNlhON0Z0Rzk0c05L?=
 =?utf-8?B?V1l0MWhEQlNpNm9RVzFxN0pOU0lEOGhGQXdMa2hZcXNPb3Fnc3NORFVEVGhv?=
 =?utf-8?B?V2hvU1pKTzN5MTRoeURLK1Q1VFk5clNzUE9oRWRvYklTaHc3YmgxQVNjY1dn?=
 =?utf-8?B?eGUwaUx6TUdLR0o0Q1hnalRob3QrTXBZTTFPNzRjdXIvWFdnc2NjNlJ1V0x6?=
 =?utf-8?B?Nk9kaW9UeDNLTWErVW1xQ0tnY2Z1RzlJTmZHNUJBV2ZobmNDNWlqVk5aZUlP?=
 =?utf-8?B?dzZjT3FlcWpCenBxVHJGMVBaM0pQSFBFU0VWNXc2VlFZR1pVTGZLYkRNcFAw?=
 =?utf-8?B?YXJNOWJQR2tHNjlmOXA4OHN1d21URXN2cnBGbkJNcU1odFhNWXFHQk9pKzBt?=
 =?utf-8?B?WE9aV2JxTENKNTIwWTdaRndYSkl1aVFwb0kvYlBCOGRvNlpCbUV5alp5UFBx?=
 =?utf-8?B?OXYrMzZ0aG5GYmQxc1kyeVkzUlRRVTl6amVKY1lOMENxckx4SjhOMndvWFF4?=
 =?utf-8?B?dmZaTXRzYUd3VWN5M3hwWkFCSWZjYTVIRE56QjZvQVJUdXgzdkppcmp5WTN6?=
 =?utf-8?B?S0NBLzB4NWF2MC8rYUpKNnVKZVQ0YStHckphUWEwYzRob21NRGdIak0xUjRp?=
 =?utf-8?B?cUtSK0cwdC90ZHlaVlFsVDhaK0w4TnpVd2JIYU9tNUxqV3pERDd1SytjOUtD?=
 =?utf-8?B?eWhaRlBrRXpmakNWWVhrN1VQWG1RLzBwMERncUo5Vk9kcEVXQXJyUXVzSHI3?=
 =?utf-8?B?dXRud055czlnOXlFUjhRN1BGbHdSQUxJMXcySWJxcmh5RG5KN0RBanR2T2ha?=
 =?utf-8?B?WWVjNVNLdE9vVGg4VHBwVHNJVDBpSlJWNWtmdkUyK2tFa3p0UmxzMlpoNDMy?=
 =?utf-8?B?N3NzOFNwQ05KdHAvQXdWMWtTWUZjMDFJdU5BUGwwMyt2Y0tFcUw1cW9mQUdz?=
 =?utf-8?B?cE90aHB0TTBDcm5kdlNOQkh5NkM0Znd1dkFBSFA5aHo3Vlh5ZlZFeWRReUhQ?=
 =?utf-8?B?NU92QW43b3FZNzgrdlV1MW9icWZzbGVnQmtaMlVUNkpHenF3bGozbnlyazg5?=
 =?utf-8?B?YVJ6aVpkU1NZZW9BanluamZlc1c5M3JOODBXak9SckVNVms2UDNmdVhTNUdD?=
 =?utf-8?B?WWlqbmRTb2Z4alNseHViek5VRURQMHhLVEx5MVB3QktkbCt1MElsMDkrdWN5?=
 =?utf-8?B?Q25IeXVXcmZRL1lzeVZiaFd6K1FmaUFVTTZiSHhXRUhjL0JmY0d3cW1RRVBI?=
 =?utf-8?B?dktvcUlTckhRczJSQ3ljaDBYK1oydkFKdFlBL3pFbitra2VZem42UEZab2NY?=
 =?utf-8?B?MW5lbW1nTzc1ZmtBbWJWcXdvVEVpWXVOMUc5RGpEaXkrcVpwY0x5TFRXcTFx?=
 =?utf-8?B?MS8zUm1oV25zcCtlSHVWdGlOdTBDNkVuZlZiUUJ2a1hTdkh0dGVHL2VJR25E?=
 =?utf-8?B?OTBRc0VFVmo2TUJENTcxVUd6SUxlR21OUTRaMGdaSjJFY1BEc0VUTFQxSWxt?=
 =?utf-8?B?UURVVU9QTU1HLzlkWm9YVklxMGZnMXJjWTQyY3FOOW5zMFA5ZTJhUHFmbHlM?=
 =?utf-8?B?ejV3S3AzNmlxbmdiMGo4TjdldzduYktvNUg0Mkw0TUh2Yi9HbklMRXcxamFP?=
 =?utf-8?B?Ty81QXAwSkcxUVBvQ1puZjNMRkFzb0MxRzZ3WDdOdnlMOCtHZ0FrMlhVK1Jy?=
 =?utf-8?B?SS83aFpwTlpTbVJxM3NnYlBmM3NtTTFwWlI5czk1ZDQzVUVxNnBFYmZMT3ZR?=
 =?utf-8?B?d3htbjJjYms3ZUN2dDVIbjlEUk52VG9qUVBrejJxcnBVNjBaU0hkLytja1U5?=
 =?utf-8?B?b0tOMXBjUWc5OWlRb21xUnBDMVF6bXZ3K1NuQlhKcGQwR2l4NWh2YWZvbjdQ?=
 =?utf-8?B?bEhXdVlIdlY4RGVKc0lzd0V3bVBGMDNyL0FqS3VBQ0dTL1BuRmtaMFpRa2x4?=
 =?utf-8?Q?+Px+5bZds3zyqwXfjNEtBKYp9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0098d137-256a-4364-bdab-08db93644712
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2023 14:25:10.2906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4XtU2IuG6o6nJsUNbM7SYcmrxjLx5+J42MjFDRRA/13fbUNwc3qpVfijPDKnJQ35doNLv2S229bGIP2Ij9fBUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6985
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/2/23 09:01, Sean Christopherson wrote:
> On Wed, Aug 02, 2023, Wu Zongyo wrote:
>> On Mon, Jul 31, 2023 at 11:45:29PM +0800, wuzongyong wrote:
>>>
>>> On 2023/7/31 23:03, Tom Lendacky wrote:
>>>> On 7/31/23 09:30, Sean Christopherson wrote:
>>>>> On Sat, Jul 29, 2023, wuzongyong wrote:
>>>>>> Hi,
>>>>>> I am writing a firmware in Rust to support SEV based on project td-shim[1].
>>>>>> But when I create a SEV VM (just SEV, no SEV-ES and no SEV-SNP) with the firmware,
>>>>>> the linux kernel crashed because the int3 instruction in int3_selftest() cause a
>>>>>> #UD.
>>>>>
>>>>> ...
>>>>>
>>>>>> BTW, if a create a normal VM without SEV by qemu & OVMF, the int3 instruction always generates a
>>>>>> #BP.
>>>>>> So I am confused now about the behaviour of int3 instruction, could anyone help to explain the behaviour?
>>>>>> Any suggestion is appreciated!
>>>>>
>>>>> Have you tried my suggestions from the other thread[*]?
>>> Firstly, I'm sorry for sending muliple mails with the same content. I thought the mails I sent previously
>>> didn't be sent successfully.
>>> And let's talk the problem here.
>>>>>
>>>>>     : > > I'm curious how this happend. I cannot find any condition that would
>>>>>     : > > cause the int3 instruction generate a #UD according to the AMD's spec.
>>>>>     :
>>>>>     : One possibility is that the value from memory that gets executed diverges from the
>>>>>     : value that is read out be the #UD handler, e.g. due to patching (doesn't seem to
>>>>>     : be the case in this test), stale cache/tlb entries, etc.
>>>>>     :
>>>>>     : > > BTW, it worked nomarlly with qemu and ovmf.
>>>>>     : >
>>>>>     : > Does this happen every time you boot the guest with your firmware? What
>>>>>     : > processor are you running on?
>>>>>     :
>>> Yes, every time.
>>> The processor I used is EPYC 7T83.
>>>>>     : And have you ruled out KVM as the culprit?  I.e. verified that KVM is NOT injecting
>>>>>     : a #UD.  That obviously shouldn't happen, but it should be easy to check via KVM
>>>>>     : tracepoints.
>>>>
>>>> I have a feeling that KVM is injecting the #UD, but it will take instrumenting KVM to see which path the #UD is being injected from.
>>>>
>>>> Wu Zongyo, can you add some instrumentation to figure that out if the trace points towards KVM injecting the #UD?
>>> Ok, I will try to do that.
>> You're right. The #UD is injected by KVM.
>>
>> The path I found is:
>>      svm_vcpu_run
>>          svm_complete_interrupts
>> 	    kvm_requeue_exception // vector = 3
>> 	        kvm_make_request
>>
>>      vcpu_enter_guest
>>          kvm_check_and_inject_events
>> 	    svm_inject_exception
>> 	        svm_update_soft_interrupt_rip
>> 		    __svm_skip_emulated_instruction
>> 		        x86_emulate_instruction
>> 			    svm_can_emulate_instruction
>> 			        kvm_queue_exception(vcpu, UD_VECTOR)
>>
>> Does this mean a #PF intercept occur when the guest try to deliver a
>> #BP through the IDT? But why?
> 
> I doubt it's a #PF.  A #NPF is much more likely, though it could be something
> else entirely, but I'm pretty sure that would require bugs in both the host and
> guest.
> 
> What is the last exit recorded by trace_kvm_exit() before the #UD is injected?

I'm guessing it was a #NPF, too. Could it be related to the changes that
went in around svm_update_soft_interrupt_rip()?

6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")

Before this the !nrips check would prevent the call into
svm_skip_emulated_instruction(). But now, there is a call to:

   svm_update_soft_interrupt_rip()
     __svm_skip_emulated_instruction()
       kvm_emulate_instruction()
         x86_emulate_instruction() (passed a NULL insn pointer)
           kvm_can_emulate_insn() (passed a NULL insn pointer)
             svm_can_emulate_instruction() (passed NULL insn pointer)

Because it is an SEV guest, it ends up in the "if (unlikely(!insn))" path
and injects the #UD.

Thanks,
Tom

