Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0DCD7D2DB3
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 11:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbjJWJKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 05:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbjJWJKQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 05:10:16 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4208EDE
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 02:10:13 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 9452C5C02EC;
        Mon, 23 Oct 2023 05:10:10 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Mon, 23 Oct 2023 05:10:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1698052210; x=1698138610; bh=4D
        XIJgtILhDloRldPsW990JKZe88KprU5t1hrTo1YbE=; b=FOnbEzh0v14uKahD/+
        JjVLLMegllVQSKTkz3oGKX8mAmQB16GF3EvmQl4ZRPUGsoYXvBX116+UiLGtjZw6
        Ff/UoL9C/J2f+s/wrTmbtq7aer4dVU1wWdHNFbnsOx+JyCN52vILNQzFEMNmwBE+
        KjJxM7IhsLyiQQZwXdZTHrUOf4p8gPf3DWsKzd8fJk87miDI4QfmmeVT9e8eDiyY
        1fenaY0KpvMItb3tSO29eYbzpACkrAxdzyW5xi2sRFbR8KfY6rIEIujlDGDIc4wt
        8Mka4GA1Gql5OO1/MHvoJ6xgcBSXjNh4/d0dPfPzy1M0UcchUF5y18mUWY3/pAYK
        LI6g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1698052210; x=1698138610; bh=4DXIJgtILhDlo
        RldPsW990JKZe88KprU5t1hrTo1YbE=; b=bZ2MVUblkGQgQraZebeZOBIm6zrV6
        rhJ9a+C9tbf21cv0UUffOl5OfmW4a5PJjIUDocXZCtqkXLUVYh0+mMzg45ZXa3R4
        0A+jqMrNr13AP641XJL0Gr8FHSbnSnBRPiAJuPfcAKXfVqgtLOOqywt6/gwkI9T0
        lAxfrFrZNmtjE5YXcCPaadqi2q+PFgez987vlvRxmbhxa2kCAAgbkxElO50Zawze
        Vq0uMeTHJQeOtwbEZR+SlOJXNLtC6cD3tpezyXMg7jb8g78SteVnu8L6gSU59+zF
        +HWVSuFx8GEaPMEksIIBBuxIclo3UNbMhn915Tz7FH223HdK//LbST4xg==
X-ME-Sender: <xms:cjg2ZSv3mzjA0VMpYUr6aQT0TF5L-AXc9PR0lUdThS9y0QSWHTMVqg>
    <xme:cjg2ZXf7EqjqYzI38rBKTapvOvGdiE6sYqYZa_OhSLaDmVlfNJDnFbvBw-y4UslKk
    Qz3q-31wz8YNUO-kYM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedrkeeigdduudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedtkeet
    ffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    hnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:cjg2ZdxTFplZ_907K4mmnA_bBWEDDUpMtuvlRYZwUSmB5SvoXvXA2A>
    <xmx:cjg2ZdPIjJk06ZNlwjlyxAXb9-UG5N-Xev9XXrL4M8xZZILYs6AMIg>
    <xmx:cjg2ZS_YJjbn0ITNrkl-BlDA6TeU420ARjcqQ4KE77r_OFGE3htAxg>
    <xmx:cjg2ZUepl8LySWZS4kVIz82Rc-uOQlVXGwaEHWETDJ0fpD8YYfhxpA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 2FB5CB60089; Mon, 23 Oct 2023 05:10:10 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-1048-g9229b632c5-fm-20231019.001-g9229b632
MIME-Version: 1.0
Message-Id: <b7834d1e-d198-45ee-b15d-12bd235bc57f@app.fastmail.com>
In-Reply-To: <20231020222804.21850-8-joao.m.martins@oracle.com>
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231020222804.21850-8-joao.m.martins@oracle.com>
Date:   Mon, 23 Oct 2023 11:09:49 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Joao Martins" <joao.m.martins@oracle.com>, iommu@lists.linux.dev
Cc:     "Jason Gunthorpe" <jgg@nvidia.com>,
        "Kevin Tian" <kevin.tian@intel.com>,
        "Shameerali Kolothum Thodi" <shameerali.kolothum.thodi@huawei.com>,
        "Baolu Lu" <baolu.lu@linux.intel.com>,
        "Yi Liu" <yi.l.liu@intel.com>, "Yi Y Sun" <yi.y.sun@intel.com>,
        "Nicolin Chen" <nicolinc@nvidia.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>,
        "Will Deacon" <will@kernel.org>,
        "Robin Murphy" <robin.murphy@arm.com>,
        "Zhenzhong Duan" <zhenzhong.duan@intel.com>,
        "Alex Williamson" <alex.williamson@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v5 07/18] iommufd: Add IOMMU_HWPT_GET_DIRTY_BITMAP
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 21, 2023, at 00:27, Joao Martins wrote:

> +int iommufd_check_iova_range(struct iommufd_ioas *ioas,
> +			     struct iommu_hwpt_get_dirty_bitmap *bitmap)
> +{
> +	unsigned long npages;
> +	size_t iommu_pgsize;
> +	int rc = -EINVAL;
> +
> +	if (!bitmap->page_size)
> +		return rc;
> +
> +	npages = bitmap->length / bitmap->page_size;


The 64-bit division causes a link failure on 32-bit architectures:

arm-linux-gnueabi-ld: drivers/iommu/iommufd/hw_pagetable.o: in function `iommufd_check_iova_range':
hw_pagetable.c:(.text+0x77e): undefined reference to `__aeabi_uldivmod'
arm-linux-gnueabi/bin/arm-linux-gnueabi-ld: drivers/iommu/iommufd/hw_pagetable.o: in function `iommufd_hwpt_get_dirty_bitmap':
hw_pagetable.c:(.text+0x84c): undefined reference to `__aeabi_uldivmod'

I think it is safe to assume that the length of the bitmap
does not overflow an 'unsigned long', so it's probably
best to add a range check plus type cast, rather than an
expensive div_u64() here.

> +/**
> + * struct iommu_hwpt_get_dirty_bitmap - ioctl(IOMMU_HWPT_GET_DIRTY_BITMAP)
> + * @size: sizeof(struct iommu_hwpt_get_dirty_bitmap)
> + * @hwpt_id: HW pagetable ID that represents the IOMMU domain
> + * @flags: Must be zero
> + * @iova: base IOVA of the bitmap first bit
> + * @length: IOVA range size
> + * @page_size: page size granularity of each bit in the bitmap
> + * @data: bitmap where to set the dirty bits. The bitmap bits each
> + *        represent a page_size which you deviate from an arbitrary iova.
> + *
> + * Checking a given IOVA is dirty:
> + *
> + *  data[(iova / page_size) / 64] & (1ULL << ((iova / page_size) % 64))
> + *
> + * Walk the IOMMU pagetables for a given IOVA range to return a bitmap
> + * with the dirty IOVAs. In doing so it will also by default clear any
> + * dirty bit metadata set in the IOPTE.
> + */
> +struct iommu_hwpt_get_dirty_bitmap {
> +	__u32 size;
> +	__u32 hwpt_id;
> +	__u32 flags;
> +	__u32 __reserved;
> +	__aligned_u64 iova;
> +	__aligned_u64 length;
> +	__aligned_u64 page_size;
> +	__aligned_u64 *data;
> +};
> +#define IOMMU_HWPT_GET_DIRTY_BITMAP _IO(IOMMUFD_TYPE, \
> +					IOMMUFD_CMD_HWPT_GET_DIRTY_BITMAP)
> +

This is a flawed definition for an ioctl data structure. While
it appears that you have tried hard to follow the recommendations
in Documentation/driver-api/ioctl.rst, you accidentally added
a pointer here, which breaks compat mode handling because of
the uninitialized padding after the 32-bit 'data' pointer.

The correct fix here is to use a __u64 value for the pointer
itself and convert it like:

diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index a26f8ae1034dd..3f6db5b18c266 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -465,7 +465,7 @@ iommu_read_and_clear_dirty(struct iommu_domain *domain,
 		return -EOPNOTSUPP;
 
 	iter = iova_bitmap_alloc(bitmap->iova, bitmap->length,
-				 bitmap->page_size, bitmap->data);
+				 bitmap->page_size, u64_to_user_ptr(bitmap->data));
 	if (IS_ERR(iter))
 		return -ENOMEM;
 
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 50f98f01fe100..7fbf2d8a3c9b8 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -538,7 +538,7 @@ struct iommu_hwpt_get_dirty_bitmap {
 	__aligned_u64 iova;
 	__aligned_u64 length;
 	__aligned_u64 page_size;
-	__aligned_u64 *data;
+	__aligned_u64 data;
 };
 #define IOMMU_HWPT_GET_DIRTY_BITMAP _IO(IOMMUFD_TYPE, \
 					IOMMUFD_CMD_HWPT_GET_DIRTY_BITMAP)


     Arnd
