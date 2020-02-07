Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 326D31552C4
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 08:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgBGHKx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 7 Feb 2020 02:10:53 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:33966 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726573AbgBGHKx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 02:10:53 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 811A1642D0DD1D05F4D5;
        Fri,  7 Feb 2020 15:10:49 +0800 (CST)
Received: from dggeme764-chm.china.huawei.com (10.3.19.110) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 7 Feb 2020 15:10:48 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme764-chm.china.huawei.com (10.3.19.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 7 Feb 2020 15:10:48 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Fri, 7 Feb 2020 15:10:48 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [Question] some questions about vmx
Thread-Topic: [Question] some questions about vmx
Thread-Index: AdXdhFgBwMZqZE9VSkyT5yW9VeTIJw==
Date:   Fri, 7 Feb 2020 07:10:48 +0000
Message-ID: <736f8beabe2046fdab0631f28f9d2b1f@huawei.com>
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

Hi:
Vitaly Kuznetsov <vkuznets@redhat.com> writes:
>linmiaohe <linmiaohe@huawei.com> writes:
>
>> About nWMX.
>> When nested_vmx_handle_enlightened_vmptrld() return 0, it do not 
>> inject any exception or set rflags to Indicate VMLAUNCH instruction 
>> failed and skip this instruction. This would cause nested_vmx_run() 
>
>Yes, it seems it can. 
>
>nested_vmx_handle_enlightened_vmptrld() has two possible places where it can fail:
>
>kvm_vcpu_map() -- meaning that the guest passed some invalid GPA.
>revision id check -- meaning that the supplied eVMCS is unsupported/garbage.
>
>I think the right behavior would be to nested_vmx_failInvalid() in both these cases. We can also check what genuing Hyper-V does.
>

Many thanks for your reply. I think this would be a problem too. And would you like to fix this potential problem? I have no idea
how to fix this correctly... Thanks again.

