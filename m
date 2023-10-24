Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1376B7D5B58
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 21:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344261AbjJXTSa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 15:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343993AbjJXTS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 15:18:29 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2115.outbound.protection.outlook.com [40.107.22.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A3710CE;
        Tue, 24 Oct 2023 12:18:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1KAvsAzk0+zX0SlvYcIqesquja/7Q2xoEYBZJVN+D5ns6IsGmpsZfXpqkxJv9Z7TZzCuXCYEebfGNT1A5KE6wOjGREqGiD00eNAdVfGw6GInmCJPC3pNBAoJGzDfF/mjr7K4t/aD+9t0caXU6bodxmegbDwi9zVMTUGcgLuB13d/dBoy8kkkdycBSNpIX14GXxhq31GPIT7y8c3+NktG87f52kiYcSZ/R5zMPz/bBBUt7FVsRQr/zavDfC4JtSslmjLFMenKfbyM01JRzO64eUe2VY/RuAc0wmG/LjJmmloZSSTtKg1fmTvbQZtMs2aRa9ZB1GOCZMPOwOnJS6u+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v1fd9KP9ChGZUWHVNhSkIx2nIzuGA/uCuY7cExJLI8k=;
 b=Jb+nozP7ulLZcPsJWbwYar8Va3m4JQg89GWnggJRFI16nt8Czi1N0VPZnlZHIDGs+ZD3bTp4U9is76ltMmDXuKY94K7ZlU+DfYCGRwn58ghLgzIPA3laWG5DWPLasgrU+KPQRG8BmOLSfuvs1MAlR7XeIdVo2A3tEIXLkMHh1KDiu7rwhJYcYLq0+U7mEskSDba/9akQCBhHjnKUKTxCshqrMD3HYiqz4yI/yoiIcLuOhPfALnjB634x4Dt6SUEEouYGtPT4EvJfBELysyYcuRO6KiLUo29m+W5pOuRbViSPS0pZ1s9Vy6RUO+bq3QWFsuyMiSIxGLSNjN90bR7Irg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v1fd9KP9ChGZUWHVNhSkIx2nIzuGA/uCuY7cExJLI8k=;
 b=sNb4JhpDDos6tv7XqEVtOTN0zhclaebwZoWk4O196QTSi48twCRFL0oZcFffv5kpuwNG9gzHILrI46XtVyuRujpSW8mciUoZEYQSQYmYiW15UYAy+9pPs0/LPtxtobJLd9YA3DTJYa+368DejvcbrEVjNjyig+PvFuqjvoLY8QRxxrH9cyqv1waaZClatMto/DEqNkDytRvcWO5MjJ7V1GpWvxtAUwFjLepJ1Tjx9vEXIn6SvLbvQydIsrTbUgni2Mq2F8ihpI+iYQAGNbwqdMdwklK/uJcVNOjmnenXxqERpZ7qgif++wNicmXRpHHxzU1wccTMvcuSNGkLWX0HHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by DBAPR02MB6168.eurprd02.prod.outlook.com (2603:10a6:10:18b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Tue, 24 Oct
 2023 19:18:24 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::717d:6e0d:ec4b:7668]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::717d:6e0d:ec4b:7668%6]) with mapi id 15.20.6907.030; Tue, 24 Oct 2023
 19:18:23 +0000
From:   Alexandru Matei <alexandru.matei@uipath.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandru Matei <alexandru.matei@uipath.com>,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: [PATCH v4] vsock/virtio: initialize the_virtio_vsock before using VQs
Date:   Tue, 24 Oct 2023 22:17:42 +0300
Message-Id: <20231024191742.14259-1-alexandru.matei@uipath.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0031.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::44) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|DBAPR02MB6168:EE_
X-MS-Office365-Filtering-Correlation-Id: dd6b0258-1672-41fb-3360-08dbd4c5fdd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m/KKnavKd4oKkQemzh56jHlwxKej3GONYIBHAvLh6nSwNXGa8JgNpt8279JCidemfJD89dGSNW6Jy+vfPp5zdYhqDAlWeVSmpeT/hiPtlD7IteMaiZPQtRUlIpOwalPZxlMmW2VaNp7Ch2h4DhJL9o4Gtu/cwWRfaBK63Y9uPTNO3oUQNig/TqQBocA3M4pTRIynHCeBvmUoDuwgO6EhLfxoJQaTv8V+aayAhIEIbENKRAA5aHdhslJfAMpWyYsCAKdGdhAtYVdKw4slwSzimUBGfui3vB8B8PuW/ZZqaewgmQdQ4ZvqeMmTufgjAGP5QhvTaFeULqM/cuCcMVKEaGy8ucmQzMTj+NH1Atk/DKc0M9Q2Q5sjMqks2r/AOxipVrE5y0IidQoEY1omA0qol2Q5LccA7BxUaZ8VoSTKI0HTKzJKQjR+d+eoPtskPxN2QD8wEL2eUeUwsjcYJZrW7vr9xril2dGAsbROE+Jog2Zz813zgdLbLmL9sEXlU7w98KeLv/S3o9o6836vHVht4+77r5uwf5/7iwP3k8jZLi+oowwtCpas246soqf6rjLi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(396003)(39860400002)(346002)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(6666004)(5660300002)(4326008)(7416002)(41300700001)(8676002)(26005)(8936002)(6506007)(44832011)(2906002)(2616005)(107886003)(1076003)(6512007)(38100700002)(110136005)(86362001)(36756003)(66476007)(66556008)(83380400001)(316002)(66946007)(478600001)(54906003)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gzYBpIFozhgcP0etyJZHMGTJaJZ2YD4v0RTe8EiUh92U/YvaE/bA9Se6Z01E?=
 =?us-ascii?Q?7ooIvYIz0hMtmTakr1gFaAh5ZxAlPZVd4ueAzAUE7g90LLmaRkKmvTQQUbjh?=
 =?us-ascii?Q?nQP2I0eHAe/TiVShJKHJBflOX+5kbzHsPGXOgENKu4fR/BcLU6ZlyaIawcdu?=
 =?us-ascii?Q?ZqLUNJjvLIwOZfmKrkF0bI9PdFwDFF3E+AVKILLqH3gfX3ZWNT16qvj4L1tE?=
 =?us-ascii?Q?m57Wyn7EjzAZ/P0LcI7ddx9yL6n8QPyXg1groi+WexNNi7ShoHvAg31ZReoy?=
 =?us-ascii?Q?5nzIrDXYuBDu4D4dtVHmSJS8v+IYXdF4nk9BGHBjxt0Crky5aXYo88XEyFqJ?=
 =?us-ascii?Q?oPTeaGH+j2ZPF4/UWav+6U2dQZMBoEHxO1GUJVtWA8ZsJaT+L4fMMmrxxuhX?=
 =?us-ascii?Q?7pztTFB5wfOgQZoJHj53K1lEi3rstSlFJQ7ZdsdymG1OmEmkdIKeuPuSgM8H?=
 =?us-ascii?Q?yiUmS4/3vVBI7b6tZVhY81VbHHFzAMaHhTWEHeVPmpFdV+I9tgqmhywodhyG?=
 =?us-ascii?Q?qhaQLuGA9kiTpXwPIGVxArtw+LJRlUxSNp0hs4mhgk2cc5JXjOny+UyUE11Y?=
 =?us-ascii?Q?7D26sfilk0LqfKsfBbyXf0gVAmDoIdSFoU9OTViSzRw9mbnQD14jq6dn2iRg?=
 =?us-ascii?Q?WFj8y+IptPotbZXD3OZlAWWe6dCPvzRrAnOgl869VEzsrCWfw3Tnc/xn8jus?=
 =?us-ascii?Q?TVSvs1wy5dmQptagcSn890VSnon/gy0gOM4sMSdSgh5nHe5i5ZkEIQd6DW8O?=
 =?us-ascii?Q?cLN3xx6th3DnjJmhLmmMSP+ab2JnRaFTe6i+qFeMnnVOJ6wxr2HRhPYQEh4Z?=
 =?us-ascii?Q?GmGmyRw7x80fQH+dKgSE8PARWjCjembzKXw4AaCqJyOwyXg/drOPOLN9Nxvv?=
 =?us-ascii?Q?D00H6wRrV14nHM69GxI/pRHAN21Z7IK6M7qsJpgxkTxm4P2U+eGlGlwhT2S8?=
 =?us-ascii?Q?rRLbaXcePT63Y+jPkqGG1zfQzXJJmdYBuzaV61AM5H5pOwuWOaGjNw6vmVxk?=
 =?us-ascii?Q?dUbGEgIvHB7nh+ZbjG1VWz398QMo5M7V3VX6WrFYq9LFksMOPmNWUJ8EpWXR?=
 =?us-ascii?Q?J57wQXfM5gBLnGMEGBnfSwXZmgZ6uCTf03slwUnrRDDlq0U02+A9umMLn7Sz?=
 =?us-ascii?Q?PoysORM8WztjNCiyPUKbUNkNfkKyGPZMGPDE4L6k3DEQ9aRgqezfql+P7MMB?=
 =?us-ascii?Q?0DwmLkffc2VnAiApkiJQAw22gm2m0syqyLFXl9bLDsQz7ETsVWCu1uRP8eMA?=
 =?us-ascii?Q?qqbhBE8BPyM3yxxwEVL1YG0YVaCJtleytwLpPJXrnLjKJrkNm9Ie9Hvo2nQz?=
 =?us-ascii?Q?XdjRhfRABaq4GKaDXVUYBCnQXMvGza2QD3cRMMUhGkpgCsGDId4peWCpN9fa?=
 =?us-ascii?Q?XbUedKUTaleLq2wfx/Cs4R3U1l/xUkT1Qo453NLQ7pQ+7zYTFAnR0chfGQRK?=
 =?us-ascii?Q?4tGyLW/GLrMDYHr4mQ73sq2EY+QZ83PilRVKgFJiK60rELKN/OaQpO19LRRk?=
 =?us-ascii?Q?hffYJGg0xknGwFVAxVPR54rZqnjYp5WzeAGOKLlzpM9hCONBqJBl/4cRwWpy?=
 =?us-ascii?Q?h+o+solLBF5jjAFUjWkYF2vuXX1pbXIsDOPqgV8XLJTk0ojEj6Q/5RBNcBgt?=
 =?us-ascii?Q?+A=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd6b0258-1672-41fb-3360-08dbd4c5fdd4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2023 19:18:23.7100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wZCsUD2Zqyc9qniiCfko3zPZ2YAn9qFU1T28JEuhAmPyksGt30j4Bt3yH9muWc3nz9bylUq0E4pJTcyGuAaooFd2psBvhTxQ6MTDFuK+PlU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR02MB6168
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Once VQs are filled with empty buffers and we kick the host, it can send
connection requests. If the_virtio_vsock is not initialized before,
replies are silently dropped and do not reach the host.

virtio_transport_send_pkt() can queue packets once the_virtio_vsock is
set, but they won't be processed until vsock->tx_run is set to true. We
queue vsock->send_pkt_work when initialization finishes to send those
packets queued earlier.

Fixes: 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock")
Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
---
v4:
- moved queue_work for send_pkt_work in vqs_start and added comment explaining why
v3:
- renamed vqs_fill to vqs_start and moved tx_run initialization to it
- queued send_pkt_work at the end of initialization to send packets queued earlier
v2: 
- split virtio_vsock_vqs_init in vqs_init and vqs_fill and moved 
  the_virtio_vsock initialization after vqs_init

 net/vmw_vsock/virtio_transport.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index e95df847176b..b80bf681327b 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -555,6 +555,11 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
 
 	virtio_device_ready(vdev);
 
+	return 0;
+}
+
+static void virtio_vsock_vqs_start(struct virtio_vsock *vsock)
+{
 	mutex_lock(&vsock->tx_lock);
 	vsock->tx_run = true;
 	mutex_unlock(&vsock->tx_lock);
@@ -569,7 +574,16 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
 	vsock->event_run = true;
 	mutex_unlock(&vsock->event_lock);
 
-	return 0;
+	/* virtio_transport_send_pkt() can queue packets once
+	 * the_virtio_vsock is set, but they won't be processed until
+	 * vsock->tx_run is set to true. We queue vsock->send_pkt_work
+	 * when initialization finishes to send those packets queued
+	 * earlier.
+	 * We don't need to queue the other workers (rx, event) because
+	 * as long as we don't fill the queues with empty buffers, the
+	 * host can't send us any notification.
+	 */
+	queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
 }
 
 static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
@@ -664,6 +678,7 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 		goto out;
 
 	rcu_assign_pointer(the_virtio_vsock, vsock);
+	virtio_vsock_vqs_start(vsock);
 
 	mutex_unlock(&the_virtio_vsock_mutex);
 
@@ -736,6 +751,7 @@ static int virtio_vsock_restore(struct virtio_device *vdev)
 		goto out;
 
 	rcu_assign_pointer(the_virtio_vsock, vsock);
+	virtio_vsock_vqs_start(vsock);
 
 out:
 	mutex_unlock(&the_virtio_vsock_mutex);
-- 
2.25.1

