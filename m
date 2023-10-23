Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A42B57D3969
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 16:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbjJWOfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 10:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjJWOfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 10:35:38 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4BC9C;
        Mon, 23 Oct 2023 07:35:36 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 5250A5C0342;
        Mon, 23 Oct 2023 10:35:36 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Mon, 23 Oct 2023 10:35:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1698071736; x=1698158136; bh=ns
        M6vmFqZvDPhoAELKcnQJ/kaRHfmIZhcPe+kcJ2ns4=; b=bDa0bPl2rptPQ2B2mX
        hBCx7/WFE3vBEEl/RdbR8eWELpZDEDcC+ikBlJAK9ENjzi4i9XQ5h0Qb2vmmms3e
        Jo8u5xhzMzrj+UiR+cF6+mh7tk60R1Y5u1a2TxHOQ58bg6Ujd61vBhXkyLJKSChg
        t+kxvcSKUjzxZZTMvX4h+elL5E533OSMCuH4BzKn6uA6Y8OT04ddDdWDngACRbmM
        6m+jJci7sxixb+CGDTJtQc4K/GqTtlF7cGENyHalQWb5YqngmLjwFN+xDe4mD5AU
        Z98UbJHCAM6TdDwpWxSOdoZ9AEGjmjbzFH6XCeAvKTuirZb7+/ewqk1gwpq5qQAT
        G1hA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1698071736; x=1698158136; bh=nsM6vmFqZvDPh
        oAELKcnQJ/kaRHfmIZhcPe+kcJ2ns4=; b=Oy6KqXD88c9a7L5MEKkQt4ia34n1C
        kwYxJ5kZSjCZQpg9HUgH1njn/znEuQq7d4nEafu8QFKXQFCuHRDFZe5jUalYPz7q
        8MbkzK2AQlEzT0XnwTsywxuw1rcg6B1dgqU6y/PU5J3ai/LnvIg1po+c4Rs2ZAjg
        zddR+BMLTWXWI5xOAAFMOlJ5+LgiZuvJaq8NUEN1r1npQ0LhbSU1/51mbuYQlAfr
        fQMMWOaLSdxhwrX8K+BVT37A75EY70Q2ZCyDJ9f97NdACDB5NpAglgxmTaUfURBE
        btDGwxXCkMPGxme58e9oQYEvqTqSeuM7XUzJuhtYkNC5S9V6LRkphJkGQ==
X-ME-Sender: <xms:t4Q2Zcc7KBLqura57B1g0EtX2vYpT2EhdlBSfQ-wJAzQsWWp2Woh8g>
    <xme:t4Q2ZeNZQNaxU_8Nb2JJzdJdbvwZPP_Vl60dUGvRqarNyVc6bIfoNPPENBlYsTJ2Y
    yI5gWwqTKiIrrheiao>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedrkeeigdejiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedtkeet
    ffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    hnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:t4Q2ZdiPzLhiQsO_rloXI0vmr4cG1RXCp2r_Qu4LMYp4bcMqNVNtpg>
    <xmx:t4Q2ZR-7WKi78zfD6oj9QOxJJsgqU9FlvNtNhvmmwNIPf_opy5E5kw>
    <xmx:t4Q2ZYtKvQSM4upkqADV7GMSDD-HNmq6DUNbHSsRyabzXKkDDag-RQ>
    <xmx:uIQ2ZWAen-pLsq5QtbhIN3M53etaHBut8XUtvJCdY2KpNfMepKkS3Q>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 85399B60089; Mon, 23 Oct 2023 10:35:35 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-1048-g9229b632c5-fm-20231019.001-g9229b632
MIME-Version: 1.0
Message-Id: <35d65efa-e87b-4cc5-9c1a-e95dd6bf8edb@app.fastmail.com>
In-Reply-To: <20231023141955.GX3952@nvidia.com>
References: <20231023115520.3530120-1-arnd@kernel.org>
 <20231023120418.GH691768@ziepe.ca>
 <a16758d6-964d-4e46-9074-4d155f9b3703@oracle.com>
 <b3f7ecb1-9484-426b-8692-98706f7ff6d4@app.fastmail.com>
 <20231023132305.GT3952@nvidia.com>
 <5d7cb04d-9e79-43b9-9dd2-7d7803c93f4f@app.fastmail.com>
 <20231023141955.GX3952@nvidia.com>
Date:   Mon, 23 Oct 2023 16:35:15 +0200
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

On Mon, Oct 23, 2023, at 16:19, Jason Gunthorpe wrote:
> On Mon, Oct 23, 2023 at 04:02:11PM +0200, Arnd Bergmann wrote:
>> On Mon, Oct 23, 2023, at 15:23, Jason Gunthorpe wrote:
>> >
>> > I think the right thing is to combine IOMMU_SUPPORT and IOMMU_API into
>> > the same thing.
>> 
>> I've had a closer look now and I think the way it is currently
>> designed to be used makes some sense: IOMMU implementations almost
>> universally depend on both a CPU architecture and CONFIG_IOMMU_SUPPORT,
>> but select IOMMU_API. So if you enable IOMMU_SUPPORT on an
>> architecture that has no IOMMU implementations, none of the drivers
>> are visible and nothing happens. Similarly, almost all drivers
>> using the IOMMU interface depend on IOMMU_API, so they can only
>> be built if at least one IOMMU driver is configured.
>
> Maybe, but I don't think we need such micro-optimization.
>
> If someone selects 'enable IOMMU support' and doesn't turn on any
> drivers then they should still get the core API. That is how a lot of
> the kconfig stuff typically works in the kernel.

Agreed, that would be fine as well, and I agree it is less confusing.
A similar approach as in iommu is used in a couple of other subsystems
(regmap, gpiolib, sound, mfd, phy, virtio) where each provider selects
the subsystem as a library, but I'm not a huge fan of this either.
It's usually just easier to not make fundamental changes like this.

In this case, we can just use 'depends on' for one of the two
symbols everywhere and use to control both the providers and
consumers.

> Similarly, if they don't select 'enable IOMMU support' then they
> definitely shouldn't quitely get the core API turned on!
...
>> diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
>> index 4a79704b164f7..2902b89a48f17 100644
>> --- a/drivers/gpu/drm/nouveau/Kconfig
>> +++ b/drivers/gpu/drm/nouveau/Kconfig
>> @@ -4,7 +4,7 @@ config DRM_NOUVEAU
>>  	depends on DRM && PCI && MMU
>>  	depends on (ACPI_VIDEO && ACPI_WMI && MXM_WMI) || !(ACPI && X86)
>>  	depends on BACKLIGHT_CLASS_DEVICE
>> -	select IOMMU_API
>> +	depends on IOMMU_API
>>  	select FW_LOADER
>>  	select DRM_DISPLAY_DP_HELPER
>>  	select DRM_DISPLAY_HDMI_HELPER
>
> Like here, nouveau should still be compilable even if no iommu driver
> was selected, and it should compile on arches without iommu drivers at
> all.

Right, so with my draft patch, we can't build nouveau without
having an IOMMU driver, which matches the original intention
behind the Kconfig logic, while your suggestion would add the
same dependency here but still allow it to be compile tested
on target systems with no IOMMU. A minor downside of your
approach is that you end up building drivers (without
CONFIG_COMPILE_TEST) that currently exclude because we know
they will never work.

     Arnd
