Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673C41C4FBA
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 09:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgEEHzi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 03:55:38 -0400
Received: from mail-co1nam11on2070.outbound.protection.outlook.com ([40.107.220.70]:6168
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726337AbgEEHzh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 03:55:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mduaDSD2XmRF70yDvVBgMGQjuiqEePaV9DiKnr3ZEWID5jRoS34xQDY1/hoyxo4hGVE+djeSCHRCICKIUIfbpStUiIhdxCXVaWJjs/OdPv4thkWHnJjS18IPd0VTwPuohG2f8dBefaSLRPD8OHAsO4HaOLu4RNICCYUMekB2RO27ekf2U8x8iXaAOpZmsCdHTGJdB8cJvSOHcu6A5TJPxTdnet2nZOlNpWvJCrRJlQIhjTDONh/Wy9JDt6+WEn5BPkK1fdZr/DXtsjPoPwzdc2fjPBsQg7K+QedrSfJRuhjfdvEbcl5PDnVQMysHOSVp8ro5xlb36U+3b6XTR7aSzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xNIOZIkFM06+bZQAUrGoFkq0JHVu0T1Rckjp3P5wX8U=;
 b=ca9/XxNLu9ALG72CtcNqnI4XCQAGn2lLA60bZPRbuP5GOuQQEEn/gBsdCWLv0O9ci0uFCXFfn93hWwU+57fNBu7JTgkO91YUEyDbiwYrvlx5rlms4RuAWc/kszXAXqDkXjJPCg7teSBGRwYuo9RQfONQLy5HV9icj/k2YCwlC0qEBl11NcugXiAbPdXadka0aqJ9r50hZct5bOom9Vwqw0KLD7p67IItd2xfmwEnM77D4FAFvjCtC3dicrDEZ0RCrKlLBmOvJvoOzNT/ZVyu861Ke/rbYr2H5mwahP5CDqgUAjBAMNTPCPdnpSWhw9ygcrWSSQ+lB86Lx4qddFMKtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xNIOZIkFM06+bZQAUrGoFkq0JHVu0T1Rckjp3P5wX8U=;
 b=jfLxn5ZdWs7o0DzZlK7cngUe1/mtIHfnrJhOymXtOcAHfQS5z+ieJCP7s4qnqhqKkhS5mp2VPKXQ/Lxw4U11S6wbfsvzqoDj2xiZ5UKBD1DrF6DFgVS85rKO4SfY1Zu9J8dM1fUrZOD4Kmn2WlSBjM16GacU7zXdqX6xPUN0JUY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM5PR12MB1868.namprd12.prod.outlook.com (2603:10b6:3:106::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Tue, 5 May 2020 07:55:35 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744%4]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 07:55:35 +0000
Subject: Re: AVIC related warning in enable_irq_window
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <9ce7bb5c4fb8bcc4ac21103f7534a6edfcbe195d.camel@redhat.com>
 <758b27a8-74c0-087d-d90b-d95faee2f561@redhat.com>
 <c5c32371-4b4e-1382-c616-3830ba46bf85@amd.com>
 <159382e7fdf0f9b50d79e29554842289e92e1ed7.camel@redhat.com>
 <d22d32de-5d91-662a-bf53-8cfb115dbe8d@redhat.com>
 <c81cf9bb-840a-d076-bc0e-496916621bdd@amd.com>
 <23b0dfe5-eba4-136b-0d4a-79f57f8a03ff@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-ID: <efbe933a-3ab6-fa57-37fb-affc87369948@amd.com>
Date:   Tue, 5 May 2020 14:55:14 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <23b0dfe5-eba4-136b-0d4a-79f57f8a03ff@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR01CA0026.apcprd01.prod.exchangelabs.com
 (2603:1096:820:1::14) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Suravees-MacBook-Pro.local (2403:6200:8862:d0e7:581:5d48:c702:870a) by KL1PR01CA0026.apcprd01.prod.exchangelabs.com (2603:1096:820:1::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Tue, 5 May 2020 07:55:33 +0000
X-Originating-IP: [2403:6200:8862:d0e7:581:5d48:c702:870a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b35fcde0-a811-4ca1-2d8d-08d7f0c9b134
X-MS-TrafficTypeDiagnostic: DM5PR12MB1868:
X-Microsoft-Antispam-PRVS: <DM5PR12MB18686BE34FD6B0BE92E1D2A4F3A70@DM5PR12MB1868.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AZtS1Rjuo3RRjHX3jyOH9NLzIsLW247zbnEzQXdZ+K+e1vVNRA1KfLsU7SxhrkU4X6KPL9c09C06IePbqT3eOiW3d1dVN2L5B4NBTjt1gr6EFb8x94HT3GxRbjIzF2zepys7IgZ8MVnVIPhZg2aUN0Yvpo1ScuxSZprDm93Gd5YJzfpik1zt3UMN5rIIrKYHEq5fq84iEWrdsbgcZNE1kOPRbuunZStdKHw66lW/SPfOEnBPRtWD6dydP8q2TIaPf6CjKG6DQVPWJYrWpz8SsI1ybqHMh9JNTf0g8D/Q1FLh8rTqTt51Yv7LKZNlToxxCV22LKeAbnJBNHDOXnCYRl4+Ki3aj7OOJeb9aTqpKKJh88qQOAWfNXOHEBlRtV2aKuX1LRkAl5wcGR3q9wtIHK3JtnPTmAK3tcf8BLv1K5xw5DZ3xQa7y6XOpi93ps0LjkSrLDMl3Cvs26ft0mwZPMQEPl7XA2kmnxlM6Dtan0xSk4xiHtxp7wEEdgU+y7+Yj3SlcY+yhkUOP00IHHeHvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(346002)(39860400002)(366004)(136003)(33430700001)(36756003)(16526019)(5660300002)(53546011)(6506007)(186003)(33440700001)(31686004)(8936002)(478600001)(2906002)(66476007)(31696002)(66556008)(86362001)(8676002)(66946007)(52116002)(6486002)(2616005)(44832011)(316002)(4326008)(110136005)(6666004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2Kp+epnFEJIFLerFv73ABe8yz6W6K722PvwnYgxiGOpuS6Gvm3pfqVPRYviCwctq9umMEEg8tWEEpcGdNPjna8zv7lzLX48kGStkJ84msEMrFVbvW4kjVLvPopZue4Gv7Pg8MlYCnvv+OjuTqpMJ+1JveW8GIJdFUMROUEpv8AHZKixZLWrfFAb6OzxaJoDcC8O3YO2OnvuFEs5O/INhrtSKgowRUmJaJw8JPxdn+O0WK8/kR+58+MXhiiZW3R2W4r+adqTh9lOmpKp3nyZCCmBWx/8sjA/lpQd5yY1Dk8O1TFwgQ90+m1e94ZrvPtAtTU7Hwt5aMnMlhiqqsFzeHClE1qVum0//Gsq/VYxQHpIQna4Wg7cTunx0mjxVM17EriHzTU0Lpci5/K7B6GZunp5Ax1hWotsWBSemfMeTYZwoo3RWTm8mYa8H+JNf11Pt9xZoUUhMfD1i3+J40dKMgWbYacH7KFixueG1XV9JoAwrBW0yBShcSEa6BehcXuCyBDN7FsyMKvzpXrS0zq3F927T3ncCT+FCTacRgtPKTu+SyMafN6XWBc7X9/hgGMId0SF5mDjbkdbTDgYw3Ho7yxlJ/M9MOaVike00/g1siBjYdw/9GS71OPGk9t2+0QUxMzKEyiof2xswrzrlAOAgYv0731Y5GpttL1AmUbNqSXkVMYL+aUb1H5Ue5qE958088ZlOc70badOJ3YNs3mau6uJpkZuyrtxaAAMMBwwfxtF15ez+DfJT73PObdG5MAbaRrhiSL7/hq9FLOC/mBPNOYBc/dv88gc7bg1cKJR4D0JOGTMuNKuNu/ZcbO44Rxmrjig8AtntHo0S/RfcwsJhsIJJTKboKV4J0qwqHV0NzU4=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b35fcde0-a811-4ca1-2d8d-08d7f0c9b134
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 07:55:35.1152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TyBREzueBydMg5JveNFkZWDvaQoE7nTmA/HgOIocRTpGbX83GOKWDClvUbL67MsXu9zdPg9Y+ihKgbNwSqUWRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1868
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo / Maxim,

On 5/4/20 5:49 PM, Paolo Bonzini wrote:
> On 04/05/20 12:37, Suravee Suthikulpanit wrote:
>> On 5/4/20 4:25 PM, Paolo Bonzini wrote:
>>> On 04/05/20 11:13, Maxim Levitsky wrote:
>>>> On Mon, 2020-05-04 at 15:46 +0700, Suravee Suthikulpanit wrote:
>>>>> On 5/2/20 11:42 PM, Paolo Bonzini wrote:
>>>>>> On 02/05/20 15:58, Maxim Levitsky wrote:
>>>>>>> The AVIC is disabled by svm_toggle_avic_for_irq_window, which calls
>>>>>>> kvm_request_apicv_update, which broadcasts the
>>>>>>> KVM_REQ_APICV_UPDATE vcpu request,
>>>>>>> however it doesn't broadcast it to CPU on which now we are
>>>>>>> running, which seems OK,
>>>>>>> because the code that handles that broadcast runs on each VCPU
>>>>>>> entry, thus when this CPU will enter guest mode it will notice 
>>>>>>> and disable the AVIC. >>>>>>>
>>>>>>> However later in svm_enable_vintr, there is test
>>>>>>> 'WARN_ON(kvm_vcpu_apicv_active(&svm->vcpu));'
>>>>>>> which is still true on current CPU because of the above.
>>>>>>
>>>>>> Good point!  We can just remove the WARN_ON I think.  Can you send
>>>>>> a patch?
>>>>>>
>>>>> Instead, as an alternative to remove the WARN_ON(), would it be
>>>>> better to just explicitly calling kvm_vcpu_update_apicv(vcpu) 
>>>>> to update the apicv_active flag right after kvm_request_apicv_update()?
>>>>>
>>>> This should work IMHO, other that the fact kvm_vcpu_update_apicv will
>>>> be called again, when this vcpu is entered since the KVM_REQ_APICV_UPDATE
>>>> will still be pending on it.
>>>> It shoudn't be a problem, and we can even add a check to do nothing
>>>> when it is called while avic is already in target enable state.
>>>
>>> I thought about that but I think it's a bit confusing.  If we want to
>>> keep the WARN_ON, Maxim can add an equivalent one to svm_vcpu_run, which
>>> is even better because the invariant is clearer.
>>>
>>> WARN_ON((vmcb->control.int_ctl & (AVIC_ENABLE_MASK | V_IRQ_MASK))
>>>      == (AVIC_ENABLE_MASK | V_IRQ_MASK));
>>>

Based on my experiment, it seems that the hardware sets the V_IRQ_MASK bit
when #VMEXIT despite this bit being ignored when AVIC is enabled.
(I'll double check w/ HW team on this.) In this case, I don't think we can
use the WARN_ON() as suggested above.

I think we should keep the warning in the svm_set_vintr() since we want to know
if the V_IRQ, V_INTR_PRIO, V_IGN_TPR, and V_INTR_VECTOR are ignored when calling
svm_set_vintr().

Instead, I would consider explicitly call kvm_vcpu_update_apicv() since it would
be benefit from not having to wait for the next vcpu_enter_guest for this vcpu to process
the request. This is less confusing to me. In this case, we would need to
kvm_clear_request(KVM_REQ_APICV_UPDATE) for this vcpu as well.

On the other hand, would be it useful to implement kvm_make_all_cpus_request_but_self(),
which sends request to all other vcpus excluding itself?

> By the way, there is another possible cleanup: the clearing
> of V_IRQ_MASK can be removed from interrupt_window_interception since it
> has already called svm_clear_vintr.

Maxim, I can help with the clean up patches if you would prefer.

Thanks,
Suravee


> Paolo
> 
