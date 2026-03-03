Return-Path: <kvm+bounces-72498-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eCfUHalbpmlnOgAAu9opvQ
	(envelope-from <kvm+bounces-72498-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 04:55:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E023F1E8983
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 04:55:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D06973067FC5
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 03:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 932E337DEB1;
	Tue,  3 Mar 2026 03:54:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE623374E53;
	Tue,  3 Mar 2026 03:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772510099; cv=none; b=RxLsYllVO9KiY/3eZKQIWEZt40YUc99y/qmop7sZTV7rixYcRMdV3TcaN4NBDQJS/LNH6gH00EciaBetlUsLNZq/hUaEDWOptxQrN8dvCPOBzWba4ga5aAFNxLY0f/JyeLXnbuU1GZoq95xoeD1/S0ZM8AIhwGtQjdzap6Yb9aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772510099; c=relaxed/simple;
	bh=RGWnQo32idVwzGjSVUcvWaFpWkVwatNcwHnmCfLFbDc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=NNbgpzOWqft1aLwVEZrkLgAWEVQlFPAtYoGPDDCEeWZViZbXPTnV4ZK8N5Oz1Yakq8opTYni6Zw+At17YiprF8GSn8vjQ9PE200EqWfJL8Jw6peI+D2TfVyikI/jsx5danUwPKhzKsnDTotgq0mbph+YGYA3+giTAWAecKZOeQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.10.30])
	by gateway (Coremail) with SMTP id _____8Dx88CHW6Zp0+kWAA--.9819S3;
	Tue, 03 Mar 2026 11:54:47 +0800 (CST)
Received: from [10.2.10.30] (unknown [10.2.10.30])
	by front1 (Coremail) with SMTP id qMiowJAxWcGFW6ZpMXdNAA--.2933S3;
	Tue, 03 Mar 2026 11:54:45 +0800 (CST)
Subject: Re: [PATCH v6 0/2] LongArch: KVM: Add DMSINTC support irqchip in
 kernel
To: Yao Zi <me@ziyao.cc>, maobibo@loongson.cn, chenhuacai@kernel.org
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev, kernel@xen0n.name,
 linux-kernel@vger.kernel.org
References: <20260206012028.3318291-1-gaosong@loongson.cn>
 <aYVhSp_eGBkpXdp-@pie>
From: gaosong <gaosong@loongson.cn>
Message-ID: <df4de374-c5ef-6652-985f-39598e234e35@loongson.cn>
Date: Tue, 3 Mar 2026 11:54:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <aYVhSp_eGBkpXdp-@pie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowJAxWcGFW6ZpMXdNAA--.2933S3
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxJr1DCr48Zw1fAFW8trWfXrc_yoW8Xw47pF
	W7Ga4jkrWDXw15Kws29FW0ga1jvrn3Jry8W39Iqa42kFWDur1xWr4fGrWjy3s2g3yfGw1S
	y3srW343ZF1UZFXCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUzZ2-
	UUUUU
X-Rspamd-Queue-Id: E023F1E8983
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[loongson.cn:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	FORGED_SENDER_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.884];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_SEVEN(0.00)[7];
	R_DKIM_NA(0.00)[];
	DMARC_NA(0.00)[loongson.cn];
	FROM_NEQ_ENVFROM(0.00)[gaosong@loongson.cn,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-72498-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[]
X-Rspamd-Action: no action

在 2026/2/6 上午11:34, Yao Zi 写道:
> On Fri, Feb 06, 2026 at 09:20:26AM +0800, Song Gao wrote:
>> Hi,
>>
>> This series  implements the DMSINTC in-kernel irqchip device,
>> enables irqfd to deliver MSI to DMSINTC, and supports injecting MSI interrupts
>> to the target vCPU.
>> applied this series.  use netperf test.
>> VM with one CPU and start netserver, host run netperf.
>> disable dmsintc
>> taskset 0x2f  netperf -H 192.168.122.204 -t UDP_RR  -l 36000
>> Local /Remote
>> Socket Size   Request  Resp.   Elapsed  Trans.
>> Send   Recv   Size     Size    Time     Rate
>> bytes  Bytes  bytes    bytes   secs.    per sec
>>
>> 212992 212992 1        1       36000.00   27107.36
>>
>> enable dmsintc
>> Local /Remote
>> Socket Size   Request  Resp.   Elapsed  Trans.
>> Send   Recv   Size     Size    Time     Rate
>> bytes  Bytes  bytes    bytes   secs.    per sec
>>
>> 212992 212992 1        1       36000.00   28831.14  (+6.3%)
>>
>> v6:
>>    Fix kvm_device leak in kvm_dmsintc_destroy().
>>
>> v5:
>>    Combine patch2 and patch3
>>    Add check msgint feature when register DMSINT device.
>>
>> V4: Rebase and R-b;
>>     replace DINTC to DMSINTC.
>>
>>
>> V3: Fix kvm_arch_set_irq_inatomic() missing dmsintc set msi.(patch3)
>>
>> V2:
>> https://patchew.org/linux/20251128091125.2720148-1-gaosong@loongson.cn/
>>
>> Thanks.
>> Song Gao
>>
>> Song Gao (2):
>>    LongArch: KVM: Add DMSINTC device support
>>    LongArch: KVM: Add dmsintc inject msi to the dest vcpu
> There's a typo in the titles, it should be LoongArch instead of
> "LongArch".

Hi,   huacai

Should I need send v7 to fix this typo error?

Thanks.

Song Gao
>
> Best regards,
> Yao Zi
>
>


