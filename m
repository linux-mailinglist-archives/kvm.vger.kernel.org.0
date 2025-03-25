Return-Path: <kvm+bounces-41921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44289A6E9C3
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 07:51:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A9653AE3B8
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:50:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C42142206BB;
	Tue, 25 Mar 2025 06:50:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0196252918
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 06:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742885454; cv=none; b=iuBZlq0Jf9x69EjKiVC24NgQ+ZePSKKn3QUx+gKqHfjiip8RkIGhLV+bZaXlnJBIBzHmbFYhasbZ8EvAUfPUabSmhsmPXKc9/350Mq8C71J2NGjdy0Z7qfVWdGKG5kMiRqSv5o3h4fkKiCN2pxgglNLapCrmN31rPdHWnqORLmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742885454; c=relaxed/simple;
	bh=SNK/rfv9Sm/aoQ+fP6y1jffu6QK0mE8GsVuulckg7HY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=oLf4Bwo87q9A/+n6KS9sRBsrPmhqDFvPs5W7k2dng8w8F08l2AMRKbNr3Y3F1Hd70hk178PZZLKk2VuDzmwh80sHx2oA7BJC9hvbGx+3087oa2iz6XqzVW0h9k1nS5KCad6MR4EyHRTv7yJ0BX5YHxRSZ5xy89DbxGR9NfqIZvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1742884580-086e2360172e37a0001-HEqcsx
Received: from ZXSHMBX3.zhaoxin.com (ZXSHMBX3.zhaoxin.com [10.28.252.165]) by mx1.zhaoxin.com with ESMTP id uKcjGgU61vPQQnT3 (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Tue, 25 Mar 2025 14:36:20 +0800 (CST)
X-Barracuda-Envelope-From: LiamNi-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Received: from ZXSHMBX2.zhaoxin.com (10.28.252.164) by ZXSHMBX3.zhaoxin.com
 (10.28.252.165) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Tue, 25 Mar
 2025 14:36:19 +0800
Received: from ZXSHMBX2.zhaoxin.com ([fe80::4dfc:4f6a:c0cf:4298]) by
 ZXSHMBX2.zhaoxin.com ([fe80::4dfc:4f6a:c0cf:4298%4]) with mapi id
 15.01.2507.044; Tue, 25 Mar 2025 14:36:19 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Received: from [10.28.66.46] (10.28.66.46) by ZXBJMBX02.zhaoxin.com
 (10.29.252.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.44; Tue, 25 Mar
 2025 14:10:58 +0800
Message-ID: <676ed22f-9c3f-4013-99d8-37c4c73bb9ac@zhaoxin.com>
Date: Tue, 25 Mar 2025 14:10:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86:Cancel hrtimer in the process of saving PIT
 state to reduce the performance overhead caused by hrtimer during guest stop.
To: Sean Christopherson <seanjc@google.com>
X-ASG-Orig-Subj: Re: [PATCH] KVM: x86:Cancel hrtimer in the process of saving PIT
 state to reduce the performance overhead caused by hrtimer during guest stop.
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
	<LiamNi@zhaoxin.com>, <CobeChen@zhaoxin.com>, <LouisQi@zhaoxin.com>,
	<EwanHai@zhaoxin.com>, <FrankZhu@zhaoxin.com>
References: <20250317091917.72477-1-liamni-oc@zhaoxin.com>
 <Z9gl5dbTfZsUCJy-@google.com>
From: LiamNioc <LiamNi-oc@zhaoxin.com>
In-Reply-To: <Z9gl5dbTfZsUCJy-@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 ZXBJMBX02.zhaoxin.com (10.29.252.6)
X-Moderation-Data: 3/25/2025 2:36:18 PM
X-Barracuda-Connect: ZXSHMBX3.zhaoxin.com[10.28.252.165]
X-Barracuda-Start-Time: 1742884580
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.35:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 2769
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.138991
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------



On 2025/3/17 21:38, Sean Christopherson wrote:
>=20
>=20
>=20
> On Mon, Mar 17, 2025, Liam Ni wrote:
>> When using the dump-guest-memory command in QEMU to dump
>> the virtual machine's memory,the virtual machine will be
>> paused for a period of time.If the guest (i.e., UEFI) uses
>> the PIT as the system clock,it will be observed that the
>> HRTIMER used by the PIT continues to run during the guest
>> stop process, imposing an additional burden on the system.
>> Moreover, during the guest restart process,the previously
>> established HRTIMER will be canceled,and the accumulated
>> timer events will be flushed.However, before the old
>> HRTIMER is canceled,the accumulated timer events
>> will "surreptitiously" inject interrupts into the guest.
>>
>> SO during the process of saving the KVM PIT state,
>> the HRTIMER need to be canceled to reduce the performance overhead
>> caused by HRTIMER during the guest stop process.
>>
>> i.e. if guest
>>
>> Signed-off-by: Liam Ni <liamni-oc@zhaoxin.com>
>> ---
>>   arch/x86/kvm/x86.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 045c61cc7e54..75355b315aca 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -6405,6 +6405,8 @@ static int kvm_vm_ioctl_get_pit(struct kvm *kvm, s=
truct kvm_pit_state *ps)
>>
>>        mutex_lock(&kps->lock);
>>        memcpy(ps, &kps->channels, sizeof(*ps));
>> +     hrtimer_cancel(&kvm->arch.vpit->pit_state.timer);
>> +     kthread_flush_work(&kvm->arch.vpit->expired);
>=20
> KVM cannot assume userspace wants to stop the PIT when grabbing a snapsho=
t.  It's
> a significant ABI change, and not desirable in all cases.

When VM Pause, all devices of the virtual machine are frozen, so the PIT=20
freeze only saves the PIT device status, but does not cancel HRTIMER,=20
but chooses to cancel HRTIMER when VM resumes and refresh the pending=20
task. According to my observation, before refreshing the pending task,=20
these pending tasks will secretly inject interrupts into the guest.

So do we need to cancel the HRTIMER when VM pause=EF=BC=9F

>=20
>>        mutex_unlock(&kps->lock);
>>        return 0;
>>   }
>> @@ -6428,6 +6430,8 @@ static int kvm_vm_ioctl_get_pit2(struct kvm *kvm, =
struct kvm_pit_state2 *ps)
>>        memcpy(ps->channels, &kvm->arch.vpit->pit_state.channels,
>>                sizeof(ps->channels));
>>        ps->flags =3D kvm->arch.vpit->pit_state.flags;
>> +     hrtimer_cancel(&kvm->arch.vpit->pit_state.timer);
>> +     kthread_flush_work(&kvm->arch.vpit->expired);
>>        mutex_unlock(&kvm->arch.vpit->pit_state.lock);
>>        memset(&ps->reserved, 0, sizeof(ps->reserved));
>>        return 0;
>> --
>> 2.25.1
>>


