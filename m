Return-Path: <kvm+bounces-23612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B02B294BBAF
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 12:53:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D45571C216CD
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 10:53:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 786EA18A934;
	Thu,  8 Aug 2024 10:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f8EG7gUJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8820A18A6AB
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 10:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723114375; cv=none; b=BjotpJKJ9uMldUVXKDxMJxoKaWSu9s8kCUAEoYAXeQO28ySTKZq9WEkbyWK79MniV/F5y+K8MIvXb+SLe7ohvVlSlWEuUKUjOOwNktYfD21yeTacS8XzxMlW9HkeQgmEQ+mxQiUyTn4FzAHNskpVXnbn/C0ivixR7dL8IQqyAew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723114375; c=relaxed/simple;
	bh=fL59EHgiBY/EiXLyPpY+nJV47MsHmte/G3P7ivTH8yQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NMCuXxtIWwbturtIDZJLo6ICSmbAtr3vxKKyWJcVoKLuQ5ncQDxd17B3YbBUAvMoR6OeDpybWJh6PaKYBaYJh/euJC0fEuc6A6/1nqkTVAual5wkefrA2MwyOm7lRunT2BBVIJ9TmnxK88GNjb3sb/JUtzdDO/q0/Uu554GrKVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f8EG7gUJ; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723114374; x=1754650374;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fL59EHgiBY/EiXLyPpY+nJV47MsHmte/G3P7ivTH8yQ=;
  b=f8EG7gUJAsTqS9Jopic+q3rP2qSuuz2lk4LIWbOR89OnhSU/EHrY2xce
   Mf0r3YMBW8MmujrborAs42v5K5ZeEDuDql+WDWB7YmCbpgddbt4exk03G
   z20k1qg8vcStcvE1BI0k5laVhmJ0d4jPUXn3khJ0X5CAGoPPcQHfRYEXM
   WTfIXd2Hlw7xdVISnnruWPzmq6AnpI3kj3GkPY1ViMH4Jjbz3CgzKWthM
   GCFAGz8f+rzCR5PrQJfogeiLdPtEnUoZpp7TS2ABcBM6GvFmkGvT2Y4Rf
   p5BNNAwEUG3snw7ZxKc3z5bIJLbgAxZcdGXXXc75qPaGeNhVGgocXc3Lo
   Q==;
X-CSE-ConnectionGUID: 19pPVF0ySvGYPaf7yvPs7g==
X-CSE-MsgGUID: mK3maZ7qQlatI6nEJ2zKhA==
X-IronPort-AV: E=McAfee;i="6700,10204,11157"; a="24992636"
X-IronPort-AV: E=Sophos;i="6.09,272,1716274800"; 
   d="scan'208";a="24992636"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2024 03:52:53 -0700
X-CSE-ConnectionGUID: Ek273q0UR1WiHaYx5ZhjcQ==
X-CSE-MsgGUID: agGMBeypTqWrzNbX3LvoZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,272,1716274800"; 
   d="scan'208";a="57882279"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 08 Aug 2024 03:52:52 -0700
Date: Thu, 8 Aug 2024 19:08:41 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Ani Sinha <anisinha@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: Re: [PATCH] kvm: refactor core virtual machine creation into its own
 function
Message-ID: <ZrSnOS0irW4vTMX/@intel.com>
References: <20240808103336.1675148-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240808103336.1675148-1-anisinha@redhat.com>

Hi Ani,

On Thu, Aug 08, 2024 at 04:03:36PM +0530, Ani Sinha wrote:
> Date: Thu,  8 Aug 2024 16:03:36 +0530
> From: Ani Sinha <anisinha@redhat.com>
> Subject: [PATCH] kvm: refactor core virtual machine creation into its own
>  function
> X-Mailer: git-send-email 2.45.2
> 
> Refactoring the core logic around KVM_CREATE_VM into its own separate function
> so that it can be called from other functions in subsequent patches. There is
> no functional change in this patch.
> 
> CC: pbonzini@redhat.com
> Signed-off-by: Ani Sinha <anisinha@redhat.com>
> ---
>  accel/kvm/kvm-all.c | 97 ++++++++++++++++++++++++++++-----------------
>  1 file changed, 60 insertions(+), 37 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 75d11a07b2..2bcd00126a 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2385,6 +2385,64 @@ uint32_t kvm_dirty_ring_size(void)
>      return kvm_state->kvm_dirty_ring_size;
>  }
>  
> +static int do_create_vm(MachineState *ms, int type)
> +{
> +    KVMState *s;
> +    int ret;
> +
> +    s = KVM_STATE(ms->accelerator);
> +
> +    do {
> +        ret = kvm_ioctl(s, KVM_CREATE_VM, type);
> +    } while (ret == -EINTR);
> +
> +    if (ret < 0) {
> +        fprintf(stderr, "ioctl(KVM_CREATE_VM) failed: %d %s\n", -ret,
> +                strerror(-ret));
> +
> +#ifdef TARGET_S390X
> +        if (ret == -EINVAL) {
> +            fprintf(stderr,
> +                    "Host kernel setup problem detected. Please verify:\n");
> +            fprintf(stderr, "- for kernels supporting the switch_amode or"
> +                    " user_mode parameters, whether\n");
> +            fprintf(stderr,
> +                    "  user space is running in primary address space\n");
> +            fprintf(stderr,
> +                    "- for kernels supporting the vm.allocate_pgste sysctl, "
> +                    "whether it is enabled\n");

Is it possible to convert fprintf to error_report()? Just like the
commit d0e16850eed3 ("hw/xen: convert stderr prints to error/warn
reports").

Regards,
Zhao

> +        }
> +#elif defined(TARGET_PPC)
> +        if (ret == -EINVAL) {
> +            fprintf(stderr,
> +                    "PPC KVM module is not loaded. Try modprobe kvm_%s.\n",
> +                    (type == 2) ? "pr" : "hv");
> +        }
> +#endif
> +    }
> +
> +    return ret;
> +}
> +
> +static int find_kvm_machine_type(MachineState *ms)
> +{
> +    MachineClass *mc = MACHINE_GET_CLASS(ms);
> +    int type;
> +
> +    if (object_property_find(OBJECT(current_machine), "kvm-type")) {
> +        g_autofree char *kvm_type;
> +        kvm_type = object_property_get_str(OBJECT(current_machine),
> +                                           "kvm-type",
> +                                           &error_abort);
> +        type = mc->kvm_type(ms, kvm_type);
> +    } else if (mc->kvm_type) {
> +        type = mc->kvm_type(ms, NULL);
> +    } else {
> +        type = kvm_arch_get_default_type(ms);
> +    }
> +    return type;
> +}
> +
>  static int kvm_init(MachineState *ms)
>  {
>      MachineClass *mc = MACHINE_GET_CLASS(ms);
> @@ -2467,49 +2525,14 @@ static int kvm_init(MachineState *ms)
>      }
>      s->as = g_new0(struct KVMAs, s->nr_as);
>  
> -    if (object_property_find(OBJECT(current_machine), "kvm-type")) {
> -        g_autofree char *kvm_type = object_property_get_str(OBJECT(current_machine),
> -                                                            "kvm-type",
> -                                                            &error_abort);
> -        type = mc->kvm_type(ms, kvm_type);
> -    } else if (mc->kvm_type) {
> -        type = mc->kvm_type(ms, NULL);
> -    } else {
> -        type = kvm_arch_get_default_type(ms);
> -    }
> -
> +    type = find_kvm_machine_type(ms);
>      if (type < 0) {
>          ret = -EINVAL;
>          goto err;
>      }
>  
> -    do {
> -        ret = kvm_ioctl(s, KVM_CREATE_VM, type);
> -    } while (ret == -EINTR);
> -
> +    ret = do_create_vm(ms, type);
>      if (ret < 0) {
> -        fprintf(stderr, "ioctl(KVM_CREATE_VM) failed: %d %s\n", -ret,
> -                strerror(-ret));
> -
> -#ifdef TARGET_S390X
> -        if (ret == -EINVAL) {
> -            fprintf(stderr,
> -                    "Host kernel setup problem detected. Please verify:\n");
> -            fprintf(stderr, "- for kernels supporting the switch_amode or"
> -                    " user_mode parameters, whether\n");
> -            fprintf(stderr,
> -                    "  user space is running in primary address space\n");
> -            fprintf(stderr,
> -                    "- for kernels supporting the vm.allocate_pgste sysctl, "
> -                    "whether it is enabled\n");
> -        }
> -#elif defined(TARGET_PPC)
> -        if (ret == -EINVAL) {
> -            fprintf(stderr,
> -                    "PPC KVM module is not loaded. Try modprobe kvm_%s.\n",
> -                    (type == 2) ? "pr" : "hv");
> -        }
> -#endif
>          goto err;
>      }
>  
> -- 
> 2.45.2
> 
> 

