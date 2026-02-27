Return-Path: <kvm+bounces-72119-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aziIC7buoGmBoAQAu9opvQ
	(envelope-from <kvm+bounces-72119-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 02:09:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B9B121B1638
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 02:09:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EA7B3300490E
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 01:09:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78B74279DC0;
	Fri, 27 Feb 2026 01:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="bF8H/HS7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD5F266576
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 01:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772154545; cv=none; b=Es0i5YictXhC7tZheyHS8tcQNQ3uSHn7KlgoYve9XlIX1ljE+GeGWLJL19Rg8dTsGnJBgEie8ZM2V2bKgZ3+WdisXWQ67UvnogdDO+i6dCw7T0m41V07RF+qn8HowyExuUZ3dQ/HWwJjdJah8qOD8hlOqUIW4/rA5xEuioHkydc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772154545; c=relaxed/simple;
	bh=Vsm+/jCgY2aB74QyLRYBdy8B+Rgt8iW3O8facH4/8UY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WOKwo0p7BN+wB8YDxkAgM78liJ0MaEeyzIJ/rdd53h642eoSlHKCpwI14d/a07TiEXb2qL4tL2f7odZkDSHlbNhg0l5WH/O19y1QlRtSfaxgmT1AQ9MEUe3wiC3F1gCVNfWWHUfaZEr7//cz7Q6EIWQdQZcDHT+BNEVgJ81OdaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=bF8H/HS7; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-506a297c14bso14705071cf.2
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 17:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1772154543; x=1772759343; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fIbZ6hyyMHAKB2BJD8/8kNRLCv959jzKvxcpPvl74ls=;
        b=bF8H/HS7dNMuW01IbwOS0eD6goFSo2jnRSC64cG8Xc6vd97ImQrnl3OhPPnNqRyJzN
         bjOniRYfzXjnNQUn9heim27wZDc8dNr39V766Ag7UxV6MlrurMUJDpQttvln8F+aZaW5
         iEB0JYmXkzrEq+4ZXa264WqfBDeMJI3OCOda+Cyu7jF2a3esxdrq+OZ+PdbOdkTagF3w
         4Xz9V91GdcincBFcEZE2aoq9GgM1r/pj85Pzy7FM8/zQmneiWucyNlciAmC+9Jp96AVy
         3hF6R727E7kaWXzl1iJGJhivDLscC0ZrXqz1Rti+42nh/gFNNcZ23x2/CzgXtHiIeDYY
         ZRVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772154543; x=1772759343;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fIbZ6hyyMHAKB2BJD8/8kNRLCv959jzKvxcpPvl74ls=;
        b=eLccSbg17eO29L8CKkWktBYxddrUSofnJ2vmdRRv8MPNh28CKsrji220IW1NNXiVbi
         yMVQ2i7psMyFBK0GzCthQQ7MJqXZUw1B8siFkdGztfBimHcBT6hWP3oklX+P5rCrUdAk
         8QF3NUAO60slpvCWZ/9H7kjuXcNIzO+W7rnGcJHYQGSO+Dtj52pI5UwyWA5ZdwOETsVU
         lTX8qG2GjRweHOnB0lCR5adytGgVjF87HcMpLXSfFZafZDH7fotN64jTKh+mv4lTHRV/
         cL3Wdhge+jJcuTcmqNt5Uwar4zEnHNwn/6I8ZT64L14qS2se2DKsH1RN0UmksX53t2oi
         z3tg==
X-Forwarded-Encrypted: i=1; AJvYcCUPxicS9lssQmXH912k/p/CqXManOHltI/cU+d8NLCmRZ10AuR+BVbksRyWCxkDfWAbx2E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmXmM3+Pn8OgOVP0BONS8TZDKuPJXKQ6hKQtcQV7K5mg4vqllE
	FkgtOH34vsuDxOzNq5jCtddNoDPFOstDI0FAqmxbOE7V9661fPQSmi3L/dWprBMO6Gw=
X-Gm-Gg: ATEYQzxiKO4aLNdMMFfdrg6prAT/CxvNCUHHEpn7PzxZz1mZ4jOqHIUFeb6PnkFaIBC
	aGc/dES2A6HnEAuO6Bo8K8RligBUekPMmvmP3Z9CntDXc+oLALM8jiVSg/Xdp201E9qKvnwqyqX
	TCU54z/WMg9HXZP/0jm4VnY1yYwC8PT1Zt1RaW9KKME4QDKGp0EgJWO3N0W7H9AAWcQhZnWFgun
	8VBQNhPfOzWb0GaDBbMDhqEaAQQ/ly/44+JqGE5v1B9sVoSSBF8Fp/O0JaFloCQ3JXlZKshQ/ti
	pdVsY68/o0LnE9GTgB35uW74Hrbm81liqITpm01E/86LtTfS+Rgqmd/ozasT/TFEWGDBzJTwlJO
	g/0k7hFZ6WyRmS808zO4ybJBmLGbmUz09OaBSGEalzCKd7QOx9vLdLpXE+O/JHykYQqttrko1lX
	lDNefAnyeiHf1zCrh1ctDtljxNN37mmmMdwVYziEVaSkD6A2ZaXWm9aAvhWv+kg0kYSgVr4fpiW
	yk2CR/Qxf3Rx4nKEH4=
X-Received: by 2002:a05:622a:1907:b0:506:bde3:1dea with SMTP id d75a77b69052e-5075299954emr12486431cf.36.1772154543378;
        Thu, 26 Feb 2026 17:09:03 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c716ccf5sm39101476d6.17.2026.02.26.17.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 17:09:02 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vvmLm-00000000sEc-0kRO;
	Thu, 26 Feb 2026 21:09:02 -0400
Date: Thu, 26 Feb 2026 21:09:02 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Sean Christopherson <seanjc@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>,
	Alexey Kardashevskiy <aik@amd.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Steve Sistare <steven.sistare@oracle.com>,
	Nicolin Chen <nicolinc@nvidia.com>, iommu@lists.linux.dev,
	linux-coco@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>,
	Santosh Shukla <santosh.shukla@amd.com>,
	"Pratik R . Sampat" <prsampat@amd.com>,
	Fuad Tabba <tabba@google.com>, Xu Yilun <yilun.xu@linux.intel.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	michael.roth@amd.com, vannapurve@google.com
Subject: Re: [RFC PATCH kernel] iommufd: Allow mapping from KVM's guest_memfd
Message-ID: <20260227010902.GE44359@ziepe.ca>
References: <20260225075211.3353194-1-aik@amd.com>
 <aZ7-tTpobKiCFT5L@google.com>
 <CAEvNRgEiod74cRoVQVC5LUbWDZf6Wwz1ssjQN0fveN=RBAjsTw@mail.gmail.com>
 <20260226190757.GA44359@ziepe.ca>
 <aaDL8tYrVCWlQg79@google.com>
 <20260227002105.GC44359@ziepe.ca>
 <aaDlRdnhIqRXEbPZ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaDlRdnhIqRXEbPZ@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[ziepe.ca:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72119-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[ziepe.ca:+];
	DMARC_NA(0.00)[ziepe.ca];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@ziepe.ca,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,ziepe.ca:mid,ziepe.ca:dkim]
X-Rspamd-Queue-Id: B9B121B1638
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 04:28:53PM -0800, Sean Christopherson wrote:
> > I'm confused though - I thought in-place conversion ment that
> > private<->shared re-used the existing memory allocation? Why does it
> > "remove" memory?
> > 
> > Or perhaps more broadly, where is the shared memory kept/accessed in
> > these guest memfd systems?
> 
> Oh, the physical memory doesn't change, but the IOMMU might care that memory is
> being converted from private<=>shared.  AMD IOMMU probably doesn't?  But unless
> Intel IOMMU reuses S-EPT from the VM itself, the IOMMU page tables will need to
> be updated.

Okay, so then it is probably OK for AMD and ARM to just let
shared/private happen and whatever userspace does or doesn't do is not
important. The IOPTE will point at guaranteed allocated memory and any
faults caused by imporerly putting private in a shared slot will be
contained.

I have no idea what happens to Intel if the shared IOMMU points to a
private page? The machine catches fire and daemons spawn from a
fissure?

Or maybe we are lucky and it generates a nice contained fault like the
other two so we don't need to build something elaborate and special to
make up for horrible hardware? Pretty please?

Jason

