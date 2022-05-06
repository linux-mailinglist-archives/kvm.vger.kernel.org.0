Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840D651CDD2
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 02:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387543AbiEFA3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 20:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387482AbiEFA2x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 20:28:53 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2047.outbound.protection.outlook.com [40.107.220.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78095DA71
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 17:25:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+cKp2uCuk7oP2oNuTMsdPnL19WEV9yjjFCi7NzJbCewtXtpGODpGhBHH8kwGVz/2mUY7jxhOIxuI+ZKu80TLFRT69+dt4/Ns+CR891phADy95vDBdPxMmOkzlR0pdHysT95T0ia/vH3XiVnEvMSuGlFSTlV4JTQRv9IiVMsmV+tTzlKa3OSbItRf/joRpIK5WXTxhOgJERTV8z1V725oozE+qEFKoFO/4TjISEmHVouqGY1HCSLrM7T1XRa1lhrTi25MRHUUqIfSKwVf/I5iMSHKzWQRMyzDmFbLJdClr3x3IexV5O3MmRy/6eqNBgw8MoYpQJWcF/ptqLShI7u2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0IzOnZertbSGl8qvE55tx4XxDpu8E4pmz9qjPqNqO3Q=;
 b=IQnLp7stEdGI8qVyWhxLW8EqrZm1kC6TwDw5B9vwaPT0ZlpWadYqDfPFnnkCDz59LCqysJpPbm12cL0BamqpB8QAUGjsHhFUZ8cBVqgqwyzRdpNSw543QTVTCKN80k6QIkCv0Cz337OQS2HXN8wRgvkJF8r/uGevb9cTx9E2j0an9mGlNJcjBEsGH/XrZTT4NBHmeUUOLeOSUYSRFzEVnsat1bKjfvujuAl0lb3LwFs+Wu6QIkKfD7jxIWMVcy/Tin/wfV2xXFYwtqzFc1jmPPKpAE5AACo/NxPtLq/V1elKNalo9NV90dA+fqxy9WwqLDakw3iRh1KrfmXJZPudUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IzOnZertbSGl8qvE55tx4XxDpu8E4pmz9qjPqNqO3Q=;
 b=CieQJe97KiGI2f+GkjS5cH1E7exnpGfvXrvEG/H4fX9bu3KA2cXDdO1xjh+B6HLxJBecVht4Aw7+6FInWjcfoAkjFuVqcuH2nz0jh5dmpK9Jqbws2XFJbGmGFLcG3eRhkqjQT9YUy5MU4oBZPCh3QJAW4sf/u8soY3hw1WsvrKzVjHDmlD0JU2xpFuNCPJc6Tzokuz4eggSTZ1iUB6lVuu+GPGj09YR/5L0juFZSpTh77IpH4TrnLPSMjnJnJC3s9Ro6xbGOZmXnAUKFb/3Fx0SUsVksYNjS8eo9qby8gqyPUoU3ONVL9Tl2ApnJ/3mmdEod1avvLEBiRiztMTVFdA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH0PR12MB5025.namprd12.prod.outlook.com (2603:10b6:610:d5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Fri, 6 May
 2022 00:25:09 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.027; Fri, 6 May 2022
 00:25:09 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 0/6] Fully lock the container members of struct vfio_group
Date:   Thu,  5 May 2022 21:25:00 -0300
Message-Id: <0-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0046.namprd19.prod.outlook.com
 (2603:10b6:208:19b::23) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0bb9c9e-7117-47e2-9615-08da2ef6dfff
X-MS-TrafficTypeDiagnostic: CH0PR12MB5025:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB50259813CC118F70269842D6C2C59@CH0PR12MB5025.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7vjzuIz/bEPZ3TVShATjxHESVcoZKTXQuUptmiyEteo3AtxkSLZmOKJteM/OcajMUEMp0UquR6y2yVQPScVK5nIH0QzEyXkRU6L9EHcW0/6F8Hu2vOpgZW5RnN65nkgSdOxzLwYG0377UVc3y0YlAr3woA2IBqyVk9jy2qGDjyYHRX9Kq19NBPWcJJ50f8tKVrIXunwtCJIzjj96EpIq8zpJAzVtlRAMb+RiYmMc6P4jsAloDxUuwrvBdm0CnADwSJanuq90ixpbgGoPqYp8cpX4KKjyjk/FAg0t2DWUEDB244tKyNBbkkbbZTDwgJrsqe4WMghw7cKiHVWqruMbmZJUUnnoMKLjrCyJ/KiiEQvtiuC/AY3DX+77ySDGYBERAlYvnHh7EXCSxiGEcwZJ53BwxQtoMgfmfvn8/yKxm50emkPBiscQXhySU5kLPAUc9MG21avTflw2LblcQUPY+2drZjOxv5wVxvZvlmyFlKqS6JtOKP9vLY75DWfon4OyIIyxbhEgIGAlrUcvWJ+VUM4ZGVyfjivfaGkgzkD4qx2/b9pMPWq8nF5Zy5RBGpkCG+jpTF2JUngNjmjTjYuDciBENAZZQgqGGCy9QomYYaEF6GC5BtHivGg7+rleIRdG/NYfKlQD1IUxAgW3ufhFiwtr1/dyJAXGB3wc3cCtmRA2TPSwj0COR0ZfoI0BiIh5UUBu3U9uYHPaHpZo1SissHu48uOeO5bdjvsTSrYDKBG3AAq6NezmoaNIxSCQeMUuWGMlh8CGVs2rjPNGaNg5rA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(54906003)(110136005)(38100700002)(316002)(2616005)(6506007)(66476007)(66556008)(8676002)(4326008)(66946007)(8936002)(2906002)(83380400001)(6666004)(508600001)(36756003)(86362001)(26005)(6512007)(966005)(6486002)(5660300002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HPOT2tvLOBRClfogeOdtyuZFu4w7pNpr51JSvdDwnIsgdnwmQZbRAKt70NJ9?=
 =?us-ascii?Q?agdM3Jic3DrmPdrSKcxdh/RlvbVCRGuyKQ8jfPDMHZwuqmDhaZyPV4l8Yb9B?=
 =?us-ascii?Q?cE7Sd4vZ6UU/SbyAWYVlYPNCr9u+1UKvL4SRZD9vrpmiJLMypmywnn+GfyJm?=
 =?us-ascii?Q?oC0Zb4OD7RXmXSyAbZ+lOMKvmsVtRnhDaBlEbpaxIE7/Akm1J8xkfAn0nDDu?=
 =?us-ascii?Q?/SrAgGvIznLCW0tNka5TXjYvye+xjpPGemS5l+SEI6roO0hdk/415JH+/gu6?=
 =?us-ascii?Q?j21UTD3p3T60EEIfHiYMY9fSQHh1eWxqBKZVfBp1BBTLmwoZAqal2Y/2LJQK?=
 =?us-ascii?Q?Z1FXtiNBvY4LgLHioY2Ldo5ByxcOBrvb//ZV4FR4AC64iY7O6mDglACbR4Eb?=
 =?us-ascii?Q?WTsqmv+q3VOhqpLbMqtccc3JGJDSXqYzoJEoz+dj913zw5dadr0X+osz8p8f?=
 =?us-ascii?Q?HwrgxavUxBJ21tTo0nuPBmxLT6H33DAO7wpZ+n/SORM0NaadTVMioM3mzKFb?=
 =?us-ascii?Q?XyExFE4822GwqKGS5pq8rQrxwttRkvuuzCguWO0az4LmTzTd10FHq3uP6qGD?=
 =?us-ascii?Q?Z1zpK88xDYaTI9K+9Ay7wiCeMnptGirL2IKLE+4t99Z+tG7kcC95xDLYTKkp?=
 =?us-ascii?Q?UJJ1dBA6P9bS2X5p+oMlOiB/DdXTdX41TMi1lGsGDYQW2XD/u5WtUtL9ruGU?=
 =?us-ascii?Q?aO4e1eVth0p1OvSPWij6Ubh4/E4eh0Qz6T1ARWqLNNqfx3pUIfMufx+HRBQN?=
 =?us-ascii?Q?dxrKmTpo5JCYMujpxEeLsLRyrIiRCMurmKoMxDp4WNf4cnzE0U3RjOVouDmJ?=
 =?us-ascii?Q?BBt65stqfZ5dyQwuKX1s5YanatmnTZFlg95mtqHSq5Ndotv4CeX3JCxZKNrr?=
 =?us-ascii?Q?QhZtSn/eZEj83V47a20mdudzyVpGi7rQTgE2F0+EJBX+jmcRf+qBmN7qopEQ?=
 =?us-ascii?Q?sBIKSa3KJ4I2xLnbWrLADRHnk+bg0Y17zb82vvXZJQg8vcUsTSdJNYTD0UEZ?=
 =?us-ascii?Q?MbXEBaRhRy1MzX9vWB8AnesYcgW+rI/6IwRWiC2JEF4DHlbVag4wY2Iv7tyS?=
 =?us-ascii?Q?OajvJ3YqV8SOEozqC65rgXbMR+25FcAfTLxZmbjoiyjNP34/w9SBYFFMujC7?=
 =?us-ascii?Q?wqD3YGQI/tLDKkHNxDRs/CCmDL5KUURJKDGLV4G9hujRTqggtqMgyeNSSV4k?=
 =?us-ascii?Q?3ct8bJbggnx2uHzmaoespr5RSltGtziwAJTGgjgT36q5B72140XFuGLsuJ0a?=
 =?us-ascii?Q?dw+OsrQImYNjW3Kot/N9gibZbzVjiGKhXIue3wXwk6bvmA46gUi3FW49I5Ha?=
 =?us-ascii?Q?/hRZcp8H9HF8hDcb8vWBEHtkCZR6m2q+31pEC5u02/C48GH/w/wywYREl5rh?=
 =?us-ascii?Q?3xLt91ONriFHphkp69YNWfpQTT9QrXnQ192/CX3tuluzcEb+39EaHzrLp7g6?=
 =?us-ascii?Q?WUWsd21ofGhx8C05ADleeWngONTbNIvJiZeWPAHb/C5FDM6j7g8wBuQmNNNb?=
 =?us-ascii?Q?G5ovU/lSFOy1Fsmz7lM8pcqb+f1aSxgJtR9d3ImCZ5KQ+rd3gCjXeN4o92mp?=
 =?us-ascii?Q?gjOf+N1QG6X/BzCZn7l33swb5/mTXYYHu68N1PjNbLFcFJX8dAlx/MLqBXhP?=
 =?us-ascii?Q?q6W4R0fvNZCUGSFh94l56DZLEsklBGrFoy6bCCFFK+GrnPyCkViklm/P//4O?=
 =?us-ascii?Q?RgWWk68QNY9lG8lNzCtzXH7G1MJjut/WIA7MBC2CB03jOh1SkI1KFnI7Iysh?=
 =?us-ascii?Q?oB8bBB02uw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0bb9c9e-7117-47e2-9615-08da2ef6dfff
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 00:25:08.2498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P+n1lFgu+VLoZn23ECRbfIO9C0BFIO6cL04T8git1gKhWTQSFjj8TIa1JURKHtvz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5025
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The atomic based scheme for tracking the group->container and group->kvm
has two race conditions, simplify it by adding a rwsem to protect those
values and related and remove the atomics.

It is based on top of all the series thus far:
 - rc3
 - vfio_mdev_no_group
 - vfio_kvm_no_group
 - vfio_get_from_dev
 - iommu series

To make all this work removing alot of the container_users cases was
necessary, which was accomplished in prior series.

This is on github: https://github.com/jgunthorpe/linux/commits/vfio_group_locking

(which also has all 82 patches listed above)

This has been rebased far too many times, I've checked this version and so
has Nicolin, but it could use a careful 3rd look.

Jason Gunthorpe (6):
  vfio: Add missing locking for struct vfio_group::kvm
  vfio: Change struct vfio_group::opened from an atomic to bool
  vfio: Split up vfio_group_get_device_fd()
  vfio: Fully lock struct vfio_group::container
  vfio: Simplify the life cycle of the group FD
  vfio: Change struct vfio_group::container_users to a non-atomic int

 drivers/vfio/vfio.c | 273 +++++++++++++++++++++++++++-----------------
 1 file changed, 166 insertions(+), 107 deletions(-)


base-commit: e50abb9a762947bd0b9ffc73b7e28e5523f6eab8
-- 
2.36.0

