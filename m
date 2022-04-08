Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4F04F959E
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 14:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbiDHM0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 08:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235612AbiDHM0A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 08:26:00 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773E033D83C;
        Fri,  8 Apr 2022 05:23:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G7x9gxiDaFF/phiXwg/zaNYnG0+WlgFIRAkIyN+9P4r0s9bJMdGTnavOWWhMSAUcS4kl2UWcPxSW09Ago0ABkUiaB3AvgrfVp9azIABzQA5cgZT596VBahnUrS5t+bc8bTMCjed4PNLfz0FWNj/57OTdjRvwjrhlSGlhIegz1F56dMViPVeSqNTYP991cfYpA3OBIMYdQeQNB2uy8woM+j/GwHS5cN+RsA5uJEfFJ7i9B8LrQvw6KsOFGqgj/WtPXX5V9IjAr32wu52LIV+jtFgWWjdBJjwLptQR+J1r6nu5LhhPcy96okWg9+YVYeAbyccz1Uc2LTJ8QyXxK8wfqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2cE+YfRxIDQgzWoKXdIN9ZUlfeKPQxDdEwmW2GUFtEE=;
 b=T0qgfLKmKO8gW8QODmlKv1/rI3wBjV2bkJ0f8ePJNCFRJjZToc0LiE+ydZBRKNuZ2SuFNAtUx5uQ50r0NhEGHy9aCSj5okANoVM7YravaqJKs58s3vnKIjD5Ymq7GhubFbY4PCGQfqPZyGLfv9EY9CVagmWI96/62Ov88iW+Fnh2l4dczFmG79SDdRDgose0rYMz/MhAIPdy2jmEoKz+hYbRDVHAHQTSA0b6sCPsFSkexq8p9gFzNtrwRKVgBK2aueA+k7h1kcNi5+Rs3aH49v1Olfo4/Dcca88KJULvjRedzxXFZhefnrM4aFXAVh3O6UWQpO3ZfPc861WqKu7G+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cE+YfRxIDQgzWoKXdIN9ZUlfeKPQxDdEwmW2GUFtEE=;
 b=Jidl6mhDBiGifVaNLM/T4Yxar7JDtKiFaBDLd+QuknNlRSIo6WSAsZGnVkpW3rvzLmDJl03SiCNzEgQaySKpWgSk02LnOPWmDIgUVIxzxwMX+VRwlz7sP2DKVAbGn9/4YptI/Nk+9oauNheVdUeQpRWFKaxVOcLzSWn41mz0XAUVGdlz1DQd9lrIQneW7KYtoa/FqW56RSfcOb/GmWj3fhzRVRtbmHkp6kjjv0sNXxBk0W/Iv4ZwtEYwzDtDwiOZpC7rRjaqQv2tdd9oKVHzLXQreMSNMRnr1ItfRW5RxzCy+zLHrGmBO3vqfC1/GEQ93dExPKPAnOCt2FtAM/v2aw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1498.namprd12.prod.outlook.com (2603:10b6:4:f::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Fri, 8 Apr 2022 12:23:54 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.026; Fri, 8 Apr 2022
 12:23:54 +0000
Date:   Fri, 8 Apr 2022 09:23:52 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 00/11] Fix BUG_ON in vfio_iommu_group_notifier()
Message-ID: <20220408122352.GW2120790@nvidia.com>
References: <20220308054421.847385-1-baolu.lu@linux.intel.com>
 <20220315002125.GU11336@nvidia.com>
 <Yk/q1BGN8pC5HVZp@8bytes.org>
 <1033ebe4-fa92-c9bd-a04b-8b28b21e25ea@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1033ebe4-fa92-c9bd-a04b-8b28b21e25ea@linux.intel.com>
X-ClientProxiedBy: BL1P221CA0010.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::14) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0bc080d-ed76-4819-c8e1-08da195aa593
X-MS-TrafficTypeDiagnostic: DM5PR12MB1498:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB149879716CD8886064DCED55C2E99@DM5PR12MB1498.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: byYcwCP7iyeVWPXRsmUFTbJ77+nLejzf5V+/v+m5gQ2g3IpLOk90KtSebium1nP2SHIgg65YelVphBNqQpPvnNCVxkTY31BW33O/kcVuFIQm6cNVXphmVwc+gKnqjMgOYZPmMbCQYu7XnoAYSHry6T5GMRh5lbnVCbuV1XRYrQGko4g6YGuiTL7GWTepKuCdv91ifY+Kc+Px5dxXd0HKeO3uxlMpLoq1Yfe2ARoU+JUR8ot4l7tTlezXkRX2NDJhsRNDwl+DPfwPjXDZLt20uOkSMIJFr4mBZA6WGVR//oZ1558/J2qN6BGXWALuiGzJ/rcorxkK7I2aTOpoQFjXF96IDkEd+6+JPuXpt1d9Ub9kYz9L7NFcRSRLHtyID1659clNgiq+shjj/QpiVz79MjuycXx5PpmaQs+oKdY3FERVl3XpO05DzKdS7ZsjLe51SxZ/MKc+Wn22FocCFSDSQUxiSQr/SVh6CRS5lOCdqgLmi+SonRwIL+g0msBXhsyts85Xsz7sW+JS6JGEFjXLTw8iMfPryHp+p9MR7/sl2gGth0DlNWT3f1oTDFs62pSj+hDrSswf4GkBNAX3gdlH6NWC6teC0SKzh6nN2CUK746wMp0ifrem7NK1F8EmsJqeWfESgcE0mAqML3gTmh0Wvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(66476007)(33656002)(5660300002)(6506007)(508600001)(66556008)(66946007)(4326008)(6512007)(86362001)(1076003)(26005)(2616005)(7416002)(186003)(53546011)(4744005)(38100700002)(2906002)(54906003)(316002)(6916009)(36756003)(6486002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JqChas2zLSZYnIQiTDhlvgRg6caBb1fyDBinMoIT+7kYZTfrQp/jM391SrVp?=
 =?us-ascii?Q?ILHwaTzpPm0g13KcBRf/NLW6XCgR2DY/6si9SkBwaum26YHGQByjdiJ+aBVP?=
 =?us-ascii?Q?AJST3eni3cDISlWmCBd22qMJkpD695/x+AHFg1QLZvFHpMtCUzoZdjbn8hEB?=
 =?us-ascii?Q?8DQ1lAfiNVlKWezXENXaIX5eZN94LCdxjnXHlRcE0ZwrYBkYHLylcbEZg/FW?=
 =?us-ascii?Q?Mm8G0uRtIIbnKkW1u/BKxdhEpPO78o8hLEqVhnwqHaYMnvzjIOp36hZyHEk7?=
 =?us-ascii?Q?9fvujrMEjor349qfC2b7XOrHRMoAsnL5go9R3UgCNR5ddCPmdS9JWBOQB+SU?=
 =?us-ascii?Q?xxjeQ0yJaPibsCDxr1vr5VYdTJp4YpQGkwZLqPIlsG2MdpVgDI4P00qNYrln?=
 =?us-ascii?Q?rXlJBIpCYSbs53aa5r2UemBt04ZMHPLfdCR6DhkytyJg+j4wSU7oCIYMR9Jx?=
 =?us-ascii?Q?Ptl6EfF9HMRs8LNqUnuWv8FnDgO6B7o016Gq+PpZFlw56Y9hLcIj1T0ll1Df?=
 =?us-ascii?Q?4MS/LyMez9bYXj4pX6lwV25f1yGE1Ppn0j+tnwhDRnz5rck4jP2gFXhz9Pmz?=
 =?us-ascii?Q?A7kKMKpjCE65oxZOA81d2Elhz/xux5XP3s4pQqM97nunlphB97zRyW1jQvwL?=
 =?us-ascii?Q?jvAn11iSRmQwZyf/uWNvZVmn2Qx8II9+Ar/iqRFUbVKCXjGIJzdpU7EAWO+g?=
 =?us-ascii?Q?79sPWyfNgIRrHeT6RRd6UHTVWJoTlW3BC1pEOwSfjaQMHOC6d9DDQe1tAznq?=
 =?us-ascii?Q?0EQWcPG1e5II6bR25OBFSkcGgAo5UvhPaZ+D05Sa4s0AFagJhqxhSAaTsXML?=
 =?us-ascii?Q?Ryg8hv/s/P1g0ydTYW7mXN8/0eOzEULIY9+6YIA8N06c9RWyA3G0xAjQFiDK?=
 =?us-ascii?Q?VYdFh0n7YlbV63rpOq8ALe0bOwVJL+L7za7rg9ylaiXWdUMJVNhIQvqMZhYB?=
 =?us-ascii?Q?3PpqpRTM59kG7cxgrVsyokmiKUHevnN+6fNnaq3Na3b467Y54w/imewz7Xq/?=
 =?us-ascii?Q?1sN6RRCMZn1CGwJJa+xc0akae7AQN7U13jCSrfnIu9njIHGYL+kMujLe6nhT?=
 =?us-ascii?Q?U/jGThmr/LATjb1LXJID94kFFCcL/1LWjMgMyQ4EoYhs6uiiRgVfw8F7igub?=
 =?us-ascii?Q?+o8E9v+Dh9nTXsHyXFGTrXTNv0I/dKL7x99kdiif+LZ0vo4/HaEq+3qdpz/p?=
 =?us-ascii?Q?geo0Bw0Wt/edNcPo4UFeb5wXSvDmcCl2y200OKzrEaSvoAboNBRTwkf1nHBQ?=
 =?us-ascii?Q?YUr8otVIPdt17h6fbOJV4SBUHs682RGMnW8xoGHp41NejLbtWGw+XZFJfW4D?=
 =?us-ascii?Q?cHzw9PUMXbC55Oq21QiTNbr/S50iAyyUHSc2KdPRqNyB/6rMpsaKXttcRC0e?=
 =?us-ascii?Q?5Yq+hTBw8mNPumpm1EW6ZAe4W/qqIx6p9L55BBe8K6FMq29qjLz4RbL/i+UI?=
 =?us-ascii?Q?Q0G66BdlHvnqhfUUHTEJdc0DiW1MUy/q1EwugY/Ug7LaNsBbbbUEwxMLwukW?=
 =?us-ascii?Q?aDIouV6QHd8Bll+hbU/zZElZib4sRSwOYa/NaIvNI3MiegO0n8tyWY+rxhJn?=
 =?us-ascii?Q?6AhTwmZLFB7JdseUm5S5JWEIA91O8d0RMrnrj5wUQDaBLqpO2uIehn/BFJv3?=
 =?us-ascii?Q?hSQy3Vy0S9y8wq+uDWB/F8xGA7qrG2gHyoFhhPjwWS35MXk77W3Nikc0ObP8?=
 =?us-ascii?Q?bycXPN0f14AXdOgl6bXU3G7G2tklEyW1TUcm7GjjpFao7LVvoLbxATd3hFYJ?=
 =?us-ascii?Q?WYOj6G/5Cg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0bc080d-ed76-4819-c8e1-08da195aa593
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 12:23:54.4522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HODJk6pIko7/WUq1IMpWHE/cw+Lxqaw1jrdXmCUrWjfpJPWiJUT/5XnbtkSRvWwR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1498
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 08, 2022 at 08:22:35PM +0800, Lu Baolu wrote:
> Hi Joerg,
> 
> On 2022/4/8 15:57, Joerg Roedel wrote:
> > On Mon, Mar 14, 2022 at 09:21:25PM -0300, Jason Gunthorpe wrote:
> > > Joerg, are we good for the coming v5.18 merge window now? There are
> > > several things backed up behind this series.
> > 
> > I usually don't apply bigger changes like this after -rc7, so it didn't
> > make it. Please re-send after -rc3 is out and I will consider it.
> 
> Sure. I will do.

Why rc3? It has been 4 weeks now with no futher comments.

Jason
