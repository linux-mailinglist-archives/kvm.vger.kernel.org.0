Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5BBE7D38C5
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 16:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbjJWOCh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 10:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbjJWOCg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 10:02:36 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF2BD73;
        Mon, 23 Oct 2023 07:02:33 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 000DC5C01F4;
        Mon, 23 Oct 2023 10:02:32 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Mon, 23 Oct 2023 10:02:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1698069752; x=1698156152; bh=8f
        c2USBUSuuU4Qm2PByD5iUbOiLGO4A2eX7Ijpawev0=; b=bqKAxq6WqJDPIYWhYJ
        QByf8in6pAb/Zlcq2Sr55+uux7kmVQe1lpssb/Z/U8ohXBCebEf0UwLNjsRtPpll
        5S/lz5PaFK5+3LTxDLrwBtXWapE39TxMKf6U3Jsy3VvUkhUiOBebd7G0NO3jQt4Z
        xl2WZZlgA+uIUaEidSG9aeOzkFzAZJeH1H9M1UMLUvNad8hK0QweWo/4TZfHK8Rt
        I13kU+e5jkEy9AD2jw964FHiD2Y9GaGzT9RyssXJGIsz5iCPwsns5bR6a6HmZss+
        msamcoFtjf3pQ4Dq463cw3LgeTClXASmWeGDnJQWmTBezYeOklADcelIWkve3kuy
        ockg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1698069752; x=1698156152; bh=8fc2USBUSuuU4
        Qm2PByD5iUbOiLGO4A2eX7Ijpawev0=; b=CoRG1M3/37qF4U2RD+IvHSwPlanAt
        DY7kUBHXLwWlU7DLfzvm0SvHopXdskvsX8R8OXtTwYL+I3VsCGfwbdBOwxF0J3GX
        pXT8NkF7tNyXCG18/Y0jLLKLIDLmmkOt7K59yaBgJiJvzHk1ALPMKYyXKQ/bTUpY
        VulvTe6o897qkx6Ad6LHBSz3LUuNDl8pLWqU8GwE4qIL0bEm5G95g1VTpMcK3cF4
        hR1TwlEj44BG67EeQ+iKxMkBhRUiJYt8+XyGkZ0sh0TtrjajGmv+4mymCjyoHg/E
        7BPeBp1DsWej1cU1pFsLN0JHvuqLOVBx9gL+aUDB/MxPFUWkaRcWHn85w==
X-ME-Sender: <xms:93w2ZVJk9mxiNVU_HwzjdMVShWZjHGSJzQnNQpqIbroI4-J2zXY9Sw>
    <xme:93w2ZRJ_mKKT584Symxt0glagQZLS_V_uMZypcJc5uJvoMnC7uSYo5X6SCzp9n8EM
    BqKAx9GncqMUMJ-9Gs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedrkeeigdejtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedtkeet
    ffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    hnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:93w2ZdueEPVMQwKdQKLAAE2ZVf0pqzjtfFI-3hLdF_TYRe9h4ZmjZg>
    <xmx:93w2ZWbRk-f8-hIKiOQYbVW2_D0wEkYSSUSNxaHJjZIX4uprX1rlsQ>
    <xmx:93w2ZcaQXSLBlITJ5ev5u1kAyev2TfKzDd1Y5MiDH1SoSpRovqRoVg>
    <xmx:-Hw2ZSP0YK1PGyUFKLf4cn9YyFwBURw0-AN3JwPfsazQVTilc96mBA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 63ADEB60089; Mon, 23 Oct 2023 10:02:31 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-1048-g9229b632c5-fm-20231019.001-g9229b632
MIME-Version: 1.0
Message-Id: <5d7cb04d-9e79-43b9-9dd2-7d7803c93f4f@app.fastmail.com>
In-Reply-To: <20231023132305.GT3952@nvidia.com>
References: <20231023115520.3530120-1-arnd@kernel.org>
 <20231023120418.GH691768@ziepe.ca>
 <a16758d6-964d-4e46-9074-4d155f9b3703@oracle.com>
 <b3f7ecb1-9484-426b-8692-98706f7ff6d4@app.fastmail.com>
 <20231023132305.GT3952@nvidia.com>
Date:   Mon, 23 Oct 2023 16:02:11 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Jason Gunthorpe" <jgg@nvidia.com>
Cc:     "Joao Martins" <joao.m.martins@oracle.com>,
        "Arnd Bergmann" <arnd@kernel.org>,
        "Kevin Tian" <kevin.tian@intel.com>,
        "Yishai Hadas" <yishaih@nvidia.com>,
        "Shameerali Kolothum Thodi" <shameerali.kolothum.thodi@huawei.com>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        "Brett Creeley" <brett.creeley@amd.com>,
        oushixiong <oushixiong@kylinos.cn>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: mlx5, pds: add IOMMU_SUPPORT dependency
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023, at 15:23, Jason Gunthorpe wrote:
> On Mon, Oct 23, 2023 at 02:55:13PM +0200, Arnd Bergmann wrote:
>> On Mon, Oct 23, 2023, at 14:37, Joao Martins wrote:
>> 
>> Are there any useful configurations with IOMMU_API but
>> not IOMMU_SUPPORT though? My first approach was actually
>
> IOMMU_SUPPORT is just the menu option in kconfig, it doesn't actually
> do anything functional as far as I can tell
>
> But you can have IOMMU_API turned on without IOMMU_SUPPORT still on
> power
>
> I think the right thing is to combine IOMMU_SUPPORT and IOMMU_API into
> the same thing.

I've had a closer look now and I think the way it is currently
designed to be used makes some sense: IOMMU implementations almost
universally depend on both a CPU architecture and CONFIG_IOMMU_SUPPORT,
but select IOMMU_API. So if you enable IOMMU_SUPPORT on an
architecture that has no IOMMU implementations, none of the drivers
are visible and nothing happens. Similarly, almost all drivers
using the IOMMU interface depend on IOMMU_API, so they can only
be built if at least one IOMMU driver is configured.

I made a patch to fix the outliers, which fixes the problem
by ensuring that nothing selects IOMMU_API without also depending
on IOMMU_SUPPORT. Unfortunately that introduces circular dependencies
with CONFIG_VIRTIO, which needs a similar patch to ensure that
only VIRTIO transport providers select it, not virtio drivers
(console, gpu, i2c, caif and fs get this one wrong).

> Since VFIO already must depend on IOMMU_API it would be sufficient for
> this problem too.

Right, having all IOMMU users depend on IOMMU_API certainly makes
sense, though at the moment it uses 'select', which is part of
the problem.

    Arnd


diff --git a/drivers/gpu/drm/msm/Kconfig b/drivers/gpu/drm/msm/Kconfig
index ad70b611b44f0..57ebd7f1a3b29 100644
--- a/drivers/gpu/drm/msm/Kconfig
+++ b/drivers/gpu/drm/msm/Kconfig
@@ -5,7 +5,7 @@ config DRM_MSM
 	depends on DRM
 	depends on ARCH_QCOM || SOC_IMX5 || COMPILE_TEST
 	depends on COMMON_CLK
-	depends on IOMMU_SUPPORT
+	depends on IOMMU_API
 	depends on QCOM_AOSS_QMP || QCOM_AOSS_QMP=n
 	depends on QCOM_OCMEM || QCOM_OCMEM=n
 	depends on QCOM_LLCC || QCOM_LLCC=n
diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
index 4a79704b164f7..2902b89a48f17 100644
--- a/drivers/gpu/drm/nouveau/Kconfig
+++ b/drivers/gpu/drm/nouveau/Kconfig
@@ -4,7 +4,7 @@ config DRM_NOUVEAU
 	depends on DRM && PCI && MMU
 	depends on (ACPI_VIDEO && ACPI_WMI && MXM_WMI) || !(ACPI && X86)
 	depends on BACKLIGHT_CLASS_DEVICE
-	select IOMMU_API
+	depends on IOMMU_API
 	select FW_LOADER
 	select DRM_DISPLAY_DP_HELPER
 	select DRM_DISPLAY_HDMI_HELPER
diff --git a/drivers/gpu/drm/panfrost/Kconfig b/drivers/gpu/drm/panfrost/Kconfig
index e6403a9d66ade..acdcad76d92a8 100644
--- a/drivers/gpu/drm/panfrost/Kconfig
+++ b/drivers/gpu/drm/panfrost/Kconfig
@@ -5,9 +5,9 @@ config DRM_PANFROST
 	depends on DRM
 	depends on ARM || ARM64 || COMPILE_TEST
 	depends on !GENERIC_ATOMIC64    # for IOMMU_IO_PGTABLE_LPAE
+	depends on IOMMU_API
 	depends on MMU
 	select DRM_SCHED
-	select IOMMU_SUPPORT
 	select IOMMU_IO_PGTABLE_LPAE
 	select DRM_GEM_SHMEM_HELPER
 	select PM_DEVFREQ
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 3199fd54b462c..be3a8bf42f6ca 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -3,10 +3,6 @@
 config IOMMU_IOVA
 	tristate
 
-# IOMMU_API always gets selected by whoever wants it.
-config IOMMU_API
-	bool
-
 menuconfig IOMMU_SUPPORT
 	bool "IOMMU Hardware Support"
 	depends on MMU
@@ -483,4 +479,8 @@ config SPRD_IOMMU
 
 	  Say Y here if you want to use the multimedia devices listed above.
 
+# IOMMU_API must be selected by any IOMMU provider
+config IOMMU_API
+	bool
+
 endif # IOMMU_SUPPORT
diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 6bda6dbb48784..8c56189c95b38 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0-only
 menuconfig VFIO
 	tristate "VFIO Non-Privileged userspace driver framework"
-	select IOMMU_API
 	depends on IOMMUFD || !IOMMUFD
+	depends on IOMMU_API
 	select INTERVAL_TREE
 	select VFIO_GROUP if SPAPR_TCE_IOMMU || IOMMUFD=n
 	select VFIO_DEVICE_CDEV if !VFIO_GROUP
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index d5989871dd5de..9b0eeffc9a3b3 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -353,6 +353,7 @@ config XEN_GRANT_DMA_OPS
 config XEN_VIRTIO
 	bool "Xen virtio support"
 	depends on VIRTIO
+	depends on IOMMU_SUPPORT
 	select XEN_GRANT_DMA_OPS
 	select XEN_GRANT_DMA_IOMMU if OF
 	help
