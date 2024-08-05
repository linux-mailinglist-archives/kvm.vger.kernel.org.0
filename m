Return-Path: <kvm+bounces-23269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 759E3948583
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 00:51:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD626B219F8
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 22:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5043416CD3A;
	Mon,  5 Aug 2024 22:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v9/JbKBc"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBF6149C4E
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 22:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722898302; cv=none; b=VPjgbBCCafWJNOJvV5Wvfft8/3vFAzueGMONQWErWSkg2PGtuSMD9RDMWc0WPd/q/Vknm8pikU8lSmy4K3Xl0XFpzbmxzQbbFVRkCXudGBXemeyaQKr8kpBh0KInAS9oGWUSzqx6WXKuhhnuDJgiplZSrSRXO5JqR/ea7WSshMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722898302; c=relaxed/simple;
	bh=p3tLUrfNddfAk1UuCgvQpVj7bRwtyBexnrqg2usS0hY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u/rxiHqLHl0aXxs2Cn7maYtVkk4LM9s1IXabEgWK8S+ntI9vp5ZdNadHc1gjrR1jn7G+ClwBeNXmXzjzlUnS8Wh6BjARtu6B95GvD7L9T0TZtNpwulY6uy+4KCG0L426wqoS/NRoraf9U06j08h5F/3HxnkPiMuizEuXCNztIWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v9/JbKBc; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 5 Aug 2024 22:51:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1722898297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z1HJCaOT1LQo49Cr/YJoEzk2PYQNpvUa5TuxAjrVzEA=;
	b=v9/JbKBctJQE+c4stOdYSdwf4gIW5RIT+YJgQxfvgeUDKtGBiDgfc8Z7gBuVDLSmhghF8V
	7sCHwAmUn2S0baVM5q5q10vxtxudc3s0xb+c3jg95jTGgYECqQX4h123vkkjZl5GEo5u9l
	1b7ILkdTEUUBpHDfwGbtTNmRjMDxo00=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Anish Moorthy <amoorthy@google.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	jthoughton@google.com, rananta@google.com
Subject: Re: [PATCH 2/3] KVM: arm64: Declare support for
 KVM_CAP_MEMORY_FAULT_INFO
Message-ID: <ZrFXcHnhXUcjof1U@linux.dev>
References: <20240802224031.154064-1-amoorthy@google.com>
 <20240802224031.154064-3-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240802224031.154064-3-amoorthy@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Aug 02, 2024 at 10:40:30PM +0000, Anish Moorthy wrote:
> Although arm64 doesn't currently use memory fault exits anywhere,
> it's still valid to advertise the capability: and a subsequent commit
> will add KVM_EXIT_MEMORY_FAULTs to the stage-2 fault handler
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 2 +-
>  arch/arm64/kvm/arm.c           | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 8e5dad80b337..49c504b12688 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8128,7 +8128,7 @@ unavailable to host or other VMs.
>  7.34 KVM_CAP_MEMORY_FAULT_INFO
>  ------------------------------

<nitpick>

The wording of the cap documentation isn't as relaxed as I'd
anticipated. Perhaps:

  The presence of this capability indicates that KVM_RUN *may* fill
  kvm_run.memory_fault if ...

IOW, userspace is not guaranteed that the structure is filled for every
'memory fault'.

> -:Architectures: x86
> +:Architectures: x86, arm64

nitpick: alphabetize

>  :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
>  
>  The presence of this capability indicates that KVM_RUN will fill
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index a7ca776b51ec..4121b5a43b9c 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -335,6 +335,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_SYSTEM_SUSPEND:
>  	case KVM_CAP_IRQFD_RESAMPLE:
>  	case KVM_CAP_COUNTER_OFFSET:
> +	case KVM_CAP_MEMORY_FAULT_INFO:
>  		r = 1;
>  		break;

Please just squash this into the following patch. Introducing the
capability without the implied functionality doesn't make a lot of
sense.

-- 
Thanks,
Oliver

