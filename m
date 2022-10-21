Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9649B607F55
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 21:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiJUT45 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 15:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiJUT4z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 15:56:55 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6239D29B88F
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 12:56:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JkH8esi4BYcyCnDLFgN/i7JpsT9ttV1YhdJIrCPoiMHoKZbNeH3EkuAynCqzFk+gRzlvd7Ccp63ea2TSsKBazf0Sa9JH2v7TfAA06ridaFQp6LsxzJHwCgeyL6ewkw3OoYi7wRYtZ4MztvUU65vl1/FLAppg8zSPcFnuLk5TcJdsRdpyk6KeyVKOuFci2IlG0SLzN8rWUlM50zfKVTkkfYHMNFjoJ0SIxIHLF6fTn32NeFIrx/Zj78cIzZ+6L533U7PFo0KOCsVMjCkrRl5j/m3hwZIJH/J/zw5SnCqmEce7xDL82kbnQdz/njYd7hPQmE7KQzoYRPcg4RIE4UzjKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D4ulHbrWbeqoyAexNPrXueUMPOSfyYgdjTyJ2Ismxa8=;
 b=A5DY2nSJTd2Qy6ID4s7a4YiMQQfEAoW7BUUWMyTAvxub3fCV4vSDpxeL7SAp02g19f4G6KX+Ij0Wx2lh9upk6SkQAkl95CkheWPPAVyXXdXJS6ewCSvoXZGi59l47M7ZE/L5SBdU8bYWS/3ztBUWIVhuFNiBEop6auN4uxg49M44yP1AbaPMKjhxO+EtYoXK5wIs0ocDvnAQ9k72Sfvse5q5fBabyJnDJWV7KjJHb0F1FS11Nv3cwVTacJrpjSoClQ6rOQqqXknI8eaOgdOZs3kXtXKcFGbkd4uaOIwVdgjmYZkr6CbdbcmclxI0gT0uG4kPe300aDKCtp+Xo1Haeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4ulHbrWbeqoyAexNPrXueUMPOSfyYgdjTyJ2Ismxa8=;
 b=aEtIpTauOYZENPWZdctpCjRVb8Hfxv2K+n9xCKPzUdjkI5x4VP33XAked976gcnInPJBYtFzJkYJcuZhw4foKtR56aqe6VSJn/3RL8dH8PYgqX2SmxCSNPcadY6hm5N9kVLFG4DuMbPjm2ZPjMbl7OZJGUDcVCttKzMJFheED4sq9VuBd9OJKOuWHXl/1F8nahja0PLJyQWLHGRGh2YTFXYmj7wXmnSdaE5yQAdumgefCAB7ukFE+1uAbXItBuTIxW5Fvd90gDIcdGK4dsZCHwTsqtE7N/uD6IA96r+UGRyIM3wJVlWa7ANNJxxbKIZL3SpJdQpnRg/RaK3XucftsQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5272.namprd12.prod.outlook.com (2603:10b6:208:319::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Fri, 21 Oct
 2022 19:56:49 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5723.033; Fri, 21 Oct 2022
 19:56:49 +0000
Date:   Fri, 21 Oct 2022 16:56:47 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Laine Stump <laine@redhat.com>
Cc:     Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
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
        Keqian Zhu <zhukeqian1@huawei.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Alistair Popple <apopple@nvidia.com>
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Message-ID: <Y1L5f3zW97672IAy@nvidia.com>
References: <Yyx13kXCF4ovsxZg@redhat.com>
 <Yyx2ijVjKOkhcPQR@nvidia.com>
 <Yyx4cEU1n0l6sP7X@redhat.com>
 <Yyx/yDQ/nDVOTKSD@nvidia.com>
 <Yy10WIgQK3Q74nBm@redhat.com>
 <Yy20xURdYLzf0ikS@nvidia.com>
 <Yy22GFgrcyMyt3q1@redhat.com>
 <Yy24rX8NQkxR2KCV@nvidia.com>
 <Yy28FzEnoKo8UExU@redhat.com>
 <5ae777d2-f95c-d8bb-5405-192a89f16e90@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ae777d2-f95c-d8bb-5405-192a89f16e90@redhat.com>
X-ClientProxiedBy: MN2PR06CA0007.namprd06.prod.outlook.com
 (2603:10b6:208:23d::12) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5272:EE_
X-MS-Office365-Filtering-Correlation-Id: 67d2872f-6fff-4245-9491-08dab39e63e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XNp+Ow6lDoL/UzGrMFRK5kwR/qWdzNxPyT1Dvcv9OMNExkQq3MJZwSWsValrWmpsXyVDcu69nbiJi7xHAPthVhbxcEwoO5Fy8K1oQewf1n4huFt8mOuxdw1sIUkhnOStLNgyPRqrmb9qG7SrXl0PFhkt1emY0CD08SbdpRXfehZrjfu7rNN2KUZ1gloxV3of8YzFhlWfj+sXlasSyTOvzfZEqMmewRpPrN1zazstoaKsYvZB2L0yfhYuJ9NBoI9zTsA8IyCRbLdVnW+0YoPVT9DA3vbsbjEJQZ73XyKp/1brlH/nngbi0PCSR5znguUp5vDay4Ybzg4rU3zT8kGIjvWBbqOKEvbxjQJ78E7JhoArrvaZURQwBBGBO2/n4jkPGhXtuEPmDYnkYwduiGRlk2aCSd03aug2rPWn+CxQnHFK1/u0u8wmMLRB2hkTdLXdqRPiGwd1T0UV/bUGV2haopBaFA20FkLhfENqnjUUOxkfriUVK7AJrOKbDtO8moI/0YCGz31p2Tsw3i16W0IJupEVJsokr+m4BTphBUpQsbQu2PcUn4bVV5CeEPxxCU2JgNf4sXUcmlRqSU3OtbRSm5XDXIbllJHUtDp/P6ALD+3f6irFTrDFUikf5ZPZXvDxQuSk9WvEe52jfDRKXuzAu0AzAZU3Bc9CSXPiva8I5ghcOsWPcWR6TsuOZ3U4W0Gl+KVInyklL1Bk/6MJw1w0aFZhIlmf81w35geaP6r4DPbUDK/1uJp5gzaqjFNtDQpQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(451199015)(6486002)(478600001)(38100700002)(186003)(2616005)(6916009)(4326008)(54906003)(36756003)(6506007)(316002)(66476007)(66946007)(66556008)(107886003)(83380400001)(5660300002)(8676002)(7416002)(2906002)(26005)(8936002)(6512007)(41300700001)(86362001)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JOFmyDnlSP/A9iOu6EJHBZBX2Jsaf8uW/V+va+PUu7gqg0myl7OXVPBURTo/?=
 =?us-ascii?Q?Npz4VEFfpSIoBWPp8lHIT1rfWPBysqRZ8zlCnNw/z0TDcqkFL14Yxq9K+a+Y?=
 =?us-ascii?Q?V6C5v9s4LirYGDD2TXiFhVHbRcOl6d3E03AuVB42kU0zM1RAcw/zrQ9OesSt?=
 =?us-ascii?Q?A9t1RwVo2yPTM4RB1SkFsKpLDILYymb3eMj8/8GJ8QZz69HH+RhghvPQ2PDb?=
 =?us-ascii?Q?dzrN9JlVej2xyXtQNKGoKUruZamtVXxdGpJqmQke75XS+cNgkez2b6l61n9T?=
 =?us-ascii?Q?m+1atX818EVw4bOiF7YFU+emvZJf+aINQOvCm7YLA7N5YFf78uWzmt5sb9be?=
 =?us-ascii?Q?KHLTV3oDcLxmIRT9cuenBhRnB9upN2Ww04vBoAmWsafG64JJTEu7WzCOUks7?=
 =?us-ascii?Q?E5WtTWy5uDp0UuDWA0Wv6L/MuSylYBRbNZgVRIKgSnhJa1/uwWkyE1T+de0z?=
 =?us-ascii?Q?ZRN07z1YA3/XrmwZVW9VbV4aBKxH8H6wLBgPRXuo3f5+8OY/gKiGyj/Nc3OP?=
 =?us-ascii?Q?JTGQ/FDcbP9qu8g00+7/VdeDLKTQ6m7OcXeEWGisAC0MNLlyzH5EQnKqzJ7z?=
 =?us-ascii?Q?ev0Cnstjueo/0h0WLXzphphzhCPfO/UvVDSzxZpetfeZZMjM3JJ0lq0LTUqe?=
 =?us-ascii?Q?c5YPPaFT0V2vWWPRpu4c0Tx8t1o87+FgWTNwS80QUa6yJ2W8xiremnY+SuzE?=
 =?us-ascii?Q?9EmI+AIqiC309Z/jJu4WUfN+Y1kpIVgzuLoPxPlqKDcvSikXEplBw0XLLUyU?=
 =?us-ascii?Q?QD4v73JkjxtepEPv1W41kLI2kx7dM+rZzT1/smEWE7UsCmLdgsGfv9B2FHRV?=
 =?us-ascii?Q?0XD4gvLaTE5BhZFtBisgWKhU3olCQOHm2i86vedosmkhDBghqINV8oepxf9w?=
 =?us-ascii?Q?HgaCM7LpxiZsYwlK91lQ1eK1CpUT7j8qaSKPO9Su2tCd3aGsWTA9KPsrDxc8?=
 =?us-ascii?Q?17HljD/CjeO7dfCu3RhBrDiL3he78VWdB013wGZtC0/z2SDM3Xu9gv0rBzop?=
 =?us-ascii?Q?WrSv+LTYfRN/WpgaszJ/UPG4r+mZ88SG33AJw/kuNviX5MTXC7CzUDleS/0R?=
 =?us-ascii?Q?XPzHbBCPVirV224AfG76Z8xbT55uF+Bqi5IlJEFDlyHtYG4cODoHv0cJPVR8?=
 =?us-ascii?Q?+hpvc0EhbxTignZq538HCqxsP9y/jbKGyOavfwO9xzRqGZyDtXVcYQF/ULUD?=
 =?us-ascii?Q?6OabuWhYjoPX39xO5iSyDOXAhfOFb91nG81pGekikXY3HF8Sg9A9XtZDw+FD?=
 =?us-ascii?Q?lRd/t+A2vqdqlelBIegpIsNPM+WO0xGgEyshntgujFr14oCEC98blXvUvVIo?=
 =?us-ascii?Q?MOiXF/8YRk5nYtf1BlDc8/9m0aQwptRRi3n+eCPdtNCMl7rm4pDbSxNsIErg?=
 =?us-ascii?Q?cYmcIRfT5ymLgDnP+lcoA0NtCFEjrX3H/qGNk9aKBHSnW1zBGjcCXqEpuHv4?=
 =?us-ascii?Q?uLp7QbKKLH/UJQMaR8VZfflthRkRc/ug3ZCX70f3JPLD80T3V/va7lm0+bom?=
 =?us-ascii?Q?ZvN2KI1umbW/zqLuOIzQabO0TDmIk8+JVW6GpF6vrAi9wmBwI/CYDntfmBgK?=
 =?us-ascii?Q?apaIntOMsUnWiWHgRhs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67d2872f-6fff-4245-9491-08dab39e63e3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 19:56:49.0597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lSTEKNn19+wyoxQPiQ1cI/oWuXh1jLgUbqjUt6KYzXNHvbQweVJiWvISMmGUbM4g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5272
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 23, 2022 at 11:40:51AM -0400, Laine Stump wrote:
> It's been a few years, but my recollection is that before starting a
> libvirtd that will run a guest with a vfio device, a privileged process
> needs to
> 
> 1) increase the locked memory limit for the user that will be running qemu
> (eg. by adding a file with the increased limit to /etc/security/limits.d)
> 
> 2) bind the device to the vfio-pci driver, and
> 
> 3) chown /dev/vfio/$iommu_group to the user running qemu.

Here is what is going on to resolve this:

1) iommufd internally supports two ways to account ulimits, the vfio
   way and the io_uring way. Each FD operates in its own mode.
 
   When /dev/iommu is opened the FD defaults to the io_uring way, when
   /dev/vfio/vfio is opened it uses the VFIO way. This means
   /dev/vfio/vfio is not a symlink, there is a new kconfig
   now to make iommufd directly provide a miscdev.

2) There is an ioctl IOMMU_OPTION_RLIMIT_MODE which allows a
   privileged user to query/set which mode the FD will run in.

   The idea is that libvirt will open iommufd, the first action will
   be to set vfio compat mode, and then it will fd pass the fd to
   qemu and qemu will operate in the correct sandbox.

3) We are working on a cgroup for FOLL_LONGTERM, it is a big job but
   this should prove a comprehensive resolution to this problem across
   the kernel and improve the qemu sandbox security.

   Still TBD, but most likely when the cgroup supports this libvirt
   would set the rlimit to unlimited, then set new mlock and
   FOLL_LONGTERM cgroup limits to create the sandbox.

Jason
