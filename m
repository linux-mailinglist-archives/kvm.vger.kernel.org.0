Return-Path: <kvm+bounces-29823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 082E19B2977
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 09:01:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2001281CD0
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 08:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 746ED1DA61D;
	Mon, 28 Oct 2024 07:38:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2423518A6BC
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 07:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730101130; cv=none; b=Ea7MnQCftJSH3K4Nyd1oXy72a8p6FZJqzJfKgkhM8UqckLyScB1iTPrwjsXBccDzB3goX+zW27tPJIuyE+juewKA5O1ttgcBlPQQlk3zIhDlPmLTKzzwBOAyxwjQ5/V3BKOFFl9oEw5FvJweZOvlifa+/FEL+/0A1txon0SPFrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730101130; c=relaxed/simple;
	bh=jVlSe8r/Woe/ps043Ccimj3KgcYuam9HgNITQA/EOiM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=VCNqvX/sZbvsoatUTGuV3gweT02sNAUtRAeqMY8ThvK9fZ6//KRGzVhZx0F6DEKs+RxxRFaJLHxiYrIe6OVNtZVCBtzK3VDJ4r5ieVfaniZ1mFa7Unb7Zcj9VfqzNuBTCsHO86TDxRO2tDASgQcGLjnzmfrvo02AHWiwSRxjWRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.239])
	by gateway (Coremail) with SMTP id _____8DxDeOCPx9n624YAA--.50368S3;
	Mon, 28 Oct 2024 15:38:42 +0800 (CST)
Received: from [10.20.42.239] (unknown [10.20.42.239])
	by front1 (Coremail) with SMTP id qMiowMAxnsJ9Px9np9MhAA--.49621S3;
	Mon, 28 Oct 2024 15:38:39 +0800 (CST)
Subject: Re: [PATCH v3 1/3] linux-headers: Add unistd_64.h
To: Bibo Mao <maobibo@loongson.cn>, "Michael S . Tsirkin" <mst@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Palmer Dabbelt
 <palmer@dabbelt.com>, Alistair Francis <alistair.francis@wdc.com>,
 Bin Meng <bmeng.cn@gmail.com>, Cornelia Huck <cohuck@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20241028023809.1554405-1-maobibo@loongson.cn>
 <20241028023809.1554405-2-maobibo@loongson.cn>
From: gaosong <gaosong@loongson.cn>
Message-ID: <b5f4a39a-278a-1918-29f2-b9da197ce055@loongson.cn>
Date: Mon, 28 Oct 2024 15:39:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241028023809.1554405-2-maobibo@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowMAxnsJ9Px9np9MhAA--.49621S3
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7KrWDWrW7WFWUJF1fWFW8Xwc_yoW8Ww1kpa
	sF9rn5Gr98Gas3tw1qk3W29r4DtFs8CFnFgFyUGFyvy3s0yr1Iq397Gr1q9rsrtay5Aay0
	9F4fCw1DCas3ZrXCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	XVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jOa93UUU
	UU=

在 2024/10/28 上午10:38, Bibo Mao 写道:
> since 6.11, unistd.h includes header file unistd_64.h directly on
> some platforms, here add unistd_64.h on these platforms. Affected
> platforms are ARM64, LoongArch64 and Riscv. Otherwise there will
> be compiling error such as:
>
> linux-headers/asm/unistd.h:3:10: fatal error: asm/unistd_64.h: No such file or directory
>   #include <asm/unistd_64.h>
Hi,  Bibo

Could you help tested this patch on ARM machine? I don't have an ARM 
machine.

Thanks.
Song Gao
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>   scripts/update-linux-headers.sh | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/scripts/update-linux-headers.sh b/scripts/update-linux-headers.sh
> index c34ac6454e..203f48d089 100755
> --- a/scripts/update-linux-headers.sh
> +++ b/scripts/update-linux-headers.sh
> @@ -163,6 +163,7 @@ EOF
>       fi
>       if [ $arch = arm64 ]; then
>           cp "$hdrdir/include/asm/sve_context.h" "$output/linux-headers/asm-arm64/"
> +        cp "$hdrdir/include/asm/unistd_64.h" "$output/linux-headers/asm-arm64/"
>       fi
>       if [ $arch = x86 ]; then
>           cp "$hdrdir/include/asm/unistd_32.h" "$output/linux-headers/asm-x86/"
> @@ -185,6 +186,11 @@ EOF
>       fi
>       if [ $arch = riscv ]; then
>           cp "$hdrdir/include/asm/ptrace.h" "$output/linux-headers/asm-riscv/"
> +        cp "$hdrdir/include/asm/unistd_32.h" "$output/linux-headers/asm-riscv/"
> +        cp "$hdrdir/include/asm/unistd_64.h" "$output/linux-headers/asm-riscv/"
> +    fi
> +    if [ $arch = loongarch ]; then
> +        cp "$hdrdir/include/asm/unistd_64.h" "$output/linux-headers/asm-loongarch/"
>       fi
>   done
>   arch=


