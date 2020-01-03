Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD64512F2E3
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2020 03:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgACCTg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 2 Jan 2020 21:19:36 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:51116 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726130AbgACCTg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jan 2020 21:19:36 -0500
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id C40AB3720E2D970A9063;
        Fri,  3 Jan 2020 10:19:33 +0800 (CST)
Received: from dggeme766-chm.china.huawei.com (10.3.19.112) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 3 Jan 2020 10:19:33 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme766-chm.china.huawei.com (10.3.19.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 3 Jan 2020 10:19:33 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Fri, 3 Jan 2020 10:19:33 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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
Subject: Re: [PATCH] KVM: SVM: Fix potential memory leak in svm_cpu_init()
Thread-Topic: [PATCH] KVM: SVM: Fix potential memory leak in svm_cpu_init()
Thread-Index: AdXB22PCGgAmhN24HEq8r6drwzC6/g==
Date:   Fri, 3 Jan 2020 02:19:33 +0000
Message-ID: <9083833afd7c465a9222e6801cb66499@huawei.com>
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

Vitaly writes:
>> From: Miaohe Lin <linmiaohe@huawei.com>
>>  	if (svm_sev_enabled()) {
>>  		r = -ENOMEM;
>
>Not your fault but this assignment to 'r' seem to be redundant: it is already set to '-ENOMEM' above, but this is also not perfect as ... 
>
>> @@ -1020,14 +1020,16 @@ static int svm_cpu_init(int cpu)
>>  					      sizeof(void *),
>>  	return r;
>
>... '-ENOMEM' is actually the only possible outcome here. In case you'll be re-submitting, I'd suggest we drop 'r' entirely and just reture -ENOMEM here.

The var r is really unnecessary and we should clean it up. Thanks for your good suggest. I would send a patch v2 soon.

>
>Anyways, your patch seems to be correct, so:
>
>Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks for your review.

