Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8074DDFE4
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 18:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239613AbiCRR3I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 13:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239625AbiCRR3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 13:29:06 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755911D760B
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 10:27:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mu+qOfiI+YRp1c3rJQ+Avs7ZCDYb2aHzmYQI3mPd3MWQYU3OhVyq9McNHXe4EgkzauD4U30CuOKk7nk/E/ITzQ9/33rQuJOIqmgEH2i1I6lFLD4QmZVF3L5R/F0nPoE1BnDTrIHuFmh5aeHLZoxyoTs7C0W+Qza7EXqOWh+d7hszm8ZvMC80xP3rFQUkNB8ssASGJDNdmPCuNXCsNCp4ghwWcJTOJyfjJT2rSwhHeWFEMOz3uYKmDQeZdf8ojTI3GXgv7wyjxtMDLEsqvwZSq5M/O2NQEjOWeal+oKCIf+PHm6b7xytGlxb4e2jmepI3mCSm462MxkWQO1jOUiIS+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AQGLja04H36JFoOTaYZ9umb2UUg4OA06Tn48eck7Lkg=;
 b=MfK6e4wJTzYvVi+1CaS1awvBL5rCsozQtQL1ArfzHVxllg4iUvTpnhaRxZkd7UD/wGA92RNr95dp57gG7fuqzcgs1rb6LbL+3Rnj2hM1NfJV0ZRXdEdvcQifYZ5GAPmsQ3io8AS20zZ+rrwYqDzGJffjh3jl4XBnrNnDe1KPf/cUsD6WF9CBXtWlNEzy9RpVN6BMdsQs2OOODcfcNcxvlN8CiN2TzLVMdGJU3EArbzTf6uKFzk5MikuBUhSOyOKDxMEiGBMFRhwSnKcACcTQiTqUKRxlu+iOUuEzaAp/ZH5+IbOBeKPDBPr/xQdelRV+T4HuwIsvmqT1iKBj0au4ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AQGLja04H36JFoOTaYZ9umb2UUg4OA06Tn48eck7Lkg=;
 b=MbkPTcqnWp02Bf5N/B4ruV+ApRLeRzdTjTNThCtq93KfpKK7CheF375x7c85GYKphkJxi4HZTNBcq1uWnwJ9GWtL/fU9SqTYhR69+os6f4vpAE6WgZT/mZvu358bmwqoJg/Yyhhr/3cw2y9SgqUYbdezUFDseP9s2TXrzy62zJfWBZMRnEqAhaxHbh9KADGzd2SaVWaJWUNQtz8PCCKdufO+IQZt58F4I3gCnJKL8EYl8cIqr+HR9iE656qMG0DNi/NOF+XLc/3le3qfaJaqn9VnztI5SwDB5SWGJPCetIdmnqpD9HUjCSe0YHBEiKsA7nrq19o/s6rxHbwO63kH6A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3951.namprd12.prod.outlook.com (2603:10b6:208:16b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Fri, 18 Mar
 2022 17:27:41 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 17:27:41 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Date:   Fri, 18 Mar 2022 14:27:36 -0300
Message-Id: <11-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0062.namprd19.prod.outlook.com
 (2603:10b6:208:19b::39) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4056a38a-62a5-43e3-d3f4-08da090499f4
X-MS-TrafficTypeDiagnostic: MN2PR12MB3951:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB395129C672D83D77ECE81B86C2139@MN2PR12MB3951.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NHZnOfm5z3E1+iNmlycTfm3tEutetq460oyTZrQ/GUxEUn1YXmewnkvjvGfNUm5O/s1HVMc+wxkzn/tUx055NSLBaY3h7aLBOI0yj2rXQxXUDN4BiN2pFe9+R17TH02RM+WWUzPZQSjUkcXo12yWC3MpZMg6lvM8gTLqDN8i5jcgc8EZS8DQDmULdSBHgWu4ZQhr35TFGBXFoUiFhqYg11ufVnRtt9VF6llOylMD/vPO2jJJ63uezTcGtNH/BH77RVrIzDt5pP6WcSni+4RpiHlbl5r98tVgOfMDgmpLpVvhGqmuKKgG1+arenbVNHyY48oulxKwvgsvsrA8bp90/X8vD1Ztha2MB9WPsx4w5cpyeEKSliW0L9Nl0YKHJdTi/WArbgblUNk0PkVXZwo5a8T2xO+8hQrgEVBjtBul7prqXya412biMJHYdrKNPYqVeesF5uZ3rwUYj4oqctjnEOxm1Xk6u7nzdhUspULSHPkMIRqLgTphkOzHg/yf+f4TxWeWuj0Uut7R0NST8TUF9GWKFxEyNX1NQRmL8kLtGtx9/Lo6uCTXlpsc50okoHrN6XHEykSGLRXE/8Maevm3XwDETRnpC1ThFtN2sfO6Y7qCXYGi1N7FWxDCsCK5s3g7sfrpNLhTZxUSGEYBWWjqsOwk6i3nVaQ/eiUxng59JFT2zUpi6no28N3y8/LgfvQL6GLwB5KcGTXrfBpVgukf773y18p09sfCStH3y2mjPjfLbswLa9RhMweZhUA+3KUv8IfvfXQlXY65mD1Y1ez17g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(30864003)(83380400001)(7416002)(4326008)(2906002)(86362001)(508600001)(8676002)(6512007)(6506007)(6666004)(5660300002)(8936002)(109986005)(66946007)(26005)(66476007)(186003)(316002)(66556008)(2616005)(36756003)(966005)(38100700002)(6486002)(54906003)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sqqleW67+biqhGyfWs3J9OVW7yg0UgviYdj16vq9BZUqNSsjrwIZ9pSAndwP?=
 =?us-ascii?Q?J/cxkZJ4AS0GBifM9H5PZuy7RG3I0NSFtDC/RJ71dnumwQxR6V4+jz3OQiWM?=
 =?us-ascii?Q?oaCayHPerJJwfPDoFscJ8poyx/Q9uv0aRy24KZFt9NJwshUbQcm7SXvV+zfU?=
 =?us-ascii?Q?RZfr4Vg0sSb3kbrAbaAQ1sOUy5r/VWxSB8DnJXB6z3pzq94CkR1MimSlGGyd?=
 =?us-ascii?Q?7dZz/SnZ3OmsE/BbG2+YV/mG/CPpqWT9+8Rp1LE4zzy7h9X73sirMylaYwKn?=
 =?us-ascii?Q?2V7K23EdvVD6P6A0Pndt58vkChU3D7QKeFbMrTF17nYzPEOav1TVxM2QdONJ?=
 =?us-ascii?Q?3KiIo7ag3rVVPgwll73HXDLTR7+VYdF5SRusV7nkGyCnP+3khjyMceZcgS3S?=
 =?us-ascii?Q?Q6LFdN7G7YLsurLubpqCT1Ul23+MiXYYzzIUvODdgkJsZ2m9d6qsqsgO/76M?=
 =?us-ascii?Q?1V/TvvGTadjAg1M+Vkr1qFMmMHKSbSadNeYer53QjZ1yXZyOFJLSL2N2FmT/?=
 =?us-ascii?Q?hv/BRWRp6wHOPiQRTEiz9b59SYTCKwvyzy04V95vJ8WNoR5SaAEqmpZZ00kH?=
 =?us-ascii?Q?s1057shYaiEzlLuwVA5GXQsY1Ukc6lcF4hGpE8MshCY1F2QULUaoPKm9ccbu?=
 =?us-ascii?Q?MDVwv/3JlEPo7WTAFp4C66CVtR6oZfOG21ibVg/0DdctdgMPP6jdJXzcUSZE?=
 =?us-ascii?Q?mLkCNRmWIsOF45RfLPCH1VUreFJFnLUx8jAUwJbImmR1qps0Py0jYez+wRaH?=
 =?us-ascii?Q?YQM0Fr/WRlt+QoMkkDaq4neBlCco0xsy35MkKA7teQfBPWXOSA5W6MSilZhH?=
 =?us-ascii?Q?AyD+SymRtFTemqRf38aYl8xTTjjcMNWdDvaG9RKHvPEdUNLQ3nfBYTIIF5d3?=
 =?us-ascii?Q?Y7pYgs+AezAVdiHeEbUpwnH09kmXosWgsWCRQ7Evss75MMyz++PORUPl5/0E?=
 =?us-ascii?Q?J0gou4ZwjSa/6PvkdNlHmfNldLdEDzxqoPUYbJgM0uxAgu9wcO1hGP6NEonJ?=
 =?us-ascii?Q?bAFgKS/MmhIYAsRNgLHD/aK8A8tMsgqMUIVdJTmpMoAp7pnyRQtxzJZPH1jU?=
 =?us-ascii?Q?lLk4bxeiLkIG2EMLE1eP4xmqUFbS22+Zv6g7LRJPVo3BUZfRsg8Q5KFY4ldE?=
 =?us-ascii?Q?6+wZuYyTU9JnLGaiWBpPGf/QrpaIpPz7WXH/yR80Be6aUc7Fa/isGQncpxSm?=
 =?us-ascii?Q?LJaMVd3iz80chdMLdOoBg9Hi1x14S8xhXa+e+RtoKJ4GeM6/JlIwzMkjfS1h?=
 =?us-ascii?Q?FK3ZHs0zCr4KDl9C/uDp6/3iEzBiwZQBfpjWTHdA8l7O+kgvov3hZCkJPYO+?=
 =?us-ascii?Q?TBiUlrvPFciecA5bOxlWqFtSRKdR+c9LQFUICuYYEVIdoz1MXrezdQr/inFx?=
 =?us-ascii?Q?m9jDs3XMX20C6xmmlXGMW4PWBUkmZfjf7F0YaSGp65CK1yBQDOtpxZgK8PeQ?=
 =?us-ascii?Q?c06AorukeUeznnJpQqJCymi6i///FCsL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4056a38a-62a5-43e3-d3f4-08da090499f4
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 17:27:39.5698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PEeh8rzGn9bHzYNjDL4quNrs9i81JSAJuxIPBV0lsXywqM/eWOIyOmQv3H7j/vWa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3951
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

iommufd can directly implement the /dev/vfio/vfio container IOCTLs by
mapping them into io_pagetable operations. Doing so allows the use of
iommufd by symliking /dev/vfio/vfio to /dev/iommufd. Allowing VFIO to
SET_CONTAINER using a iommufd instead of a container fd is a followup
series.

Internally the compatibility API uses a normal IOAS object that, like
vfio, is automatically allocated when the first device is
attached.

Userspace can also query or set this IOAS object directly using the
IOMMU_VFIO_IOAS ioctl. This allows mixing and matching new iommufd only
features while still using the VFIO style map/unmap ioctls.

While this is enough to operate qemu, it is still a bit of a WIP with a
few gaps to be resolved:

 - Only the TYPE1v2 mode is supported where unmap cannot punch holes or
   split areas. The old mode can be implemented with a new operation to
   split an iopt_area into two without disturbing the iopt_pages or the
   domains, then unmapping a whole area as normal.

 - Resource limits rely on memory cgroups to bound what userspace can do
   instead of the module parameter dma_entry_limit.

 - VFIO P2P is not implemented. Avoiding the follow_pfn() mis-design will
   require some additional work to properly expose PFN lifecycle between
   VFIO and iommfd

 - Various components of the mdev API are not completed yet

 - Indefinite suspend of SW access (VFIO_DMA_MAP_FLAG_VADDR) is not
   implemented.

 - The 'dirty tracking' is not implemented

 - A full audit for pedantic compatibility details (eg errnos, etc) has
   not yet been done

 - powerpc SPAPR is left out, as it is not connected to the iommu_domain
   framework. My hope is that SPAPR will be moved into the iommu_domain
   framework as a special HW specific type and would expect power to
   support the generic interface through a normal iommu_domain.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/Makefile          |   3 +-
 drivers/iommu/iommufd/iommufd_private.h |   6 +
 drivers/iommu/iommufd/main.c            |  16 +-
 drivers/iommu/iommufd/vfio_compat.c     | 401 ++++++++++++++++++++++++
 include/uapi/linux/iommufd.h            |  36 +++
 5 files changed, 456 insertions(+), 6 deletions(-)
 create mode 100644 drivers/iommu/iommufd/vfio_compat.c

diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
index ca28a135b9675f..2fdff04000b326 100644
--- a/drivers/iommu/iommufd/Makefile
+++ b/drivers/iommu/iommufd/Makefile
@@ -5,6 +5,7 @@ iommufd-y := \
 	io_pagetable.o \
 	ioas.o \
 	main.o \
-	pages.o
+	pages.o \
+	vfio_compat.o
 
 obj-$(CONFIG_IOMMUFD) += iommufd.o
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index e5c717231f851e..31628591591c17 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -67,6 +67,8 @@ void iopt_remove_reserved_iova(struct io_pagetable *iopt, void *owner);
 struct iommufd_ctx {
 	struct file *filp;
 	struct xarray objects;
+
+	struct iommufd_ioas *vfio_ioas;
 };
 
 struct iommufd_ctx *iommufd_fget(int fd);
@@ -78,6 +80,9 @@ struct iommufd_ucmd {
 	void *cmd;
 };
 
+int iommufd_vfio_ioctl(struct iommufd_ctx *ictx, unsigned int cmd,
+		       unsigned long arg);
+
 /* Copy the response in ucmd->cmd back to userspace. */
 static inline int iommufd_ucmd_respond(struct iommufd_ucmd *ucmd,
 				       size_t cmd_len)
@@ -186,6 +191,7 @@ int iommufd_ioas_iova_ranges(struct iommufd_ucmd *ucmd);
 int iommufd_ioas_map(struct iommufd_ucmd *ucmd);
 int iommufd_ioas_copy(struct iommufd_ucmd *ucmd);
 int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd);
+int iommufd_vfio_ioas(struct iommufd_ucmd *ucmd);
 
 /*
  * A HW pagetable is called an iommu_domain inside the kernel. This user object
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 6a895489fb5b82..f746fcff8145cb 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -122,6 +122,8 @@ bool iommufd_object_destroy_user(struct iommufd_ctx *ictx,
 		return false;
 	}
 	__xa_erase(&ictx->objects, obj->id);
+	if (ictx->vfio_ioas && &ictx->vfio_ioas->obj == obj)
+		ictx->vfio_ioas = NULL;
 	xa_unlock(&ictx->objects);
 
 	iommufd_object_ops[obj->type].destroy(obj);
@@ -219,27 +221,31 @@ static struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
 		 __reserved),
 	IOCTL_OP(IOMMU_IOAS_UNMAP, iommufd_ioas_unmap, struct iommu_ioas_unmap,
 		 length),
+	IOCTL_OP(IOMMU_VFIO_IOAS, iommufd_vfio_ioas, struct iommu_vfio_ioas,
+		 __reserved),
 };
 
 static long iommufd_fops_ioctl(struct file *filp, unsigned int cmd,
 			       unsigned long arg)
 {
+	struct iommufd_ctx *ictx = filp->private_data;
 	struct iommufd_ucmd ucmd = {};
 	struct iommufd_ioctl_op *op;
 	union ucmd_buffer buf;
 	unsigned int nr;
 	int ret;
 
-	ucmd.ictx = filp->private_data;
+	nr = _IOC_NR(cmd);
+	if (nr < IOMMUFD_CMD_BASE ||
+	    (nr - IOMMUFD_CMD_BASE) >= ARRAY_SIZE(iommufd_ioctl_ops))
+		return iommufd_vfio_ioctl(ictx, cmd, arg);
+
+	ucmd.ictx = ictx;
 	ucmd.ubuffer = (void __user *)arg;
 	ret = get_user(ucmd.user_size, (u32 __user *)ucmd.ubuffer);
 	if (ret)
 		return ret;
 
-	nr = _IOC_NR(cmd);
-	if (nr < IOMMUFD_CMD_BASE ||
-	    (nr - IOMMUFD_CMD_BASE) >= ARRAY_SIZE(iommufd_ioctl_ops))
-		return -ENOIOCTLCMD;
 	op = &iommufd_ioctl_ops[nr - IOMMUFD_CMD_BASE];
 	if (op->ioctl_num != cmd)
 		return -ENOIOCTLCMD;
diff --git a/drivers/iommu/iommufd/vfio_compat.c b/drivers/iommu/iommufd/vfio_compat.c
new file mode 100644
index 00000000000000..5c996bc9b44d48
--- /dev/null
+++ b/drivers/iommu/iommufd/vfio_compat.c
@@ -0,0 +1,401 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
+ */
+#include <linux/file.h>
+#include <linux/interval_tree.h>
+#include <linux/iommu.h>
+#include <linux/iommufd.h>
+#include <linux/slab.h>
+#include <linux/vfio.h>
+#include <uapi/linux/vfio.h>
+#include <uapi/linux/iommufd.h>
+
+#include "iommufd_private.h"
+
+static struct iommufd_ioas *get_compat_ioas(struct iommufd_ctx *ictx)
+{
+	struct iommufd_ioas *ioas = ERR_PTR(-ENODEV);
+
+	xa_lock(&ictx->objects);
+	if (!ictx->vfio_ioas || !iommufd_lock_obj(&ictx->vfio_ioas->obj))
+		goto out_unlock;
+	ioas = ictx->vfio_ioas;
+out_unlock:
+	xa_unlock(&ictx->objects);
+	return ioas;
+}
+
+/*
+ * Only attaching a group should cause a default creation of the internal ioas,
+ * this returns the existing ioas if it has already been assigned somehow
+ * FIXME: maybe_unused
+ */
+static __maybe_unused struct iommufd_ioas *
+create_compat_ioas(struct iommufd_ctx *ictx)
+{
+	struct iommufd_ioas *ioas = NULL;
+	struct iommufd_ioas *out_ioas;
+
+	ioas = iommufd_ioas_alloc(ictx);
+	if (IS_ERR(ioas))
+		return ioas;
+
+	xa_lock(&ictx->objects);
+	if (ictx->vfio_ioas && iommufd_lock_obj(&ictx->vfio_ioas->obj))
+		out_ioas = ictx->vfio_ioas;
+	else
+		out_ioas = ioas;
+	xa_unlock(&ictx->objects);
+
+	if (out_ioas != ioas) {
+		iommufd_object_abort(ictx, &ioas->obj);
+		return out_ioas;
+	}
+	if (!iommufd_lock_obj(&ioas->obj))
+		WARN_ON(true);
+	iommufd_object_finalize(ictx, &ioas->obj);
+	return ioas;
+}
+
+int iommufd_vfio_ioas(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_vfio_ioas *cmd = ucmd->cmd;
+	struct iommufd_ioas *ioas;
+
+	if (cmd->__reserved)
+		return -EOPNOTSUPP;
+	switch (cmd->op) {
+	case IOMMU_VFIO_IOAS_GET:
+		ioas = get_compat_ioas(ucmd->ictx);
+		if (IS_ERR(ioas))
+			return PTR_ERR(ioas);
+		cmd->ioas_id = ioas->obj.id;
+		iommufd_put_object(&ioas->obj);
+		return iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+
+	case IOMMU_VFIO_IOAS_SET:
+		ioas = iommufd_get_ioas(ucmd, cmd->ioas_id);
+		if (IS_ERR(ioas))
+			return PTR_ERR(ioas);
+		xa_lock(&ucmd->ictx->objects);
+		ucmd->ictx->vfio_ioas = ioas;
+		xa_unlock(&ucmd->ictx->objects);
+		iommufd_put_object(&ioas->obj);
+		return 0;
+
+	case IOMMU_VFIO_IOAS_CLEAR:
+		xa_lock(&ucmd->ictx->objects);
+		ucmd->ictx->vfio_ioas = NULL;
+		xa_unlock(&ucmd->ictx->objects);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int iommufd_vfio_map_dma(struct iommufd_ctx *ictx, unsigned int cmd,
+				void __user *arg)
+{
+	u32 supported_flags = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE;
+	size_t minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
+	struct vfio_iommu_type1_dma_map map;
+	int iommu_prot = IOMMU_CACHE;
+	struct iommufd_ioas *ioas;
+	unsigned long iova;
+	int rc;
+
+	if (copy_from_user(&map, arg, minsz))
+		return -EFAULT;
+
+	if (map.argsz < minsz || map.flags & ~supported_flags)
+		return -EINVAL;
+
+	if (map.flags & VFIO_DMA_MAP_FLAG_READ)
+		iommu_prot |= IOMMU_READ;
+	if (map.flags & VFIO_DMA_MAP_FLAG_WRITE)
+		iommu_prot |= IOMMU_WRITE;
+
+	ioas = get_compat_ioas(ictx);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	iova = map.iova;
+	rc = iopt_map_user_pages(&ioas->iopt, &iova,
+				 u64_to_user_ptr(map.vaddr), map.size,
+				 iommu_prot, 0);
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
+
+static int iommufd_vfio_unmap_dma(struct iommufd_ctx *ictx, unsigned int cmd,
+				  void __user *arg)
+{
+	size_t minsz = offsetofend(struct vfio_iommu_type1_dma_unmap, size);
+	u32 supported_flags = VFIO_DMA_UNMAP_FLAG_ALL;
+	struct vfio_iommu_type1_dma_unmap unmap;
+	struct iommufd_ioas *ioas;
+	int rc;
+
+	if (copy_from_user(&unmap, arg, minsz))
+		return -EFAULT;
+
+	if (unmap.argsz < minsz || unmap.flags & ~supported_flags)
+		return -EINVAL;
+
+	ioas = get_compat_ioas(ictx);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	if (unmap.flags & VFIO_DMA_UNMAP_FLAG_ALL)
+		rc = iopt_unmap_all(&ioas->iopt);
+	else
+		rc = iopt_unmap_iova(&ioas->iopt, unmap.iova, unmap.size);
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
+
+static int iommufd_vfio_check_extension(unsigned long type)
+{
+	switch (type) {
+	case VFIO_TYPE1v2_IOMMU:
+	case VFIO_UNMAP_ALL:
+		return 1;
+	/*
+	 * FIXME: The type1 iommu allows splitting of maps, which can fail. This is doable but
+	 * is a bunch of extra code that is only for supporting this case.
+	 */
+	case VFIO_TYPE1_IOMMU:
+	/*
+	 * FIXME: No idea what VFIO_TYPE1_NESTING_IOMMU does as far as the uAPI
+	 * is concerned. Seems like it was never completed, it only does
+	 * something on ARM, but I can't figure out what or how to use it. Can't
+	 * find any user implementation either.
+	 */
+	case VFIO_TYPE1_NESTING_IOMMU:
+	/*
+	 * FIXME: Easy to support, but needs rework in the Intel iommu driver
+	 * to expose the no snoop squashing to iommufd
+	 */
+	case VFIO_DMA_CC_IOMMU:
+	/*
+	 * FIXME: VFIO_DMA_MAP_FLAG_VADDR
+	 * https://lore.kernel.org/kvm/1611939252-7240-1-git-send-email-steven.sistare@oracle.com/
+	 * Wow, what a wild feature. This should have been implemented by
+	 * allowing a iopt_pages to be associated with a memfd. It can then
+	 * source mapping requests directly from a memfd without going through a
+	 * mm_struct and thus doesn't care that the original qemu exec'd itself.
+	 * The idea that userspace can flip a flag and cause kernel users to
+	 * block indefinately is unacceptable.
+	 *
+	 * For VFIO compat we should implement this in a slightly different way,
+	 * Creating a access_user that spans the whole area will immediately
+	 * stop new faults as they will be handled from the xarray. We can then
+	 * reparent the iopt_pages to the new mm_struct and undo the
+	 * access_user. No blockage of kernel users required, does require
+	 * filling the xarray with pages though.
+	 */
+	case VFIO_UPDATE_VADDR:
+	default:
+		return 0;
+	}
+
+ /* FIXME: VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP I think everything with dirty
+  * tracking should be in its own ioctl, not muddled in unmap. If we want to
+  * atomically unmap and get the dirty bitmap it should be a flag in the dirty
+  * tracking ioctl, not here in unmap. Overall dirty tracking needs a careful
+  * review along side HW drivers implementing it.
+  */
+}
+
+static int iommufd_vfio_set_iommu(struct iommufd_ctx *ictx, unsigned long type)
+{
+	struct iommufd_ioas *ioas = NULL;
+
+	if (type != VFIO_TYPE1v2_IOMMU)
+		return -EINVAL;
+
+	/* VFIO fails the set_iommu if there is no group */
+	ioas = get_compat_ioas(ictx);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+	iommufd_put_object(&ioas->obj);
+	return 0;
+}
+
+static u64 iommufd_get_pagesizes(struct iommufd_ioas *ioas)
+{
+	/* FIXME: See vfio_update_pgsize_bitmap(), for compat this should return
+	 * the high bits too, and we need to decide if we should report that
+	 * iommufd supports less than PAGE_SIZE alignment or stick to strict
+	 * compatibility. qemu only cares about the first set bit.
+	 */
+	return ioas->iopt.iova_alignment;
+}
+
+static int iommufd_fill_cap_iova(struct iommufd_ioas *ioas,
+				 struct vfio_info_cap_header __user *cur,
+				 size_t avail)
+{
+	struct vfio_iommu_type1_info_cap_iova_range __user *ucap_iovas =
+		container_of(cur, struct vfio_iommu_type1_info_cap_iova_range,
+			     header);
+	struct vfio_iommu_type1_info_cap_iova_range cap_iovas = {
+		.header = {
+			.id = VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE,
+			.version = 1,
+		},
+	};
+	struct interval_tree_span_iter span;
+
+	for (interval_tree_span_iter_first(
+		     &span, &ioas->iopt.reserved_iova_itree, 0, ULONG_MAX);
+	     !interval_tree_span_iter_done(&span);
+	     interval_tree_span_iter_next(&span)) {
+		struct vfio_iova_range range;
+
+		if (!span.is_hole)
+			continue;
+		range.start = span.start_hole;
+		range.end = span.last_hole;
+		if (avail >= struct_size(&cap_iovas, iova_ranges,
+					 cap_iovas.nr_iovas + 1) &&
+		    copy_to_user(&ucap_iovas->iova_ranges[cap_iovas.nr_iovas],
+				 &range, sizeof(range)))
+			return -EFAULT;
+		cap_iovas.nr_iovas++;
+	}
+	if (avail >= struct_size(&cap_iovas, iova_ranges, cap_iovas.nr_iovas) &&
+	    copy_to_user(ucap_iovas, &cap_iovas, sizeof(cap_iovas)))
+		return -EFAULT;
+	return struct_size(&cap_iovas, iova_ranges, cap_iovas.nr_iovas);
+}
+
+static int iommufd_fill_cap_dma_avail(struct iommufd_ioas *ioas,
+				      struct vfio_info_cap_header __user *cur,
+				      size_t avail)
+{
+	struct vfio_iommu_type1_info_dma_avail cap_dma = {
+		.header = {
+			.id = VFIO_IOMMU_TYPE1_INFO_DMA_AVAIL,
+			.version = 1,
+		},
+		/* iommufd has no limit, return the same value as VFIO. */
+		.avail = U16_MAX,
+	};
+
+	if (avail >= sizeof(cap_dma) &&
+	    copy_to_user(cur, &cap_dma, sizeof(cap_dma)))
+		return -EFAULT;
+	return sizeof(cap_dma);
+}
+
+static int iommufd_vfio_iommu_get_info(struct iommufd_ctx *ictx,
+				       void __user *arg)
+{
+	typedef int (*fill_cap_fn)(struct iommufd_ioas *ioas,
+				   struct vfio_info_cap_header __user *cur,
+				   size_t avail);
+	static const fill_cap_fn fill_fns[] = {
+		iommufd_fill_cap_iova,
+		iommufd_fill_cap_dma_avail,
+	};
+	size_t minsz = offsetofend(struct vfio_iommu_type1_info, iova_pgsizes);
+	struct vfio_info_cap_header __user *last_cap = NULL;
+	struct vfio_iommu_type1_info info;
+	struct iommufd_ioas *ioas;
+	size_t total_cap_size;
+	int rc;
+	int i;
+
+	if (copy_from_user(&info, arg, minsz))
+		return -EFAULT;
+
+	if (info.argsz < minsz)
+		return -EINVAL;
+	minsz = min_t(size_t, info.argsz, sizeof(info));
+
+	ioas = get_compat_ioas(ictx);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	down_read(&ioas->iopt.iova_rwsem);
+	info.flags = VFIO_IOMMU_INFO_PGSIZES;
+	info.iova_pgsizes = iommufd_get_pagesizes(ioas);
+	info.cap_offset = 0;
+
+	total_cap_size = sizeof(info);
+	for (i = 0; i != ARRAY_SIZE(fill_fns); i++) {
+		int cap_size;
+
+		if (info.argsz > total_cap_size)
+			cap_size = fill_fns[i](ioas, arg + total_cap_size,
+					       info.argsz - total_cap_size);
+		else
+			cap_size = fill_fns[i](ioas, NULL, 0);
+		if (cap_size < 0) {
+			rc = cap_size;
+			goto out_put;
+		}
+		if (last_cap && info.argsz >= total_cap_size &&
+		    put_user(total_cap_size, &last_cap->next)) {
+			rc = -EFAULT;
+			goto out_put;
+		}
+		last_cap = arg + total_cap_size;
+		total_cap_size += cap_size;
+	}
+
+	/*
+	 * If the user did not provide enough space then only some caps are
+	 * returned and the argsz will be updated to the correct amount to get
+	 * all caps.
+	 */
+	if (info.argsz >= total_cap_size)
+		info.cap_offset = sizeof(info);
+	info.argsz = total_cap_size;
+	info.flags |= VFIO_IOMMU_INFO_CAPS;
+	if (copy_to_user(arg, &info, minsz))
+		rc = -EFAULT;
+	rc = 0;
+
+out_put:
+	up_read(&ioas->iopt.iova_rwsem);
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
+
+/* FIXME TODO:
+PowerPC SPAPR only:
+#define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
+#define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
+#define VFIO_IOMMU_SPAPR_TCE_GET_INFO	_IO(VFIO_TYPE, VFIO_BASE + 12)
+#define VFIO_IOMMU_SPAPR_REGISTER_MEMORY	_IO(VFIO_TYPE, VFIO_BASE + 17)
+#define VFIO_IOMMU_SPAPR_UNREGISTER_MEMORY	_IO(VFIO_TYPE, VFIO_BASE + 18)
+#define VFIO_IOMMU_SPAPR_TCE_CREATE	_IO(VFIO_TYPE, VFIO_BASE + 19)
+#define VFIO_IOMMU_SPAPR_TCE_REMOVE	_IO(VFIO_TYPE, VFIO_BASE + 20)
+*/
+
+int iommufd_vfio_ioctl(struct iommufd_ctx *ictx, unsigned int cmd,
+		       unsigned long arg)
+{
+	void __user *uarg = (void __user *)arg;
+
+	switch (cmd) {
+	case VFIO_GET_API_VERSION:
+		return VFIO_API_VERSION;
+	case VFIO_SET_IOMMU:
+		return iommufd_vfio_set_iommu(ictx, arg);
+	case VFIO_CHECK_EXTENSION:
+		return iommufd_vfio_check_extension(arg);
+	case VFIO_IOMMU_GET_INFO:
+		return iommufd_vfio_iommu_get_info(ictx, uarg);
+	case VFIO_IOMMU_MAP_DMA:
+		return iommufd_vfio_map_dma(ictx, cmd, uarg);
+	case VFIO_IOMMU_UNMAP_DMA:
+		return iommufd_vfio_unmap_dma(ictx, cmd, uarg);
+	case VFIO_IOMMU_DIRTY_PAGES:
+	default:
+		return -ENOIOCTLCMD;
+	}
+	return -ENOIOCTLCMD;
+}
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index ba7b17ec3002e3..2c0f5ced417335 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -42,6 +42,7 @@ enum {
 	IOMMUFD_CMD_IOAS_MAP,
 	IOMMUFD_CMD_IOAS_COPY,
 	IOMMUFD_CMD_IOAS_UNMAP,
+	IOMMUFD_CMD_VFIO_IOAS,
 };
 
 /**
@@ -184,4 +185,39 @@ struct iommu_ioas_unmap {
 	__aligned_u64 length;
 };
 #define IOMMU_IOAS_UNMAP _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_UNMAP)
+
+/**
+ * enum iommufd_vfio_ioas_op
+ * @IOMMU_VFIO_IOAS_GET: Get the current compatibility IOAS
+ * @IOMMU_VFIO_IOAS_SET: Change the current compatibility IOAS
+ * @IOMMU_VFIO_IOAS_CLEAR: Disable VFIO compatibility
+ */
+enum iommufd_vfio_ioas_op {
+	IOMMU_VFIO_IOAS_GET = 0,
+	IOMMU_VFIO_IOAS_SET = 1,
+	IOMMU_VFIO_IOAS_CLEAR = 2,
+};
+
+/**
+ * struct iommu_vfio_ioas - ioctl(IOMMU_VFIO_IOAS)
+ * @size: sizeof(struct iommu_ioas_copy)
+ * @ioas_id: For IOMMU_VFIO_IOAS_SET the input IOAS ID to set
+ *           For IOMMU_VFIO_IOAS_GET will output the IOAS ID
+ * @op: One of enum iommufd_vfio_ioas_op
+ * @__reserved: Must be 0
+ *
+ * The VFIO compatibility support uses a single ioas because VFIO APIs do not
+ * support the ID field. Set or Get the IOAS that VFIO compatibility will use.
+ * When VFIO_GROUP_SET_CONTAINER is used on an iommufd it will get the
+ * compatibility ioas, either by taking what is already set, or auto creating
+ * one. From then on VFIO will continue to use that ioas and is not effected by
+ * this ioctl. SET or CLEAR does not destroy any auto-created IOAS.
+ */
+struct iommu_vfio_ioas {
+	__u32 size;
+	__u32 ioas_id;
+	__u16 op;
+	__u16 __reserved;
+};
+#define IOMMU_VFIO_IOAS _IO(IOMMUFD_TYPE, IOMMUFD_CMD_VFIO_IOAS)
 #endif
-- 
2.35.1

