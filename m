Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E472E7043E1
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 05:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjEPDNM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 23:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjEPDNB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 23:13:01 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C8165B2
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 20:13:00 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id 6a1803df08f44-61aecee26feso61795966d6.2
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 20:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684206779; x=1686798779;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RllGWZ4DaU1HnlvuJFnMhFPh8NZt7oPNf60Dp85Uygs=;
        b=KRB8Dugc/4arKm55u1U1HMU9yLQwqZlq3mMM9q6zbfmnnzJpSQHVEnkDy6oTNXQ77E
         2avWMKLy/XFTuIvCvPoO9VNK+SAhu/ML6sE57C9kd3F4felE7u6TazmLSM9PCugeM/jZ
         HOdoTAiTxMzCNnRi7z3zYfZyPz3xpovnvPUPsqXTH/Jfy1Oyq6XVrywssreeM/jjsF1s
         hOIuFV+hNbw9jpPjpVWZntmuQVe+C3IRoH/Nt8WqrGdDsX1GATs1p3lk7vqGKqipStZG
         3reKUfvcDX8VFKywt3uIhG6PR3J38TiEB6GCz17mYUbkeKv6EWHxhnuhE5Hx7TSdtycl
         3E9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684206779; x=1686798779;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RllGWZ4DaU1HnlvuJFnMhFPh8NZt7oPNf60Dp85Uygs=;
        b=ISrXDCysprxgBNEMgAdjeYt9SZFxxmHCHX6bLiW5HZk4eMdhY/HiLhleLgD4cpnyBd
         kV681h3EsFBfJg/hcpnbS/5RwnPl8OvVtpDf8EyHufo3k0l6blT7af7fftdtpqSJaBEu
         KzVc9JX4SrVDTsho9TFsP7PAw38pWfhAK4HzgwxssHn0QeuCmuXHIu/6ffuNOEnYERDS
         4AoZD/rnIjBWn89X6iCeWkDznnrINnqCrJwCG4OO7ySSewf8ptACQ/HEpTHrk2dCm+3S
         mYH+f/9UoUaXszBAkznNyoOI1e2np3+unxFDYxRhyXCV+46Q5QOhlWyxhp8AYUSMohhJ
         NVgg==
X-Gm-Message-State: AC+VfDyFmLkvY0xCYocAOM0M7M13D/JuDkYWmXkuSLrf4hq2NIGIQkfC
        7QGPL+ILzzCTwHp+x1hj7ATBmJgVPhIDVPulUcvqlw==
X-Google-Smtp-Source: ACHHUZ6BDSWA0d0LCkYI84mfMecurWgNaLJ2UFz/UFNSQeduQ872yGnRDB920D9EnWjeo8DWGm0n6D5z6dC7XNCXcgU=
X-Received: by 2002:a05:6214:e46:b0:621:2641:c656 with SMTP id
 o6-20020a0562140e4600b006212641c656mr39757641qvc.31.1684206779197; Mon, 15
 May 2023 20:12:59 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1683688960.git.nicolinc@nvidia.com> <CABQgh9FL4ssQjBJM52_kb0aBVVPb_9Wc0Q+NL1PaQO=2LYBHCA@mail.gmail.com>
 <ZGJWgFVJDWxVpiBE@Asurada-Nvidia>
In-Reply-To: <ZGJWgFVJDWxVpiBE@Asurada-Nvidia>
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
Date:   Tue, 16 May 2023 11:12:44 +0800
Message-ID: <CABQgh9FMGPnUpz6tc6c27i6nT0Lcs9YQMoO=V40Fi2inJiCh-A@mail.gmail.com>
Subject: Re: [PATCH v2 00/17] Add Nested Translation Support for SMMUv3
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     jgg@nvidia.com, robin.murphy@arm.com, will@kernel.org,
        eric.auger@redhat.com, kevin.tian@intel.com,
        baolu.lu@linux.intel.com, joro@8bytes.org,
        shameerali.kolothum.thodi@huawei.com, jean-philippe@linaro.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        alex.williamson@redhat.com, yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 15 May 2023 at 23:58, Nicolin Chen <nicolinc@nvidia.com> wrote:
>
> Hi Zhangfei,
>
> On Mon, May 15, 2023 at 06:00:26PM +0800, Zhangfei Gao wrote:
>
> > I rebased on these two branches and did some basic tests.
> >
> > The basic functions work after backport
> > iommufd: Add IOMMU_PAGE_RESPONSE
> > iommufd: Add device fault handler support
> >
> > https://github.com/Linaro/linux-kernel-warpdrive/tree/uacce-devel-6.4
> > https://github.com/Linaro/qemu/tree/iommufd-6.4-nesting-smmuv3-v2
>
> Thanks for testing!
>
> > However when debugging hotplug PCI device, it still does not work,
> > Segmentation fault same as 6.2.
> >
> > guest kernel
> > CONFIG_HOTPLUG_PCI_PCIE=y
> >
> > boot guest (this info does not appear in 6.2)
> > qemu-system-aarch64: -device
> > vfio-pci,host=0000:76:00.1,bus=pci.1,addr=0x0,id=acc1,iommufd=iommufd0:
> > Failed to set data -1
> > qemu-system-aarch64: -device
> > vfio-pci,host=0000:76:00.1,bus=pci.1,addr=0x0,id=acc1,iommufd=iommufd0:
> > failed to set device data
>
> Hmm.. I wonder what fails the set_dev_data ioctl...
Simply debug, it is because dev_data.sid=0, causing
arm_smmu_set_dev_user_data fail

hw/arm/smmu-common.c
smmu_dev_set_iommu_device
.sid = smmu_get_sid(sdev)
smmu_dev_set_iommu_device dev_data.sid=0

drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
arm_smmu_set_dev_user_data
u32 sid_user = user->sid;
if (!sid_user) return -EINVAL;

>
> > $ sudo nc -U /tmp/qmpm_1.socket
> > (qemu) info pci
> > (qemu) device_del acc1
> >
> > guest:
> > qemu-system-aarch64: IOMMU_IOAS_UNMAP failed: No such file or directory
> > qemu-system-aarch64: vfio_container_dma_unmap(0xaaaae1fc0380,
> > 0x8000000000, 0x10000) = -2 (No such file or directory)
>
From ex-email reply
(Eric) In qemu arm virt machine 0x8000000000 matches the PCI MMIO region.
(Yi) Currently, iommufd kernel part doesn't support mapping device BAR MMIO.
This is a known gap.

> This is resulted from the following commit that we should
> drop later:
>
> commit c4fd2efd7c02dd30491adf676c1b0aed67656f36
> Author: Yi Liu <yi.l.liu@intel.com>
> Date:   Thu Apr 27 05:47:03 2023 -0700
>
>     vfio/container: Skip readonly pages
>
>     This is a temparary solution for Intel platform due to an errata in
>     which readonly pages in second stage page table is exclusive with
>     nested support.
>
>     Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>
>
> > qemu-system-aarch64: Failed to unset data -1
> > Segmentation fault (core dumped).  // also happened in 6.2
>
> Hmm, would it be possible for you to run the test again by
> adding the following tracers to your QEMU command?
>     --trace "iommufd*" \
>     --trace "smmu*" \
>     --trace "vfio_*" \
>     --trace "pci_*"
>

Have sent you the log directly, since it is too big.

Thanks
