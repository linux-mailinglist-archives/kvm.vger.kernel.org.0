Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F07513D1D5
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 03:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730576AbgAPCED convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 15 Jan 2020 21:04:03 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2560 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729431AbgAPCED (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 21:04:03 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id D19F737F32F697526E1E;
        Thu, 16 Jan 2020 10:04:01 +0800 (CST)
Received: from dggeme764-chm.china.huawei.com (10.3.19.110) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 16 Jan 2020 10:04:01 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme764-chm.china.huawei.com (10.3.19.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 16 Jan 2020 10:04:01 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Thu, 16 Jan 2020 10:03:59 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "will@kernel.org" <will@kernel.org>,
        "andre.przywara@arm.com" <andre.przywara@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: arm64: get rid of var ret and out jump label in
 kvm_arch_vcpu_ioctl_set_guest_debug()
Thread-Topic: [PATCH] KVM: arm64: get rid of var ret and out jump label in
 kvm_arch_vcpu_ioctl_set_guest_debug()
Thread-Index: AdXMEOY3ibkFZKiqSOySikptaJRgWA==
Date:   Thu, 16 Jan 2020 02:03:59 +0000
Message-ID: <36f01951fb09465e9981b870c536eea5@huawei.com>
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


Marc Zyngier <maz@kernel.org> wrote:
> 
> I don't think there is anything wrong with the existing code.
> It may not be to your own taste, but is in keeping with a lot of the KVM code.
>
> If you were making changes to this code, I wouldn't object.
> But on its own, this is just churn.
>
> Thanks,
>
>          M.

Oh, I see. Many thanks for your reply and patient explaination.
