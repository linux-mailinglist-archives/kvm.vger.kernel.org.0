Return-Path: <kvm+bounces-73295-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2J8LGE3OrmnEIwIAu9opvQ
	(envelope-from <kvm+bounces-73295-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 14:42:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 001EC239E86
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 14:42:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6121F305DA79
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 13:41:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED9F23C1977;
	Mon,  9 Mar 2026 13:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SS3qFN7Q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C4B38553A;
	Mon,  9 Mar 2026 13:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773063716; cv=none; b=j3nwv8yP8zbQ09HLVGHbLzuNrkY8SXVU7Fdmg+0U89fe1fSPrC5p5tg2FcKwl181Sxf7tkd0Ro1LC2DhW9GyuHKdAkG3HslPBRxfjLOzX/8f3bghG/Okh9050jfQDj3Ee94if5JWLg9tJVmgThV2eAfa/HLk8UTPOOBJktQvlRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773063716; c=relaxed/simple;
	bh=UoUbL95Q4+tSbCtlerVmISNzgIu9HYD6KL01bp1lHXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fAzQ+1QE5N5YB7wuwj78BJyUVN19UMg4keje3iwaJfog4141CyNBuk6GDXM3G++kSZxigw9zlamU23Jx9Ox0WAzNxU9NeIg2aXGD49muGc5QtPFxYKPL9gNHgh3DDqBZsV0o+oC8NLVuTWiRzFCZHJy2iLO2rg5Fc7B3+GzBBR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SS3qFN7Q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A309C4CEF7;
	Mon,  9 Mar 2026 13:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773063715;
	bh=UoUbL95Q4+tSbCtlerVmISNzgIu9HYD6KL01bp1lHXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SS3qFN7Q0Vb6c7hMStjg2G4fQsxATczuRLFp2+E9luZ8z3HUWiFITLQ/PcT9t3nti
	 vrdM9DoYVbqdenkvgAePk4EimHqj8r0simCmFNk8jX202vhWStXUCx/YleD75oJ4lr
	 rCAS0QYc1ocxeaClYLtp2UyBbon6K5QUlwm3AauPOBCiXALALNcMlyi2d1Nf/b7Kfw
	 X/asaAXJSjtc6q9voMpnwngtqxaS/vOZCCbx7h2NqqiqsEwfA8Pn8UVjonEK6OwA7C
	 2G5z0gNjgvypfYcWHuJOfjaWpRsuWl5WLN+9OVlxB6yZ2469XVPHZIYL97BIOqzI1C
	 Fb2vKUPO8JBxg==
Date: Mon, 9 Mar 2026 13:41:51 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1 1/4] mm: move vma_kernel_pagesize() from hugetlb to
 mm.h
Message-ID: <d8cdf99b-3139-49b5-bc4f-dda139856021@lucifer.local>
References: <20260306101600.57355-1-david@kernel.org>
 <20260306101600.57355-2-david@kernel.org>
 <833950ef-e01d-4914-b5f9-bc1f6261b184@lucifer.local>
 <729e14d4-6949-4d46-9380-12331b5ad363@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <729e14d4-6949-4d46-9380-12331b5ad363@kernel.org>
X-Rspamd-Queue-Id: 001EC239E86
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73295-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ljs@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.933];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lucifer.local:mid,intel.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026 at 02:25:51PM +0100, David Hildenbrand (Arm) wrote:
> On 3/6/26 12:07, Lorenzo Stoakes (Oracle) wrote:
> > On Fri, Mar 06, 2026 at 11:15:57AM +0100, David Hildenbrand (Arm) wrote:
> >> In the past, only hugetlb had special "vma_kernel_pagesize()"
> >> requirements, so it provided its own implementation.
> >>
> >> In commit 05ea88608d4e ("mm, hugetlbfs: introduce ->pagesize() to
> >> vm_operations_struct") we generalized that approach by providing a
> >> vm_ops->pagesize() callback to be used by device-dax.
> >>
> >> Once device-dax started using that callback in commit c1d53b92b95c
> >> ("device-dax: implement ->pagesize() for smaps to report MMUPageSize")
> >> it was missed that CONFIG_DEV_DAX does not depend on hugetlb support.
> >>
> >> So building a kernel with CONFIG_DEV_DAX but without CONFIG_HUGETLBFS
> >> would not pick up that value.
> >>
> >> Fix it by moving vma_kernel_pagesize() to mm.h, providing only a single
> >> implementation. While at it, improve the kerneldoc a bit.
> >>
> >> Ideally, we'd move vma_mmu_pagesize() as well to the header. However,
> >> its __weak symbol might be overwritten by a PPC variant in hugetlb code.
> >> So let's leave it in there for now, as it really only matters for some
> >> hugetlb oddities.
> >>
> >> This was found by code inspection.
> >>
> >> Fixes: c1d53b92b95c ("device-dax: implement ->pagesize() for smaps to report MMUPageSize")
> >> Cc: Dan Williams <dan.j.williams@intel.com>
> >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> >
> > LGTM, but you need to fix up VMA tests, I attach a patch below to do this. Will
> > this resolved:
>
> Thanks!
>
> I assume that should go into patch #2 instead?
>
> >
> > Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
>
> [...]
>
> > ---
> >  tools/testing/vma/include/dup.h | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
> > index 3078ff1487d3..65b1030a7fdf 100644
> > --- a/tools/testing/vma/include/dup.h
> > +++ b/tools/testing/vma/include/dup.h
> > @@ -1318,3 +1318,10 @@ static inline void vma_set_file(struct vm_area_struct *vma, struct file *file)
> >  	swap(vma->vm_file, file);
> >  	fput(file);
> >  }
> > +
> > +static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
> > +{
> > +	if (unlikely(vma->vm_ops && vma->vm_ops->pagesize))
> > +		return vma->vm_ops->pagesize(vma);
> > +	return PAGE_SIZE;
>
> Should we just KIS and use PAGE_SIZE for the test?

Yeah that's fine, but then should go in tools/testing/vma/include/custom.h :>)

I tidied things up there to make it easier to understand WTH is going on with
the headers used by VMA tests.

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

