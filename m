Return-Path: <kvm+bounces-59635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A7917BC48BA
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 13:25:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id F0D1B3511B6
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 11:25:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D47E2F6191;
	Wed,  8 Oct 2025 11:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="opvK7vwX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8438221767A;
	Wed,  8 Oct 2025 11:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759922735; cv=none; b=crl6+05QQ3Y+cFCEbDSgpvCjez1xZ9C5y2YiLbIWRK0AFsDiYQNa9W4BeC//51rxGbowD2h8IKDSEu2Qy3Mn6GtV2H6msJ1Kixk5IsNz1EUSLYY51WdnQxx7B6QFoBzedCqNU2loONA1EFzjJRPCEdH+PGEyH/SC/AcQdoOp1Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759922735; c=relaxed/simple;
	bh=wF5dPYFYimeUgSWA+M+3jfz7QJ554eh/ZJK6xYLJ8qM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iabZjzxJvBz+XUMcJ+Wnn0NTAvrl3PxLjJ36aIkD5sD90+SoC2stRCuCfl2C5qH2ZX2rC0AFTX3eqI0DH/c7Of/SZa3VI/yfvFXozOOrzM2i7l2MdZf/0Wgs9da2mlhip8Wv0GEby2KBWC+IQ3XLObFnPPL/3qIgw9U9mN+MFLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=opvK7vwX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572F5C4CEF4;
	Wed,  8 Oct 2025 11:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759922735;
	bh=wF5dPYFYimeUgSWA+M+3jfz7QJ554eh/ZJK6xYLJ8qM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=opvK7vwX0GSe7RXt2FGn/JC7l226lVVDdiFzibqK8HYLsO9kHcMc2B21nXwIDZhoN
	 Qz9hUqhUEoCMs8/T+N0SJg7LGjK5QKmY8t0xyUOTHzFvYIdbFZ2boFjRMNDVC2M2V8
	 DCw0MDV+Ha6E6pAl3hweF2Jntqz2U4SDqR7tvA+elQYPtXNgVDXQRwqEZjTBl1OeJo
	 eA3ghZjfo3ddk7gindsjEOniaNMMV7qMzY8FVte/Zp4WbtbA8104Lt7EWy3EjtB4x9
	 3nnLNwmQ28aZYfF/udBrq9fj0ky/PANhnGr8W/r7wgxzrOBh8vHOvzitRHf91yXJLh
	 NgE5CibGeCI3g==
Date: Wed, 8 Oct 2025 13:00:46 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Manali Shukla <manali.shukla@amd.com>
Cc: kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-doc@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com, nikunj@amd.com, 
	bp@alien8.de, peterz@infradead.org, mingo@redhat.com, mizhang@google.com, 
	thomas.lendacky@amd.com, ravi.bangoria@amd.com, Sandipan.Das@amd.com
Subject: Re: [PATCH v2 10/12] KVM: SVM: Add support for IBS Virtualization
Message-ID: <ts57y4xsspyykwx32ge4fb46jchjl2pas7wa2mrtswevbluufu@4ijxkv24ohon>
References: <20250901051656.209083-1-manali.shukla@amd.com>
 <20250901052536.209251-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250901052536.209251-1-manali.shukla@amd.com>

On Mon, Sep 01, 2025 at 10:55:36AM +0530, Manali Shukla wrote:
> From: Santosh Shukla <santosh.shukla@amd.com>
> 
> +static void svm_ibs_set_cpu_caps(void)
> +{
> +	kvm_cpu_cap_check_and_set(X86_FEATURE_IBS);
> +	kvm_cpu_cap_check_and_set(X86_FEATURE_EXTLVT);

Do we need this? AFAICS, this is only relevant for nested guests and we 
don't support AVIC for nested guests.

> +	kvm_cpu_cap_check_and_set(X86_FEATURE_EXTAPIC);

Should this instead be set as part of adding emulation support for 
extended APIC?

- Naveen


