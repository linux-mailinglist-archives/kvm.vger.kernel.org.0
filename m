Return-Path: <kvm+bounces-72750-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qIfOKVSzqGlgwgAAu9opvQ
	(envelope-from <kvm+bounces-72750-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 23:33:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1175A208A6F
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 23:33:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F2E2330B39CA
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 22:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC6083988F6;
	Wed,  4 Mar 2026 22:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vD2i5SMu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E532239E6F
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 22:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772663463; cv=none; b=KoUmBGDiQ+wy6hEDdDw2uc+QNdcbXZ25Ihfit8Rid9/b5kVvmat8vY2Ra1KQzRePdKvw9gliQBBRy60tcH5lY3p+FpCqYrwPOM5efEcaWQxYQ8TIfkqzGpCruLKUmB34FBIwvaHUSkIt30xj8Nv8iy8o96ynnrSQSx2g6htgOrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772663463; c=relaxed/simple;
	bh=3b0QgQI2KwZHXszgh9/7axf/lYL7GsCs8HcBmenTR2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BN6vpWtzqTsaxcDn6F4olgv6SNs2xJxGoSEaG0mpOg9qODTEu44Ya+pOrdlTW1AcQC23GfiCpKfYCK1hRgXsQzeUXBEOUqJHNeMIEuB4+dhKrHZHzZXQZa0Znc1uRJRyuZAZTJxdx24/YbvI+Hjz7xCUcjzQ6ErypPm1SCkTsYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vD2i5SMu; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ae3a2f6007so33838335ad.2
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 14:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772663461; x=1773268261; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V3fTU8QManykyH146Geu+QI8WoaA0wZ9bvU2xLy47ZE=;
        b=vD2i5SMurNFacnyzJMrYluFl7ycNVV6Eo9At/6AlHbmgLGPU4tYAMO97Gw/nDUu4vK
         qUVNnCjghISReLonASix0SJG8NZ3ppTTxyMPs2JdZZqjmkvjNhFYSAPP61SwgRS9BO5J
         bdUIHPP5Jfwcz8J/Oqbxdqyu05KBU8Ss6uVLfUEVQ0DAotIUB2gIP0n3ugqCnWRvZxH4
         uMI99FXZgX3pbJyOOu8QF4MnR8FfJ2jRSk2N29Omd+Y4XWqbW0gd7eQFxsX5bllGJvHh
         rqnGj+iAKSSz2PQCB6dC5fS8WPbUMPhcRpeTcWKz20/YzpVBWZqsw1x5ebr7g2gJXZ4B
         uLHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772663461; x=1773268261;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V3fTU8QManykyH146Geu+QI8WoaA0wZ9bvU2xLy47ZE=;
        b=AhAhAnE7ifv1pDJc1ruVrSHrq15V55bwVeHrJgtuc/iYFpal83MhUqggPt0wAJCrGN
         1wyCLk9K9/+mUoeO9LPJIG4Y8XYlLekjjEJoj0PG1QBasZcoKLmwZpM3nZ2p3iwTGbu2
         YX0/dmZhNzEMmtqMn7vxb+2QzI8GziZWq74FQ2bE+mu1zEyua4Ykl70QJrDd14fph1fI
         CMADCxnHz5u3/HFvSj4hunLJffs5lTTd3iJgQwAlVjsuyIjFW+3Ca9MkkWUoKG9rhiKz
         35ilcjlfkX7hgfC/qXsQi9jgv4EcDmRIoxWahLVnG0b8TbgYmOHXDe25MiUv+jrkn6z1
         hWqA==
X-Forwarded-Encrypted: i=1; AJvYcCWUq2l4McQelWoWCSerPawLTAy3ZiFZFChmZgYzLXMsE/S8VlT8std7WZ0tcBtpBfHqLSQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxhWF+/FLizVLzCta7hYcCb2MDsMrtbOV2FZCF4gPU8Rmw6mil
	37BICSNm9S3U0jQXWFgTJUjqATw+jt3agUoffj/thKtk2PmN6iYVQDaVIRkd7+a9vw==
X-Gm-Gg: ATEYQzyrMUDTdrmtvqdz0CB8hVelDLL7+ap0A8Jl4wKcVSBoNQloeACb8/3YUOA79Ic
	x2ZWs6B6ZOjMikckmyIQgCJ/8tZ8TpqVzbbNbhIKoHi/6r/PEJSYsZC16sxedowzx91JAvrxhSp
	b2Fu82SoVnYLRqNYLshsPHO5u8WfRiVrqAqu+5/hzJG6wUoE07qeURKfHeLGuAZwlsiPOlPZrPP
	iv8mRDZB5inpD4TNCq9TgI7HXwiOxKF34sWADXYWedu88cuZ2/LOL8eTcLbktDNXsEF70gCm6Rq
	1eY6dhCra4vv7AlyxunfFr0pnyp+baIxm91to2GNbsxojCVZVTfmCwYUaiVs7vq4p9afcg7UufX
	BqZM1CFwoa85J5fTZf/Nv3gSthhRpGbkIDbFL4dzEwcsSAPxYLdKNTbFyjIkMW0ploiSSFdp1Ps
	jMGfwBYPnaCC8xG9f31PUQWfFta8TwnXYg+DSv1oxNZYE9K0XFByfawz5Q5Re6lw==
X-Received: by 2002:a17:902:e790:b0:2ae:6457:309a with SMTP id d9443c01a7336-2ae6aaf3d37mr32457385ad.37.1772663460415;
        Wed, 04 Mar 2026 14:31:00 -0800 (PST)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae4cd40e4dsm108183855ad.92.2026.03.04.14.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 14:30:59 -0800 (PST)
Date: Wed, 4 Mar 2026 22:30:55 +0000
From: David Matlack <dmatlack@google.com>
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: selftests: fix crash in vfio_dma_mapping_mmio_test
Message-ID: <aaiyn8ZtRwOiQvfB@google.com>
References: <20260303-fix-mmio-test-v1-1-78b4a9e46a4e@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303-fix-mmio-test-v1-1-78b4a9e46a4e@fb.com>
X-Rspamd-Queue-Id: 1175A208A6F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72750-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[fb.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 2026-03-03 11:46 AM, Alex Mastro wrote:
> Remove the __iommu_unmap() call on a region that was never mapped.
> When __iommu_map() fails (expected for MMIO vaddrs in non-VFIO
> modes), the region is not added to the dma_regions list, leaving its
> list_head zero-initialized. If the unmap ioctl returns success,
> __iommu_unmap() calls list_del_init() on this zeroed node and crashes.
> 
> This fixes the iommufd_compat_type1 and iommufd_compat_type1v2
> test variants.
> 
> Fixes: 080723f4d4c3 ("vfio: selftests: Add vfio_dma_mapping_mmio_test")
> Signed-off-by: Alex Mastro <amastro@fb.com>
> ---
> The bug was missed because the test was originally run against a kernel
> without commit afb47765f923 ("iommufd: Make vfio_compat's unmap succeed
> if the range is already empty"). Without that fix, the unmap ioctl
> returned -ENOENT, taking the early return before list_del_init().

Thanks for the fix.

Looking back I remember testing your new test out without seeing a
failure. Turns out I had applied it on top of tag vfio-v6.19-rc1, which
did not have commit afb47765f923.

Reviewed-by: David Matlack <dmatlack@google.com>

