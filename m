Return-Path: <kvm+bounces-49596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B399ADAE09
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 13:10:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C49C3B01B1
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 11:09:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0DFF2BD5A7;
	Mon, 16 Jun 2025 11:10:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464B01E501C;
	Mon, 16 Jun 2025 11:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750072212; cv=none; b=EtJtMNO6LctNn2EuuNW5jY5p2ODj9yIVj/HwqFu1rCY0hE7nj+jrbQBCmH1OtJo0u1cnzf/NYlvsMgaaGkjTRdoUP90pjbc1HjiPqlx6dO5NBOjWZHFug+k4287SM2FZQY7vKYDHsSse6VvcRKW+a3SuXg5erdfLdzNfPdfTAfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750072212; c=relaxed/simple;
	bh=061tTKCW1Z+wM95im2rlDKaggm8fXWjifaAXtUl0CiM=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=VMjKRH5XeytYwqLPEaOOAhbISRjqLwS8dQwhA/gXoxGMyjlXWH96jhO0cj/TR1GqxA+bRRRRBdYv5c9BDXUbo51npx5jVs9eunxR36R7XXY4NwogD7WC5PY4p7o/oAOZ5COaHFZCgR8j2Ep67oviW9lf6iAzQrZTwO2wlCrQki0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4bLRzy28PLz1V43x;
	Mon, 16 Jun 2025 19:07:42 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id 287C3180044;
	Mon, 16 Jun 2025 19:10:06 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 16 Jun 2025 19:10:04 +0800
Subject: Re: [PATCH 3/8] KVM: arm64: Move ARM specific headers in include/kvm
 to arch directory
To: Sean Christopherson <seanjc@google.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan
	<maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley
	<paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
	<aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda
	<imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linux-mips@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	<kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, Anish Ghulati <aghulati@google.com>, Colton
 Lewis <coltonlewis@google.com>, Thomas Huth <thuth@redhat.com>
References: <20250611001042.170501-1-seanjc@google.com>
 <20250611001042.170501-4-seanjc@google.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <a5032f01-9f54-eff9-ee72-b159ed56ca70@huawei.com>
Date: Mon, 16 Jun 2025 19:10:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250611001042.170501-4-seanjc@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk200017.china.huawei.com (7.202.194.83)

On 2025/6/11 8:10, Sean Christopherson wrote:
> Move kvm/arm_{arch_timer,pmu,vgic}.h to arch/arm64/include/asm and drop
> the "arm" prefix from all file names.  Now that KVM no longer supports
> 32-bit ARM, there is no reason to expose ARM specific headers to other
> architectures beyond arm64.
> 
> Cc: Colton Lewis <coltonlewis@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../arm64/include/asm/kvm_arch_timer.h                     | 0
>  arch/arm64/include/asm/kvm_host.h                          | 7 +++----
>  include/kvm/arm_pmu.h => arch/arm64/include/asm/kvm_pmu.h  | 0
>  .../kvm/arm_vgic.h => arch/arm64/include/asm/kvm_vgic.h    | 0
>  arch/arm64/kvm/arch_timer.c                                | 5 ++---
>  arch/arm64/kvm/arm.c                                       | 3 +--
>  arch/arm64/kvm/pmu-emul.c                                  | 4 ++--
>  arch/arm64/kvm/reset.c                                     | 3 +--
>  arch/arm64/kvm/trace_arm.h                                 | 2 +-
>  arch/arm64/kvm/vgic/vgic-debug.c                           | 2 +-
>  arch/arm64/kvm/vgic/vgic-init.c                            | 2 +-
>  arch/arm64/kvm/vgic/vgic-irqfd.c                           | 2 +-
>  arch/arm64/kvm/vgic/vgic-kvm-device.c                      | 2 +-
>  arch/arm64/kvm/vgic/vgic-mmio-v2.c                         | 2 +-
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c                         | 2 +-
>  arch/arm64/kvm/vgic/vgic-mmio.c                            | 4 ++--
>  arch/arm64/kvm/vgic/vgic-v2.c                              | 2 +-
>  arch/arm64/kvm/vgic/vgic-v3-nested.c                       | 3 +--
>  arch/arm64/kvm/vgic/vgic-v3.c                              | 2 +-
>  19 files changed, 21 insertions(+), 26 deletions(-)
>  rename include/kvm/arm_arch_timer.h => arch/arm64/include/asm/kvm_arch_timer.h (100%)
>  rename include/kvm/arm_pmu.h => arch/arm64/include/asm/kvm_pmu.h (100%)
>  rename include/kvm/arm_vgic.h => arch/arm64/include/asm/kvm_vgic.h (100%)

Nitpick:

|F:	include/kvm/arm_*

can be deleted from the KVM/arm64 MAINTAINERS entry now.

Thanks,
Zenghui

