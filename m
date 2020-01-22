Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEA61144BD7
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 07:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgAVGlk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 22 Jan 2020 01:41:40 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2932 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725883AbgAVGlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 01:41:40 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 5DC50164CDFF9D86DBC1;
        Wed, 22 Jan 2020 14:41:37 +0800 (CST)
Received: from dggeme766-chm.china.huawei.com (10.3.19.112) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 22 Jan 2020 14:41:36 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme766-chm.china.huawei.com (10.3.19.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 22 Jan 2020 14:41:36 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Wed, 22 Jan 2020 14:41:36 +0800
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
Subject: Re: [PATCH] KVM: X86: Add 'else' to unify fastop and execute call
 path
Thread-Topic: [PATCH] KVM: X86: Add 'else' to unify fastop and execute call
 path
Thread-Index: AdXQ7h4phXDfYzF8TkGgPxWB+LvmzQ==
Date:   Wed, 22 Jan 2020 06:41:36 +0000
Message-ID: <2b928100e8354aa8a2bf2bba845e8bee@huawei.com>
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
Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> On Wed, Jan 22, 2020 at 11:21:44AM +0800, linmiaohe wrote:
>> From: Miaohe Lin <linmiaohe@huawei.com>
>> 
>> It also helps eliminate some duplicated code.
>
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

Thanks for your review.

>
>>  		if (ctxt->d & Fastop) {
>>  			void (*fop)(struct fastop *) = (void *)ctxt->execute;
>
>The brackets can also be removed with a bit more cleanup, e.g. using a typedef to handling casting ctxt->execute.  I'll send a patch that can be applied on top and/or squashed with this one.

Thanks for doing this. :)

>
>>  			rc = fastop(ctxt, fop);
