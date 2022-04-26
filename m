Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C05F50FFB0
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 15:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351234AbiDZN47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 09:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351232AbiDZN45 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 09:56:57 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2045.outbound.protection.outlook.com [40.107.212.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C8C15DD40
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 06:53:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XA03z5uHlSJEgaOYNup0d86chSk2owS9X+J2oSb9jD+xxDXm8OysUZsS9iJ0xINwCb10y8HZ9fMntiP151iVd2+LgFLzaV2ZSQ18hLZYUXatpYZ7yxiIKdPqOgAMgc/eVo22TGHOsdKI93LZ5Spvv39aZJso3LFO3LAajDRJsD7Xgu0zStTRgLzgtQ9AvdOJcw3xTWw8a1bqfqUd6CWVBUXvdnPj5MZgfItAyRK4XJF9asfBfTSn7jrrJKJnNgJO9ga1HL7pUGTxHozuAeIgIKGNO8COOTCTvgAO9P8RicHbugJyMpRPCZldr41LsOl0ruUlMjuO7Vm8ekmlXRLP+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NsVNCXMff1bsOVQl6xK+qCNXUijD8pmq+eRU2YNH6T8=;
 b=nyYHdB/W4r59kpe4gtFx/0hJjBLqKDujzzfMWDAkrByomMkLQdSWxWA/O8AF4agdvBTc1Y+3lKn1BGjFCpEZEKxKAL5l7hstYRiyN5h2cIVdVQrX7pqx5a3r7AtTaPA/mFapIk4pkLeSvMYPDoy5J9QaCHS227RNJrWuD94EjAjPlbOXSflt81xlwV+ZSgLOPDammU+kA5ru7s8mDWwJEAXQwpDAlGeg7SerWkb60r0pB+tQqXUsV7VrK5NXIOpDmXc9tqqPg77wATabUBHA1qn59un0MdyuQANCxqJ/OgpgSfIf4LsxmjT4DrnzLI1hCdyGx4o2HpbJ3R/0s2CMtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NsVNCXMff1bsOVQl6xK+qCNXUijD8pmq+eRU2YNH6T8=;
 b=TU0djGxaVLfGT7NnIUPptN/Mbx12aGr0eVfdj+xtiYJdv6uJFXRF+jFzYBASMWwI79QrmypXKv5LHI9NZl+LSQ5CL4SS4MwlTfvEh5AkdhXCHE0VtZ1m1k7TUr5qZkB9T5ktK/b7B7g76xNkMR8KM8q+8d8uVyL7tq3YgMg+ApJ7W5YX4D912z6sN9fhhU+osQgYPvQcxsbo+Zp3xXMyvy7DUhBpQZExS7Nibmg2p7xdKtdFqmCE31lwJr8z3CkVQ47wJKI1KI7sOd6NEaG18u/v2+8MYLHYYQFr+v+Pubooz/y4wpl4F8vPp4ilDcNyh+eYsUJJSOgOvALy7XS5ew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY4PR12MB1414.namprd12.prod.outlook.com (2603:10b6:903:3a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.19; Tue, 26 Apr
 2022 13:53:47 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 13:53:47 +0000
Date:   Tue, 26 Apr 2022 10:53:45 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "peterx@redhat.com" <peterx@redhat.com>
Subject: Re: [RFC 15/18] vfio/iommufd: Implement iommufd backend
Message-ID: <20220426135345.GN2125828@nvidia.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <20220414104710.28534-16-yi.l.liu@intel.com>
 <20220422145815.GK2120790@nvidia.com>
 <3576770b-e4c2-cf11-da0c-821c55ab9902@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3576770b-e4c2-cf11-da0c-821c55ab9902@intel.com>
X-ClientProxiedBy: BL1PR13CA0295.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::30) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6649dfc-3a9d-49f6-dd3b-08da278c2f50
X-MS-TrafficTypeDiagnostic: CY4PR12MB1414:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB141487DCFEADDC3E48943BD7C2FB9@CY4PR12MB1414.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TGR0XIpKuZoyAuyu9Xx0XN7rM7dfVrbfGzId4aXjazcWp14plsNgSeIvMdJgyoi3N10I0fJfPB2UXnCCxKVL1LV2bF3aUZ5Cx7pbK6wbjukfBlWuc1zEhr7Kgl5q40D+n7rCCmm7GlhMUvS24xL323YjM6FT8LI3IwU0/3Jxg6JJ4DKRNUZjHkX4USVeej43UTMgBgZTUwIstWDm04lBSMYtwqAiP9uoDm/GX0Ieu9IDAedTEvUrrfDu6Zxu7awDhXm8tg9fbiAHldp7rqzcCBUmQl4iTvvPFLCY9Qr/o10mcJVwsRMXxVFj2ibicnyPtmM5tgMQiclUmRNcWNzDc292uZ1R44dDMMD2VKNPKCW/OTplWxAS/GErfY+5WJEGjFwLSSLSh9UyWX8N6nwiOtR15ebJNAxk/AV4+sjuq8v11osPfF8ViWLaN0c1dqmC4uzZc3N2Wxhb6WgjnruOLa7mm3k+ftpoYoEbuGXqsl456NJFcidWLrGEXsBNlPx+aZZa/1xy9IrJBE7buIYElMfcoWsAndfbBT7y4/FNNCm8vh9TISG0t7AuT7LaYp7AI6pM2hIo131ydtEnOpu80XJahxokQyA+TvU7TmdA52j6c2p81iX+z8JyW/v7z3not6bRbU7ib24xw9TDWSfrfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(36756003)(6512007)(6486002)(33656002)(6506007)(7416002)(1076003)(2616005)(26005)(508600001)(6916009)(54906003)(2906002)(38100700002)(66946007)(66556008)(66476007)(4744005)(5660300002)(86362001)(8676002)(316002)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EYr2iiknfexBNuXw/I0cLd3YIb2xtsTVxfv5pgjiSm0VdmSKQ7IgA/Qi4Whm?=
 =?us-ascii?Q?1eZKGqd/hP8iYCxtekxwh0EAKaUab/z4ITG0hSGZdkoS5Hc3ZWGezxX2qduB?=
 =?us-ascii?Q?EE4j2V7iSqS3BxU0WGjJ8wEP3SEj9Xwa+ghZ6RRcaFTw2hwocghoF1th6AeB?=
 =?us-ascii?Q?7gzw5tGY/LEP648pMb+5GSxUYRknJQOe6Ij5KcCpgv1RluCZhkOY/FoExvxQ?=
 =?us-ascii?Q?wi2kI2fCjuRoGaHxeDQKL7bbWyazK6Gm/uG1KWkjHLRvulex+veDQ+US+45z?=
 =?us-ascii?Q?6HY1oZt0NuDELP+ib6idr0bQoH/q24Fy5cb0UZZeCX4wXp2szTJq+A9B/LYW?=
 =?us-ascii?Q?i8yz7SihJ94PgTBy/Du0bLivu+17eYEKWIsSu055ZUdQCTznvRnVRbprRLa8?=
 =?us-ascii?Q?JibxVFMFkx0fsy3W/aQWelP0TCuU9YQ9zF6pOD77V3+4OVKA12u342UAAPDm?=
 =?us-ascii?Q?oQdfNaovLbRLgiLKE6KsgofYDiDg+8Kz4+IgEh7bepqF6HMdwTHuq96InADd?=
 =?us-ascii?Q?8vL3ymWTalHpXioQN/TyOLzCD86iZn9cy99MqI5CrznO6PoogibRNj+D5V1/?=
 =?us-ascii?Q?JXnNDso643ircgJ3aOd/rp8akazEVuH0MddtxgmrtIANbuMJgNDBlldcmgEl?=
 =?us-ascii?Q?LgPAg9ZVWp0SdrBNZHLrVXsFnuCj/zutnt6V+wEH5Gw5zy31oFoIg/j+PaZq?=
 =?us-ascii?Q?behR9oMLTI2uTV83oeHPH9S4UCXs3AI/R4JGCPNEh/+c5FfjYdT2bbNcEJp9?=
 =?us-ascii?Q?JjMxvk7nJyS2Vd0N8z3wdF1EcyHgdM1U+XUR6gs5WKeG5ChcwwlVZIX94bkd?=
 =?us-ascii?Q?nC/ZrUd9QaQuAbn6K5pY1yAf3CX/IC0PQs/w1oMTmaUHbxQwU6AwSzqghync?=
 =?us-ascii?Q?mUPsQDlAol8Sk1mpxgq92VGYi2vP+TfJ8W/oBrpHfyXbvWEdakYUlrXXxAjM?=
 =?us-ascii?Q?r3JPaMdWVLER1H6LPdWH+qnhX1hu3xqbtJR0Lk7JuPB4JHuVzlgePa6kND0I?=
 =?us-ascii?Q?gGJD9wtwJy9/+VwrIHZiDsD39jFT1cNmhupcXFzG5yGNQZdBCSeyL4Qq+g6r?=
 =?us-ascii?Q?Tuc/sT4c2STxV+hFltcKOm9qTM5ul02IvMHyGD4bkdHqvsE51CyiKW7yU+Mf?=
 =?us-ascii?Q?nbiz6QXLYivHBNIFWDOt9wXOBNKSbZD1g3Dx/B88xlZeyAreMJb7rMEfrT9/?=
 =?us-ascii?Q?ol4EuYpB5+WrnXaX8wCE4RqjNhVLoeKqgnCL0zysq2f1hPdgFHLyCH77IYLJ?=
 =?us-ascii?Q?/1g9RKUrR1dMcvho3hd9fE3E8Iw9XRD3Z6Zk3JJxJbGQm2p0incWLLvdhQiY?=
 =?us-ascii?Q?rnVDgP0fCwLtHeJIxiVk8yaoNcaDfO6ZrdNSL7Yl/e+ok329qqIMuQiSHgy3?=
 =?us-ascii?Q?XXpXqdcmTNMDrOgoacbpyoIhOSsSvYOjRJgVxxwv9rIqgHUAMFF6mTu4RT1L?=
 =?us-ascii?Q?Hd2ZHdPklsNI+/7gV8Yyl0hxdNqzB6X8sK9CInORAbwIrxZj8j8noRjt+wJd?=
 =?us-ascii?Q?rkugr27CBN/2uwKXIXnK7FI6FUG6Pd8IaoTaFhncW76N4EKe5qhh95xAc0Un?=
 =?us-ascii?Q?S+ddp9jDBS8noMnsKc++Swai8qXaGJmWPb9clup+6/LQotN+XAR7jkJRhsxa?=
 =?us-ascii?Q?7WV5Go30JLouUcBNel8s73kdU0/Y27JhN8kfMUvANQWig3ijjGZmCb8Ghfj1?=
 =?us-ascii?Q?yPc8rpobih9BZlm78+RN/N27P0SixCNjKr6zbg/GQ6i9Jo9U6UZidfQM0kFj?=
 =?us-ascii?Q?wLUfA8pvXg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6649dfc-3a9d-49f6-dd3b-08da278c2f50
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 13:53:47.1110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jf3A3TM4auHoV07PqwPfCKy+waBPE10opulL1/mvS61FTXjqg85P/kC0H+RY2ji/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1414
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 26, 2022 at 05:55:29PM +0800, Yi Liu wrote:
> > I also suggest falling back to using "/dev/char/%u:%u" if the above
> > does not exist which prevents "vfio/devices/vfio" from turning into
> > ABI.
> 
> do you mean there is no matched file under /dev/vfio/devices/? Is this
> possible?

The layout of /dev/ depens on udev rules, so it is possible. I only
suggested it to avoid creating ABI here.

> > It would be a good idea to make a general open_cdev function that does
> > all this work once the sysfs is found and cdev read out of it, all the
> > other vfio places can use it too.
> 
> hmmm, it's good to have a general open_cdev() function. But I guess this
> is the only place in VFIO to open the device cdev. Do you mean the vdpa
> stuffes?

Any place that starts from a sysfs name would be interested - I don't
know what vdpa does

Jason
