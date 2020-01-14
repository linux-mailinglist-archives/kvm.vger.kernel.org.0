Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4D16139F61
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 03:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbgANCPb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 13 Jan 2020 21:15:31 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2989 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729402AbgANCPb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 21:15:31 -0500
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id B9AA8675F32A4268D52D;
        Tue, 14 Jan 2020 10:15:28 +0800 (CST)
Received: from dggeme716-chm.china.huawei.com (10.1.199.112) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 14 Jan 2020 10:15:28 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme716-chm.china.huawei.com (10.1.199.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 14 Jan 2020 10:15:28 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Tue, 14 Jan 2020 10:15:28 +0800
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
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2] KVM: nVMX: vmread should not set rflags to specify
 success in case of #PF
Thread-Topic: [PATCH v2] KVM: nVMX: vmread should not set rflags to specify
 success in case of #PF
Thread-Index: AdXKfnlTqBbphD17SN+x8lK5ZNmfGA==
Date:   Tue, 14 Jan 2020 02:15:28 +0000
Message-ID: <724c22eff5f94a338e0f8af4f2c1df93@huawei.com>
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
On Mon, Jan 13, 2020 at 12:09:42PM -0800, Sean Christopherson wrote:
> > On Sat, Dec 28, 2019 at 02:25:24PM +0800, linmiaohe wrote:
> > > From: Miaohe Lin <linmiaohe@huawei.com>
> > > 
> > > In case writing to vmread destination operand result in a #PF, 
> > vmread should not call nested_vmx_succeed() to set rflags to specify success.
> > > Similar to as done in VMPTRST (See handle_vmptrst()).
> > > 
> > > Reviewed-by: Liran Alon <liran.alon@oracle.com>
> > > Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> > 
> > Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Gah, got trigger happy.  This could also have "Cc: stable@vger.kernel.org".
> With that, my Reviewed-by stands :-).

Many thanks for your review. I would add Cc tag and resend a v3. Thanks again.
