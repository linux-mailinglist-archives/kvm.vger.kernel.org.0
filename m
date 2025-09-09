Return-Path: <kvm+bounces-57033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F764B49F14
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 04:19:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6AE74E212E
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 02:19:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD43624BBF0;
	Tue,  9 Sep 2025 02:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BAntUjAd"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC641A5B8A;
	Tue,  9 Sep 2025 02:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757384329; cv=none; b=BLjrl1Uazw/2vgzkLIiXY+Phlfvp+2ef5+yut+yyEiZjN3f5DY1A8hvprLFGw/xIoBuU4imll988Cmh0KZ2F+/ihiDDOh5HmftEhpP/6cCXvj93fFO4yWhZBv5cJTPLcF5DI1B7pmXGRL5zUcaDUwO9+xcFqzIImFddxsvP3rjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757384329; c=relaxed/simple;
	bh=WGDFdrUIO57RFhL1Hx4aXR5epVMihSnh5sl8CIbKJtw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=em/4yS26MUqWibdqDTYe0Ah7B3I+dfxvdvHYuxpmrV/dUF3cQ4MtsUo4f1NG7zeaaUm3c2C20hH6WZCy2yZSC+JFLj0qQSQNT4snVbu5uw7nj34VTrFj5+zMGp9KcAq/PFlC7ygTRMNIkfxaTxHgnGWalQG8L+quy10t6Hi+fX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BAntUjAd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=IofV6huNpOfUH9kOcfLlUEgXZUkpn9/vanabM6dcCKQ=; b=BAntUjAdRiibQDvNg0XKZqYZBb
	uGS+5AXqc8fqzISX1z2qOliaasU/p2spviAOv2gCoHCzu97fImJnVGPbIO7+5qiq5vXH2z0APUrdR
	0VW1qMpeX7crDrwIVBJZODZV4jCTTBKqII6TYICsRMGUxmON4eBFjWj5XPinAFI06lVEmEDrSKTz+
	QO1O7ml6iv0vOLAcZV+SHb12MXaDF8f/u9FsI93hm/p0JmCxZZskvruXz3v52f5bciGWbaiu/5gLB
	GaLecD5nPNIqM4Qw7M9T1obxoelYO+4sm9ghb2Jv05lXF70+cxI3mB2pT7npQJ9RwWaT+74+RcTJ0
	t8OVHqqw==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uvnwL-00000003eGh-0Sp2;
	Tue, 09 Sep 2025 02:18:37 +0000
Message-ID: <b23d3799-f8c3-4bd3-82ae-df9c3e965555@infradead.org>
Date: Mon, 8 Sep 2025 19:18:36 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Fix hypercalls docs section number order
To: Bagas Sanjaya <bagasdotme@gmail.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux KVM <kvm@vger.kernel.org>,
 Linux Documentation <linux-doc@vger.kernel.org>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Wanpeng Li <wanpengli@tencent.com>
References: <20250909003952.10314-1-bagasdotme@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250909003952.10314-1-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/8/25 5:39 PM, Bagas Sanjaya wrote:
> Commit 4180bf1b655a79 ("KVM: X86: Implement "send IPI" hypercall")
> documents KVM_HC_SEND_IPI hypercall, yet its section number duplicates
> KVM_HC_CLOCK_PAIRING one (which both are 6th). Fix the numbering order
> so that the former should be 7th.
> 
> Fixes: 4180bf1b655a ("KVM: X86: Implement "send IPI" hypercall")
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Yep. Thanks.

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  Documentation/virt/kvm/x86/hypercalls.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/x86/hypercalls.rst b/Documentation/virt/kvm/x86/hypercalls.rst
> index 10db7924720f16..521ecf9a8a361a 100644
> --- a/Documentation/virt/kvm/x86/hypercalls.rst
> +++ b/Documentation/virt/kvm/x86/hypercalls.rst
> @@ -137,7 +137,7 @@ compute the CLOCK_REALTIME for its clock, at the same instant.
>  Returns KVM_EOPNOTSUPP if the host does not use TSC clocksource,
>  or if clock type is different than KVM_CLOCK_PAIRING_WALLCLOCK.
>  
> -6. KVM_HC_SEND_IPI
> +7. KVM_HC_SEND_IPI
>  ------------------
>  
>  :Architecture: x86
> @@ -158,7 +158,7 @@ corresponds to the APIC ID a2+1, and so on.
>  
>  Returns the number of CPUs to which the IPIs were delivered successfully.
>  
> -7. KVM_HC_SCHED_YIELD
> +8. KVM_HC_SCHED_YIELD
>  ---------------------
>  
>  :Architecture: x86
> @@ -170,7 +170,7 @@ a0: destination APIC ID
>  :Usage example: When sending a call-function IPI-many to vCPUs, yield if
>  	        any of the IPI target vCPUs was preempted.
>  
> -8. KVM_HC_MAP_GPA_RANGE
> +9. KVM_HC_MAP_GPA_RANGE
>  -------------------------
>  :Architecture: x86
>  :Status: active
> 
> base-commit: a6ad54137af92535cfe32e19e5f3bc1bb7dbd383

-- 
~Randy

