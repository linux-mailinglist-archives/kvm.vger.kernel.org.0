Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB3162CC3D
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 22:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234446AbiKPVH1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 16:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234191AbiKPVGq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 16:06:46 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9173A682B5
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 13:05:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aTWXGznwlldagSKIO68SCvwnTe/WUTqWs+cZlcs/0KluyiTYHdrczpYmKWgdqeDR8aGsaIklLjyF4/9vs3uXng5r82Xr+rlrLtKIkqUP7rp5xzu9ADOftjEaVK6bma5b7t5jq6cmplKuW5Isz4AhXsVkOBo+bExgwFO32cSNr/1dvbHMJa0J7dgAGDhwdn4cYugMqFiEhc//4+5YPrSkpxii0JJAR1RNjhQjRGBrGvS2pRtt7oquhG7bLKMnuBe7SF/LV3JtgudWHnMHgFchfo9owMkjlN5aE/BvROoZumhPUX9qW/u+aToxXTt/2xxOHdCKJhWbF212DZ6VgwpjGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GR5RFMOWlqY4XxZSJOi677+vckDJcBybW4lYCEKuwHc=;
 b=DSFeFmZEMJaq5amZH9gI2JMU0hXvit06EPVssmGTB4xcBN2OScj+jRqRa8pZS+isMUef50A0Jv2ct1LqpSzYwuyl7FG8wVwG1Or2Mg/a67HqeRdsiYcnTX9hJO//Yj7EShTqZELHxtEpm7QQYfLWYDkprxjtijCQICinyzX6YTGP74mpJxFzJevhaL145kU43fOwLQDnsJ2zz+ia9eYSG4GqbdxKXIY+yw2BtmOJSrFbOEc0tXub7XTvCdb3OGljzo6cIH/pQ/E/q4zD1HTNP+JTOpU3a6wZwyz6UXmn9TkJlzvxct5laoizTfJIr2Cg7tIIJFkSmlIOYqn8aqFunQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GR5RFMOWlqY4XxZSJOi677+vckDJcBybW4lYCEKuwHc=;
 b=ORZChbLkc9RClHrA9ayHXhb6783MR8JXPnvCkil+bhFGonLD1cwbcmfXRcu0uLCEmGBCbuOmV0EgmiVQKGSakSFA7XHYiV6a7vbDApQCZLUMmkL58anNKXt8X1fabsIWXKEmveFPnPe8cP4v+y2dcEPdfzqOUur+jxoZ3GaAnvjBQpEgXM+PgoUdZE1whDrzJA+M0vA4Bx2VHI3y8XJtukOg1eTr+oAYnd+VJXGQlgPwbK3JQkqh/JAPm1NXyzN/2HTNyeVTk4YCE4v/BufONyCv6WpJ/FG9c5AwbK13OPtXr2RQi/Yp/sv5lz4Ov6sm32n+CnpyAOI2QqrGxbDgYg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB5609.namprd12.prod.outlook.com (2603:10b6:a03:42c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Wed, 16 Nov
 2022 21:05:40 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 21:05:40 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: [PATCH v3 03/11] vfio: Rename vfio_device_assign/unassign_container()
Date:   Wed, 16 Nov 2022 17:05:28 -0400
Message-Id: <3-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0031.namprd20.prod.outlook.com
 (2603:10b6:208:e8::44) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: 7790168c-93a0-41b6-35fe-08dac8164fd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YPw6V3Dk39Sw5gDcg0HnnMDr8KZ9rIL8AbyV8QAP9uTfYzFLbbtk0niNxhPdjVG3Z/Z77Ks0wgwigTmdP3HmgSWfU6D3GwXzdyxVAMOZAhSOzTLzyv5WthtsLfuD6YzvCAT//RqJLrWqmdsqfi/+NlcZWKPth5ju8Hc1VT/g2fhWFaxex+j+g95+EhniVjkgytHs3Zsv2Tk8S7ttCLt+bmHgK7YPBT4vG46flt8HmBgr9dR7eJkIOcsXGapW6VuEU4SRDS8powpytZlLxPXApX6D+1fmdMB3lCl7QVsZxHySDMeT5N4rJGyiS81kJDzLPtOh5zDteJtnvKXK+P46fc7Cnf65gA4PGKhFRB8nIaRfJeJqDxLkFYbdGeLWA6Ty9y/pVWNUSIovXyJM4JoxQIuYp+gmCzXMuxZTxOell+k2t6XyjeW5aLchIe9vc+Zh1yNPKXFimVWY5AHV6qUDnUGN6t4ymlPhyepbNLrV5rhyEc9fmDiGxWErppYXoM4wgsXDJO9Z6u5CiY1r/xiKg28BvPSHwdxckDFeVNuk40U5TYNzUz28SqGKPh1AJH29bqY69iP+Ohpc8PC8XpQTUJEI4v/aguIlSvqTpVJhlI5Fi2j22D4WYm5ue5Zs64N0+J3gqubD1hh6+y05UBCTatveAKEl2rRDskl9B052LkSlD3MmnQGkUj+GwhZg5Ho50g/VDz67n8lu14BTg0k0wVv7sSMUaVKnzfHyiNcBUE/+CJgAHRn1HXBaWJZGW572L6bxTKSCQW1gfSdUqLXEOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(376002)(39860400002)(136003)(451199015)(109986013)(86362001)(36756003)(38100700002)(54906003)(316002)(6506007)(6486002)(478600001)(2906002)(5660300002)(7416002)(186003)(2616005)(6666004)(8936002)(66556008)(4326008)(66476007)(66946007)(83380400001)(6512007)(41300700001)(26005)(8676002)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XeCLWcfbJ0DcjNU2g4YmNlMLh7FQlS9KSWekSAPYqVNET3fCDaYF1hzHXn2l?=
 =?us-ascii?Q?9rHIQHmRHUA8Zx7Tm0GtENViVCOAoHJk9i6Dj+Lk/TZ0N9tddQKLQycYz21j?=
 =?us-ascii?Q?+yOIFCSlMzZgDeXiW/XwpfRHksWsaSzk4+wHchxDHobK1ZQokphdg/l4D//A?=
 =?us-ascii?Q?tlsEMDjfNRpjeMFFbzLjTQJV0a9yukYraugTe3zYODUbVPeXL6BwD6cuMttU?=
 =?us-ascii?Q?g/fXYWC+7fNae1PMmY/bRnfRUhcNbdHKMYF7CA3nZkPIVzvkZuOzWNwPd46/?=
 =?us-ascii?Q?YN/8Y8Q7ZvZZyPqT3mo+mHmD82nOkCkhgubtHdyGYRffC7heYMU3NjbSCW5O?=
 =?us-ascii?Q?yfw226z0ySWOqWlf+B310ImN8oJzUfgyjZ/roXgc24Omu8QOyxHmUIlqD8Nv?=
 =?us-ascii?Q?+Xhh63P4JoGu9W9ZJ0/lUKR4Ogr/+x1c/a9rn9omsN2nVkt0kopWNbby2JU2?=
 =?us-ascii?Q?zE3YL2ROp4MnYsE9HeiMXMCny+A92G85ky8Rs3d+o6+6FGVj5ZxZTDREZVw6?=
 =?us-ascii?Q?cOvklEhej7w0Jnj+AiXRguWOknisbP0jRY9BrjTluzQQOajueVrsqvzEpssf?=
 =?us-ascii?Q?c3AdH640SrM3aQBrn61Pt7tHCoeZyXk4c7UfdipwnXkSIPoxgeu3hJXZQJb8?=
 =?us-ascii?Q?GMoB0LzFNnHaygr+GAYTOHeBZTX/LgdA7JTmGLTSMO6kkt0WFNs/SrWOnp4X?=
 =?us-ascii?Q?CAoNitel7/Zs/EUjlvgGCumz0w9lxBx3muaqpBkoetHZ4D0l6OcCw3vyz2Ws?=
 =?us-ascii?Q?9v1U/uRY2WibjI8FDLmUu7jlutkwtfYanOhmsQ7DQet7a88qhI59RDdHeOhR?=
 =?us-ascii?Q?SossSj0HK4ZZyJXyfcgzcJfEHhcqr94GFw8XYSpVRJnjNRo2m2Eoic+4CQaR?=
 =?us-ascii?Q?IThkCGHSa2UwQ24fIADX7lfovg12hYdc2CC12fQ/Q0MbLd9bGd36IxGUYI39?=
 =?us-ascii?Q?wsyz2hWY5q0X6ZrhMZ4Ay3yUvOAAoT+OErwyj+eZAnp3YOHD88gaQpv/woHc?=
 =?us-ascii?Q?ui3tHlt/bcSeyfusUxXhZUNOcfXIrBVsdjKU/ldv1nJwgLdE92OxVj4U5tjt?=
 =?us-ascii?Q?66+mOihnXBGI1JCOyWpE9jbgG7+jaK3qaUIiHTIMElV2nAANk0e5uHe4JFXQ?=
 =?us-ascii?Q?WoDrtEfz93NMgmaupbOoDPkmRoy+2Shsm+pIRBjvtOKdrBJde+1WoEXByFpj?=
 =?us-ascii?Q?+oLOjtjRADJlWtdxkW6glVODbwlkJ7X5iZJ/2zTu+CVnNEsBc/AuGjS3jC4H?=
 =?us-ascii?Q?u4sQ2jo+Jc7TP8NAAt2Z+dqY5ri5280vg0MttTFSvwbMuVhEEMEYROjQc1wx?=
 =?us-ascii?Q?+RBIWj9QHPJ8Xyo292w5W7343BVfz7SvaBp4+n8L1SkY18S+ZDIYNDESV7U+?=
 =?us-ascii?Q?HPU5G0sIB/snVI0pcqV49MOnt9HlhZ3iaoKMCBffF4FCIYz5Q4g0gCm+VwH/?=
 =?us-ascii?Q?3APJ8+QiQXrYIrvflQHAjVd7xUvXh/px2FtrwsyY9HBuLcsfjMTrwxPjDPjD?=
 =?us-ascii?Q?X5Ig94+QdBX5sRpdA/jVTfOFG8G+CbD4CHIfV+rTpBw/abeI2hxCjRAmc6UV?=
 =?us-ascii?Q?f0KCwADDHaYqDMwj71Y=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7790168c-93a0-41b6-35fe-08dac8164fd5
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 21:05:38.1805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l2N7jZJC61FmmQ67Gf4bslxn5xdiDM736SAJUqq6SR676KgJD/J+TXxu+l+NfbGt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5609
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These functions don't really assign anything anymore, they just increment
some refcounts and do a sanity check. Call them
vfio_group_[un]use_container()

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yu He <yu.he@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/container.c | 14 ++++++--------
 drivers/vfio/vfio.h      |  4 ++--
 drivers/vfio/vfio_main.c |  6 +++---
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
index dd79a66ec62cad..499777930b08fa 100644
--- a/drivers/vfio/container.c
+++ b/drivers/vfio/container.c
@@ -511,10 +511,8 @@ void vfio_group_detach_container(struct vfio_group *group)
 	vfio_container_put(container);
 }
 
-int vfio_device_assign_container(struct vfio_device *device)
+int vfio_group_use_container(struct vfio_group *group)
 {
-	struct vfio_group *group = device->group;
-
 	lockdep_assert_held(&group->group_lock);
 
 	if (!group->container || !group->container->iommu_driver ||
@@ -529,13 +527,13 @@ int vfio_device_assign_container(struct vfio_device *device)
 	return 0;
 }
 
-void vfio_device_unassign_container(struct vfio_device *device)
+void vfio_group_unuse_container(struct vfio_group *group)
 {
-	lockdep_assert_held_write(&device->group->group_lock);
+	lockdep_assert_held(&group->group_lock);
 
-	WARN_ON(device->group->container_users <= 1);
-	device->group->container_users--;
-	fput(device->group->opened_file);
+	WARN_ON(group->container_users <= 1);
+	group->container_users--;
+	fput(group->opened_file);
 }
 
 /*
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index bcad54bbab08c4..f95f4925b83bbd 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -112,8 +112,8 @@ void vfio_unregister_iommu_driver(const struct vfio_iommu_driver_ops *ops);
 bool vfio_assert_device_open(struct vfio_device *device);
 
 struct vfio_container *vfio_container_from_file(struct file *filep);
-int vfio_device_assign_container(struct vfio_device *device);
-void vfio_device_unassign_container(struct vfio_device *device);
+int vfio_group_use_container(struct vfio_group *group);
+void vfio_group_unuse_container(struct vfio_group *group);
 int vfio_container_attach_group(struct vfio_container *container,
 				struct vfio_group *group);
 void vfio_group_detach_container(struct vfio_group *group);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 717c7f404feeea..8c2dcb481ae10b 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -749,7 +749,7 @@ static int vfio_device_first_open(struct vfio_device *device)
 	 * during close_device.
 	 */
 	mutex_lock(&device->group->group_lock);
-	ret = vfio_device_assign_container(device);
+	ret = vfio_group_use_container(device->group);
 	if (ret)
 		goto err_module_put;
 
@@ -765,7 +765,7 @@ static int vfio_device_first_open(struct vfio_device *device)
 
 err_container:
 	device->kvm = NULL;
-	vfio_device_unassign_container(device);
+	vfio_group_unuse_container(device->group);
 err_module_put:
 	mutex_unlock(&device->group->group_lock);
 	module_put(device->dev->driver->owner);
@@ -781,7 +781,7 @@ static void vfio_device_last_close(struct vfio_device *device)
 	if (device->ops->close_device)
 		device->ops->close_device(device);
 	device->kvm = NULL;
-	vfio_device_unassign_container(device);
+	vfio_group_unuse_container(device->group);
 	mutex_unlock(&device->group->group_lock);
 	module_put(device->dev->driver->owner);
 }
-- 
2.38.1

