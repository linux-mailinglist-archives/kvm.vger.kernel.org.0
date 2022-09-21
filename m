Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91255C0451
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 18:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbiIUQgj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 12:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiIUQgW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 12:36:22 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2049.outbound.protection.outlook.com [40.107.92.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25789AB1B9
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 09:19:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNXk9bIfq/IYGCAqZGqeedCSXeH5EXFaj7fvoIMIo4Pwcrxz9g+5XPtL8R3hL+MSNpWc2oR+21UI1XgrpCA5c2WEVKpeog2w5yPzZYxcRmHGQcMWAz5ihUZcv1u4y3PrQXkqDUWF0wxBhy6zBK8QNl/EY24UzKo17zpf4IfvWKjRNbVU1NGa2CwNSbDhoqjMOVe6Pi8vAn8Mw2p671KAqbFg7RlHjTM+ziSGuqCSFzWjqL8qnrsZf03xNjRvVtdOBsT0mEe6WI7wiemr0WtFpGYE66ZPALu3N7qI3Gh1+45zx+DpeVi6/A2q42n/GWYJDVR9KysUGQUf8qRqkqzjMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6R8ygzDpLtQg7yjZ8i53yPZneU0cW91FB4FRV8A1Yrk=;
 b=bBvmRqjlBomH23lnzpvon1XsjcceeXqzvAQexHkYtVu2bXcMsxKTx3T/7aMFH0/z4WOprOaqTPdihzWJoine6O6MsgY6Q4YJ6Vbw1zJrH5Hv5Be7DTuSo6+QH1IuYWlz0p83KK16U7hyoXkmZfVwpw5SbVKTvkubsfwSoMZD4njxbwJzDpItc1FY23RN39iLAm8DhS4//VcXb8F29ENaSXan25Mre2F3K8gBf5gC/fGAko39FCV/m4UcRb3wJrCUok+Pa8MbcpzKiK7l8bPJtB4DMfqKzuCuob+HmuyKpBnBOf2QBVEMfpApifZE3osjvCJPG73SqGMe+lbl5F2nHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6R8ygzDpLtQg7yjZ8i53yPZneU0cW91FB4FRV8A1Yrk=;
 b=lp42Ustj8zMtmUsM8QWMfTDosrPJgXo0r+1KQ3taPkPh/6wGfKtYvOauDJLhzGnRduTfpORaEPeDiGkh+4SIqcQUcXvAdPvzl4OeZ0eOS+ymuVazaSm3w27kRniLZ/lCBwmC1/LY5xxjI1DY7qryOhbcIwGt9A9C9gEXnU8Zo8huOl5TBa6vDcTy3khAUlYowZJVDG4PKS0kKz51l1mPpuKDkA5AMsLIqL8ORvxwDRu+seybTLJroHenwAcC0KCdwkA5EMYvfp6JOrW7hSiCAZ6imFlucKxXzlfCj7y0veg1hZqi1mXEPSZq1YuDI2SlHmXbuhxUkfp+5npVLqxfkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN0PR12MB6199.namprd12.prod.outlook.com (2603:10b6:208:3c4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Wed, 21 Sep
 2022 16:19:15 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5654.016; Wed, 21 Sep 2022
 16:19:15 +0000
Date:   Wed, 21 Sep 2022 13:19:14 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Message-ID: <Yys5gnlb0DpvNx6A@nvidia.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <BN9PR11MB527620E859FF60250E7F08A98C479@BN9PR11MB5276.namprd11.prod.outlook.com>
 <YyodnOJaYsimbDVK@nvidia.com>
 <BN9PR11MB527643C8E0FAE091968BE2D88C4F9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527643C8E0FAE091968BE2D88C4F9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR05CA0042.namprd05.prod.outlook.com
 (2603:10b6:208:335::22) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|MN0PR12MB6199:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b14de2e-fd4f-49bb-a650-08da9bed0718
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9C+t6JmF8Y2H4SXZlHCWA5R7WrtzjpHR3VpLjVqZCDYP3Z2ZOT/39LeJeChwUMP15SVjh2/PnU3gn12f3+0aS5lQkLxj/Plp2W+kWinfC6sthmz1dTM8n8gnaH/plvlQJt1/DA8PaFUA21PtZsBtyas73ANARyJ2Q8C/kJ1BX7SpF67kWTDZ7jczj8VAV6PMfqMz2nGziwEcAkW41YyNWa2jNkFEBC8FJuHT6sTkbb/SfCQ7Odbk8DKTel1RVjnybD82TOkt/1m5lZn178aa9TE1ssqW5vCrHZG8jZsk5l0dmnwSml0SFno/HJtHBHqPX4uc6XMdd8LQe58ajHc/BAxjcpepTJDEF5le7fzDfc7n9SO6V/J4aKRaUENCq5lbJ/SLOF03QiQ88rz8RtnV0DThxt25GPZm7MuteSqY1v/uqKTTHzBIfUDIvP2EsmpRQa5YahSpuMLfpwdCLetHVGU3k5ULnPMgG8pxptKk9+W2FA8/bEG/R9RUKTRgajIkwEI6yh9Z3zY62DiX4s14aEzb2sS5loh1H7CHtrYmFzNRhPtZwUHtTcoTKfQhDF5h/1vyY7H7Bi9jpGsmP5mFRbHUEN358GIxLWRxCbnOsV790fsV4CjntiRQGv1R/EsOLr1pZquj2LnY+yGiOpHLKJ21xeH29nJSGvajccNRjqtPDZeq/Ayv3KHdQh3df8F9xsfiKKlFmRabtur6J8buLIEsnsC5wlRrUJgXOL2QAKcVIPMSCkQqEudhrAKqAz+P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(451199015)(26005)(41300700001)(6506007)(8936002)(6916009)(54906003)(2616005)(5660300002)(186003)(8676002)(4326008)(36756003)(2906002)(86362001)(66556008)(66476007)(66946007)(316002)(6512007)(7416002)(478600001)(6486002)(38100700002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1+pKLB3uuMqORzwKaulOJuqXyFP/l4FvkK5aQcNRMztwI5bd/ikWZ1Sxq+xK?=
 =?us-ascii?Q?C2VDjg9DM8AHXLczy6xOcpl0oqYbErIBPo+C+yUZy6/A9jo/sh6mdciIo7NO?=
 =?us-ascii?Q?/XqN81N78we4g3Ey52tJgc8GAfs+lQCW+mATbijVJR7W/Ggzsk7xUlOQf2Uw?=
 =?us-ascii?Q?yJ/Lvy9ukSJZs91LVmvuSAHYaY/sabVuf5tseNi78Dz5ehN5GXcNnpAmP8TC?=
 =?us-ascii?Q?0b+rQuttloY4XZF+6wEc4QNfz07W5z394jCXfCGK1KoPojF2zeKoEsJihNxK?=
 =?us-ascii?Q?gsYtHyhz6dII44GvgoPgPC3fq/ul2kMN1UfERDfSjySr8za6s4wdiz75fPPB?=
 =?us-ascii?Q?XZcfaRcOyYHQXxFcsqfmbzVcL+ZWAwy29TgUJrFZCshEFt3DaUp3vgAQN9rJ?=
 =?us-ascii?Q?2Xbiq3zrQKjKZZ7zjqNlo0IBDWYt2Q483rQmTO/yvnutzBEvflZW1I+5xLDo?=
 =?us-ascii?Q?ZxyibnMFZH+KIwJVehpdQk5V9gwQG7exmadEPIt5kRlPlo/dtPVL2aZy7PVP?=
 =?us-ascii?Q?Eh9GNHUc7qwKgBmuCqLvD+dLd8EPnGYnVa3QMr1cL/a0uZ2ga18kiEBggJNc?=
 =?us-ascii?Q?RsEU/DI2857iwVSoXCn/wN6f8nDQS+7aiHrLU+j0m8kCXmdBezE69ikMgFki?=
 =?us-ascii?Q?AsUJySBKV40/7lno6d1o3hraqsv/RrkKofYY5vBIV85I8MI/bpp/XVrlZeEI?=
 =?us-ascii?Q?A7rg+NLNqsjodUpsQJV9fj83k0fB4cCzS3h471IRV/ZBNf+hzz2q6/7odJPI?=
 =?us-ascii?Q?/F22bUSYMCDAZctc4WjW+xoBNQYVdj28E/Qyy8EkbykQdKRA407Go9cbIxdz?=
 =?us-ascii?Q?Gay9vE8nOyfVCKOPvGvHjMMLmSmeXlYeBMEWjAoBiELuAZNCwjYKcp19r7Dv?=
 =?us-ascii?Q?i74eBMEfsL4ELaVEMRwagJWFhMJ/NBvAX5zmBYn1ukmWVE3LsH1xQ6MkJhKT?=
 =?us-ascii?Q?cpWMT0NpazG8R/mXA7lnnphD93ZXMc9HQVgP1fLTO5StTSFIjaQ4GkLy5xDi?=
 =?us-ascii?Q?RHlpV92wXP2ONj6KSlAy3H6jwn8zTJldpnOMP3WTyJIEFm0eeR6z+KWVdbrf?=
 =?us-ascii?Q?WyMa2UGFD8lC3jJ94qZmffawIIK3cU5FyrCSGf5bKv2CmOq3LgqUCB579HG5?=
 =?us-ascii?Q?CzHnAlfUTpFFL6yxUdYPpmTk4KL4C1B7Y+pdUGq75dfzouZMGOzQM4q9ya04?=
 =?us-ascii?Q?0aodXgFlJeDvsT6suqlwipSY1OlPgDRSjyX82/WDs7T5s/89F5h3Yizns+yx?=
 =?us-ascii?Q?TpmvukJfEHxrHCjmxSjLwSj7hbxz2A9WynQwNEcLC2VJd3ddPFYXu8Aa8Nu7?=
 =?us-ascii?Q?WsN73R7+dyUDqMcFz/v7Em5GmBXaIXVZIhONWl7KBi0KKW8IeGaFcfbhvFUL?=
 =?us-ascii?Q?oJg54OayQ/Mm1pjxCMQ1wu83l4PyQaBFcuUlIsBDSndNBvIE5p5rhsyyK+vU?=
 =?us-ascii?Q?ZWrWXA/QtfM3AWyjyNgM0bkNH61tHGC0PlrF+GkffneJsdkrbTs8pgOsr+Pt?=
 =?us-ascii?Q?050GBDh9fwQ/01teLlAJdiG6oRC1yyz+Sg4QhzP2RdKP9d1DZweqbbS/48Pc?=
 =?us-ascii?Q?AgLzIOCeEMX94flVvC2DIIVQyS1J9KsqF8l8X5h1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b14de2e-fd4f-49bb-a650-08da9bed0718
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 16:19:15.7768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FwLh/AP5Dfdpg11PA/MAFjuaK+7xBcH9dm9MUKyKVKV7fvfVjhrc1SbdZQ5pefWC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6199
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 03:40:44AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, September 21, 2022 4:08 AM
> > 
> > On Tue, Sep 13, 2022 at 02:05:13AM +0000, Tian, Kevin wrote:
> > > A side open is about the maintenance model of iommufd.
> > >
> > > This series proposes to put its files under drivers/iommu/, while the
> > > logic is relatively self-contained compared to other files in that directory.
> > >
> > > Joerg, do you plan to do same level of review on this series as you did
> > > for other iommu patches or prefer to a lighter model with trust on the
> > > existing reviewers in this area (mostly VFIO folks, moving forward also
> > > include vdpa, uacces, etc.)?
> > 
> > From my view, I don't get the sense the Joerg is interested in
> > maintaining this, so I was expecting to have to PR this to Linus on
> > its own (with the VFIO bits) and a new group would carry it through
> > the initial phases.
> 
> I'm fine with this model if it also matches Joerg's thought.
> 
> Then we need add a "X: drivers/iommu/iommufd" line under IOMMU
> SUBSYSTEM in the MAINTAINERS file.

The maintainers file is fine to have a new stanza:

+IOMMU FD
+M:     Jason Gunthorpe <jgg@nvidia.com>
+M:     Kevin Tian <kevin.tian@intel.com>
+L:     iommu@lists.linux.dev
+S:     Maintained
+F:     Documentation/userspace-api/iommufd.rst
+F:     drivers/iommu/iommufd/
+F:     include/uapi/linux/iommufd.h
+F:     include/linux/iommufd.h

It says who to send patches to for review..

Jason
