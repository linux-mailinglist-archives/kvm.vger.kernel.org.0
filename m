Return-Path: <kvm+bounces-43257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64070A88951
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 19:05:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD5CC1893F32
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 17:05:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3966288CBD;
	Mon, 14 Apr 2025 17:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="HLuj6g/B"
X-Original-To: kvm@vger.kernel.org
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDD71A29A;
	Mon, 14 Apr 2025 17:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744650333; cv=none; b=EjUhihcEugoLWvo/9QxAVW45Q2r3HRrDEnAQ/qvWvanp2eBtJAMliVOM8ZlrPQV7kTHZiJ7uid+JfQPEMZ12mY4WHHZmia6KWrS+7yomdbygbogfV7XXuuBIJnorSobVytXQefIryL19pw77NmIuZDkd4mTDTBbzgBIRoCAW5nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744650333; c=relaxed/simple;
	bh=t/KetL+A/wJmvv1bmNlxqP2hW4xNEy5F9j0XPihvCik=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=E93diinsn9bcmaShqPz4mMzX511Q96I21rMtlRk4hOMva8C+Ym4egKGOKNG/3sZwL0QDEPqxRwuOYrbTou/vh57hcb4eBYjx/iKm+UkEXbocmVho+N0nYcwb2ubpfqS+t7tR1cP6LExOlvqCtY+hJQ2l7wqs8FqfHct8oPrMU2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=HLuj6g/B; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net BB64641062
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1744650330; bh=ku9qE/yuQA7Fzf/9Lh2nHhyG6AWPqEHjv/q7LJKhUMM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=HLuj6g/ByovvmWlQASFCNPMXHfnpMwyqzOV9YbOmpSH2BFQginLZGfj43MSyVPo+e
	 YCUa8Q1ZdB9hRCs8dBoL/ZsupWlkp7WwA9Mi5s7KcTq6UASpAgF6IMMAbFxzL75qql
	 XNm5OPIgrbkbDXSe/f7U1a/QW5wl4O22n/HaZfFAFLrLjBO2LofvAZFWtfHqngnPve
	 RC82/s5jr2rHJTFlKX0jUOQqFGYXq12pzL9x0bHqdWhmz0s/OmW4LdhXg/81xHGVhg
	 QZTYltnJ7rhh07F5LugI52yvlTSNZrfMclBbgDDa7hoBmmdynr1O5aDWxcqxX45AEF
	 ttxQKqFxw3vXA==
Received: from localhost (unknown [IPv6:2601:280:4600:2da9::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id BB64641062;
	Mon, 14 Apr 2025 17:05:30 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: "Xin Li (Intel)" <xin@zytor.com>, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com
Subject: Re: [PATCH v1 1/1] Documentation: kvm: Fix a section number
In-Reply-To: <20250414165146.2279450-1-xin@zytor.com>
References: <20250414165146.2279450-1-xin@zytor.com>
Date: Mon, 14 Apr 2025 11:05:29 -0600
Message-ID: <87sema8yhy.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

"Xin Li (Intel)" <xin@zytor.com> writes:

> The previous section is 7.41, thus this should be 7.42.
>
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> ---
>  Documentation/virt/kvm/api.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 47c7c3f92314..58478b470860 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8478,7 +8478,7 @@ ENOSYS for the others.
>  When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
>  type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
>  
> -7.37 KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
> +7.42 KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
>  -------------------------------------

The fix seems fine but ... I have to ask ... do the section numbers buy
anything here?  We have a documentation system that can do nice
cross-references when needed, so I'm not sure that these numbers add
anything other than a bit of manual maintenance hassle.

Thanks,

jon

