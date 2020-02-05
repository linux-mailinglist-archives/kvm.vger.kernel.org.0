Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C54A2152493
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 02:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgBEB5q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 4 Feb 2020 20:57:46 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2939 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727140AbgBEB5q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 20:57:46 -0500
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 32A5CAB5CA5AADBE51FF;
        Wed,  5 Feb 2020 09:57:44 +0800 (CST)
Received: from dggeme714-chm.china.huawei.com (10.1.199.110) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 5 Feb 2020 09:57:43 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme714-chm.china.huawei.com (10.1.199.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 5 Feb 2020 09:57:43 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Wed, 5 Feb 2020 09:57:43 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: nVMX: Remove stale comment from
 nested_vmx_load_cr3()
Thread-Topic: [PATCH] KVM: nVMX: Remove stale comment from
 nested_vmx_load_cr3()
Thread-Index: AdXbxp75aDxUWE75SIe9flCE+/wfCA==
Date:   Wed, 5 Feb 2020 01:57:43 +0000
Message-ID: <c587f9fff1ec45709af5a453df94d92b@huawei.com>
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

Sean Christopherson <sean.j.christopherson@intel.com> writes:
> The blurb pertaining to the return value of nested_vmx_load_cr3() no longer matches reality, remove it entirely as the behavior it is attempting to document is quite obvious when reading the actual code.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> - * Returns 0 on success, 1 on failure. Invalid state exit qualification code
> - * is assigned to entry_failure_code on failure.
>  */
> static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool nested_ept,
> 			       u32 *entry_failure_code)

It seems the comment is uncorrect as it return -EINVAL on failure. Thanks.

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

