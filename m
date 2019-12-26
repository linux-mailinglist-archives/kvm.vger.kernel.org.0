Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA8112A9C2
	for <lists+kvm@lfdr.de>; Thu, 26 Dec 2019 03:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfLZCba convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 25 Dec 2019 21:31:30 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2539 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726899AbfLZCba (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Dec 2019 21:31:30 -0500
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 03246CF25FAB54CE2B2F;
        Thu, 26 Dec 2019 10:31:28 +0800 (CST)
Received: from dggeme715-chm.china.huawei.com (10.1.199.111) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Dec 2019 10:31:27 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme715-chm.china.huawei.com (10.1.199.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 26 Dec 2019 10:31:27 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Thu, 26 Dec 2019 10:31:27 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Liran Alon <liran.alon@oracle.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
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
Subject: Re: [PATCH] KVM: nvmx: retry writing guest memory after page fault
 injected
Thread-Topic: [PATCH] KVM: nvmx: retry writing guest memory after page fault
 injected
Thread-Index: AdW7k0w0WbRQrxXDT82zueNPzgGwWg==
Date:   Thu, 26 Dec 2019 02:31:27 +0000
Message-ID: <5744632b88b44369a68c0b0704bfb48e@huawei.com>
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

Hi,

Liran Alon <liran.alon@oracle.com> wrote:
>> On 25 Dec 2019, at 4:21, linmiaohe <linmiaohe@huawei.com> wrote:
>> 
>> From: Miaohe Lin <linmiaohe@huawei.com>
>> 
>> We should retry writing guest memory when 
>> kvm_write_guest_virt_system() failed and page fault is injected in handle_vmread().
>> 
>> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>
>Patch fix seems correct to me:
>Reviewed-by: Liran Alon <liran.alon@oracle.com>

Thanks for your review.

>However, I suggest to rephrase commit title & message as follows:
>
>"""
>KVM: nVMX: vmread should not set rflags to specify success in case of #PF
>
>In case writing to vmread destination operand result in a #PF, vmread should not call nested_vmx_succeed() to set rflags to specify success. Similar to as done in for VMPTRST (See handle_vmptrst()).
>"""

Thanks for your sueestion, I would rephrase commit title & message accordingly.

>
>In addition, it will be appreciated if you would also submit kvm-unit-test that verifies this condition.

I'd like to submit kvm-unit-test that verifies this condition, but I am not familiar with the kvm-unit-test code yet and
also not in my recent todo list. So such a patch may come late. It would be appreciated too if you could submit this
kvm-unit-test patch. :) 
Thanks again.
