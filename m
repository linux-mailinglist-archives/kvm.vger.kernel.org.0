Return-Path: <kvm+bounces-4860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3096B818F6B
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 19:13:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E0021F2B8D7
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 18:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57C6D41C96;
	Tue, 19 Dec 2023 18:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gTFJds4H"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA74641854;
	Tue, 19 Dec 2023 18:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q1q1rJlCjCk5Hk3BSbMq4xXPc0pT7EiwiJM0IKPj3FfWjeozSzjmZ7KDYwf3eS16bHp1S7ArTcW5PBljNZUCCssAiRgolkpwWyLXB0B/c+UdZom/eg3veD7g4+/O1iwo2tZsPqIsnqijE8HjkJ+I9aCrN8VOKUZM013CPnXi3Szd/bHzagYEFkLY9nK4JlE5fOX2Fs5O5M9AqbyhXadW+SGYv8DJ7seiFwlTS8rkcnDNYifCG2SwNr3mVjQjdd1RNpP0NGku85QJ3Bst8hYPdBKr7WScU3XrrOgWYIsjEXqR8zM5fkgU8HhJtKefvHv1H7dnbI22K64SAhv1rXLSmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KZRtPKqdWEMRTC6mFKrmvUf27QCWsQ5pVGAeS4l4Y3o=;
 b=ivmn0niEPfWelRK+upkNqSMNkIZ1AoP11wZ3NiuLrrMa5kp9Pop4cfsHr/susj4GfWUd6vYNgU312oAiCdXNpRuCD6tXJxx94RXHq76S9yvybAH9/IoscVRachPeBNhrTeyZRT+gMyQrIgXDKN2+Unh/lnYtlE84iUy3g+AQj2yM6vV1wI6NtxoTPRMrET6u9cOWuj54ri33/+NJE3hs9ZO1O3auTxVaLPEV+5XqQhXyw/4JUQ9tEopG/1nc+HoVLYqcNsWoH7LsCZt80HGUffUGqmWsze3/eXpR/rUp1/KtQdp18jU/NsLZuViLhRk7foenP3lMoAaMxRk1RNsluw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KZRtPKqdWEMRTC6mFKrmvUf27QCWsQ5pVGAeS4l4Y3o=;
 b=gTFJds4Hx+V3vNt8c8c9ZVOlzo2CupnBdmFKdo+LWmh/ZrQtq1lvF+EA7QLKpyVB2/mLFklSyxo56seFxx0UhEE6JnSQW3215uyi5XS7fiABLMpNLQHL+jKLu1b20aJn9KJYbOZGVZq2RJ3r3+x4O20EyT6hs/XQ5Ca0YGfWUSXlgush0HVnN4+XQuULJDWC01SAs8sGUDu7OsHdTYIC3eZpp+GxQArg0XGwF2on3fGxVQ/Nub5eh+ozI7r9V8sonZeX0+krF3BKL84PsocydW5C64IcO5js+9pY+Xz0ApyoFgABhdH2/V85optxIPIvm37ZUyeH1KZjT9RPPiChBw==
Received: from MN2PR03CA0028.namprd03.prod.outlook.com (2603:10b6:208:23a::33)
 by PH7PR12MB9152.namprd12.prod.outlook.com (2603:10b6:510:2ec::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.37; Tue, 19 Dec
 2023 18:09:54 +0000
Received: from BL6PEPF0001AB73.namprd02.prod.outlook.com
 (2603:10b6:208:23a:cafe::38) by MN2PR03CA0028.outlook.office365.com
 (2603:10b6:208:23a::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38 via Frontend
 Transport; Tue, 19 Dec 2023 18:09:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB73.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 18:09:53 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:36 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:36 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 19 Dec 2023 10:09:32 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v4 08/15] vdpa: Block vq state change in DRIVER_OK unless device supports it
Date: Tue, 19 Dec 2023 20:08:51 +0200
Message-ID: <20231219180858.120898-9-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231219180858.120898-1-dtatulea@nvidia.com>
References: <20231219180858.120898-1-dtatulea@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB73:EE_|PH7PR12MB9152:EE_
X-MS-Office365-Filtering-Correlation-Id: 6aca3a01-01a8-4607-8bdb-08dc00bdb39c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	g3pOcKTKa9ycqZnWDiUkVCsFcANALcJeAcFJR/i7hpN8oWGS8qK3boMHr5O/vQFXfdOhr+QutMraSWqJH05sJMFbi+dQXStOon/e7hRifi6y2vYZCfzCaunjtPQ/t34N7T633mjDJkWlojsj5TSWrOUxqWp79GBbjJtm2wlN7Bn1FzgvYzFYKGpXkeLlGxfm2bWu33U9RU4dosnlqlsHfufrtYLWEL29g0ZuUjnnPFTAAzBD4DUd1ZwNrMNcZQGOorQ038YeYRZ/leGGq+fUZL6LkYsbl+Z77OYFYqI26Doww5orANXBZuzRdEJa+UJOGGIsd61MPSdHiHmK5BX4+hN0kg7sgOeISMU9Z4s554vZOyv2EWSr5f4V032l7efyEScdbhVS0qdxmkVLfnBxUjCQZqXosVeQQPdc5mpgrdBZ3l2CAKGsJ7gYFBVBd2vA2VKp6LE2ivK4LcxykGFp14i7pZLnf+uBWpyt06//5kJMzZnXg5V3FNUlpAqZ8Cu0Jv5rX7Kocxvr1y6VdCWQQRy7dy/jnpQatkVb4uSDcDu4z/ydjTKMNTZ01+tlHRhp0NOJXmnFOTdEuguz+3kJ/DA3ZCb5lgn7ggqI10P1YDkGhMe7PlnMZJv9YYNTWJF+owxwQ4bcA25RyaAOl6xubQel4zgUoTD9D+4V556uDQFb8yQO/yTkM9p7xLQcet2y3WUgrYadiOi58IM2TAmITSpvoF4B1pso61SNJcywkBHAYfKnlSMKgO+FrHdLHyqt
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(136003)(376002)(396003)(230922051799003)(186009)(1800799012)(451199024)(64100799003)(82310400011)(46966006)(40470700004)(36840700001)(40480700001)(478600001)(1076003)(2616005)(6636002)(6666004)(83380400001)(426003)(316002)(66574015)(336012)(110136005)(70586007)(70206006)(54906003)(5660300002)(4326008)(47076005)(8936002)(8676002)(36860700001)(26005)(2906002)(40460700003)(356005)(7636003)(82740400003)(86362001)(41300700001)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 18:09:53.9936
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aca3a01-01a8-4607-8bdb-08dc00bdb39c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB73.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9152

Virtqueue state change during DRIVE_OK is not supported by the virtio
standard. Allow this op in DRIVER_OK only for devices that support
changing the state during DRIVER_OK if the device is suspended.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Suggested-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vhost/vdpa.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 6bfa3391935a..77509440c723 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -641,6 +641,9 @@ static bool vhost_vdpa_vq_config_allowed(struct vhost_vdpa *v, unsigned int cmd)
 	case VHOST_SET_VRING_ADDR:
 		feature = VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND;
 		break;
+	case VHOST_SET_VRING_BASE:
+		feature = VHOST_BACKEND_F_CHANGEABLE_VQ_STATE_IN_SUSPEND;
+		break;
 	default:
 		return false;
 	}
@@ -737,6 +740,9 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 		break;
 
 	case VHOST_SET_VRING_BASE:
+		if (!vhost_vdpa_vq_config_allowed(v, cmd))
+			return -EOPNOTSUPP;
+
 		if (vhost_has_feature(vq, VIRTIO_F_RING_PACKED)) {
 			vq_state.packed.last_avail_idx = vq->last_avail_idx & 0x7fff;
 			vq_state.packed.last_avail_counter = !!(vq->last_avail_idx & 0x8000);
-- 
2.43.0


