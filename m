Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D56AD61467E
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 10:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiKAJTW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 05:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiKAJTU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 05:19:20 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2055.outbound.protection.outlook.com [40.107.100.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DFEE07;
        Tue,  1 Nov 2022 02:19:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n6MCCpSZwys9ds//FPMY4uKxvOjiMJroAZqZFJPBHCuB0Zj77VSjC6rw7LUW5KnmXlnpBeggoGQ2KK79v/VhsYBQK97e+KEe1/cg2XBg6UdCdqm55NfV9+Mg0Uh+SXKs5r55Dcg/M3uOS8oLH1zOi+TTJia9d1mx+Fb3Uo8FU0FjsvB763XWPFh+yrYauyMxVJXCh58P1dsDIKYOvE+chPq1Ie4K4hJqsdxx7Er4EiUDEq3IlI15ajfa6EuL+TmCxXZTSsMeLc9eAJYQJO3D0JLYeUdq6pQ019nthhHz+OPzO9+sb4JCK+YE2CYFScY0vMy3cHw0ob5cyJakCTUz+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A3HzOHfrge0Dz3XBWzBJXGo6vP/4dDrpUcB5YFWmoXg=;
 b=K9GlfCTKDAB7iE0QUiCETlNFlAKM01II23AtdmTUr9AZjHLgxeRh+O1pRZgM4ljZpRZgxIn2OtNRe/lqBresjNVbIOfd3njHoEA0LAd700MjLz6uxVh4GtgczAkikZN9B4nekS+1XHGDkl4+F+gMFe+Od/WdXA/JWe7Mu5iGB8qYtkesTiWGiR/17iQYK7VDoPqIc9o8ZL04JWKfZDw4ZYSpnfNCO53+wJ1wCwNip1Xz/eUPlg5ws0m5NU0KkiqptCXyYwrzo2/CD+aZnJ+WaebBCeaZyiK9NMI0Hv5RRvztRrGbhRAK6lAu33rlfHLoJJAty7CERTaG194vclSvFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A3HzOHfrge0Dz3XBWzBJXGo6vP/4dDrpUcB5YFWmoXg=;
 b=rXdkOpdU4yW8tm0u+lpU+gHK3Vc6nzoe7aCg9rrhIXoyI7uxChEO4bCo+89f7P/PlmGIhLY9eOyWAs+IuVIyoYDX7FH7+8eAlxoGJo0jHzzrXnjSwwYNnH5RaRcy0oAqxn99n1cIhDp0VpSXsbyakFav8247oVi39LKM6e7QnAlfAE8W9/qDul/CHZ592Zr/CXSP40yOUjWgdhnTanmf+jnKUfgIfASQYjEvMfM9LWQXPq1HJj20ui3RFf+M4cHN/KoVJaV6KKTrvbImWfPFpXpIYKPiN4x2OrBfNZduTEkObnjXocJU3TRvoRZkSqw0CtZkiRiv9SXWqISzipRmvw==
Received: from MW4PR04CA0053.namprd04.prod.outlook.com (2603:10b6:303:6a::28)
 by MW3PR12MB4412.namprd12.prod.outlook.com (2603:10b6:303:58::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Tue, 1 Nov
 2022 09:19:12 +0000
Received: from CO1NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::fc) by MW4PR04CA0053.outlook.office365.com
 (2603:10b6:303:6a::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19 via Frontend
 Transport; Tue, 1 Nov 2022 09:19:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1NAM11FT096.mail.protection.outlook.com (10.13.175.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.14 via Frontend Transport; Tue, 1 Nov 2022 09:19:12 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 1 Nov 2022
 02:19:08 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Tue, 1 Nov 2022 02:19:07 -0700
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Tue, 1 Nov 2022 02:19:06 -0700
Date:   Tue, 1 Nov 2022 02:19:04 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        David Airlie <airlied@gmail.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Eric Auger <eric.auger@redhat.com>,
        "Eric Farman" <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        "Joonas Lahtinen" <joonas.lahtinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Longfang Liu <liulongfang@huawei.com>,
        "Matthew Rosato" <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 06/10] vfio-iommufd: Allow iommufd to be used in place of
 a container fd
Message-ID: <Y2DkiM/o2wTf9Mjz@Asurada-Nvidia>
References: <0-v1-4991695894d8+211-vfio_iommufd_jgg@nvidia.com>
 <6-v1-4991695894d8+211-vfio_iommufd_jgg@nvidia.com>
 <BN9PR11MB527655AB662598A9D5F9F1778C369@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527655AB662598A9D5F9F1778C369@BN9PR11MB5276.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT096:EE_|MW3PR12MB4412:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ad75108-9150-41a1-db59-08dabbea2410
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s92JwPeBoQN4SxLrgtpd9vo4g9GZgsoEKmdoKMVLEjai4TnQ1Z5GI6NhxA+hh+i0Tz5E/UnlcdtbG3xu/uiqSZdvkSaRxoVwf5zvr3fCJfoejLSj1ThcC+WAontq0VfHZ1cHkSOtotOuurXR7Nplk3N/4viHwxzfHUf3wQ/QK61jAnDyrEAJX6Po7/h+6C87QolnkB03fqKLR3vzDBwzH+SYt6RfeodjcvFdROua4JCZgredUamCFJAlXnbYnQekWAkdL4aDgD24s6F9rdx4x2kjjE1ZjhVc9mt2rNH08U6mxmvjvWUoKP9bwsP98Qb53oknASwpfhstHWttsBMlWAKwA18wOIjQ6AbmGl9fxARI/435sdQh4NUcL5QDTNQiDHOIDpnmS0+lnD3j8ooLmTR9NUi+ijMEYbLJ4AASjvBgK4si36R/4S/q4u+GuHV+ddYO5Ng0FPfjUCX1U65LN132yxiYgBtL0KcT0Rbzs/KzJxemyCMLezdMZcqKqLuJCTjS2Tg8oRyW2LMuwG1FduZxiGnN5Veh8JAaTovaWvMZ7HuwpQZqZOF9coowH28BrBy8r98j+yvkYtejAV9+F0qAt5goZWztyLH/18b46f/9h5Zg3FrCLnspwi3bnTPo0psz8f/QD/q36Hvmgt1UkX0BnbRHrPZJODcRC0wBGYdQt/Lnd26l1Kq6jHa9p76+TIhoqflbbZpnVGTQBMz8vYdWjDudcyGuS4YtyhC5eX1ItaN0zclp/pST+NTtaWuTvanlKK6Lx0o2gq6L0xVt3mAvYp5YJ+xXpNwsxdP+Zth56nG02VZbf6PUfKhMb+2VqKBbWzQZIK6wiLYSxmRC0GvSiXJwle3kls1k9XGUN+4=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(39860400002)(396003)(376002)(451199015)(36840700001)(46966006)(40470700004)(41300700001)(7406005)(2906002)(7416002)(5660300002)(70586007)(54906003)(316002)(8676002)(70206006)(6916009)(4744005)(4326008)(40480700001)(55016003)(966005)(8936002)(7636003)(356005)(478600001)(82740400003)(336012)(36860700001)(426003)(47076005)(26005)(186003)(86362001)(9686003)(40460700003)(82310400005)(33716001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 09:19:12.7234
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ad75108-9150-41a1-db59-08dabbea2410
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4412
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 01, 2022 at 08:09:52AM +0000, Tian, Kevin wrote:

> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, October 26, 2022 2:51 AM
> >
> >  menuconfig VFIO
> >       tristate "VFIO Non-Privileged userspace driver framework"
> >       select IOMMU_API
> > +     depends on IOMMUFD || !IOMMUFD
> 
> Out of curiosity. What is the meaning of this dependency claim?

"is it a module or not" -- from https://lwn.net/Articles/683476/
