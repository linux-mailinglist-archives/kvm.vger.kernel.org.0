Return-Path: <kvm+bounces-57736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EF2A5B59CB9
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:00:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D7D81B25AB2
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E6973728B2;
	Tue, 16 Sep 2025 15:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="igY1sd5h"
X-Original-To: kvm@vger.kernel.org
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CF937289B;
	Tue, 16 Sep 2025 15:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758038395; cv=none; b=UEPlKakI8UKNwhgdkMROvwuQBlKZaHMJJLQuZIJAZH0EcsJ6JYYJZDGac24oz+JGeMinVKGFzjNkZ0aIAXr0KJHifxfaVGMTJqeXmqkTbSw/9F8eK5C1D2l/f/4Q9EDWqmczzlfpdoDhPbusMRkz4sCh49pwbnU8s79Klfog/N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758038395; c=relaxed/simple;
	bh=Dp7szgpaGfHlQ755zC+EanzJ5ixm7MT/BCbY2JQBh3Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tavVTWabJuzOFqCnU66L/6qiKHMXWhg6eT1FcR0dKFPyfBckO2nC3HOcrsyJ/rBy9vCVxiphTabhETUJW4mPpygxTgJ0rADM9m+BrDthSDyof9EutX3UQyOspVDXybGqA6oKBX/S1NILk2XftIrqcz8Hyib910sxjUQOmV9PPhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=igY1sd5h; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 9465D40ADA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1758038393; bh=EeMXhtxJprG2YTOXivHc4OPVuBvbCoeoJoyBQiRwvNU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=igY1sd5hSbQ/+MQuIl7oOjn/nadXg/GYQvdXKVFrXJOnMF++U96ZSlatwgksMz9cD
	 e0upqeTDNNv+geMOKQ/XhrUmL02BijqfV4GqIxyC66EFsk2uqEjuG+B/tr2jZ8IdqG
	 G/GGlXDjOeSQJxUoE33acY3K/HQBopPsdEDk2fe42PU7m33s4azmwyrnfva6IkQhwm
	 0FK7A7ssfC3dRJjSLqeMOKjFlKGdqmRRFhFIkQOUcrcsTb2vnlvzspBP8/PNPVl+Ke
	 IHfWrDqdz6RQ53f09m8L7RCTtQJb7+4XrUbwFc71G4pBB555FDjqv+JCJ2KNBVk7N7
	 4BbQLDiz+6uEQ==
Received: from localhost (unknown [IPv6:2601:280:4600:2da9::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 9465D40ADA;
	Tue, 16 Sep 2025 15:59:53 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Akiyoshi Kurita <weibu@redadmin.org>, kvm@vger.kernel.org,
 pbonzini@redhat.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Akiyoshi Kurita
 <weibu@redadmin.org>
Subject: Re: [PATCH] docs: wmi: lenovo-wmi-gamezone: fix typo in frequency
In-Reply-To: <20250913173845.951982-1-weibu@redadmin.org>
References: <20250913173845.951982-1-weibu@redadmin.org>
Date: Tue, 16 Sep 2025 09:59:52 -0600
Message-ID: <877bxyfkw7.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Akiyoshi Kurita <weibu@redadmin.org> writes:

> Fix a spelling mistake in lenovo-wmi-gamezone.rst
> ("freqency" -> "frequency").
>
> No functional change.
>
> Signed-off-by: Akiyoshi Kurita <weibu@redadmin.org>
> ---
>  Documentation/wmi/devices/lenovo-wmi-gamezone.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/wmi/devices/lenovo-wmi-gamezone.rst b/Documentation/wmi/devices/lenovo-wmi-gamezone.rst
> index 997263e51a7d..167548929ac2 100644
> --- a/Documentation/wmi/devices/lenovo-wmi-gamezone.rst
> +++ b/Documentation/wmi/devices/lenovo-wmi-gamezone.rst
> @@ -153,7 +153,7 @@ data using the `bmfdec <https://github.com/pali/bmfdec>`_ utility:
>      [WmiDataId(1), read, Description("P-State ID.")] uint32 PStateID;
>      [WmiDataId(2), read, Description("CLOCK ID.")] uint32 ClockID;
>      [WmiDataId(3), read, Description("Default value.")] uint32 defaultvalue;
> -    [WmiDataId(4), read, Description("OC Offset freqency.")] uint32 OCOffsetFreq;
> +    [WmiDataId(4), read, Description("OC Offset frequency")] uint32 OCOffsetFreq;
>      [WmiDataId(5), read, Description("OC Min offset value.")] uint32 OCMinOffset;

I don't have the device in question and can't test this ... but the text
in question has the appearance of being literal output from the bmfdec
utility.  Do we know that this is some sort of editing error rather than
an accurate reflection of what the tool prints?

Thanks,

jon

