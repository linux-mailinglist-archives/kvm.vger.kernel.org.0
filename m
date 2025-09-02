Return-Path: <kvm+bounces-56603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0507EB4090E
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 17:37:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E3C8016B2CD
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 15:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7360326D50;
	Tue,  2 Sep 2025 15:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="T2Y5ChM9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6C5322C99
	for <kvm@vger.kernel.org>; Tue,  2 Sep 2025 15:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756827374; cv=none; b=Ha5sHVnLxNaLyEPKX4ayhB6jvDd4uUP3kYgYgoZuFQqlGTOMDUBwVCPDD0iIHRZH9o4gUVFAkOZlU2YqVl+t+OeatpdE+5EcLmtxuRFLQ77wmwH7DjuyIy//cJu5z7bIXANrJbkdhpvYkI1pXQg+xw0s4jxjsfDkc+/6fbkxlLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756827374; c=relaxed/simple;
	bh=pQfx5rbbo9VQV6yem/9gGiPAtj7wlmVzU3U4hgkJ1I0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VSavvD3w1JfCyOUrskehOzLQGXnY2spHxB8poXG96yd1Y3+92Z4Dy5BPWqnM9SWdeC7fIBfelJEij996Q6DnlrSI8aFDZdx6lN1TV1B9B8V+vESs91ClLOhNe7ZqHEg/yKU5BfzXZByAUOwdBjzQVmgRG0cLqCvSJXpZKC32TDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=T2Y5ChM9; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3f2b6e0b942so23772295ab.1
        for <kvm@vger.kernel.org>; Tue, 02 Sep 2025 08:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1756827371; x=1757432171; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K9s+kfAE8HRXPT1H9Bh1Vhsm3UofgSwfxkPjIm95TJo=;
        b=T2Y5ChM9hTNIdeDM5yJ1one2K7VvP7XcE2iK+G198VkCs3N1rdlI0hxHDjZuRk5jnb
         xPSWnnSwceWN6cmrLHZUN1p6e3LcVSp7KAlCGY36zm8/rdZFutCg6Qi28oUmpYEAEaII
         qCqQegFYf+jXfijc2xtFEtXW1HnJMJJmeG90BWIrDBALZFOvfs70Djo9WzHmkMl3lm41
         6jAO61b1hO3WsDnJnYryszEgeYMi0pRDT6WM/h7xTYFPsJtfvkWSwfx1uY1IjC2uz8Bs
         4SVoxvt+B+7pAOPgOUhEyfritekaFAWs5mxJS032uonpPQ2AgFsN3cxUtdyvHNAtDTJw
         ygGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756827371; x=1757432171;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K9s+kfAE8HRXPT1H9Bh1Vhsm3UofgSwfxkPjIm95TJo=;
        b=ovl8I1HWQUau/EU820A+wgo7iqXxA5iPPEoT6PJ/RoPrs05EEgfWWRMeFO568qhwme
         GO2ilOUYGGznH+xwd7PDnKBFH5zjM6wngI6Ot4fpfbm2gN0f65QfIgIDGrGCrWy5nWkJ
         R0++V/0P5a0+soF5J8YBQq+onhd16rbVFUdtW5j8skNl4/h67grT6EN+8d4aHlWDSCFV
         5zRlw8N1gH5I6CO7gyxu9voB1Kym0E48B8CwoW7gjJZ49RxsSWkzbdOMaoVn9XCovmb/
         sl6sQYcymIz3ijlTmjfTorbJxir9jjUPEOQFkoxTB6tLJGVS1HCAcd4oy5eXEl7Xey62
         CbwA==
X-Forwarded-Encrypted: i=1; AJvYcCWZCv3OTlLQTsmSpqw7HSplSd5DtXQejBrspGQIYZBxFBQWfRBztiuejrLQdF5vS2bS20I=@vger.kernel.org
X-Gm-Message-State: AOJu0YymGyRGGWlC4PMXVSpYicGP5ZPGa9ePxj1jiADb9BvUq6Q7xJCd
	IBvQzCYnw0CP4HF/cJZpvfa3Rwg/By2iGwW9jCSSI9tZ2p5S8heF6Q7UfHmFoMjtcis=
X-Gm-Gg: ASbGncsmubk+iPuJb8g7AXQDN2HtrFPnfeDRmTItbS+eE2oWPCNopSCYorpyR2y/LFp
	qiAmwlDWOPPnKWWkosyCtlkv+opZKX64eEzhuyMFtjXGMM19EFuT1W0p58DdhAsJZPPOjBSxkEw
	BVxbZ1rAej2yrsVNbFwKHwsDsaM9YjwqCtuLMbmNJnsNMCLQhagYRR7UkDV5hEpzNyrVfVtz44q
	7Noo8IIYaONKP+BWwbmCpIDwhfaks/WzWzYvT+m+2wmHVyXrHCn3XSTSwF9JRsw9n71sVn75T0T
	uIP2QQQgAbXME34tLZGJcmyxPEOGx1AbjUrRmp24RY6A/x+0T78x46YF5XIwnYVcEr5MX+yaJrX
	eCc5lxoK12YkrF8jHRmgRcyYX
X-Google-Smtp-Source: AGHT+IES7nRiJ9CHZ2JkifKal6ueldn9qBf26MOJ0udQNkIKmIhptPxDm7X55cZKJRjHHzBvZ9JRfA==
X-Received: by 2002:a05:6e02:2302:b0:3f0:62bf:f23 with SMTP id e9e14a558f8ab-3f401aee1b6mr224147135ab.15.1756827371527;
        Tue, 02 Sep 2025 08:36:11 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50d8f35cd88sm3180471173.59.2025.09.02.08.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 08:36:10 -0700 (PDT)
Date: Tue, 2 Sep 2025 10:36:10 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: dayss1224@gmail.com
Cc: pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	atish.patra@linux.dev, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, alex@ghiti.fr, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH v3 0/3] KVM: riscv: selftests: Enable supported test cases
Message-ID: <20250902-9cc0d0dad59ba680062dbbf8@orel>
References: <cover.1756710918.git.dayss1224@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1756710918.git.dayss1224@gmail.com>

On Mon, Sep 01, 2025 at 03:35:48PM +0800, dayss1224@gmail.com wrote:
> From: Dong Yang <dayss1224@gmail.com>
> 
> Add supported KVM test cases and fix the compilation dependencies.
> ---
> Changes in v3:
> - Reorder patches to fix build dependencies
> - Sort common supported test cases alphabetically
> - Move ucall_common.h include from common header to specific source files
> 
> Changes in v2:
> - Delete some repeat KVM test cases on riscv
> - Add missing headers to fix the build for new RISC-V KVM selftests
> 
> Dong Yang (1):
>   KVM: riscv: selftests: Add missing headers for new testcases
> 
> Quan Zhou (2):
>   KVM: riscv: selftests: Use the existing RISCV_FENCE macro in
>     `rseq-riscv.h`
>   KVM: riscv: selftests: Add common supported test cases
> 
>  tools/testing/selftests/kvm/Makefile.kvm                    | 6 ++++++
>  tools/testing/selftests/kvm/access_tracking_perf_test.c     | 1 +
>  tools/testing/selftests/kvm/include/riscv/processor.h       | 1 +
>  .../selftests/kvm/memslot_modification_stress_test.c        | 1 +
>  tools/testing/selftests/kvm/memslot_perf_test.c             | 1 +
>  tools/testing/selftests/rseq/rseq-riscv.h                   | 3 +--
>  6 files changed, 11 insertions(+), 2 deletions(-)
> 
> -- 
> 2.34.1

In the future please CC previous reviewers on the entire series
(particularly when they have reviewed the entire previous series).

For the series,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

