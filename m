Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA541639BD
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 02:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgBSB7M convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 18 Feb 2020 20:59:12 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:3015 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728049AbgBSB7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 20:59:12 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 89678D537310C44376DD;
        Wed, 19 Feb 2020 09:59:10 +0800 (CST)
Received: from dggeme751-chm.china.huawei.com (10.3.19.97) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 19 Feb 2020 09:59:09 +0800
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme751-chm.china.huawei.com (10.3.19.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 19 Feb 2020 09:59:10 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1713.004;
 Wed, 19 Feb 2020 09:59:09 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] KVM: VMX: replace "fall through" with "return true" to
 indicate different case
Thread-Topic: [PATCH] KVM: VMX: replace "fall through" with "return true" to
 indicate different case
Thread-Index: AdXmxq8nqVWWRnoHQZaSjPcZ82TtoQ==
Date:   Wed, 19 Feb 2020 01:59:09 +0000
Message-ID: <94f330693be7431fa6d586cc317c26bc@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.158]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> wrote:
>On Tue, Feb 18, 2020 at 11:39:28AM +0800, linmiaohe wrote:
>> From: Miaohe Lin <linmiaohe@huawei.com>
>> 
>> @@ -4495,7 +4495,7 @@ static bool rmode_exception(struct kvm_vcpu *vcpu, int vec)
>>  		if (vcpu->guest_debug &
>>  			(KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))
>>  			return false;
>> -		/* fall through */
>> +		return true;
>
>I prefer the current code, i.e. the fall through.  This code is already burdened with a fall through, from #BP->#DB, and IMO the fall through makes it more obvious that the vcpu->guest_debug checks are corner cases, while everything else is handled by common logic.

Yeh, it looks better this way. But from a different perspective, "return turn" here indicates #BP and #DB need do vcpu->guest_debug checks, while others not.
Thanks. :)

>
>>  	case DE_VECTOR:
>>  	case OF_VECTOR:
>>  	case BR_VECTOR: 
