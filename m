Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9FA27D3F78
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 20:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbjJWSqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 14:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbjJWSq3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 14:46:29 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560F5FD;
        Mon, 23 Oct 2023 11:46:26 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id A3F7F5C02CC;
        Mon, 23 Oct 2023 14:46:23 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Mon, 23 Oct 2023 14:46:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1698086783; x=1698173183; bh=IE
        pCttuRg26CpesYQ8Q2lIBb5RtOOwPfreUJDn0eR5U=; b=E3FfjqY5+1NLzibCBU
        IRS8GUDikz0zLmmP4NEKs4QPt6X1ggxk9uIdYC9p/K7HDYkExlB/XfkkB6klZE7Z
        ThMrp1kagXtoq+8ORR7UBqMq6LM+R2VhtnN0Tj1xDWKTtaxxBCKNr8PJwmksJMiQ
        sx5OOANb0QghGACzHzZWyKHzPOTc3H4bu5t5Nog5jhA9RpYwXQ1hdrh4713ltRgG
        NOtyZvbDqZRK9IAmE7LgLhc6YZFlCo7bK8evvvgdViX3LclFgLbD1ZD0pylbigKq
        1kRyAjdAgIhKqBahqdRccJfna9okLyVCC5xvBLIlAjemN2RZ+jtVS1AbmCGGPmcz
        zRFQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1698086783; x=1698173183; bh=IEpCttuRg26Cp
        esYQ8Q2lIBb5RtOOwPfreUJDn0eR5U=; b=tF3BkOOxiLD4uKvMgp9bCJiIpOaD1
        ARsK6u8ovwxhrhuHqou06K8x9ANzuDLCKs1SNKqKfL0WjaGQeEzUP/Nh8o5l/dg1
        oXlZEcsN+qUOPkZsVNNSiE+bBs6/+TzCulGp5dqBw4L5dQGP7JuAy0Gh4u/kYmSL
        JAWxtgMCxHmclKRCYLFmGK5FgFLrF7ugQB3KM8XYhx+gV3OVcdAz4YQxQMvSvKVg
        NcIeLScOpcsmyrmFQh/8eYaCYnQ/cVZk94N8Skyw52LVEbA6RtiVnFr4YFYiAuWL
        DtNh1KqxoFs334FZ6Fa1RivgMQjoZ2vO0L+K8FGc7B7yQhpSdERWLoyFA==
X-ME-Sender: <xms:fr82ZTNkrfrj9CaxbEG2n8yhJ12eAIHgOfiqtueKAXY8rDeXQ2mP5Q>
    <xme:fr82Zd-X02TV1Zvu7Y_mM5vN1aXJHYeBmIkMMuZr5O3ZmzF8aWkrLU7ijun4vW8ab
    J0I5DMFYj4mR3haIhA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedrkeeigdduvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:fr82ZSRcfmMpMoWc9BFVOkgOBVE6xuHgsy5jQM2llh9yAFb29Jai6Q>
    <xmx:fr82ZXv_qFFf7uCS4pP9wi1RGuAa88uxqv6cRTeC3Y_-VryS9xuuKw>
    <xmx:fr82ZbcNJQaaulgRlkz5qn8Dy33FMFED2p8eF67-vV21R2qZeoimJw>
    <xmx:f782ZayVzLe4Ps3_VsQL8v2m-VKUBH8y4I5uIUqSeVyNBUmSmTpapw>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 1655AB60089; Mon, 23 Oct 2023 14:46:22 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-1048-g9229b632c5-fm-20231019.001-g9229b632
MIME-Version: 1.0
Message-Id: <1aeb7767-428f-4fbe-8531-c408e580764f@app.fastmail.com>
In-Reply-To: <3b731349-38e4-43bd-9482-6fe43871b679@oracle.com>
References: <20231023115520.3530120-1-arnd@kernel.org>
 <20231023120418.GH691768@ziepe.ca>
 <a16758d6-964d-4e46-9074-4d155f9b3703@oracle.com>
 <20231023131229.GR3952@nvidia.com>
 <3b731349-38e4-43bd-9482-6fe43871b679@oracle.com>
Date:   Mon, 23 Oct 2023 20:46:01 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Joao Martins" <joao.m.martins@oracle.com>,
        "Jason Gunthorpe" <jgg@nvidia.com>
Cc:     "Arnd Bergmann" <arnd@kernel.org>,
        "Kevin Tian" <kevin.tian@intel.com>,
        "Yishai Hadas" <yishaih@nvidia.com>,
        "Shameerali Kolothum Thodi" <shameerali.kolothum.thodi@huawei.com>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        "Brett Creeley" <brett.creeley@amd.com>,
        oushixiong <oushixiong@kylinos.cn>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: mlx5, pds: add IOMMU_SUPPORT dependency
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023, at 19:50, Joao Martins wrote:
> On 23/10/2023 14:12, Jason Gunthorpe wrote:
>> On Mon, Oct 23, 2023 at 01:37:28PM +0100, Joao Martins wrote:
>
> To be specific what I meant to move is the IOMMUFD_DRIVER kconfig part, not the
> whole iommufd Kconfig [in the patch introducing the problem] e.g.
>
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 2b12b583ef4b..5cc869db1b79 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -7,6 +7,10 @@ config IOMMU_IOVA
>  config IOMMU_API
>         bool
>
> +config IOMMUFD_DRIVER
> +       bool
> +       default n
> +
>  menuconfig IOMMU_SUPPORT
>         bool "IOMMU Hardware Support"
>         depends on MMU
> diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
> index 1fa543204e89..99d4b075df49 100644
> --- a/drivers/iommu/iommufd/Kconfig
> +++ b/drivers/iommu/iommufd/Kconfig
> @@ -11,10 +11,6 @@ config IOMMUFD
>
>           If you don't know what to do here, say N.
>
> -config IOMMUFD_DRIVER
> -       bool
> -       default n
> -
>  if IOMMUFD
>  config IOMMUFD_VFIO_CONTAINER
>         bool "IOMMUFD provides the VFIO container /dev/vfio/vfio"
>
> (...) or in alternative, do similar to this patch except that it's:
>
> 	select IOMMUFD_DRIVER if IOMMU_SUPPORT
>
> In the mlx5/pds vfio drivers.

If I understand it right, we have two providers (AMD and
Intel iommu) and two consumers (mlx5 and pds) for this
interface, so we probably don't want to use 'select' for
both sides here.

As with CONFIG_IOMMU_API, two two logical options are
to either have a hidden symbol selected by the providers
that the consumers depend on, or have a user-visible
symbol and use 'depends on IOMMUFD_DRIVER' for both
the providers and the consumers.

Either way, I think the problem with the warning goes
away.

> Perhaps the merging of IOMMU_API with IOMMU_SUPPORT should
> be best done separately?

Right, that part should be improved as well, but it's
not causing other problems at the moment.

     Arnd
