Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3692B11C2F6
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 03:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbfLLCIi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 11 Dec 2019 21:08:38 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2478 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726793AbfLLCIg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 21:08:36 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id A2873810A3D0E9DE0606;
        Thu, 12 Dec 2019 10:08:33 +0800 (CST)
Received: from dggeme716-chm.china.huawei.com (10.1.199.112) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 12 Dec 2019 10:08:32 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme716-chm.china.huawei.com (10.1.199.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 12 Dec 2019 10:08:33 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Thu, 12 Dec 2019 10:08:32 +0800
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
Subject: Re: [PATCH 0/6] Fix various comment errors
Thread-Topic: [PATCH 0/6] Fix various comment errors
Thread-Index: AdWwkIVWFlZnSMe+cUqN78tMuV49Xw==
Date:   Thu, 12 Dec 2019 02:08:32 +0000
Message-ID: <88f5931859484959bd80a48edbbe1104@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.189.20]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson wrote:
> On Wed, Dec 11, 2019 at 02:26:19PM +0800, linmiaohe wrote:
>> From: Miaohe Lin <linmiaohe@huawei.com>
>> 
>> Miaohe Lin (6):
>>   KVM: Fix some wrong function names in comment
>>   KVM: Fix some out-dated function names in comment
>>   KVM: Fix some comment typos and missing parentheses
>>   KVM: Fix some grammar mistakes
>>   KVM: hyperv: Fix some typos in vcpu unimpl info
>>   KVM: Fix some writing mistakes
>
>Regarding the patch organizing, I'd probably group the comment changes based on what files they touch as opposed to what type of comment issue they're fixing.
>
>E.g. three patches for the comments
>
>   KVM: VMX: Fix comment blah blah blah
>   KVM: x86: Fix comment blah blah blah
>   KVM: Fix comment blah blah blah
>
>and one patch for the print typo in hyperv
>
>   KVM: hyperv: Fix some typos in vcpu unimpl info
>
>For KVM, the splits don't matter _that_ much since they more or less all get routed through the maintainers/reviewers, but it is nice when patches can be contained to specific subsystems/areas as it allows people to easily skip over patches that aren't relevant to them.
>

Many thanks for your advice and patient explanation. I feel sorry for my poor patch organizing.
I would reorganize my patches. Thanks again.
 
