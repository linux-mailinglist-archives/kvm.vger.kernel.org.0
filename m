Return-Path: <kvm+bounces-56815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B74DFB4375B
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 11:41:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 771441C225BA
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 09:41:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB8E32F7479;
	Thu,  4 Sep 2025 09:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="emZOx7j1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1112B26B2CE
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 09:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756978870; cv=none; b=tbUFx8KJGu26LpMKS0BSFjyDOA7Dz5VVrNbULx8Af0HW8RVSXDJw0BCXBLdgJeabAb3VwNKQougVbEH6jC2ih+fKoRg+KQWXvjw0TMafigLwdMKOYB05wXjcBJPE7SNEyVxxf+HmU3LgMCirRUjYQt7XK6tKCkYNSdZ4x1/RFJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756978870; c=relaxed/simple;
	bh=XYdtB4QgovF+/4eIgDO6JOdgw1qaH6+X67HqQbA3+NA=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=IXU3/tZKT9puRsylX3NSM6i9dwlzdYjikaGrZg5TjzDrkCVIxjYbcTw8yAEE1xN+GuwV4mebgjtNJdYz52fGxMXovIB4DDfeSaY02geea0IEkWkXunK+kDGG1OtNzAWjmlrHZJksTtE71aYOVwPyy0PY6VcVtlI7Rt6ZgHFqBq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=emZOx7j1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E2CC4CEF0;
	Thu,  4 Sep 2025 09:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756978869;
	bh=XYdtB4QgovF+/4eIgDO6JOdgw1qaH6+X67HqQbA3+NA=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=emZOx7j1dmRvG9tz6tSHCvhrVWXUU7ddp38STr5r/X91vmjD9gBl42jgA3duq/Usl
	 FYoAI67aenRw9P7j9jyjQ1dSYu9dOfWH5EJ2LtggRvIDijDhZ/QJHgEPTQwT46QedR
	 nKQjVLO1a7GWUbcwBz/rCi04elO5DhK4RBJFx9Gych2+PHwF2V6+snjYwQ0Ep3zRP9
	 j6KBvAjES8255+XPyFqCJqitNUB7rbZDQhxO1ockGOCSQs3RQLnAWyjkvjVq9zbfhZ
	 ICInW73iRQfgU8ShTte2Bws7+KueMHQo/wFDvI1iyqz5kS5Zk0IorznGEsoyoUKa89
	 PrL4Qq41iykXw==
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 04 Sep 2025 11:41:03 +0200
Message-Id: <DCJX0ZBB1ATN.1WPXONLVV8RYD@kernel.org>
Subject: Re: [RFC v2 03/14] vfio/nvidia-vgpu: introduce vGPU type uploading
Cc: <kvm@vger.kernel.org>, <alex.williamson@redhat.com>,
 <kevin.tian@intel.com>, <jgg@nvidia.com>, <airlied@gmail.com>,
 <daniel@ffwll.ch>, <acurrid@nvidia.com>, <cjia@nvidia.com>,
 <smitra@nvidia.com>, <ankita@nvidia.com>, <aniketa@nvidia.com>,
 <kwankhede@nvidia.com>, <targupta@nvidia.com>, <zhiwang@kernel.org>,
 <acourbot@nvidia.com>, <joelagnelf@nvidia.com>, <apopple@nvidia.com>,
 <jhubbard@nvidia.com>, <nouveau@lists.freedesktop.org>
To: "Zhi Wang" <zhiw@nvidia.com>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250903221111.3866249-1-zhiw@nvidia.com>
 <20250903221111.3866249-4-zhiw@nvidia.com>
 <DCJWXVLI2GWB.3UBHWIZCZXKD2@kernel.org>
In-Reply-To: <DCJWXVLI2GWB.3UBHWIZCZXKD2@kernel.org>

(Cc: Alex, John, Joel, Alistair, nouveau)

On Thu Sep 4, 2025 at 11:37 AM CEST, Danilo Krummrich wrote:
> On Thu Sep 4, 2025 at 12:11 AM CEST, Zhi Wang wrote:
>> diff --git a/drivers/vfio/pci/nvidia-vgpu/include/nvrm/gsp.h b/drivers/v=
fio/pci/nvidia-vgpu/include/nvrm/gsp.h
>> new file mode 100644
>> index 000000000000..c3fb7b299533
>> --- /dev/null
>> +++ b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/gsp.h
>> @@ -0,0 +1,18 @@
>> +/* SPDX-License-Identifier: MIT */
>> +#ifndef __NVRM_GSP_H__
>> +#define __NVRM_GSP_H__
>> +
>> +#include <nvrm/nvtypes.h>
>> +
>> +/* Excerpt of RM headers from https://github.com/NVIDIA/open-gpu-kernel=
-modules/tree/570 */
>> +
>> +#define NV2080_CTRL_CMD_GSP_GET_FEATURES (0x20803601)
>> +
>> +typedef struct NV2080_CTRL_GSP_GET_FEATURES_PARAMS {
>> +	NvU32  gspFeatures;
>> +	NvBool bValid;
>> +	NvBool bDefaultGspRmGpu;
>> +	NvU8   firmwareVersion[GSP_MAX_BUILD_VERSION_LENGTH];
>> +} NV2080_CTRL_GSP_GET_FEATURES_PARAMS;
>> +
>> +#endif
>
> <snip>
>
>> +static struct version supported_version_list[] =3D {
>> +	{ 18, 1, "570.144" },
>> +};
>
> nova-core won't provide any firmware specific APIs, it is meant to serve =
as a
> hardware and firmware abstraction layer for higher level drivers, such as=
 vGPU
> or nova-drm.
>
> As a general rule the interface between nova-core and higher level driver=
s must
> not leak any hardware or firmware specific details, but work on a higher =
level
> abstraction layer.
>
> Now, I recognize that at some point it might be necessary to do some kind=
 of
> versioning in this API anyways. For instance, when the semantics of the f=
irmware
> API changes too significantly.
>
> However, this would be a separte API where nova-core, at the initial hand=
shake,
> then asks clients to use e.g. v2 of the nova-core API, still hiding any f=
irmware
> and hardware details from the client.
>
> Some more general notes, since I also had a look at the nova-core <-> vGP=
U
> interface patches in your tree (even though I'm aware that they're not pa=
rt of
> the RFC of course):
>
> The interface for the general lifecycle management for any clients attach=
ing to
> nova-core (VGPU, nova-drm) should be common and not specific to vGPU. (Th=
e same
> goes for interfaces that will be used by vGPU and nova-drm.)
>
> The interface nova-core provides for that should be designed in Rust, so =
we can
> take advantage of all the features the type system provides us with conne=
cting
> to Rust clients (nova-drm).
>
> For vGPU, we can then monomorphize those types into the corresponding C
> structures and provide the corresponding functions very easily.
>
> Doing it the other way around would be a very bad idea, since the Rust ty=
pe
> system is much more powerful and hence it'd be very hard to avoid introdu=
cing
> limitations on the Rust side of things.
>
> Hence, I recommend to start with some patches defining the API in nova-co=
re for
> the general lifecycle (in Rust), so we can take it from there.
>
> Another note: I don't see any use of the auxiliary bus in vGPU, any clien=
ts
> should attach via the auxiliary bus API, it provides proper matching wher=
e
> there's more than on compatible GPU in the system. nova-core already regi=
sters
> an auxiliary device for each bound PCI device.
>
> Please don't re-implement what the auxiliary bus already does for us.
>
> - Danilo


