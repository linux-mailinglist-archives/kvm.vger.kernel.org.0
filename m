Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFBC144BE4
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 07:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgAVGpU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 22 Jan 2020 01:45:20 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2933 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725862AbgAVGpT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 01:45:19 -0500
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 54629633CB77996C62F7;
        Wed, 22 Jan 2020 14:45:16 +0800 (CST)
Received: from dggeme766-chm.china.huawei.com (10.3.19.112) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 22 Jan 2020 14:45:16 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme766-chm.china.huawei.com (10.3.19.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 22 Jan 2020 14:45:15 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Wed, 22 Jan 2020 14:45:15 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 02/01] KVM: x86: Use a typedef for fastop functions
Thread-Topic: [PATCH 02/01] KVM: x86: Use a typedef for fastop functions
Thread-Index: AdXQ7wQO7gfXyaigQEuRUqZCmOrVqQ==
Date:   Wed, 22 Jan 2020 06:45:15 +0000
Message-ID: <03a3ae65df7d45338ad0a82f96bb6ecb@huawei.com>
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
> Add a typedef to for the fastop function prototype to make the code more readable.
>
> No functional change intended.
>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>
> Applies on top of Miaohe's patch.  Feel free to squash this.
>
> arch/x86/kvm/emulate.c | 14 +++++++-------

Thanks for making the code more readable and clean.

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>


