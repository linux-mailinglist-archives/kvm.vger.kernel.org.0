Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6F0F172E5F
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 02:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730445AbgB1BgN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 27 Feb 2020 20:36:13 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:56820 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729984AbgB1BgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 20:36:13 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id A85DA9B87906DBC93EC2;
        Fri, 28 Feb 2020 09:36:07 +0800 (CST)
Received: from dggeme702-chm.china.huawei.com (10.1.199.98) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 28 Feb 2020 09:36:07 +0800
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme702-chm.china.huawei.com (10.1.199.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 28 Feb 2020 09:36:06 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1713.004;
 Fri, 28 Feb 2020 09:36:07 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH v2] KVM: X86: deprecate obsolete KVM_GET_CPUID2 ioctl
Thread-Topic: [PATCH v2] KVM: X86: deprecate obsolete KVM_GET_CPUID2 ioctl
Thread-Index: AdXt1qEkvfAF5eNoTq2w3ZJUqJzH6Q==
Date:   Fri, 28 Feb 2020 01:36:07 +0000
Message-ID: <9054db11e0c946eba998864aa0c40fa2@huawei.com>
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

Vitaly Kuznetsov <vkuznets@redhat.com> writes:
>linmiaohe <linmiaohe@huawei.com> writes:
>
>> From: Miaohe Lin <linmiaohe@huawei.com>
>> -		if (copy_to_user(cpuid_arg, &cpuid, sizeof(cpuid)))
>> -			goto out;
>> -		r = 0;
>> +		r = -EINVAL;
>>  		break;
>>  	}
>
>Braces are not really needed not but all other cases in the switch have it so let's leave them here too.
>

That's what I think too. :)

>>
>>  	case KVM_GET_MSRS: {
>> +/* KVM_GET_CPUID2 is deprecated, should not be used. */
>
>"should not be used" pre-patch, post-patch we can say "Can only be used as a reliable source of -EINVAL" :-)

That's right.

>
>  #define KVM_GET_CPUID2            _IOWR(KVMIO, 0x91, struct kvm_cpuid2)
>  /* Available with KVM_CAP_VAPIC */
>  #define KVM_TPR_ACCESS_REPORTING  _IOWR(KVMIO, 0x92, struct 
> kvm_tpr_access_ctl)
>
>Surprisingly (or not), KVM_GET_CPUID2 is not even described in Documentation/virt/kvm/api.txt.
>

Maybe KVM_GET_CPUID2 is defined for integrity only.

>
>Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>

Many thanks for your review!

