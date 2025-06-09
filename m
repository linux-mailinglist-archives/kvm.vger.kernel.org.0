Return-Path: <kvm+bounces-48737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BE49AAD1E2A
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 14:54:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18DAA1887164
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 12:54:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1283257422;
	Mon,  9 Jun 2025 12:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="dje3YdAg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D35117A2EF
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 12:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749473672; cv=none; b=CQltJFbOkpMiN6Hw0KUndtwhjmyPqPp3oCre+yJKRAcTlk5zCK5oVP2nnCLcQ0pE3wDO2iEAIuCEXeW16yNLXQKuYj2TCzSbeea/7XkI2/oqEvKKLtRoh1Fulv0jFJ+uA+fFcIk2RajhzfoyxtdgRVyuoAwa/58gVTyJjHDa32I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749473672; c=relaxed/simple;
	bh=g0lqbFBPc8O9RqKPPbnkwDW7qPXz8SjHCy9PsChiGDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rRUEviP2LZXg0Bd77yIOvhZIfbls4NFMt6mbaH8mAc5cAESAeLwDej8Dzf1pXaUjN7C7YgPCPUV+5jpXRNTpuNFnsu3k8kB7fXooeuiSk8ZqKiSRA5CSpSbQIyzkTmOBNqnDreovu9jvpV9AYeuIglJcRmDTh1ptg8acghn6MMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=dje3YdAg; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3a522224582so2617574f8f.3
        for <kvm@vger.kernel.org>; Mon, 09 Jun 2025 05:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1749473669; x=1750078469; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xB2zG2k1G4WQxpgsH4LuYksFLvv8C8C4QIYaKBnq/b4=;
        b=dje3YdAgeZofprh9qQtGlBBz4ngPEfjGxbbvPTW86jsGgFurm3gfc8IxzTGHImdnWs
         i7F4GWIUUsn4kZP/bbZjqb7L3lutsIlHLojHhAL82Kqkir/wjeI4qOwmSDvTYCV74cAh
         0xbUqZJiXYVFnFQwKw37HEekYScbOr1Ei8UNPpzhVm7ESnalpdGuKhBFBHPB8foP9jNX
         iat7r8gXOZ8lwJUFS5VeKrVkwfIFosgvtvrNHPl5uNUev92s05+Fd7ea8JFfbqhv2FZ/
         Mieim2xg9uQ98Rz4G4ZWIg6edC5BXkfHqHxIc+5RxorWB/O0RdPaLZ5XY2msQbT951w6
         YOJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749473669; x=1750078469;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xB2zG2k1G4WQxpgsH4LuYksFLvv8C8C4QIYaKBnq/b4=;
        b=ePDsv3226tZTFAFPT8RsY0kWhh0+WFNjHmlTzJrt/1dL+g/290cg0yzFQ4ytQJQX9k
         MiLGiSx52AS9B4HE4dgsz0Qbt8dMlb87ghu4iB9Jvj1lSF1hLgoz5VIBEpHkuQb31HHI
         iiS2R/s02iNrQdz7Nbig2qgiLhmciiPVKYXhHG1CqZ3pGdlJx9K9sgJVsp6kNQ5pfL2I
         y7ZlAos9ColS54HAbC5ScTcOOY4drjqD5FaPJKqqVt2tnqWM44mPSWi6YZTh9LP1uJiD
         nEgBqb7n4aHveqxH++PCYrGm3GWGczZ8B1n+63OdrZ7l0gOyw+EfgblRPO1Wi4ZSd8Nh
         Ufag==
X-Gm-Message-State: AOJu0YyOwij+mstjWkyEA5bw1UZ9aXNk+dENHKUiTluD/w03AjLtY13+
	9Uf+Bp04PIYk3as5NS9fU+PWfsqrherVf8HUzI39MRzTv8fGlPyZJeriqXMptrYOzGE=
X-Gm-Gg: ASbGncvPBMSAk0TTgMur1EPDfY/z2sEgW0zNs9dgwt2GiknyQnWnf0ssbOPNNT5y+cp
	KfUNxsU8m+pmCpWJyfPBJkzJKVldYgTI8zULEo9eJcSF09748DsNg7ZNK+6t+vYneE07on4rw/S
	4/cl1ke+somMg+UgQVbjRQqepkr4k/7LUNIqR6MCAge/wz+pro6UnjXHwEZ36AYNdca7JYmPS1m
	jr2Jese9KKM89JK7alNWC3CvSE3D450oN5lRDn2UMgu9B46SX5d0fePFCdo9flUpcM61gHkPTP8
	zoKiISXxj6A0LOkOzdMLXQa/D56RE7m4Z9cGcrbY2ke8PUuArA==
X-Google-Smtp-Source: AGHT+IEC/1dBxgIFgGAmnWpdiKwEZouvKkkuBZf9Ps4mzSz9CyCY930v5yHNcYS1Azk34Z4raHel5g==
X-Received: by 2002:a5d:5f94:0:b0:3a4:eecf:b8cb with SMTP id ffacd0b85a97d-3a5318a7648mr10575693f8f.28.1749473668526;
        Mon, 09 Jun 2025 05:54:28 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::2f2d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4530748870bsm62109445e9.33.2025.06.09.05.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jun 2025 05:54:28 -0700 (PDT)
Date: Mon, 9 Jun 2025 14:54:27 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, seanjc@google.com, 
	pbonzini@redhat.com, anup@brainfault.org, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, maz@kernel.org, oliver.upton@linux.dev, 
	dmatlack@google.com
Subject: Re: [PATCH v2 15/15] KVM: selftests: Add riscv auto generated test
 files for KVM Selftests Runner
Message-ID: <20250609-cb3c80fbe1fe702668830b1b@orel>
References: <20250606235619.1841595-1-vipinsh@google.com>
 <20250606235619.1841595-16-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250606235619.1841595-16-vipinsh@google.com>

On Fri, Jun 06, 2025 at 04:56:19PM -0700, Vipin Sharma wrote:
> Add auto generated test files for s390 platforms.
                                    ^ riscv

Thanks,
drew

> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  tools/testing/selftests/kvm/tests/riscv/ebreak_test/default.test | 1 +
>  .../testing/selftests/kvm/tests/riscv/sbi_pmu_test/default.test  | 1 +
>  2 files changed, 2 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/tests/riscv/ebreak_test/default.test
>  create mode 100644 tools/testing/selftests/kvm/tests/riscv/sbi_pmu_test/default.test
> 
> diff --git a/tools/testing/selftests/kvm/tests/riscv/ebreak_test/default.test b/tools/testing/selftests/kvm/tests/riscv/ebreak_test/default.test
> new file mode 100644
> index 000000000000..d34b4b9b77ae
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/tests/riscv/ebreak_test/default.test
> @@ -0,0 +1 @@
> +riscv/ebreak_test
> diff --git a/tools/testing/selftests/kvm/tests/riscv/sbi_pmu_test/default.test b/tools/testing/selftests/kvm/tests/riscv/sbi_pmu_test/default.test
> new file mode 100644
> index 000000000000..5abb62c51097
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/tests/riscv/sbi_pmu_test/default.test
> @@ -0,0 +1 @@
> +riscv/sbi_pmu_test
> -- 
> 2.50.0.rc0.604.gd4ff7b7c86-goog
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

