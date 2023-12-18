Return-Path: <kvm+bounces-4732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33C9B817648
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 16:49:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C5111C213AE
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 15:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE7D74239B;
	Mon, 18 Dec 2023 15:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OxzhKKIR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1A55A879
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 15:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702914369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qE58Iyt4ieyHgCB0J7mbfm6qUfvo4Ia92ji4r99oP2g=;
	b=OxzhKKIRQk2pkY/nkw8sZM3RDa7XG96ApjGVcrDvnxUcq2T5wd4Cbis6dHchJ6JyNv1pmf
	8Th/fIgR9bIdvqCg8m69WOoHqjkBTxJ0OxQKsOx6UImxHTWeZspdszCWSsbdJxYryNFj6r
	xwY9Qa/IBX7wUZQR3zu8yPmEBgzj8Kk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-sIsxz5FFOcCVnMYm3pBlDg-1; Mon, 18 Dec 2023 10:46:07 -0500
X-MC-Unique: sIsxz5FFOcCVnMYm3pBlDg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-40c514f9243so22859865e9.3
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 07:46:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702914366; x=1703519166;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qE58Iyt4ieyHgCB0J7mbfm6qUfvo4Ia92ji4r99oP2g=;
        b=Oj/1UtKBnYaMvpE7zod8ytTx7tx9zHO5BXgaYWH6idhtXdLTXJSWs2CeNMDOfvGuB0
         AoZ3JZpVAcFbSw4c3o76oeNelBqQPmsPuCQP3q2BdrCjd/9Favqc9ZoP7vOOotbQuc3Q
         C/epm8IdaNaqXgMYI/7MMHOtRhbU/8vQux7flRQ+hVyk1f6IwlCOLfBPWcl3lp43co8M
         yHB1QAPJWZGToc6A5+JJJ+UQpsif56LgtJrbPmG3s3NQlHDbjhJIta5pSR/TP1eORI7t
         JdUYc7natebewdOfW9F51ani7q0mYijlwJHHKY/lpQ4EbpVraKOshwmVTcDSCIOCUa8G
         Ug4w==
X-Gm-Message-State: AOJu0YxjrdT0hc9oSzFpaZo5QSWKPegb72R2mzTw27tx1go7m1Dqg4CW
	A7vuxxy8lRBo9rXSzRjk+vWlpuloEcFJo7O0w2nyNvPk0VjFpNCGADmd82CC8P/TA5a9miGi38x
	gVl2+gd5cdg+g
X-Received: by 2002:adf:e684:0:b0:336:613e:ada with SMTP id r4-20020adfe684000000b00336613e0adamr2278779wrm.3.1702914365750;
        Mon, 18 Dec 2023 07:46:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFBkkx+bp2I175obL+0JUnu3L0ncwXnQN9VgUvXg+bodxH2f23vzTjKUi0CNim6a46TKUhzWw==
X-Received: by 2002:adf:e684:0:b0:336:613e:ada with SMTP id r4-20020adfe684000000b00336613e0adamr2278733wrm.3.1702914364998;
        Mon, 18 Dec 2023 07:46:04 -0800 (PST)
Received: from ?IPV6:2a01:e0a:280:24f0:3f78:514a:4f03:fdc0? ([2a01:e0a:280:24f0:3f78:514a:4f03:fdc0])
        by smtp.gmail.com with ESMTPSA id d5-20020a5d5385000000b0033662cf5e51sm5048029wrv.93.2023.12.18.07.46.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Dec 2023 07:46:04 -0800 (PST)
Message-ID: <1430f453-f22f-4f83-8d65-35eeb470aebd@redhat.com>
Date: Mon, 18 Dec 2023 16:46:03 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 1/1] vfio/nvgrace-gpu: Add vfio pci variant module for
 grace hopper
Content-Language: en-US
To: ankita@nvidia.com, jgg@nvidia.com, alex.williamson@redhat.com,
 yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
 kevin.tian@intel.com, eric.auger@redhat.com, brett.creeley@amd.com,
 horms@kernel.org
Cc: aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
 targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
 apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
 anuaggarwal@nvidia.com, mochs@nvidia.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20231217191031.19476-1-ankita@nvidia.com>
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
In-Reply-To: <20231217191031.19476-1-ankita@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Ankit,

On 12/17/23 20:10, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> NVIDIA's upcoming Grace Hopper Superchip provides a PCI-like device
> for the on-chip GPU that is the logical OS representation of the
> internal proprietary chip-to-chip cache coherent interconnect.
> 
> The device is peculiar compared to a real PCI device in that whilst
> there is a real 64b PCI BAR1 (comprising region 2 & region 3) on the
> device, it is not used to access device memory once the faster
> chip-to-chip interconnect is initialized (occurs at the time of host
> system boot). The device memory is accessed instead using the chip-to-chip
> interconnect that is exposed as a contiguous physically addressable
> region on the host. This device memory aperture can be obtained from host
> ACPI table using device_property_read_u64(), according to the FW
> specification. Since the device memory is cache coherent with the CPU,
> it can be mmap into the user VMA with a cacheable mapping using
> remap_pfn_range() and used like a regular RAM. The device memory
> is not added to the host kernel, but mapped directly as this reduces
> memory wastage due to struct pages.
> 
> There is also a requirement of a reserved 1G uncached region (termed as
> resmem) to support the Multi-Instance GPU (MIG) feature [1]. Based on [2],
> the requisite properties (uncached, unaligned access) can be achieved
> through a VM mapping (S1) of NORMAL_NC and host (S2) mapping with
> MemAttr[2:0]=0b101. To provide a different non-cached property to the
> reserved 1G region, it needs to be carved out from the device memory and
> mapped as a separate region in Qemu VMA with pgprot_writecombine().
> pgprot_writecombine() sets the Qemu VMA page properties (pgprot) as
> NORMAL_NC.
> 
> Provide a VFIO PCI variant driver that adapts the unique device memory
> representation into a more standard PCI representation facing userspace.
> 
> The variant driver exposes these two regions - the non-cached reserved
> (resmem) and the cached rest of the device memory (termed as usemem) as
> separate VFIO 64b BAR regions. Since the device implements 64-bit BAR0,
> the VFIO PCI variant driver maps the uncached carved out region to the
> next available PCI BAR (i.e. comprising of region 2 and 3). The cached
> device memory aperture is assigned BAR region 4 and 5. Qemu will then
> naturally generate a PCI device in the VM with the uncached aperture
> reported as BAR2 region, the cacheable as BAR4. The variant driver provides
> emulation for these fake BARs' PCI config space offset registers. The
> BAR can also be enabled/disabled through PCI_COMMAND config space register.
> The VM driver should enable the BARs (as it does already) to make use
> of the device memory.
> 
> The memory layout on the host looks like the following:
>                 devmem (memlength)
> |--------------------------------------------------|
> |-------------cached------------------------|--NC--|
> |                                           |
> usemem.phys/memphys                         resmem.phys
> 
> PCI BARs need to be aligned to the power-of-2, but the actual memory on the
> device may not. A read or write access to the physical address from the
> last device PFN up to the next power-of-2 aligned physical address
> results in reading ~0 and dropped writes. Note that the GPU device
> driver [6] is capable of knowing the exact device memory size through
> separate means. The device memory size is primarily kept in the system
> ACPI tables for use by the VFIO PCI variant module.
> 
> Note that the usemem memory is added by the VM Nvidia device driver [5]
> to the VM kernel as memblocks. Hence make the usable memory size memblock
> aligned.
> 
> Currently there is no provision in KVM for a S2 mapping with
> MemAttr[2:0]=0b101, but there is an ongoing effort to provide the same [3].
> As previously mentioned, resmem is mapped pgprot_writecombine(), that
> sets the Qemu VMA page properties (pgprot) as NORMAL_NC. Using the
> proposed changes in [4] and [3], KVM marks the region with
> MemAttr[2:0]=0b101 in S2.
> 
> This goes along with a qemu series [6] to provides the necessary
> implementation of the Grace Hopper Superchip firmware specification so
> that the guest operating system can see the correct ACPI modeling for
> the coherent GPU device. Verified with the CUDA workload in the VM.
> 
> [1] https://www.nvidia.com/en-in/technologies/multi-instance-gpu/
> [2] section D8.5.5 of https://developer.arm.com/documentation/ddi0487/latest/
> [3] https://lore.kernel.org/all/20231205033015.10044-1-ankita@nvidia.com/
> [4] https://lore.kernel.org/all/20230907181459.18145-2-ankita@nvidia.com/
> [5] https://github.com/NVIDIA/open-gpu-kernel-modules
> [6] https://lore.kernel.org/all/20231203060245.31593-1-ankita@nvidia.com/
> 
> Applied over next-20231211.
> ---
> Link for variant driver v14:
> https://lore.kernel.org/all/20231212184613.3237-1-ankita@nvidia.com/
> 
> v14 -> v15
> - Added case to handle VFIO_DEVICE_IOEVENTFD to return -EIO as it
>    is not required on the device.
> - Updated the BAR config space handling code to closely resemble
>    by Yishai Hadas (using range_intersect_range) in
>    https://lore.kernel.org/all/20231207102820.74820-10-yishaih@nvidia.com
> - Changed the bar pci config register from union to u64.
> - Adapted the code to disable BAR when it is disabled through
>    PCI_COMMAND.
> - Exported and reused the do_io_rw to do mmio accesses.
> - Added a new header file to keep the newly declared structures.
> - Miscellaneous code fixes suggested by Alex Williamson in v14.

./scripts/checkpatch.pl --strict will give you some tips on how to
improve the changes furthermore.


> v13 -> v14
> - Merged the changes for second BAR implementation for MIG support
>    on the device driver.
>    https://lore.kernel.org/all/20231115080751.4558-1-ankita@nvidia.com/
> - Added the missing implementation of sub-word access to fake BARs'
>    PCI config access. Implemented access algorithm suggested by
>    Alex Williamson in the comments (Thanks!)
> - Added support to BAR accesses on the reserved memory with
>    Qemu device param x-no-mmap=on.
> - Handled endian-ness in the PCI config space access.
> - Git commit message change
> 
> v12 -> v13
> - Added emulation for the PCI config space BAR offset register for
> the fake BAR.
> - commit message updated with more details on the BAR offset emulation.
> 
> v11 -> v12
> - More details in commit message on device memory size
> 
> v10 -> v11
> - Removed sysfs attribute to expose the CPU coherent memory feature
> - Addressed review comments
> 
> v9 -> v10
> - Add new sysfs attribute to expose the CPU coherent memory feature.
> 
> v8 -> v9
> - Minor code adjustment suggested in v8.
> 
> v7 -> v8
> - Various field names updated.
> - Added a new function to handle VFIO_DEVICE_GET_REGION_INFO ioctl.
> - Locking protection for memremap to bar region and other changes
>    recommended in v7.
> - Added code to fail if the devmem size advertized is 0 in system DSDT.
> 
> v6 -> v7
> - Handled out-of-bound and overflow conditions at various places to validate
>    input offset and length.
> - Added code to return EINVAL for offset beyond region size.
> 
> v5 -> v6
> - Added the code to handle BAR2 read/write using memremap to the device
>    memory.
> 
> v4 -> v5
> - Changed the module name from nvgpu-vfio-pci to nvgrace-gpu-vfio-pci.
> - Fixed memory leak and added suggested boundary checks on device memory
>    mapping.
> - Added code to read all Fs and ignored write on region outside of the
>    physical memory.
> - Other miscellaneous cleanup suggestions.
> 
> v3 -> v4
> - Mapping the available device memory using sparse mmap. The region outside
>    the device memory is handled by read/write ops.
> - Removed the fault handler added in v3.
> 
> v2 -> v3
> - Added fault handler to map the region outside the physical GPU memory
>    up to the next power-of-2 to a dummy PFN.
> - Changed to select instead of "depends on" VFIO_PCI_CORE for all the
>    vfio-pci variant driver.
> - Code cleanup based on feedback comments.
> - Code implemented and tested against v6.4-rc4.
> 
> v1 -> v2
> - Updated the wording of reference to BAR offset and replaced with
>    index.
> - The GPU memory is exposed at the fixed BAR2_REGION_INDEX.
> - Code cleanup based on feedback comments.
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> Signed-off-by: Aniket Agashe <aniketa@nvidia.com>
> Tested-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>   MAINTAINERS                           |   6 +
>   drivers/vfio/pci/Kconfig              |   2 +
>   drivers/vfio/pci/Makefile             |   2 +
>   drivers/vfio/pci/nvgrace-gpu/Kconfig  |  10 +
>   drivers/vfio/pci/nvgrace-gpu/Makefile |   3 +
>   drivers/vfio/pci/nvgrace-gpu/main.c   | 806 ++++++++++++++++++++++++++
>   drivers/vfio/pci/vfio_pci_rdwr.c      |   9 +-
>   7 files changed, 834 insertions(+), 4 deletions(-)
>   create mode 100644 drivers/vfio/pci/nvgrace-gpu/Kconfig
>   create mode 100644 drivers/vfio/pci/nvgrace-gpu/Makefile
>   create mode 100644 drivers/vfio/pci/nvgrace-gpu/main.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 98f7dd0499f1..6f8f3a6daa43 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22877,6 +22877,12 @@ L:	kvm@vger.kernel.org
>   S:	Maintained
>   F:	drivers/vfio/platform/
>   
> +VFIO NVIDIA GRACE GPU DRIVER
> +M:	Ankit Agrawal <ankita@nvidia.com>
> +L:	kvm@vger.kernel.org
> +S:	Maintained
> +F:	drivers/vfio/pci/nvgrace-gpu/
> +
>   VGA_SWITCHEROO
>   R:	Lukas Wunner <lukas@wunner.de>
>   S:	Maintained
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 8125e5f37832..2456210e85f1 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -65,4 +65,6 @@ source "drivers/vfio/pci/hisilicon/Kconfig"
>   
>   source "drivers/vfio/pci/pds/Kconfig"
>   
> +source "drivers/vfio/pci/nvgrace-gpu/Kconfig"
> +
>   endmenu
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index 45167be462d8..1352c65e568a 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -13,3 +13,5 @@ obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
>   obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
>   
>   obj-$(CONFIG_PDS_VFIO_PCI) += pds/
> +
> +obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu/
> diff --git a/drivers/vfio/pci/nvgrace-gpu/Kconfig b/drivers/vfio/pci/nvgrace-gpu/Kconfig
> new file mode 100644
> index 000000000000..936e88d8d41d
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgrace-gpu/Kconfig
> @@ -0,0 +1,10 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config NVGRACE_GPU_VFIO_PCI
> +	tristate "VFIO support for the GPU in the NVIDIA Grace Hopper Superchip"
> +	depends on ARM64 || (COMPILE_TEST && 64BIT)
> +	select VFIO_PCI_CORE
> +	help
> +	  VFIO support for the GPU in the NVIDIA Grace Hopper Superchip is
> +	  required to assign the GPU device using KVM/qemu/etc.
> +
> +	  If you don't know what to do here, say N.
> diff --git a/drivers/vfio/pci/nvgrace-gpu/Makefile b/drivers/vfio/pci/nvgrace-gpu/Makefile
> new file mode 100644
> index 000000000000..3ca8c187897a
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgrace-gpu/Makefile
> @@ -0,0 +1,3 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu-vfio-pci.o
> +nvgrace-gpu-vfio-pci-y := main.o
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> new file mode 100644
> index 000000000000..43387a800c41
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -0,0 +1,806 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> + */
> +
> +#include "nvgrace_gpu_vfio_pci.h"


This file doesn't exist.

> +
> +static bool nvgrace_gpu_vfio_pci_is_fake_bar(int index)
> +{
> +	return (index == RESMEM_REGION_INDEX ||
> +	    index == USEMEM_REGION_INDEX);
> +}
> +
> +static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> +		core_device.vdev);
> +
> +	nvdev->resmem.u64_reg = 0;
> +	nvdev->usemem.u64_reg = 0;
> +}
> +
> +/* Choose the structure corresponding to the fake BAR with a given index. */
> +struct mem_region *
> +nvgrace_gpu_vfio_pci_fake_bar_mem_region(int index,
> +			struct nvgrace_gpu_vfio_pci_core_device *nvdev)
> +{
> +	if (index == USEMEM_REGION_INDEX)
> +		return &(nvdev->usemem);
> +
> +	if (index == RESMEM_REGION_INDEX)
> +		return &(nvdev->resmem);
> +
> +	return NULL;
> +}
> +
> +static int nvgrace_gpu_vfio_pci_open_device(struct vfio_device *core_vdev)
> +{
> +	struct vfio_pci_core_device *vdev =
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> +		core_device.vdev);
> +	int ret;
> +
> +	ret = vfio_pci_core_enable(vdev);
> +	if (ret)
> +		return ret;
> +
> +	vfio_pci_core_finish_enable(vdev);
> +
> +	nvgrace_gpu_init_fake_bar_emu_regs(core_vdev);
> +
> +	mutex_init(&nvdev->remap_lock);
> +
> +	return 0;
> +}
> +
> +static void nvgrace_gpu_vfio_pci_close_device(struct vfio_device *core_vdev)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> +		core_device.vdev);
> +
> +	/* Unmap the mapping to the device memory cached region */
> +	if (nvdev->usemem.bar_remap.memaddr) {
> +		memunmap(nvdev->usemem.bar_remap.memaddr);
> +		nvdev->usemem.bar_remap.memaddr = NULL;
> +	}
> +
> +	/* Unmap the mapping to the device memory non-cached region */
> +	if (nvdev->resmem.bar_remap.ioaddr) {
> +		iounmap(nvdev->resmem.bar_remap.ioaddr);
> +		nvdev->resmem.bar_remap.ioaddr = NULL;
> +	}
> +
> +	mutex_destroy(&nvdev->remap_lock);
> +
> +	vfio_pci_core_close_device(core_vdev);
> +}
> +
> +static int nvgrace_gpu_vfio_pci_mmap(struct vfio_device *core_vdev,
> +				     struct vm_area_struct *vma)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
> +
> +	unsigned long start_pfn;
> +	unsigned int index;
> +	u64 req_len, pgoff, end;
> +	int ret = 0;
> +	struct mem_region *memregion;
> +
> +	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> +
> +	memregion = nvgrace_gpu_vfio_pci_fake_bar_mem_region(index, nvdev);
> +	if (!memregion)
> +		return vfio_pci_core_mmap(core_vdev, vma);
> +
> +	/*
> +	 * Request to mmap the BAR. Map to the CPU accessible memory on the
> +	 * GPU using the memory information gathered from the system ACPI
> +	 * tables.
> +	 */
> +	pgoff = vma->vm_pgoff &
> +		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +
> +	if (check_sub_overflow(vma->vm_end, vma->vm_start, &req_len) ||
> +		check_add_overflow(PHYS_PFN(memregion->memphys), pgoff, &start_pfn) ||
> +		check_add_overflow(PFN_PHYS(pgoff), req_len, &end))
> +		return -EOVERFLOW;
> +
> +	/*
> +	 * Check that the mapping request does not go beyond available device
> +	 * memory size
> +	 */
> +	if (end > memregion->memlength)
> +		return -EINVAL;
> +
> +	/*
> +	 * The carved out region of the device memory needs the NORMAL_NC
> +	 * property. Communicate as such to the hypervisor.
> +	 */
> +	if (index == RESMEM_REGION_INDEX)
> +		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
> +
> +	/*
> +	 * Perform a PFN map to the memory and back the device BAR by the
> +	 * GPU memory.
> +	 *
> +	 * The available GPU memory size may not be power-of-2 aligned. Map up
> +	 * to the size of the device memory. If the memory access is beyond the
> +	 * actual GPU memory size, it will be handled by the vfio_device_ops
> +	 * read/write.
> +	 *
> +	 * During device reset, the GPU is safely disconnected to the CPU
> +	 * and access to the BAR will be immediately returned preventing
> +	 * machine check.
> +	 */
> +	ret = remap_pfn_range(vma, vma->vm_start, start_pfn,
> +			      req_len, vma->vm_page_prot);
> +	if (ret)
> +		return ret;
> +
> +	vma->vm_pgoff = start_pfn;
> +
> +	return 0;
> +}
> +
> +static long
> +nvgrace_gpu_vfio_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
> +					    unsigned long arg)
> +{
> +	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
> +	struct vfio_region_info_cap_sparse_mmap *sparse;
> +	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
> +	struct vfio_region_info info;
> +	struct mem_region *memregion;
> +	uint32_t size;
> +	int ret;
> +
> +	if (copy_from_user(&info, (void __user *)arg, minsz))
> +		return -EFAULT;
> +
> +	if (info.argsz < minsz)
> +		return -EINVAL;
> +
> +	memregion = nvgrace_gpu_vfio_pci_fake_bar_mem_region(info.index, nvdev);
> +	if (!memregion)
> +		return vfio_pci_core_ioctl(core_vdev,
> +					   VFIO_DEVICE_GET_REGION_INFO, arg);
> +
> +	/*
> +	 * Request to determine the BAR region information. Send the
> +	 * GPU memory information.
> +	 */
> +	size = struct_size(sparse, areas, 1);
> +
> +	/*
> +	 * Setup for sparse mapping for the device memory. Only the
> +	 * available device memory on the hardware is shown as a
> +	 * mappable region.
> +	 */
> +	sparse = kzalloc(size, GFP_KERNEL);
> +	if (!sparse)
> +		return -ENOMEM;
> +
> +	sparse->nr_areas = 1;
> +	sparse->areas[0].offset = 0;
> +	sparse->areas[0].size = memregion->memlength;
> +	sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
> +	sparse->header.version = 1;
> +
> +	ret = vfio_info_add_capability(&caps, &sparse->header, size);
> +	kfree(sparse);
> +	if (ret)
> +		return ret;
> +
> +	info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> +	/*
> +	 * The region memory size may not be power-of-2 aligned.
> +	 * Given that the memory  as a BAR and may not be
> +	 * aligned, roundup to the next power-of-2.
> +	 */
> +	info.size = roundup_pow_of_two(memregion->memlength);
> +	info.flags = VFIO_REGION_INFO_FLAG_READ |
> +		VFIO_REGION_INFO_FLAG_WRITE |
> +		VFIO_REGION_INFO_FLAG_MMAP;
> +
> +	if (caps.size) {
> +		info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
> +		if (info.argsz < sizeof(info) + caps.size) {
> +			info.argsz = sizeof(info) + caps.size;
> +			info.cap_offset = 0;
> +		} else {
> +			vfio_info_cap_shift(&caps, sizeof(info));
> +			if (copy_to_user((void __user *)arg +
> +					 sizeof(info), caps.buf,
> +					 caps.size)) {
> +				kfree(caps.buf);
> +				return -EFAULT;
> +			}
> +			info.cap_offset = sizeof(info);
> +		}
> +		kfree(caps.buf);
> +	}
> +	return copy_to_user((void __user *)arg, &info, minsz) ?
> +			    -EFAULT : 0;
> +}
> +
> +static long nvgrace_gpu_vfio_pci_ioctl(struct vfio_device *core_vdev,
> +					unsigned int cmd, unsigned long arg)
> +{
> +	switch (cmd) {
> +	case VFIO_DEVICE_GET_REGION_INFO:
> +		return nvgrace_gpu_vfio_pci_ioctl_get_region_info(core_vdev, arg);
> +	case VFIO_DEVICE_IOEVENTFD:
> +		return -ENOTTY;
> +	case VFIO_DEVICE_RESET:
> +		nvgrace_gpu_init_fake_bar_emu_regs(core_vdev);
> +		fallthrough;
> +	default:
> +		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> +	}
> +}
> +
> +static bool range_intersect_range(loff_t range1_start, size_t count1,
> +				  loff_t range2_start, size_t count2,
> +				  loff_t *start_offset,
> +				  size_t *intersect_count,
> +				  size_t *register_offset)
> +{
> +	if (range1_start <= range2_start &&
> +	    range1_start + count1 > range2_start) {
> +		*start_offset = range2_start - range1_start;
> +		*intersect_count = min_t(size_t, count2,
> +					 range1_start + count1 - range2_start);
> +		*register_offset = 0;
> +		return true;
> +	}
> +
> +	if (range1_start > range2_start &&
> +	    range1_start < range2_start + count2) {
> +		*start_offset = 0;
> +		*intersect_count = min_t(size_t, count1,
> +					 range2_start + count2 - range1_start);
> +		*register_offset = range1_start - range2_start;
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Both the usable (usemem) and the reserved (resmem) device memory region
> + * are exposed as a 64b fake BARs in the VM. These fake BARs must respond
> + * to the accesses on their respective PCI config space offsets.
> + *
> + * resmem BAR owns PCI_BASE_ADDRESS_2 & PCI_BASE_ADDRESS_3.
> + * usemem BAR owns PCI_BASE_ADDRESS_4 & PCI_BASE_ADDRESS_5.
> + */
> +static ssize_t
> +nvgrace_gpu_read_config_emu(struct vfio_device *core_vdev,
> +			     char __user *buf, size_t count, loff_t *ppos)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
> +	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	__le64 val64;
> +	size_t bar_size;
> +	size_t register_offset;
> +	loff_t copy_offset;
> +	size_t copy_count;
> +	int ret;
> +
> +	ret = vfio_pci_core_read(core_vdev, buf, count, ppos);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_2, sizeof(val64),
> +				  &copy_offset, &copy_count, &register_offset)) {
> +		bar_size = roundup_pow_of_two(nvdev->resmem.memlength);
> +		nvdev->resmem.u64_reg &= ~(bar_size - 1);
> +		nvdev->resmem.u64_reg |= PCI_BASE_ADDRESS_MEM_TYPE_64 |
> +					 PCI_BASE_ADDRESS_MEM_PREFETCH;
> +		val64 = cpu_to_le64(nvdev->resmem.u64_reg);
> +		if (copy_to_user(buf + copy_offset, (void *)&val64 + register_offset, copy_count))
> +			return -EFAULT;
> +	}
> +
> +	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_4, sizeof(val64),
> +				  &copy_offset, &copy_count, &register_offset)) {
> +		bar_size = roundup_pow_of_two(nvdev->usemem.memlength);
> +		nvdev->usemem.u64_reg &= ~(bar_size - 1);
> +		nvdev->usemem.u64_reg |= PCI_BASE_ADDRESS_MEM_TYPE_64 |
> +					 PCI_BASE_ADDRESS_MEM_PREFETCH;
> +		val64 = cpu_to_le64(nvdev->usemem.u64_reg);
> +		if (copy_to_user(buf + copy_offset, (void *)&val64 + register_offset, copy_count))
> +			return -EFAULT;
> +	}
> +
> +	return count;
> +}
> +
> +static ssize_t
> +nvgrace_gpu_write_config_emu(struct vfio_device *core_vdev,
> +			      const char __user *buf, size_t count, loff_t *ppos)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
> +	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	__le64 val64 = 0;
> +	__le16 val16 = 0;
> +	u64 tmp_val;
> +	size_t register_offset;
> +	loff_t copy_offset;
> +	size_t copy_count;
> +
> +	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_2, sizeof(val64),
> +				  &copy_offset, &copy_count, &register_offset)) {
> +		if (copy_from_user((void *)&val64, buf + copy_offset, copy_count))
> +			return -EFAULT;
> +		tmp_val = le64_to_cpu(val64);
> +		memcpy((void *)&(nvdev->resmem.u64_reg) + register_offset,
> +			(void *)&tmp_val + copy_offset, copy_count);
> +		*ppos += copy_count;
> +		return copy_count;
> +	}
> +
> +	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_4, sizeof(val64),
> +				  &copy_offset, &copy_count, &register_offset)) {
> +		if (copy_from_user((void *)&val64, buf + copy_offset, copy_count))
> +			return -EFAULT;
> +		tmp_val = le64_to_cpu(val64);
> +		memcpy((void *)&(nvdev->usemem.u64_reg) + register_offset,
> +			(void *)&tmp_val + copy_offset, copy_count);
> +		*ppos += copy_count;
> +		return copy_count;
> +	}
> +
> +	if (range_intersect_range(pos, count, PCI_COMMAND, sizeof(val16),
> +				  &copy_offset, &copy_count, &register_offset)) {
> +		if (copy_from_user((void *)&val16, buf + copy_offset, copy_count))
> +			return -EFAULT;
> +
> +		if (le16_to_cpu(val16) & PCI_COMMAND_MEMORY)
> +			nvdev->bars_disabled = false;
> +		else
> +			nvdev->bars_disabled = true;
> +	}
> +
> +	return vfio_pci_core_write(core_vdev, buf, count, ppos);
> +}
> +
> +/*
> + * Ad hoc map the device memory in the module kernel VA space. Primarily needed
> + * to support Qemu's device x-no-mmap=on option.
> + *
> + * The usemem region is cacheable memory and hence is memremaped.
> + * The resmem region is non-cached and is mapped using ioremap_wc (NORMAL_NC).
> + */
> +static int
> +nvgrace_gpu_map_device_mem(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
> +			    int index)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&nvdev->remap_lock);
> +	if (index == USEMEM_REGION_INDEX &&
> +		!nvdev->usemem.bar_remap.memaddr) {
> +		nvdev->usemem.bar_remap.memaddr
> +			= memremap(nvdev->usemem.memphys, nvdev->usemem.memlength, MEMREMAP_WB);
> +		if (!nvdev->usemem.bar_remap.memaddr)
> +			ret = -ENOMEM;
> +	} else if (index == RESMEM_REGION_INDEX &&
> +		!nvdev->resmem.bar_remap.ioaddr) {
> +		nvdev->resmem.bar_remap.ioaddr
> +			= ioremap_wc(nvdev->resmem.memphys, nvdev->resmem.memlength);
> +		if (!nvdev->resmem.bar_remap.ioaddr)
> +			ret = -ENOMEM;
> +	}
> +	mutex_unlock(&nvdev->remap_lock);
> +
> +	return ret;
> +}
> +
> +/*
> + * Read the data from the device memory (mapped either through ioremap
> + * or memremap) into the user buffer.
> + */
> +static int
> +nvgrace_gpu_map_and_read(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
> +		void __user *buf, size_t mem_count, loff_t *ppos)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
> +	int ret = 0;
> +
> +	/*
> +	 * Handle read on the BAR regions. Map to the target device memory
> +	 * physical address and copy to the request read buffer.
> +	 */
> +	ret = nvgrace_gpu_map_device_mem(nvdev, index);
> +	if (ret)
> +		goto read_exit;
> +
> +	if (index == USEMEM_REGION_INDEX) {
> +		if (copy_to_user(buf, (u8 *)nvdev->usemem.bar_remap.memaddr + offset, mem_count))
> +			ret = -EFAULT;
> +	} else {
> +		return do_io_rw(&nvdev->core_device, false, nvdev->resmem.bar_remap.ioaddr,
> +				(char __user *) buf, offset, mem_count, 0, 0, false);
> +	}
> +
> +read_exit:
> +	return ret;
> +}
> +
> +/*
> + * Read count bytes from the device memory at an offset. The actual device
> + * memory size (available) may not be a power-of-2. So the driver fakes
> + * the size to a power-of-2 (reported) when exposing to a user space driver.
> + *
> + * Read request beyond the actual device size is filled with ~0, while
> + * those beyond the actual reported size is skipped.
> + *
> + * A read from a negative or an offset greater than reported size, a negative
> + * count are considered error conditions and returned with an -EINVAL.
> + */
> +static ssize_t
> +nvgrace_gpu_read_mem(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
> +		      void __user *buf, size_t count, loff_t *ppos)
> +{
> +	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	struct mem_region *memregion;
> +	size_t mem_count, i, bar_size;
> +	u8 val = 0xFF;
> +	int ret;
> +
> +	memregion = nvgrace_gpu_vfio_pci_fake_bar_mem_region(index, nvdev);
> +	if (!memregion)
> +		return -EINVAL;
> +
> +	bar_size = roundup_pow_of_two(memregion->memlength);
> +
> +	if (offset >= bar_size)
> +		return -EINVAL;
> +
> +	/* Clip short the read request beyond reported BAR size */
> +	count = min(count, bar_size - (size_t)offset);
> +
> +	/*
> +	 * Determine how many bytes to be actually read from the device memory.
> +	 * Read request beyond the actual device memory size is filled with ~0,
> +	 * while those beyond the actual reported size is skipped.
> +	 */
> +	if (offset >= memregion->memlength)
> +		mem_count = 0;
> +	else
> +		mem_count = min(count, memregion->memlength - (size_t)offset);
> +
> +	ret = nvgrace_gpu_map_and_read(nvdev, buf, mem_count, ppos);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Only the device memory present on the hardware is mapped, which may
> +	 * not be power-of-2 aligned. A read to an offset beyond the device memory
> +	 * size is filled with ~0.
> +	 */
> +	for (i = mem_count; i < count; i++)
> +		put_user(val, (unsigned char __user *)(buf + i));
> +
> +	*ppos += count;
> +	return count;
> +}
> +
> +static ssize_t
> +nvgrace_gpu_vfio_pci_read(struct vfio_device *core_vdev,
> +			   char __user *buf, size_t count, loff_t *ppos)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	ssize_t read_count;
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> +		core_device.vdev);
> +
> +	if (nvgrace_gpu_vfio_pci_is_fake_bar(index)) {
> +		/* Check if the bars are disabled, allow access otherwise */
> +		down_read(&nvdev->core_device.memory_lock);
> +		if (nvdev->bars_disabled) {
> +			up_read(&nvdev->core_device.memory_lock);
> +			return -EIO;
> +		}
> +		read_count = nvgrace_gpu_read_mem(nvdev, buf, count, ppos);
> +		up_read(&nvdev->core_device.memory_lock);
> +
> +		return read_count;
> +	}
> +
> +	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
> +		return nvgrace_gpu_read_config_emu(core_vdev, buf, count, ppos);
> +
> +	return vfio_pci_core_read(core_vdev, buf, count, ppos);
> +}
> +
> +/*
> + * Write the data to the device memory (mapped either through ioremap
> + * or memremap) from the user buffer.
> + */
> +static int nvgrace_gpu_map_and_write(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
> +		const void __user *buf, size_t mem_count, loff_t *ppos)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	int ret = 0;
> +
> +	ret = nvgrace_gpu_map_device_mem(nvdev, index);
> +	if (ret)
> +		goto write_exit;
> +
> +	if (index == USEMEM_REGION_INDEX) {
> +		if (copy_from_user((u8 *)nvdev->usemem.bar_remap.memaddr + pos,
> +				   buf, mem_count))
> +			return -EFAULT;
> +	} else {
> +		return do_io_rw(&nvdev->core_device, false, nvdev->resmem.bar_remap.ioaddr,
> +				(char __user *) buf, pos, mem_count, 0, 0, true);
> +	}
> +
> +write_exit:
> +	return ret;
> +}
> +
> +/*
> + * Write count bytes to the device memory at a given offset. The actual device
> + * memory size (available) may not be a power-of-2. So the driver fakes the
> + * size to a power-of-2 (reported) when exposing to a user space driver.
> + *
> + * Write request beyond the actual device size are dropped, while those
> + * beyond the actual reported size are skipped entirely.
> + *
> + * A write to a negative or an offset greater than the reported size, a
> + * negative count are considered error conditions and returned with an -EINVAL.
> + */
> +static ssize_t
> +nvgrace_gpu_write_mem(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
> +			size_t count, loff_t *ppos, const void __user *buf)
> +{
> +	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	struct mem_region *memregion;
> +	size_t mem_count, bar_size;
> +	int ret = 0;
> +
> +	memregion = nvgrace_gpu_vfio_pci_fake_bar_mem_region(index, nvdev);
> +	if (!memregion)
> +		return -EINVAL;
> +
> +	bar_size = roundup_pow_of_two(memregion->memlength);
> +
> +	if (offset >= bar_size)
> +		return -EINVAL;
> +
> +	/* Clip short the write request beyond reported BAR size */
> +	count = min(count, bar_size - (size_t)offset);
> +
> +	/*
> +	 * Determine how many bytes to be actually written to the device memory.
> +	 * Do not write to the offset beyond available size.
> +	 */
> +	if (offset >= memregion->memlength)
> +		goto exitfn;
> +
> +	/*
> +	 * Only the device memory present on the hardware is mapped, which may
> +	 * not be power-of-2 aligned. Drop access outside the available device
> +	 * memory on the hardware.
> +	 */
> +	mem_count = min(count, memregion->memlength - (size_t)offset);
> +
> +	ret = nvgrace_gpu_map_and_write(nvdev, buf, mem_count, ppos);
> +	if (ret)
> +		return ret;
> +
> +exitfn:
> +	*ppos += count;
> +	return count;
> +}
> +
> +static ssize_t
> +nvgrace_gpu_vfio_pci_write(struct vfio_device *core_vdev,
> +			    const char __user *buf, size_t count, loff_t *ppos)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
> +	size_t write_count;
> +
> +	if (nvgrace_gpu_vfio_pci_is_fake_bar(index)) {
> +		/* Check if the bars are disabled, allow access otherwise */
> +		down_read(&nvdev->core_device.memory_lock);
> +		if (nvdev->bars_disabled) {
> +			up_read(&nvdev->core_device.memory_lock);
> +			return -EIO;
> +		}
> +		write_count = nvgrace_gpu_write_mem(nvdev, count, ppos, buf);
> +		up_read(&nvdev->core_device.memory_lock);
> +		return write_count;
> +	}
> +
> +	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
> +		return nvgrace_gpu_write_config_emu(core_vdev, buf, count, ppos);
> +
> +	return vfio_pci_core_write(core_vdev, buf, count, ppos);
> +}
> +
> +static const struct vfio_device_ops nvgrace_gpu_vfio_pci_ops = {
> +	.name = "nvgrace-gpu-vfio-pci",
> +	.init = vfio_pci_core_init_dev,
> +	.release = vfio_pci_core_release_dev,
> +	.open_device = nvgrace_gpu_vfio_pci_open_device,
> +	.close_device = nvgrace_gpu_vfio_pci_close_device,
> +	.ioctl = nvgrace_gpu_vfio_pci_ioctl,
> +	.read = nvgrace_gpu_vfio_pci_read,
> +	.write = nvgrace_gpu_vfio_pci_write,
> +	.mmap = nvgrace_gpu_vfio_pci_mmap,
> +	.request = vfio_pci_core_request,
> +	.match = vfio_pci_core_match,
> +	.bind_iommufd = vfio_iommufd_physical_bind,
> +	.unbind_iommufd = vfio_iommufd_physical_unbind,
> +	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> +	.detach_ioas = vfio_iommufd_physical_detach_ioas,
> +};
> +
> +static struct
> +nvgrace_gpu_vfio_pci_core_device *nvgrace_gpu_drvdata(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
> +
> +	return container_of(core_device, struct nvgrace_gpu_vfio_pci_core_device,
> +			    core_device);
> +}
> +
> +static int
> +nvgrace_gpu_vfio_pci_fetch_memory_property(struct pci_dev *pdev,
> +					    struct nvgrace_gpu_vfio_pci_core_device *nvdev)
> +{
> +	int ret;
> +	u64 memphys, memlength;
> +
> +	/*
> +	 * The memory information is present in the system ACPI tables as DSD
> +	 * properties nvidia,gpu-mem-base-pa and nvidia,gpu-mem-size.
> +	 */
> +	ret = device_property_read_u64(&pdev->dev, "nvidia,gpu-mem-base-pa",
> +				       &(memphys));
> +	if (ret)
> +		return ret;
> +
> +	if (memphys > type_max(phys_addr_t))
> +		return -EOVERFLOW;
> +
> +	ret = device_property_read_u64(&pdev->dev, "nvidia,gpu-mem-size",
> +				       &(memlength));
> +	if (ret)
> +		return ret;
> +
> +	if (memlength > type_max(size_t))
> +		return -EOVERFLOW;
> +
> +	/*
> +	 * If the C2C link is not up due to an error, the coherent device
> +	 * memory size is returned as 0. Fail in such case.
> +	 */
> +	if (memlength == 0)
> +		return -ENOMEM;
> +
> +	/*
> +	 * The VM GPU device driver needs a non-cacheable region to support
> +	 * the MIG feature. Since the device memory is mapped as NORMAL cached,
> +	 * carve out a region from the end with a different NORMAL_NC
> +	 * property (called as reserved memory and represented as resmem). This
> +	 * region then is exposed as a 64b BAR (region 2 and 3) to the VM, while
> +	 * exposing the rest (termed as usable memory and represented using usemem)
> +	 * as cacheable 64b BAR (region 4 and 5).
> +	 *
> +	 *               devmem (memlength)
> +	 * |-------------------------------------------------|
> +	 * |                                           |
> +	 * usemem.phys/memphys                         resmem.phys
> +	 */
> +	nvdev->usemem.memphys = memphys;
> +
> +	/*
> +	 * The device memory exposed to the VM is added to the kernel by the
> +	 * VM driver module in chunks of memory block size. Only the usable
> +	 * memory (usemem) is added to the kernel for usage by the VM
> +	 * workloads. Make the usable memory size memblock aligned.
> +	 */
> +	if (check_sub_overflow(memlength, RESMEM_SIZE,
> +			       &nvdev->usemem.memlength)) {
> +		ret = -EOVERFLOW;
> +		goto done;
> +	}
> +	nvdev->usemem.memlength = round_down(nvdev->usemem.memlength,
> +					     MEMBLK_SIZE);
> +	if ((check_add_overflow(nvdev->usemem.memphys,
> +	     nvdev->usemem.memlength, &nvdev->resmem.memphys)) ||
> +	    (check_sub_overflow(memlength, nvdev->usemem.memlength,
> +	     &nvdev->resmem.memlength))) {
> +		ret = -EOVERFLOW;
> +		goto done;
> +	}
> +
> +done:
> +	return ret;
> +}
> +
> +static int nvgrace_gpu_vfio_pci_probe(struct pci_dev *pdev,
> +				       const struct pci_device_id *id)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev;
> +	int ret;
> +
> +	nvdev = vfio_alloc_device(nvgrace_gpu_vfio_pci_core_device, core_device.vdev,
> +				  &pdev->dev, &nvgrace_gpu_vfio_pci_ops);
> +	if (IS_ERR(nvdev))
> +		return PTR_ERR(nvdev);
> +
> +	dev_set_drvdata(&pdev->dev, nvdev);
> +
> +	ret = nvgrace_gpu_vfio_pci_fetch_memory_property(pdev, nvdev);
> +	if (ret)
> +		goto out_put_vdev;
> +
> +	ret = vfio_pci_core_register_device(&nvdev->core_device);
> +	if (ret)
> +		goto out_put_vdev;
> +
> +	return ret;
> +
> +out_put_vdev:
> +	vfio_put_device(&nvdev->core_device.vdev);
> +	return ret;
> +}
> +
> +static void nvgrace_gpu_vfio_pci_remove(struct pci_dev *pdev)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = nvgrace_gpu_drvdata(pdev);
> +	struct vfio_pci_core_device *vdev = &nvdev->core_device;
> +
> +	vfio_pci_core_unregister_device(vdev);
> +	vfio_put_device(&vdev->vdev);
> +}
> +
> +static const struct pci_device_id nvgrace_gpu_vfio_pci_table[] = {
> +	/* GH200 120GB */
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2342) },
> +	/* GH200 480GB */
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2345) },
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(pci, nvgrace_gpu_vfio_pci_table);
> +
> +static struct pci_driver nvgrace_gpu_vfio_pci_driver = {
> +	.name = KBUILD_MODNAME,
> +	.id_table = nvgrace_gpu_vfio_pci_table,
> +	.probe = nvgrace_gpu_vfio_pci_probe,
> +	.remove = nvgrace_gpu_vfio_pci_remove,
> +	.err_handler = &vfio_pci_core_err_handlers,
> +	.driver_managed_dma = true,
> +};
> +
> +module_pci_driver(nvgrace_gpu_vfio_pci_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Ankit Agrawal <ankita@nvidia.com>");
> +MODULE_AUTHOR("Aniket Agashe <aniketa@nvidia.com>");
> +MODULE_DESCRIPTION(
> +	"VFIO NVGRACE GPU PF - User Level driver for NVIDIA devices with CPU coherently accessible device memory");
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index e27de61ac9fe..ca20440b442d 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -94,10 +94,10 @@ VFIO_IOREAD(32)
>    * reads with -1.  This is intended for handling MSI-X vector tables and
>    * leftover space for ROM BARs.
>    */
> -static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
> -			void __iomem *io, char __user *buf,
> -			loff_t off, size_t count, size_t x_start,
> -			size_t x_end, bool iswrite)
> +ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
> +		  void __iomem *io, char __user *buf,
> +		  loff_t off, size_t count, size_t x_start,
> +		  size_t x_end, bool iswrite)
>   {
>   	ssize_t done = 0;
>   	int ret;
> @@ -199,6 +199,7 @@ static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
>   
>   	return done;
>   }
> +EXPORT_SYMBOL(do_io_rw);

You should rename this routime with a vfio_ prefix and include its
declaration in include/linux/vfio_pci_core.h. I suppose we want
it to be GPL, right ?

See https://lore.kernel.org/all/20231218083755.96281-9-yishaih@nvidia.com/

Thanks,

C.



>   
>   static int vfio_pci_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
>   {


