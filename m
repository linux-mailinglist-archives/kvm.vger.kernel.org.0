Return-Path: <kvm+bounces-40908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E57D6A5EEE1
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 10:04:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A63A3B56CD
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 09:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BD6C2641D4;
	Thu, 13 Mar 2025 09:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X8UzyDYT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B0E263F52
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741856599; cv=none; b=fiTUcms2jCNIkKIuWG0bjXqE3v3/ZXs8Rbx8Xjah+g0odmIoej3v+GXB3OcKtFAJyG7WsVshZx1Gs+srK5VeKQxKgaSBvqcf+rspjRMkqIww6YA4T/6aNcLJu+emEcRC0d1RVjp4sQkxbDox2ARRfQP930sBaqWj/yzkWRuvXS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741856599; c=relaxed/simple;
	bh=aZDWaOl31agwHSeFtrIfizSaaXAxaHm409w6nhtjL+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FgYNuubCvLLGplYhMlRFp61ao/mq+QYJZG2c4ZXLcZIdzTRmgHTCnsQqbKEywDn8D1w+ffkEiQEyp1SqnKhdSa1D1j+1tNSwSm4+gM4jcsq2GS2h5b9YiXX+welHPj7+4deBdxabfuMpi6KsSnEImhVAl2UijbF6T8jtDBwlAgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X8UzyDYT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15004C4CEDD;
	Thu, 13 Mar 2025 09:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741856596;
	bh=aZDWaOl31agwHSeFtrIfizSaaXAxaHm409w6nhtjL+8=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=X8UzyDYTEKdL3S2qnz6m5u7fSPURWkYCQy9eUyHoC9ygq6hDiZobVAVTxtiXU46Mn
	 dT7arCyTfeoiT+4R5U+NKAfe3mxfPJs6TCYNaA+pIZTqRohxwrdsi3U8AxoXfrvsDk
	 xTCBDnc+xuHt6YWaBQYqlP385/oTDGwa61nkoyigSZzJr5d3IUEq9FGo7DwVqSsMUK
	 oyCH7r4GPhcqGs4FG01F+QUIBXpnmMr1T6mFhelNwcdtL6TIhqGUBdxvfNm/Xa8IhA
	 4MQp2T25wvb3DxMZ/Xl/9yvQyMkWTSPOHRiZVMi1wuirYm3i1GwMQTTHh07yoBMBud
	 nUZ1yCqyuwSRg==
Message-ID: <f7e7c4e0-1997-4edd-a0b6-137f5abca3c0@kernel.org>
Date: Thu, 13 Mar 2025 18:03:13 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 04/11] nvmet: Add function to get nvmet_fabrics_ops
 from trtype
To: Mike Christie <michael.christie@oracle.com>, chaitanyak@nvidia.com,
 kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, joao.m.martins@oracle.com,
 linux-nvme@lists.infradead.org, kvm@vger.kernel.org, kwankhede@nvidia.com,
 alex.williamson@redhat.com, mlevitsk@redhat.com
References: <20250313052222.178524-1-michael.christie@oracle.com>
 <20250313052222.178524-5-michael.christie@oracle.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250313052222.178524-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/13/25 14:18, Mike Christie wrote:
> In the next patches we allow users to create static controllers if the
> driver supports it. To get this info we need the nvmet_fabrics_ops
> a little sooner then port enablement so this creates a function to go
> from trtype to nvmet_fabrics_ops.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/nvme/target/core.c  | 41 +++++++++++++++++++++++--------------
>  drivers/nvme/target/nvmet.h |  1 +
>  2 files changed, 27 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
> index 4de534eafd89..06967c00e9a2 100644
> --- a/drivers/nvme/target/core.c
> +++ b/drivers/nvme/target/core.c
> @@ -306,6 +306,30 @@ void nvmet_unregister_transport(const struct nvmet_fabrics_ops *ops)
>  }
>  EXPORT_SYMBOL_GPL(nvmet_unregister_transport);
>  
> +const struct nvmet_fabrics_ops *nvmet_get_ops_by_transport(int trtype)
> +{
> +	const struct nvmet_fabrics_ops *ops;
> +
> +	lockdep_assert_held(&nvmet_config_sem);
> +
> +	ops = nvmet_transports[trtype];
> +	if (!ops) {
> +		up_write(&nvmet_config_sem);
> +		request_module("nvmet-transport-%d", trtype);
> +		down_write(&nvmet_config_sem);
> +		ops = nvmet_transports[trtype];
> +		if (!ops) {
> +			pr_err("transport type %d not supported\n", trtype);
> +			return NULL;
> +		}
> +	}
> +
> +	if (!try_module_get(ops->owner))
> +		return NULL;
> +
> +	return ops;
> +}
> +
>  void nvmet_port_del_ctrls(struct nvmet_port *port, struct nvmet_subsys *subsys)
>  {
>  	struct nvmet_ctrl *ctrl;
> @@ -325,22 +349,9 @@ int nvmet_enable_port(struct nvmet_port *port)
>  
>  	lockdep_assert_held(&nvmet_config_sem);
>  
> -	ops = nvmet_transports[port->disc_addr.trtype];
> -	if (!ops) {
> -		up_write(&nvmet_config_sem);
> -		request_module("nvmet-transport-%d", port->disc_addr.trtype);
> -		down_write(&nvmet_config_sem);
> -		ops = nvmet_transports[port->disc_addr.trtype];
> -		if (!ops) {
> -			pr_err("transport type %d not supported\n",
> -				port->disc_addr.trtype);
> -			return -EINVAL;
> -		}
> -	}
> -
> -	if (!try_module_get(ops->owner))
> +	ops = nvmet_get_ops_by_transport(port->disc_addr.trtype);
> +	if (!ops)
>  		return -EINVAL;
> -

whiteline change.

>  	/*
>  	 * If the user requested PI support and the transport isn't pi capable,
>  	 * don't enable the port.
> diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
> index ec3d10eb316a..052ea4a105fc 100644
> --- a/drivers/nvme/target/nvmet.h
> +++ b/drivers/nvme/target/nvmet.h
> @@ -622,6 +622,7 @@ void nvmet_port_send_ana_event(struct nvmet_port *port);
>  
>  int nvmet_register_transport(const struct nvmet_fabrics_ops *ops);
>  void nvmet_unregister_transport(const struct nvmet_fabrics_ops *ops);
> +const struct nvmet_fabrics_ops *nvmet_get_ops_by_transport(int trtype);
>  
>  void nvmet_port_del_ctrls(struct nvmet_port *port,
>  			  struct nvmet_subsys *subsys);


-- 
Damien Le Moal
Western Digital Research

