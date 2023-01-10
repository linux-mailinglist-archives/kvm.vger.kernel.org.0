Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47096663B83
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 09:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237855AbjAJInS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 03:43:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238179AbjAJImj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 03:42:39 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2102.outbound.protection.outlook.com [40.107.100.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3624C53713
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 00:42:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZT6sViLryM7P3/ypQLH0jxNT8Uw8Sg3Kaetl/iI/CzjoRqz9+JeHg9x3AVgjgaAGYyPtcHQB8o0tZq7hgQaYpzZwumrySbkkSLAKBoZn02DwG0XueVxrql9km7XhuoRc0FOHwhEXK6rzo77SsdUyPl+1PuWVkky5p6E6nzf1dkAWSJpyAlInz6q5jDsCarH0E+1eYE/jH3M+bH2qL5orbQoqnkCwgN8rMrTcY6nrxZeWtWURZ2J3CazbPfBxetED9yinr9J26ZEuJvS8oLW9nMwRzIOmpQ/0DeNckZZBlvHeO/mgY4jZ+ywKC2tRrfsYBZYq174HK7A2lf3qWDi+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KJjH83iEa3FH018gwlzfrqr9CmeyrAAQ643oEjWmuWY=;
 b=WweHv2mIkfZRvHcvHxfD6S45MqLDjhOa6YBt6oy5fcLhw9GmwOOoTjDNdM+uLoAhNfurprYq+UFwfndw3DvQHernaNJdU+ndrX85k3D+lzRYO4WuDszt8jN+Y78E+fmHUjkNc7BLFO27lzI0uIzaozVKuQpj1BZDpG2WHOBQucnA4MylaZu2+djVCbgubHPafgTs3r84VxsB559xzaiNWtXh8g7geTxOBacfILiXXLgNta7CM58XZ3MYOd3SjRr/aNX63buxoCKwkUetDqyKg/QTP4hgKa/WW1OlSmMnx8xl+H+2l6Kvk+wKfucaizS7pasQt69Bqcw8txoTH/BcGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJjH83iEa3FH018gwlzfrqr9CmeyrAAQ643oEjWmuWY=;
 b=f2CJmYbnyuOTkh21zDNdqAQhj1glw6SA6YJqdzXS8rvWTvPYyVBgxhuUn/SKa8NzYflHK0n0DELjyxvDSK2/de16mpitHb71FHnNGSl9FvtN1+SeSyxRvLJV5br94i0Y/Sl+aDnoJ6oQ4q33pAH4r2W3UfT/Sxw9jbyO29HLoIw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 MW2PR0102MB3340.prod.exchangelabs.com (2603:10b6:302:c::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Tue, 10 Jan 2023 08:41:59 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::6b5b:1242:818c:e70d]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::6b5b:1242:818c:e70d%6]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 08:41:59 +0000
Message-ID: <31e49612-443b-888a-9730-f4e017251130@os.amperecomputing.com>
Date:   Tue, 10 Jan 2023 14:11:44 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 2/3] KVM: arm64: nv: Emulate ISTATUS when emulated timers
 are fired.
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, scott@os.amperecomputing.com,
        keyur@os.amperecomputing.com
References: <20220824060304.21128-1-gankulkarni@os.amperecomputing.com>
 <20220824060304.21128-3-gankulkarni@os.amperecomputing.com>
 <87y1qqe2pg.wl-maz@kernel.org> <867cy5b1mq.wl-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <867cy5b1mq.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0201.apcprd06.prod.outlook.com (2603:1096:4:1::33)
 To DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|MW2PR0102MB3340:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d710224-0a1b-45ad-25c7-08daf2e6899a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PVZrRXVBzdEwDTVaLlOSsdJWXgjzoYF8LYpVavwuryGh84zY/ZuTUlTd9BMWhkLwTfC+042bQS4XtCpfu1h7CRkU2x62Yt9mcfaN6OycD8dCJuNmNTRhzioQpBtUQydBU42ZEyMu12ib/ntR5nodzU0mlTUAAyYOn/D+24TaWO079TGFY1j0PT8/2sslTo1c5rEZl1ueCxrtQwKtYppQQVOhkFkX5iYgA5FHp51ZsfNUXMCzvcJobLSyq7ZMj+Y2xVS9tBrR9fD9dFxi26s5S5IXk1Nmh83lIAziHld3leHPLPAn0i+iRtCpZ/IBT1bo/57g6bvsqUqRDByJ+TAEPvq3LmMZ4RGCi2GU9Ta7Ip2EWyesj3JNrloCDJ9zLJjha/1NSccMOsT23dvQj1UAuDukL3G6UtzxnEEGJ7y/Bj0f/PG+uExJ4MPSnQKjUbDg79uoMFt3cV4uWDDvqbk92Q9HwU2ejiib6WpR8EaNGGbMtLIN0hDAVSCNoM5s4TrmMqoudlk4c/c/tPsFYeRAnuslmplBGIr4oQc/G/2wKmnIlelzgZdkcK1d/FPKBWizGlg94R7wVvEBveJZ1e6Dr8Y1gXA6BhKpZ1SR0XVZlVau48d9uL76fOTMfYKUkZRmbUtdZSrOpxJV4K2WG6t3GdZgdQU2k7wgXAitra2vp3GGDaIX/lv5LXXWLUg7OFHx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39850400004)(136003)(346002)(376002)(451199015)(478600001)(53546011)(2906002)(6506007)(6512007)(26005)(6666004)(107886003)(31686004)(6486002)(186003)(41300700001)(2616005)(316002)(66556008)(66476007)(6916009)(66946007)(8676002)(4326008)(38100700002)(5660300002)(83380400001)(8936002)(86362001)(31696002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHM1Zm5EaGZITjk2SFdIMzhIN0MrWmwyNmkvYmtqdkhQa2ZWRlM3OXNpcFkr?=
 =?utf-8?B?VnhTSGxGQzdxYWRsa2NHSzc3cTYySjB6ZTFEUG9mUkdvbHBaUVZ6Z25NVEZL?=
 =?utf-8?B?bENyWXI1d3BWTUVESDdhOFpOc3BWeUdaMGZDc2k0ZDc5VXZoUmxqQU9MaEU2?=
 =?utf-8?B?UGZkQ1hDVlp6TEQvdCt1dUNpOURpbzhKcW44SSs1dlNlLytGUlY5TkJRaDV3?=
 =?utf-8?B?OFJoOUU5bmhIdjVBL3pyZEhPTmxBYkhkdGo2eWtIYk5pNDRVdC8xUXNaSk9r?=
 =?utf-8?B?NWhqUTU4c0ZCY0dTRUZzaUJhZURlUVNpMTMwZkZ2RlJ6SG05dXV5SnRsay9x?=
 =?utf-8?B?ZmJtVzdMbzViMkJiblJpNnN6d1ZCZlhpT1dmWVdFNjJQdDJGaUVjYmxaMER6?=
 =?utf-8?B?UFh1aG82dEtOUnd3TVlMMGRpTGxLUWJGTjBRd1VxZjY1NDhralpMOWZPVzQ0?=
 =?utf-8?B?N1g3dGhVbnVaVlpDUDlDKzF3cU9UWlVnUlRVZm1lVGFnUUtGOHhCS2htMG5a?=
 =?utf-8?B?K2p3SnhYZGZlMzRpclprbmRZbzVJbklYQ053RGt0TmROTkF1ZVpuR2Rjc1ZD?=
 =?utf-8?B?Mjk0VFAvSVFhYkd3Z1hGM3NoN200OVJWcW1hYmZWQkNhbUVXYys5VUsvcmhi?=
 =?utf-8?B?RzkxYXJQb1JxdWc3ZVVKS1p0aTVDMkF3Ym4zbHd4OXpYLzZWS0JNUTlSdjV1?=
 =?utf-8?B?U3ZRZjEwZG05VVVyUjJIdXNWQkY1S3JZUGxIa3dkazJlNFlwdGxkNGV5MlE3?=
 =?utf-8?B?NUlOM3Z4aG05aWVRdFVkOEJGNTVkZnZGTnNnU1U4c3k3cEFScTVobEt1Q1dv?=
 =?utf-8?B?MnIrR3FLKzg2dmJqYUpBWlZhdzByeVJFMTNyanRGVTlWWlFUdHN0NXQ4WjJO?=
 =?utf-8?B?L2FQNDFiR1NFa0RON3B3TWh5STYyR1RNaXFNQk5PVzlDVXVvaWhBbjlQV1NJ?=
 =?utf-8?B?VXV1cE9ST0pJbnZjTmNrVnBDOE4yOXhhSTJMQjhwK1pxMFFWdVB3bTdubDA0?=
 =?utf-8?B?d1lSSi9ObCsrRE1EcVBPajUyTklzcjZPWkpwM3Ruc2pNQU5iOEZwMEJzbkNy?=
 =?utf-8?B?RWxWR0syNUFQVFBUWFBjWVY5SytXem53ZWQxWDVEU2VlVTZ2Tzh0em9hbVVR?=
 =?utf-8?B?NWdJWTlrRklON0ppbVl1QnpWVTBQR1JYRk0vMno4Q2M2anpoQlJEL1ZNNHU4?=
 =?utf-8?B?RWVSQlB6cyt0VDQyaWNpQjdaRzhsdlY3T3g4djliNlBncnI5S1JlZWlCaVdu?=
 =?utf-8?B?M3V6Q2tnS0FFUXA1M0llZFB1K05GSHJha25mTUNkcDFqckR6cE1wNFZDY0tX?=
 =?utf-8?B?T3BHMEhWV29ia3NBN2dlS3Q5QWV6YUplRFpXbk5qbCtrU1FnLytxNDVud3Vy?=
 =?utf-8?B?RThYNDlOWFlESXVnNUJvbEx5aHo5d0Fycnp1M2g3T3hycUY3bVJaZ1FXV0Jk?=
 =?utf-8?B?WVZZNFhwZjRnTWM2ZVVnWFg1QmxxamxKVG5PMTNnMk9uZVRoOGlQZ3Y3eG5r?=
 =?utf-8?B?QTRNTFJiNHNxUGVEa21qbXJxck8wQS9COGZhcjZMdWJXSHVhc2pCL29OMmJN?=
 =?utf-8?B?bXZiZzZSa2NQZ3B4WUIxYmVxV0orVXpiTTc0dW9JQ0plc3VISmpkRU93V3Nr?=
 =?utf-8?B?ZDFBOGpEYmF1KytIci9PeGljY1c5LytvUklDQVFLMytqaGZKWjQ1QWxyZ1Zp?=
 =?utf-8?B?bGozSnB1bWZtaUhEc1U0ZG4vbnpIRU1ScmFLVWFhVExDbjVTd2xrSDZKM0E3?=
 =?utf-8?B?TFlvTGJTakhVWGtWb0lSSU5DOEQyMjQwMnJmbGZGWTRHR004QlVlYStZOS9x?=
 =?utf-8?B?OE1VTS9XWVRzTGNtbUJYK3c5VUNSRXdSdWY2TzFFcUZNWUZITS9Ba2FoVG1T?=
 =?utf-8?B?WTNVWXJpWDJ4d3BJbFRUWGFDUFJuREhiSG9McTNtY0kvcWd6dW9xZXVYcllM?=
 =?utf-8?B?OGtLSE1vWGR5dldpNjdzZk5uYm9oTW0yQmNjc1dDdW1Md3hPNFNZazhwTEh3?=
 =?utf-8?B?YUM5N3JoWEk1Q08wYithODFLZlQ4UkdIZTFvMXVLMmNLTmc2ZnRDOCsvNjNl?=
 =?utf-8?B?OXdkY0QzbFUvZVcxY0dRQzEzVGxFOFJmdU1xNGoyUUV3NWdnK2lRR2tLcEk4?=
 =?utf-8?B?dWtiVG14Mk1lY1Nzclc5Y1dSVlpHSDZqRjFJaGIzSFB1dEJ3eEViSXg0VVow?=
 =?utf-8?Q?68iDoUQA44EvZV04hAP+6TEFlKfTsKpPrArl/3eIBQ6k?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d710224-0a1b-45ad-25c7-08daf2e6899a
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 08:41:59.5232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 20OSQOTTM4Z3DCivTbixE98YETgYu8sfRmInPGHkp8bPdBre+UyJ/PeGcN1I9LK24qizgSSOSCeQJHQwG9Nj0h/KkUCChDN1HcrI1CbTtRBtdqNEXDfag+fHiJUpe6j/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR0102MB3340
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 02-01-2023 05:16 pm, Marc Zyngier wrote:
> On Thu, 29 Dec 2022 13:53:15 +0000,
> Marc Zyngier <maz@kernel.org> wrote:
>>
>> On Wed, 24 Aug 2022 07:03:03 +0100,
>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>
>>> Guest-Hypervisor forwards the timer interrupt to Guest-Guest, if it is
>>> enabled, unmasked and ISTATUS bit of register CNTV_CTL_EL0 is set for a
>>> loaded timer.
>>>
>>> For NV2 implementation, the Host-Hypervisor is not emulating the ISTATUS
>>> bit while forwarding the Emulated Vtimer Interrupt to Guest-Hypervisor.
>>> This results in the drop of interrupt from Guest-Hypervisor, where as
>>> Host Hypervisor marked it as an active interrupt and expecting Guest-Guest
>>> to consume and acknowledge. Due to this, some of the Guest-Guest vCPUs
>>> are stuck in Idle thread and rcu soft lockups are seen.
>>>
>>> This issue is not seen with NV1 case since the register CNTV_CTL_EL0 read
>>> trap handler is emulating the ISTATUS bit.
>>>
>>> Adding code to set/emulate the ISTATUS when the emulated timers are fired.
>>>
>>> Signed-off-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
>>> ---
>>>   arch/arm64/kvm/arch_timer.c | 5 +++++
>>>   1 file changed, 5 insertions(+)
>>>
>>> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
>>> index 27a6ec46803a..0b32d943d2d5 100644
>>> --- a/arch/arm64/kvm/arch_timer.c
>>> +++ b/arch/arm64/kvm/arch_timer.c
>>> @@ -63,6 +63,7 @@ static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
>>>   			      struct arch_timer_context *timer,
>>>   			      enum kvm_arch_timer_regs treg);
>>>   static bool kvm_arch_timer_get_input_level(int vintid);
>>> +static u64 read_timer_ctl(struct arch_timer_context *timer);
>>>   
>>>   static struct irq_ops arch_timer_irq_ops = {
>>>   	.get_input_level = kvm_arch_timer_get_input_level,
>>> @@ -356,6 +357,8 @@ static enum hrtimer_restart kvm_hrtimer_expire(struct hrtimer *hrt)
>>>   		return HRTIMER_RESTART;
>>>   	}
>>>   
>>> +	/* Timer emulated, emulate ISTATUS also */
>>> +	timer_set_ctl(ctx, read_timer_ctl(ctx));
>>
>> Why should we do that for non-NV2 configurations?
>>
>>>   	kvm_timer_update_irq(vcpu, true, ctx);
>>>   	return HRTIMER_NORESTART;
>>>   }
>>> @@ -458,6 +461,8 @@ static void timer_emulate(struct arch_timer_context *ctx)
>>>   	trace_kvm_timer_emulate(ctx, should_fire);
>>>   
>>>   	if (should_fire != ctx->irq.level) {
>>> +		/* Timer emulated, emulate ISTATUS also */
>>> +		timer_set_ctl(ctx, read_timer_ctl(ctx));
>>>   		kvm_timer_update_irq(ctx->vcpu, should_fire, ctx);
>>>   		return;
>>>   	}
>>
>> I'm not overly keen on this. Yes, we can set the status bit there. But
>> conversely, the bit will not get cleared when the guest reprograms the
>> timer, and will take a full exit/entry cycle for it to appear.
>>
>> Ergo, the architecture is buggy as memory (the VNCR page) cannot be
>> used to emulate something as dynamic as a timer.
>>
>> It is only with FEAT_ECV that we can solve this correctly by trapping
>> the counter/timer accesses and emulate them for the guest hypervisor.
>> I'd rather we add support for that, as I expect all the FEAT_NV2
>> implementations to have it (and hopefully FEAT_FGT as well).
> 
> So I went ahead and implemented some very basic FEAT_ECV support to
> correctly emulate the timers (trapping the CTL/CVAL accesses).
> 
> Performance dropped like a rock (~30% extra overhead) for L2
> exit-heavy workloads that are terminated in userspace, such as virtio.
> For those workloads, vcpu_{load,put}() in L1 now generate extra traps,
> as we save/restore the timer context, and this is enough to make
> things visibly slower, even on a pretty fast machine.
> 
> I managed to get *some* performance back by satisfying CTL/CVAL reads
> very early on the exit path (a pretty common theme with NV). Which
> means we end-up needing something like what you have -- only a bit
> more complete. I came up with the following:

Yes it is more appropriate, this moves ISTATUS update to single place.
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 4945c5b96f05..a198a6211e2a 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -450,6 +450,25 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>   {
>   	int ret;
>   
> +	/*
> +	 * Paper over NV2 brokenness by publishing the interrupt status
> +	 * bit. This still results in a poor quality of emulation (guest
> +	 * writes will have no effect until the next exit).
> +	 *
> +	 * But hey, it's fast, right?
> +	 */
> +	if (vcpu_has_nv2(vcpu) && is_hyp_ctxt(vcpu) &&
> +	    (timer_ctx == vcpu_vtimer(vcpu) || timer_ctx == vcpu_ptimer(vcpu))) {
> +		u32 ctl = timer_get_ctl(timer_ctx);
> +
> +		if (new_level)
> +			ctl |= ARCH_TIMER_CTRL_IT_STAT;
> +		else
> +			ctl &= ~ARCH_TIMER_CTRL_IT_STAT;
> +
> +		timer_set_ctl(timer_ctx, ctl);
> +	}
> +
>   	timer_ctx->irq.level = new_level;
>   	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_ctx->irq.irq,
>   				   timer_ctx->irq.level);
> 
> which reports the interrupt state in all cases.
> 
> Does this work for you?

This works.
Are you going to pull this diff/patch in to your 6.2-nv tree? or you 
want me to send an updated patch?

> 
> Thanks,
> 
> 	M.
> 

Thanks,
Ganapat

