Return-Path: <kvm+bounces-40906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4AB2A5EEB0
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 09:59:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28A7B3AE8B6
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 08:59:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1CBB262D27;
	Thu, 13 Mar 2025 08:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="al3OzBa3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7871BDCF
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 08:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741856360; cv=none; b=P6jTuD/MenxuBvY7ObPzx4n81s7au+lNBjwLMfXlG1oPIYAoX360QcZyQk2+EOdy9s4BQ2Zw9ch6Qvptg6o2M41NlZyc5i1gLb1fPvKUU/hqNNmlhzF1pUfB732eSzB9uEegwnrCpB1SZImgRK62LzejxQvKlZwdb9YjpsiZQUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741856360; c=relaxed/simple;
	bh=Uih/8Aelm7B5LTifK01VFfHuDsEigWvuf20c48D0JY8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Z/u8dqIAWjaSg3U4baz1dRNbah7qiOAEn1MusS7I2fj/F+MPA2fcDKh0DYtJ3M0p6ENPtyRlx4PqTJhkcLhi8Hm1VCuKmNNaMaR2mA/EoYIs/gu4NYDUiRbE255Wgn5pZ8kxz//cocxLn/sYEglhX+zx7DopKVteO2gNTuFrGbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=al3OzBa3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A845CC4CEDD;
	Thu, 13 Mar 2025 08:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741856359;
	bh=Uih/8Aelm7B5LTifK01VFfHuDsEigWvuf20c48D0JY8=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=al3OzBa3ps12oOsGrrshnH5rr6EKHubYU4Fv6nWd5A/4fSBV1UZK94qZalW+SPdTB
	 LRrMzTJfta+lUknPZgCWB7QAo4Kfdn0/PJn86Kk30FuMmh1DUU+F4ppcvxYB7EtW3+
	 EQ9G3xzgew6iX3h/vzPF3aSyRNj9/92u6sI77opcEfWpkuZLVhjXUh1JadFVh1ZXcy
	 LdXOtQXBL9FSLggEZfD2XOWlkrqPng3BaF6aGwHa4eanSrS40JhzyEguTWSZjjn/do
	 H5Pc2eiYy9Yp2W3zz5JemCJeUcdVfDzdH5kaK7OaNLXl69LzGPL+HjmKZ4+G4AoxEH
	 w6McRk3TS4TkQ==
Message-ID: <d59ea1dd-f1f1-4ca7-b666-358354633d9e@kernel.org>
Date: Thu, 13 Mar 2025 17:59:16 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 01/11] nvmet: Remove duplicate uuid_copy
To: Mike Christie <michael.christie@oracle.com>, chaitanyak@nvidia.com,
 kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, joao.m.martins@oracle.com,
 linux-nvme@lists.infradead.org, kvm@vger.kernel.org, kwankhede@nvidia.com,
 alex.williamson@redhat.com, mlevitsk@redhat.com
References: <20250313052222.178524-1-michael.christie@oracle.com>
 <20250313052222.178524-2-michael.christie@oracle.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250313052222.178524-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/13/25 14:18, Mike Christie wrote:
> We do uuid_copy twice in nvmet_alloc_ctrl so this patch deletes one
> of the calls.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/nvme/target/core.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
> index 2e741696f371..f896d1fd3326 100644
> --- a/drivers/nvme/target/core.c
> +++ b/drivers/nvme/target/core.c
> @@ -1618,8 +1618,6 @@ struct nvmet_ctrl *nvmet_alloc_ctrl(struct nvmet_alloc_ctrl_args *args)
>  	}
>  	ctrl->cntlid = ret;
>  
> -	uuid_copy(&ctrl->hostid, args->hostid);

Good catch. But it is the other call that should be removed as that will also
remove the if (args->hostid) as that is not needed (the 2 call sites of
nvmet_alloc_ctrl() both set a hostid).

And maybe sned this patch as a real patch as I think it can go upstream now.

> -
>  	/*
>  	 * Discovery controllers may use some arbitrary high value
>  	 * in order to cleanup stale discovery sessions


-- 
Damien Le Moal
Western Digital Research

