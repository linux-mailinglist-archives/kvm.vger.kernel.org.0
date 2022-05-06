Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0FF51CDD0
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 02:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387518AbiEFA3H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 20:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356706AbiEFA2x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 20:28:53 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2047.outbound.protection.outlook.com [40.107.220.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190BD5DBD7
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 17:25:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a+JoR326NK1Qb4dIlDQDopc7clqxThFDespbzCEcLOXPGwrZ2Kt0MkRbXzODfBabHPHRUynzlIcvEmqFcv7YlkvtigGTELu7W6YScXZxE+iIvTalc7CJB/zMvc8gCPuJCwcA7omSr73aSHKUuG5atryc5gP26HqbkpOI8e+q5u7BUFCAyGSRHP625hukf0pm7EzCXk+SaTpT2LLNIYnRthLIG0Yr2gZIFJ9O03Sia1Pv54pI8uz/TlD/XU2pzzEv5a80Qr4AQH1qG4ieCKoA4LHxPXZrlFSrINJXyHHg5FqVRmENG89ZUFTHxXzC/ZnjL+2iLXkMA7pZ3kbjjbKw6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8WMbkknb9ZyUJhDAbhQ7gSB+jMYK7lrrWgBH/9rqm5k=;
 b=XTgkbj4DTrFu1Am8QJoZZiVh/RrNX4+BYlZNY2k50/ky0ngDL6npajel2ZxxmU/WaxLryUcfjSssRbbgM228WK88qk+lG5odcRlxyfujBPEDwXP2NQzPP6sEBVzDyrxl+J+Q+/ttaLa/RV2socg4rt4cFnHkuF7zvBf9flhjdWoyUq+ziYCDPzHV6rtGbc1gp6/H/gS1QHuEHRUudHADy6ilcNI54iABYcNjhLkaPcv5LxgXbqozhSNCbTTXX1Ps17k8UvsIFelGNCcXDXzi9HM2au9GfkrSycDkzTRehVQYtIIngN36oCBCtVjtE6Y1Lw4c8C4+LyVi7licUes1Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8WMbkknb9ZyUJhDAbhQ7gSB+jMYK7lrrWgBH/9rqm5k=;
 b=W94u+zsFtvCXx9N8trpezf4DYlr2HFqG5H3KQDWHuVH901mQ+Zwe7iVFGV/7waS5R+PpjbZfo7UXmI6Hwuis9YinlCZObCSVUvAyht1steU/vHk/XODphIOiqFynB//kTsZitKWK0b9SyP4tls3TSFtzQFLNdj4fRATL8xVAxh3NnysgSmbjwxEBz1s9R4G2w/7cz/VAr3mK5vyN6xh5i4f6S/N7mBr8fp5SSkm/rcqXLev9ZnecFnNpDH7Mb5+2NoQRbWS68xJBac4/f2W0vCaTAej0/nrr17auK5tnWf/KOlSN6oAJ/5CSEgRmjvUBGn6+9fNRcvPxTE82MlvMcw==
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
Subject: [PATCH 2/6] vfio: Change struct vfio_group::opened from an atomic to bool
Date:   Thu,  5 May 2022 21:25:02 -0300
Message-Id: <2-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
In-Reply-To: <0-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR22CA0021.namprd22.prod.outlook.com
 (2603:10b6:208:238::26) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c08ef7a7-1cd8-479f-d387-08da2ef6dffa
X-MS-TrafficTypeDiagnostic: CH0PR12MB5025:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5025E739DF41968C85B29ADEC2C59@CH0PR12MB5025.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8LqhsgyAPaCNkza8xpXw7EHk0c89mSQMMn7lu3/X3C775hi4uuCuHWkZWknDib832KnDGoH/xS8gwDJWYnAaVKW6cmr8rPKUDXT7s6Nz5vVGQdm+J4U+owjZsL796wkp60DegHFsUKGInKJ/8mrYpQFcRtg0RMbaBqRMDKDe9ee9Ob5ztNXRa51zqgQpfi6RfsoVbBmTTVnpBkXjsKGtBpt6u1TD1Gf4tA1EdzjXhpCjmG9zQI6gThwburtglic44qMInKL1CwczOheOs2RfQEZGFYa68/qSWKNNFXKmN/yv4XcCzo5IE8XBZZmezDEQfNi1Wgvn88aps7KXMsVoW6X0UyJnooAWkcawx061gk4YEZMNWqkK0oKkAKel3NKlGz4Es0QKirRlXjbFP2qI44Gc5zMGUlk67ypKjKofpt2agJkfrVaPUtY6s2o4F/xhqEPv/DoZwVSACNKQAB4F08oOtf2db+qgWvAG+5ExwFVjpSb77M6X+AqH5mAf2dkVjy3RrCZlhLuMmq07kXDTvpWv5SJdfC35Y3J3ccCBKPGqmqBBkOL6R9MBeg3g/yQk/R3DLIS09rGSfi8F1sLQsUN72nNSAUIcydIipB3dhY/sKeSY0Aw4UUX458jxZRXdgOBGDLvTuomri9z51YMtmFLSz3ReCx05L1CHLUlfQrXNsRHgjD0yPxjcCXleplUf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(54906003)(110136005)(38100700002)(316002)(2616005)(6506007)(66476007)(66556008)(8676002)(4326008)(66946007)(8936002)(2906002)(83380400001)(6666004)(508600001)(36756003)(86362001)(26005)(6512007)(6486002)(5660300002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A/sdOXCVbZaguYGZ12/FBI0vIakx88P7hxlJ8NXIv1pL+b1RkAY80TsGjfgC?=
 =?us-ascii?Q?sh6vXUnlZ/W1K9Pdq8sfZLGcUAbZAJa1zdEtnUyoKWDXFuerPYbQazEq+ysM?=
 =?us-ascii?Q?QlerrtQG8/45QR3s4oAQ2LEidvykPiS9p5HqYWqhNuHBfJkgAGQuU79FmLDr?=
 =?us-ascii?Q?ksKvvPead2qMLC6wls7cz9uD5q38FqwfSrpD3fhmCYS2ejq/WrkodPGsAqh5?=
 =?us-ascii?Q?A7tbMgZ3f1uQfjCTWvY1r6VkJxfRlONQYfiNCygw9QqOwRrU5x1RLaIYcMpf?=
 =?us-ascii?Q?pcNp9U8Ukj8KgD3qF7Ced4Z8EBuXWQ4TT57P/WSqMp3DIIahm0vH3A5RB1N9?=
 =?us-ascii?Q?iehGvF/47RbXTnfgUNnnUtkc2+ZP3bOCGENdI81h66EpGPwM4gfuYMtX3rU7?=
 =?us-ascii?Q?UpzNyURTE+WT+nHr7cSVwnLX4SjkwLDqyqtsQFWlvaXgm7InDtvnD/6zM3wm?=
 =?us-ascii?Q?DyoK4adwqwRhOEJKX6t2pBGG5CjMemdhV9mXRnGLGCZOzrcuiWcnP4bgy9Fw?=
 =?us-ascii?Q?nhO/XU41MUaoiSYGbANLXvpKMbDdHo29oqS5Z1Daa+yAlzeMTcLh7u2Kn7/4?=
 =?us-ascii?Q?TZGbRfVNsr9Rr4sRTpUcasyG6/Gyjkjk6wMURU/otHDzVNQPqWGb52KZvdgJ?=
 =?us-ascii?Q?2sWMkkFtAD13Rdps8ko9LjRHKx3kr+mWDy9zMVI+StudemSRIjBPcyqfY3Vq?=
 =?us-ascii?Q?mjIUGoWbLYrdtZvbO4RBqvqmefI0aws8jEddnjxoFH4ifr9mW3g9BDR8TX9o?=
 =?us-ascii?Q?jIOFToKPzzapG/k/6Qjn/dCJqwsy2vCY7xGA17L5Pqt5k3uSDVx0sw3Xz5qb?=
 =?us-ascii?Q?akAIjVPlYmGL1OFaAOdEtK7+WV0fSadGozB5QpBCuFxLpZuRX+dBEGDT4Sb5?=
 =?us-ascii?Q?w3cwI5wqIrrV4BFqxi/WCXFRFGM6QSqglXe2u5WTrd6K2cZLM3STFTFlQ6Fu?=
 =?us-ascii?Q?KI4rVRRlpX0Y0yNPLyyDR3pFFduFuKusPCLZFpDRQAX3E/P1aBdYVnkE+3yo?=
 =?us-ascii?Q?+t26NV1wRNr2a84D47/nbU09uKzIUkyXwdGj4XYKswMPZnowjyFKyNGmBmfV?=
 =?us-ascii?Q?AupIrQ+9K+9PD7rQ/z3hk4umkYgM2hPIStR1kB6/tPLra7alQ3nvOCT/++DK?=
 =?us-ascii?Q?0HqO+RMXRvYEHxax3SQqx6zsv5lySZtQMZgJJ8QkBa5XKBi4vsUFkFrtHgpX?=
 =?us-ascii?Q?443gxhjQpiKH2W7W8TUtmwyf+y4Y2WFoYWBgiKIuGz/giX29maRJ2Ltdd54E?=
 =?us-ascii?Q?XNyziatc26uREwjLbGU9xiDgFC7nrtHHviUOXw/HctHM8Wpb/I8/pQd5zAys?=
 =?us-ascii?Q?QxXym67k47i/rfoLShIDMc/7Pfp+jrNkwnVhL8LJSd3A6R4qaOpPYlm/umZd?=
 =?us-ascii?Q?w05LcZFpQnaSaxjYNtLTDY0JQAI5kOiqOA444L47Cjt5e+iget/PErzEfgvd?=
 =?us-ascii?Q?0F/L2JkOstCw5Gnu0n5qZt5HjuGKKUEthUGGDFrPLH/ymBbvO9ospsqFRfqf?=
 =?us-ascii?Q?OvW70UPLXSyvykq7YEjLxnHT06jGfghMe+qoHKisTh+gJ9n03mswz4bj1muZ?=
 =?us-ascii?Q?E4KT0q7wboe2hTciYuzzaxeBT1Ucy3f4kVdjQ/fj9cpFqwT+1ax5BVOgfDuN?=
 =?us-ascii?Q?XIlbTpgP3bJZud5lbmhdNj6+RQqXxyj10DBZS1wPfSeNUzsF3au/enbDd/mt?=
 =?us-ascii?Q?CIWSyaEyX5LZkwPqbsNC/TOc0DZ/PRQqM2WdVQwmyP0XeqAKQedzgxFYhJr3?=
 =?us-ascii?Q?/KVrAndInw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c08ef7a7-1cd8-479f-d387-08da2ef6dffa
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 00:25:08.1873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UkVvhwGc85QoW7MAqsFPqjwYvqY5gmt+DTqFYlAg2CvU4flgW39y2oqTCe2osUMc
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

This is not a performance path, just use the group_rwsem to protect the
value.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 46 ++++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 0477df3a50a3d6..a5584131648765 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -73,7 +73,7 @@ struct vfio_group {
 	struct mutex			device_lock;
 	struct list_head		vfio_next;
 	struct list_head		container_next;
-	atomic_t			opened;
+	bool				opened;
 	wait_queue_head_t		container_q;
 	enum vfio_group_type		type;
 	unsigned int			dev_counter;
@@ -1233,30 +1233,30 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
 {
 	struct vfio_group *group =
 		container_of(inode->i_cdev, struct vfio_group, cdev);
-	int opened;
+	int ret;
+
+	down_write(&group->group_rwsem);
 
 	/* users can be zero if this races with vfio_group_put() */
-	if (!refcount_inc_not_zero(&group->users))
-		return -ENODEV;
+	if (!refcount_inc_not_zero(&group->users)) {
+		ret = -ENODEV;
+		goto err_unlock;
+	}
 
 	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO)) {
-		vfio_group_put(group);
-		return -EPERM;
+		ret = -EPERM;
+		goto err_put;
 	}
 
-	/* Do we need multiple instances of the group open?  Seems not. */
-	opened = atomic_cmpxchg(&group->opened, 0, 1);
-	if (opened) {
-		vfio_group_put(group);
-		return -EBUSY;
-	}
-
-	/* Is something still in use from a previous open? */
-	if (group->container) {
-		atomic_dec(&group->opened);
-		vfio_group_put(group);
-		return -EBUSY;
+	/*
+	 * Do we need multiple instances of the group open?  Seems not.
+	 * Is something still in use from a previous open?
+	 */
+	if (group->opened || group->container) {
+		ret = -EBUSY;
+		goto err_put;
 	}
+	group->opened = true;
 
 	/* Warn if previous user didn't cleanup and re-init to drop them */
 	if (WARN_ON(group->notifier.head))
@@ -1264,7 +1264,13 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
 
 	filep->private_data = group;
 
+	up_write(&group->group_rwsem);
 	return 0;
+err_put:
+	vfio_group_put(group);
+err_unlock:
+	up_write(&group->group_rwsem);
+	return ret;
 }
 
 static int vfio_group_fops_release(struct inode *inode, struct file *filep)
@@ -1275,7 +1281,9 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
 
 	vfio_group_try_dissolve_container(group);
 
-	atomic_dec(&group->opened);
+	down_write(&group->group_rwsem);
+	group->opened = false;
+	up_write(&group->group_rwsem);
 
 	vfio_group_put(group);
 
-- 
2.36.0

