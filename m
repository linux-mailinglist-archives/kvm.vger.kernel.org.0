Return-Path: <kvm+bounces-33221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF9DD9E7680
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 17:54:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 787FC28283A
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 16:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFBCB1F63F0;
	Fri,  6 Dec 2024 16:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="pxtfq+Gs"
X-Original-To: kvm@vger.kernel.org
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AECA1F37DE;
	Fri,  6 Dec 2024 16:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733504063; cv=none; b=Qo/ixvuTnpQU2iPp5opNXl1z20YIv9ySbrnD7XDVa5CMJg/mmbHQ6kxXq9xqD0UOR91/SFlsGOZuPqJFTo0kStL/yDLbhTKIRFpf1BIGW6gXEk5XfYbojz+CLIAggbdUqKyDTcjVW5afERpb+bg7RuR+VHMWgm/7DZynFXkoqcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733504063; c=relaxed/simple;
	bh=4c0qDcDGWbfhi2JPlFbVb3IxY7BtFLTA25A9XcroWQY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FpiBSTupz3MJqhdJrGoGaOkSeMbkOmKEdwfAkjF+x9SHReVMBuO8oPxb7TLP05pp1JZePvaBbumTXvyQODf6lqj0FP3E+Kzbq5iipiQjQA9vVZD/tx/RUSCpZtLIK8pi5NOqrCMbsF0LhhK4Sit0tpJfU0idOt1Af/8+7ygxc3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=pxtfq+Gs; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net C63274040A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1733504062; bh=aphGMcVNZxQQh1V/02EpA22OaxWF/8Zz7+xoEgrHPYs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=pxtfq+GslazVTKL48JPiQa1lPGF5s2Wqe27ngT2W4tp+snxGNG+WWyc1seL16oIEE
	 1jxZDzqcV1NhKFgiz8Wlop+0+nmvv7jAJkurt/u9ZtkVWSQQ57GEWHT2sP2iyxwWGS
	 5cUqO77YF4truzeN0crQjN6eoDPIXYQUYAczJX9P2eFFjC7Nglr3JeRDxvfMR7gngB
	 tBZM00a25rkJYQyLns060/ySaOOFFx56U9afNEOiGkfqfAXPJzv6z8Go8YNaVTP9cq
	 ZsaPzNXFjy/OWsXE2XSBMw8VE1kXE76+izciuG9UIZv2kTOb/CwSYxwD+UFTtWvhQl
	 2kU3Ak8Ex7zrg==
Received: from localhost (unknown [IPv6:2601:280:5e00:625::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id C63274040A;
	Fri,  6 Dec 2024 16:54:21 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Gianfranco Trad <gianf.trad@gmail.com>, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Gianfranco Trad <gianf.trad@gmail.com>
Subject: Re: [PATCH v2] Documentation: kvm: fix typo in api.rst
In-Reply-To: <20241115011831.300705-5-gianf.trad@gmail.com>
References: <20241115011831.300705-5-gianf.trad@gmail.com>
Date: Fri, 06 Dec 2024 09:54:20 -0700
Message-ID: <87v7vwsqf7.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Gianfranco Trad <gianf.trad@gmail.com> writes:

> Fix minor typo in api.rst where the word physical was misspelled
> as physcial.
>
> Signed-off-by: Gianfranco Trad <gianf.trad@gmail.com>
> ---
> Notes: 
>   - changes in v2: fixed a typo in the shortlog...
>
>  Documentation/virt/kvm/api.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index edc070c6e19b..4ed8f222478a 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5574,7 +5574,7 @@ KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA
>    in guest physical address space. This attribute should be used in
>    preference to KVM_XEN_ATTR_TYPE_SHARED_INFO as it avoids
>    unnecessary invalidation of an internal cache when the page is
> -  re-mapped in guest physcial address space.
> +  re-mapped in guest physical address space.
>  
It looks like nobody has picked this up, so I've just applied it.

Thanks,

jon

