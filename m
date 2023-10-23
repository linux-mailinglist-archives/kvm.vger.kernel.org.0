Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 434337D3A14
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 16:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbjJWOxZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 10:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjJWOxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 10:53:14 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F884D79;
        Mon, 23 Oct 2023 07:53:03 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 9318B5C03F9;
        Mon, 23 Oct 2023 10:53:02 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Mon, 23 Oct 2023 10:53:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1698072782; x=1698159182; bh=Az
        wo4GV810aPeTvBEWC7qjq1Io9LNCYHKvvtMNaxp0o=; b=miggIbszm8IdrnbhkD
        /s1zRFqh+sYOg/uO0TeA2dYmoZe/Ou8KblqBu10x5LckA7wUdqoqxsT2KSrLsAg6
        Uv5IjJrKcs1f137NAKn03IcIVJjpZJmOj3noZLiFX40o3pPltTmDahD9qixmjvMf
        OpZo1Ry+9hzMY8IRHtoUVZ46jNql6K9UpbXol4NJxwciA5ixMCQR6f1482PU8NiS
        xtO3fExCRjVxnxKIGPt7tU/km5A4856vDiGtfxUJHLgaXYrJTL7OcgPkH7QqvRXp
        9OKO/Tyxp4G9Fn6zA+TBG8QdJ8VCU+a1VIiZWC79t/uKB8eFuVQuDxr6oXSa0YkT
        MYGw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1698072782; x=1698159182; bh=Azwo4GV810aPe
        TvBEWC7qjq1Io9LNCYHKvvtMNaxp0o=; b=MwiTSWr7zHjHaoP7Vs7tFTcsD2kyJ
        gUeIMLjicevBCS6q/ZqShzrR+gO/+QGtbqavAHsXjNw1GkFT6UrwXggX4ylucq9m
        whiRYZKj42S3QdYWbulWioP6FP4oISpvWApFGR7PRSrtNe2marg0WeKFys4rV0Vs
        ejtglmDPdoQVT901EpPmh/Zik4AUTD+zbcnBBEbhPYcdxRqY0ZrcCyOJ71r2+xry
        TOcAQpzvwu3TiUQglJuYrROuZEILh9wCqNHnridq61I2N5AEILRZLI9EbetNL3EC
        Q6+LVDCKpEhlrUewtL9jNk45AKBDq+74V/9SOevZeQ0w3ohUIAB/xczCA==
X-ME-Sender: <xms:zIg2Zab_iR3HxSRBxf9CYIyZLN-xU0LPh-4D3jdZVUq-5pBabQCneg>
    <xme:zIg2ZdYZb3hF-Q27cxoD0vFwqObAkUeMpbg642M06O0bh3Cq_gYVieZUvVSHtkgQC
    86eELoTstG4h5CKAAU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedrkeeigdektdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedtkeet
    ffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    hnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:zIg2ZU-cLHWcn7etcN9qSAUNSZd-qYSaWXLcgawOq4e5ueenh3w4Sw>
    <xmx:zIg2ZcrzJNgvy7c_65ssdBHbs2l36vLoX6VAeyKgCjzAUvNvB3bQpw>
    <xmx:zIg2ZVoNP2G2jfGI44NwuPMNvPCtIRf7DMRvs2nzwn5JbhallTefag>
    <xmx:zog2ZZc2B8U0f-jjGQcYkk2MBOhP1qIUbiwMn0w1rmtbG6k-5pwkng>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id B07F5B60089; Mon, 23 Oct 2023 10:53:00 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-1048-g9229b632c5-fm-20231019.001-g9229b632
MIME-Version: 1.0
Message-Id: <29ddfa62-6875-4b25-acc9-6d7228c6ae89@app.fastmail.com>
In-Reply-To: <20231023144322.GY3952@nvidia.com>
References: <20231023115520.3530120-1-arnd@kernel.org>
 <20231023120418.GH691768@ziepe.ca>
 <a16758d6-964d-4e46-9074-4d155f9b3703@oracle.com>
 <b3f7ecb1-9484-426b-8692-98706f7ff6d4@app.fastmail.com>
 <20231023132305.GT3952@nvidia.com>
 <5d7cb04d-9e79-43b9-9dd2-7d7803c93f4f@app.fastmail.com>
 <20231023141955.GX3952@nvidia.com>
 <35d65efa-e87b-4cc5-9c1a-e95dd6bf8edb@app.fastmail.com>
 <20231023144322.GY3952@nvidia.com>
Date:   Mon, 23 Oct 2023 16:52:29 +0200
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

On Mon, Oct 23, 2023, at 16:43, Jason Gunthorpe wrote:
> On Mon, Oct 23, 2023 at 04:35:15PM +0200, Arnd Bergmann wrote:
>> >> diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
>> >> index 4a79704b164f7..2902b89a48f17 100644
>> >> --- a/drivers/gpu/drm/nouveau/Kconfig
>> >> +++ b/drivers/gpu/drm/nouveau/Kconfig
>> >> @@ -4,7 +4,7 @@ config DRM_NOUVEAU
>> >>  	depends on DRM && PCI && MMU
>> >>  	depends on (ACPI_VIDEO && ACPI_WMI && MXM_WMI) || !(ACPI && X86)
>> >>  	depends on BACKLIGHT_CLASS_DEVICE
>> >> -	select IOMMU_API
>> >> +	depends on IOMMU_API
>> >>  	select FW_LOADER
>> >>  	select DRM_DISPLAY_DP_HELPER
>> >>  	select DRM_DISPLAY_HDMI_HELPER
>> >
>> > Like here, nouveau should still be compilable even if no iommu driver
>> > was selected, and it should compile on arches without iommu drivers at
>> > all.
>> 
>> Right, so with my draft patch, we can't build nouveau without
>> having an IOMMU driver, which matches the original intention
>> behind the Kconfig logic, while your suggestion would add the
>> same dependency here but still allow it to be compile tested
>> on target systems with no IOMMU. A minor downside of your
>> approach is that you end up building drivers (without
>> CONFIG_COMPILE_TEST) that currently exclude because we know
>> they will never work.
>
> I wonder how true that is, even nouveau only seems to have this for
> some tegra specific situation. The driver broadly does work without an
> iommu. (even weirder that already seems to have IS_ENABLED so I don't
> know what this is for)
>
> I'd prefer clarity over these kinds of optimizations..

It does look like a mistake in ee8642162a9e ("drm/nouveau: fix build
error without CONFIG_IOMMU_API"), which was done in response
to a compile-time failure that was also addressed in commit 
0008d0c3b1ab ("iommu: Define dev_iommu_fwspec_get() for
!CONFIG_IOMMU_API") in a different way that made it possible to
use NOUVEAU without the IOMMU API again.

For drm/panfrost and drm/msm the dependency on IOMMU_SUPPORT
is different, as those apparently just want to select
CONFIG_IOMMU_IO_PGTABLE but can build without IOMMU_API.
This can also be handled in different ways, but it's a
separate problem.

     Arnd
