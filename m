Return-Path: <kvm+bounces-27376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 22787984790
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 16:22:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9F511F21D2F
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 14:22:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 229EC1A7AFD;
	Tue, 24 Sep 2024 14:22:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07331A76A3
	for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 14:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727187731; cv=none; b=i5YS/jVQpGVw454VWd4AAyoj6xJ9hSLRWg7mBiyDRnSfBImgIcUhjCYFzk5hxbOFzdVPqvD1etnKXDZXMz17Xnwil0Q71sZF6eGRLy5JnEpl65LsYinVlVMTRCS7zXzTEurMCtRuKuottWFqKUoMEz0Npo+K6Bjrc48dLjG2nJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727187731; c=relaxed/simple;
	bh=f+bPmYNyuxTi5v3+IaW2+opMblTepj+Sxa28ZCd+Xj8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bASgnvM4o4+5+GX/Bt+dWZPW6yz9HV/44W0n9vaR60ebgdjcDwDtsP/KSQcZ9o6/S+Z1IQCLAKirZIIKRmyjOSxrokvH1NPd/Pceuft3YexMC7hwOEFShwRzgB39JRy79JKH98dF0Bo/e/rpsXkvAaGdqbc+S7r94dHaGJRoaIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [192.168.31.249] (unknown [183.209.152.55])
	by APP-01 (Coremail) with SMTP id qwCowACHbn1DyfJmg_+tAA--.9372S2;
	Tue, 24 Sep 2024 22:14:28 +0800 (CST)
Message-ID: <f6fc300c-ed54-4b32-99a2-82171fb26a50@iscas.ac.cn>
Date: Tue, 24 Sep 2024 22:14:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvmtool PATCH 0/2] Add riscv isa exts based on linux-6.11
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, will@kernel.org,
 julien.thierry.kdev@gmail.com, pbonzini@redhat.com, anup@brainfault.org
References: <cover.1727174321.git.zhouquan@iscas.ac.cn>
 <20240924-c48e643c4a7a77c47b784fd1@orel>
Content-Language: en-US
From: Quan Zhou <zhouquan@iscas.ac.cn>
In-Reply-To: <20240924-c48e643c4a7a77c47b784fd1@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:qwCowACHbn1DyfJmg_+tAA--.9372S2
X-Coremail-Antispam: 1UD129KBjvdXoWruF17Gr48Zry8XF4xAF45GFg_yoWDGrXEk3
	48A34xWr18XFy7Cas5J3ZaqasrArW8X3Z5XF1YqF1UZ3WDAr1UJwsrGw18J3WDCF48JF4q
	qF1rJr97trnxWjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb28YjsxI4VWxJwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
	6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
	8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0
	cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4
	A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
	w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMc
	vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k2
	0xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI
	8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41l
	IxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIx
	AIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2
	jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07j0LvtUUUUU=
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiBgoKBmbyw9oQ6wAAs2

On 2024/9/24 21:20, Andrew Jones wrote:
> On Tue, Sep 24, 2024 at 07:03:27PM GMT, zhouquan@iscas.ac.cn wrote:
>> From: Quan Zhou <zhouquan@iscas.ac.cn>
>>
>> Add support for a few Zc* extensions, Zimop, Zcmop and Zawrs.
>>
>> Quan Zhou (2):
>>    Sync-up headers with Linux-6.11 kernel
>>    riscv: Add Zc*/Zimop/Zcmop/Zawrs exts support
>>
>>   include/linux/kvm.h                 | 27 +++++++++++++++-
>>   powerpc/include/asm/kvm.h           |  3 ++
>>   riscv/fdt.c                         |  7 +++++
>>   riscv/include/asm/kvm.h             |  7 +++++
>>   riscv/include/kvm/kvm-config-arch.h | 21 +++++++++++++
>>   x86/include/asm/kvm.h               | 49 +++++++++++++++++++++++++++++
>>   6 files changed, 113 insertions(+), 1 deletion(-)
>>
>>
>> base-commit: b48735e5d562eaffb96cf98a91da212176f1534c
>> -- 
>> 2.34.1
>>
> 
> These have already been posted by Anup [1].
> 
> [1] https://lore.kernel.org/all/20240831112743.379709-1-apatel@ventanamicro.com/
> 
> Thanks,
> drew

Sorry, I missed that. Thanks for the reminder!

Thanks,
Quan


