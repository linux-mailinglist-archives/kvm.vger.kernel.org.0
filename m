Return-Path: <kvm+bounces-12547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 07467887A05
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 19:48:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37E781C20C0E
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 18:48:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6F9558AB4;
	Sat, 23 Mar 2024 18:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="QMSfzB9R"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBA54C3C3;
	Sat, 23 Mar 2024 18:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711219726; cv=none; b=ZVg/JwTryWbQM6hkc43/pIoQcraQtEpxGo5RRM0eox876ztvrwqoL0WsOOwZ4TOmSbs09IRhtWrnze0YHnuV7329nwO01KlK1Ow1Djmyn4BS9cYcs2OeEStwO8tcB+YQgiqDwKDfm1ttgvtKj+XSSzZozpeAovAXamJcKAxVnKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711219726; c=relaxed/simple;
	bh=npwipMtKSwmLf9mv4yQ2FyleQl5NkVskeswqDmWzh0g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KxxOePsbD/H9h6iY4p4TQA3uQC+kaF7bUR3k0aY/nVmc3yEzno8rA8UymRVuB4/QVUIrTOKDBrH9OtJO0N6XqIqJ8qVh8qHzr6X3S18uR83TK9yoI7ZQ3KFFbUlhiz64RItQnOSmQQrLAVRGrxzrmT3dlQIErlvjsP2m6htovRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=QMSfzB9R; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1711219204; bh=npwipMtKSwmLf9mv4yQ2FyleQl5NkVskeswqDmWzh0g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QMSfzB9RAzfhKYaxTnVOG0t1sAMrc040mVeLSw5dcg6t2kvKK/yOZQHfSyfNd5VDs
	 HpcJ04SmV4fjOhSsWeQyid5DxcOaFvL2IaSn+l1YrmmAoJU8ik7X9A7xG/ERvn82SR
	 /jLSjwcwGVaqd8H3/KPx68+iUsJXdQ0RVxpoFZkA=
Received: from [IPV6:240e:388:8d00:6500:cccf:e2b8:7fab:4dfb] (unknown [IPv6:240e:388:8d00:6500:cccf:e2b8:7fab:4dfb])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 6AB18600A6;
	Sun, 24 Mar 2024 02:40:04 +0800 (CST)
Message-ID: <68473508-dbf1-4875-a392-88ca09f7ea63@xen0n.name>
Date: Sun, 24 Mar 2024 02:40:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 7/7] Documentation: KVM: Add hypercall for LoongArch
Content-Language: en-US
To: Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
References: <20240315080710.2812974-1-maobibo@loongson.cn>
 <20240315081104.2813031-1-maobibo@loongson.cn>
From: WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <20240315081104.2813031-1-maobibo@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/24 16:11, Bibo Mao wrote:
> [snip]
> +KVM hypercall ABI
> +=================
> +
> +Hypercall ABI on KVM is simple, only one scratch register a0 and at most
> +five generic registers used as input parameter. FP register and vector register
> +is not used for input register and should not be modified during hypercall.
> +Hypercall function can be inlined since there is only one scratch register.

Maybe it's better to describe the list of preserved registers with an 
expression such as "all non-GPR registers shall remain unmodified after 
returning from the hypercall", to guard ourselves against future ISA 
state additions.

But I still maintain that it's better to promise less here, and only 
hint on the extensive preservation of context as an implementation 
detail. It is for not losing our ability to save/restore less in the 
future, should we decide to do so.

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/


