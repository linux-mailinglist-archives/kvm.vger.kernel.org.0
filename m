Return-Path: <kvm+bounces-69653-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2J/PIdMKfGkEKQIAu9opvQ
	(envelope-from <kvm+bounces-69653-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 02:35:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0724FB62F0
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 02:35:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CDE193013693
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 01:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C02B932FA2D;
	Fri, 30 Jan 2026 01:35:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E21AE27703E;
	Fri, 30 Jan 2026 01:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769736905; cv=none; b=a/9kJcS5nZS6VhL8fkv9CvylK84mD9Xw1cLO7BxJ1zn9DMbtLEJe9x0cuLUWFX1SB7/tyKlNFHmfaS5vhGww32t3kVPmOLXyj6VyF0nGZOss1DivaHsc8fvl+nydPcEvIDGn3JJk14U9syeVFSnxmnUpq0HakwP/kbUf4XlWLMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769736905; c=relaxed/simple;
	bh=O57/Sy8QiVizVgXb3NALOQ82MULBFs8I1qptiIbqQ+0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=e04oAiR7oHxTbqHoOhLy8yhQ20SSASP5BnZuO/cE7aPX6m9tb+5+Rd319DeQWPy4rvVsxRw9Hn0R/KmPXwP13b1GPYHVLLecjcoC3Y2xAeuSFDMTubgkpAC8M/i3KHqA6O2MTla0mHV9cVcCb0JIoOp3Iga34Y6Lxq8nbaGsHOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxLMPECnxpmR4OAA--.46472S3;
	Fri, 30 Jan 2026 09:35:00 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJCxHOHBCnxph+E5AA--.45367S3;
	Fri, 30 Jan 2026 09:34:59 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: Set default return value in kvm IO bus
 ops
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, loongarch@lists.linux.dev
References: <20251210025623.343511-1-maobibo@loongson.cn>
 <CAAhV-H5pTS0A54gW9mOZxjqXYXcjGx=EXFH6-QO-75T0XoqYsA@mail.gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <ab998710-637c-315b-ca49-8346f671abab@loongson.cn>
Date: Fri, 30 Jan 2026 09:32:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H5pTS0A54gW9mOZxjqXYXcjGx=EXFH6-QO-75T0XoqYsA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxHOHBCnxph+E5AA--.45367S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Gw18XFyfuF47uw48Kr18Xrc_yoWfKrykpr
	WUZFZ8Zw4rtryxWryvqwn8WFnIv392gr1Iv3yDGaySkF4Dtr9xtFy8JrWjvFyjk34DGF40
	qF4rJFy3uF45JacCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8JVW8Jr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU2nYF
	DUUUU
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	R_DKIM_NA(0.00)[];
	DMARC_NA(0.00)[loongson.cn];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69653-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[loongson.cn:mid,loongson.cn:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0724FB62F0
X-Rspamd-Action: no action



On 2026/1/29 下午8:44, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Wed, Dec 10, 2025 at 10:56 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> When irqchip in kernel is enabled, its register area is registered
>> in the IO bus list with API kvm_io_bus_register_dev(). In MMIO/IOCSR
>> register access emulation, kvm_io_bus_write/kvm_io_bus_read is called
>> firstly. If it returns 0, it shows that in kernel irqchip handles
>> the emulation already, else it returns to VMM and lets VMM emulate
>> the register access.
>>
>> Once irqchip in kernel is enabled, it should return 0 if the address
>> is within range of the registered IO bus. It should not return to VMM
>> since VMM does not know how to handle it, and irqchip is handled in
>> kernel already.
>>
>> Here set default return value with 0 in KVM IO bus operations.
> If you are sure that both the good path and bad path should both
> return 0, please check whether mail_send() and send_ipi_data() should
> also change.
yes, there should be similiar modification with mail_send() and 
send_ipi_data(). Will update the patch in next version.

Regards
Bibo Mao
> 
> Huacai
> 
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/kvm/intc/eiointc.c | 28 ++++++++++++----------------
>>   arch/loongarch/kvm/intc/ipi.c     | 10 ++--------
>>   arch/loongarch/kvm/intc/pch_pic.c | 31 ++++++++++++++-----------------
>>   3 files changed, 28 insertions(+), 41 deletions(-)
>>
>> diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
>> index 29886876143f..7ca9dfea7f39 100644
>> --- a/arch/loongarch/kvm/intc/eiointc.c
>> +++ b/arch/loongarch/kvm/intc/eiointc.c
>> @@ -119,7 +119,7 @@ void eiointc_set_irq(struct loongarch_eiointc *s, int irq, int level)
>>   static int loongarch_eiointc_read(struct kvm_vcpu *vcpu, struct loongarch_eiointc *s,
>>                                  gpa_t addr, unsigned long *val)
>>   {
>> -       int index, ret = 0;
>> +       int index;
>>          u64 data = 0;
>>          gpa_t offset;
>>
>> @@ -150,30 +150,29 @@ static int loongarch_eiointc_read(struct kvm_vcpu *vcpu, struct loongarch_eioint
>>                  data = s->coremap[index];
>>                  break;
>>          default:
>> -               ret = -EINVAL;
>>                  break;
>>          }
>>          *val = data;
>>
>> -       return ret;
>> +       return 0;
>>   }
>>
>>   static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
>>                          struct kvm_io_device *dev,
>>                          gpa_t addr, int len, void *val)
>>   {
>> -       int ret = -EINVAL;
>> +       int ret = 0;
>>          unsigned long flags, data, offset;
>>          struct loongarch_eiointc *eiointc = vcpu->kvm->arch.eiointc;
>>
>>          if (!eiointc) {
>>                  kvm_err("%s: eiointc irqchip not valid!\n", __func__);
>> -               return -EINVAL;
>> +               return ret;
>>          }
>>
>>          if (addr & (len - 1)) {
>>                  kvm_err("%s: eiointc not aligned addr %llx len %d\n", __func__, addr, len);
>> -               return -EINVAL;
>> +               return ret;
>>          }
>>
>>          offset = addr & 0x7;
>> @@ -208,7 +207,7 @@ static int loongarch_eiointc_write(struct kvm_vcpu *vcpu,
>>                                  struct loongarch_eiointc *s,
>>                                  gpa_t addr, u64 value, u64 field_mask)
>>   {
>> -       int index, irq, ret = 0;
>> +       int index, irq;
>>          u8 cpu;
>>          u64 data, old, mask;
>>          gpa_t offset;
>> @@ -287,29 +286,28 @@ static int loongarch_eiointc_write(struct kvm_vcpu *vcpu,
>>                  eiointc_update_sw_coremap(s, index * 8, data, sizeof(data), true);
>>                  break;
>>          default:
>> -               ret = -EINVAL;
>>                  break;
>>          }
>>
>> -       return ret;
>> +       return 0;
>>   }
>>
>>   static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
>>                          struct kvm_io_device *dev,
>>                          gpa_t addr, int len, const void *val)
>>   {
>> -       int ret = -EINVAL;
>> +       int ret = 0;
>>          unsigned long flags, value;
>>          struct loongarch_eiointc *eiointc = vcpu->kvm->arch.eiointc;
>>
>>          if (!eiointc) {
>>                  kvm_err("%s: eiointc irqchip not valid!\n", __func__);
>> -               return -EINVAL;
>> +               return ret;
>>          }
>>
>>          if (addr & (len - 1)) {
>>                  kvm_err("%s: eiointc not aligned addr %llx len %d\n", __func__, addr, len);
>> -               return -EINVAL;
>> +               return ret;
>>          }
>>
>>          vcpu->stat.eiointc_write_exits++;
>> @@ -352,7 +350,7 @@ static int kvm_eiointc_virt_read(struct kvm_vcpu *vcpu,
>>
>>          if (!eiointc) {
>>                  kvm_err("%s: eiointc irqchip not valid!\n", __func__);
>> -               return -EINVAL;
>> +               return 0;
>>          }
>>
>>          addr -= EIOINTC_VIRT_BASE;
>> @@ -383,21 +381,19 @@ static int kvm_eiointc_virt_write(struct kvm_vcpu *vcpu,
>>
>>          if (!eiointc) {
>>                  kvm_err("%s: eiointc irqchip not valid!\n", __func__);
>> -               return -EINVAL;
>> +               return ret;
>>          }
>>
>>          addr -= EIOINTC_VIRT_BASE;
>>          spin_lock_irqsave(&eiointc->lock, flags);
>>          switch (addr) {
>>          case EIOINTC_VIRT_FEATURES:
>> -               ret = -EPERM;
>>                  break;
>>          case EIOINTC_VIRT_CONFIG:
>>                  /*
>>                   * eiointc features can only be set at disabled status
>>                   */
>>                  if ((eiointc->status & BIT(EIOINTC_ENABLE)) && value) {
>> -                       ret = -EPERM;
>>                          break;
>>                  }
>>                  eiointc->status = value & eiointc->features;
>> diff --git a/arch/loongarch/kvm/intc/ipi.c b/arch/loongarch/kvm/intc/ipi.c
>> index 05cefd29282e..311cbb66821d 100644
>> --- a/arch/loongarch/kvm/intc/ipi.c
>> +++ b/arch/loongarch/kvm/intc/ipi.c
>> @@ -174,7 +174,7 @@ static int any_send(struct kvm *kvm, uint64_t data)
>>          vcpu = kvm_get_vcpu_by_cpuid(kvm, cpu);
>>          if (unlikely(vcpu == NULL)) {
>>                  kvm_err("%s: invalid target cpu: %d\n", __func__, cpu);
>> -               return -EINVAL;
>> +               return 0;
>>          }
>>          offset = data & 0xffff;
>>
>> @@ -183,7 +183,6 @@ static int any_send(struct kvm *kvm, uint64_t data)
>>
>>   static int loongarch_ipi_readl(struct kvm_vcpu *vcpu, gpa_t addr, int len, void *val)
>>   {
>> -       int ret = 0;
>>          uint32_t offset;
>>          uint64_t res = 0;
>>
>> @@ -211,19 +210,17 @@ static int loongarch_ipi_readl(struct kvm_vcpu *vcpu, gpa_t addr, int len, void
>>                  if (offset + len > IOCSR_IPI_BUF_38 + 8) {
>>                          kvm_err("%s: invalid offset or len: offset = %d, len = %d\n",
>>                                  __func__, offset, len);
>> -                       ret = -EINVAL;
>>                          break;
>>                  }
>>                  res = read_mailbox(vcpu, offset, len);
>>                  break;
>>          default:
>>                  kvm_err("%s: unknown addr: %llx\n", __func__, addr);
>> -               ret = -EINVAL;
>>                  break;
>>          }
>>          *(uint64_t *)val = res;
>>
>> -       return ret;
>> +       return 0;
>>   }
>>
>>   static int loongarch_ipi_writel(struct kvm_vcpu *vcpu, gpa_t addr, int len, const void *val)
>> @@ -239,7 +236,6 @@ static int loongarch_ipi_writel(struct kvm_vcpu *vcpu, gpa_t addr, int len, cons
>>
>>          switch (offset) {
>>          case IOCSR_IPI_STATUS:
>> -               ret = -EINVAL;
>>                  break;
>>          case IOCSR_IPI_EN:
>>                  spin_lock(&vcpu->arch.ipi_state.lock);
>> @@ -257,7 +253,6 @@ static int loongarch_ipi_writel(struct kvm_vcpu *vcpu, gpa_t addr, int len, cons
>>                  if (offset + len > IOCSR_IPI_BUF_38 + 8) {
>>                          kvm_err("%s: invalid offset or len: offset = %d, len = %d\n",
>>                                  __func__, offset, len);
>> -                       ret = -EINVAL;
>>                          break;
>>                  }
>>                  write_mailbox(vcpu, offset, data, len);
>> @@ -273,7 +268,6 @@ static int loongarch_ipi_writel(struct kvm_vcpu *vcpu, gpa_t addr, int len, cons
>>                  break;
>>          default:
>>                  kvm_err("%s: unknown addr: %llx\n", __func__, addr);
>> -               ret = -EINVAL;
>>                  break;
>>          }
>>
>> diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/intc/pch_pic.c
>> index a698a73de399..773885f8d659 100644
>> --- a/arch/loongarch/kvm/intc/pch_pic.c
>> +++ b/arch/loongarch/kvm/intc/pch_pic.c
>> @@ -74,7 +74,7 @@ void pch_msi_set_irq(struct kvm *kvm, int irq, int level)
>>
>>   static int loongarch_pch_pic_read(struct loongarch_pch_pic *s, gpa_t addr, int len, void *val)
>>   {
>> -       int ret = 0, offset;
>> +       int offset;
>>          u64 data = 0;
>>          void *ptemp;
>>
>> @@ -121,34 +121,32 @@ static int loongarch_pch_pic_read(struct loongarch_pch_pic *s, gpa_t addr, int l
>>                  data = s->isr;
>>                  break;
>>          default:
>> -               ret = -EINVAL;
>> +               break;
>>          }
>>          spin_unlock(&s->lock);
>>
>> -       if (ret == 0) {
>> -               offset = (addr - s->pch_pic_base) & 7;
>> -               data = data >> (offset * 8);
>> -               memcpy(val, &data, len);
>> -       }
>> +       offset = (addr - s->pch_pic_base) & 7;
>> +       data = data >> (offset * 8);
>> +       memcpy(val, &data, len);
>>
>> -       return ret;
>> +       return 0;
>>   }
>>
>>   static int kvm_pch_pic_read(struct kvm_vcpu *vcpu,
>>                          struct kvm_io_device *dev,
>>                          gpa_t addr, int len, void *val)
>>   {
>> -       int ret;
>> +       int ret = 0;
>>          struct loongarch_pch_pic *s = vcpu->kvm->arch.pch_pic;
>>
>>          if (!s) {
>>                  kvm_err("%s: pch pic irqchip not valid!\n", __func__);
>> -               return -EINVAL;
>> +               return ret;
>>          }
>>
>>          if (addr & (len - 1)) {
>>                  kvm_err("%s: pch pic not aligned addr %llx len %d\n", __func__, addr, len);
>> -               return -EINVAL;
>> +               return ret;
>>          }
>>
>>          /* statistics of pch pic reading */
>> @@ -161,7 +159,7 @@ static int kvm_pch_pic_read(struct kvm_vcpu *vcpu,
>>   static int loongarch_pch_pic_write(struct loongarch_pch_pic *s, gpa_t addr,
>>                                          int len, const void *val)
>>   {
>> -       int ret = 0, offset;
>> +       int offset;
>>          u64 old, data, mask;
>>          void *ptemp;
>>
>> @@ -226,29 +224,28 @@ static int loongarch_pch_pic_write(struct loongarch_pch_pic *s, gpa_t addr,
>>          case PCH_PIC_ROUTE_ENTRY_START ... PCH_PIC_ROUTE_ENTRY_END:
>>                  break;
>>          default:
>> -               ret = -EINVAL;
>>                  break;
>>          }
>>          spin_unlock(&s->lock);
>>
>> -       return ret;
>> +       return 0;
>>   }
>>
>>   static int kvm_pch_pic_write(struct kvm_vcpu *vcpu,
>>                          struct kvm_io_device *dev,
>>                          gpa_t addr, int len, const void *val)
>>   {
>> -       int ret;
>> +       int ret = 0;
>>          struct loongarch_pch_pic *s = vcpu->kvm->arch.pch_pic;
>>
>>          if (!s) {
>>                  kvm_err("%s: pch pic irqchip not valid!\n", __func__);
>> -               return -EINVAL;
>> +               return ret;
>>          }
>>
>>          if (addr & (len - 1)) {
>>                  kvm_err("%s: pch pic not aligned addr %llx len %d\n", __func__, addr, len);
>> -               return -EINVAL;
>> +               return ret;
>>          }
>>
>>          /* statistics of pch pic writing */
>>
>> base-commit: c9b47175e9131118e6f221cc8fb81397d62e7c91
>> --
>> 2.39.3
>>
>>


