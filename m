Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F34627D370F
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 14:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjJWMmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 08:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjJWMmS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 08:42:18 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D67D7C
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 05:42:15 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 096F55C02A0;
        Mon, 23 Oct 2023 08:42:12 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Mon, 23 Oct 2023 08:42:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1698064932; x=1698151332; bh=OR
        ikYydWrWL8WqH+mJzNdmmSF0PKOctvYSDbut1fkXI=; b=dX9qslR1Y6fMq8gtxt
        vtD16EnkKc+26tTBT/m2OxTI1dR7fupNYO1wa2zawKLsLhsjsXECmH5aqFk3aPBp
        2aTo07idjRj0O/E+omdvwqL//dRnSC3qO1s8U9pSbC3H1Ghycg6z7V7Lb4MiuOR3
        WK6W3e8perdLC5QhRwQn2/54gWVxELdabzDqXgkYR5wmaNT9AaC1CogyVmcdPLqX
        ZEVY6CQDdjMBH1D0eofnpEklymGYIH5QVQWhV2EkrmRbj16YXwZ6qj1UlLkfXnVu
        1iNyJwUL0rniQl7vMwsMQvCPDhIuX43dbQY/ssqrpS6UgJtj/p3ZiyLrrZqv3Fcs
        xRYQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1698064932; x=1698151332; bh=ORikYydWrWL8W
        qH+mJzNdmmSF0PKOctvYSDbut1fkXI=; b=HE4S3X2H+JSr74QskoVt8c1iD5Fbm
        h360Zru1b1bDK770BBTTHwK3jL1QDZUPyMIOXr/MElqyrdgpevla/Mvsx3Nrlbl+
        a8PC06PkwIpQ6k61GSw9jXpuXv8XItu6uvgMR6t5U6qhnRUfFOu7Th0ttodwnoCc
        2ktcRHB7kIrcol9HL4E/o/lLygzwZdtmhG/VVfpYVt3pvRh9mXpz2aV273h1rAxi
        InufK3QK4SGKUlNtQDhT/brWcPHjqoi6qJkJN1n9b8NmkEd5onsAUDfukk41qrAe
        vVUyudMx/vb8g1CpGHA0CukbzxvapR2dniJsKN7XqDzrrPx8BiT3CHcQg==
X-ME-Sender: <xms:Imo2Zb9g_fcRiuYAdrJPQ-RmJI1dWR_-ciVR8YXPrf-hn7Q4jCwe0Q>
    <xme:Imo2ZXvn11XhI-rNnbr3QJJy6t8I3u_5HvYKF663qD14UDZsuyXdJTY8CHglaIa7c
    AMrPM3omilMSsoiY8c>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedrkeeigdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedtkeet
    ffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    hnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:Imo2ZZBpqo0cq0L-HVTsyJlR-O0jdTNyITIalF_9RKiTVKUg0NRChg>
    <xmx:Imo2ZXe-CeIb1kcB-jOjFTjW06_N2uoYDwwa_fOx8-tEqwAJ0ZQEiw>
    <xmx:Imo2ZQPHPANtLC8D7VsmYIZJWuUFW_BYwMkgxk3C715fFhszxc7Jzw>
    <xmx:JGo2ZSuW7vrtIMh6vgfxDwUbPynvR0xc_DcmwXwJKSybvw6Sdz54NA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id C6170B60089; Mon, 23 Oct 2023 08:42:10 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-1048-g9229b632c5-fm-20231019.001-g9229b632
MIME-Version: 1.0
Message-Id: <5a809f02-f102-4488-9fb2-bd4eb1c94999@app.fastmail.com>
In-Reply-To: <20231023121013.GQ3952@nvidia.com>
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231020222804.21850-8-joao.m.martins@oracle.com>
 <b7834d1e-d198-45ee-b15d-12bd235bc57f@app.fastmail.com>
 <d65cb92a-8d2c-41a3-83b1-899310db1a20@oracle.com>
 <20231023121013.GQ3952@nvidia.com>
Date:   Mon, 23 Oct 2023 14:41:50 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Jason Gunthorpe" <jgg@nvidia.com>,
        "Joao Martins" <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, "Kevin Tian" <kevin.tian@intel.com>,
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
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023, at 14:10, Jason Gunthorpe wrote:
> On Mon, Oct 23, 2023 at 10:28:13AM +0100, Joao Martins wrote:
>> > so it's probably
>> > best to add a range check plus type cast, rather than an
>> > expensive div_u64() here.
>> 
>> OK
>
> Just keep it simple, we don't need to optimize for 32 bit. div_u64
> will make the compiler happy.

Fair enough. FWIW, I tried adding just the range check to see
if that would make the compiler turn it into a 32-bit division,
but that didn't work.

Some type of range check might still be good to have for
unrelated reasons.

    Arnd
