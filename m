Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC69D22A60C
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 05:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387718AbgGWDal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 23:30:41 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34898 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733203AbgGWDal (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 23:30:41 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5104EB7C2985CD5A5D6C;
        Thu, 23 Jul 2020 11:30:35 +0800 (CST)
Received: from [10.174.185.226] (10.174.185.226) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Thu, 23 Jul 2020 11:30:27 +0800
Subject: Re: [PATCH] KVM: arm64: Prevent vcpu_has_ptrauth from generating OOL
 functions
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Marc Zyngier <maz@kernel.org>
CC:     <kvm@vger.kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
        <kernel-team@android.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "James Morse" <james.morse@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        "Will Deacon" <will@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20200722162231.3689767-1-maz@kernel.org>
 <20200723025142.GA361584@ubuntu-n2-xlarge-x86>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <b60f9cd1-adf1-b32a-e6cc-ca880506ff03@huawei.com>
Date:   Thu, 23 Jul 2020 11:30:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200723025142.GA361584@ubuntu-n2-xlarge-x86>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.226]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nathan,

On 2020/7/23 10:51, Nathan Chancellor wrote:
> For the future, is there an easy way to tell which type of system I am
> using (nVHE or VHE)?

afaict the easiest way is looking at the kernel log and you will find
something like "{VHE,Hyp} mode initialized successfully". I can get the
following message on my *VHE* box:

  # cat /var/log/dmesg | grep kvm
[    4.896295] kvm [1]: IPA Size Limit: 48bits
[    4.896339] [...]
[    4.899407] kvm [1]: VHE mode initialized successfully
                         ^^^

Have a look at kvm_arch_init(). With VHE, the host kernel is running at
EL2 (aka Hyp mode).


Thanks,
Zenghui
