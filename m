Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40670161E72
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 02:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgBRBTG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 17 Feb 2020 20:19:06 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:3012 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726097AbgBRBTG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 20:19:06 -0500
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 6ADAD6CC603DCE2AA59A;
        Tue, 18 Feb 2020 09:19:02 +0800 (CST)
Received: from dggeme716-chm.china.huawei.com (10.1.199.112) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 18 Feb 2020 09:19:00 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme716-chm.china.huawei.com (10.1.199.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 18 Feb 2020 09:19:00 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Tue, 18 Feb 2020 09:19:00 +0800
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
Subject: Re: [PATCH] KVM: x86: eliminate some unreachable code
Thread-Topic: [PATCH] KVM: x86: eliminate some unreachable code
Thread-Index: AdXl+NU45blWUgUaIkO/8dNc6zLBsA==
Date:   Tue, 18 Feb 2020 01:19:00 +0000
Message-ID: <d743a58606fc45c7a6a2580454ec72eb@huawei.com>
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
>> @@ -4505,7 +4505,6 @@ static bool rmode_exception(struct kvm_vcpu *vcpu, int vec)
>>  	case GP_VECTOR:
>>  	case MF_VECTOR:
>>  		return true;
>> -	break;
>>  	}
>>  	return false;
>>  }
>
>Unrelated to your change but what I don't in rmode_exception() is the second "/* fall through */" instead of just 'return true;', it makes it harder to read.

Agree. I will do it in another patch as it's unrelated to this one. Many Thanks for your review and advice.
