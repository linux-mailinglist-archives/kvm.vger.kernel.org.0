Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C863476D01C
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 16:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbjHBOeF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 10:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbjHBOeB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 10:34:01 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2058.outbound.protection.outlook.com [40.107.243.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B2026AB;
        Wed,  2 Aug 2023 07:33:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qj2zb3DCoyr8RwfLxveSgfepxpP9i+EAsD8skK0P8uz0SX5XGy08glp4Mx1fdi4hv/HQlZcmiyxl2zEHVZ2LLWq2+nvrg9T0j8zZzB/5sZNvvl52KdwEuOinTK23/Il7Ys08aLY2fys0tfexUQtcM9agQs6jueKJQ1UeUoL6FA+71m8OnOGQ97mFXcxT46FLcdYUJ7F5VIvMXnHiIswl/iGQwh9rrtfIhI/bEmI5t0Y97P39flR++9MA2v0OjidxRF5dxYTcQFKqMp1Bq2PE8YQyK9U7hZLkLeR0k9A+eeXBImu+w7B1x4X7R91rUJYaiNnX9uws/88YhckfQPPIPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xqovJJYi8NVTJSnJKZDN2jHeuVGt6tTOArMyYovX8Is=;
 b=PqVIm2/pkm5Wlq8mBl4UBTvgYj9/134lGR/VYEzi1dEtViLijjdHWtuzLjwnQFYlTXrsduXI1upXBF9ncZHR3MBiv2+W11LwVbzeJiq5WvYjjZGQNRxtps86yr/A6FWo9asHeR2TRVMvHqhmkoxrdOxxUPqLU6/evVDaf0EdF592ydGD/cNY0jt6a/8hFygSHm+ojT9PdE62zfDUYbkPagGfc6MpQ9/3VU1fAlckFynaTDU4SXwcDUpA/OSY/0q/JMxK2ND7g7Ldzxi1Z1eRt6JaOzdcQJIMHibq84uRw4GIizrhUSvjpMjV5gkLykogg9kESd4BdKe0OvYIGEud9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xqovJJYi8NVTJSnJKZDN2jHeuVGt6tTOArMyYovX8Is=;
 b=4yzYk/y5R6GZLdbX6YLj7vSKJ/bgX+Qay+Zd+hUy/v3DYrJoUZ1P7hjFKxS5DLER8C2lwyGgkzlAPozXM4xdX12asQ4qrv3Nz7c7SprZ39p2SSApnSrDBcUi+yoGWRI5PLtlR4GlAxtc76kkNTtVynNkUAZh6yOLyMqspd/+Qmo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by BL0PR12MB4948.namprd12.prod.outlook.com (2603:10b6:208:1cc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.19; Wed, 2 Aug
 2023 14:33:48 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6631.045; Wed, 2 Aug 2023
 14:33:48 +0000
Message-ID: <7a4f3f59-1482-49c4-92b2-aa621e9b06b3@amd.com>
Date:   Wed, 2 Aug 2023 09:33:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [Question] int3 instruction generates a #UD in SEV VM
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     Sean Christopherson <seanjc@google.com>,
        Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-coco@lists.linux.dev
References: <8eb933fd-2cf3-d7a9-32fe-2a1d82eac42a@mail.ustc.edu.cn>
 <ZMfFaF2M6Vrh/QdW@google.com> <4ebb3e20-a043-8ad3-ef6c-f64c2443412c@amd.com>
 <544b7f95-4b34-654d-a57b-3791a6f4fd5f@mail.ustc.edu.cn>
 <ZMpEUVsv5hSmrcH8@iZuf6hx7901barev1c282cZ> <ZMphvF+0H9wHQr5B@google.com>
 <bbc52f40-2661-3fa2-8e09-bec772728812@amd.com>
In-Reply-To: <bbc52f40-2661-3fa2-8e09-bec772728812@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0209.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::34) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|BL0PR12MB4948:EE_
X-MS-Office365-Filtering-Correlation-Id: 83ee8c97-8af6-4002-0c68-08db93657be2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V4an16wyP+kDtMK3xV4NMW1VBAyfrRk3TjLhVeXOgTIxTYSScEn5U039rUodnKsENhk0ObBLyjycrqVrlhY0cbO44Kzy2UejKU1XVfrhHYziIRBVLk0M/8IBqyj24tEcdkZdmnvNQfQpXe5rWjqKMiP5KO2uDjS3V2EpvzbRDBQClH8KkZ54TUlqddTGO9xpg0BMWNXGUbRjfZ8B7DnHALY1fNB0hDnGXe1hWuRoqTKpuLp5xY0HXfm/WYRrjjjVmuF4L0P3Qlius/z63UhEbA9ASR//BzjXYb7gKE/omhxZSTrjsbvBAT3aeWhMnJV00EhXVhT8oGpOnU7J9XhK0EZJgKbaW5L3KKVfcjdaQBuoGL2ala7+lipS0OIkKmq4OJVF+FSTNd8RCJO/nWkt2LpzaFF1eavUiP3GRcbQtbxzZekTgvvQIxomealMIcJoCayFR6+V+M17wDpwZVmFMgtY7/NEYmSE1SAK0/hUT6J9ZPFJhqqyH3fD3aP3h+nvm1hTEfhkR6+irLz76VVxjadcBYwbZg0r6fMre9GgW6vDR7bWk4CYPH8dG3fawDCeZWShZqji7V5mUlVR3MlRKU/AgooJghaahY7uxR0131udqX95wTBFCj+H7lAELKwpuenJlSg77FjMnDgGwhbkJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(451199021)(478600001)(86362001)(31696002)(6512007)(36756003)(6486002)(316002)(8676002)(8936002)(41300700001)(5660300002)(31686004)(4326008)(66556008)(66476007)(83380400001)(110136005)(2906002)(38100700002)(66946007)(26005)(2616005)(186003)(6506007)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dTJOc2tBbGZsckpIeXZUNVR5Q0RkR2xwZ1gxdy9JaHBtTlRKVHlUcnd6M2dU?=
 =?utf-8?B?ZWl5ZVVsNzAwaElBTmhoVTE2ai9DRWRQekdWZnBpODUxYTBEK3V2VmVIamxx?=
 =?utf-8?B?WERRNWR1UDFiLy8wM1VCMGZyM3hERUVpMmFQamlKQ0k5dDA2NnRkODFxcllm?=
 =?utf-8?B?QXlNZkhJYTQ1cEZjQXlCTmY4OG1uRWJDM0FENTZpOXo5L0Nnb0Vmb1BvcHBq?=
 =?utf-8?B?d1BFY1VkS2dlUzNpREQxVjQxTks2c0pKNVBFV0t3ek9kZkFvT0RQVUlCRDJO?=
 =?utf-8?B?d2tJUit3RXZDc0g0SWlTei9wQVA0T2xUSlI3L1dyaEJCZXpiNVBPeis4bTc5?=
 =?utf-8?B?TmNlVm1HdThKV0xZQ0p5WjVnVEZCOWdFQ0F4bzBzK0JXTTBoTkQrNy9xb3dL?=
 =?utf-8?B?dWpiN2tlcjh2NldvRWFQSTU4SjFSYVhMeG80ZUs3c0x0UmJ4dkVYVUkzQnFx?=
 =?utf-8?B?SHgwdW80Y3Y1M0c2cTZRWGJmUkx1eDRjV0pGcE9oNTRJVHNyMGszV2JMRDBa?=
 =?utf-8?B?c0Yzd29UNXVuZzdQTkpBUEVyVTNoQkNQQlRjS0hUQVkrM241UjdCN3I1cGtK?=
 =?utf-8?B?RVpzRVdUdk13elRHVmNzUTRseHduN2hhWmtyZFRHYWJNMWp0SzI5Nkh5Rk85?=
 =?utf-8?B?TTB0OWtkQy9xRUptcWdwcTBJNmh4dVlhY2FlWU45UThpdkFMbHVrU1dvemRN?=
 =?utf-8?B?cU5UQnlYdm1OR0w1b09zS0RsRld6dDN6dTBWZnJZUTRoVm5VTXJpVENLa0ln?=
 =?utf-8?B?Yk1QS2g4R0psMVR5ZlpOaGFQWWpzWEViRlhNMktGdFZFVHppbXg4VTExcG4w?=
 =?utf-8?B?ZllUUS9UU21PZWdUaWdIcVh6MERQQ2pTdzAwaExMaklxTnIrbk5icEdHelV4?=
 =?utf-8?B?MXVBNFVjRTJPbGR0TStYRzl0eCs2Mm9TT1R0dzcrUzMwVzg0YXlhWnRNcUdV?=
 =?utf-8?B?aXkwVWN4S2dDNCtEQ1BIUUNjNEZiNEJmVUhtSmZUdmhyMkNHY25BMlZ1YVNU?=
 =?utf-8?B?cXpuODBhRXFyMDJXQjJ5UndJbHo5dklId2oyQWFXc3VxYURkZllncHpPcVRX?=
 =?utf-8?B?bkZOaytUdVpUNHlnaWFiVW1uUDQ4V0h0RUpBM3hQS0s3ZHRLUXlRcmxFbVA2?=
 =?utf-8?B?VnlWRDVyR2pBYklzeFZoMFRLdmpoZTR1OFp2eWZmeng3R3hPV25IWGZyZTl2?=
 =?utf-8?B?K3JtTHUyeDY0NnQ4UG93VVFIeHRNOGJhM29aN1dzTlViemlBem5GWUhtMFJR?=
 =?utf-8?B?Q05uYXdWNjVMWTlaVjBBZGVoQW9paUF0L2wyN3ZSZjBZOEd1bUx6T1JCWWVy?=
 =?utf-8?B?c1hTY0dGTjRtdGlWNDh2V1B3b0U3Q1BNamNnR01ab0pHdWJaUFNxNXJqYjZh?=
 =?utf-8?B?bmRpYzhmTE83eDhGczhFZXZzdGJKOGwrc3NsTC9QeVljcENac0kxZnUyOFVr?=
 =?utf-8?B?QTYyZlJLaXEzdWJiUmJKNkZMY3VyUlQrak92VUhLbnNMbFBicHg4L2RwN09E?=
 =?utf-8?B?TW9iK05ybmZrakdmdlVXOStmZnYvZ1dJNG1Ob0Nic2MzM3lDaWc5NU42cUtC?=
 =?utf-8?B?QmxpcEZHTW9zYWpFeFBCR3FqVUo5MitKRTg2amcya1lJanRabXp3N1RzTjVD?=
 =?utf-8?B?NytlWnkyUEFHam40VXZFdFRRN3d0UnFjcXA4bUdNSFlDWWliblhTcnREc1Vn?=
 =?utf-8?B?WXBlYWRSRHJXbWVZdFREMVVhMEd2TUVOb2FnTktwaFJMb1p2ckpNaVBlZm4w?=
 =?utf-8?B?S3NJVjVDWFMzTEZCTHRwQUlGNmFISk45NWdFbzlQb3FhdnhyRmxGVWRPUUI2?=
 =?utf-8?B?cnQxMXUvVTFZMTRMcE1rR1JVb05hbDNFYiszNkVEU1RnNUpjWkY1Nnl4R1BD?=
 =?utf-8?B?dXNnT0xOZFYyT0ltcGg2ai9ucVZ1OUh2MEtkQ04waGptejd1eXN4NWRvd2sw?=
 =?utf-8?B?ZUpyNUpUTjM4ZVhjYjVBejNtZXVkcXZ5Zi95ZU1uL0hUU3ZUOE9rcUlWcnFB?=
 =?utf-8?B?TmQ4UG5zV245RG04Yk1WZWY2eTltRWF3NXh3QmVzQXd3SVpYZmExSXBmNzJW?=
 =?utf-8?B?NGNiQ1NsTW1LWW1URk9IZHh1ZnRqNmF2RVNWV0NjdFlaVWRuWCtRYVllZDEy?=
 =?utf-8?Q?NA6e6yFNM4jD864usbtD35Qxj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83ee8c97-8af6-4002-0c68-08db93657be2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2023 14:33:48.3417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e9phiBHPDw9AxhW8P2DYWShIqVvtnBNNpMPa64iykcVsGqCe2lYfNbnDcQUyo/XHxsJ1F5ZKnXg2drmztoHE2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4948
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

On 8/2/23 09:25, Tom Lendacky wrote:
> On 8/2/23 09:01, Sean Christopherson wrote:
>> On Wed, Aug 02, 2023, Wu Zongyo wrote:
>>> On Mon, Jul 31, 2023 at 11:45:29PM +0800, wuzongyong wrote:
>>>>
>>>> On 2023/7/31 23:03, Tom Lendacky wrote:
>>>>> On 7/31/23 09:30, Sean Christopherson wrote:
>>>>>> On Sat, Jul 29, 2023, wuzongyong wrote:
>>>>>>> Hi,
>>>>>>> I am writing a firmware in Rust to support SEV based on project 
>>>>>>> td-shim[1].
>>>>>>> But when I create a SEV VM (just SEV, no SEV-ES and no SEV-SNP) 
>>>>>>> with the firmware,
>>>>>>> the linux kernel crashed because the int3 instruction in 
>>>>>>> int3_selftest() cause a
>>>>>>> #UD.
>>>>>>
>>>>>> ...
>>>>>>
>>>>>>> BTW, if a create a normal VM without SEV by qemu & OVMF, the int3 
>>>>>>> instruction always generates a
>>>>>>> #BP.
>>>>>>> So I am confused now about the behaviour of int3 instruction, could 
>>>>>>> anyone help to explain the behaviour?
>>>>>>> Any suggestion is appreciated!
>>>>>>
>>>>>> Have you tried my suggestions from the other thread[*]?
>>>> Firstly, I'm sorry for sending muliple mails with the same content. I 
>>>> thought the mails I sent previously
>>>> didn't be sent successfully.
>>>> And let's talk the problem here.
>>>>>>
>>>>>>     : > > I'm curious how this happend. I cannot find any condition 
>>>>>> that would
>>>>>>     : > > cause the int3 instruction generate a #UD according to the 
>>>>>> AMD's spec.
>>>>>>     :
>>>>>>     : One possibility is that the value from memory that gets 
>>>>>> executed diverges from the
>>>>>>     : value that is read out be the #UD handler, e.g. due to 
>>>>>> patching (doesn't seem to
>>>>>>     : be the case in this test), stale cache/tlb entries, etc.
>>>>>>     :
>>>>>>     : > > BTW, it worked nomarlly with qemu and ovmf.
>>>>>>     : >
>>>>>>     : > Does this happen every time you boot the guest with your 
>>>>>> firmware? What
>>>>>>     : > processor are you running on?
>>>>>>     :
>>>> Yes, every time.
>>>> The processor I used is EPYC 7T83.
>>>>>>     : And have you ruled out KVM as the culprit?  I.e. verified that 
>>>>>> KVM is NOT injecting
>>>>>>     : a #UD.  That obviously shouldn't happen, but it should be easy 
>>>>>> to check via KVM
>>>>>>     : tracepoints.
>>>>>
>>>>> I have a feeling that KVM is injecting the #UD, but it will take 
>>>>> instrumenting KVM to see which path the #UD is being injected from.
>>>>>
>>>>> Wu Zongyo, can you add some instrumentation to figure that out if the 
>>>>> trace points towards KVM injecting the #UD?
>>>> Ok, I will try to do that.
>>> You're right. The #UD is injected by KVM.
>>>
>>> The path I found is:
>>>      svm_vcpu_run
>>>          svm_complete_interrupts
>>>         kvm_requeue_exception // vector = 3
>>>             kvm_make_request
>>>
>>>      vcpu_enter_guest
>>>          kvm_check_and_inject_events
>>>         svm_inject_exception
>>>             svm_update_soft_interrupt_rip
>>>             __svm_skip_emulated_instruction
>>>                 x86_emulate_instruction
>>>                 svm_can_emulate_instruction
>>>                     kvm_queue_exception(vcpu, UD_VECTOR)
>>>
>>> Does this mean a #PF intercept occur when the guest try to deliver a
>>> #BP through the IDT? But why?
>>
>> I doubt it's a #PF.  A #NPF is much more likely, though it could be 
>> something
>> else entirely, but I'm pretty sure that would require bugs in both the 
>> host and
>> guest.
>>
>> What is the last exit recorded by trace_kvm_exit() before the #UD is 
>> injected?
> 
> I'm guessing it was a #NPF, too. Could it be related to the changes that
> went in around svm_update_soft_interrupt_rip()?
> 
> 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the 
> instruction")

Sorry, that should have been:

7e5b5ef8dca3 ("KVM: SVM: Re-inject INTn instead of retrying the insn on "failure"")

> 
> Before this the !nrips check would prevent the call into
> svm_skip_emulated_instruction(). But now, there is a call to:
> 
>    svm_update_soft_interrupt_rip()
>      __svm_skip_emulated_instruction()
>        kvm_emulate_instruction()
>          x86_emulate_instruction() (passed a NULL insn pointer)
>            kvm_can_emulate_insn() (passed a NULL insn pointer)
>              svm_can_emulate_instruction() (passed NULL insn pointer)
> 
> Because it is an SEV guest, it ends up in the "if (unlikely(!insn))" path
> and injects the #UD.
> 
> Thanks,
> Tom
> 
