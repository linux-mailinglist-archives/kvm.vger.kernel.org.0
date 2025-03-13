Return-Path: <kvm+bounces-40911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D55DA5EF54
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 10:16:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F30061893041
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 09:16:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DFC9262D27;
	Thu, 13 Mar 2025 09:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WBkj0tke"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2231EA7F4
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741857373; cv=none; b=cVSz05En1QmvtWNOlX3X8PQtDSbjnBsBX0DqkNnFRrq2wnfbaM/8bb3LBiB2DFG3riwQa+h1Nf6pUsxIxSO4C22ViVQV+rBA6phrW1borkr9cLF/OYZveJRAkKsLQhoetjlkI8euchsPtu24M2yw2gZCXUa4kTnirRJhRHNY8jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741857373; c=relaxed/simple;
	bh=EveOz9BzqCWNDFQacYFRdY44+wrFRTKnPnOmJi+jXac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JV3Y/sNMTA9qsGCPqaQufFCH57TELpBxT2cG6i6s3dOTktZvs81dMNm3wMi2Q0utP+xmfsCj3WdKjcEzSUNwy14bFkfJkvVLecunO2M9P5dpJ3OuyMYIxWqGA/6nmV2V8HiNIV+5fmCMzWpneJpcIRgFT6KZO2YDVowEiOHN/SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WBkj0tke; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E445C4CEDD;
	Thu, 13 Mar 2025 09:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741857372;
	bh=EveOz9BzqCWNDFQacYFRdY44+wrFRTKnPnOmJi+jXac=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WBkj0tkeeGRkOdQ92Bi4Fop54UxAH+yBeq7GFhdwsF7bDLgR434u8sYEt6fya67Lq
	 3M/FVO+peqFfKl+13tYh1n7nTUGgf1i8cOBKXlylSjBaVaJtYLRpiY5F0jBs0tenm1
	 wIbiI955QyNd8yADAC7Q5H9AQIbM/ddjNuiXMeLkHaF06cuVE8L7k9vampKRfTRaCh
	 MBCXZ8KC3rndUnI62+0IrA+4x5IY7fRFHrg4fzliQb9qJN0K3vf07mX885A0MRI9Zj
	 iUr2cArFS0Dy8HmVjJp+szltNqxCv4EXbuzSe5iQ9vjp40tQOv1abuhiATXOsLgbuH
	 U7a2i1yuTJ2Qw==
Message-ID: <574a8296-1bc5-403f-89fb-fd4cedb57c0f@kernel.org>
Date: Thu, 13 Mar 2025 18:16:09 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 03/11] nvmet: Add nvmet_fabrics_ops flag to indicate
 SGLs not supported
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michael.christie@oracle.com>, chaitanyak@nvidia.com,
 kbusch@kernel.org, sagi@grimberg.me, joao.m.martins@oracle.com,
 linux-nvme@lists.infradead.org, kvm@vger.kernel.org, kwankhede@nvidia.com,
 alex.williamson@redhat.com, mlevitsk@redhat.com
References: <20250313052222.178524-1-michael.christie@oracle.com>
 <20250313052222.178524-4-michael.christie@oracle.com>
 <970e0d79-f338-4803-92c4-255156a8257e@kernel.org>
 <20250313091349.GA18939@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250313091349.GA18939@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/13/25 18:13, Christoph Hellwig wrote:
> On Thu, Mar 13, 2025 at 06:02:29PM +0900, Damien Le Moal wrote:
>> On 3/13/25 14:18, Mike Christie wrote:
>>> The nvmet_mdev_pci driver does not initially support SGLs. In some
>>> prelim testing I don't think there will be a perf gain (the virt related
>>> interface may be the major bottleneck so I may not notice) so I wasn't
>>> sure if they will be required/needed. This adds a nvmet_fabrics_ops flag
>>> so we can tell nvmet core to tell the host we do not supports SGLS.
>>
>> That is a major spec violation as NVMe fabrics mandates SGL support.
> 
> But this is a PCIe controller implementation, not fabrics.

Ah ! yes !

> Fabrics does not support PRPs and has very different SGLs from the
> PCIe ones.  The fact that the spec conflates those in very confusing
> ways is one of the big mistakes in the spec.

Yes, and despite tripping on this several times with pci-epf, I did it again :)

pci-epf has code for handling both PCI PRPs and SGL. We probably can make that
common with mdev to facilitate SGL support.


-- 
Damien Le Moal
Western Digital Research

