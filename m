Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B07F950905B
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 21:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381794AbiDTT0W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 15:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381783AbiDTT0R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 15:26:17 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F419A4664C
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 12:23:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MePK3S6Be0gs3LsQeS8zlH1X/xwlpfwoUImifiRqCc5JDnuOTcZ26j/59LKN6NWciv1YCSgsbN7S+7qTKE4XXecPpV1UjgWMXUDcncnCoVK+EST6DbtPQsc6naFp29aeODWbdqfVmRvEPJ59/y3xti8/11SoRvaskvKGlAg3CLKl7Cszd+m8iisKPwcFtDi801dx2bunGGztmcW2zaZvBtjIH9lTrYf6ka514+4mFZxIVWdEyR0MFjCPH+8Ynwbx4T12o21GokS02CTSvjPoEieM0n7ES5xhmtNjd9kPLUgn1erLtL+7jUNlItzhezEUC2nKxLl6tnqs2dj6+KYBvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ah5ovzd4PiV/QUaYlz0fMzMtAV6K5NiUJprsfm/iGpY=;
 b=cYimPLbRjRpctNpd1V1EQRaJAme5q5aAbamvqipUKItVXg6xSxglXNDcjrePx+J/nAeP5/1ItPHu7k+o9BWQbxXF96WLIoIpn+0dP9ZSp6dLr2vlVxga6192x/dh1zall+sdpTfvRY1BKUdvp3YaxLk1GU0gG3avGhIxymms4eCMqOP1IoDhr2FDLHI5Nhu9nJF0IyeefRBLsXj/9JocfHkkeqwhUoSrvDUgxLt7Vn1ViHj8b8sVd/6rVuoS1PAHnOalVaYRpFmkjvRsmzEg5gD+cOePwu4Lm1Ih2TN9tBNVnXEOdRGHS32VlhPCBCzN4c3jiXYFAEuQl+RhnZMErg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ah5ovzd4PiV/QUaYlz0fMzMtAV6K5NiUJprsfm/iGpY=;
 b=uB0jTSztOdjLdMkxQ7M/+VmxJvg9u8Ok9S7M0nhY/CsNIf5yJBDZ/O1TH8wui705tNESNaQGWs45zONo8Bg/oufGBqVN0a8tVoWmRmHpYS+qeqgaZaHPIMddRNUTjYiMPOEV5JlqDh0/BuBPyss7eQfjRVkd/rHWvA82uRlyFk8b5QwD7jtwmy2+musrQwkLmH4+gUxqIoVWMXiJ+u5FyjuJ/lyU7i1l/C6eu+GwEA/obGh+JXGyEYA/M7wDGY2XryHIeFdzgqkIHYu9/KpKVnxHbH/VrwBvO08ItYhACjzw8Tvm4VGmbD4vd96ZjLkVWqBANc0JAp77LjJQ3B8/qA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB4131.namprd12.prod.outlook.com (2603:10b6:a03:212::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Wed, 20 Apr
 2022 19:23:24 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.014; Wed, 20 Apr 2022
 19:23:24 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v2 4/8] vfio: Remove vfio_external_group_match_file()
Date:   Wed, 20 Apr 2022 16:23:13 -0300
Message-Id: <4-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0098.namprd03.prod.outlook.com
 (2603:10b6:208:32a::13) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d529cea-fbfa-48f9-d023-08da23033a2c
X-MS-TrafficTypeDiagnostic: BY5PR12MB4131:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB41315B5E36B9A9BFAC41874BC2F59@BY5PR12MB4131.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jv4QrZGwtRxsPABM5fWdG5rtdtoxAkdVL8M09IvO35WWb7BNIU9pX8XDd3iDnOGQ7xXch4WPCCbf2g9Yl3dXUGVVWnNNRXV5Ek6SITyPBjXHYD1JuzXDHazFqmi5gjgP9FS+HmcfAiQJ+Uc1uocny2iQjuspaDk+kah2Zdg2Ifad4PaejRKCiF4scid0QrGzbGh0u8GPzDR7g5xhJbHscrg4cJAYDruwakZDhZQuTqCsdoMlyrvhQTChHf36485rCErsh2fQa+RZFQg7YIXJD/ZlZAREPASZ99MPoZq+1W3+Yd5Jt4kfL8hnenyQaZdIJWNxycQ5lMEsXe3OPJ53dSoHbfolHNWMKkOyr37nIU5Ow2BBoOxIBOVn1eHXUxwn42wfNmilwKc31bHMmPFQialkarHyWKXRcNwTZrolfeuYaFXDscpL0UTTrtPk1hZpmUoKBsrrxuWOLWJv0yEIQ+gIJmDFY+kS1BYbgHeFkXkSdJli9yeqLVO9MU4F8MMjvNoO5OsFjCTxMwtlWpId8wlNdjyQTMBnBn8IYnGHrvlORRwc0cxeXYWWrp9+I01wMFhm3qKe6DP8sl0jseSrq6gAeLB4Zf3XAIp4mTLDQLnThniPzA5HaKrkxQJjwYReAWEMJbEchnyEpqTUFWYnkVYmGG4AvZo0hQZyHxHUpj8PwRrjqehiuQkRVGXN/VVd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(38100700002)(6512007)(36756003)(6506007)(66946007)(2616005)(186003)(6666004)(66476007)(8676002)(66556008)(8936002)(316002)(4326008)(5660300002)(86362001)(83380400001)(110136005)(54906003)(508600001)(6486002)(2906002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HVDW3kJ9YvfEf5Tsq6M8/BtGhJ7s1ADDCnpr1q1jR4Oopi19KK50LZyFSbN6?=
 =?us-ascii?Q?gLIcdJh0Hglb/Kfcb7YSWZL7FZOeck1ZCwo9USX5hTPGlRSXjRdMLABj8LOw?=
 =?us-ascii?Q?bZLqSEkT92NZEQsr1EaEXaCWSsURjscpNi3l2e2osSd0Y98nuomjgoBFjxUy?=
 =?us-ascii?Q?kR/DvZEpg/u2ufAh7tszv+/+CKHPa5LOnwxPN5r2ExTZRFuiWqm9TvQNVpOj?=
 =?us-ascii?Q?ZvlTvpPOhLKVa63QmP/Bca052dizioKXIyXQOlExiO4QDM4sIrJnBhtzlc2X?=
 =?us-ascii?Q?yNqem4vcutohegHbRMArZ05ztK23dCEFKKGebe8EDw96qRKuW1fMVASeq5ON?=
 =?us-ascii?Q?lcwrt8a3G34QdTJ7yGYvg89TnthxdnBXU/h2jKm28xgmQCluyLFs53wfIMhW?=
 =?us-ascii?Q?ZzR5jOsyC2Otiqf1QKQtejSCwrF3Yx2bQdef96d+eM3xHrZdP9RX9v9auBHu?=
 =?us-ascii?Q?HUagitqgtTdNiJ+o4Rk5AdjGJZ1/s3EO6WrJHwlUWFee7Ny7B8fLHQtQeSzu?=
 =?us-ascii?Q?aKj8pXeKrQbPfC5kQVt9EsJjIWqx9gJ2V/P0kGWgs7qCEd/CEXVdVkLNNxQa?=
 =?us-ascii?Q?kRuzgZ+VTdEx9EyQUGT7+JIhBjklefMSDr2F5/GW21ezijuOdRAOmuHwIfWQ?=
 =?us-ascii?Q?fFDzeJtDjqcO7e7VCwAKmprPI4roJ70y13fusdKKJ8JyOhvVv+OVcyAJA9ft?=
 =?us-ascii?Q?FSkvtmmKYubtL1oBXvGr9I46Tjo1jd58G2/d/8LPtVPRlNTGR12spGKLMScK?=
 =?us-ascii?Q?bSlRePX7hD9yoe8POZwUDrYG/90j47naN/LbAmliF0r3vMP/aia6V/1sy8Xl?=
 =?us-ascii?Q?bUf3a+jbQ2Zr2cvtl2Eb2CNx4+rTkdMiQGlPoWpIeIzGz/cyPxyf3wsTFD4f?=
 =?us-ascii?Q?QnVuhMJ8fVeqAI2rJySQq6UxXTCU5R77SH37VpU12UScfBoLzWQHrD7b7SiZ?=
 =?us-ascii?Q?XAv4C3eV96QKPZTe3Gg8xosgM3Qxq2SpLq7xqxRYDg+kokV6dNFBE4HS7qFh?=
 =?us-ascii?Q?EQ+mP79MZ6jTPqxRxoGV0lzgugcXOos/J00eimwWYMMfsYbICqY5MHYPJgV+?=
 =?us-ascii?Q?83T1IfGb1so+V4YwHdHECOAAbhKheS9/f4n/LsPRTbyNKMuAcTgWFnJghbnY?=
 =?us-ascii?Q?lY4lO0anoaUfqE4JAywdzxvTVviYETyA+SGG05MeShkfKjDj0a3rmDmPeJfS?=
 =?us-ascii?Q?WlV97nSrSQiyYiTpkgI3NpTtPPISA8WeyLfl3c4f+EOrquB6sT2a9WbWI0t6?=
 =?us-ascii?Q?YyJQVZRQpOfA/fyjaDEy8OUI1QCxi0BP2eRe1qoQ74OkcPl+bBJZmGZlAodT?=
 =?us-ascii?Q?Lf4Inkv0QgkaQOiOOHJGdZaQVi7u5x2pNUNzK8UAL6D0e18CY+376AwTRz0I?=
 =?us-ascii?Q?NKAaDX4CzcF5xxoriy79j7wDa5sBpXHGvorFMqjmG+980W8l+g0hLW7Mybwb?=
 =?us-ascii?Q?sVvjMVLqY6sKtddtiYOg+0ry8n/E0r8n7JHEUNOI/BnVcRECSgGBrJeKpHcR?=
 =?us-ascii?Q?sPDryz56qo7F5Xmav1/9n4XGycu5U9MMZ6RisYcMN9Gi7DEoMRVDnn6km/T2?=
 =?us-ascii?Q?mmRZKxA1zMfRBYnXyytr51Bh7s5sVNSajBqIz/Ai4YwFMZUn4Z6Ex86TsQzW?=
 =?us-ascii?Q?aZHzijqbi16WBJSDvgC8lh7v4e+IJvAwQ1ERtKrFQcsknVIyk/Wfs/7m4fsm?=
 =?us-ascii?Q?7QkZEdjOQFkfKUANu98+g8bHef+Z+qBLI3rK9DDk6BvHdPtv+riNUV55NOOI?=
 =?us-ascii?Q?DXFKCv6gbw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d529cea-fbfa-48f9-d023-08da23033a2c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 19:23:19.6266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S3lYffw9rZmoEBq9uUm1vXuQ17wsWoJX3wyC6fjP07eD9M0ymuuZycr+L2SwL0xN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4131
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_group_fops_open() ensures there is only ever one struct file open for
any struct vfio_group at any time:

	/* Do we need multiple instances of the group open?  Seems not. */
	opened = atomic_cmpxchg(&group->opened, 0, 1);
	if (opened) {
		vfio_group_put(group);
		return -EBUSY;

Therefor the struct file * can be used directly to search the list of VFIO
groups that KVM keeps instead of using the
vfio_external_group_match_file() callback to try to figure out if the
passed in FD matches the list or not.

Delete vfio_external_group_match_file().

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c  |  9 ---------
 include/linux/vfio.h |  2 --
 virt/kvm/vfio.c      | 19 +------------------
 3 files changed, 1 insertion(+), 29 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 3444d36714e933..c9122c84583aa1 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1989,15 +1989,6 @@ void vfio_group_put_external_user(struct vfio_group *group)
 }
 EXPORT_SYMBOL_GPL(vfio_group_put_external_user);
 
-bool vfio_external_group_match_file(struct vfio_group *test_group,
-				    struct file *filep)
-{
-	struct vfio_group *group = filep->private_data;
-
-	return (filep->f_op == &vfio_group_fops) && (group == test_group);
-}
-EXPORT_SYMBOL_GPL(vfio_external_group_match_file);
-
 /**
  * vfio_file_iommu_group - Return the struct iommu_group for the vfio group file
  * @file: VFIO group file
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 8b53fd9920d24a..132cf3e7cda8db 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -142,8 +142,6 @@ extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
 extern void vfio_group_put_external_user(struct vfio_group *group);
 extern struct vfio_group *vfio_group_get_external_user_from_dev(struct device
 								*dev);
-extern bool vfio_external_group_match_file(struct vfio_group *group,
-					   struct file *filep);
 extern struct iommu_group *vfio_file_iommu_group(struct file *file);
 extern long vfio_external_check_extension(struct vfio_group *group,
 					  unsigned long arg);
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 1655d3aebd16b4..50193ae270faca 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -49,22 +49,6 @@ static struct vfio_group *kvm_vfio_group_get_external_user(struct file *filep)
 	return vfio_group;
 }
 
-static bool kvm_vfio_external_group_match_file(struct vfio_group *group,
-					       struct file *filep)
-{
-	bool ret, (*fn)(struct vfio_group *, struct file *);
-
-	fn = symbol_get(vfio_external_group_match_file);
-	if (!fn)
-		return false;
-
-	ret = fn(group, filep);
-
-	symbol_put(vfio_external_group_match_file);
-
-	return ret;
-}
-
 static void kvm_vfio_group_put_external_user(struct vfio_group *vfio_group)
 {
 	void (*fn)(struct vfio_group *);
@@ -239,8 +223,7 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
 	mutex_lock(&kv->lock);
 
 	list_for_each_entry(kvg, &kv->group_list, node) {
-		if (!kvm_vfio_external_group_match_file(kvg->vfio_group,
-							f.file))
+		if (kvg->file != f.file)
 			continue;
 
 		list_del(&kvg->node);
-- 
2.36.0

