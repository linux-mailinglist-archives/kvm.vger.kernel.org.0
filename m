Return-Path: <kvm+bounces-3335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F962803401
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 14:09:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDF6B280F25
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 13:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD49F24B2A;
	Mon,  4 Dec 2023 13:09:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E60610EB
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 05:09:26 -0800 (PST)
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.55])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4SkP5759swz14L9q;
	Mon,  4 Dec 2023 21:04:27 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 21:09:23 +0800
Subject: Re: [PATCH v2 0/3] arm64: Drop support for VPIPT i-cache policy
To: Marc Zyngier <maz@kernel.org>
CC: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<kvm@vger.kernel.org>, Will Deacon <will@kernel.org>, Catalin Marinas
	<catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ard
 Biesheuvel <ardb@kernel.org>, James Morse <james.morse@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>
References: <20231127172613.1490283-1-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <6f859b31-dcbe-148d-cfde-e6119553b072@huawei.com>
Date: Mon, 4 Dec 2023 21:09:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20231127172613.1490283-1-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm000007.china.huawei.com (7.193.23.189)
X-CFilter-Loop: Reflected

On 2023/11/28 1:26, Marc Zyngier wrote:
> ARMv8.2 introduced support for VPIPT i-caches, the V standing for
> VMID-tagged. Although this looks like a reasonable idea, no
> implementation has ever made it into the wild.
> 
> Linux has supported this for over 6 years (amusingly, just as the
> architecture was dropping support for AVIVT i-caches), but we had no
> way to even test it, and it is likely that this code was just
> bit-rotting.
> 
> However, in a recent breakthrough (XML drop 2023-09, tagged as
> d55f5af8e09052abe92a02adf820deea2eaed717), the architecture has
> finally been purged of this option, making VIPT and PIPT the only two
> valid options.
> 
> This really means this code is just dead code. Nobody will ever come
> up with such an implementation, and we can just get rid of it.
> 
> Most of the impact is on KVM, where we drop a few large comment blocks
> (and a bit of code), while the core arch code loses the detection code
> itself.
> 
> Marc Zyngier (3):
>   KVM: arm64: Remove VPIPT I-cache handling
>   arm64: Kill detection of VPIPT i-cache policy
>   arm64: Rename reserved values for CTR_EL0.L1Ip

Series looks good to me.  With Anshuman's comment addressed,

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

