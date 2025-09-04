Return-Path: <kvm+bounces-56814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 730A4B4374E
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 11:37:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EEB44843DB
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 09:37:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 966AA2F658E;
	Thu,  4 Sep 2025 09:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lSLjQM/U"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14531A9F82
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 09:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756978625; cv=none; b=phaEtsdQKREQFvnLaGX3ubhC1wJtuExrZj0M8nUBwd/WJcUcE3y8Z7kAFC6Qh8CHu+LX+2U8Ul2If9zX9eJ4iPFA/nmbk42URnAJgWrUefXegUNFubKlpelLo7IYegCh3cxY/gKwDAnsyTJwDYa86HdfVkLsoN3GZQAHlFomD5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756978625; c=relaxed/simple;
	bh=vJJxdgxF4Bc1mcgD+FVWMOuZJmSFyxuk3LWs2VZahuA=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:From:Subject:Cc:
	 References:In-Reply-To; b=EuWHjNt3kAVTOir5j1k6P5As1o5ps3gR9Us+QJfa4lkCH39yqbACaKbIwtjZefQ/C5nvZjCmdgb2QvEcq9NfXz8vP1tKUOon8ObZIRr+JjH6hLTx/ZJBSjH6+B3sjkF9EA4vtAl7k1Cnu3fEdPqslV+FKjvscgfcXp0dy1fMfD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lSLjQM/U; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875E2C4CEF0;
	Thu,  4 Sep 2025 09:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756978625;
	bh=vJJxdgxF4Bc1mcgD+FVWMOuZJmSFyxuk3LWs2VZahuA=;
	h=Date:To:From:Subject:Cc:References:In-Reply-To:From;
	b=lSLjQM/URQzEDKXVmo6Tp0d/dvdPxRDeepDVKv8jqydSxXyPdIZd8pn/D/HVibvnj
	 kS9XWbhKc00HqzFyap53aEKgWMktKYxIhM/dx95wTjJqcluK7OlFiVyGzFToTrNXFY
	 YbFE7A32TImc/3hAieNP/Mo+XolpvMQsbz7oQ//EA0Y4kU0isuyNq2DF2BB+3zE0Ua
	 t+93dbA9UShMuEbajsREwl/bMwufstnA/77xYn8YSfJFV2RfivjY2hujgejK5yNlGp
	 PiTlpkyr7txr24LKDgy08GR6FVaQiZ+GUsugnzYXCi2RCHI5Ne/oi+Ykoe7Ae17GOe
	 VE7YgbPdU7Sxw==
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 04 Sep 2025 11:37:00 +0200
Message-Id: <DCJWXVLI2GWB.3UBHWIZCZXKD2@kernel.org>
To: "Zhi Wang" <zhiw@nvidia.com>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [RFC v2 03/14] vfio/nvidia-vgpu: introduce vGPU type uploading
Cc: <kvm@vger.kernel.org>, <alex.williamson@redhat.com>,
 <kevin.tian@intel.com>, <jgg@nvidia.com>, <airlied@gmail.com>,
 <daniel@ffwll.ch>, <acurrid@nvidia.com>, <cjia@nvidia.com>,
 <smitra@nvidia.com>, <ankita@nvidia.com>, <aniketa@nvidia.com>,
 <kwankhede@nvidia.com>, <targupta@nvidia.com>, <zhiwang@kernel.org>
References: <20250903221111.3866249-1-zhiw@nvidia.com>
 <20250903221111.3866249-4-zhiw@nvidia.com>
In-Reply-To: <20250903221111.3866249-4-zhiw@nvidia.com>

On Thu Sep 4, 2025 at 12:11 AM CEST, Zhi Wang wrote:
> diff --git a/drivers/vfio/pci/nvidia-vgpu/include/nvrm/gsp.h b/drivers/vf=
io/pci/nvidia-vgpu/include/nvrm/gsp.h
> new file mode 100644
> index 000000000000..c3fb7b299533
> --- /dev/null
> +++ b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/gsp.h
> @@ -0,0 +1,18 @@
> +/* SPDX-License-Identifier: MIT */
> +#ifndef __NVRM_GSP_H__
> +#define __NVRM_GSP_H__
> +
> +#include <nvrm/nvtypes.h>
> +
> +/* Excerpt of RM headers from https://github.com/NVIDIA/open-gpu-kernel-=
modules/tree/570 */
> +
> +#define NV2080_CTRL_CMD_GSP_GET_FEATURES (0x20803601)
> +
> +typedef struct NV2080_CTRL_GSP_GET_FEATURES_PARAMS {
> +	NvU32  gspFeatures;
> +	NvBool bValid;
> +	NvBool bDefaultGspRmGpu;
> +	NvU8   firmwareVersion[GSP_MAX_BUILD_VERSION_LENGTH];
> +} NV2080_CTRL_GSP_GET_FEATURES_PARAMS;
> +
> +#endif

<snip>

> +static struct version supported_version_list[] =3D {
> +	{ 18, 1, "570.144" },
> +};

nova-core won't provide any firmware specific APIs, it is meant to serve as=
 a
hardware and firmware abstraction layer for higher level drivers, such as v=
GPU
or nova-drm.

As a general rule the interface between nova-core and higher level drivers =
must
not leak any hardware or firmware specific details, but work on a higher le=
vel
abstraction layer.

Now, I recognize that at some point it might be necessary to do some kind o=
f
versioning in this API anyways. For instance, when the semantics of the fir=
mware
API changes too significantly.

However, this would be a separte API where nova-core, at the initial handsh=
ake,
then asks clients to use e.g. v2 of the nova-core API, still hiding any fir=
mware
and hardware details from the client.

Some more general notes, since I also had a look at the nova-core <-> vGPU
interface patches in your tree (even though I'm aware that they're not part=
 of
the RFC of course):

The interface for the general lifecycle management for any clients attachin=
g to
nova-core (VGPU, nova-drm) should be common and not specific to vGPU. (The =
same
goes for interfaces that will be used by vGPU and nova-drm.)

The interface nova-core provides for that should be designed in Rust, so we=
 can
take advantage of all the features the type system provides us with connect=
ing
to Rust clients (nova-drm).

For vGPU, we can then monomorphize those types into the corresponding C
structures and provide the corresponding functions very easily.

Doing it the other way around would be a very bad idea, since the Rust type
system is much more powerful and hence it'd be very hard to avoid introduci=
ng
limitations on the Rust side of things.

Hence, I recommend to start with some patches defining the API in nova-core=
 for
the general lifecycle (in Rust), so we can take it from there.

Another note: I don't see any use of the auxiliary bus in vGPU, any clients
should attach via the auxiliary bus API, it provides proper matching where
there's more than on compatible GPU in the system. nova-core already regist=
ers
an auxiliary device for each bound PCI device.

Please don't re-implement what the auxiliary bus already does for us.

- Danilo

