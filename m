Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70AFF36BA72
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 22:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241776AbhDZUBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 16:01:07 -0400
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:3982
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241751AbhDZUBF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 16:01:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RT1GEBkslHBB2KGtqwsIZEB/rh+PBpkXku3JD3R0VzEfoKhsT7j7xQxbjknSJ1dHfZAhQjqa1PC1KK2NVEj0/gl8F61sei6nlz1CExNrxIR5dALZop6J7hgRkb8dqeQr0AxHoBAw+2l0j6F1vBvKfkj+phKveHSudv0BoUfp+lIzztQ3e6zEmRiteSfz93QBfLU2NVwJpBEStqy3PqwWe+ip6/JdefqY1DDQ6d+Trlc83//fky3MNRp7SA9MXTLwpUouAKYSK6IdIb/zgcmX+0CPiyuCrKqwOY9quJyMWdSCUinowzPwlT0ST1mmNghATp3RCb9/Pla152jszuS1cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bPmWwfiY76LrNjwW05YwP7QvqV3Mr1EaO2sh4Dhq21o=;
 b=nW/Q0ZhuJiW4x0hYYKOCiyAWq7V7q0z1p/o1ACg4AqqsvmuU9JSnO22sYMvhczFa7EuHThxbenm1tt8jGi4/2YkERNPAwV58PC5cOp6876tzp7/H10CWdwb5WvRWym8HuKFe2nRZyMVmXvPsSdk6badRAKTrjPe3+KLaR6CfPUoJSDrJwR3Ttn7uZvSHMJVgmWrzwkQk7K12p7HJaVj/TDxoeMxlj7l0U9FzFi+zOtkZIlDFWU5UtYYnKXiHjBu3aGieTSS9sB76FLa3Khu/eoaa9hnQ2+DLo2C4Kz0lZqf6d720ezkVX8j6UCV0gSt5YNBbvU+W8qiV+ZlXLLr0JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bPmWwfiY76LrNjwW05YwP7QvqV3Mr1EaO2sh4Dhq21o=;
 b=YPoueLP30IuF4K1zdgYa+nzpKQ6H2F+34d/rrN2F2AvvMOeE/oRia7+sAFk3bsfmlOCZ6Ar2w8R9t/XMcNI54P8+VGnZCvVLtCzK/V3CDLgk2ufyFEZg3R/lL4REupaE6jQncVDjtKlVI7imx5MGJx8phR5SRRBSU1FQ+rqf+fxr7qj+LooRK0xuLMPOKKu9Si6Oph43scSMRkCgY64CjSPsmnFA/i7CoMurpvEM1MrSM72Zyshw/JFIQbDT7hTZGvvpfeg5sM6N3/wSwSK8QVMRa6Uj9HppPR0GtmhuNHOgEALwcxF5IY8SVY0/IV9dbv/LpGdoOpyTSC7d/0bjGA==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1659.namprd12.prod.outlook.com (2603:10b6:4:11::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Mon, 26 Apr
 2021 20:00:20 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.026; Mon, 26 Apr 2021
 20:00:20 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 05/13] vfio/mbochs: Convert to use vfio_register_group_dev()
Date:   Mon, 26 Apr 2021 17:00:07 -0300
Message-Id: <5-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
In-Reply-To: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR15CA0014.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::27) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR15CA0014.namprd15.prod.outlook.com (2603:10b6:208:1b4::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Mon, 26 Apr 2021 20:00:18 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lb7Ox-00DFZH-U9; Mon, 26 Apr 2021 17:00:15 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24aea0a6-5d7e-45a8-1374-08d908edea45
X-MS-TrafficTypeDiagnostic: DM5PR12MB1659:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB16591E6B2DD5BCF6B9E26145C2429@DM5PR12MB1659.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:198;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R1mvTpNMhjpOYMF67SAgVll5fLEPgNxzIVczSGrW4dnbAGDBRYohj1+kFwpgQrqHB4wf3fpplpH+Y0tFnGm1OJqW1y7J8imTvxc6We3gJa/a8w25pNK+OeA7hnAEYvCRaoL8IIIEdmZ/iwGrGpLmUX6r3B65kZViOi4/z93fj49624kcJe4GOgWqM3C7WpScNR/ly460OPbylC1X7Ptg7nLcbwnUArVGzBFl6LWTijcltjXeyPe1GP7JVVZr22dXUYuZZu++F89ySOH9FErgNvjVuAUTeTp4OIjTqbqGTBdjsenORQLI7WV5TN8ny6FurwYpoYqTTp6KPT84k8RQ629UEtX4U2WSvcJmzaq9IJ4lNCLbOBZG4f7KeMg3f9WaH8f3WkaVxbQ0NN94T6/OhSyL3FV/96lKxmD+O7Y1K1EF0lnBCeB8UXhoRVVrxe9uBRnK+HvNhVcw2Y2DGcWgA4hpqdlfqe2RVjUVkDoTAndJrRMfbg+L1lahQqON52qyfIxz88ZOWPfzrDrgQlNezt042YBWFZ/4hT8TwtIWDVbWMFC641+3KEBW60N2U+KVFjAVFIa4+Fk5Z9vJ44YxHefWByfUUXFeierZjsQ6uPQKLeQiixYW5/lG44KuOWTRdH1zme3tuS4cvyLmg/l++g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(366004)(39860400002)(376002)(66946007)(36756003)(66556008)(66476007)(8676002)(2906002)(86362001)(6666004)(6636002)(2616005)(8936002)(478600001)(30864003)(426003)(83380400001)(5660300002)(4326008)(38100700002)(9786002)(107886003)(37006003)(9746002)(6862004)(186003)(316002)(54906003)(26005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?k7SMTQVRbF0Dg72vsbY8u7CRXtu+NMaCy257X0+FK6iTmNu28O1yP8+Dhpgf?=
 =?us-ascii?Q?wdCrgudvgYr8gNYBfkxzi4d80u2Vls3t2NHPYHb1AWjX93FfOSroQt5jIgol?=
 =?us-ascii?Q?xC8Dm4RSyfmoJPjGWpwqYVz2An0rX7IiYm3WwpaImIAOHz90qpr4ecg2nRoy?=
 =?us-ascii?Q?FWmDibYWaOHrkSDFoU6uqXJq5BTlO/5Pw1bJPl3SMfx1FACl653HrUJ9jTRI?=
 =?us-ascii?Q?JUBcIwAKlet4Spo/tOML6JM82rJIzoA0+SqRgpKC4vMhYCpXM5PAUs+pPE9+?=
 =?us-ascii?Q?Gpli4b4fnWApLWksJTgRsCyF3jkDFI4loXA2im7I1+cVJ7hxtm0CueG7xLia?=
 =?us-ascii?Q?1Ttf7XTmZND/j6KJUwC1hVzclmKQLlPqBqJh7ZvrQDlKRkr7ffu9T27yQajR?=
 =?us-ascii?Q?UkYkVXxFM46FbH7tfyFLdUGCzaXpbOlzTxAvT+q88oGyn/wY2WdknFb0IOG2?=
 =?us-ascii?Q?gV111r53x4qozB9uty1LachHKMwV7ngZ8oJeBT9knnR4G39P8G46GnobLtye?=
 =?us-ascii?Q?shqdfUz1ShKMzFJAw3pxOzxzAFAZCCc+0s0iH03hTqRJCnbK6yVoracfMpu1?=
 =?us-ascii?Q?5857Uo6cYDt5ODQsxuQ74KVXbZyHHNxfHua4/4W85ftMYb28Vx9e9fOypt4W?=
 =?us-ascii?Q?BvfQHevBgSb5jwaLJDd/4c9tjtXMlK72e/26Ia12ocqrr9N1vj+A5am3CzdT?=
 =?us-ascii?Q?zp1hz1RC/LmICunCwziIl/LWK4e9lg5cadOS5ahjYenai68C1405XCcKnGZy?=
 =?us-ascii?Q?CeoBpGV2uB+FSvRqs8gWLmOLOusYnrPi40h6xy2/intElEFF0xr2ykKesoAr?=
 =?us-ascii?Q?LwT/iwJCWLgMl5j6DhuQB/QwLj2fFPOP0yUoH9WtNNUINOjVhtZYO/ag53ox?=
 =?us-ascii?Q?p9bU47th1ZnIBLSXn/xJ9tofrZoGSeNnUHiiyPVn+ofMz5ncWnYskgbDvFsL?=
 =?us-ascii?Q?1HdK9nxBiuMfpZAoAUqJPAMKl1YhJ0G70IEwvRsWhqXbXNKEK3Dn14ovIHHv?=
 =?us-ascii?Q?KCgNnel5WVYe8iwQoRRYKQKYvLvaQ9XfGbSuuuh04+YUeBLywOGVTENRLpjq?=
 =?us-ascii?Q?8n/W6guSO8N9AH6BltygLRXz0j8VOQ/PYoRHehiKTpKD2eT98R5SeZI/kDx+?=
 =?us-ascii?Q?xjhI48GZw/hbmDe07cCiMFdidPuIhAHeiGdJWKuvJCfwIbsYLUOfRXHeNWeQ?=
 =?us-ascii?Q?Cuoonshwg1j+67wu8w9xywHIJCe48bdE4DcGHc2QZdBOrZbXFdI4XuZzQ9zk?=
 =?us-ascii?Q?RjJj6d/FXP1+EVhE4+lN0pgrtFoticsgSa2GzOFm6m+pTHk6Zu4x2Dh75j5D?=
 =?us-ascii?Q?Ktp4noykvIuEFCTLDv29Nfyd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24aea0a6-5d7e-45a8-1374-08d908edea45
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 20:00:18.2531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D0GCFbShHF3xewAsQLpcqSFPHfgcDc6BCcNcplF9vtoeFD/GDbkWZt38+OqnXdsM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1659
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is straightforward conversion, the mdev_state is actually serving as
the vfio_device and we can replace all the mdev_get_drvdata()'s and the
wonky dead code with a simple container_of().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 samples/vfio-mdev/mbochs.c | 163 +++++++++++++++++++++----------------
 1 file changed, 91 insertions(+), 72 deletions(-)

diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 861c76914e7639..e18821a8a6beb8 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -130,6 +130,7 @@ static struct class	*mbochs_class;
 static struct cdev	mbochs_cdev;
 static struct device	mbochs_dev;
 static int		mbochs_used_mbytes;
+static const struct vfio_device_ops mbochs_dev_ops;
 
 struct vfio_region_info_ext {
 	struct vfio_region_info          base;
@@ -160,6 +161,7 @@ struct mbochs_dmabuf {
 
 /* State of each mdev device */
 struct mdev_state {
+	struct vfio_device vdev;
 	u8 *vconfig;
 	u64 bar_mask[3];
 	u32 memory_bar_mask;
@@ -425,11 +427,9 @@ static void handle_edid_blob(struct mdev_state *mdev_state, u16 offset,
 		memcpy(buf, mdev_state->edid_blob + offset, count);
 }
 
-static ssize_t mdev_access(struct mdev_device *mdev, char *buf, size_t count,
-			   loff_t pos, bool is_write)
+static ssize_t mdev_access(struct mdev_state *mdev_state, char *buf,
+			   size_t count, loff_t pos, bool is_write)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
-	struct device *dev = mdev_dev(mdev);
 	struct page *pg;
 	loff_t poff;
 	char *map;
@@ -478,7 +478,7 @@ static ssize_t mdev_access(struct mdev_device *mdev, char *buf, size_t count,
 		put_page(pg);
 
 	} else {
-		dev_dbg(dev, "%s: %s @0x%llx (unhandled)\n",
+		dev_dbg(mdev_state->vdev.dev, "%s: %s @0x%llx (unhandled)\n",
 			__func__, is_write ? "WR" : "RD", pos);
 		ret = -1;
 		goto accessfailed;
@@ -493,9 +493,8 @@ static ssize_t mdev_access(struct mdev_device *mdev, char *buf, size_t count,
 	return ret;
 }
 
-static int mbochs_reset(struct mdev_device *mdev)
+static int mbochs_reset(struct mdev_state *mdev_state)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
 	u32 size64k = mdev_state->memsize / (64 * 1024);
 	int i;
 
@@ -506,12 +505,13 @@ static int mbochs_reset(struct mdev_device *mdev)
 	return 0;
 }
 
-static int mbochs_create(struct mdev_device *mdev)
+static int mbochs_probe(struct mdev_device *mdev)
 {
 	const struct mbochs_type *type =
 		&mbochs_types[mdev_get_type_group_id(mdev)];
 	struct device *dev = mdev_dev(mdev);
 	struct mdev_state *mdev_state;
+	int ret = -ENOMEM;
 
 	if (!type)
 		type = &mbochs_types[0];
@@ -521,6 +521,7 @@ static int mbochs_create(struct mdev_device *mdev)
 	mdev_state = kzalloc(sizeof(struct mdev_state), GFP_KERNEL);
 	if (mdev_state == NULL)
 		return -ENOMEM;
+	vfio_init_group_dev(&mdev_state->vdev, &mdev->dev, &mbochs_dev_ops);
 
 	mdev_state->vconfig = kzalloc(MBOCHS_CONFIG_SPACE_SIZE, GFP_KERNEL);
 	if (mdev_state->vconfig == NULL)
@@ -539,7 +540,6 @@ static int mbochs_create(struct mdev_device *mdev)
 
 	mutex_init(&mdev_state->ops_lock);
 	mdev_state->mdev = mdev;
-	mdev_set_drvdata(mdev, mdev_state);
 	INIT_LIST_HEAD(&mdev_state->dmabufs);
 	mdev_state->next_id = 1;
 
@@ -549,32 +549,38 @@ static int mbochs_create(struct mdev_device *mdev)
 	mdev_state->edid_regs.edid_offset = MBOCHS_EDID_BLOB_OFFSET;
 	mdev_state->edid_regs.edid_max_size = sizeof(mdev_state->edid_blob);
 	mbochs_create_config_space(mdev_state);
-	mbochs_reset(mdev);
+	mbochs_reset(mdev_state);
 
 	mbochs_used_mbytes += type->mbytes;
+
+	ret = vfio_register_group_dev(&mdev_state->vdev);
+	if (ret)
+		goto err_mem;
+	dev_set_drvdata(&mdev->dev, mdev_state);
 	return 0;
 
 err_mem:
 	kfree(mdev_state->vconfig);
 	kfree(mdev_state);
-	return -ENOMEM;
+	return ret;
 }
 
-static int mbochs_remove(struct mdev_device *mdev)
+static void mbochs_remove(struct mdev_device *mdev)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
+	struct mdev_state *mdev_state = dev_get_drvdata(&mdev->dev);
 
 	mbochs_used_mbytes -= mdev_state->type->mbytes;
-	mdev_set_drvdata(mdev, NULL);
+	vfio_unregister_group_dev(&mdev_state->vdev);
 	kfree(mdev_state->pages);
 	kfree(mdev_state->vconfig);
 	kfree(mdev_state);
-	return 0;
 }
 
-static ssize_t mbochs_read(struct mdev_device *mdev, char __user *buf,
+static ssize_t mbochs_read(struct vfio_device *vdev, char __user *buf,
 			   size_t count, loff_t *ppos)
 {
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 	unsigned int done = 0;
 	int ret;
 
@@ -584,7 +590,7 @@ static ssize_t mbochs_read(struct mdev_device *mdev, char __user *buf,
 		if (count >= 4 && !(*ppos % 4)) {
 			u32 val;
 
-			ret =  mdev_access(mdev, (char *)&val, sizeof(val),
+			ret =  mdev_access(mdev_state, (char *)&val, sizeof(val),
 					   *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -596,7 +602,7 @@ static ssize_t mbochs_read(struct mdev_device *mdev, char __user *buf,
 		} else if (count >= 2 && !(*ppos % 2)) {
 			u16 val;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -608,7 +614,7 @@ static ssize_t mbochs_read(struct mdev_device *mdev, char __user *buf,
 		} else {
 			u8 val;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -631,9 +637,11 @@ static ssize_t mbochs_read(struct mdev_device *mdev, char __user *buf,
 	return -EFAULT;
 }
 
-static ssize_t mbochs_write(struct mdev_device *mdev, const char __user *buf,
+static ssize_t mbochs_write(struct vfio_device *vdev, const char __user *buf,
 			    size_t count, loff_t *ppos)
 {
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 	unsigned int done = 0;
 	int ret;
 
@@ -646,7 +654,7 @@ static ssize_t mbochs_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -658,7 +666,7 @@ static ssize_t mbochs_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -670,7 +678,7 @@ static ssize_t mbochs_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -756,9 +764,10 @@ static const struct vm_operations_struct mbochs_region_vm_ops = {
 	.fault = mbochs_region_vm_fault,
 };
 
-static int mbochs_mmap(struct mdev_device *mdev, struct vm_area_struct *vma)
+static int mbochs_mmap(struct vfio_device *vdev, struct vm_area_struct *vma)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 
 	if (vma->vm_pgoff != MBOCHS_MEMORY_BAR_OFFSET >> PAGE_SHIFT)
 		return -EINVAL;
@@ -965,7 +974,7 @@ mbochs_dmabuf_find_by_id(struct mdev_state *mdev_state, u32 id)
 static int mbochs_dmabuf_export(struct mbochs_dmabuf *dmabuf)
 {
 	struct mdev_state *mdev_state = dmabuf->mdev_state;
-	struct device *dev = mdev_dev(mdev_state->mdev);
+	struct device *dev = mdev_state->vdev.dev;
 	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
 	struct dma_buf *buf;
 
@@ -993,15 +1002,10 @@ static int mbochs_dmabuf_export(struct mbochs_dmabuf *dmabuf)
 	return 0;
 }
 
-static int mbochs_get_region_info(struct mdev_device *mdev,
+static int mbochs_get_region_info(struct mdev_state *mdev_state,
 				  struct vfio_region_info_ext *ext)
 {
 	struct vfio_region_info *region_info = &ext->base;
-	struct mdev_state *mdev_state;
-
-	mdev_state = mdev_get_drvdata(mdev);
-	if (!mdev_state)
-		return -EINVAL;
 
 	if (region_info->index >= MBOCHS_NUM_REGIONS)
 		return -EINVAL;
@@ -1049,15 +1053,13 @@ static int mbochs_get_region_info(struct mdev_device *mdev,
 	return 0;
 }
 
-static int mbochs_get_irq_info(struct mdev_device *mdev,
-			       struct vfio_irq_info *irq_info)
+static int mbochs_get_irq_info(struct vfio_irq_info *irq_info)
 {
 	irq_info->count = 0;
 	return 0;
 }
 
-static int mbochs_get_device_info(struct mdev_device *mdev,
-				  struct vfio_device_info *dev_info)
+static int mbochs_get_device_info(struct vfio_device_info *dev_info)
 {
 	dev_info->flags = VFIO_DEVICE_FLAGS_PCI;
 	dev_info->num_regions = MBOCHS_NUM_REGIONS;
@@ -1065,11 +1067,9 @@ static int mbochs_get_device_info(struct mdev_device *mdev,
 	return 0;
 }
 
-static int mbochs_query_gfx_plane(struct mdev_device *mdev,
+static int mbochs_query_gfx_plane(struct mdev_state *mdev_state,
 				  struct vfio_device_gfx_plane_info *plane)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
-	struct device *dev = mdev_dev(mdev);
 	struct mbochs_dmabuf *dmabuf;
 	struct mbochs_mode mode;
 	int ret;
@@ -1123,18 +1123,16 @@ static int mbochs_query_gfx_plane(struct mdev_device *mdev,
 done:
 	if (plane->drm_plane_type == DRM_PLANE_TYPE_PRIMARY &&
 	    mdev_state->active_id != plane->dmabuf_id) {
-		dev_dbg(dev, "%s: primary: %d => %d\n", __func__,
-			mdev_state->active_id, plane->dmabuf_id);
+		dev_dbg(mdev_state->vdev.dev, "%s: primary: %d => %d\n",
+			__func__, mdev_state->active_id, plane->dmabuf_id);
 		mdev_state->active_id = plane->dmabuf_id;
 	}
 	mutex_unlock(&mdev_state->ops_lock);
 	return 0;
 }
 
-static int mbochs_get_gfx_dmabuf(struct mdev_device *mdev,
-				 u32 id)
+static int mbochs_get_gfx_dmabuf(struct mdev_state *mdev_state, u32 id)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
 	struct mbochs_dmabuf *dmabuf;
 
 	mutex_lock(&mdev_state->ops_lock);
@@ -1156,9 +1154,11 @@ static int mbochs_get_gfx_dmabuf(struct mdev_device *mdev,
 	return dma_buf_fd(dmabuf->buf, 0);
 }
 
-static long mbochs_ioctl(struct mdev_device *mdev, unsigned int cmd,
-			unsigned long arg)
+static long mbochs_ioctl(struct vfio_device *vdev, unsigned int cmd,
+			 unsigned long arg)
 {
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 	int ret = 0;
 	unsigned long minsz, outsz;
 
@@ -1175,7 +1175,7 @@ static long mbochs_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		ret = mbochs_get_device_info(mdev, &info);
+		ret = mbochs_get_device_info(&info);
 		if (ret)
 			return ret;
 
@@ -1199,7 +1199,7 @@ static long mbochs_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (outsz > sizeof(info))
 			return -EINVAL;
 
-		ret = mbochs_get_region_info(mdev, &info);
+		ret = mbochs_get_region_info(mdev_state, &info);
 		if (ret)
 			return ret;
 
@@ -1222,7 +1222,7 @@ static long mbochs_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		    (info.index >= VFIO_PCI_NUM_IRQS))
 			return -EINVAL;
 
-		ret = mbochs_get_irq_info(mdev, &info);
+		ret = mbochs_get_irq_info(&info);
 		if (ret)
 			return ret;
 
@@ -1245,7 +1245,7 @@ static long mbochs_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (plane.argsz < minsz)
 			return -EINVAL;
 
-		ret = mbochs_query_gfx_plane(mdev, &plane);
+		ret = mbochs_query_gfx_plane(mdev_state, &plane);
 		if (ret)
 			return ret;
 
@@ -1262,19 +1262,19 @@ static long mbochs_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (get_user(dmabuf_id, (__u32 __user *)arg))
 			return -EFAULT;
 
-		return mbochs_get_gfx_dmabuf(mdev, dmabuf_id);
+		return mbochs_get_gfx_dmabuf(mdev_state, dmabuf_id);
 	}
 
 	case VFIO_DEVICE_SET_IRQS:
 		return -EINVAL;
 
 	case VFIO_DEVICE_RESET:
-		return mbochs_reset(mdev);
+		return mbochs_reset(mdev_state);
 	}
 	return -ENOTTY;
 }
 
-static int mbochs_open(struct mdev_device *mdev)
+static int mbochs_open(struct vfio_device *vdev)
 {
 	if (!try_module_get(THIS_MODULE))
 		return -ENODEV;
@@ -1282,9 +1282,10 @@ static int mbochs_open(struct mdev_device *mdev)
 	return 0;
 }
 
-static void mbochs_close(struct mdev_device *mdev)
+static void mbochs_close(struct vfio_device *vdev)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 	struct mbochs_dmabuf *dmabuf, *tmp;
 
 	mutex_lock(&mdev_state->ops_lock);
@@ -1308,8 +1309,7 @@ static ssize_t
 memory_show(struct device *dev, struct device_attribute *attr,
 	    char *buf)
 {
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
+	struct mdev_state *mdev_state = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%d MB\n", mdev_state->type->mbytes);
 }
@@ -1400,18 +1400,30 @@ static struct attribute_group *mdev_type_groups[] = {
 	NULL,
 };
 
+static const struct vfio_device_ops mbochs_dev_ops = {
+	.open = mbochs_open,
+	.release = mbochs_close,
+	.read = mbochs_read,
+	.write = mbochs_write,
+	.ioctl = mbochs_ioctl,
+	.mmap = mbochs_mmap,
+};
+
+static struct mdev_driver mbochs_driver = {
+	.driver = {
+		.name = "mbochs",
+		.owner = THIS_MODULE,
+		.mod_name = KBUILD_MODNAME,
+		.dev_groups = mdev_dev_groups,
+	},
+	.probe = mbochs_probe,
+	.remove	= mbochs_remove,
+};
+
 static const struct mdev_parent_ops mdev_fops = {
 	.owner			= THIS_MODULE,
-	.mdev_attr_groups	= mdev_dev_groups,
+	.device_driver		= &mbochs_driver,
 	.supported_type_groups	= mdev_type_groups,
-	.create			= mbochs_create,
-	.remove			= mbochs_remove,
-	.open			= mbochs_open,
-	.release		= mbochs_close,
-	.read			= mbochs_read,
-	.write			= mbochs_write,
-	.ioctl			= mbochs_ioctl,
-	.mmap			= mbochs_mmap,
 };
 
 static const struct file_operations vd_fops = {
@@ -1436,11 +1448,15 @@ static int __init mbochs_dev_init(void)
 	cdev_add(&mbochs_cdev, mbochs_devt, MINORMASK + 1);
 	pr_info("%s: major %d\n", __func__, MAJOR(mbochs_devt));
 
+	ret = mdev_register_driver(&mbochs_driver);
+	if (ret)
+		goto err_cdev;
+
 	mbochs_class = class_create(THIS_MODULE, MBOCHS_CLASS_NAME);
 	if (IS_ERR(mbochs_class)) {
 		pr_err("Error: failed to register mbochs_dev class\n");
 		ret = PTR_ERR(mbochs_class);
-		goto failed1;
+		goto err_driver;
 	}
 	mbochs_dev.class = mbochs_class;
 	mbochs_dev.release = mbochs_device_release;
@@ -1448,19 +1464,21 @@ static int __init mbochs_dev_init(void)
 
 	ret = device_register(&mbochs_dev);
 	if (ret)
-		goto failed2;
+		goto err_class;
 
 	ret = mdev_register_device(&mbochs_dev, &mdev_fops);
 	if (ret)
-		goto failed3;
+		goto err_device;
 
 	return 0;
 
-failed3:
+err_device:
 	device_unregister(&mbochs_dev);
-failed2:
+err_class:
 	class_destroy(mbochs_class);
-failed1:
+err_driver:
+	mdev_unregister_driver(&mbochs_driver);
+err_cdev:
 	cdev_del(&mbochs_cdev);
 	unregister_chrdev_region(mbochs_devt, MINORMASK + 1);
 	return ret;
@@ -1472,6 +1490,7 @@ static void __exit mbochs_dev_exit(void)
 	mdev_unregister_device(&mbochs_dev);
 
 	device_unregister(&mbochs_dev);
+	mdev_unregister_driver(&mbochs_driver);
 	cdev_del(&mbochs_cdev);
 	unregister_chrdev_region(mbochs_devt, MINORMASK + 1);
 	class_destroy(mbochs_class);
-- 
2.31.1

