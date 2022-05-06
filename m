Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7992151CDCE
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 02:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387514AbiEFA2x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 20:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbiEFA2u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 20:28:50 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2047.outbound.protection.outlook.com [40.107.220.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FEF45DA71
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 17:25:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gj/lPjtWXVK5t8U5GWPrfUj1J0OOCQnHE4CFBw0bhPkVFNUKLSg+eTzYsi5otIg0lMeWpayFGZDA/GgcVBCK6o1c6KpZTNFCEd1UCxWc/fZ3IfRO6gcmNXk16Fj3kNaXyKo7QGaOIioa+s9K7v1bdodojVhirB9VluhYGjAqdK5ShW37cVEY62wLqY2C8vSppoRTDB+zEA1xCdy1kzhtEMIXTJVfu3IZh5OL7YXVP5h1ksK1sJgaotixoqXltT+ewV4zBgFSLJNrw54xyc60J/jMpkeIDBu2+G055WHISjCCWd6847z/MoLmEstxWZzxYVvUJjSLpUNEKfgVJM3m3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tm50MDjWo4uM9Y0CEhaASoFeIjr4KwUAPWP6CLm9hUI=;
 b=RjNaEuV+7JS3QXuDfBIuqdf0gvLfjbapxJ4si6EK1mDHWokUjnZ9JE2QLek5gKJDOG9YmXTlc8AqvO3pEHFemnmKo321ioRVBqXxfROy1bzK4/tWfdxtXPCte8WHeDu5rJ5/W5Bg/MjG/fAMYzAjmA12/OvhbCYKTqQZ2yibmz3RziJ16ZU50QAQqrnx9KjBTFCJ2q3XoMIb7kcxmLvApeseyoJGfmEKeFTzpD0BgxD4fO079zYT3uL74HHHu12psni42sb+SNx9RSBDSxO+qT4mDuQNIGPYShNL4wu5p/I2xMErL21oDRdWdMQAju48Xj1SjweDVCT4DYb0tB13UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tm50MDjWo4uM9Y0CEhaASoFeIjr4KwUAPWP6CLm9hUI=;
 b=XMCU3L4HX55ER9EwWOEFTNFXdSil/MI8aRTkgzz51fIpA1G8jr6DGHmBwZi/HYogPJxjaaOnmOtbuuFfdmlBnyjF9ypJMKtVmh21vhfPPbMTksQEHvpLrMgGMbR+mkJPnL8o4Sjggw+EUf+DqaHVl2RNrfSIz9MMziHxwM/ofsWts5zJly4tkX1Z8SPjIAM/9+tHnPkDWaT6e1uCOOvMUZDRnXl3jOZQ7eeYRJzfW0xhJJ0YKt+8hdIrYfyrmSVTR9zAjUWsUCTNv3cuPsrSYgV0NuR7+gSB/sqiQ7Xe5Y1x9ZRbAB0vdFbvLx5sAD6emkn9dbw32o5jjNJhukU0hA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH0PR12MB5025.namprd12.prod.outlook.com (2603:10b6:610:d5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Fri, 6 May
 2022 00:25:07 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.027; Fri, 6 May 2022
 00:25:07 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 1/6] vfio: Add missing locking for struct vfio_group::kvm
Date:   Thu,  5 May 2022 21:25:01 -0300
Message-Id: <1-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
In-Reply-To: <0-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0053.namprd19.prod.outlook.com
 (2603:10b6:208:19b::30) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82ac7046-20ea-49eb-50b5-08da2ef6dfb3
X-MS-TrafficTypeDiagnostic: CH0PR12MB5025:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5025789C9B99DA5B4FF52E19C2C59@CH0PR12MB5025.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r4rIPoCdMk3j8kREwlUfYHakRWB4Aet8UV+8kWhgmdPxZ3ms2kp3H5RyS8CMM7ruINTMToTQpHTX+Cde+AfeIYGcts/h9EYWFzxcgcPu7SXPJd7mvvKew8DhdQcyBVRnpvIU5S+BcPRHvWCiub/nRZ+f7kw5j4dGd7G2DgBeakmezaZqTe/bh91NlBgPiptvaybiSnVra79nHSWV30RbVFwcZLtWK+pzwJbs952BDt1wYy1HJaMNCM6iL7Y29FKG8HnMCKnAkHqGvovLGbGl7rZG0/ikRgTEdm7wz5wikE/ST2Kff9cpMRSnxOlr/s3ZTSbps46sXYGAZFcl0JjTLv3ntNpfGaQ8kmGQW1UIlbLmmT73CUXroPg0+7ac1cn82wLEyiYpVcS4jYSXshchVgKoxQh2htKWWqLgfXV6GeG/uRAzW41l49jbfzQ8041XaZSZEj0c2fhBf8pamzW0jTQFUJRAP5dIPNIq5mH3toGLlfkF1TTJoxA9lc6AbkpnarQRJOQ4txMzfsBoJy5CfE8eLLo9C3sCmBj7ZvfPcZzp/eCriFrdUOJEFXQ7rTPPkdm7IWZXW9B9aVoVX6zTO8pi/Pvne3GWuQYtwjfz30taSdMbAewZe2fs5R5e+dxuaNjPGHXpQQ4HqSwF+utSPFeXv3WDik2qbzG8hzje3YreBmA4T43HZeoXT7+z3rBr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(54906003)(110136005)(38100700002)(316002)(2616005)(6506007)(66476007)(66556008)(8676002)(4326008)(66946007)(8936002)(2906002)(83380400001)(6666004)(508600001)(36756003)(86362001)(26005)(6512007)(6486002)(5660300002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kr8QEhKVcWUZ+E+T8MqS94CZMEkgqvM6zkLssT7BpXzM6S1Pxp4AujyvGd7D?=
 =?us-ascii?Q?fyCrMVKRI/DaStFGzU9t6VhqFf46w09fJmw36vz6kEt+wrizgrk0t+EwCF88?=
 =?us-ascii?Q?XVQDYmqoI/Nj8RV+Jz944XMtevsAdi2eOSfsrdKqtEV4tt4ZeXrsoeOeih4t?=
 =?us-ascii?Q?DwYT+0JDQpiFHvN5n6y5G70MGGS72fsr/51zw5Ghq4cWIQec9V+7J69SU7hR?=
 =?us-ascii?Q?8L2BvgNIKt5tDLjKgGbOwxYJOrKgtsbrFpeHoQeECI+FHlyO4Xq0rgprPUFG?=
 =?us-ascii?Q?MZ2HP9bqramHvnHtkCZ7mGJnqmuxzR8wuz4GRtJIq4MAy/wwPJca0P8Cnw/l?=
 =?us-ascii?Q?/tMPI7sv8o+UjRgj/Rhfb9XWvfI4FSKWwzaAV+FlUyNXx8Ywv47GOJq+xNAc?=
 =?us-ascii?Q?egv6lTl59h4HtJZpFZS47qmJKWdaQ/wtzEwPGH8VgnyNiD1SznEkOzb1n7Z6?=
 =?us-ascii?Q?f1iPp5z0z0Zz1vFesnkOoOcasd17IsQQ/s9WKmyOpSPZc87MRsubti1nh8E+?=
 =?us-ascii?Q?n/rUExswjRsvGcj8cC8gqWZtd1uPDq/wvXD4B6JJSq+RcweS9rTnIsrvLah7?=
 =?us-ascii?Q?8+5DCw0t1yYsDfk98ZNZJJ5bu4ybLUMQDQcHlfqLMwx00z9IKuSg3vWaqEYw?=
 =?us-ascii?Q?NcNXs5mFfcZgYH77zhXYvAHakD/nDBJLZbQo4uT4qnx6AAHtE4y7uxNBzNTf?=
 =?us-ascii?Q?g+m7+TctUYA9sCmHb1Dxla4cwyGLXBuSzdcIPI03+CfY2nWTQDd+0TIa5Ofz?=
 =?us-ascii?Q?sTiCw7SLdzXry4ftSJFQ761dydClLoKyflRs5kBlkvW5VYIDXURKtlDfl8mE?=
 =?us-ascii?Q?zy40VjT2dnRdi3zW39yVtIi3McAmyYte1Yj4kPc9o9KJEzd4dechsqVsL/Nd?=
 =?us-ascii?Q?UKA0NYH+KjRXAGJwNPDlrQw8SMq+ApxeglD7YYMNyuYEBXZ2LI6ZsLomVTwi?=
 =?us-ascii?Q?OrbWV0I45K8tDRdVr4VIKNcEBDx6CAvi9Np9a+5mUooSuraEbvSHpOooo0ap?=
 =?us-ascii?Q?YexM3ykjrv4mRkey+SH2g9UpJhl+V4rmN4Lc1XmQHjseyU9nDcXSWQYUzSrA?=
 =?us-ascii?Q?KrNOK1dM2lf+xqTfHZY24AvEqrPwqVqP5e+30UMLFaGDgiN16739RB9Vk1Mi?=
 =?us-ascii?Q?RJAA6w0MndO+Oj+vDUX0yKBHHAiK2oLbHu/veFLKXivXH1mmESto9pESj0Q/?=
 =?us-ascii?Q?sek4NDD8+teSvawD3TuMRXC2LqcApKGtmz8jteyrn3v2arJsTDiNzcrWhV92?=
 =?us-ascii?Q?pBQt4eJEdC49YIOBmfVgJyY+yokCVN/A3Ps+qjPZcsF0PwSK7C6U4tjDbmI0?=
 =?us-ascii?Q?IfO5KRMLbWO8cu5QuLf67grb4miIT3XlR5ccXhqu6RUIImoOkrKWudROSGZ7?=
 =?us-ascii?Q?ePwBi6SyXZzJLh13waE7P0veObF89xsGrT5q6mds0AWB526ND1v/F5dv0YRn?=
 =?us-ascii?Q?YRKx1ieLSt0rMwFWfpvXZr4Z8l+JTxT1Ws6IKFcsW1SW3GV/+8x11hvyq5Go?=
 =?us-ascii?Q?WLSpRXSEfJh5CRzMLQr/TOQ+I5GYlwYEgQNW3HU7Ge5OHLVT2SmL675whX1A?=
 =?us-ascii?Q?ILONacZJYccV2HcRjYspe52I1uDDvH/RH9sQwX/DVsW8hjCxn+grP2nHYgFQ?=
 =?us-ascii?Q?u4Q6CSV5JDZknwQ9K0vOYlXF0LV+dq+4kKepj4k5dmaZ663FjIhsBjBHJ2kz?=
 =?us-ascii?Q?XcUPlE02BCutn3FnprsU1yB/fxO3TJGSlMdZ9q5azxonAAxHmk4QEZ9MMnS0?=
 =?us-ascii?Q?o2+QJGpl+w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82ac7046-20ea-49eb-50b5-08da2ef6dfb3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 00:25:07.8123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fKiKihys4ZLasMwFBV+UN1P+oNXNCB1ukRKd9tWen6gqiei6pWCfukQZwFi4wOcx
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

Without locking userspace can trigger a UAF by racing
KVM_DEV_VFIO_GROUP_DEL with VFIO_GROUP_GET_DEVICE_FD:

              CPU1                               CPU2
					    ioctl(KVM_DEV_VFIO_GROUP_DEL)
 ioctl(VFIO_GROUP_GET_DEVICE_FD)
    vfio_group_get_device_fd
     open_device()
      intel_vgpu_open_device()
        vfio_register_notifier()
	 vfio_register_group_notifier()
	   blocking_notifier_call_chain(&group->notifier,
               VFIO_GROUP_NOTIFY_SET_KVM, group->kvm);

					      set_kvm()
						group->kvm = NULL
					    close()
					     kfree(kvm)

             intel_vgpu_group_notifier()
                vdev->kvm = data
    [..]
        kvmgt_guest_init()
         kvm_get_kvm(info->kvm);
	    // UAF!

Add a simple rwsem in the group to protect the kvm while the notifier is
using it.

Note this doesn't fix the race internal to i915 where userspace can
trigger two VFIO_GROUP_NOTIFY_SET_KVM's before we reach kvmgt_guest_init()
and trigger this same UAF.

Fixes: ccd46dbae77d ("vfio: support notifier chain in vfio_group")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index e6ea3981bc7c4a..0477df3a50a3d6 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -77,6 +77,7 @@ struct vfio_group {
 	wait_queue_head_t		container_q;
 	enum vfio_group_type		type;
 	unsigned int			dev_counter;
+	struct rw_semaphore		group_rwsem;
 	struct kvm			*kvm;
 	struct blocking_notifier_head	notifier;
 };
@@ -361,6 +362,7 @@ static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
 	group->cdev.owner = THIS_MODULE;
 
 	refcount_set(&group->users, 1);
+	init_rwsem(&group->group_rwsem);
 	INIT_LIST_HEAD(&group->device_list);
 	mutex_init(&group->device_lock);
 	init_waitqueue_head(&group->container_q);
@@ -1714,9 +1716,11 @@ void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
 	if (file->f_op != &vfio_group_fops)
 		return;
 
+	down_write(&group->group_rwsem);
 	group->kvm = kvm;
 	blocking_notifier_call_chain(&group->notifier,
 				     VFIO_GROUP_NOTIFY_SET_KVM, kvm);
+	up_write(&group->group_rwsem);
 }
 EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
 
@@ -2024,15 +2028,22 @@ static int vfio_register_group_notifier(struct vfio_group *group,
 		return -EINVAL;
 
 	ret = blocking_notifier_chain_register(&group->notifier, nb);
+	if (ret)
+		return ret;
 
 	/*
 	 * The attaching of kvm and vfio_group might already happen, so
 	 * here we replay once upon registration.
 	 */
-	if (!ret && set_kvm && group->kvm)
-		blocking_notifier_call_chain(&group->notifier,
-					VFIO_GROUP_NOTIFY_SET_KVM, group->kvm);
-	return ret;
+	if (set_kvm) {
+		down_read(&group->group_rwsem);
+		if (group->kvm)
+			blocking_notifier_call_chain(&group->notifier,
+						     VFIO_GROUP_NOTIFY_SET_KVM,
+						     group->kvm);
+		up_read(&group->group_rwsem);
+	}
+	return 0;
 }
 
 int vfio_register_notifier(struct vfio_device *device,
-- 
2.36.0

