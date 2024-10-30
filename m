Return-Path: <kvm+bounces-29986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C0E99B5987
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 02:47:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCA001C20CEA
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 01:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 785C219922F;
	Wed, 30 Oct 2024 01:46:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84D7218E37B
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 01:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730252815; cv=none; b=PFSQgIu9KEeOJOo8q6uC/Mpv6oJ4OE57VYE5MW+ddPBBXkrgoCvqMNUqmG/sPkcgVT5OUdvzciwIjMDr9rmZCVPz6ZqiiVZP6dbZE8R4GAALpf+b34f0TiDToDcNImHoC3sLZ+/zjPkAe4z4b7zqu3EsJj8EYrVfADJew6Vk8AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730252815; c=relaxed/simple;
	bh=a62FOcKQ6QMdWmbT6NSocERxpVBGaek55B6zn7W3dz0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=c+jMrlizJjNF9sr3worLNjPytNJuCQykFT0aVeRhBQ79aTBJyEDC2Ibw3SYhbDdzfURBGCauAFWrhYZl7QV6P0CjuCBNikzMbxUA/CPi97Zo2V8QkdY4asKfiFEfcr9TZniCWL03bwWK3PZZ6X+6as+gYrwj+Y6UToVq0iEV+cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.239])
	by gateway (Coremail) with SMTP id _____8DxQK8JkCFnjUYdAA--.36702S3;
	Wed, 30 Oct 2024 09:46:49 +0800 (CST)
Received: from [10.20.42.239] (unknown [10.20.42.239])
	by front1 (Coremail) with SMTP id qMiowMAxDEcFkCFnWjooAA--.22887S3;
	Wed, 30 Oct 2024 09:46:47 +0800 (CST)
Subject: Re: [PATCH v3 1/3] linux-headers: Add unistd_64.h
To: maobibo <maobibo@loongson.cn>, Peter Maydell <peter.maydell@linaro.org>,
 Alistair Francis <alistair.francis@wdc.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Bin Meng <bmeng.cn@gmail.com>,
 Cornelia Huck <cohuck@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20241028023809.1554405-1-maobibo@loongson.cn>
 <20241028023809.1554405-2-maobibo@loongson.cn>
 <b5f4a39a-278a-1918-29f2-b9da197ce055@loongson.cn>
 <08fa5950-8ca4-b6fc-fac7-77bc5c16893a@loongson.cn>
From: gaosong <gaosong@loongson.cn>
Message-ID: <8b7dfe0f-f4cd-d61a-c850-d92b5aec39e8@loongson.cn>
Date: Wed, 30 Oct 2024 09:47:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <08fa5950-8ca4-b6fc-fac7-77bc5c16893a@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowMAxDEcFkCFnWjooAA--.22887S3
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7Kry7XF43tF18ur1fAw1xXrc_yoW8Kw43pr
	yvyF18Cr98G3s3tw129w12grWUtF4DC3ZFqryUGFyvvrWDtr1IgrsrWr1q9r4DJayrAF1j
	vF43Gw15Z3WfXrXCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWU
	AwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUc9a9UUUUU

在 2024/10/28 下午5:55, maobibo 写道:
>
>
> On 2024/10/28 下午3:39, gaosong wrote:
>> 在 2024/10/28 上午10:38, Bibo Mao 写道:
>>> since 6.11, unistd.h includes header file unistd_64.h directly on
>>> some platforms, here add unistd_64.h on these platforms. Affected
>>> platforms are ARM64, LoongArch64 and Riscv. Otherwise there will
>>> be compiling error such as:
>>>
>>> linux-headers/asm/unistd.h:3:10: fatal error: asm/unistd_64.h: No 
>>> such file or directory
>>>   #include <asm/unistd_64.h>
>> Hi,  Bibo
>>
>> Could you help tested this patch on ARM machine? I don't have an ARM 
>> machine.
> yeap, I test on arm64 machine, it passes to compile with header files 
> updated. However there is no riscv machine by hand.
>
Thank you,

@Peter and  @Alistair Francis Could you help tested this patch on RISCV 
machine?

Thanks.
Song Gao

> Regards
> Bibo Mao
>>
>> Thanks.
>> Song Gao
>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>> ---
>>>   scripts/update-linux-headers.sh | 6 ++++++
>>>   1 file changed, 6 insertions(+)
>>>
>>> diff --git a/scripts/update-linux-headers.sh 
>>> b/scripts/update-linux-headers.sh
>>> index c34ac6454e..203f48d089 100755
>>> --- a/scripts/update-linux-headers.sh
>>> +++ b/scripts/update-linux-headers.sh
>>> @@ -163,6 +163,7 @@ EOF
>>>       fi
>>>       if [ $arch = arm64 ]; then
>>>           cp "$hdrdir/include/asm/sve_context.h" 
>>> "$output/linux-headers/asm-arm64/"
>>> +        cp "$hdrdir/include/asm/unistd_64.h" 
>>> "$output/linux-headers/asm-arm64/"
>>>       fi
>>>       if [ $arch = x86 ]; then
>>>           cp "$hdrdir/include/asm/unistd_32.h" 
>>> "$output/linux-headers/asm-x86/"
>>> @@ -185,6 +186,11 @@ EOF
>>>       fi
>>>       if [ $arch = riscv ]; then
>>>           cp "$hdrdir/include/asm/ptrace.h" 
>>> "$output/linux-headers/asm-riscv/"
>>> +        cp "$hdrdir/include/asm/unistd_32.h" 
>>> "$output/linux-headers/asm-riscv/"
>>> +        cp "$hdrdir/include/asm/unistd_64.h" 
>>> "$output/linux-headers/asm-riscv/"
>>> +    fi
>>> +    if [ $arch = loongarch ]; then
>>> +        cp "$hdrdir/include/asm/unistd_64.h" 
>>> "$output/linux-headers/asm-loongarch/"
>>>       fi
>>>   done
>>>   arch=
>>


