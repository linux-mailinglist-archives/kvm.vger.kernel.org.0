Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C605E561662
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 11:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbiF3Jda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 05:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbiF3Jd3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 05:33:29 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7771E13CD9;
        Thu, 30 Jun 2022 02:33:25 -0700 (PDT)
X-UUID: d9a66131010f4958a9a685e7c5722af9-20220630
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.7,REQID:c6e5360c-aab8-43c5-8966-20f89b8b8363,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:0
X-CID-META: VersionHash:87442a2,CLOUDID:2ace0d63-0b3f-4b2c-b3a6-ed5c044366a0,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: d9a66131010f4958a9a685e7c5722af9-20220630
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <yong.wu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1924593644; Thu, 30 Jun 2022 17:33:20 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Thu, 30 Jun 2022 17:33:18 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 30 Jun 2022 17:33:16 +0800
Message-ID: <63969062a55b1c520f276b9a4b5f79faa12da20b.camel@mediatek.com>
Subject: Re: [PATCH v3 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
From:   Yong Wu <yong.wu@mediatek.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Baolu Lu <baolu.lu@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "jordan@cosmicpenguin.net" <jordan@cosmicpenguin.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolin.wang7@gmail.com" <baolin.wang7@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Date:   Thu, 30 Jun 2022 17:33:16 +0800
In-Reply-To: <YrysUpY4mdzA0h76@Asurada-Nvidia>
References: <20220623200029.26007-1-nicolinc@nvidia.com>
         <20220623200029.26007-2-nicolinc@nvidia.com>
         <270eec00-8aee-2288-4069-d604e6da2925@linux.intel.com>
         <YrUk8IINqDEZLfIa@Asurada-Nvidia>
         <8a5e9c81ab1487154828af3ca21e62e39bcce18c.camel@mediatek.com>
         <BN9PR11MB527629DEF740C909A7B7BEB38CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
         <19cfb1b85a347c70c6b0937bbbca4a176a724454.camel@mediatek.com>
         <20220624181943.GV4147@nvidia.com> <YrysUpY4mdzA0h76@Asurada-Nvidia>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-06-29 at 12:47 -0700, Nicolin Chen wrote:
> On Fri, Jun 24, 2022 at 03:19:43PM -0300, Jason Gunthorpe wrote:
> > On Fri, Jun 24, 2022 at 06:35:49PM +0800, Yong Wu wrote:
> > 
> > > > > It's not used in VFIO context. "return 0" just satisfy the
> > > > > iommu
> > > > > framework to go ahead. and yes, here we only allow the shared
> > > > > "mapping-domain" (All the devices share a domain created
> > > > > internally).
> > 
> > What part of the iommu framework is trying to attach a domain and
> > wants to see success when the domain was not actually attached ?
> > 
> > > > What prevent this driver from being used in VFIO context?
> > > 
> > > Nothing prevent this. Just I didn't test.
> > 
> > This is why it is wrong to return success here.
> 
> Hi Yong, would you or someone you know be able to confirm whether
> this "return 0" is still a must or not?
> 
> Considering that it's an old 32-bit platform for MTK, if it would
> take time to do so, I'd like to drop the change in MTK driver and
> note in commit log for you or other MTK folks to change in future.

Yes. Please help drop the change in this file.

Sorry I don't have the board at hand right now and I could not list the
backtrace where this is needed(should be bus_iommu_probe from the
previous debug...)

> 
> Thanks
> Nic

