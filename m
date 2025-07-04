Return-Path: <kvm+bounces-51597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C20FAAF9110
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 13:11:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3DDC3AFD72
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 11:11:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6CA82C15A0;
	Fri,  4 Jul 2025 11:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZHGROoWI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48736236A9F
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 11:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751627510; cv=none; b=cFcuV4mJjJOjb564kJK1lLKHZVj1bWFiyEgQJHDgVcL9TxJX1AxDl54BcMsYkMO/R0hYLbZbifWp4EoAntBlVUAdwHM/0aGZgvoha7bzWp1TuffkksjFn9MKTcMthbulOpwjncC4Vk2xTxUWi++hf161a9qrACCi/NzCs+KMAw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751627510; c=relaxed/simple;
	bh=o1Nrk5RUp6fY1bkTBtN3Hp9y0X6x3rmoyVhWTfb40es=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fldwwBQjZidBCtDkx6AXo8IbF6u39Hq1BtoUmgSd+JmS7GK2imVMJGRUIoQ2nXqpVDiprv8g1Uxm+MVTKpHCN4hUvX2HhWbgoJXHWVw1O38NKsvfRE3A28amQQJ67w/jjswq2ujPC2yDE3Zhrs/PLe8Q2bEiBSKxnYe9T6SfLNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZHGROoWI; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751627509; x=1783163509;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=o1Nrk5RUp6fY1bkTBtN3Hp9y0X6x3rmoyVhWTfb40es=;
  b=ZHGROoWIVbTocSnS11JN8T3jPsmxOxVDM6+AH3jW51UzojTNVqY3QnFm
   5JoqhrhI7kyoBphsVaVzVteJWyxKpTu2R/Z1i9vzC1zhc/8Ntxdpb4bM7
   z1EraBwG8AuJHEwc8+1PZKbG0+AquZEUVH6xgpuyRoPe7GjOmN3Huqkrz
   hsLwehFw/N83Wb95eSWfZ7WoQ2ujJF4LHiWJeGlV7pqrB7qzt6dXCynQX
   t8jY6xekMUGgYZoAfJoE4ffF/gniHtu2Qtav9XsXZ+BbhtXx7X253qm2r
   TeS0TwY4OlxTDASXxe8DqJkmlAjPGmIRdySwIZqeKnAJnTb+3UqJgoDt8
   Q==;
X-CSE-ConnectionGUID: ybu3KKynT8WEpjVDaapGKw==
X-CSE-MsgGUID: 1G7iltQcS8mbXeejMFXFAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="54104359"
X-IronPort-AV: E=Sophos;i="6.16,287,1744095600"; 
   d="scan'208";a="54104359"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 04:11:48 -0700
X-CSE-ConnectionGUID: 9GV3W5YtQfabXlm8uFAwUA==
X-CSE-MsgGUID: Rb2p5PN2TDWcFZtsdBilyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,287,1744095600"; 
   d="scan'208";a="154746779"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa007.jf.intel.com with ESMTP; 04 Jul 2025 04:11:44 -0700
Date: Fri, 4 Jul 2025 19:33:09 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Mads Ynddal <mads@ynddal.dk>, Fabiano Rosas <farosas@suse.de>,
	Laurent Vivier <lvivier@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Warner Losh <imp@bsdimp.com>, Kyle Evans <kevans@freebsd.org>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v6 30/39] accel: Propagate AccelState to
 AccelClass::init_machine()
Message-ID: <aGe79U/acV51nQM9@intel.com>
References: <20250703173248.44995-1-philmd@linaro.org>
 <20250703173248.44995-31-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250703173248.44995-31-philmd@linaro.org>

On Thu, Jul 03, 2025 at 07:32:36PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu,  3 Jul 2025 19:32:36 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v6 30/39] accel: Propagate AccelState to
>  AccelClass::init_machine()
> X-Mailer: git-send-email 2.49.0
> 
> In order to avoid init_machine() to call current_accel(),
> pass AccelState along.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  include/qemu/accel.h        | 2 +-
>  accel/accel-system.c        | 2 +-
>  accel/hvf/hvf-all.c         | 2 +-
>  accel/kvm/kvm-all.c         | 2 +-
>  accel/qtest/qtest.c         | 2 +-
>  accel/tcg/tcg-all.c         | 2 +-
>  accel/xen/xen-all.c         | 2 +-
>  bsd-user/main.c             | 2 +-
>  linux-user/main.c           | 2 +-
>  target/i386/nvmm/nvmm-all.c | 2 +-
>  target/i386/whpx/whpx-all.c | 2 +-
>  11 files changed, 11 insertions(+), 11 deletions(-)

...

> diff --git a/accel/accel-system.c b/accel/accel-system.c
> index b5b368c6a9c..fb8abe38594 100644
> --- a/accel/accel-system.c
> +++ b/accel/accel-system.c
> @@ -37,7 +37,7 @@ int accel_init_machine(AccelState *accel, MachineState *ms)
>      int ret;
>      ms->accelerator = accel;
>      *(acc->allowed) = true;
> -    ret = acc->init_machine(ms);
> +    ret = acc->init_machine(accel, ms);

Now we've already set "ms->accelerator", so that we could get @accel
by ms->accelerator.

But considerring the user emulation, where the @ms is NULL, and for
these cases, it needs to bring current_accel() back in patch 32.

Anyway, this solution is also fine for me, so,

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


...But there're still more comments/questions about user emulation:

> --- a/bsd-user/main.c
> +++ b/bsd-user/main.c
> @@ -474,7 +474,7 @@ int main(int argc, char **argv)
>                                   opt_one_insn_per_tb, &error_abort);
>          object_property_set_int(OBJECT(accel), "tb-size",
>                                  opt_tb_size, &error_abort);
> -        ac->init_machine(NULL);
> +        ac->init_machine(accel, NULL);

Not the issue about this patch though,

it seems user emulation doesn't set acc->allowed. At least TCG enabled
is necessary, I guess?

>      }
>  
>      /*
> diff --git a/linux-user/main.c b/linux-user/main.c
> index 5ac5b55dc65..a9142ee7268 100644
> --- a/linux-user/main.c
> +++ b/linux-user/main.c
> @@ -820,7 +820,7 @@ int main(int argc, char **argv, char **envp)
>                                   opt_one_insn_per_tb, &error_abort);
>          object_property_set_int(OBJECT(accel), "tb-size",
>                                  opt_tb_size, &error_abort);
> -        ac->init_machine(NULL);
> +        ac->init_machine(accel, NULL);

Ditto.

>      }
>  
>      /*

Thanks,
Zhao


