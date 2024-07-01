Return-Path: <kvm+bounces-20746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EDB991D5C4
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 03:28:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40DCD1C20CA4
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 01:27:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2648B748E;
	Mon,  1 Jul 2024 01:27:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF5A94C69;
	Mon,  1 Jul 2024 01:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719797269; cv=none; b=ZjkxbbtMAqfOC76zsEYScCaZe8roYF/nXulvk9kxtjFfGYlgtH0jJaZ+huRts0aYh+s7smQcuthnZDmYwESiHAwU0sVxW3weWx/t5tZNrCb9ruiCI+fr4ROeG0LcCK1ylUO8BBzLjrpyhZNmAipBdOOgerMWaNX8EEnSgl6+sXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719797269; c=relaxed/simple;
	bh=2L0dXZysX/b1ARLPqrRyaQbeY7QWIHYTKIyECCNDMMg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=VLCkNdn2dyiW8CR8pD6/SSF2DM+oGbSfKKRUs6cOrfbptAjQKSXNCfxCim6KxeH6+HxyxClaL3ubx4W9j4CVtBGhST9XgRtFau+x6lV98MgTqqtuv17DPU/XFWhUhFKJGJP71s2jGuHVRX2vIn2rLbIFzgcrPV28fdYLuYED9AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxnLoHBoJmNsELAA--.1745S3;
	Mon, 01 Jul 2024 09:27:35 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxZcUFBoJmDvg2AA--.52300S3;
	Mon, 01 Jul 2024 09:27:35 +0800 (CST)
Subject: Re: [PATCH v4 2/3] LoongArch: KVM: Add LBT feature detection function
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240626063239.3722175-1-maobibo@loongson.cn>
 <20240626063239.3722175-3-maobibo@loongson.cn>
 <CAAhV-H4O8QNb61xkErd9y_1tK_70=Y=LNqzy=9Ny5EQK1XZJaQ@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <79dcf093-614f-2737-bb03-698b0b3abc57@loongson.cn>
Date: Mon, 1 Jul 2024 09:27:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4O8QNb61xkErd9y_1tK_70=Y=LNqzy=9Ny5EQK1XZJaQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxZcUFBoJmDvg2AA--.52300S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxGFW5XF4UKF4kWr4UuFW7trc_yoW7Jr47pr
	yjyFs8GrW8Gr1xC3Z5tws09w43XF4xCr4xuFyxKFWayFn0vryxG34vkrZxCFy5X3y8Wa4I
	93Z7Aa12vFs0y3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzV
	AYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8czVUUU
	UUU==


Huacai,

On 2024/6/30 上午10:07, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Wed, Jun 26, 2024 at 2:32 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> Two kinds of LBT feature detection are added here, one is VCPU
>> feature, the other is VM feature. VCPU feature dection can only
>> work with VCPU thread itself, and requires VCPU thread is created
>> already. So LBT feature detection for VM is added also, it can
>> be done even if VM is not created, and also can be done by any
>> thread besides VCPU threads.
>>
>> Loongson Binary Translation (LBT) feature is defined in register
>> cpucfg2. Here LBT capability detection for VCPU is added.
>>
>> Here ioctl command KVM_HAS_DEVICE_ATTR is added for VM, and macro
>> KVM_LOONGARCH_VM_FEAT_CTRL is added to check supported feature. And
>> three sub-features relative with LBT are added as following:
>>   KVM_LOONGARCH_VM_FEAT_X86BT
>>   KVM_LOONGARCH_VM_FEAT_ARMBT
>>   KVM_LOONGARCH_VM_FEAT_MIPSBT
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/include/uapi/asm/kvm.h |  6 ++++
>>   arch/loongarch/kvm/vcpu.c             |  6 ++++
>>   arch/loongarch/kvm/vm.c               | 44 ++++++++++++++++++++++++++-
>>   3 files changed, 55 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
>> index ddc5cab0ffd0..c40f7d9ffe13 100644
>> --- a/arch/loongarch/include/uapi/asm/kvm.h
>> +++ b/arch/loongarch/include/uapi/asm/kvm.h
>> @@ -82,6 +82,12 @@ struct kvm_fpu {
>>   #define KVM_IOC_CSRID(REG)             LOONGARCH_REG_64(KVM_REG_LOONGARCH_CSR, REG)
>>   #define KVM_IOC_CPUCFG(REG)            LOONGARCH_REG_64(KVM_REG_LOONGARCH_CPUCFG, REG)
>>
>> +/* Device Control API on vm fd */
>> +#define KVM_LOONGARCH_VM_FEAT_CTRL     0
>> +#define  KVM_LOONGARCH_VM_FEAT_X86BT   0
>> +#define  KVM_LOONGARCH_VM_FEAT_ARMBT   1
>> +#define  KVM_LOONGARCH_VM_FEAT_MIPSBT  2
>> +
>>   /* Device Control API on vcpu fd */
>>   #define KVM_LOONGARCH_VCPU_CPUCFG      0
>>   #define KVM_LOONGARCH_VCPU_PVTIME_CTRL 1
> If you insist that LBT should be a vm feature, then I suggest the
> above two also be vm features. Though this is an UAPI change, but
> CPUCFG is upstream in 6.10-rc1 and 6.10-final hasn't been released. We
> have a chance to change it now.

KVM_LOONGARCH_VCPU_PVTIME_CTRL need be attr percpu since every vcpu
has is own different gpa address.

For KVM_LOONGARCH_VCPU_CPUCFG attr, it will not changed. We cannot break
the API even if it is 6.10-rc1, VMM has already used this. Else there is
uapi breaking now, still will be in future if we cannot control this.

How about adding new extra features capability for VM such as?
+#define  KVM_LOONGARCH_VM_FEAT_LSX   3
+#define  KVM_LOONGARCH_VM_FEAT_LASX  4

Regards
Bibo Mao
> 
> Huacai
> 
>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>> index 233d28d0e928..9734b4d8db05 100644
>> --- a/arch/loongarch/kvm/vcpu.c
>> +++ b/arch/loongarch/kvm/vcpu.c
>> @@ -565,6 +565,12 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
>>                          *v |= CPUCFG2_LSX;
>>                  if (cpu_has_lasx)
>>                          *v |= CPUCFG2_LASX;
>> +               if (cpu_has_lbt_x86)
>> +                       *v |= CPUCFG2_X86BT;
>> +               if (cpu_has_lbt_arm)
>> +                       *v |= CPUCFG2_ARMBT;
>> +               if (cpu_has_lbt_mips)
>> +                       *v |= CPUCFG2_MIPSBT;
>>
>>                  return 0;
>>          case LOONGARCH_CPUCFG3:
>> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
>> index 6b2e4f66ad26..09e05108c68b 100644
>> --- a/arch/loongarch/kvm/vm.c
>> +++ b/arch/loongarch/kvm/vm.c
>> @@ -99,7 +99,49 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>          return r;
>>   }
>>
>> +static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>> +{
>> +       switch (attr->attr) {
>> +       case KVM_LOONGARCH_VM_FEAT_X86BT:
>> +               if (cpu_has_lbt_x86)
>> +                       return 0;
>> +               return -ENXIO;
>> +       case KVM_LOONGARCH_VM_FEAT_ARMBT:
>> +               if (cpu_has_lbt_arm)
>> +                       return 0;
>> +               return -ENXIO;
>> +       case KVM_LOONGARCH_VM_FEAT_MIPSBT:
>> +               if (cpu_has_lbt_mips)
>> +                       return 0;
>> +               return -ENXIO;
>> +       default:
>> +               return -ENXIO;
>> +       }
>> +}
>> +
>> +static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>> +{
>> +       switch (attr->group) {
>> +       case KVM_LOONGARCH_VM_FEAT_CTRL:
>> +               return kvm_vm_feature_has_attr(kvm, attr);
>> +       default:
>> +               return -ENXIO;
>> +       }
>> +}
>> +
>>   int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>>   {
>> -       return -ENOIOCTLCMD;
>> +       struct kvm *kvm = filp->private_data;
>> +       void __user *argp = (void __user *)arg;
>> +       struct kvm_device_attr attr;
>> +
>> +       switch (ioctl) {
>> +       case KVM_HAS_DEVICE_ATTR:
>> +               if (copy_from_user(&attr, argp, sizeof(attr)))
>> +                       return -EFAULT;
>> +
>> +               return kvm_vm_has_attr(kvm, &attr);
>> +       default:
>> +               return -EINVAL;
>> +       }
>>   }
>> --
>> 2.39.3
>>


