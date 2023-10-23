Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6395A7D3742
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 14:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjJWMzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 08:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjJWMzi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 08:55:38 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74AB2102;
        Mon, 23 Oct 2023 05:55:36 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id DD0095C0302;
        Mon, 23 Oct 2023 08:55:35 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Mon, 23 Oct 2023 08:55:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1698065735; x=1698152135; bh=Q6
        trpO4sunVxOj/tQLxQc8xj8/EvcRkLo3vb/WNkXmc=; b=IjPT5vxp6YCCUPYkBU
        dgdmvXKOLMuK3t4twcKD/25yyIqeJlv7gVxFUJlPJbh0kr8jxLUTkHk1xi3eOlSW
        KVRQBhCLAeHgkedvboEyaj7FmWFoESa/6BZFfiQSsSabZOqkmfd06q9F78lcbeY4
        b4Du6jr8kg2jiYg5LqGs0FXdJVCQkYakXeDVYh3Fwlvx2BTj1v83q25aiwjXTfFA
        C9EovJ/I7OBoKM67rIYPvlQbN+wMWIlxy4e+btsLisZX787Z47wD26DdM9wMOV4J
        CivvFt6+R96346dGM77DOiCwQ4yhUC8mc6T7L9j/kxGK3t+3onNK7+m5c9MWHG2d
        1Ndg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1698065735; x=1698152135; bh=Q6trpO4sunVxO
        j/tQLxQc8xj8/EvcRkLo3vb/WNkXmc=; b=PS9az+5enioBXBIKfhPuW0+HphscE
        /uW4J58OgH+xhc3U8UCUPyfcLvDooeeqF+N/cyg56422RlkHjsVUV03LynZ7U0MZ
        J6HHNBihYtB5seFjUM7kgCGwF+iyh2fpsCFFtB7jRTjdL7rPCRtVYJwOSD86iuCK
        kPllNDvKjLQBkGMlnrPjAZvLyeLmd5fk/keg7QcvQl9TcNvCdd3OKO5lTkruK6B3
        1o752ED0hshqNrqut0Bv/nx+vRsym86ZbjDO+DY28UjhK/GHkcF+xIKEnJzUa7nV
        Ly3GvRTxsDjoYg9AyNqDlunheat58K588G607TcOiaUtqjTQxXdEtUmcQ==
X-ME-Sender: <xms:R202ZSIF1kOw6Ethvq6jAYUNXVhJQpYhPrwRECAbvN_cNswi87D8BQ>
    <xme:R202ZaLXCqq2m4YgKwylXeSyB07mH4XrbsrQTvd2bcPHWT_bTnAzqcb7hQRwaFFkT
    9iGPR6DT-hSPEYpcPY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedrkeeigdehiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedtkeet
    ffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    hnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:R202ZSu0EWGXI4p9jyhEBRw7kH0QHHJTviu2QlcrdqSkKyfHZ5pO4w>
    <xmx:R202ZXbE7-JsL1Z-dDTc50vFZ6zHNwOkls7aRWiivd4uk5aiiwJqpw>
    <xmx:R202ZZZupLc4DXqg6wXkCqHo4bDQa24a9jEwiY5sA_AcoVj6j4CrVA>
    <xmx:R202ZXP9EcS4_KjLHF1Dnj_DF-4IckKKdzHW-eUK1bEAqeuldVF0lw>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 44843B60089; Mon, 23 Oct 2023 08:55:35 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-1048-g9229b632c5-fm-20231019.001-g9229b632
MIME-Version: 1.0
Message-Id: <b3f7ecb1-9484-426b-8692-98706f7ff6d4@app.fastmail.com>
In-Reply-To: <a16758d6-964d-4e46-9074-4d155f9b3703@oracle.com>
References: <20231023115520.3530120-1-arnd@kernel.org>
 <20231023120418.GH691768@ziepe.ca>
 <a16758d6-964d-4e46-9074-4d155f9b3703@oracle.com>
Date:   Mon, 23 Oct 2023 14:55:13 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Joao Martins" <joao.m.martins@oracle.com>,
        "Jason Gunthorpe" <jgg@nvidia.com>,
        "Arnd Bergmann" <arnd@kernel.org>
Cc:     "Kevin Tian" <kevin.tian@intel.com>,
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

On Mon, Oct 23, 2023, at 14:37, Joao Martins wrote:
> On 23/10/2023 13:04, Jason Gunthorpe wrote:
>> On Mon, Oct 23, 2023 at 01:55:03PM +0200, Arnd Bergmann wrote:
>
> Right -- IOMMU drivers need really IOMMUFD (as its usage is driven by IOMMUFD),
> whereby vfio pci drivers don't quite need the iommufd support, only the helper
> code support, as the vfio UAPI drives VF own dirty tracking.
>
>> I think it means IOMMUFD_DRIVER should be lifted out of the
>> IOMMU_SUPPORT block somehow. I guess just move it into the top of
>> drivers/iommu/Kconfig?
>
> iommufd Kconfig is only included in the IOMMU_SUPPORT kconfig if clause; so
> moving it out from the iommufd kconfig out into iommu kconfig should fix it.
> Didn't realize that one can select IOMMU_API yet have IOMMU_SUPPORT unset/unmet.
> I'll make the move in v6

Are there any useful configurations with IOMMU_API but
not IOMMU_SUPPORT though? My first approach was actually

--- a/drivers/vfio/pci/mlx5/Kconfig
+++ b/drivers/vfio/pci/mlx5/Kconfig
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config MLX5_VFIO_PCI
        tristate "VFIO support for MLX5 PCI devices"
+       depends on IOMMU_SUPPORT
        depends on MLX5_CORE
        select VFIO_PCI_CORE
        select IOMMUFD_DRIVER

before I saw the other construct in the iommu drivers. Maybe that
is the best solution after all.

      Arnd
