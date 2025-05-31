Return-Path: <kvm+bounces-48129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DF9C7AC99A4
	for <lists+kvm@lfdr.de>; Sat, 31 May 2025 08:38:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74DA11BA5FA1
	for <lists+kvm@lfdr.de>; Sat, 31 May 2025 06:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D270322DFB5;
	Sat, 31 May 2025 06:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HD79848N"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0558479;
	Sat, 31 May 2025 06:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748673510; cv=none; b=pgoefph6A1FInQSb+BXpai3J+cJ930xlMT+yZAYyTiSjSVkvBnDLhh4LFFdfyivvhowWGGr89bxMVdFAZhMBzEHIZH+loYH+N9zmMJEACvNjHMy9k8dyJLwEDH9XHZ7YB1+0X0OXx3R8DKQxRl19BD11TaR1UgNozgndX84S76w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748673510; c=relaxed/simple;
	bh=FZUC2I5LAvsA3VQWXEtsPX3es+jsE4YUQWHmJUJgcbk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PB2ORqSZEaNDa996bwD3vV3bYx3QpdoNJdHU46tC1O5cE7QgN0LXey3IMkvnkYEmk/94B8Qq3ARIHfgAK5rciK5mApB7/n1nv6he7SvnyWaBLQsouWPdU5NiV9NGkri9FQq770y6HjIXVQ9LsxLcXygYTBlUH4nnmOjSOYvDVeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HD79848N; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=24EwpxZgUn+ypwftk2i/PqDkmuMZ5vv5Q2cnNVzmjEs=; b=HD79848NxGDBfbf21M3FNgx1rn
	UBXK/im/xom6P3ZfPO0gZZkgaBRhZJ2HhwiKbKiZokfhSKLtvJ8GOzj6TILp12qSnwY7nlmF+yijQ
	16/dltPMP+C+y/EbQjjBC0JR2o38PtJK4NqLd1xNOUTbhl8CQ7qd58eFp38ERhmHAcHLvT/SyyRRQ
	GI5k9d6rW4aHEBX8yAnW9r9e0Zayh9k+VEXlcjcrPV+pLZunKQHjxs6SswvwbYP8Ehcb7FYKnBUHc
	pUe8numEtNKUCds7s1E8FSrzqijOpkCsUJwAFyBLOtt/EP2OJHB6iK3NTEgXodJaphvMZmJlXyAr+
	sCEiiu/w==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uLFrL-0000000GYXv-1R8A;
	Sat, 31 May 2025 06:38:23 +0000
Message-ID: <d25bec97-bd48-4265-8cee-af68487e8333@infradead.org>
Date: Fri, 30 May 2025 23:38:19 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] rtmutex_api: provide correct extern functions
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: mlevitsk@redhat.com, Peter Zijlstra <peterz@infradead.org>
References: <20250531060756.130554-1-pbonzini@redhat.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250531060756.130554-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/30/25 11:07 PM, Paolo Bonzini wrote:
> Commit fb49f07ba1d9 ("locking/mutex: implement mutex_lock_killable_nest_lock")
> changed the set of functions that mutex.c defines when CONFIG_DEBUG_LOCK_ALLOC
> is set.
> 
> - it removed the "extern" declaration of mutex_lock_killable_nested from
>   include/linux/mutex.h, and replaced it with a macro since it could be
>   treated as a special case of _mutex_lock_killable.  It also removed a
>   definition of the function in kernel/locking/mutex.c.
> 
> - likewise, it replaced mutex_trylock() with the more generic
>   mutex_trylock_nest_lock() and replaced mutex_trylock() with a macro.
> 
> However, it left the old definitions in place in kernel/locking/rtmutex_api.c,
> which causes failures when building with CONFIG_RT_MUTEXES=y.  Bring over
> the changes.
> 
> Fixes: fb49f07ba1d9 ("locking/mutex: implement mutex_lock_killable_nest_lock")
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Tested-by: Randy Dunlap <rdunlap@infradead.org>

Thanks!

> ---
> 	This time, with brain connected.
> 
>  kernel/locking/rtmutex_api.c | 33 +++++++++++++++++++++------------
>  1 file changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/locking/rtmutex_api.c b/kernel/locking/rtmutex_api.c
> index 191e4720e546..f21e59a0525e 100644
> --- a/kernel/locking/rtmutex_api.c
> +++ b/kernel/locking/rtmutex_api.c
> @@ -544,12 +544,12 @@ int __sched mutex_lock_interruptible_nested(struct mutex *lock,
>  }
>  EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
>  
> -int __sched mutex_lock_killable_nested(struct mutex *lock,
> -					    unsigned int subclass)
> +int __sched _mutex_lock_killable(struct mutex *lock, unsigned int subclass,
> +				 struct lockdep_map *nest_lock)
>  {
> -	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, NULL, _RET_IP_);
> +	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, nest_lock, _RET_IP_);
>  }
> -EXPORT_SYMBOL_GPL(mutex_lock_killable_nested);
> +EXPORT_SYMBOL_GPL(_mutex_lock_killable);
>  
>  void __sched mutex_lock_io_nested(struct mutex *lock, unsigned int subclass)
>  {
> @@ -563,6 +563,21 @@ void __sched mutex_lock_io_nested(struct mutex *lock, unsigned int subclass)
>  }
>  EXPORT_SYMBOL_GPL(mutex_lock_io_nested);
>  
> +int __sched _mutex_trylock_nest_lock(struct mutex *lock,
> +				     struct lockdep_map *nest_lock)
> +{
> +	int ret;
> +
> +	if (IS_ENABLED(CONFIG_DEBUG_RT_MUTEXES) && WARN_ON_ONCE(!in_task()))
> +		return 0;
> +
> +	ret = __rt_mutex_trylock(&lock->rtmutex);
> +	if (ret)
> +		mutex_acquire_nest(&lock->dep_map, 0, 1, nest_lock, _RET_IP_);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(_mutex_trylock_nest_lock);
>  #else /* CONFIG_DEBUG_LOCK_ALLOC */
>  
>  void __sched mutex_lock(struct mutex *lock)
> @@ -591,22 +606,16 @@ void __sched mutex_lock_io(struct mutex *lock)
>  	io_schedule_finish(token);
>  }
>  EXPORT_SYMBOL(mutex_lock_io);
> -#endif /* !CONFIG_DEBUG_LOCK_ALLOC */
>  
>  int __sched mutex_trylock(struct mutex *lock)
>  {
> -	int ret;
> -
>  	if (IS_ENABLED(CONFIG_DEBUG_RT_MUTEXES) && WARN_ON_ONCE(!in_task()))
>  		return 0;
>  
> -	ret = __rt_mutex_trylock(&lock->rtmutex);
> -	if (ret)
> -		mutex_acquire(&lock->dep_map, 0, 1, _RET_IP_);
> -
> -	return ret;
> +	return __rt_mutex_trylock(&lock->rtmutex);
>  }
>  EXPORT_SYMBOL(mutex_trylock);
> +#endif /* !CONFIG_DEBUG_LOCK_ALLOC */
>  
>  void __sched mutex_unlock(struct mutex *lock)
>  {

-- 
~Randy

