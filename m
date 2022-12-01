Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBBB863E6B1
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 01:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiLAAvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 19:51:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiLAAvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 19:51:18 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E8E5B584
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 16:51:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uxhj9FU4iRXMtC5oSvwhprfv9GHm9HCqWWZUY7XXjeE+tdyscKIShEJ0k8rDEASZgnfY1lo+Eiw/tSpZ64xzo/jxRUmWaK4j7q3sFNqjoyUHeUJshysysSChmXzBGtHPyIRZjSBL+DB+LROUPXYgafghAme+7+uRpJRR6i0jDSCoXxacpRewLt8KuBDx3Y90BITSmobG+3AKVY+JwGYPNOIqBKzjSIfMu8H7vxHH5LHFwjr+xU3ZDFQbH2OGIZCBKkNsXh9ErveHWBdL8QT1tyYhRVJHJt4qa/JOt0O7NNMoh8o0omxcSG0vGxn8NJ6wTxrmF1WyeoUu2QJYPHc9bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jLTGt4cxWxO3fpB7A4Ryd5/s8HuAAqySElzIsBSEsQ8=;
 b=W0SueJJIGMy9HdoaNeB89fa34PiEYbPR0OHWfuf0PLmV9+K4qUo35eGiKV8VyS5e2ZdOmJXpB3d0OPmi64MkDHvDHabKjOeLfhIRhK5RyPYj1xGY3L3E/feUcHzKRWEtP12wXvKJD1+GXg7wb5ba2WoGROBqEKW1mrYRZ5vo7rw9mZ+MXNLNRGGdJPrwGrUl3bKdu5/fXOrQOcBMoprBMBaD0YllSlnXa7+VCRdYZGKz7iVzyj0XsstHs6N66JuprAkUR7khb73cVUjroBB/iFGON/tHuMm2WK6//avKDnwd/BxG/qHUgHMgnLGbfdzQu5BZb4ct3yXAi6n0Z9PgcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jLTGt4cxWxO3fpB7A4Ryd5/s8HuAAqySElzIsBSEsQ8=;
 b=s5Ik5DMAczdQxYuRFUFQTrgB4ECD4fgOwI5oMg9M1DSLzpoFN7e3ILgxNbYKcHxO0rb1gZggbuwpEi81AwmVnj+2IKfbAvkEoXZr+1Vty+AsP1rWJe/HCpnjDuR2rhvOjRvdbrhTWwB+AMlfRsER0kgGrnvi/qVdQzS3tQjymqXA4h4B9q58JeQXtRx19FwC+1UlAA1DscYceH+Mm2oaBLeU3gZ3iNXZzt5aytXmyaoQL0wtKTrHKN8qNqyn2n30dP4jfzhqBq0VeEYyPyy+VQwSkKNMUAg7a4O8uydSsBa6RzdB0VOlvl0wYIAFlAXEotodR+hfqDDHRP4HdP8waQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4171.namprd12.prod.outlook.com (2603:10b6:5:21f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 00:51:15 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 00:51:15 +0000
Date:   Wed, 30 Nov 2022 20:51:14 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        shayd@nvidia.com, maorg@nvidia.com, avihaih@nvidia.com,
        cohuck@redhat.com, Juan Quintela <quintela@redhat.com>
Subject: Re: [PATCH V1 vfio 02/14] vfio: Extend the device migration protocol
 with PRE_COPY
Message-ID: <Y4f6gk2JD3l47p2y@nvidia.com>
References: <20221124173932.194654-1-yishaih@nvidia.com>
 <20221124173932.194654-3-yishaih@nvidia.com>
 <20221130152240.11a24c4d.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130152240.11a24c4d.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1P223CA0015.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4171:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ee09245-76a5-4fca-d60b-08dad3362671
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lrUiCkWIVg0AQmEFMVUsHaifqgBlpILkNH4tv2I7BUcN/QPaWCwrmXNxpXSrqS65yu/Y5JzVq5PthSt4ssnZudqngR6a+SU+Sti7J2OnStSUN11R8f/uRmhSNdYis0RHnddkUOyVz4sET26hc3BXoynWMXCdzUhYLQQz9rMxgVWJ1iJPq1XfGtVUZRZ7spMcGvuyym1Oov28PpLqJ+LxXIRQFVZq4DzUm7eEfWGxW23NwHWn7SC3aVi3F/HZsj1Xo46Nb2nttqTOTcdasKLx87PG1PZYFBl/WMYlnKupCcEt9lmNxwiOJfMXJKTKx2BkBavWszZWXIqff38QECUilYakSiHwUJ9kKJUjowodCZKZ6X4dnVohTGicfHqHnT9j8Wp2xfGktphahnCSh/3DkKxBZjfAAI4rgJHa/WC/a9r1Pd7rzbihj/jDVzDnnt2bVrsXLiKU1w/kdxROt05ZB7pDE3Ys2GQS1X/BWOFiVHcRxdd6kRQ0IWzairveGJIduAZXUjJnjnC5wP3IaNTeSHiyf7AcyqiDz0zPUuq/2ViYb1VjMz18kSPNHdmtyRyKxGEyZgfrgwIztkoOTb2T/f1nRE1J08pOiCQi4pX4sgVJ3/LoiaTAsjML4I0eiWW/Hk/tUuIGkTcoYSJyMM4XIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(366004)(346002)(396003)(136003)(451199015)(66476007)(66556008)(26005)(66946007)(6512007)(8936002)(4326008)(54906003)(36756003)(186003)(8676002)(316002)(86362001)(2906002)(6916009)(5660300002)(2616005)(478600001)(6486002)(6506007)(41300700001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o2Hchaw16RRbwZzup6lwLDX1Eg1tr3Gj2gilrCIh6xesdwIgUukmE33hNAGM?=
 =?us-ascii?Q?/1ThwyWpeCc0X+VyFsm267mZVdbTQH0arc0OnLsRZI2cwNU46wXc6xUcgBd7?=
 =?us-ascii?Q?IWCu4OW1Z24On25xtfc9RF72PzlTSuhFo/19fV4B5lXMBUvL0s+t0G+bGPQW?=
 =?us-ascii?Q?JITXTIUAGcxosRPRFIcuKORX3oBIKmszUsFa8U/enIVDlb4Cf14Y9B8MWAMj?=
 =?us-ascii?Q?iJ77McfzY2D8kJV8DfRqG4U+4qRiBiNw0cJ81Iq0dDy6dUQtL70+TT8QmH6N?=
 =?us-ascii?Q?dJ/Zi6qZ/9CNqjhTe6kQu71DA4w0lUgEyWTyLAEDVsgLyBZouzGZzxcrTMT9?=
 =?us-ascii?Q?Jy1bvciPcFV1OqTNPc20xFKEHGrDDlvHiZK1NzmqRevxnI/vujORQcLcz2Y2?=
 =?us-ascii?Q?+UKg6GPsCuQl/bBrlnNAqLEpdTAaB/kELw5eOEiyiLN66w0289wM51f5oyHA?=
 =?us-ascii?Q?1EkSs242jhFpCs1ipfGxO3r2tJbgBMlVHhMKMPcfTzcdAHLIS1y3l+89Re93?=
 =?us-ascii?Q?gq314xMIfHre2lB3Gi5+sqFoIpeNCXXAAgjzUsYdCYLHqh5lWoXJyoUMDMIZ?=
 =?us-ascii?Q?aYXCZm4ut8wBghyFM5m1MbjHx92TlMMl14SoonwJr9O+2pPG2v7PeK0ZAdc7?=
 =?us-ascii?Q?ZYcVPtPJJJiNOOLpA+w/z9Pcr/6Mgx6G1Jwjewv4k/yKp0zXJxydeOUvZ3T8?=
 =?us-ascii?Q?3fkPJuxgN6jrQrNsDoaapBUCc8/yuo6ErTLSxSYVG27ZXQiUqsXGNCa5XlU3?=
 =?us-ascii?Q?zEBpk2Aq7vL6DAsOpSJtdG69LWmUhWPO26OHehA35NSgVDJY/Bt5+LzZGhlS?=
 =?us-ascii?Q?xMmWvZADAs45zooU8hqbSQwmrqb2IrFt5jbSzxxtgngFBNWhtbVxxI2LCKWu?=
 =?us-ascii?Q?oY//UWadOsXjwBsDacfOLN5u59GflX5Icj7EPHEF1Uny2G34pgdKAQ3FZnX2?=
 =?us-ascii?Q?JzzBDo1AONlOlJ8uVaGPU/2QzwGLLNdNPo/HfEeFQIdMaycbaqTEUFZ2lv6f?=
 =?us-ascii?Q?ejmKykzZ1DWy7tbAQeqHoeogKfp/Lb+wd1RMRcGrPBECF6PKmEikEBhFCifY?=
 =?us-ascii?Q?UDz3bsA+rZNgQ1Un3NHDvGtaocvkR1b35qB+QTxN4fHEskv2VBJF8pRgI046?=
 =?us-ascii?Q?Nq6mUfrCt8guytkUCNM/ePYVqPLu8IWNTbKZ5Ft10Ej/CoOCckWxwvwVhvNa?=
 =?us-ascii?Q?tfxIR6QzQVX+09+iLnGd+SOgAdsGzcZLTCC6/GZCoVKMXQ6pygHLD44udhHX?=
 =?us-ascii?Q?TlUaWSlfjsAvHKL6Hqm9a2IElzPZ2fo2KVCl43DGBqZZtYHiS9PR3ZDhHh6p?=
 =?us-ascii?Q?1D0RA9W7dWMN0xGKh8g+KQh7FcDH19JHfnxAo91PBBQY9CmQUX/3XGtZUvTb?=
 =?us-ascii?Q?lMbl4OfozJcRmvIKwKmIkrIeJIWgo8m+X17Pkcy30uJU364PtOGLqlTP6dEN?=
 =?us-ascii?Q?GImtsYkaX7kN/K4MbUN1HvUHSE5HEGyGGr+Mjo9IF72ls46s0l4pYy5awi9a?=
 =?us-ascii?Q?U2VeG3CmY2NH6y2nynYMiGqINWa95D01KhTmdmytkQWhnGh/oXH+Mpt4WoiN?=
 =?us-ascii?Q?X27Xu6Jb6CwNFosTm2w=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ee09245-76a5-4fca-d60b-08dad3362671
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 00:51:15.4285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BY3+PnrrZ5IK3rGppQiA7DFDANFqiTvezXsdndmRbHfjRtiZizh/FzYad2Ar7vCz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4171
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 30, 2022 at 03:22:40PM -0700, Alex Williamson wrote:
> On Thu, 24 Nov 2022 19:39:20 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
> > +/**
> > + * VFIO_MIG_GET_PRECOPY_INFO - _IO(VFIO_TYPE, VFIO_BASE + 21)
> > + *
> > + * This ioctl is used on the migration data FD in the precopy phase of the
> > + * migration data transfer. It returns an estimate of the current data sizes
> > + * remaining to be transferred. It allows the user to judge when it is
> > + * appropriate to leave PRE_COPY for STOP_COPY.
> > + *
> > + * This ioctl is valid only in PRE_COPY states and kernel driver should
> > + * return -EINVAL from any other migration state.
> > + *
> > + * The vfio_precopy_info data structure returned by this ioctl provides
> > + * estimates of data available from the device during the PRE_COPY states.
> > + * This estimate is split into two categories, initial_bytes and
> > + * dirty_bytes.
> > + *
> > + * The initial_bytes field indicates the amount of initial mandatory precopy
> > + * data available from the device. This field should have a non-zero initial
> > + * value and decrease as migration data is read from the device.
> > + * It is a must to leave PRE_COPY for STOP_COPY only after this field reach
> > + * zero.
> 
> 
> Is this actually a requirement that's compatible with current QEMU
> behavior?  It's my impression that a user can force the migration to
> move to STOP_COPY at any point in time.  Thanks,

I think it is a typo

It should be explaining that leaving PRE_COPY early will make things
slower, but is not a functional problem.

Jason
