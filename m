Return-Path: <kvm+bounces-69791-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WEZHLhUGgGnR1gIAu9opvQ
	(envelope-from <kvm+bounces-69791-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 03:04:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 27DA6C7D32
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 03:04:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 615A13008A72
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 02:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCA6D20298D;
	Mon,  2 Feb 2026 02:03:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 607881E32D6;
	Mon,  2 Feb 2026 02:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769997828; cv=none; b=K7mnXMIkscIhVwhxTrsBGsBrGed0a0GWtmoMgxz8Q6Y3z0B+cKDgpuJxE6438lKwRrdmxn2QEu11gNXqGnBVDM4/sIS96dph8HxWkvCdaXsP7cJr695991qpiUrmQbBgOAUaWfoX0RbfT2UjjCS+e1sV/BzQ8a0Glq5iBuB89uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769997828; c=relaxed/simple;
	bh=AyEx9Vsn+zJmzDPorX/P1o+++XFEptNwuJBGpB1FtKs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=LYYthJLMGHWuwGl15CTMuBBkSOsmRxBEaynbI2nhsjucDxGpCd2ijNZXlg8S0niWrZ5xkF9HxVl9nidtAHgO+zHang+zcZqXDY+xZr0xBOleqN7YFm7SqYmv1jN6pKL+IKScy8Gi1hir5Q38P8fyaBnaLlnSzsSytsy17VJ54zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxJMH7BYBppNQOAA--.1206S3;
	Mon, 02 Feb 2026 10:03:39 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJAx38L1BYBpkrw9AA--.49183S3;
	Mon, 02 Feb 2026 10:03:35 +0800 (CST)
Subject: Re: [PATCH] KVM: LoongArch: selftests: Add steal time test case
To: Huacai Chen <chenhuacai@kernel.org>,
 "open list:LOONGARCH" <loongarch@lists.linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260129021839.3674879-1-maobibo@loongson.cn>
 <CAAhV-H5yZbocBBBN5nMqb32UaVP6i8+9X4RNAwquVYVFVRaBVg@mail.gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <865fdd00-b8ef-1e17-c1b9-1cb264e32914@loongson.cn>
Date: Mon, 2 Feb 2026 10:00:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H5yZbocBBBN5nMqb32UaVP6i8+9X4RNAwquVYVFVRaBVg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAx38L1BYBpkrw9AA--.49183S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxuF4fZF13tw17Jw45KF18tFc_yoWrKr1xpF
	Z2kFs0gFW0gr1xJr1kJ3yDuFsIqrs2kr4IvFy7Xr45Ar4vyrs7Jry09rW7KFn8Zws5WF1S
	v3WSgFsruF4DJ3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzV
	AYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8zwZ7UU
	UUU==
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[loongson.cn:mid,loongson.cn:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_SENDER_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_SEVEN(0.00)[7];
	R_DKIM_NA(0.00)[];
	DMARC_NA(0.00)[loongson.cn];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-69791-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[]
X-Rspamd-Queue-Id: 27DA6C7D32
X-Rspamd-Action: no action

Hi Huacai,

On 2026/1/31 下午9:47, Huacai Chen wrote:
> Since paravirt preempt is also applied, I applied this one with some
> modifications, you can check whether it is correct.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.git/commit/?h=loongarch-kvm&id=cf991b57ffc808d69cb1f911563b1d4658774ccf

I checked the pendning patches in loongarch-kvm branch, they all look 
good to me.

Thanks for doing this.

Regards
Bibo Mao
> 
> Huacai
> 
> On Thu, Jan 29, 2026 at 10:18 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> LoongArch KVM supports steal time accounting now, here add steal time
>> test case on LoongArch.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   tools/testing/selftests/kvm/Makefile.kvm |  1 +
>>   tools/testing/selftests/kvm/steal_time.c | 85 ++++++++++++++++++++++++
>>   2 files changed, 86 insertions(+)
>>
>> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
>> index ba5c2b643efa..a18c00f1a4fa 100644
>> --- a/tools/testing/selftests/kvm/Makefile.kvm
>> +++ b/tools/testing/selftests/kvm/Makefile.kvm
>> @@ -228,6 +228,7 @@ TEST_GEN_PROGS_loongarch += kvm_page_table_test
>>   TEST_GEN_PROGS_loongarch += memslot_modification_stress_test
>>   TEST_GEN_PROGS_loongarch += memslot_perf_test
>>   TEST_GEN_PROGS_loongarch += set_memory_region_test
>> +TEST_GEN_PROGS_loongarch += steal_time
>>
>>   SPLIT_TESTS += arch_timer
>>   SPLIT_TESTS += get-reg-list
>> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
>> index 8edc1fca345b..ee13e8973c45 100644
>> --- a/tools/testing/selftests/kvm/steal_time.c
>> +++ b/tools/testing/selftests/kvm/steal_time.c
>> @@ -301,6 +301,91 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
>>          pr_info("\n");
>>   }
>>
>> +#elif defined(__loongarch__)
>> +/* steal_time must have 64-byte alignment */
>> +#define STEAL_TIME_SIZE                ((sizeof(struct kvm_steal_time) + 63) & ~63)
>> +#define KVM_STEAL_PHYS_VALID   BIT_ULL(0)
>> +
>> +struct kvm_steal_time {
>> +       __u64 steal;
>> +       __u32 version;
>> +       __u32 flags;
>> +       __u32 pad[12];
>> +};
>> +
>> +static bool is_steal_time_supported(struct kvm_vcpu *vcpu)
>> +{
>> +       int err;
>> +       uint64_t val;
>> +       struct kvm_device_attr attr = {
>> +               .group = KVM_LOONGARCH_VCPU_CPUCFG,
>> +               .attr = CPUCFG_KVM_FEATURE,
>> +               .addr = (uint64_t)&val,
>> +       };
>> +
>> +       err = __vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &attr);
>> +       if (err)
>> +               return false;
>> +
>> +       err = __vcpu_ioctl(vcpu, KVM_GET_DEVICE_ATTR, &attr);
>> +       if (err)
>> +               return false;
>> +
>> +       return val & BIT(KVM_FEATURE_STEAL_TIME);
>> +}
>> +
>> +static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
>> +{
>> +       struct kvm_vm *vm = vcpu->vm;
>> +       uint64_t st_gpa;
>> +       int err;
>> +       struct kvm_device_attr attr = {
>> +               .group = KVM_LOONGARCH_VCPU_PVTIME_CTRL,
>> +               .attr = KVM_LOONGARCH_VCPU_PVTIME_GPA,
>> +               .addr = (uint64_t)&st_gpa,
>> +       };
>> +
>> +       /* ST_GPA_BASE is identity mapped */
>> +       st_gva[i] = (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE);
>> +       sync_global_to_guest(vm, st_gva[i]);
>> +
>> +       err = __vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &attr);
>> +       TEST_ASSERT(err == 0, "No PV stealtime Feature");
>> +
>> +       st_gpa = (unsigned long)st_gva[i] | KVM_STEAL_PHYS_VALID;
>> +       err = __vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &attr);
>> +       TEST_ASSERT(err == 0, "Fail to set PV stealtime GPA");
>> +}
>> +
>> +static void guest_code(int cpu)
>> +{
>> +       struct kvm_steal_time *st = st_gva[cpu];
>> +       uint32_t version;
>> +
>> +       memset(st, 0, sizeof(*st));
>> +       GUEST_SYNC(0);
>> +
>> +       GUEST_ASSERT(!(READ_ONCE(st->version) & 1));
>> +       WRITE_ONCE(guest_stolen_time[cpu], st->steal);
>> +       version = READ_ONCE(st->version);
>> +       GUEST_ASSERT(!(READ_ONCE(st->version) & 1));
>> +       GUEST_SYNC(1);
>> +
>> +       GUEST_ASSERT(!(READ_ONCE(st->version) & 1));
>> +       GUEST_ASSERT(version < READ_ONCE(st->version));
>> +       WRITE_ONCE(guest_stolen_time[cpu], st->steal);
>> +       GUEST_ASSERT(!(READ_ONCE(st->version) & 1));
>> +       GUEST_DONE();
>> +}
>> +
>> +static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
>> +{
>> +       struct kvm_steal_time *st = addr_gva2hva(vm, (ulong)st_gva[vcpu_idx]);
>> +
>> +       ksft_print_msg("VCPU%d:\n", vcpu_idx);
>> +       ksft_print_msg("    steal:     %lld\n", st->steal);
>> +       ksft_print_msg("    version:   %d\n", st->version);
>> +}
>>   #endif
>>
>>   static void *do_steal_time(void *arg)
>>
>> base-commit: 8dfce8991b95d8625d0a1d2896e42f93b9d7f68d
>> --
>> 2.39.3
>>


