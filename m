Return-Path: <kvm+bounces-30276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C6029B89D7
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 04:17:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D28C1C20909
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 03:17:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E1B815252D;
	Fri,  1 Nov 2024 03:15:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6162B148317
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 03:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730430956; cv=none; b=JdBnEK/MBLmwCutSlyIB12Wi8sr5fWEXDGtPB3ejMFa4+VLYuWUZvEemrSH3Jvy4yxkOzoc5WA+iCY+O2VZ9jbcZ45f61+YOBlmSA8DhYSDyjP/8WxmLcLN3aD5Eo/hW/D7gjxavQTA2GCaM6tE4vmIV3VuzjdUMrI4JUhnhnb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730430956; c=relaxed/simple;
	bh=q4qrTv/a75waTKP4UL/rcqhcPePNYU1QqdJ9cmRGF6I=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=DMZ7eFCCsHMKH2a54Ck99bVVe9mm9vMC5p7fA1XWOXilvAOA5e5iGo8JFD5QzZLM9kNmd2baUIAQoRdfwJNvSNeFRb2hyeLYpSwv9snNR+QqtfqGAqsBxn2gk+Wt8vDdLA44ABNTfYio1lHnQQXlNV0o8zlGLfB6Gx6iSLjKK8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8DxmeHfRyRnHGEjAA--.8349S3;
	Fri, 01 Nov 2024 11:15:43 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMAx18DdRyRnbmwwAA--.33943S3;
	Fri, 01 Nov 2024 11:15:41 +0800 (CST)
Subject: Re: [PATCH v3 1/3] linux-headers: Add unistd_64.h
To: Alistair Francis <alistair23@gmail.com>, gaosong <gaosong@loongson.cn>
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Alistair Francis <alistair.francis@wdc.com>,
 "Michael S . Tsirkin" <mst@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Bin Meng <bmeng.cn@gmail.com>, Cornelia Huck <cohuck@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
References: <20241028023809.1554405-1-maobibo@loongson.cn>
 <20241028023809.1554405-2-maobibo@loongson.cn>
 <b5f4a39a-278a-1918-29f2-b9da197ce055@loongson.cn>
 <08fa5950-8ca4-b6fc-fac7-77bc5c16893a@loongson.cn>
 <8b7dfe0f-f4cd-d61a-c850-d92b5aec39e8@loongson.cn>
 <CAKmqyKOGcjOFqUMiySYxtCyx-5_Rbx3=w9BYeUuS8mSrQ0bhxg@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <2c13c998-746c-8119-019b-71e3d6c16b01@loongson.cn>
Date: Fri, 1 Nov 2024 11:15:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAKmqyKOGcjOFqUMiySYxtCyx-5_Rbx3=w9BYeUuS8mSrQ0bhxg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAx18DdRyRnbmwwAA--.33943S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWrZF15KFyxWr4DZr13Jw48Xwc_yoW8Jry5pa
	43AF1qyF4UWr4ftwn2kw1j9FsFvrnrKFW5XFy8Wr97Jas0kr13Xr1xJFZFkrWqv34rJFyU
	u3yakay3ZF15ZrbCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUP2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y
	6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUXVWUAwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8m9aDUUUU
	U==

It passed to compile on riscv machine, and the testbed is riscv qemu VM.

Regards
Bibo Mao

On 2024/10/30 下午12:06, Alistair Francis wrote:
> On Wed, Oct 30, 2024 at 11:47 AM gaosong <gaosong@loongson.cn> wrote:
>>
>> 在 2024/10/28 下午5:55, maobibo 写道:
>>>
>>>
>>> On 2024/10/28 下午3:39, gaosong wrote:
>>>> 在 2024/10/28 上午10:38, Bibo Mao 写道:
>>>>> since 6.11, unistd.h includes header file unistd_64.h directly on
>>>>> some platforms, here add unistd_64.h on these platforms. Affected
>>>>> platforms are ARM64, LoongArch64 and Riscv. Otherwise there will
>>>>> be compiling error such as:
>>>>>
>>>>> linux-headers/asm/unistd.h:3:10: fatal error: asm/unistd_64.h: No
>>>>> such file or directory
>>>>>    #include <asm/unistd_64.h>
>>>> Hi,  Bibo
>>>>
>>>> Could you help tested this patch on ARM machine? I don't have an ARM
>>>> machine.
>>> yeap, I test on arm64 machine, it passes to compile with header files
>>> updated. However there is no riscv machine by hand.
>>>
>> Thank you,
>>
>> @Peter and  @Alistair Francis Could you help tested this patch on RISCV
>> machine?
> 
> I don't have a RISC-V machine either unfortunately.
> 
> You can test it with QEMU though
> 
> Alistair
> 


