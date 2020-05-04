Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974731C370B
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 12:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgEDKiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 06:38:02 -0400
Received: from mail-dm6nam12on2067.outbound.protection.outlook.com ([40.107.243.67]:14108
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726445AbgEDKiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 06:38:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V7g+31kTwL27cHuzheaE1LJXz/7BONJlMEn2EYjYFFUYSiLe5BP79SX0tft5s6CrJIQscLuL7cZ03NyOKQfiUHIR+WINh/YoJqA2DTXI91Xcz3X5ch9yvztc+069C5Ue/eXFsW+ootOjieJCzC7kgk77z8JRJRGmqe3BTRNprjCv0BKaJwQgK7wyNoyK/HVHonK2SG/e+YDRNgutSjSjHMlN0zDGUaDcbIlpgAJLiXp+ocj/DFDmrHPu739kkPiQOlzwyA0M7KXyl/nRWG+YBgegHIdSOhwS6LGSCz7bX9IPVrf8MLWauGeLdhlklv8FhSQ6CVYccvOtLohf2Ue5RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FCxA7VRNUyu5kqdJZaSoKhC8qoiUGuF4WWK5JQsKXew=;
 b=PSP+2HkNuVdbciOsrh9OSW2zsNLXDbi/lJkeXqb6l+iNWxsiXdoCNJWQH892RYW/14mUfM7bUoRoNDeUYgpHWDdb3SZE/6qNM/6X2R9k4Yp2TPw2b6vxO7Oi7YSIJAnSGKtiHYQ/7vETn2XjxBZno1x5DURmsSzGmA9flcBIsV9P1/zf58vs0Y3OZl5i3R8fgwLyif+4XbraBqYS2podJfRxKoaQ6nA4Q3cV/48ezGtEZtSuNvLRWkLST4J0yKRLvxOqqphLvbKjbaabHqS9gFGSqDrLrooVn3GCXlCDTfdeE/mwJ99M0YWoo2hwRJxKeMh0E+O9sI3FAb5/hoj8ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FCxA7VRNUyu5kqdJZaSoKhC8qoiUGuF4WWK5JQsKXew=;
 b=MZ8vEGSlRUAfat8RD7oxVTPYE4UeXPgkZi/LAdv7vTivrR4nY1VHrSOpj+C8QuJT0c0DmEHYuxaeGOaCiJMveE91FJRuK6CVYWTBqvD9+aK5dtEvU3+g/ZXsqSxdTtPvvMIgWHlF4RjYgsIEig0HAoXSC/GiXxFtEHMHyy6ihU0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM5PR12MB1148.namprd12.prod.outlook.com (2603:10b6:3:74::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Mon, 4 May 2020 10:37:54 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744%4]) with mapi id 15.20.2958.029; Mon, 4 May 2020
 10:37:54 +0000
Subject: Re: AVIC related warning in enable_irq_window
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <9ce7bb5c4fb8bcc4ac21103f7534a6edfcbe195d.camel@redhat.com>
 <758b27a8-74c0-087d-d90b-d95faee2f561@redhat.com>
 <c5c32371-4b4e-1382-c616-3830ba46bf85@amd.com>
 <159382e7fdf0f9b50d79e29554842289e92e1ed7.camel@redhat.com>
 <d22d32de-5d91-662a-bf53-8cfb115dbe8d@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-ID: <c81cf9bb-840a-d076-bc0e-496916621bdd@amd.com>
Date:   Mon, 4 May 2020 17:37:44 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <d22d32de-5d91-662a-bf53-8cfb115dbe8d@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0019.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::31)
 To DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Suravees-MacBook-Pro.local (2403:6200:8862:d0e7:7c73:bebd:7e44:6839) by SGBP274CA0019.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Mon, 4 May 2020 10:37:52 +0000
X-Originating-IP: [2403:6200:8862:d0e7:7c73:bebd:7e44:6839]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dadb86ae-8e46-4f51-079e-08d7f01733a6
X-MS-TrafficTypeDiagnostic: DM5PR12MB1148:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1148F7540171A97F5F559A9DF3A60@DM5PR12MB1148.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03932714EB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p8OheAMmnsytef10bTORf0vKbTmALV6mVQt1jL5TME9CT/G3YlEf6MQUsIOYyUhLpoBfgerJeXezVpFYUcv1Lvp6EDsx58XhFPkhVGgCEqclkOX4zJfQYHOKnEV+PsjTxAsw7tg5Hj7zX9R3UsaGO7NlCw74P7kDqomsu6gy52TgRqef0SEcSv5/5cUVdcfCU8ieMUZCH49Nl8qon2i3nJf8U1SxlCYqpRUtelI6iBxodK1LOE6teoeCEGlWIIWXCe3fXHJJMdMC71s3XeuIxRiBRcymYqS/3gKVfKKvzbdJXb5RaJnsGUDnio9TLTO+8WTxa2Ra94bajII32RbMt7Eciy+DHxSE7BtVMYUp0/S7L0YjLCQ/i0SWfpDwguV7sVluWN2h2I/B/AQOCAwfQisEqjpzEGG/d8oueEE+OvlQ/h1qPGs4cAfqoDwUPgnL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(366004)(396003)(39860400002)(376002)(66556008)(66476007)(478600001)(4326008)(5660300002)(8676002)(110136005)(53546011)(44832011)(316002)(2616005)(6506007)(31696002)(66946007)(36756003)(6512007)(186003)(6666004)(2906002)(8936002)(52116002)(86362001)(16526019)(6486002)(31686004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ucaiIceXT9ajhNQHHejKHC/fJ3TSg4aGJ2p515aK6ol1iOqXLODSruKPD085Rp0HfuSLrh6P5YLmYxNUPSoJNqgl80UtE+plfpaeXS4bU13NcpDcZejDHwirjlw/1Z3ZCCwNIlKIC7q7VglI+A4CSFodiNKb13FxIZC4U5NrDJMaXe2/pG2weNKKCOzIp/v1RkoVydedPsvVSYED7+KzkzPnaS9oUWyehfxaO7dfXIv/msveHBwSavlpMwZl01yoEyobqhJma/i6lLLRPGlsRsxxEilx5Ht9wJyx5HVGGSafYUhLp0hJaeS2gM+7cbBtGd9P/7rFLPV7h0GTfVEQNggQtpcZBrOGitBoMhhqJz4zvkQbIahcH/ufMtIQHh+TaNVrQdjcEdSbRHiYwdSL3q5xtXV/uCuVGwrq4I82X+0TFOFCEQ3b3gc9hSrc2WwvWxUCMG2dVR24YUd8xzg4bzv3+1kG1WCVgRAighrfffny0hkDwNncMAZlhIPZ5e4FQjBxuU4vTB+dpTeDO3tFOdHseSncrX3eWptTcplwHdn4UVGnCYXHVvGmsjfLF8l9jj788WDrZMDS58fXRjcZxe5jSxIfA4tgXF+tup9U8ywrV0W+JkQT8p3PKGG4qW3fGUdgRCk+YfxXR5+ieRBhDgo+alyZvcA74dNB/jJAhQt2iKsdfNUuKzDBQo60jy8EI25L41eOgwAJMsZA0Vk/OEAlzaTr8b6E/zReGW/RJZdq/WUsRcrz5Sj+ibNi0Aa18kr0W3oI5yBaznH3vn+7pyudmCmVr3QLQTY7GQsC5xwtpMSOZZMVAQ2GbkvLKBjmTB34hrCD2u5MnFjY0pk9Qe1LZ+gTOuLO1ktr7644i3lHI3+GE447d5rWPT/lMOyG
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dadb86ae-8e46-4f51-079e-08d7f01733a6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2020 10:37:53.9566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WlYD5j0oA7V5/sizynOnv9+t9I0H9BXbPnS+jn/9ocTRbZBuSFMbxEbdVLAuA6UamUF9R0nMrMLAbYCj/LDsRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1148
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo / Maxim,

On 5/4/20 4:25 PM, Paolo Bonzini wrote:
> On 04/05/20 11:13, Maxim Levitsky wrote:
>> On Mon, 2020-05-04 at 15:46 +0700, Suravee Suthikulpanit wrote:
>>> Paolo / Maxim,
>>>
>>> On 5/2/20 11:42 PM, Paolo Bonzini wrote:
>>>> On 02/05/20 15:58, Maxim Levitsky wrote:
>>>>> The AVIC is disabled by svm_toggle_avic_for_irq_window, which calls
>>>>> kvm_request_apicv_update, which broadcasts the KVM_REQ_APICV_UPDATE vcpu request,
>>>>> however it doesn't broadcast it to CPU on which now we are running, which seems OK,
>>>>> because the code that handles that broadcast runs on each VCPU entry, thus
>>>>> when this CPU will enter guest mode it will notice and disable the AVIC.
>>>>>
>>>>> However later in svm_enable_vintr, there is test 'WARN_ON(kvm_vcpu_apicv_active(&svm->vcpu));'
>>>>> which is still true on current CPU because of the above.
>>>>
>>>> Good point!  We can just remove the WARN_ON I think.  Can you send a patch?
>>>
>>> Instead, as an alternative to remove the WARN_ON(), would it be better to just explicitly
>>> calling kvm_vcpu_update_apicv(vcpu) to update the apicv_active flag right after
>>> kvm_request_apicv_update()?
>>>
>> This should work IMHO, other that the fact kvm_vcpu_update_apicv will be called again,
>> when this vcpu is entered since the KVM_REQ_APICV_UPDATE will still be pending on it.
>> It shoudn't be a problem, and we can even add a check to do nothing when it is called
>> while avic is already in target enable state.
> 
> I thought about that but I think it's a bit confusing.  If we want to
> keep the WARN_ON, Maxim can add an equivalent one to svm_vcpu_run, which
> is even better because the invariant is clearer.
> 
> WARN_ON((vmcb->control.int_ctl & (AVIC_ENABLE_MASK | V_IRQ_MASK))
> 	== (AVIC_ENABLE_MASK | V_IRQ_MASK));
> 
> Paolo
> 

Quick update. I tried your suggestion as following, and it's showing the warning still.
I'll look further into this.

  arch/x86/kvm/svm/svm.c | 20 +++++++++++++-------
  1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2f379ba..142c4b9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1368,9 +1368,6 @@ static inline void svm_enable_vintr(struct vcpu_svm *svm)
  {
         struct vmcb_control_area *control;

-       /* The following fields are ignored when AVIC is enabled */
-       WARN_ON(kvm_vcpu_apicv_active(&svm->vcpu));
-
         /*
          * This is just a dummy VINTR to actually cause a vmexit to happen.
          * Actual injection of virtual interrupts happens through EVENTINJ.
@@ -3322,6 +3319,11 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
                 vcpu->arch.apic->lapic_timer.timer_advance_ns)
                 kvm_wait_lapic_expire(vcpu);

+//SURAVEE
+       WARN_ON((svm->vmcb->control.int_ctl &
+                (AVIC_ENABLE_MASK | V_IRQ_MASK))
+                == (AVIC_ENABLE_MASK | V_IRQ_MASK));
+

Suravee
