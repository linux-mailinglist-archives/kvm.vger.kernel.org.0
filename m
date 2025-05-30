Return-Path: <kvm+bounces-48102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FE59AC914D
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 16:15:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D2D8A21211
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 14:14:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F0D422D9EB;
	Fri, 30 May 2025 14:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TbwCOWU0"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E68C19F10A;
	Fri, 30 May 2025 14:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748614504; cv=none; b=hrBKzFsHb9J0FwlI5UE6joyZuN+02pBCKmH2hikd9OzExerQ9RcdM8AamXhb29NsUqOncrM3OVovVkApekPT73ixUu/uw5lpvXkTeIlRiqq7A2ycp6mH0ncA+7RLkmPbM8x2zkenkuohy8pzDpOaiy8GqpaHSm01Jgu6SIhmqxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748614504; c=relaxed/simple;
	bh=D14su2SnZrT619r1bgDXLjqrkr8mqlqrATupz2uDAMw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EoY9EMgifzDsve4ZjsLZZBx9vajob4jtcfwQ+/iWFgBFnIFY6Xe4fkjU5ZTOUQuqYCyp5oMR+pIPbZV+Bt6Pcl+11pL0XD0UJtEgWCRZUm9C2nLZxt2Y/wf5QNurDqG9THq+/L9OohmqdillHRWS/ZangKTI6UZUfNsbZKft3KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TbwCOWU0; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=cXJwdA1WXYAXD7LdHMB/+fSm/iGIaIYkzTw/ndBNrCc=; b=TbwCOWU0mQjKWsz5IzZtbH55GZ
	387GpG7L45tKVLi18ASGhnHrdUFY2bJhcM62faP76gpRRbTkjwiTq65WlRlk6atv2LfW4Z1pPKR7O
	xaNS4/2fNk/s4Pz6MZDeLtQUOn4ZAaDSOS04IZSjDHMrD8Dt9aUK9RFaZcMW3u92I6PAMbMUkqSNQ
	WLPVc+08JDJLylpWLf06/dB228ieekGZBC0iPs9GE6Othp3hOin+M998iSQmMC1u2ori84RHcfyQm
	qLuoTUBbT1kvR2UUVq/DrMXT+fmGQpTeHLqbdTB+r0JFdLuxjeKiBdldI21XZG4xY1Zd4Ht0dFNFS
	m7qpmOLg==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uL0Va-00000000FhE-2o2t;
	Fri, 30 May 2025 14:14:55 +0000
Message-ID: <a013d8f5-61b7-4cfc-a863-76084e974634@infradead.org>
Date: Fri, 30 May 2025 07:14:43 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] rtmutex_api: remove definition of
 mutex_lock_killable_nested
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>
References: <20250530075136.11842-1-pbonzini@redhat.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250530075136.11842-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

On 5/30/25 12:51 AM, Paolo Bonzini wrote:
> Commit fb49f07ba1d9 ("locking/mutex: implement mutex_lock_killable_nest_lock")
> removed the "extern" declaration of mutex_lock_killable_nested from
> include/linux/mutex.h, and replaced it with a macro since it could be
> treated as a special case of _mutex_lock_killable.  It also removed a
> definition of the function in kernel/locking/mutex.c.
> 
> However, it left the definition in place in kernel/locking/rtmutex_api.c,
> which causes a failure when building with CONFIG_RT_MUTEXES=y.  Drop it as
> well now.
> 
> Fixes: fb49f07ba1d9 ("locking/mutex: implement mutex_lock_killable_nest_lock")
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

This patch fixes part of the build errors that I was seeing, but I
still have these:

In file included from ../include/uapi/linux/posix_types.h:5,
                 from ../include/uapi/linux/types.h:14,
                 from ../include/linux/types.h:6,
                 from ../include/linux/kasan-checks.h:5,
                 from ../include/asm-generic/rwonce.h:26,
                 from ./arch/x86/include/generated/asm/rwonce.h:1,
                 from ../include/linux/compiler.h:390,
                 from ../include/linux/export.h:5,
                 from ../include/linux/linkage.h:7,
                 from ../include/linux/preempt.h:10,
                 from ../include/linux/spinlock.h:56,
                 from ../kernel/locking/rtmutex_api.c:5:
../include/linux/stddef.h:8:14: error: expected declaration specifiers or ‘...’ before ‘(’ token
    8 | #define NULL ((void *)0)
      |              ^
../include/linux/mutex.h:215:60: note: in expansion of macro ‘NULL’
  215 | #define mutex_trylock(lock) _mutex_trylock_nest_lock(lock, NULL)
      |                                                            ^~~~
../kernel/locking/rtmutex_api.c:589:13: note: in expansion of macro ‘mutex_trylock’
  589 | int __sched mutex_trylock(struct mutex *lock)
      |             ^~~~~~~~~~~~~
../kernel/locking/rtmutex_api.c:602:15: error: ‘mutex_trylock’ undeclared here (not in a function); did you mean ‘ww_mutex_trylock’?
  602 | EXPORT_SYMBOL(mutex_trylock);
      |               ^~~~~~~~~~~~~
../include/linux/export.h:76:23: note: in definition of macro ‘__EXPORT_SYMBOL’
   76 |         extern typeof(sym) sym;                                 \
      |                       ^~~
../include/linux/export.h:89:41: note: in expansion of macro ‘_EXPORT_SYMBOL’
   89 | #define EXPORT_SYMBOL(sym)              _EXPORT_SYMBOL(sym, "")
      |                                         ^~~~~~~~~~~~~~
../kernel/locking/rtmutex_api.c:602:1: note: in expansion of macro ‘EXPORT_SYMBOL’
  602 | EXPORT_SYMBOL(mutex_trylock);
      | ^~~~~~~~~~~~~



> ---
>  kernel/locking/rtmutex_api.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/kernel/locking/rtmutex_api.c b/kernel/locking/rtmutex_api.c
> index 191e4720e546..0c26b52dd417 100644
> --- a/kernel/locking/rtmutex_api.c
> +++ b/kernel/locking/rtmutex_api.c
> @@ -544,13 +544,6 @@ int __sched mutex_lock_interruptible_nested(struct mutex *lock,
>  }
>  EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
>  
> -int __sched mutex_lock_killable_nested(struct mutex *lock,
> -					    unsigned int subclass)
> -{
> -	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, NULL, _RET_IP_);
> -}
> -EXPORT_SYMBOL_GPL(mutex_lock_killable_nested);
> -
>  void __sched mutex_lock_io_nested(struct mutex *lock, unsigned int subclass)
>  {
>  	int token;

-- 
~Randy


