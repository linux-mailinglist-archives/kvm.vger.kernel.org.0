Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9D055926A
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 07:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiFXFjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 01:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiFXFjL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 01:39:11 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D405DF19;
        Thu, 23 Jun 2022 22:39:05 -0700 (PDT)
X-UUID: 8974fcc91cf4473f861aa31b1ed3be7e-20220624
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.6,REQID:696aae49-583a-4e22-9975-bd4e6d524399,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:0
X-CID-META: VersionHash:b14ad71,CLOUDID:17d673d8-850a-491d-a127-60d9309b2b3e,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: 8974fcc91cf4473f861aa31b1ed3be7e-20220624
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
        (envelope-from <yong.wu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 2041637942; Fri, 24 Jun 2022 13:39:01 +0800
Received: from mtkmbs07n1.mediatek.inc (172.21.101.16) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Fri, 24 Jun 2022 13:39:00 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 24 Jun 2022 13:39:00 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Jun 2022 13:38:58 +0800
Message-ID: <8a5e9c81ab1487154828af3ca21e62e39bcce18c.camel@mediatek.com>
Subject: Re: [PATCH v3 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
From:   Yong Wu <yong.wu@mediatek.com>
To:     Nicolin Chen <nicolinc@nvidia.com>,
        Baolu Lu <baolu.lu@linux.intel.com>
CC:     <joro@8bytes.org>, <will@kernel.org>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <robin.murphy@arm.com>,
        <robdclark@gmail.com>, <matthias.bgg@gmail.com>,
        <orsonzhai@gmail.com>, <baolin.wang7@gmail.com>,
        <zhang.lyra@gmail.com>, <jean-philippe@linaro.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kevin.tian@intel.com>, <suravee.suthikulpanit@amd.com>,
        <alyssa@rosenzweig.io>, <dwmw2@infradead.org>,
        <mjrosato@linux.ibm.com>, <gerald.schaefer@linux.ibm.com>,
        <thierry.reding@gmail.com>, <vdumpa@nvidia.com>,
        <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <thunder.leizhen@huawei.com>, <tglx@linutronix.de>,
        <chenxiang66@hisilicon.com>, <christophe.jaillet@wanadoo.fr>,
        <john.garry@huawei.com>, <yangyingliang@huawei.com>,
        <jordan@cosmicpenguin.net>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Date:   Fri, 24 Jun 2022 13:38:58 +0800
In-Reply-To: <YrUk8IINqDEZLfIa@Asurada-Nvidia>
References: <20220623200029.26007-1-nicolinc@nvidia.com>
         <20220623200029.26007-2-nicolinc@nvidia.com>
         <270eec00-8aee-2288-4069-d604e6da2925@linux.intel.com>
         <YrUk8IINqDEZLfIa@Asurada-Nvidia>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,MAY_BE_FORGED,
        SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-06-23 at 19:44 -0700, Nicolin Chen wrote:
> On Fri, Jun 24, 2022 at 09:35:49AM +0800, Baolu Lu wrote:
> > External email: Use caution opening links or attachments
> > 
> > 
> > On 2022/6/24 04:00, Nicolin Chen wrote:
> > > diff --git a/drivers/iommu/mtk_iommu_v1.c
> > > b/drivers/iommu/mtk_iommu_v1.c
> > > index e1cb51b9866c..5386d889429d 100644
> > > --- a/drivers/iommu/mtk_iommu_v1.c
> > > +++ b/drivers/iommu/mtk_iommu_v1.c
> > > @@ -304,7 +304,7 @@ static int mtk_iommu_v1_attach_device(struct
> > > iommu_domain *domain, struct device
> > >       /* Only allow the domain created internally. */
> > >       mtk_mapping = data->mapping;
> > >       if (mtk_mapping->domain != domain)
> > > -             return 0;
> > > +             return -EMEDIUMTYPE;
> > > 
> > >       if (!data->m4u_dom) {
> > >               data->m4u_dom = dom;
> > 
> > This change looks odd. It turns the return value from success to
> > failure. Is it a bug? If so, it should go through a separated fix
> > patch.

Thanks for the review:)

> 
> Makes sense.
> 
> I read the commit log of the original change:
> 
https://lore.kernel.org/r/1589530123-30240-1-git-send-email-yong.wu@mediatek.com
> 
> It doesn't seem to allow devices to get attached to different
> domains other than the shared mapping->domain, created in the
> in the mtk_iommu_probe_device(). So it looks like returning 0
> is intentional. Though I am still very confused by this return
> value here, I doubt it has ever been used in a VFIO context.

It's not used in VFIO context. "return 0" just satisfy the iommu
framework to go ahead. and yes, here we only allow the shared "mapping-
>domain" (All the devices share a domain created internally).

thus I think we should still keep "return 0" here.

Thanks:)

> 
> Young, would you please give us some input?
> 
> Overall, I feel it's better to play it safe here by dropping
> this part. If we later confirm there is a need to fix it, we
> will do that in a separate patch anyway.
> 
> Thanks
> Nic

