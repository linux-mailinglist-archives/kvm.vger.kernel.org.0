Return-Path: <kvm+bounces-56909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C0B42B46377
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:19:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AC58AA1B89
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 19:18:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50626274B41;
	Fri,  5 Sep 2025 19:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FErJ9/w/"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1232AD2F;
	Fri,  5 Sep 2025 19:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757099851; cv=none; b=KcJzn7Tvk4ShmqG3KPcIvmK7iAlBoKSvZkWlxJjtWRaOjldU+kjrsG/dO1BR89STS+CmhzrjSXEZyLZc9hbTZG+AzvBEqP/aA/ZZfMfYaS+xLXVyYWiuHoQjROZhDzV4tRonZjqFT7acxHidt8OUtyg+0u5bLPlgBhICqH/1IIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757099851; c=relaxed/simple;
	bh=6DvTqiz5oE0MUYIdGEJzKhFGMzFYNPmlC08fSMO//K0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tPRW9M7dXjaTgH4q5OODGzqIMZ1s5OxhkPOKMsXAtFL57TUDbC6Z0B4BhViecZwoG6r/+RVgSW0fv2bF1v0ZB7ZBp/NKL4AGcVLNW+B/HtQBW6NXeE5aaAwXcz7a+UJdh8k7bV+K7yl9P1eFpKGMqsq7sEVbnsDQVpy5eh2rSGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FErJ9/w/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=7GxwLQxCzAg843L+h1jj3ZmsSQYEHcvwK6GOI2qdcLA=; b=FErJ9/w/te2gPH6BxKrroAxz+G
	bVXzoOzrg4dNgUtPnai8uuA+wA4YKlh7N0xmNfqRszc/4z1LDvGh0IZEmqo3DrAktFhBwj5ITX+1o
	7SZLMrVi83c18nCN6MFmGIWL2KEHLYYu2sCZUYvnerk4tJtR1j8zWdU0+SXdCvZqT1+2Lnxvw52BH
	RdSEIQIVRF7BDpq183iBWkZ5+jWzALSB18bm/2Wu342DMXdwsumhB2AIC/Q5WWc3niUrUrDh+LSfn
	bPIAiDjsBhVfg7oluC6EikIiBGbg5B5rkxejyrntRe2SR5tIUeWb98ul1cqe9c+EfH/pq0qP0keH7
	oRF+acqQ==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uubw8-0000000444V-3ovf;
	Fri, 05 Sep 2025 19:17:28 +0000
Message-ID: <bccc8f53-9efa-4844-af5d-9abfe4446d06@infradead.org>
Date: Fri, 5 Sep 2025 12:17:28 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] Documentation: KVM: Add reference specs for PIT and
 LAPIC ioctls
To: Jiaming Zhang <r772577952@gmail.com>
Cc: corbet@lwn.net, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
References: <00378f4c-ac64-459d-a990-6246a29c0ced@infradead.org>
 <20250905174736.260694-1-r772577952@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250905174736.260694-1-r772577952@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/5/25 10:47 AM, Jiaming Zhang wrote:
> ---
> 
> The behavior of KVM_SET_PIT2 and KVM_SET_LAPIC conforms to their
> respective hardware specifications. Add references to the Intel 8254
> PIT datasheet and the Software Developer's Manual (SDM)  to ensure
> users can rely on the official datasheets for behavioral details.
> 
> Signed-off-by: Jiaming Zhang <r772577952@gmail.com>

Thanks. LGTM.

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  Documentation/virt/kvm/api.rst | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 6aa40ee05a4a..f55e1b7562db 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -2083,6 +2083,11 @@ The format of the APIC ID register (bytes 32-35 of struct kvm_lapic_state's
>  regs field) depends on the state of the KVM_CAP_X2APIC_API capability.
>  See the note in KVM_GET_LAPIC.
>  
> +.. Tip::
> +  ``KVM_SET_LAPIC`` ioctl strictly adheres to Intel® 64 and IA-32 Architectures
> +  Software Developer's Manual (SDM). Refer to volume 3A of the `Intel SDM
> +  <https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html>`_.
> +
>  
>  4.59 KVM_IOEVENTFD
>  ------------------
> @@ -3075,6 +3080,13 @@ This IOCTL replaces the obsolete KVM_GET_PIT.
>  Sets the state of the in-kernel PIT model. Only valid after KVM_CREATE_PIT2.
>  See KVM_GET_PIT2 for details on struct kvm_pit_state2.
>  
> +.. Tip::
> +
> +  ``KVM_SET_PIT2`` ioctl strictly adheres to the spec of Intel 8254 PIT.
> +  For example, a ``count`` value of 0 in ``struct kvm_pit_channel_state`` is
> +  interpreted as 65536, which is the maximum count value. Refer to `Intel 8254
> +  programmable interval timer <https://www.scs.stanford.edu/10wi-cs140/pintos/specs/8254.pdf>`_.
> +
>  This IOCTL replaces the obsolete KVM_SET_PIT.
>  
>  

-- 
~Randy

