Return-Path: <kvm+bounces-5514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A15B8229CB
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 09:54:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FADF1C2310E
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 08:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 449EB182BE;
	Wed,  3 Jan 2024 08:54:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0E03182A2;
	Wed,  3 Jan 2024 08:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8AxkOmxIJVl3HsBAA--.1600S3;
	Wed, 03 Jan 2024 16:54:09 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxG76vIJVl+pUYAA--.44880S3;
	Wed, 03 Jan 2024 16:54:09 +0800 (CST)
Subject: Re: [PATCH 4/5] LoongArch: Add paravirt interface for guest kernel
To: Juergen Gross <jgross@suse.com>, Huacai Chen <chenhuacai@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
References: <20240103071615.3422264-1-maobibo@loongson.cn>
 <20240103071615.3422264-5-maobibo@loongson.cn>
 <66c15a1b-fb28-4653-982f-37494a01cd4f@suse.com>
 <4240d67f-1e5d-f865-c16e-32b64aea8099@loongson.cn>
 <df32d011-49c8-4bdb-a695-41cb6fbdf854@suse.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <b8b2330d-9057-ff9b-b5aa-483c0f573a72@loongson.cn>
Date: Wed, 3 Jan 2024 16:54:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <df32d011-49c8-4bdb-a695-41cb6fbdf854@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxG76vIJVl+pUYAA--.44880S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxJrykKFW5Cry5WF4fKw1ruFX_yoW8JFWrpF
	WS9asFkF48CF42yr4xKr4kZr1Y9rZrKr15Wa4rXry0v39xZw1Fvr4FgF1a9a4DAr1UC3Wj
	qFWjq3srW3WDAFXCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Sb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv
	67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C2
	67AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI
	8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWU
	CwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBI
	daVFxhVjvjDU0xZFpf9x07jYSoJUUUUU=



On 2024/1/3 下午4:14, Juergen Gross wrote:
> On 03.01.24 09:00, maobibo wrote:
>>
>>
>> On 2024/1/3 下午3:40, Jürgen Groß wrote:
>>> On 03.01.24 08:16, Bibo Mao wrote:
>>>> The patch add paravirt interface for guest kernel, it checks whether
>>>> system runs on VM mode. If it is, it will detect hypervisor type. And
>>>> returns true it is KVM hypervisor, else return false. Currently only
>>>> KVM hypervisor is supported, so there is only hypervisor detection
>>>> for KVM type.
>>>
>>> I guess you are talking of pv_guest_init() here? Or do you mean
>>> kvm_para_available()?
>> yes, it is pv_guest_init. It will be better if all hypervisor detection
>> is called in function pv_guest_init. Currently there is only kvm 
>> hypervisor, kvm_para_available is hard-coded in pv_guest_init here.
> 
> I think this is no problem as long as there are not more hypervisors
> supported.
> 
>>
>> I can split file paravirt.c into paravirt.c and kvm.c, paravirt.c is 
>> used for hypervisor detection, and move code relative with pv_ipi into 
>> kvm.c
> 
> I wouldn't do that right now.
> 
> Just be a little bit more specific in the commit message (use the related
> function name instead of "it").
Sure, will do this in next version, and thanks for your guidance.

Regards
Bibo Mao
> 
> 
> Juergen


