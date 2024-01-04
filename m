Return-Path: <kvm+bounces-5618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12E72823BAC
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 06:07:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 69908B24D75
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 05:07:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51F9318ECC;
	Thu,  4 Jan 2024 05:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="COuCTjZO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D821865A
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 05:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704344822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9wsIvjC67PLFCF/BdJ20SdklAkum5ffGTzXv885bu5w=;
	b=COuCTjZOu39EpP3GpmD1etCtU1Wrocdc1qJdhUkq/eEAO8Ynf/rloH6Gksm9OHfgBydY8t
	yp8EK2ohZsbO4tJVi6vFNaa5Nfhr/qa7xCkZc5ILWxyykTVgU7VNiSl+JLI8CEdHNINEiX
	FU0RgtMMA4x7AWOA7HTp5fFxG4bQ5zM=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-10gn5vvtNtqZEPTxoUgO1g-1; Thu, 04 Jan 2024 00:07:01 -0500
X-MC-Unique: 10gn5vvtNtqZEPTxoUgO1g-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1d4b2a95f70so1351765ad.0
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 21:07:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704344820; x=1704949620;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9wsIvjC67PLFCF/BdJ20SdklAkum5ffGTzXv885bu5w=;
        b=GpNQCRsKJU54FLFpCddKc8jn9SL9TbMNSPgCg+7CZT+nEVFgFea8IKC2sU60S6htK8
         Y2XChcGiOLruWNOlCpe+oCr7SqPt6WptFzKw9nho6ZfJEIE2mqgiMaZwA9z+wKOMWN7y
         XdrpF8Zt1NepBjdTfOU7dpw9yhq+OJM+rI8Gof2H2tKjNc9fhws825DuBAW8hOfVQJWG
         IAFb/4TOOScc1ya5uLru0wuaP5NdB/mTGoNy+NJBD5Sn6l7xlyzPunX/UWpnRKZa88gd
         UV8jQuQalX7DenDqaX1k3gvzD9I3yekAdKjkh3UhbkMW+0PSECUbDjb4+KkgWxtOyJrd
         DJ+g==
X-Gm-Message-State: AOJu0YzQ5jqpGBh+pd3uT6FKmhuiiTEvgtggbkLjWva/BB/UoHPadsLm
	9WTfrW8xZ8cliWb3POY2juxKtDIlKXHt+UzKnk0lh/ovL6AqWgKeziROp7cUBBIho1oeMdqEdqu
	xxHgibf7jIMtxL9LNUav3
X-Received: by 2002:a17:903:2448:b0:1d4:418e:d83b with SMTP id l8-20020a170903244800b001d4418ed83bmr67083pls.111.1704344820260;
        Wed, 03 Jan 2024 21:07:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHtRRfPoD2AmDU6qtptVCBW0QbNzJYM+ha8MKoofBpriej1vuzGKEnPUsoFlW2M8rLqW0B82A==
X-Received: by 2002:a17:903:2448:b0:1d4:418e:d83b with SMTP id l8-20020a170903244800b001d4418ed83bmr67071pls.111.1704344819948;
        Wed, 03 Jan 2024 21:06:59 -0800 (PST)
Received: from LeoBras.redhat.com ([2804:431:c7ec:911:6911:ca60:846:eb46])
        by smtp.gmail.com with ESMTPSA id e1-20020a170902ed8100b001d4ab4e2a7asm8332870plj.231.2024.01.03.21.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 21:06:59 -0800 (PST)
From: Leonardo Bras <leobras@redhat.com>
To: guoren@kernel.org
Cc: Leonardo Bras <leobras@redhat.com>,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	panqinglin2020@iscas.ac.cn,
	bjorn@rivosinc.com,
	conor.dooley@microchip.com,
	peterz@infradead.org,
	anup@brainfault.org,
	keescook@chromium.org,
	wuwei2016@iscas.ac.cn,
	xiaoguang.xing@sophgo.com,
	chao.wei@sophgo.com,
	unicorn_wang@outlook.com,
	uwu@icenowy.me,
	jszhang@kernel.org,
	wefu@redhat.com,
	atishp@atishpatra.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	Guo Ren <guoren@linux.alibaba.com>
Subject: Re: [PATCH V12 07/14] riscv: qspinlock: Add virt_spin_lock() support for VM guest
Date: Thu,  4 Jan 2024 02:06:46 -0300
Message-ID: <ZZY85kZZ_uipkVTW@LeoBras>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231225125847.2778638-8-guoren@kernel.org>
References: <20231225125847.2778638-1-guoren@kernel.org> <20231225125847.2778638-8-guoren@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Dec 25, 2023 at 07:58:40AM -0500, guoren@kernel.org wrote:
> From: Guo Ren <guoren@linux.alibaba.com>
> 
> Add a static key controlling whether virt_spin_lock() should be
> called or not. When running on bare metal set the new key to
> false.
> 
> The VM guests should fall back to a Test-and-Set spinlock,
> because fair locks have horrible lock 'holder' preemption issues.
> The virt_spin_lock_key would shortcut for the queued_spin_lock_-
> slowpath() function that allow virt_spin_lock to hijack it.
> 
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@kernel.org>
> ---
>  .../admin-guide/kernel-parameters.txt         |  4 +++
>  arch/riscv/include/asm/spinlock.h             | 22 ++++++++++++++++
>  arch/riscv/kernel/setup.c                     | 26 +++++++++++++++++++
>  3 files changed, 52 insertions(+)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 2ac9f1511774..b7794c96d91e 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -3997,6 +3997,10 @@
>  	no_uaccess_flush
>  	                [PPC] Don't flush the L1-D cache after accessing user data.
>  
> +	no_virt_spin	[RISC-V] Disable virt_spin_lock in VM guest to use
> +			native_queued_spinlock when the nopvspin option is enabled.
> +			This would help vcpu=pcpu scenarios.
> +
>  	novmcoredd	[KNL,KDUMP]
>  			Disable device dump. Device dump allows drivers to
>  			append dump data to vmcore so you can collect driver
> diff --git a/arch/riscv/include/asm/spinlock.h b/arch/riscv/include/asm/spinlock.h
> index d07643c07aae..7bbcf3d9fff0 100644
> --- a/arch/riscv/include/asm/spinlock.h
> +++ b/arch/riscv/include/asm/spinlock.h
> @@ -4,6 +4,28 @@
>  #define __ASM_RISCV_SPINLOCK_H
>  
>  #ifdef CONFIG_QUEUED_SPINLOCKS
> +/*
> + * The KVM guests fall back to a Test-and-Set spinlock, because fair locks
> + * have horrible lock 'holder' preemption issues. The virt_spin_lock_key
> + * would shortcut for the queued_spin_lock_slowpath() function that allow
> + * virt_spin_lock to hijack it.
> + */
> +DECLARE_STATIC_KEY_TRUE(virt_spin_lock_key);
> +
> +#define virt_spin_lock virt_spin_lock
> +static inline bool virt_spin_lock(struct qspinlock *lock)
> +{
> +	if (!static_branch_likely(&virt_spin_lock_key))
> +		return false;
> +
> +	do {
> +		while (atomic_read(&lock->val) != 0)
> +			cpu_relax();
> +	} while (atomic_cmpxchg(&lock->val, 0, _Q_LOCKED_VAL) != 0);
> +
> +	return true;
> +}
> +
>  #define _Q_PENDING_LOOPS	(1 << 9)
>  #endif
>  
> diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
> index d9072a59831c..0bafb9fd6ea3 100644
> --- a/arch/riscv/kernel/setup.c
> +++ b/arch/riscv/kernel/setup.c
> @@ -27,6 +27,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/cpufeature.h>
>  #include <asm/cpu_ops.h>
> +#include <asm/cpufeature.h>
>  #include <asm/early_ioremap.h>
>  #include <asm/pgtable.h>
>  #include <asm/setup.h>
> @@ -266,6 +267,27 @@ early_param("qspinlock", queued_spinlock_setup);
>  DEFINE_STATIC_KEY_TRUE(combo_qspinlock_key);
>  EXPORT_SYMBOL(combo_qspinlock_key);
>  
> +#ifdef CONFIG_QUEUED_SPINLOCKS
> +static bool no_virt_spin __ro_after_init;
> +static int __init no_virt_spin_setup(char *p)
> +{
> +	no_virt_spin = true;
> +
> +	return 0;
> +}
> +early_param("no_virt_spin", no_virt_spin_setup);
> +
> +DEFINE_STATIC_KEY_TRUE(virt_spin_lock_key);
> +
> +static void __init virt_spin_lock_init(void)
> +{
> +	if (no_virt_spin)
> +		static_branch_disable(&virt_spin_lock_key);
> +	else
> +		pr_info("Enable virt_spin_lock\n");
> +}
> +#endif
> +
>  static void __init riscv_spinlock_init(void)
>  {
>  	if (!enable_qspinlock) {
> @@ -274,6 +296,10 @@ static void __init riscv_spinlock_init(void)
>  	} else {
>  		pr_info("Queued spinlock: enabled\n");
>  	}
> +
> +#ifdef CONFIG_QUEUED_SPINLOCKS
> +	virt_spin_lock_init();
> +#endif
>  }
>  #endif
>  
> -- 
> 2.40.1
> 

LGTM:
Reviewed-by: Leonardo Bras <leobras@redhat.com>


