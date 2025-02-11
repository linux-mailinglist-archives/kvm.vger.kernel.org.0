Return-Path: <kvm+bounces-37860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4360EA30B91
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 13:17:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4353B3ABBF2
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 12:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A580C21D5B4;
	Tue, 11 Feb 2025 12:15:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85031215067;
	Tue, 11 Feb 2025 12:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739276133; cv=none; b=Z5Jwpcp3O2uppJ06hIK9FuEGl2pMMeZye11N4ibjP6/lqvUgjOyOKfqO7eAzlZS7rqg/bKni59571xRVGdO5z5VvA9SpvzX1jxccSvSGNFM5DNh4oMYb1/uKTqDctxKcQ+5DvZ2ySSU7Hh3j+L3sH33jLhnUfoDHKplmqwYKuLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739276133; c=relaxed/simple;
	bh=px1/3pDHkPTjELj1Y3FHc3HpPQ/OFBWfdG0ktviEZB8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=jo5wEg3uyHC+zfxyJB+v4F58T2qB5s0/YbaLwVsoqfw9s6sCGSQUnn2ryOvOz8rZ1czvWA1VokG9FzqqFU6+b+gIE1CCmPVKMYJw5fgteW5Uk8c/o9Cl2gTBHs8CV1Hm9wzqg6Ykg0Q4daj0jBxwWviJIWFHsaKJJ1IoYZLjuL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxLGtdP6tnRiVyAA--.2035S3;
	Tue, 11 Feb 2025 20:15:25 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMBxLsdaP6tn2fkLAA--.47359S3;
	Tue, 11 Feb 2025 20:15:25 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: remove unnecessary header include path
To: Masahiro Yamada <masahiroy@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, WANG Xuerui <kernel@xen0n.name>
References: <20250210102148.1516651-1-masahiroy@kernel.org>
From: bibo mao <maobibo@loongson.cn>
Message-ID: <aa024fce-9882-3bbe-9a3c-08e461408241@loongson.cn>
Date: Tue, 11 Feb 2025 20:14:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250210102148.1516651-1-masahiroy@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxLsdaP6tn2fkLAA--.47359S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9xXoWrur13Wr1DJr48Zr4fGF4rJFc_yoWfXrbEva
	y3Gw4rG3yrJw4kXws5K3yrG3W0gw1kJFs0vrnxXr1xJF9xGrZ5GFs3Ww45AFZ8KrWDWr45
	tFWvyF98Cr15tosvyTuYvTs0mTUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbx8YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0
	oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc02F4
	0EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_
	Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbI
	xvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AK
	xVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrx
	kI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v2
	6r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
	CI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jUsqXUUUUU
	=

On 2025/2/10 下午6:21, Masahiro Yamada wrote:
> arch/loongarch/kvm/ includes local headers with the double-quote form
> (#include "..."). Also, TRACE_INCLUDE_PATH in arch/loongarch/kvm/trace.h
> is relative to include/trace/.
> 
> Hence, the local header search path is unneeded.
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> ---
> 
>   arch/loongarch/kvm/Makefile | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
> index 3a01292f71cc..f4c8e35c216a 100644
> --- a/arch/loongarch/kvm/Makefile
> +++ b/arch/loongarch/kvm/Makefile
> @@ -3,8 +3,6 @@
>   # Makefile for LoongArch KVM support
>   #
>   
> -ccflags-y += -I $(src)
> -
>   include $(srctree)/virt/kvm/Makefile.kvm
>   
>   obj-$(CONFIG_KVM) += kvm.o
> 
Reviewed-by: Bibo Mao <maobibo@loongson.cn>


