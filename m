Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF812170DF0
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 02:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgB0Bfd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 26 Feb 2020 20:35:33 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:51084 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727964AbgB0Bfd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 20:35:33 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 9C57E219A9E64BA3F2FD;
        Thu, 27 Feb 2020 09:35:30 +0800 (CST)
Received: from dggeme704-chm.china.huawei.com (10.1.199.100) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 27 Feb 2020 09:35:30 +0800
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme704-chm.china.huawei.com (10.1.199.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 27 Feb 2020 09:35:30 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1713.004;
 Thu, 27 Feb 2020 09:35:30 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: Fix some obsolete comments
Thread-Topic: [PATCH] KVM: Fix some obsolete comments
Thread-Index: AdXtDdM9eK2cvv6aTVeXyFgaCiJkyg==
Date:   Thu, 27 Feb 2020 01:35:29 +0000
Message-ID: <f1fa66a985e2426083a1f3439b12a2bc@huawei.com>
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
>On Wed, Feb 26, 2020 at 01:48:28AM +0000, linmiaohe wrote:
>> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
>> >linmiaohe <linmiaohe@huawei.com> writes:
>> >> throws
>> >> - * #UD or #GP.
>> >> + * #UD, #GP or #SS.
>> >
>> >Oxford comma, anyone? :-)))
>> 
>> I have no strong preference. ^_^
>
>I'm also a fan of the Oxford comma when it comes to describing code.

So there are two votes for Oxford comma.:) Will do. Thanks.

