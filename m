Return-Path: <kvm+bounces-45279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38858AA80BE
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 14:52:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9612A461146
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 12:52:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4182823717F;
	Sat,  3 May 2025 12:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="B812wfRS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE2619ADA4
	for <kvm@vger.kernel.org>; Sat,  3 May 2025 12:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746276739; cv=none; b=lQewqsNoX94tFG08nFFW4zmE3D0UCMzE2Yff3RuGzqsskzZu9JOarcN0pQgmI15E35xUUIzIDBbyzrkGp7Les9BSJXdQmLji9BSjv05px0OABjbti+NQwVXBfsiGkmtOMCUxQPt3gxLTCvtjYqQtUDi6am1yF4ofXoPrzLHS5Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746276739; c=relaxed/simple;
	bh=5Q4s5H51v4YjiEWogsK7dq20W1xoB9DMYqrDqtLQTlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qL6CgMLOXaTwQ1NWBztasn7lifS0+87Tr5A1obLw7DRweZMUSWLLtz/LKK1pCdOdc1kzl3u4q3R+EhjxeKSK8QwmqLFM09ZFgYONf9MuctwPXGjY2hdMKU6y6CwFq6Xnfv0wz3o0uO2GmNQXkGdIJWQUTq2Gu3Q+5JTRtaY0NqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=B812wfRS; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-39ee5ac4321so3290841f8f.1
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 05:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1746276736; x=1746881536; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tYaZItmLrRN7W/WhNOQd0NXAvbdv/VhuepsO+NlfyQs=;
        b=B812wfRSGVhsKwlhiCnp7x86ipgRIZm6O+xM18lye5BNd1z3T1xjEGbbtSX49L6/Eo
         4qNYlmK0vvEFZei4rUYuhLch+/JBYWo8vtCeUh19D1+HaEcNjXonZW1VkipBReb4S07x
         5ORmD0nD2bWUKk3who2lEciQrrB6unCNRizJMGRBDWtntjF3s4u/E2lOsz+GBKfRmKJ5
         AS2kQNbzSvIWeXUsQtjBHPLXUsDiU5ssSEdvQBiJRCaDGJsRFDH3zQgbYdlpnkRxpfxh
         gyCUJk3r6EGEBKAMudmQDBIUHxkNQaJJEnVxZPp77PYxBkd1LTeo1V4dwOhyQBHaGyWI
         Hc9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746276736; x=1746881536;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tYaZItmLrRN7W/WhNOQd0NXAvbdv/VhuepsO+NlfyQs=;
        b=fyKrDywM+tcwUJwXk0HfaiYqs0rFTVXO8m158y87ZgR7IjJJvqsbUWWn/j/HN2JC89
         HDrlPOVFuzUyn0QGQKp/ObnAMFSAJ7rBFTC1VAI9rK7TjOTOWmAsCYn8ivqbzl7l+Q1m
         OhcI+qSmZoA/PoY7HzjwCw3mqzZRvu1o1rp9uvMMpf0wE+qeuNu1CGWYd1HY0kUMXtrw
         /QFSR7XcFC3XhnPLpHFbg/qUr80r20ZDW2J72aUYZ5vEWP2So6uje+TN6QnghxYns5z6
         hGA86O5CX0MZ7zIq0ZHiFiz8feKrQEU6nXyJi6KyUQV4u2X3MFB2HZ087bQ1ejJGlVPd
         eFWA==
X-Forwarded-Encrypted: i=1; AJvYcCX3ZV7eCklXhhmH3gil9hkbxp+fZ/oYev/PpmHmS7H0ijLiEIJhDLZonK2UT82g1oRzpCo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz2OWdUPC82H7eAk4DsBt77WiMzR9zTMm5kkzKdziqWkjfU/iO
	cM6PQuLqwKNFSuKtkQvdcrej1+h7+c/OP6NTF9PCC/FGvJxt00BZfM0wv1fBkuU=
X-Gm-Gg: ASbGncuQgmlqgK8tTze2eT8u15oUiNMU0CU+hBisb/kyOJa0z0PWSXI+xZVE++957pa
	k8R7+lSuwW4jQh9+wEli1NtGS/lOxKyzdEAHwdoZ17d4/VIsQKVkFOAVoJ71/uX2nVumL6X6Jeo
	+yQVA9k22uLFU3tsODJHv1RAyvpolx0SqWuo8Tp8dZB7wKxCbwrdYT9l5DJFvrrH6vUdaoaV6d9
	whi226z4M0UYS2xVmWVf1GVuG8XBuwnRRsWcYoLZDCRTmsXtSTcL3aP+P9yVWvsIiAdYWA7JOMB
	pa0UcyuPsIeLCURDbGY3emFCvRYkb84Lt0xQKqQ=
X-Google-Smtp-Source: AGHT+IGLH9Z4ZKUhzh050EkBelZWBumftUMASYFOgD3UT7Zbv0mxLau8cCAhDmGvmZwhHErQBQ0eZQ==
X-Received: by 2002:a05:6000:1887:b0:38f:4acd:975c with SMTP id ffacd0b85a97d-3a09fd96325mr840113f8f.27.1746276735613;
        Sat, 03 May 2025 05:52:15 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::f716])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099b0f125sm4772656f8f.72.2025.05.03.05.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 05:52:15 -0700 (PDT)
Date: Sat, 3 May 2025 14:52:14 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Huth <thuth@redhat.com>, Andrew Jones <andrew.jones@linux.dev>, 
	kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2] scripts: Search the entire string for
 the correct accelerator
Message-ID: <20250503-0dc4b668579925c880337a5d@orel>
References: <20250502195618.848606-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502195618.848606-1-seanjc@google.com>

On Fri, May 02, 2025 at 12:56:18PM -0700, Sean Christopherson wrote:
> Search the entire ACCEL string for the required accelerator as searching
> for an exact match incorrectly rejects ACCEL when additional accelerator
> specific options are provided, e.g.
> 
>   SKIP pmu (kvm only, but ACCEL=kvm,kernel_irqchip=on)
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> v2: Require the accelerator string to match the start and end, with an
>     allowance for comma-seperate options. [Drew]
> 
>  scripts/runtime.bash | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 4b9c7d6b..ee229631 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -126,7 +126,7 @@ function run()
>          machine="$MACHINE"
>      fi
>  
> -    if [ -n "$accel" ] && [ -n "$ACCEL" ] && [ "$accel" != "$ACCEL" ]; then
> +    if [ -n "$accel" ] && [ -n "$ACCEL" ] && [[ ! "$ACCEL" =~ ^$accel(,|$) ]]; then
>          print_result "SKIP" $testname "" "$accel only, but ACCEL=$ACCEL"
>          return 2
>      elif [ -n "$ACCEL" ]; then
> 
> base-commit: abdc5d02a7796a55802509ac9bb704c721f2a5f6
> -- 
> 2.49.0.906.g1f30a19c02-goog
>

Merged.

Thanks,
drew

