Return-Path: <kvm+bounces-22281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3499393CD08
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 05:35:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5D2B282D77
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 03:35:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11E1025624;
	Fri, 26 Jul 2024 03:35:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE96123B0;
	Fri, 26 Jul 2024 03:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721964910; cv=none; b=S0lR98RkPgkUbhgBXg1eEfqy/p1/T8E6p+exlonb4DXWzMINKvxXeA/sThxTzDFNl30dy0LuOE3d5uXnSIxe8f53MX+MkAY7kyA2KEAjwfULfEdM+fEYgAPQpzYdOdpDkw01CaX1AXYXKo+x96KMOGsOcq2zkKXRq/tui8JqQV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721964910; c=relaxed/simple;
	bh=A9aJNiurICviezCurKvMzRiVwN9W5WJ3FN+2sqPkURg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=P6+jDwNiA5PTi6RE0gQcguHYP38cCJISOVQPE1q2+NfcapZ3OXPgtpmHgEUCUeBvkDrVMBYWTN0vGyx+Awv6vCsb06O625FGb0m6vl5r/KqanvUsAPyyR78OSQOPMsbo5HVPeGDMgP22SDxrF9tqdYyYCQWNtPE7GDYgSe1Nqng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Ax2eliGaNmA+YBAA--.6996S3;
	Fri, 26 Jul 2024 11:34:58 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMAxHsdgGaNmISMCAA--.12641S3;
	Fri, 26 Jul 2024 11:34:58 +0800 (CST)
Subject: Re: [PATCH] KVM: Loongarch: Remove undefined a6 argument comment for
 kvm_hypercall
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Dandan Zhang <zhangdandan@uniontech.com>, zhaotianrui@loongson.cn,
 kernel@xen0n.name, kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, wangyuli@uniontech.com,
 Wentao Guan <guanwentao@uniontech.com>
References: <6D5128458C9E19E4+20240725134820.55817-1-zhangdandan@uniontech.com>
 <c40854ac-38ef-4781-6c6b-4f74e24f265c@loongson.cn>
 <CAAhV-H5R_kamf=YJ62hb+iFr7Y+cvCaBBrY1rdk_wEEq4+6D_w@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <a9245b66-be6e-7211-49dd-a9a2d23ec2cf@loongson.cn>
Date: Fri, 26 Jul 2024 11:34:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H5R_kamf=YJ62hb+iFr7Y+cvCaBBrY1rdk_wEEq4+6D_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAxHsdgGaNmISMCAA--.12641S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7ur47Zw1UCFy5XrWxtw45XFc_yoW8Cr4rpF
	ZxA3WvkF48Kr1fC34xtrs8uryagrZ7Gw12gF98W345CrsFvwn3tr48tF1DuF1kAw1rJF4F
	qFya93WfZFyUA3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9ab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE
	14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E
	14v26r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
	CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1x
	MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsG
	vfC2KfnxnUUI43ZEXa7IU8vApUUUUUU==



On 2024/7/26 上午10:55, Huacai Chen wrote:
> On Fri, Jul 26, 2024 at 9:49 AM maobibo <maobibo@loongson.cn> wrote:
>>
>>
>>
>> On 2024/7/25 下午9:48, Dandan Zhang wrote:
>>> The kvm_hypercall set for LoongArch is limited to a1-a5.
>>> The mention of a6 in the comment is undefined that needs to be rectified.
>>>
>>> Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
>>> Signed-off-by: Dandan Zhang <zhangdandan@uniontech.com>
>>> ---
>>>    arch/loongarch/include/asm/kvm_para.h | 4 ++--
>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
>>> index 335fb86778e2..43ec61589e6c 100644
>>> --- a/arch/loongarch/include/asm/kvm_para.h
>>> +++ b/arch/loongarch/include/asm/kvm_para.h
>>> @@ -39,9 +39,9 @@ struct kvm_steal_time {
>>>     * Hypercall interface for KVM hypervisor
>>>     *
>>>     * a0: function identifier
>>> - * a1-a6: args
>>> + * a1-a5: args
>>>     * Return value will be placed in a0.
>>> - * Up to 6 arguments are passed in a1, a2, a3, a4, a5, a6.
>>> + * Up to 5 arguments are passed in a1, a2, a3, a4, a5.
>>>     */
>>>    static __always_inline long kvm_hypercall0(u64 fid)
>>>    {
>>>
>>
>> Dandan,
>>
>> Nice catch. In future hypercall abi may expand such as the number of
>> input register and output register, or async hypercall function if there
>> is really such requirement.
>>
>> Anyway the modification is deserved and it is enough to use now, thanks
>> for doing it.
>>
>> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> Maybe it is better to implement kvm_hypercall6() than remove a6 now?
That is one option also. The main reason is that there is no such 
requirement in near future :(, I prefer to removing the annotation and 
keeping it clean.

Regards
Bibo Mao
> 
> Huacai
>>


