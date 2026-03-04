Return-Path: <kvm+bounces-72632-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eGdBESaBp2liiAAAu9opvQ
	(envelope-from <kvm+bounces-72632-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:47:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 076381F8FCF
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:47:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 269C7302C75D
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 00:47:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4E481448E0;
	Wed,  4 Mar 2026 00:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="iokcO/JE"
X-Original-To: kvm@vger.kernel.org
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35EB322A;
	Wed,  4 Mar 2026 00:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772585249; cv=none; b=NVt0YOUHSbJFbDXBumFR2Uq86LaWSkmXOlkO7lSk6L16RPz+XArh8A+Bz7XvT7TLsbMoUHLwqRWePk4H62V+QbhJAqhJ+Q0G4j+Q43xVz/nIV8c0xVj3vOxiCpqxnahDnoGescPbcrGZ6kyK2lwdkD9LbYOh6PPA2FngTyyuyy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772585249; c=relaxed/simple;
	bh=+L7SUxV5+ZgZqW2wk1K5g+AlZf4y17v2y0NfpGKOCFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k4erPdQ7PhKI3rT2CXM2mgBb8ialVdirNDI2BwRPGJzbqLk43wfQJyBOMKyHt3PkrsE1X3ks5s/XSigQGhDbJ2w1gYFAs9lQEAMyU0DpQxZZHpnHcYyEFdpu3Lqnf24R8ddLZtFdXnvAywHt34aq4AYpgK6azDadLQBtnknnWzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=iokcO/JE; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772585236; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=b5u3CcUv0pgAolzm4rEmwpoEocfcJX1iiE9qFfZsikE=;
	b=iokcO/JEn+R2MBMTfwecYJLFP25EVGeija/tAoAeTHqQhwFHutZRS06kbJSV1kxhzLiISDqW1SZEcrNLwaDJNUYOlKHYgQdsE9+MK1Oi++vD21dI+lGs9PDULU8PWIhSudCJVV9sUdqjXQij8XIgzsExza/9D64jbW4kvIyi9DM=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X-B3A1p_1772585235 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 04 Mar 2026 08:47:16 +0800
Date: Wed, 4 Mar 2026 08:47:15 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex@shazbot.org>, 
	David Matlack <dmatlack@google.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: selftests: fix crash in vfio_dma_mapping_mmio_test
Message-ID: <vps7in2ph6yyb2vl3zuxie7sp2cyzh4endrvdsdjgtqhjxvoqp@po4m7zddafi5>
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
X-Rspamd-Queue-Id: 076381F8FCF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-8.66 / 15.00];
	WHITELIST_DMARC(-7.00)[alibaba.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.alibaba.com,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72632-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yaoyuan@linux.alibaba.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.alibaba.com:dkim,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,fb.com:email,alibaba.com:email]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 11:46:24AM +0800, Alex Mastro wrote:
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
> ---
>  tools/testing/selftests/vfio/vfio_dma_mapping_mmio_test.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_mmio_test.c b/tools/testing/selftests/vfio/vfio_dma_mapping_mmio_test.c
> index 957a89ce7b3a..d7f25ef77671 100644
> --- a/tools/testing/selftests/vfio/vfio_dma_mapping_mmio_test.c
> +++ b/tools/testing/selftests/vfio/vfio_dma_mapping_mmio_test.c
> @@ -100,7 +100,6 @@ static void do_mmio_map_test(struct iommu *iommu,
>  		iommu_unmap(iommu, &region);
>  	} else {

Hi Alex,

>  		VFIO_ASSERT_NE(__iommu_map(iommu, &region), 0);
> -		VFIO_ASSERT_NE(__iommu_unmap(iommu, &region, NULL), 0);

This is the more simply way to work w/ or w/o commit
afb47765f923 ("iommufd: Make vfio_compat's unmap succeed if
the range is already empty"), may worth to add this point
into the commit message.

For the changes:

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>  	}
>  }
>
>
> ---
> base-commit: 96ca4caf9066f5ebd35b561a521af588a8eb0215
> change-id: 20260303-fix-mmio-test-d3bd688105f3
>
> Best regards,
> --
> Alex Mastro <amastro@fb.com>
>

