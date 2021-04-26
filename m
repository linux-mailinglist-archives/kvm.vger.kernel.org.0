Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD7236BA7B
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 22:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241812AbhDZUBN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 16:01:13 -0400
Received: from mail-bn8nam08on2069.outbound.protection.outlook.com ([40.107.100.69]:56800
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241775AbhDZUBH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 16:01:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=anznxZ3RJvNdgwyR+ZSzEphkTaHOIX+G7FsYZMKhxMSu4w88PTVFlRDAVH+YalKSPPQ/P4I9HfZlE/Fey+/oqG+pnW4y6fMZpGQbLCa6KiLvsMFNtYrwOpbQOg+7ivSVn02ZPdyetXkE5dCC0r6YhQlFDgRrse4bJ11p/PYSG7zKyZJz736zDAdKn/yu+R3ltAq4tOQ6+J1ZPCSs/C7jDBHCzeCXPJbTRfdbw6Al40z0xLHuEfvJ+UkUART86B8bGZ13r4Svrc06OK6TTMhCGPdNsEsQnSfkNUiPOq6bSODIgPRRULW7mu+V3XETIdWK5lXeZTkcD6YlPqBVIuijLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2GqfmI8BaiRJtzq2SAixfbkeVfV7VIkOI1t3oWnh6Co=;
 b=JpNdGbDOnAVq6sn7etlG4+1jsfi9CJtYvNiOzsbF6LwCeXiyC76WJkYIedwm8QFUHIIodx4DqvNtqBA8hjxzJVui9oOu3IEiipKZLqZR9lqWCjt5/HXUMLizpaXt8W5rVJ2d7+Hr/jMwp3INkxwGb91le3QejQMjUnJ3OitCr17iE1hYpw1sTOgtOma9zcSqE4qHOMPFEdnIprPiM4evNGMX71xWONVHSM8rz+0Nz5keMFGphr4oGbCyK3wQBoMWeHDM5lUTN2vpfrtK09fuWK9BfKaARIRXenfN/X1CkG1sv+1laejfOAO4wf2GcB9U9/jQFYB3/KDfXklB9+jqUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2GqfmI8BaiRJtzq2SAixfbkeVfV7VIkOI1t3oWnh6Co=;
 b=GEJ/mSN9Lc671HsBPpwD5vFFDXwVYQMDdFlML+v/Tm6fWSVs/eyPoGweWEOdc+FprMlbOzKZJm0HhUK86QlZQ2iHgS8H9qhC9yl9pxVb7eAiy5sacJQ5n11W9cKzGZj4cYeP5ZCtEspOLgGxaDUtvo2UudDMPQwZaOUI1nz6BxRvVGkFDacGaZdIUnABVIyHb09DsyTZIbGcst4B5mQz6z7aASODfZJPRhsBy5uefXDRUfsqnDNX93pNj/ZXwktFIX6Sv9WxYJPTFdZ99G+KM6txN+otWWGFBhEyWbDdMEBRwM2m1j2Bx0U1onymkSn61ZtFSRfM7D5/S7Vf13R7kA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3740.namprd12.prod.outlook.com (2603:10b6:5:1c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Mon, 26 Apr
 2021 20:00:19 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.026; Mon, 26 Apr 2021
 20:00:19 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 10/13] vfio/mdev: Remove mdev_parent_ops dev_attr_groups
Date:   Mon, 26 Apr 2021 17:00:12 -0300
Message-Id: <10-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
In-Reply-To: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR01CA0047.prod.exchangelabs.com (2603:10b6:208:23f::16)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR01CA0047.prod.exchangelabs.com (2603:10b6:208:23f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Mon, 26 Apr 2021 20:00:17 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lb7Oy-00DFZc-47; Mon, 26 Apr 2021 17:00:16 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69729f29-550f-47a9-fc21-08d908ede9dd
X-MS-TrafficTypeDiagnostic: DM6PR12MB3740:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3740AC95A763F8F97E7756A2C2429@DM6PR12MB3740.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QZgRpXVsWYpIDaK57fl9Oj+Fr2haNsx01UO9rKQDCml/pp/lv5ivcter3OAzHBPOFNeN7MMMHLTLQ6K54Erdmqvzutf63FF5zakuiiPlGa38s9xnO+Utix0vFFlUYOGHq5fdqdfm3dtksHwRQMMaar6xqaywPiLPfmWm95KSXP5NbDbTvRfE2NElKD71CrH1g/wWE72HDZwKAYJOt+ZEI0MKwNvDEiLTnBsXE++OKsJZxWG1o5f6GW2cNung9zag83zwGiRIfx7OXfWMEDYvXwPchQSwWlGEK+5fzUmjWHRmBDGIpOfsD9lh8RqVeHYbvETbyGZn4T3gQs5awqonMiVQZ17aW8Gsd8m1CEFpe+6RMG18ARdwtTkiWNF1bZ6rMH+CdzaoJALk35aV7rfEMhavQ0GzSNQ3OoQBK5rN0BONq1ziC850exXFeoJ6r9RX5QrdIWvjpompdck5+Bd6vRx+SEB+DY1Xk9+mowb4yVzXlLjjpUakTHWZhmhD1tF7+LYRmPSlidnKfwz6TrNXgns5v52QykYXxbQOajtenTg1Bi2tyWbTcHMRiqjLcrZSJYY9dJDvWNIUGR+/if9w/aEBqMM/w0kCngOwtXaZziU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(136003)(396003)(376002)(66476007)(66556008)(9746002)(54906003)(426003)(110136005)(107886003)(186003)(26005)(6666004)(36756003)(316002)(2906002)(2616005)(478600001)(6636002)(9786002)(8936002)(83380400001)(38100700002)(86362001)(8676002)(5660300002)(4326008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HhgJMTPN7+CA0yH/OB7ZRAG7KRoLQUNlLyzcBCE+FBLYKerFvATljssJh516?=
 =?us-ascii?Q?UcTcv7Eiip2x4p+gZ2PiG+9lFMUp/B6Ta2pS5pCer4NlW01VAfU7h5jGK5w4?=
 =?us-ascii?Q?rs2W7IT+hdJVVkNhtWTZb84Cos9q095w2rMjVgFBLv8s9OetPmrGSUtBmXVJ?=
 =?us-ascii?Q?S4LayvM9Bp7Po0XKQATQE2V5bLDFwSHR/EssKf7ohwg5eral75NSzFhhsdHR?=
 =?us-ascii?Q?gtn9WusSobnOIE6Cj+XS2L8ODFFOjGvq1xwCOfg5ooA1E+U8b6PETHZyPfVn?=
 =?us-ascii?Q?CFUmZo3MQbP0yv9Q7BPRHffoUp1QEC/brlUaYDY09rRNSmXSR2/eBa8HQizy?=
 =?us-ascii?Q?B0IvPuyDplv9WWa4puVw66T3nJeCRCPxVG+shG9Oal0Ga2SvxcUuQwGuLTve?=
 =?us-ascii?Q?s8pk21LfCcF09WUfgWzytfmuJBHFhyLvwHk7CKlRTjvcZLpWQw9AT9cby6xl?=
 =?us-ascii?Q?mKVfkIB7v5NdaKmcLRvUmY1A0zpcVQVpOKMlPPyK7ApkOeQSJPSIokX6BQqr?=
 =?us-ascii?Q?E2pN1QmP4In4a22Jl8WWYcIZBu3o34CP3oU8dyWaZ1cNQotKZLp88DR58YyL?=
 =?us-ascii?Q?Ja6uUHRnzyIE4ivFQ0e5+hVsZvU1ai/u6PNr3Oyz/ftIhDX54TixTG1JAIfk?=
 =?us-ascii?Q?pO1UT+wHxv2e54HsbUMRrP+ihjB9CiukpCNhdI8JMmrqIrlcbt09YTuj+STS?=
 =?us-ascii?Q?qGJT+nnrM+aJuga6vAoQ4/PtCa04Cmp617fTeGGe6EUMYZ63TYIEzmk76eR5?=
 =?us-ascii?Q?nYxei98HvPwk1C6WcX++93d+phvtlGvte5G1iSr0rsud3DQ9pphW1iz8uCN6?=
 =?us-ascii?Q?yyZgkMTzVCkkb1ZuD2FjKuD0LfxvT49ftvBGl4hN4hF3TZnorw6zDM9BAQhX?=
 =?us-ascii?Q?BuCUFDGHV3OPvq4+8F0Xd5Hgw0pAkuJe84vOhRh2yEVrBv/ZdyQYX4IC2MwQ?=
 =?us-ascii?Q?RtULnN0N/hwDPiK6Fvj3pkl812tb1TkSLTgJoty2wnojTOqDcNJShf8g1aNl?=
 =?us-ascii?Q?1mfNRu1+vRHfZ7luVzsas5lMtP6D0mZwTaRxf0WIGwDMrSO+u8KMaIS52L7P?=
 =?us-ascii?Q?waVAILWmgF/mRNouZIEEW0N3huVgaXAnBx3bqjpiw2tI86kBTj0/E5rJhcsy?=
 =?us-ascii?Q?NFyT1LOk06eCLn7CsqyhCzHeKNB+JbdkccbXr+wnNaxMUOoIY6rSVSvpJ4KE?=
 =?us-ascii?Q?XNY3lGdCll8KUaIs7r3D5MYor9j/5B6FvN0bNl+VwAnFdHBlpm4XzZn2OIzq?=
 =?us-ascii?Q?7xg6zOHI4ksfhLhRG7QlgLBN/jYG/oFTs3cqudWVLzvchTA9DAiB+3RahOVm?=
 =?us-ascii?Q?cHIDDlZs9dMQdj8+zxOVAzmI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69729f29-550f-47a9-fc21-08d908ede9dd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 20:00:17.5595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5PhzIwkNS1v3ikPSK+dr8LwN4LDKrrewZKuoi4qttHOMmnvH2KrTwfBX3SIR/hmf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3740
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is only used by one sample to print a fixed string that is pointless.

In general, having a device driver attach sysfs attributes to the parent
is horrific. This should never happen, and always leads to some kind of
liftime bug as it become very difficult for the sysfs attribute to go back
to any data owned by the device driver.

Remove the general mechanism to create this abuse.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_sysfs.c | 12 ++----------
 include/linux/mdev.h           |  2 --
 samples/vfio-mdev/mtty.c       | 30 +-----------------------------
 3 files changed, 3 insertions(+), 41 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index f5cf1931c54e48..66eef08833a4ef 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -197,7 +197,6 @@ void parent_remove_sysfs_files(struct mdev_parent *parent)
 		remove_mdev_supported_type(type);
 	}
 
-	sysfs_remove_groups(&parent->dev->kobj, parent->ops->dev_attr_groups);
 	kset_unregister(parent->mdev_types_kset);
 }
 
@@ -213,17 +212,10 @@ int parent_create_sysfs_files(struct mdev_parent *parent)
 
 	INIT_LIST_HEAD(&parent->type_list);
 
-	ret = sysfs_create_groups(&parent->dev->kobj,
-				  parent->ops->dev_attr_groups);
-	if (ret)
-		goto create_err;
-
 	ret = add_mdev_supported_type_groups(parent);
 	if (ret)
-		sysfs_remove_groups(&parent->dev->kobj,
-				    parent->ops->dev_attr_groups);
-	else
-		return ret;
+		goto create_err;
+	return 0;
 
 create_err:
 	kset_unregister(parent->mdev_types_kset);
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index ea48c401e4fa63..fd9fe1dcf0e230 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -57,7 +57,6 @@ struct device *mtype_get_parent_dev(struct mdev_type *mtype);
  *
  * @owner:		The module owner.
  * @device_driver:	Which device driver to probe() on newly created devices
- * @dev_attr_groups:	Attributes of the parent device.
  * @mdev_attr_groups:	Attributes of the mediated device.
  * @supported_type_groups: Attributes to define supported types. It is mandatory
  *			to provide supported types.
@@ -67,7 +66,6 @@ struct device *mtype_get_parent_dev(struct mdev_type *mtype);
 struct mdev_parent_ops {
 	struct module   *owner;
 	struct mdev_driver *device_driver;
-	const struct attribute_group **dev_attr_groups;
 	const struct attribute_group **mdev_attr_groups;
 	struct attribute_group **supported_type_groups;
 };
diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index d2a168420b775d..31eec76bc553ce 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -1207,38 +1207,11 @@ static void mtty_close(struct vfio_device *mdev)
 	pr_info("%s\n", __func__);
 }
 
-static ssize_t
-sample_mtty_dev_show(struct device *dev, struct device_attribute *attr,
-		     char *buf)
-{
-	return sprintf(buf, "This is phy device\n");
-}
-
-static DEVICE_ATTR_RO(sample_mtty_dev);
-
-static struct attribute *mtty_dev_attrs[] = {
-	&dev_attr_sample_mtty_dev.attr,
-	NULL,
-};
-
-static const struct attribute_group mtty_dev_group = {
-	.name  = "mtty_dev",
-	.attrs = mtty_dev_attrs,
-};
-
-static const struct attribute_group *mtty_dev_groups[] = {
-	&mtty_dev_group,
-	NULL,
-};
-
 static ssize_t
 sample_mdev_dev_show(struct device *dev, struct device_attribute *attr,
 		     char *buf)
 {
-	if (mdev_from_dev(dev))
-		return sprintf(buf, "This is MDEV %s\n", dev_name(dev));
-
-	return sprintf(buf, "\n");
+	return sprintf(buf, "This is MDEV %s\n", dev_name(dev));
 }
 
 static DEVICE_ATTR_RO(sample_mdev_dev);
@@ -1340,7 +1313,6 @@ static struct mdev_driver mtty_driver = {
 static const struct mdev_parent_ops mdev_fops = {
 	.owner                  = THIS_MODULE,
 	.device_driver		= &mtty_driver,
-	.dev_attr_groups        = mtty_dev_groups,
 	.supported_type_groups  = mdev_type_groups,
 };
 
-- 
2.31.1

