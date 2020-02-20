Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4FD61658FE
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 09:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgBTISI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 20 Feb 2020 03:18:08 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:3018 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726501AbgBTISI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 03:18:08 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 5EBDE75DE2C3B4178073;
        Thu, 20 Feb 2020 16:18:04 +0800 (CST)
Received: from dggeme701-chm.china.huawei.com (10.1.199.97) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 20 Feb 2020 16:18:03 +0800
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme701-chm.china.huawei.com (10.1.199.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 20 Feb 2020 16:18:03 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1713.004;
 Thu, 20 Feb 2020 16:18:03 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Li RongQing <lirongqing@baidu.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
CC:     Liran Alon <liran.alon@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH][resend] KVM: fix error handling in svm_cpu_init
Thread-Topic: [PATCH][resend] KVM: fix error handling in svm_cpu_init
Thread-Index: AdXnxCuvQCn2ngYdSyKWLfuyXd13zw==
Date:   Thu, 20 Feb 2020 08:18:03 +0000
Message-ID: <4cf5d767b570430a9e0b515a9d6d8fbd@huawei.com>
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
Li RongQing <lirongqing@baidu.com> writes:
>
>sd->save_area should be freed in error path
>
>Fixes: 70cd94e60c733 ("KVM: SVM: VMRUN should use associated ASID when SEV is enabled")
>Signed-off-by: Li RongQing <lirongqing@baidu.com>
>Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
>Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>---
> arch/x86/kvm/svm.c | 8 +++++---
> 1 file changed, 5 insertions(+), 3 deletions(-)

Oh, it's strange. This is already fixed in my previous patch : [PATCH v2] KVM: SVM: Fix potential memory leak in svm_cpu_init().
And Vitaly and Liran gave me Reviewed-by tags and Paolo queued it one month ago. But I can't found it in master or queue
branch. There might be something wrong. :(
