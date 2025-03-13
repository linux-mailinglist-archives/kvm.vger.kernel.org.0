Return-Path: <kvm+bounces-40907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BE68A5EEDD
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 10:03:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A41A719C0F0E
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 09:03:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D74E2641DE;
	Thu, 13 Mar 2025 09:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P7Tl4hWT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3932638A0
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741856552; cv=none; b=SsBPt0Je8h/aATzQTxFyts1rWLyRYkP1xq3Nsg//LL1m2EGq5KrEYr6xr+29wEbH+8IvpLk+sYErt7txqPjkD0aLquNE8umhCTHuQkobPoOIKfnIRWDQwhj40FwLMm+inNEL7exsBR6TI/EsYsCh0CT+FYJK61Q6fuja74DoUi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741856552; c=relaxed/simple;
	bh=ngIjLNejv6KmigNprK/9mbpgD6OCwOaupkoclqpOGEk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SkIFrmAep6Np7H+id2rDUiq0RrQtWfA7yaFFeH+YRH48Wdt9eRQvwSgx5tkLHNo6rZxkQo73KehjNzeq9n+VXepRldzbh2GMLFadVsL4rJzhJaGxUxL/rNrnmBjk3GysU740/ZmtI8Kq08EZ8oe0kiSqYr7Jap/PFSfAasJWfFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P7Tl4hWT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DA9C4CEDD;
	Thu, 13 Mar 2025 09:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741856552;
	bh=ngIjLNejv6KmigNprK/9mbpgD6OCwOaupkoclqpOGEk=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=P7Tl4hWTdQTxFQfJ8kWyhhDcYVNz6HnIO7VijTGn2IsTV/A2HICy0VH7dhB++9ARv
	 irBJ7Xa49EozuiTA3uR2B5vL6xrOvGfQHGoWaXunTQIV2TZMhij7FcEamPSz4fIw+P
	 nCONXOlgb+OOTvmJYRA9uEpsuOKZTKj2JWw8Ef+fN0Cywag2aAEGljnB1nwjEjcRak
	 wa+L/tT+EU8TmScoskdCd2XSBTuG/SGDh7Bc3euP1JMEgo10QJZVYnV55WmGSsgzhK
	 VVQBLWyvdfyLpSEaZHTQuZFsOCNvsfbTC9HZIqDS2V/Q8fxTGaLa91tPBoD61Z+HFR
	 PR4eAGGuQ5MnQ==
Message-ID: <970e0d79-f338-4803-92c4-255156a8257e@kernel.org>
Date: Thu, 13 Mar 2025 18:02:29 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 03/11] nvmet: Add nvmet_fabrics_ops flag to indicate
 SGLs not supported
To: Mike Christie <michael.christie@oracle.com>, chaitanyak@nvidia.com,
 kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, joao.m.martins@oracle.com,
 linux-nvme@lists.infradead.org, kvm@vger.kernel.org, kwankhede@nvidia.com,
 alex.williamson@redhat.com, mlevitsk@redhat.com
References: <20250313052222.178524-1-michael.christie@oracle.com>
 <20250313052222.178524-4-michael.christie@oracle.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250313052222.178524-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/13/25 14:18, Mike Christie wrote:
> The nvmet_mdev_pci driver does not initially support SGLs. In some
> prelim testing I don't think there will be a perf gain (the virt related
> interface may be the major bottleneck so I may not notice) so I wasn't
> sure if they will be required/needed. This adds a nvmet_fabrics_ops flag
> so we can tell nvmet core to tell the host we do not supports SGLS.

That is a major spec violation as NVMe fabrics mandates SGL support.
So at the very least, this needs a big fat warning comment explaining what this
is about.

> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/nvme/target/admin-cmd.c | 13 +++++++------
>  drivers/nvme/target/nvmet.h     |  1 +
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
> index acc138bbf8f2..486ed6f7b717 100644
> --- a/drivers/nvme/target/admin-cmd.c
> +++ b/drivers/nvme/target/admin-cmd.c
> @@ -755,12 +755,13 @@ static void nvmet_execute_identify_ctrl(struct nvmet_req *req)
>  	id->awun = 0;
>  	id->awupf = 0;
>  
> -	/* we always support SGLs */
> -	id->sgls = cpu_to_le32(NVME_CTRL_SGLS_BYTE_ALIGNED);
> -	if (ctrl->ops->flags & NVMF_KEYED_SGLS)
> -		id->sgls |= cpu_to_le32(NVME_CTRL_SGLS_KSDBDS);
> -	if (req->port->inline_data_size)
> -		id->sgls |= cpu_to_le32(NVME_CTRL_SGLS_SAOS);
> +	if (!(ctrl->ops->flags & NVMF_SGLS_NOT_SUPP)) {
> +		id->sgls = cpu_to_le32(NVME_CTRL_SGLS_BYTE_ALIGNED);
> +		if (ctrl->ops->flags & NVMF_KEYED_SGLS)
> +			id->sgls |= cpu_to_le32(NVME_CTRL_SGLS_KSDBDS);
> +		if (req->port->inline_data_size)
> +			id->sgls |= cpu_to_le32(NVME_CTRL_SGLS_SAOS);
> +	}
>  
>  	strscpy(id->subnqn, ctrl->subsys->subsysnqn, sizeof(id->subnqn));
>  
> diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
> index fcf4f460dc9a..ec3d10eb316a 100644
> --- a/drivers/nvme/target/nvmet.h
> +++ b/drivers/nvme/target/nvmet.h
> @@ -403,6 +403,7 @@ struct nvmet_fabrics_ops {
>  	unsigned int flags;
>  #define NVMF_KEYED_SGLS			(1 << 0)
>  #define NVMF_METADATA_SUPPORTED		(1 << 1)
> +#define NVMF_SGLS_NOT_SUPP		(1 << 2)
>  	void (*queue_response)(struct nvmet_req *req);
>  	int (*add_port)(struct nvmet_port *port);
>  	void (*remove_port)(struct nvmet_port *port);


-- 
Damien Le Moal
Western Digital Research

