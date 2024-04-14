Return-Path: <kvm+bounces-14599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51FE38A40AC
	for <lists+kvm@lfdr.de>; Sun, 14 Apr 2024 08:42:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2E612829B0
	for <lists+kvm@lfdr.de>; Sun, 14 Apr 2024 06:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC82A1CA89;
	Sun, 14 Apr 2024 06:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="1UDELe4O"
X-Original-To: kvm@vger.kernel.org
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EF717736;
	Sun, 14 Apr 2024 06:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713076920; cv=none; b=cteiEkbI80xeCKhqFGJ3w7F5eb4GRx5P8B8rDko98PV9vzXWZRGPXrQEMXTQtbesNcr6Q+U5V4YUBhFIGPUxUa3iQLrA6N0AxciMXhtZXaN3rnY8m4yzikt5OwyxL4o9JaZtfy9iX7bjHqyq6ugY03dY1IcS1hD7Q6mCLly3aHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713076920; c=relaxed/simple;
	bh=NFH2xx83K4Ast9oEOtWQ3Ql3oIVUgdGR+WUbnII0wEY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qYfxwMqmPIjv8uva7TU/kETm6t+iHkGKatTypW/ttszZWlMQRxYc2Zb9T3gXHLeJ4oXeeu/d5nluI6lY+wXq7Fl0CxEFkwFRaBnH7UlStOugGJPiTqx86aHcmJ94Roir+2dAom1OGvj+YsgTZ9p/tdKL9nwkhsupVY0/cXfHd64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=1UDELe4O; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:Reply-To:MIME-Version:Date:
	Message-ID:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	In-Reply-To:References; bh=4OW3Mq0YXkIS63Euv+2zQYbER+KJH/Bt2ANqXEYmbf0=;
	t=1713076917; x=1713508917; b=1UDELe4Olw4M0wwryo7fV7thmI2sB7vqkEJR14lBp5YOa89
	z2jlU5YSQGyIsQJT8fM1dnTrT2O7NWHn1WrPzSH7D0u6vMBqN0jQdHcHiqdddEO580AoD9Yff+GmY
	kjlQ3LLMzdUDMOemoWFrHJNoGy6IOeGx+yGCWrJGvbg/FkI/Gsy/MCBWNz2AoYm9p6REtCE76In2G
	mkAMU29q3Blpr5ptDxGDLUrnRYYalTsl0nhaR2IRVUbdHmNLpmRWnDpLoynrfFnqFA+6imHnqUCye
	EuSJMZ9/oWPpWCVGkOY0Iq9jqNyA5AXDdKJnsJwJ6acIENevyUJbqlGGg05NuwFg==;
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1rvtYn-0003u4-30; Sun, 14 Apr 2024 08:41:53 +0200
Message-ID: <8c77ccfd-d561-45a1-8ed5-6b75212c7a58@leemhuis.info>
Date: Sun, 14 Apr 2024 08:41:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Subject: Re: [linus:master] [x86/bugs] 6613d82e61:
 general_protection_fault:#[##]
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>, kvm@vger.kernel.org,
 Linux kernel regressions list <regressions@lists.linux.dev>,
 kernel test robot <oliver.sang@intel.com>
References: <202403281553.79f5a16f-lkp@intel.com>
 <20240328211742.bh2y3zsscranycds@desk>
From: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
Content-Language: en-US, de-DE
In-Reply-To: <20240328211742.bh2y3zsscranycds@desk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1713076917;06afded1;
X-HE-SMSGID: 1rvtYn-0003u4-30

Hi, Thorsten here, the Linux kernel's regression tracker.

On 28.03.24 22:17, Pawan Gupta wrote:
> On Thu, Mar 28, 2024 at 03:36:28PM +0800, kernel test robot wrote:
>> compiler: clang-17
>> test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
>>
>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>> the same patch/commit), kindly add following tags
>> | Reported-by: kernel test robot <oliver.sang@intel.com>
>> | Closes: https://lore.kernel.org/oe-lkp/202403281553.79f5a16f-lkp@intel.com

TWIMC, a user report general protection faults with dosemu that were
bisected to a 6.6.y backport of the commit that causes the problem
discussed in this thread (6613d82e617dd7 ("x86/bugs: Use ALTERNATIVE()
instead of mds_user_clear static key")).

User compiles using gcc, so it might be a different problem. Happens
with 6.8.y as well.

The problem occurs with x86-32 kernels, but strangely only on some of
the x86-32 systems the reporter has (e.g. on some everything works
fine). Makes me wonder if the commit exposed an older problem that only
happens on some machines.

For details see https://bugzilla.kernel.org/show_bug.cgi?id=218707
Could not CC the reporter here due to the bugzilla privacy policy; if
you want to get in contact, please use bugzilla.

Ciao, Thorsten

>> [   25.175767][  T670] VFS: Warning: trinity-c2 using old stat() call. Recompile your binary.
>> [   25.245597][  T669] general protection fault: 0000 [#1] PREEMPT SMP
>> [   25.246417][  T669] CPU: 1 PID: 669 Comm: trinity-c1 Not tainted 6.8.0-rc5-00004-g6613d82e617d #1 85a4928d2e6b42899c3861e57e26bdc646c4c5f9
>> [   25.247743][  T669] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
>> [ 25.248865][ T669] EIP: restore_all_switch_stack (kbuild/src/consumer/arch/x86/entry/entry_32.S:957) 
>> [ 25.249510][ T669] Code: 4c 24 10 36 89 48 fc 8b 4c 24 0c 81 e1 ff ff 00 00 36 89 48 f8 8b 4c 24 08 36 89 48 f4 8b 4c 24 04 36 89 48 f0 59 8d 60 f0 58 <0f> 00 2d 00 94 d5 c1 cf 6a 00 68 88 6b d4 c1 eb 00 fc 0f a0 50 b8
>> All code
>> ========
>>    0:	4c 24 10             	rex.WR and $0x10,%al
>>    3:	36 89 48 fc          	ss mov %ecx,-0x4(%rax)
>>    7:	8b 4c 24 0c          	mov    0xc(%rsp),%ecx
>>    b:	81 e1 ff ff 00 00    	and    $0xffff,%ecx
>>   11:	36 89 48 f8          	ss mov %ecx,-0x8(%rax)
>>   15:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
>>   19:	36 89 48 f4          	ss mov %ecx,-0xc(%rax)
>>   1d:	8b 4c 24 04          	mov    0x4(%rsp),%ecx
>>   21:	36 89 48 f0          	ss mov %ecx,-0x10(%rax)
>>   25:	59                   	pop    %rcx
>>   26:	8d 60 f0             	lea    -0x10(%rax),%esp
>>   29:	58                   	pop    %rax
>>   2a:*	0f 00 2d 00 94 d5 c1 	verw   -0x3e2a6c00(%rip)        # 0xffffffffc1d59431		<-- trapping instruction
> 
> This is due to 64-bit addressing with CONFIG_X86_32=y on clang.
> 
> I haven't tried with clang, but I don't see this happening with gcc-11:
> 
> 	entry_INT80_32:
> 	...
> 	<+446>:   mov    0x4(%esp),%ecx
> 	<+450>:   mov    %ecx,%ss:-0x10(%eax)
> 	<+454>:   pop    %ecx
> 	<+455>:   lea    -0x10(%eax),%esp
> 	<+458>:   pop    %eax
> 	<+459>:   verw   0xc1d5c700              <----------
> 	<+466>:   iret
> 
>>   31:	cf                   	iret
>>   32:	6a 00                	push   $0x0
>>   34:	68 88 6b d4 c1       	push   $0xffffffffc1d46b88
>>   39:	eb 00                	jmp    0x3b
> ...
> 
> The config has CONFIG_X86_32=y, but it is possible that in 32-bit build
> with clang, 64-bit mode expansion of "VERW (_ASM_RIP(addr))" is getting
> used i.e. __ASM_FORM_RAW(b) below:
> 
>   file: arch/x86/include/asm/asm.h
>   ...
>   #ifndef __x86_64__
>   /* 32 bit */
>   # define __ASM_SEL(a,b)         __ASM_FORM(a)
>   # define __ASM_SEL_RAW(a,b)     __ASM_FORM_RAW(a)
>   #else
>   /* 64 bit */
>   # define __ASM_SEL(a,b)         __ASM_FORM(b)
>   # define __ASM_SEL_RAW(a,b)     __ASM_FORM_RAW(b)   <--------
>   #endif
>   ...
>   /* Adds a (%rip) suffix on 64 bits only; for immediate memory references */
>   #define _ASM_RIP(x)     __ASM_SEL_RAW(x, x (__ASM_REGPFX rip))
> 
> Possibly __x86_64__ is being defined with clang even when CONFIG_X86_32=y.
> 
> I am not sure about current level of 32-bit mode support in clang. This
> seems inconclusive:
> 
>   https://discourse.llvm.org/t/x86-32-bit-testing/65480
> 
> Does anyone care about 32-bit mode builds with clang?

