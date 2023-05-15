Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 722FD7029D4
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 12:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240832AbjEOKBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 06:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240521AbjEOKAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 06:00:39 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165771723
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 03:00:38 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id 6a1803df08f44-61a9bb1b3a0so58922256d6.1
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 03:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684144837; x=1686736837;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SmOMWPo18vGFDtTuraejpVVU9tOcfMjTbcnb/sRrPI8=;
        b=IZeLFC15oPqxEGdYJHzx4HmxTfBqxd8j+LKyVXLZn5EORmXMF23ESuLRHbhr53Pdgc
         +749Y8OWBrXIGmxIYIdQgxJxv50F1QtQojUg/2sJpaV6pKUCsTiKiN2Os6OYE73LPR0a
         4Qa5M1pOmLKLjwdk9g2KY63Y3/aGdi0nCFVuH9UFxK8lrpD8WPDTYx+9Bmjr55Pi7n/n
         XWGnV71Vdx/pzv9mHgTPDCnu69IFDvoX5H7Ks0140HsLmaVv7hojjwBSkvKsbDjmUbFL
         QY/62CMl1SNf4v3I+/E++w4hJ3YHu2OtpMcEg1V4MIAcyyhEuyMrG1hyq7JPUvO1Dci/
         nd/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684144837; x=1686736837;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SmOMWPo18vGFDtTuraejpVVU9tOcfMjTbcnb/sRrPI8=;
        b=K/hjyocuXxUTdyfKQ9G5in8hGRi7wfZZDFx4tLIkXRVxx1wL69JI5cLy7pzQHcSBxm
         ACKy/eBp+lZwDRYIZGDXtjDDXgPP6/HR9GmDkO9JhN0hk+xy37Aeuvb4wm/kxKUGpuUd
         OREIE1tRzgSbWJxJg8LMO8b8ISJIiUBeK5nhliHDVPNZyK8FXaouJHcKePpVLWU4WL5O
         EWWeiKNUTXRbCCV+rspL7ez598vFzg/c6EkYeLMZu7IL3M2b+cqQrOj2fTrmBhYR85YO
         rdgOUomDK66IlD3DfZ4vJMSaxYHjyGDC5CceSXhQp6zYxs8SRtZr0CQNi72h8+DaV29g
         3iYA==
X-Gm-Message-State: AC+VfDxwwvoUIxnjy4WqOGtQXieL3AYJXXPZX2LLJd5VyyBDL4fP22ad
        uEiS9fkGmji0ROeENU43A6GI63jiOLEdACubGc+jAA==
X-Google-Smtp-Source: ACHHUZ67CVh5Hzsksx47EDC4a6Xy4GO4KXQRZ/T0I3OXGD/qt6qZ+VpJMnseXs+OlzVAshIxwy5FS/auAdTpYgGsM2E=
X-Received: by 2002:ad4:5ecf:0:b0:619:152a:b99b with SMTP id
 jm15-20020ad45ecf000000b00619152ab99bmr53895082qvb.6.1684144836989; Mon, 15
 May 2023 03:00:36 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1683688960.git.nicolinc@nvidia.com>
In-Reply-To: <cover.1683688960.git.nicolinc@nvidia.com>
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
Date:   Mon, 15 May 2023 18:00:26 +0800
Message-ID: <CABQgh9FL4ssQjBJM52_kb0aBVVPb_9Wc0Q+NL1PaQO=2LYBHCA@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Nico

On Wed, 10 May 2023 at 11:34, Nicolin Chen <nicolinc@nvidia.com> wrote:
>
> [ This series is rebased on top of v6.4-rc1 merging Jason's iommu_hwpt
>   branch and Yi's vfio cdev v11 branch, then the replace v7 series and
>   the nesting v2 (candidate) series and Intel VT-d series. Note that
>   some of them are still getting finalized. So, there can be potential
>   minor API changes that would not be reflected in this series. Yet, we
>   can start the review at the SMMU driver specific things.
>
>   @robin, the hw_info patch still requires the errata patch that you
>   mentioned. Perhaps we can merge that separately or include it in v3.
>
>   Thanks! ]
>
> Changelog
> v2:
>  * Added arm_smmu_set_dev_data after the set_dev_data series.
>  * Added Jason's patch "vfio: Remove VFIO_TYPE1_NESTING_IOMMU"
>  * Replaced the iommu_get_unmanaged_domain() helper with Robin's patch.
>  * Reworked the code in arm_smmu_cmdq_build_cmd() to make NH_VA to be
>    a superset of NH_VAA.
>  * Added inline comments and a bug-report link to the patch unsetting
>    dst[2] and dst[3] of STE.
>  * Dropped the to_s2_cfg helper since only one place really needs it.
>  * Dropped the VMID (override) flag and s2vmid in iommu_hwpt_arm_smmuv3
>    structure, because it's expected for user space to use a shared S2
>    domain/hwpt for all devices, i.e. the VMID (allocated with the S2
>    domain is already unified. If there's some special case that still
>    needs a VMID unification, we should probably add it incrementally.
>  * Move the introduction of the "struct arm_smmu_domain *s2" function
>    parameter to the proper patch.
>  * Redefined "struct iommu_hwpt_arm_smmuv3" by adding ste_uptr/len and
>    out_event_uptr/len. Then added an arm_smmu_domain_finalise_nested()
>    function to read guest Stream Table Entry with a proper sanity.
>  * Reworked arm_smmu_cache_invalidate_user() by reading the guest CMDQ
>    directly, to support batching. Also, added return value feedback of
>    -ETIMEDOUT at CMD_SYNC, and reported CERROR_ILL errors via the CONS
>    in the user_data structure.
>  * Updated data/functions following the nesting infrastructure updates.
>  * Added/fixed multiple comments per v1 review inputs.
> v1:
>  https://lore.kernel.org/all/cover.1678348754.git.nicolinc@nvidia.com/
>
> --------------------------------------------------------------------------
>
> Hi all,
>
> This series of patches add nested translation support for ARM SMMUv3.
>
> Eric Auger made a huge effort previously with the VFIO uAPIs, and sent
> his v16 a year ago. Now, the nested translation should follow the new
> IOMMUFD uAPIs design. So, most of the key features are ported from the
> privous VFIO solution, and then rebuilt on top of the IOMMUFD nesting
> infrastructure.
>
> The essential parts in the driver to support a nested translation are
> ->hw_info, ->domain_alloc_user and ->cache_invalidate_user ops. So this
> series fundamentally adds these three functions in the SMMUv3 driver,
> along with several preparations and cleanups for them.
>
> One unique requirement for SMMUv3 nested translation support is the MSI
> doorbell address translation, which is a 2-stage translation too. And,
> to working with the ITS driver, an msi_cookie needs to be setup on the
> kernel-managed domain, the stage-2 domain of the nesting setup. And the
> same msi_cookie will be fetched, via iommu_dma_get_msi_mapping_domain(),
> in the iommu core to allocate and creates IOVA mappings for MSI doorbell
> page(s). However, with the nesting design, the device is attached to a
> user-managed domain, the stage-1 domain. So both the setup and fetching
> of the msi_cookie would not work at the level of stage-2 domain. Thus,
> on both sides, the msi_cookie setup and fetching require a redirection
> of the domain pointer. It's easy to do so in iommufd core, but needs a
> new op in the iommu core and driver.
>
> You can also find this series on the Github:
> https://github.com/nicolinc/iommufd/commits/iommufd_nesting-v2
>
> The kernel branch is tested with this QEMU branch:
> https://github.com/nicolinc/qemu/commits/wip/iommufd_rfcv4+nesting+smmuv3-v2
>

I rebased on these two branches and did some basic tests.

The basic functions work after backport
iommufd: Add IOMMU_PAGE_RESPONSE
iommufd: Add device fault handler support

https://github.com/Linaro/linux-kernel-warpdrive/tree/uacce-devel-6.4
https://github.com/Linaro/qemu/tree/iommufd-6.4-nesting-smmuv3-v2

However when debugging hotplug PCI device, it still does not work,
Segmentation fault same as 6.2.

guest kernel
CONFIG_HOTPLUG_PCI_PCIE=y

boot guest (this info does not appear in 6.2)
qemu-system-aarch64: -device
vfio-pci,host=0000:76:00.1,bus=pci.1,addr=0x0,id=acc1,iommufd=iommufd0:
Failed to set data -1
qemu-system-aarch64: -device
vfio-pci,host=0000:76:00.1,bus=pci.1,addr=0x0,id=acc1,iommufd=iommufd0:
failed to set device data

$ sudo nc -U /tmp/qmpm_1.socket
(qemu) info pci
(qemu) device_del acc1

guest:
qemu-system-aarch64: IOMMU_IOAS_UNMAP failed: No such file or directory
qemu-system-aarch64: vfio_container_dma_unmap(0xaaaae1fc0380,
0x8000000000, 0x10000) = -2 (No such file or directory)
qemu-system-aarch64: Failed to unset data -1
Segmentation fault (core dumped).  // also happened in 6.2

Thanks
