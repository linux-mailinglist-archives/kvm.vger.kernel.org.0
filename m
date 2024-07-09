Return-Path: <kvm+bounces-21168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53A5F92B5D5
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 12:49:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F0121C21E5F
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 10:49:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 894EB157461;
	Tue,  9 Jul 2024 10:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YH2oSUoS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92D614290;
	Tue,  9 Jul 2024 10:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720522138; cv=none; b=ulXAOx7Y8OAambgd83XwxT59I1rv2I9FXl0bGxBo5ZnDpvAMPZ7MggIIaydObJw9HSdFlfkhSWjV8VEhCfWhB27NFbZrRoZe4QAJXDaxzA82I7CK+TMOrbKtxYgMhf/7of497SZzjwOqoUXNgjJYOyH/0S9J8EkgKay70+4ixGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720522138; c=relaxed/simple;
	bh=+0UCCKX9eTmUCtlh6j65FUsSAck/OtEeFegBRXqawoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c9SapNBiHMa5QFDTJOipdci4jrOVm099kJLfEEFGOy+JUEoAfg7zXJQgahyTMNuBjPa7F3/XJxS/GdmQLGqU7zmLPc00HEceVeuEJSXNa9OfMgkajcTLHBh1dxwrzQlxbwkFm9tFPw0Ve33DHOG5HXLpa5/FmFdcCx+pSy41byM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YH2oSUoS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBF3C3277B;
	Tue,  9 Jul 2024 10:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720522138;
	bh=+0UCCKX9eTmUCtlh6j65FUsSAck/OtEeFegBRXqawoA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YH2oSUoS8Mrw383mytbFplGa9CwGgWmEBAuIXD1eNNWw4D8cmmis+Ey6BXCcyhJu4
	 dSUSlQqkWVZoqbU2ratz0Ul7+lyCNt8lJmeFy+hEl8RgcBWlLTxKHSkr6x7QHTphsi
	 FSpKjRepjzSseN2lHHu+UXddVEyNrKX+oyyOvdT5sSgG23FKJT44aYcNBQ+1kOxtU6
	 8RG+CQVCSWZpUzpAq3baaIm+lD/O8GT/+BLZLh3rjX8XEdk3tw/Wo+tGOAG8+zdZrS
	 yCZF/uUk165W3pxsBTnS4IU8KwSwKto9ja749I67GhEjcYLGBg/bgNzUq4NMSLOLbD
	 WW7gvGuz4JwiQ==
Date: Tue, 9 Jul 2024 11:48:51 +0100
From: Will Deacon <will@kernel.org>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v4 02/15] firmware/psci: Add psci_early_test_conduit()
Message-ID: <20240709104851.GE12978@willie-the-truck>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-3-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240701095505.165383-3-steven.price@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jul 01, 2024 at 10:54:52AM +0100, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> Add a function to test early if PSCI is present and what conduit it
> uses. Because the PSCI conduit corresponds to the SMCCC one, this will
> let the kernel know whether it can use SMC instructions to discuss with
> the Realm Management Monitor (RMM), early enough to enable RAM and
> serial access when running in a Realm.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> v4: New patch
> ---
>  drivers/firmware/psci/psci.c | 25 +++++++++++++++++++++++++
>  include/linux/psci.h         |  5 +++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
> index d9629ff87861..a40dcaf17822 100644
> --- a/drivers/firmware/psci/psci.c
> +++ b/drivers/firmware/psci/psci.c
> @@ -13,6 +13,7 @@
>  #include <linux/errno.h>
>  #include <linux/linkage.h>
>  #include <linux/of.h>
> +#include <linux/of_fdt.h>
>  #include <linux/pm.h>
>  #include <linux/printk.h>
>  #include <linux/psci.h>
> @@ -767,6 +768,30 @@ int __init psci_dt_init(void)
>  	return ret;
>  }
>  
> +/*
> + * Test early if PSCI is supported, and if its conduit matches @conduit
> + */
> +bool __init psci_early_test_conduit(enum arm_smccc_conduit conduit)
> +{
> +	int len;
> +	int psci_node;
> +	const char *method;
> +	unsigned long dt_root;
> +
> +	/* DT hasn't been unflattened yet, we have to work with the flat blob */
> +	dt_root = of_get_flat_dt_root();
> +	psci_node = of_get_flat_dt_subnode_by_name(dt_root, "psci");
> +	if (psci_node <= 0)
> +		return false;
> +
> +	method = of_get_flat_dt_prop(psci_node, "method", &len);
> +	if (!method)
> +		return false;
> +
> +	return  (conduit == SMCCC_CONDUIT_SMC && strncmp(method, "smc", len) == 0) ||
> +		(conduit == SMCCC_CONDUIT_HVC && strncmp(method, "hvc", len) == 0);
> +}

Hmm, I don't think this is sufficient to check for SMCCC reliably.
Instead, I think you need to do something more involved:

1. Check for PSCI in the DT
2. Check that the PSCI major version is >= 1
3. Use PSCI_FEATURES to check that you have SMCCC
4. Use SMCCC_VERSION to find out which version of SMCCC you have

That's roughly what the PSCI driver does, so we should avoid duplicating
that logic.

Will

