Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A11558AC6
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 23:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiFWVcm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 17:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiFWVcl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 17:32:41 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2052.outbound.protection.outlook.com [40.107.102.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B42852E63;
        Thu, 23 Jun 2022 14:32:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G5Kd/fglLd6z+wSvYyP2wluugXtA6Bjrm1vB+wpb1X4WyC3+c55+Iu84A74l6tFDSYoZFS2SZdpuM1MjQ6NF6hvaAg7fL0SAcs+TpTx+lpN+N3Bebj0IwyHtEf34P+ONdvF+JnsSPFis3yCdDvI7uYDHY01iprAh9szJUMhsO8ZABwXoSfd30grx5eRGBsim1/QFg6xrSr6BQ6w+X/Vni2brX9K1iJhDdvnG6pRCMRt/LQTA5rAYu2Cy5QNxgLieiopzVFIW6n0OXiH9Y3fhvYdSJ4sEJRe3AkE4xcQGyvK1TzTkQnjV+OIpnDtxgN8H9YYCyprugfF8ZTciu9K0Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JhuAh9SAZ03Ov6bu6b5ZrfeR8vSR1Td22L7nCs1/yL4=;
 b=apn8FZ+66OLwNAN/5eOO2DPFCnBHRoEL6aguF/4YUG5Rh5SdIXS3VStIe3pHmlEtf0l4MZzb0VZVFWOjx6UND5lWwpwsmHxQXYILs2KM6ZPWghIEbBAtWyON4cTgd8Vx5BjQQsYRXxjMoG5b1soj7u8wN4pIpYqYJb/xPNx5IJStitai/HHw2mY+q5O5Fw/QqKkEkEIUNPG6r6/t17FWKXiPqGyeacj55epokRWC0M1BQtV9vIAzD3ovGfqhrLm6p7GR3d3e4SBAkWrbFEfSUeDnoZT/3M7DIT3x36bBaqDv1af38zQzQSb7AIXTqz87TdQ77WVTL2So4yyao1QLxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JhuAh9SAZ03Ov6bu6b5ZrfeR8vSR1Td22L7nCs1/yL4=;
 b=KjB4mrzmBbrXwnOW7ehhh1mfBff058pG9PpURK4Wcy/IvD+MYhnuRcgQkz0LJ4s5qx00b1Os2XIlzx7FbFLWHtRe+v2YiYh2ZMs4H4S2DpNqfJLf7W9NfsQHzNSFlyTZ9HG4AYONayFN/Kl/DN8dqbrtuqbK+USU/+CWrjqWl8piOMSxyn3F4arISdoZRLHBPM2B+VoYdkL8gxsV21KC2kCIyXOBYaC3m7K4PQYy3kmo3Qfin1r/Fopc7w3N3+au4d8yRk3UEwi8pXZS/EudCp9VYD0pplMgYSktNCPWvf0lGVorLX566BXmj0WpB78Eo7CB3l/VFE8MH+s/DlvCRg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB4608.namprd12.prod.outlook.com (2603:10b6:208:fd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Thu, 23 Jun
 2022 21:32:38 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.016; Thu, 23 Jun 2022
 21:32:38 +0000
Date:   Thu, 23 Jun 2022 18:32:36 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org
Subject: Re: [PATCH 10/13] vfio/mdev: consolidate all the name sysfs into the
 core code
Message-ID: <20220623213236.GE38911@nvidia.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-11-hch@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614045428.278494-11-hch@lst.de>
X-ClientProxiedBy: BL1P222CA0008.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::13) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2a05694-b226-4fa0-61e0-08da555fe4f6
X-MS-TrafficTypeDiagnostic: MN2PR12MB4608:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vnn1JYxxf4GEKvO7U+/b/ICby0u17K8clHOg90LOSAYT2CN2gBCOjZ8VSuwpMlyq1L4CQvT7XzoIxe4fmGr+t1DbKOSZyABu1JnWKX5HtMApbeoPZ+lsBBFUfwX/dO/4KwScKZwyBcoEIAoJ7v7bxISFBRD9GthSwVix/GeNcwLeW3YmSOp1X4jQYbPpkNifTGCL6C8y3n48SYiHJ4fE8JWcJ0scXhYnwIyIxyJv9N8w32roaNZRfG4sDCP2nRh1vaLm/Y/Rt/kCUmTfFlngwlGhcEQ8X0YJqwM8aRi4LnIbmHLCeVXVpBAG6+lD8+sWtX8e5oCLOeci3mUOmaMTfes+ncKC10WEDrl+QMrpjZvCuXD7o9aScsP/5ufGUb00LMasr+DgKGdmeadibTnddQnKgbuDcjKJCSNIPx57fBS4kn9u5H9ZjlPU6a6MFZrGo5bqxLO6wIDKZECvhcjO2uv337RadSwFoash03Qph6waPKc8jv7G0v4Z60GmwyLZxZ/k9Kb5r2PGdFZpmXMavbo6fermctKvMgm+lnL9YMdArLb8Q8XeMqygBZCgKKWUYwF6tyigsQUAMlPzDvabEQvLdE5NE+CwDHpx236u8QYR0cjZpRtUqAzQzJzO6rZ1aOTEMqr0JIejvxsGdwdmj+9o8AWiaEmWLYh8VGgFMHAyOwR549F93uyQPPNKDXtjF9NPtZbbCgY6iRokNj42Q6sKBJ0pL5twrgZU99dv/5hBf0mgknh4lsVX9PEhet/C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(6506007)(6916009)(316002)(6512007)(26005)(4744005)(41300700001)(33656002)(54906003)(478600001)(2906002)(36756003)(6486002)(66476007)(66556008)(66946007)(4326008)(7416002)(86362001)(83380400001)(5660300002)(2616005)(8936002)(8676002)(1076003)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d7FAvXQ5+MI4wOupkPSUJ7d74btYGsyzVOSu/952Qv9jD0ylp+f3xC9nvcRi?=
 =?us-ascii?Q?PXdLUya7z/knB8nEMAuCUDn5QCsAjhuqPVElPhU/BycJm2faGwe+hmVDlOGd?=
 =?us-ascii?Q?0U8W2ghcaGpjpd+HgcvVn44zmdiS5hk31g8gkwVzcGhe5uC0S8H52Cffe2sO?=
 =?us-ascii?Q?GII4/h/VBhIkI/AKgCeqnt39INGECAxxaGeYuRojvHLOSAfXKGkRuetZLe1A?=
 =?us-ascii?Q?rt3BlPVitEVLKEWHx2Fb7LbaPStZAsIallsgp7vf41x8huGnG+M9P67F75mN?=
 =?us-ascii?Q?lc3UZ0tuU6DJlNydAGtwy+yMgUK9rslnR/Ipmkumk2prlL+iHmheBpdE5tiu?=
 =?us-ascii?Q?5Fha9VS1wJqfrBz34d8SeUTIWV9N00rtGvemAoz/uFSV8QAxbzOHGb7QelcO?=
 =?us-ascii?Q?agoJIojMrBOCZqu12fA4NvHq1y6HP9cs4VFXWLuY+qNTEqDt2HJBtrAuZSRR?=
 =?us-ascii?Q?cICKl3DqkhMVTdxg34/TTZYafZWHiBLXGa0+7/qNkPY4dOEagtWczo0PqpvP?=
 =?us-ascii?Q?H5wzQ2PtDe3zgWBXM8Ih1bDEe9QxF+C+dB1XcM8tyUarXBizS7APVE379Dzn?=
 =?us-ascii?Q?RofIbn5zGC6xup7KJXeE1jLYBkLyDyRELfEd0sku+GdyD2BuFMZAmLcaze97?=
 =?us-ascii?Q?/sc0NRTfkFHsxQhzDLwC4oYpAXWNpck+REurOiVUeY0+tIODV+QMpw86oZdR?=
 =?us-ascii?Q?DTdgyLnD77ETtnssgTu1vuyPu6wrHrkm1kzcnCLwc55sh+RpAvs8JKs9F11J?=
 =?us-ascii?Q?pwNrx2EH056G+ewyflpbDRzQDDzak3So6NEJVW0xwBq895zcBUP3Jn03UH18?=
 =?us-ascii?Q?zGyyEIr+cSkg9jW/yLw+9rQrvtX6/DayD0FqE2yrcv11HzEbAPmqXmSYBVNk?=
 =?us-ascii?Q?WegrfjmZuvhmwH0BhpoAJuuzmTMwc1ZLFMSjKa9kiQA0KkMJ4ZoO+3X0bYKv?=
 =?us-ascii?Q?FXgO/MFCHTx0frELDdZqoAxGSZ/29WMQS0l4CjtG3Qo4AuWKAUBwW6UMjO6q?=
 =?us-ascii?Q?Mihv8IZXx35Q0ZqDcMKT60q3rfs/i2TjwYQq1IsJMd75Qs8eqjLE+bK+IcbG?=
 =?us-ascii?Q?TEaGahKVLfRsDzCQsbDN0DNeDVB+6oRKtwMS+h4A6i6O//oQlUJXZmWwEjHL?=
 =?us-ascii?Q?YKy/V1FG2WyjP47ScAwMO7EBjxdWI6bsd3v69ELUnWiiFNZpZbmRwpPaMPZ+?=
 =?us-ascii?Q?GSywXuelDYHkJEtn1I+zNCW1/zEY0ODr5kMpNrEWMEDcjvrmruk4NKx7DW7M?=
 =?us-ascii?Q?EBewZCOGhD7MzyxV1D/BUIY7oMmV/rnq4XIG/UJoSVRcNEKorKoHSnuLF/MQ?=
 =?us-ascii?Q?C1GErM9UgDHMMpcLH3omAzSJwoFVEaGqIVNWyV6HJvn87bBuYcm7508wqCL/?=
 =?us-ascii?Q?k2hume5bzInY7Xnt2XENFdHka8TVRl+og5O+MSlH9jYUGOPNNumBEG5eCqr3?=
 =?us-ascii?Q?MyJq326rpkYAPgQsRok5KxB3mw6FQ8B3kMZ5vPXOlcfwoY95tHIcaZzL6SUB?=
 =?us-ascii?Q?WNFePI68XDMGMLvuJTP1Z/mzvj6PNdRGW2uqHoL9KCJAByvsEQvlk2yI2ZAi?=
 =?us-ascii?Q?bppFkzhlYDYL5nGi5JnKlnp2N8aHNe/wARztzRwq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2a05694-b226-4fa0-61e0-08da555fe4f6
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 21:32:37.9996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FPXmbCzdJJQtILC2ykIr/Dg7RETdZ3M3Qd1U4Ox7N8pDEGBrpxYi3ZTJEg/cPznc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4608
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022 at 06:54:25AM +0200, Christoph Hellwig wrote:
> Every driver just emits a static string, simply add a field to the
> mdev_type for the driver to fill out or fall back to the sysfs name and
> provide a standard sysfs show function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  .../driver-api/vfio-mediated-device.rst       |  2 +-
>  drivers/gpu/drm/i915/gvt/kvmgt.c              |  8 -------
>  drivers/s390/cio/vfio_ccw_ops.c               |  9 +-------
>  drivers/s390/crypto/vfio_ap_ops.c             |  9 --------
>  drivers/vfio/mdev/mdev_sysfs.c                | 11 ++++++++++
>  include/linux/mdev.h                          |  1 +
>  samples/vfio-mdev/mbochs.c                    | 20 ++++--------------
>  samples/vfio-mdev/mdpy.c                      | 21 +++++--------------
>  samples/vfio-mdev/mtty.c                      | 18 ++++------------
>  9 files changed, 27 insertions(+), 72 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
