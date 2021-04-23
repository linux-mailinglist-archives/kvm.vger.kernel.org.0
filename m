Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4AD369D07
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 01:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236688AbhDWXEF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 19:04:05 -0400
Received: from mail-mw2nam10on2084.outbound.protection.outlook.com ([40.107.94.84]:47680
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235837AbhDWXD4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 19:03:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MXVTog+XzQnwnGT1ndOraIXMbM4T+70uw/egg+62m4NL6zmSrGkV4k2ombHTd/AGub5d2HP4ISxnRPC2oOtscc0eL+mZvBXfHwiTOf91RTF4xBTTzvqjcSMYlgmpvL/vSjirXinT64jJgkH+AgLPYvC6AZbAmd0WPBw0DRmV4QC+qtUBiRL6L7j5eGA8ILD2jKc+ki1KIuagkKd2s8i5ct7q1aXDFqXhlqam0b7zH4uAvAC6tzEm6BqX2oxXn2qWwhHk5/NXNKwF/IGGEdBFiwoKv8PUxAWFTiiQ9B4sb+7Bv9msw/6tRU5MN6iys788N7hZEnwVqTV4Uu5GDeI8kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sriOwqzoLiul+j9NcS/YmknI5BRFaGKDpxJkHbu4pEY=;
 b=AZAGs8D9QzA8q9yO2qW6rWUnzOqu1yARJu0t2dwBO+J7YitZbuITShLAgSecCW78jTw+v1snlKHdSCRKri/fTQarwob+eAJp8CR+Xeyz/1vr4Tphx35WxRELsKVLAEiB38uu+upwfazRXkMiz5+kocJX55+4KA3xiDE7kq2EbA7WdK7SZ+ragPkyu4KDq3G41LKJQ0LoirLr8u6/YCaoHKJgHyVhjnYHwoxiWxWWd9Z2mB3TbFpNy4q/qmsIHgr1AC+7pQm/knvfzQ7ZOVEBfTd+GJuXYG/wvx/3IUuod1A2V52ELM/WXivOZoxSC5xTjHMdG704qOh86c+jso4mlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sriOwqzoLiul+j9NcS/YmknI5BRFaGKDpxJkHbu4pEY=;
 b=GFGTFf+c3lv7C3LhoXQg2kX9NGXZG0M+cF0nArOKhyPAfrtiXrXrd/0NWfbNld9ZHBEjkBXgkP3580F/abh1tV8V4WH02Xz1ZxyWNm6n4weSPqNRWgznSSJprtOjtcLn/G9Ja23rzq47UwBSFgLWYD5vEHz8nskXbyzOvClDeJTCxeCgP93pM3kagNn1xyLI5PV291OCCxzf0ArIpHtTjWV5tkGwHx2KJZ/QAed5xbPZ05liIejpoWhVHD0B9/PlSre9s9mfwFkVNIQgs02tXVyIoq1alEJr0g2gXuanPLJTWji7ZDjYsl3GMxnr1bqKaeeQBJ2ltGGGPiAnven0IQ==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3513.namprd12.prod.outlook.com (2603:10b6:5:18a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.24; Fri, 23 Apr
 2021 23:03:14 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.023; Fri, 23 Apr 2021
 23:03:14 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 04/12] vfio/mdpy: Convert to use vfio_register_group_dev()
Date:   Fri, 23 Apr 2021 20:03:01 -0300
Message-Id: <4-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
In-Reply-To: <0-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:208:23a::17) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR03CA0012.namprd03.prod.outlook.com (2603:10b6:208:23a::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24 via Frontend Transport; Fri, 23 Apr 2021 23:03:12 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1la4pK-00CHzf-2d; Fri, 23 Apr 2021 20:03:10 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42e5c0fd-eb88-45c1-7745-08d906abf841
X-MS-TrafficTypeDiagnostic: DM6PR12MB3513:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB35139ED7697DE1842C77CEBAC2459@DM6PR12MB3513.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:126;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jHd/mvgxnVJOrMmU7mCHe9G59pURuegQbeQfxthLNFZJYnN6BTIRiTTsgZtFIdgmYcDmiB28PF5+8+PWJ8ZAcfmc71Rc1Ib+IBjLwiIu8X8IT4AhRoJ/fEXW1MXSdzjCmsBeQhTcGkRXb5xK1WGwAT8TimPtnoKLgrzVRiqS1agrh80IJDR8l9Sb8R1lu+ML3ckbLa/NQqBDobr4l76+bRWcPFv9rizmhhGjexgydf6lhjmFdbjIUriEQp0ONPVv/6j9g5FeYL2NMGR2yPtDpXzllHrstM8TmKiOt68B6mkDU4wdz8+GbkLmQRv2txa2HpEpd+gVYGh5WqTVGNrx5/wC0WbELR6CaQYn8vEjVv6Q0WTzlZnAn0WYB7l4q0trC7vaUDfP3DdtGF2ajL/gX0VDDfQ37pGy605bJnnG3/3pla+f2b0u+i0ullx5suUp6im80sR72Dwupq2ZRrbwLLy5ZspJbjHkkaLFuVS2dnGu66xDn1qqMmBhRcKvoIx/xXclQc7FDMtTyWfQyDpO+uwCUV22999OCpXEWx/m2Y4g8gkWSyiHfw58Lin67RRaEPHMojOoRH/yU0ZLVCZS9kW06+PnCTM57yztmHUkTguui6ud2zbyZOFw6TtIITnms3BwzZyab9F1fL5YkXjv3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(366004)(346002)(136003)(36756003)(66556008)(26005)(66476007)(107886003)(426003)(8936002)(83380400001)(9786002)(5660300002)(186003)(86362001)(9746002)(54906003)(38100700002)(2616005)(316002)(8676002)(6636002)(2906002)(4326008)(37006003)(66946007)(6666004)(6862004)(30864003)(478600001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6i7UwXUFQfw0oGB6TK8dWfMMBnoFg1LXOUyeIXw1HQY3Sctw7tYvnS3psXqF?=
 =?us-ascii?Q?Hg6orNJ13AGtwU8bzlG0W24F1mV8PYCBM3/CIekPSTALtVhxHENWyRcB7sCE?=
 =?us-ascii?Q?c7lUd9bb0EHBgdd2ZbNgEr/T0ZtXlUGqmM8GYMwevyN/rEoGlP5pi6Pno3J5?=
 =?us-ascii?Q?ys++u1L4QzjTclC6JaaRpQYnIv1XzicSjvh4jnOiTxcWfIY2fT0sz50V6s0L?=
 =?us-ascii?Q?+VuVxID1sAWNxNi0EDCkqULsHCMSL/zEtvOT3v5JR6LNBqRzQ4dzMqCDE9pd?=
 =?us-ascii?Q?wqOxTwCDTGIDkuvmnYf6S1Ixxxcfm9KBHRMCHj2L17qn9H7eThPa5N1uhWrh?=
 =?us-ascii?Q?jG7aZdN8rsJiM11pT3l3VVaqYGlWQe8S3GE21eOh9kSnMWdmrbqoAVUAT88b?=
 =?us-ascii?Q?8MP0jBW2o84sJeMcrJ0raq115CS9dEpV7sJqp+A5TO3+vwzWmIyOZnPHGGb0?=
 =?us-ascii?Q?7dYxtbYuq9+eLCFfgceNJBd4sXeszoV7CTDIKUqrhfABMX4lxED49PDt84Ja?=
 =?us-ascii?Q?uvUDmW5TQuUwezF1U8/icsQs/KsGRX5fcYIft0y+ZS8MZcGA+wEeMlh0zFXy?=
 =?us-ascii?Q?CtizAZ7VkLJeA1fn/sZb5iSVEYFEr7BJPpjQMd8p5qq8QZMut40XmI2K0ZnU?=
 =?us-ascii?Q?Ulpgugwh5mHn9vuFwhv+JHIKNNlJvBFjxoQ1ogQhTJ+eGtn8FP99CAP8TGmZ?=
 =?us-ascii?Q?A0WqDm4Pi9y1bz1z9SQEjHii7R3qoomRgWJT8veEQJzoHPQjnKSUwydeEOvR?=
 =?us-ascii?Q?T1DWAB9Gkix3RFHpJmH9Wzb9CiyhquUcfvOZ0Ec72j0iCcJGCGukkVfXA8oC?=
 =?us-ascii?Q?CrT00nkabyEMZnOfxSgPYFtdbeqS/KM5MqUOE3z2OWWn/ZTnbggd9Twq2AJi?=
 =?us-ascii?Q?bOrAtgo7Q8likIXmX+E7sfZXz3mn2qsQShi0jxJzC+WTDLIm8CblKzbC9T0K?=
 =?us-ascii?Q?4Pc2ro1OZ+UM7W2IKQCe7TRJK/Dtmm3NcIvF2waVuqbLNdvuZwvpQZJkx5KQ?=
 =?us-ascii?Q?9VUr5jfEy9cuuYqslMUn8J4l1Y0Kz8lvRb3JlvHffMqFvGyXhIOo7Kib/d8F?=
 =?us-ascii?Q?PdfrpP/2NO+rkxLQy8Z87MVbgUj52F/F1TR2vqyN8iNHfIHAaLG3k35PRcXb?=
 =?us-ascii?Q?5JDUPJxJR3hBlp8a3soL49GnKtjnO/vOuRWiJtQpFGMvpkP+xozu2FpFEd8V?=
 =?us-ascii?Q?KBBfg/5NRUXqkbd2gzcLZUM4qUArexPb+oQlVi+D5bznF0ZTBl9ZOEweao67?=
 =?us-ascii?Q?YBBfACSUA5vjUhGT++IJSCoRl3QrbLHJ0z+otxD3DWgTvbtfS3TKtMH9iomr?=
 =?us-ascii?Q?mMGHn3S7OLA8terRQwBM8Bbc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42e5c0fd-eb88-45c1-7745-08d906abf841
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 23:03:12.6158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VA77bZifnGPhKY8coghNLwAeBfgK9NM2GLo2n/oNQtoaiNyh5jgwr/bP5rFgJ65U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3513
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is straightforward conversion, the mdev_state is actually serving as
the vfio_device and we can replace all the mdev_get_drvdata()'s and the
wonky dead code with a simple container_of().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 samples/vfio-mdev/mdpy.c | 159 ++++++++++++++++++++++-----------------
 1 file changed, 88 insertions(+), 71 deletions(-)

diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index 885b88ea20e234..82638de333330d 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -85,9 +85,11 @@ static struct class	*mdpy_class;
 static struct cdev	mdpy_cdev;
 static struct device	mdpy_dev;
 static u32		mdpy_count;
+static const struct vfio_device_ops mdpy_dev_ops;
 
 /* State of each mdev device */
 struct mdev_state {
+	struct vfio_device vdev;
 	u8 *vconfig;
 	u32 bar_mask;
 	struct mutex ops_lock;
@@ -162,11 +164,9 @@ static void handle_pci_cfg_write(struct mdev_state *mdev_state, u16 offset,
 	}
 }
 
-static ssize_t mdev_access(struct mdev_device *mdev, char *buf, size_t count,
-			   loff_t pos, bool is_write)
+static ssize_t mdev_access(struct mdev_state *mdev_state, char *buf,
+			   size_t count, loff_t pos, bool is_write)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
-	struct device *dev = mdev_dev(mdev);
 	int ret = 0;
 
 	mutex_lock(&mdev_state->ops_lock);
@@ -187,8 +187,9 @@ static ssize_t mdev_access(struct mdev_device *mdev, char *buf, size_t count,
 			memcpy(buf, mdev_state->memblk, count);
 
 	} else {
-		dev_info(dev, "%s: %s @0x%llx (unhandled)\n",
-			 __func__, is_write ? "WR" : "RD", pos);
+		dev_info(mdev_state->vdev.dev,
+			 "%s: %s @0x%llx (unhandled)\n", __func__,
+			 is_write ? "WR" : "RD", pos);
 		ret = -1;
 		goto accessfailed;
 	}
@@ -202,9 +203,8 @@ static ssize_t mdev_access(struct mdev_device *mdev, char *buf, size_t count,
 	return ret;
 }
 
-static int mdpy_reset(struct mdev_device *mdev)
+static int mdpy_reset(struct mdev_state *mdev_state)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
 	u32 stride, i;
 
 	/* initialize with gray gradient */
@@ -216,13 +216,14 @@ static int mdpy_reset(struct mdev_device *mdev)
 	return 0;
 }
 
-static int mdpy_create(struct mdev_device *mdev)
+static int mdpy_probe(struct mdev_device *mdev)
 {
 	const struct mdpy_type *type =
 		&mdpy_types[mdev_get_type_group_id(mdev)];
 	struct device *dev = mdev_dev(mdev);
 	struct mdev_state *mdev_state;
 	u32 fbsize;
+	int ret;
 
 	if (mdpy_count >= max_devices)
 		return -ENOMEM;
@@ -230,6 +231,7 @@ static int mdpy_create(struct mdev_device *mdev)
 	mdev_state = kzalloc(sizeof(struct mdev_state), GFP_KERNEL);
 	if (mdev_state == NULL)
 		return -ENOMEM;
+	vfio_init_group_dev(&mdev_state->vdev, &mdev->dev, &mdpy_dev_ops);
 
 	mdev_state->vconfig = kzalloc(MDPY_CONFIG_SPACE_SIZE, GFP_KERNEL);
 	if (mdev_state->vconfig == NULL) {
@@ -250,36 +252,41 @@ static int mdpy_create(struct mdev_device *mdev)
 
 	mutex_init(&mdev_state->ops_lock);
 	mdev_state->mdev = mdev;
-	mdev_set_drvdata(mdev, mdev_state);
-
 	mdev_state->type    = type;
 	mdev_state->memsize = fbsize;
 	mdpy_create_config_space(mdev_state);
-	mdpy_reset(mdev);
+	mdpy_reset(mdev_state);
 
 	mdpy_count++;
+
+	ret = vfio_register_group_dev(&mdev_state->vdev);
+	if (ret) {
+		kfree(mdev_state);
+		return ret;
+	}
+	dev_set_drvdata(&mdev->dev, mdev_state);
 	return 0;
 }
 
-static int mdpy_remove(struct mdev_device *mdev)
+static void mdpy_remove(struct mdev_device *mdev)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
-	struct device *dev = mdev_dev(mdev);
+	struct mdev_state *mdev_state = dev_get_drvdata(&mdev->dev);
 
-	dev_info(dev, "%s\n", __func__);
+	dev_info(&mdev->dev, "%s\n", __func__);
 
-	mdev_set_drvdata(mdev, NULL);
+	vfio_unregister_group_dev(&mdev_state->vdev);
 	vfree(mdev_state->memblk);
 	kfree(mdev_state->vconfig);
 	kfree(mdev_state);
 
 	mdpy_count--;
-	return 0;
 }
 
-static ssize_t mdpy_read(struct mdev_device *mdev, char __user *buf,
+static ssize_t mdpy_read(struct vfio_device *vdev, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 	unsigned int done = 0;
 	int ret;
 
@@ -289,8 +296,8 @@ static ssize_t mdpy_read(struct mdev_device *mdev, char __user *buf,
 		if (count >= 4 && !(*ppos % 4)) {
 			u32 val;
 
-			ret =  mdev_access(mdev, (char *)&val, sizeof(val),
-					   *ppos, false);
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
+					  *ppos, false);
 			if (ret <= 0)
 				goto read_err;
 
@@ -301,7 +308,7 @@ static ssize_t mdpy_read(struct mdev_device *mdev, char __user *buf,
 		} else if (count >= 2 && !(*ppos % 2)) {
 			u16 val;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -313,7 +320,7 @@ static ssize_t mdpy_read(struct mdev_device *mdev, char __user *buf,
 		} else {
 			u8 val;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -336,9 +343,11 @@ static ssize_t mdpy_read(struct mdev_device *mdev, char __user *buf,
 	return -EFAULT;
 }
 
-static ssize_t mdpy_write(struct mdev_device *mdev, const char __user *buf,
+static ssize_t mdpy_write(struct vfio_device *vdev, const char __user *buf,
 			  size_t count, loff_t *ppos)
 {
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 	unsigned int done = 0;
 	int ret;
 
@@ -351,7 +360,7 @@ static ssize_t mdpy_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -363,7 +372,7 @@ static ssize_t mdpy_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -375,7 +384,7 @@ static ssize_t mdpy_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -393,9 +402,10 @@ static ssize_t mdpy_write(struct mdev_device *mdev, const char __user *buf,
 	return -EFAULT;
 }
 
-static int mdpy_mmap(struct mdev_device *mdev, struct vm_area_struct *vma)
+static int mdpy_mmap(struct vfio_device *vdev, struct vm_area_struct *vma)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 
 	if (vma->vm_pgoff != MDPY_MEMORY_BAR_OFFSET >> PAGE_SHIFT)
 		return -EINVAL;
@@ -411,16 +421,10 @@ static int mdpy_mmap(struct mdev_device *mdev, struct vm_area_struct *vma)
 					   vma->vm_end - vma->vm_start);
 }
 
-static int mdpy_get_region_info(struct mdev_device *mdev,
+static int mdpy_get_region_info(struct mdev_state *mdev_state,
 				struct vfio_region_info *region_info,
 				u16 *cap_type_id, void **cap_type)
 {
-	struct mdev_state *mdev_state;
-
-	mdev_state = mdev_get_drvdata(mdev);
-	if (!mdev_state)
-		return -EINVAL;
-
 	if (region_info->index >= VFIO_PCI_NUM_REGIONS &&
 	    region_info->index != MDPY_DISPLAY_REGION)
 		return -EINVAL;
@@ -449,15 +453,13 @@ static int mdpy_get_region_info(struct mdev_device *mdev,
 	return 0;
 }
 
-static int mdpy_get_irq_info(struct mdev_device *mdev,
-			     struct vfio_irq_info *irq_info)
+static int mdpy_get_irq_info(struct vfio_irq_info *irq_info)
 {
 	irq_info->count = 0;
 	return 0;
 }
 
-static int mdpy_get_device_info(struct mdev_device *mdev,
-				struct vfio_device_info *dev_info)
+static int mdpy_get_device_info(struct vfio_device_info *dev_info)
 {
 	dev_info->flags = VFIO_DEVICE_FLAGS_PCI;
 	dev_info->num_regions = VFIO_PCI_NUM_REGIONS;
@@ -465,11 +467,9 @@ static int mdpy_get_device_info(struct mdev_device *mdev,
 	return 0;
 }
 
-static int mdpy_query_gfx_plane(struct mdev_device *mdev,
+static int mdpy_query_gfx_plane(struct mdev_state *mdev_state,
 				struct vfio_device_gfx_plane_info *plane)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
-
 	if (plane->flags & VFIO_GFX_PLANE_TYPE_PROBE) {
 		if (plane->flags == (VFIO_GFX_PLANE_TYPE_PROBE |
 				     VFIO_GFX_PLANE_TYPE_REGION))
@@ -498,14 +498,13 @@ static int mdpy_query_gfx_plane(struct mdev_device *mdev,
 	return 0;
 }
 
-static long mdpy_ioctl(struct mdev_device *mdev, unsigned int cmd,
+static long mdpy_ioctl(struct vfio_device *vdev, unsigned int cmd,
 		       unsigned long arg)
 {
 	int ret = 0;
 	unsigned long minsz;
-	struct mdev_state *mdev_state;
-
-	mdev_state = mdev_get_drvdata(mdev);
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 
 	switch (cmd) {
 	case VFIO_DEVICE_GET_INFO:
@@ -520,7 +519,7 @@ static long mdpy_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		ret = mdpy_get_device_info(mdev, &info);
+		ret = mdpy_get_device_info(&info);
 		if (ret)
 			return ret;
 
@@ -545,7 +544,7 @@ static long mdpy_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		ret = mdpy_get_region_info(mdev, &info, &cap_type_id,
+		ret = mdpy_get_region_info(mdev_state, &info, &cap_type_id,
 					   &cap_type);
 		if (ret)
 			return ret;
@@ -569,7 +568,7 @@ static long mdpy_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		    (info.index >= mdev_state->dev_info.num_irqs))
 			return -EINVAL;
 
-		ret = mdpy_get_irq_info(mdev, &info);
+		ret = mdpy_get_irq_info(&info);
 		if (ret)
 			return ret;
 
@@ -592,7 +591,7 @@ static long mdpy_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (plane.argsz < minsz)
 			return -EINVAL;
 
-		ret = mdpy_query_gfx_plane(mdev, &plane);
+		ret = mdpy_query_gfx_plane(mdev_state, &plane);
 		if (ret)
 			return ret;
 
@@ -606,12 +605,12 @@ static long mdpy_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		return -EINVAL;
 
 	case VFIO_DEVICE_RESET:
-		return mdpy_reset(mdev);
+		return mdpy_reset(mdev_state);
 	}
 	return -ENOTTY;
 }
 
-static int mdpy_open(struct mdev_device *mdev)
+static int mdpy_open(struct vfio_device *vdev)
 {
 	if (!try_module_get(THIS_MODULE))
 		return -ENODEV;
@@ -619,7 +618,7 @@ static int mdpy_open(struct mdev_device *mdev)
 	return 0;
 }
 
-static void mdpy_close(struct mdev_device *mdev)
+static void mdpy_close(struct vfio_device *vdev)
 {
 	module_put(THIS_MODULE);
 }
@@ -628,8 +627,7 @@ static ssize_t
 resolution_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
+	struct mdev_state *mdev_state = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%dx%d\n",
 		       mdev_state->type->width,
@@ -719,18 +717,30 @@ static struct attribute_group *mdev_type_groups[] = {
 	NULL,
 };
 
+static const struct vfio_device_ops mdpy_dev_ops = {
+	.open = mdpy_open,
+	.release = mdpy_close,
+	.read = mdpy_read,
+	.write = mdpy_write,
+	.ioctl = mdpy_ioctl,
+	.mmap = mdpy_mmap,
+};
+
+static struct mdev_driver mdpy_driver = {
+	.driver = {
+		.name = "mdpy",
+		.owner = THIS_MODULE,
+		.mod_name = KBUILD_MODNAME,
+		.dev_groups = mdev_dev_groups,
+	},
+	.probe = mdpy_probe,
+	.remove	= mdpy_remove,
+};
+
 static const struct mdev_parent_ops mdev_fops = {
 	.owner			= THIS_MODULE,
-	.mdev_attr_groups	= mdev_dev_groups,
+	.device_driver          = &mdpy_driver,
 	.supported_type_groups	= mdev_type_groups,
-	.create			= mdpy_create,
-	.remove			= mdpy_remove,
-	.open			= mdpy_open,
-	.release		= mdpy_close,
-	.read			= mdpy_read,
-	.write			= mdpy_write,
-	.ioctl			= mdpy_ioctl,
-	.mmap			= mdpy_mmap,
 };
 
 static const struct file_operations vd_fops = {
@@ -755,11 +765,15 @@ static int __init mdpy_dev_init(void)
 	cdev_add(&mdpy_cdev, mdpy_devt, MINORMASK + 1);
 	pr_info("%s: major %d\n", __func__, MAJOR(mdpy_devt));
 
+	ret = mdev_register_driver(&mdpy_driver);
+	if (ret)
+		goto err_cdev;
+
 	mdpy_class = class_create(THIS_MODULE, MDPY_CLASS_NAME);
 	if (IS_ERR(mdpy_class)) {
 		pr_err("Error: failed to register mdpy_dev class\n");
 		ret = PTR_ERR(mdpy_class);
-		goto failed1;
+		goto err_driver;
 	}
 	mdpy_dev.class = mdpy_class;
 	mdpy_dev.release = mdpy_device_release;
@@ -767,19 +781,21 @@ static int __init mdpy_dev_init(void)
 
 	ret = device_register(&mdpy_dev);
 	if (ret)
-		goto failed2;
+		goto err_class;
 
 	ret = mdev_register_device(&mdpy_dev, &mdev_fops);
 	if (ret)
-		goto failed3;
+		goto err_device;
 
 	return 0;
 
-failed3:
+err_device:
 	device_unregister(&mdpy_dev);
-failed2:
+err_class:
 	class_destroy(mdpy_class);
-failed1:
+err_driver:
+	mdev_unregister_driver(&mdpy_driver);
+err_cdev:
 	cdev_del(&mdpy_cdev);
 	unregister_chrdev_region(mdpy_devt, MINORMASK + 1);
 	return ret;
@@ -791,6 +807,7 @@ static void __exit mdpy_dev_exit(void)
 	mdev_unregister_device(&mdpy_dev);
 
 	device_unregister(&mdpy_dev);
+	mdev_unregister_driver(&mdpy_driver);
 	cdev_del(&mdpy_cdev);
 	unregister_chrdev_region(mdpy_devt, MINORMASK + 1);
 	class_destroy(mdpy_class);
-- 
2.31.1

