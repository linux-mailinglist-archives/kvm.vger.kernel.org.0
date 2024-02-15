Return-Path: <kvm+bounces-8744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B98A855F1E
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 11:26:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18FAC1F25C56
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 10:26:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFF946995E;
	Thu, 15 Feb 2024 10:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="I0ProOXR"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC4E69940;
	Thu, 15 Feb 2024 10:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707992767; cv=none; b=qGEPZpi7hyTkl3ssgJulGwkFty/b9tA7ufni1tF0HbJ0dTEDQT5dLNa5pYoDMPy5Fhap0shqFUleKm4bF9UKf5LoYolC/Sl5NGdnUdQHUCJSVM2KsekyV4HVqpmzY5YwMuzpo2crBcleOAwJenIRsatsl/IyYJJGs0X2WnizGmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707992767; c=relaxed/simple;
	bh=y/P4R4hDfJZr0gCFtDW2pgobuhwlFJX18ctbuXp2Rto=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=UwoGoPG5PLKTaIOJ2zfsNH+rC7rVkvw/bl7yw0mXD8p8io/LHKs+EQ3fywYeczHB78CVyVU3/78WAmtDuHAQxcGv6iAp5AHp3ZQXXI7/9alw0JmEcyOPhEPSnlRWmoH91zr1WIhe3Ga6MePsq4BGCo0XhmqUttWiDQ5YxrsLEQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=I0ProOXR; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1707992756; bh=y/P4R4hDfJZr0gCFtDW2pgobuhwlFJX18ctbuXp2Rto=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=I0ProOXReh5OzzHB5mQQtlUKAJkkwkTPoB4VNzi3fjdWqcnFutbS55EeKWyftZ431
	 bi6OYPmYG24K6xbCHqPsYI6YEohYVfgje2cccptDFGLwn+ZjfkNBhMKNxqZkpI+YWV
	 LfO/fq02Sf7d9uq6fwUIC/t2p3UqEqTWBSizl474=
Received: from [28.0.0.1] (unknown [49.93.119.4])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 8FA0E60122;
	Thu, 15 Feb 2024 18:25:55 +0800 (CST)
Message-ID: <447f4279-aea9-4f35-b87e-a3fc8c6c20ac@xen0n.name>
Date: Thu, 15 Feb 2024 18:25:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/6] LoongArch: Add pv ipi support on LoongArch VM
Content-Language: en-US
From: WANG Xuerui <kernel@xen0n.name>
To: Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
References: <20240201031950.3225626-1-maobibo@loongson.cn>
 <0f4d83e2-bff9-49d9-8066-9f194ce96306@xen0n.name>
In-Reply-To: <0f4d83e2-bff9-49d9-8066-9f194ce96306@xen0n.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/15/24 18:11, WANG Xuerui wrote:
> Sorry for the late reply (and Happy Chinese New Year), and thanks for 
> providing microbenchmark numbers! But it seems the more comprehensive 
> CoreMark results were omitted (that's also absent in v3)? While the 

Of course the benchmark suite should be UnixBench instead of CoreMark. 
Lesson: don't multi-task code reviews, especially not after consuming 
beer -- a cup of coffee won't fully cancel the influence. ;-)

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/


