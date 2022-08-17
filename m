Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9DD5973C4
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 18:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240775AbiHQQHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 12:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240714AbiHQQHm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 12:07:42 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506249F76D
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:07:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUHp/K3n4I9ZaDwYR4Xz+t8YRLp5Glmd4sFdMR21HYj2OUypmZTupxPhm3LwulQtRZu3bYk4a21zrx/r8R/fHMNdAN24GgHbU2GGVdp3myz3gMpYgFyoFw8XoKBGbJBxOj1YZ/WdE77mAw/nw5TdSB9+u73WxDJ0LY17gRSBJDwzeY/qfuyabK6oP/Q5dYso5Ynf90EAgn0sxoc/N9bT8KaRFCReIMSwcHPCc7uaS+X2lxDodDYKzUsASOooVU+fcq1b372ppvhYcjNo+kV8qmf/VroBsR5XXb19VZYaKgpKM9JgZaAY2R01EEshb0iRBGkHleDB8M47zvXEXviZXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WXcDNsuQnC0E8qlz26Ds0cOSqpouzQxXfzAuI4qMbPc=;
 b=l6NEUTIMeL9IxSxGoszx7I51fBGUaJ/fSgqTN3ye4UbK3q0ScpxpmLB7txcWEZc3iRiHbDG8N5V0OA/0YUyG86QBn8sUzuxfB/2TP7p8LYBgZsjtDPnDBmsKup9GqrjU9u0MKN8LpjpxcG5egFAzcW6zdf8IfEBIBFvdIruQz6lIvjqqrWoW4TWd2YASwsRicrFXG7ZiGsa5eBd+3qC5t4Z+aNSs8Uxpm1m5KdnL/1To8fpNiPBAuc8pkfDc2qp3ybwSnqs5mcH5Za0UFfYSsH1ikqzMvIUpzvQYnEwN4s3YKjUsOy8WBBykPjz3xEKleetLvlNP3+dWD7XOAOM9Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WXcDNsuQnC0E8qlz26Ds0cOSqpouzQxXfzAuI4qMbPc=;
 b=mJbvaveIfVYvWCAzNMjmdJIDCmoH12K/u0ho/ooNgCShQKscfPhj/510WmiD55CbKb94nN3AeLI2uEoOBo6vRTd69Sepf6CM1TmmX9E8lvgXlWPnthKG7unDm9OLFX093Xq/29tPRBrGIDdKE5tVc7grjE/3Pmzznp5R3O+Br/i+o46DlWIH7OOwkugYAs08t0GVb+SF9Vad3+6XeDoeWwNHlZgjdaKe3SXAmzaFLYmNDOmWi/91jnKstku1mwYT7bd5B/aTdh2tQ+Pt8O3wC8L6stPWCEjGWqp6xByVQuXlw4//PnajCa+Vs02oAYq3DiKuG/pQagzutw4IeCtEmA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY4PR1201MB0216.namprd12.prod.outlook.com (2603:10b6:910:18::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.18; Wed, 17 Aug
 2022 16:07:29 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%6]) with mapi id 15.20.5525.019; Wed, 17 Aug 2022
 16:07:29 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: [PATCH 1/8] vfio-pci: Fix vfio_pci_ioeventfd() to return int
Date:   Wed, 17 Aug 2022 13:07:18 -0300
Message-Id: <1-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0062.prod.exchangelabs.com
 (2603:10b6:208:25::39) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a7b0b9e-7b26-44b9-17fe-08da806a945a
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0216:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tD/tdQiKPC+brCbEBA+/RAupMQ931kmc2hbPFSsch2RJOZWcNdl16iCfydrRY7xcXtfFU14bdGOsu+GVd9OoOEfqq11AXFkpLcI7BJ20JXLoVhB+fteI/82JI1ZKi0sogtkhWtUSb68HliU50X5Ww7MM+s+pZozcuPdDNPfTgAvemb+nDYGr57ZrZ0mbr/veibzzN2lPf0VV3KCxCNVOWl6SFNGdTg3lI41ICze6IITq1R+k7BD5kOnHk9huAMmzPheLzxfySHj+oLywe0XQCJXqJtWUbmG+cSYER1MwL0ArScInnzpyJPcBYWNQeM1azuBtCn6SYbR+XSEQ6wWAbGpqTvWNWQaZ0LXM2VZy2zUKP18TxEloAxwj/nm/TLfs5eau3OgnvMjmQqOXu7y0woV4Xb5Rss4N9dYZncp3NS4MWxgBpkT9ubbOJ79dvCt7PygAs0amvfv+MwR0HZDroytX6ylbOWOwYe1FT+HmYuuAYXBarItsZBWK7shrRkjGhf7uWFQ4xuVt10g5Mf+YT+KHt36a4jGkM1HCCjlkeTrywMZy1mlP/Z7ENIbI3Bkl3vNKBksKVl5zZvjneao2KDf2kiz36Iq5K1uY97HEfEmp0qWoIq3QHMFG60HZ6zX8ItSTfparBkHjJWq5zB8Zu00WNcAZk+pFjxONZ87UFPlSDv0KR0q4PDK4o/xreK/BYFYIskdJOIjUC8EgVY+KoBvrzv8lgeo94BaKiTl9+G2PSNFRgFAn5T1g+9KIVho3rJ2XLnsEJdEoskAwx+4qAEg13RfrUSrbKZewiY8IMzU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(41300700001)(6506007)(6666004)(6486002)(26005)(66476007)(2906002)(478600001)(8676002)(66556008)(110136005)(36756003)(86362001)(316002)(6512007)(38100700002)(186003)(5660300002)(2616005)(8936002)(66946007)(83380400001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uXB96kVrFeiPQFSCcte/08pVHsyodelsaoFZ1Jy1IeNoukWsNz3G54XcF/2i?=
 =?us-ascii?Q?2XEOOwFsh+KG6P7NsPuRXZqun9qPCebCgzq2YvH7iaXxw+8iONedh2+Tpdcc?=
 =?us-ascii?Q?wVY7LT3EITP7CiM9PTk2WnxUw58oN6jtemOYRnjdbW7Wt48Ai2mpwUve8mJQ?=
 =?us-ascii?Q?jMr6CMrB2iolqB6yvkWqYFKBSWvqzbBPrNGMtEQx75Yr0aRVtDAkc8lk0jOM?=
 =?us-ascii?Q?atW5yV4PXCi6IRJh9v8fKMNZiLx+zq5NUckJfzo/jRiOAvIZ2VZtrICtf2zK?=
 =?us-ascii?Q?D8MS8WByTn/lv2XZA0juwLA1T8KJgFNfYqQOHH7Yb+s0V1e6ua4wFoamRxjK?=
 =?us-ascii?Q?sI1r0IdxUbET1OkqZhCApAMHiF79wf7w43Oe9CHzXxU/M76yJvKiNHoIwf3E?=
 =?us-ascii?Q?M4xWfDrqozEb6/DzUGlftVWuYIJaKjO2BL6YZyP5rEzFnV8Ap8gpmKx1Hvm8?=
 =?us-ascii?Q?iH6mbTQXZhJVNpR+7ERZ4DwOQHxYMj+VXkykglHbLgWJ/j9JHXfmSQVNlhMi?=
 =?us-ascii?Q?AZOoTEUBvfL30Gd8zY5lk41li6f43/OQAUa1Aqed6/kP5hzolCXelcQpRN/K?=
 =?us-ascii?Q?mz7qQQQyAJnbpu614G48cTLhsTuDmMfDiucyvgsAP5wgQRYSXFsya416uLp3?=
 =?us-ascii?Q?cysC9XV+TsRCanPIDSGGShpvscTFO2buPsbFcYyFNy0KsLlcGWy07aWunf8F?=
 =?us-ascii?Q?3fx7mqgB+XgHzFzjmfCf1/SGo1gGcVMpqZOr2SJjREBz4r3OLNWs7PgEdKdf?=
 =?us-ascii?Q?tidIqURqrVSK84TINKLqk5/RgTNX5oo/N7RRXGGoqOxwAZ6tI/q5l8uQ+IwQ?=
 =?us-ascii?Q?Wnay0sVT6S/UN84+4Hy54cvNeG+N3jg2rDG7vVsajRi35YuP88153BuLEFqQ?=
 =?us-ascii?Q?98u/nX7UoE6DWVJRxFfJ/Ua1ukx92IkdXGtndp0AsQ4cO0aYoQloE4CDsxBn?=
 =?us-ascii?Q?Z29iyNYfHAc56UjFw/ES4AP1902zbE+EPntiPPFYYqVMR2b2DN/SPDG4Luij?=
 =?us-ascii?Q?uqtjgck129B+qCggXJmgei07ApBXi/BuRyvEIy8f0A7/8ZPr6wOZh7bnL5cP?=
 =?us-ascii?Q?/rIc4INYis4sYObsfWhbp/NtZ2jzk5CdJDTLV4mpJhAZXGspb9rxcr9cbNNP?=
 =?us-ascii?Q?SHEDc0cq8Fh0O5jO1iHXMdvZYzLS2pEafG667/7/A+J+bkbdLN/2E8igDq+L?=
 =?us-ascii?Q?k9LTlMIfERnYKglVNAV60MHuQ6qV8CKelin3DYx+DtYR4hcCrCvaFrBd9nHP?=
 =?us-ascii?Q?201V6i5V/SviQdC2HM0oP3ZePIRX7OzZFZ5zdAIftkl06NLHZMEIfvnYm9MH?=
 =?us-ascii?Q?KD7g9A9Fm32DJSVVB5m1MHKEBM7mvAh3znWM8NBWCok2xh5MD91baz7AkPtN?=
 =?us-ascii?Q?KTtuOBYllmxoxtBgPSfb/ZEwWmET/xAlqmnmd+U/xud6rstXPGhOlHhzMcXm?=
 =?us-ascii?Q?iOZnaaZdR4DWHZCSQcywHTPDeiW5dKXXYbWtg3RkYaTjQYKnoOG3jdyUwzzG?=
 =?us-ascii?Q?Qx8ALbMCtc4wS3MMVBWjbSEXiLrWONfNhEvUT+ZKGiaAVEimhD1DNRU+W+78?=
 =?us-ascii?Q?N0Re0mlsNuJsKNgbITKJ3xTYXlATYBGBqqsM2yGa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a7b0b9e-7b26-44b9-17fe-08da806a945a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 16:07:27.1104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GU1oYdsk7ojUtUrwEFxAiQL+9QJKsV4aTRDYpclxsFiAAYaG2cnWY1XU4ofA3JOP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0216
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This only returns 0 or -ERRNO, it should return int like all the other
ioctl dispatch functions.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_priv.h | 4 ++--
 drivers/vfio/pci/vfio_pci_rdwr.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 4830fb01a1caa2..58b8d34c162cd6 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -48,8 +48,8 @@ static inline ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev,
 }
 #endif
 
-long vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
-			uint64_t data, int count, int fd);
+int vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
+		       uint64_t data, int count, int fd);
 
 int vfio_pci_init_perm_bits(void);
 void vfio_pci_uninit_perm_bits(void);
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index d5e9883c1eee10..e352a033b4aef7 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -412,8 +412,8 @@ static void vfio_pci_ioeventfd_thread(void *opaque, void *unused)
 	vfio_pci_ioeventfd_do_write(ioeventfd, ioeventfd->test_mem);
 }
 
-long vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
-			uint64_t data, int count, int fd)
+int vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
+		       uint64_t data, int count, int fd)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	loff_t pos = offset & VFIO_PCI_OFFSET_MASK;
-- 
2.37.2

