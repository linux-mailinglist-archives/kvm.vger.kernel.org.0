Return-Path: <kvm+bounces-5221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AF2681E0F4
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 14:42:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58A151C215BB
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 13:42:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20728524BC;
	Mon, 25 Dec 2023 13:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="t7PGirZZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2082.outbound.protection.outlook.com [40.107.102.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69230524A2;
	Mon, 25 Dec 2023 13:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HpPOVL0LfmhvS00ieA1q7oQDX8tb/yXFRMOV1WQLFV1CXLN0c5bLGeczRVqR1oibHfVDsXYgeScBYKDqbjxNU7K023A+4jZTYnbCvb4dYsj0A3ugcNr74vAGTLvpA7ElPYmZfhKRVQDRzvSNJoQNfaZrPJNtgdu3iwRtt6/+F+mAhCOVejgDyMGpZAPINs2ZaJaOqGdAE1E4EG2opp46OubqrXqenS9ukM84eVti/vogPicYj2u55Hct2FzOUCr5yt2bKVkXLQL7C4JiHyY1CxjXhKMGK4r9CB27atpAtM6/Gwb+EMb2CXilfmN8RpUEiIlMQJa/mL/TJSuuJh3U6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YJIY655ftkdiDvQD8/8ryhleS7Q7zJO/SfxEv7juzIc=;
 b=WiS/dUvSNveNUFoBXGdDHuW+GwIimr9mNR/Z5cnZwMshk6haKy/c7eDymu0d3a88CehyDR0S64iWbxNsyRr1GC4eVQq8XHvIDpDaQUnH0xwFXvRrjZ+uXU8es9EVo42W/cKWU/W0m/uPAc7OyEv6mgEwLzN3N+WFamYNoVDNrT7PPgmtTOvKR2OShfJkzQnD+CTSgpjlNA4Mnu8cj1AM6sCKYsVFPJ6X6+JgcFVadv0dxg1ptVuFsA4seBEyL3LkhLnrIk0TaGQMQV1iucTLoNp7+3EPQ/irATs3ICowvy8z33ITSVvh/KlFu2CIVqEV+VuRy9yNwaZacu/PmGYzPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YJIY655ftkdiDvQD8/8ryhleS7Q7zJO/SfxEv7juzIc=;
 b=t7PGirZZrguskhK64jcgB6gSwjFa3wROupaqJu1GbReUtLBM7bBkhr5qIev/tbE4QFtO5TPChHAgjMQSLr2aI27/iAhXc6dba8nM8w2xWuhXxev5eCWZNR3wN65loEZjGPPO8iOYOpQVuWsAFkhNUy4Wfm3R+MKKJLpYjjhuVrtpNOKn0P0CN0NeX52o1xWpXaKbNb7XWIS9HZU27xWVRhYK7Z0226kI1Hzmpk388D8TAjsAFzpRfCoabfozjjG6x/YOpo/g7vKxHX3plkxg06Owv2SfNWCuBaQrlA+BB8YXWcIcfRHtoxz/CMrc1GZhAwVSSFC8E261mdeuhnoyPg==
Received: from BL1PR13CA0251.namprd13.prod.outlook.com (2603:10b6:208:2ba::16)
 by SA1PR12MB6972.namprd12.prod.outlook.com (2603:10b6:806:24f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.27; Mon, 25 Dec
 2023 13:42:28 +0000
Received: from BL6PEPF0001AB76.namprd02.prod.outlook.com
 (2603:10b6:208:2ba:cafe::46) by BL1PR13CA0251.outlook.office365.com
 (2603:10b6:208:2ba::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.16 via Frontend
 Transport; Mon, 25 Dec 2023 13:42:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB76.mail.protection.outlook.com (10.167.242.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7135.14 via Frontend Transport; Mon, 25 Dec 2023 13:42:28 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 25 Dec
 2023 05:42:15 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 25 Dec
 2023 05:42:15 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Mon, 25 Dec 2023 05:42:12 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, <virtualization@lists.linux-foundation.org>, "Gal
 Pressman" <gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH 0/2] vdpa: Block vq property change in DRIVER_OK
Date: Mon, 25 Dec 2023 15:42:08 +0200
Message-ID: <20231225134210.151540-1-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.42.0
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB76:EE_|SA1PR12MB6972:EE_
X-MS-Office365-Filtering-Correlation-Id: f76c51eb-0feb-4fa1-f5c2-08dc054f563a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	M2R6aVVKEBFF7bCNf9hNz8Y1Zq6x9BpfXsoAVIFM2FuxHXg4YV94ZjATy7j9l0OWB69OhnB3H5w8pqjhBZd6AFrOgn+oKol4ou14wkUirQYXCnpMlh8XF4iR//oy1Mnv0OYo6NuEYmjStsNfFLCY/m963FsEsepBybt/EoZ1O/JPwi+0Vbfy1SYernhRVBD0FOsIuQtJHPlEVKUk/0JC5faDbt9yiwhvdAnRRpRCJnWbebUt9p1trlWwvVXZguLaBb1wO6j8CijpXOBOULcT7GkiPevOs0KNg6sK7Hi77Rp0QB2SbH2exm8y752w92FxzL8aHLn7SSFI7ge49lacybk9cEGKlDPF/8Wkm6Y/ImpZRncg9igbmNi+f4y7GugZYRbUzv+vSJAF7ORJVo+FK9p34Uf8d+bOmJBJazxphgEEiuFpdnNQTQRu5+nbV08yBbZ9Izot2PUYbGlUzxG1QkJMxTIX6NTyv+Eh0U8cqpIu67TIpSSoxQRo63N7fIvMntcAhxjPO7AoRjJsFzxiqjj0/PDT/1a2waScaNQV4tH+Sji+0Hc90P2ZUzspK+l3AN6iPA7jRfTM8Be/VJYakkemF3V0tx0ddVTTYMJzO4HlqZbkZPmY/vdfUnh2+mWsMpZ6I26eVTNBVJBnWbjau0H+oM2sPTWG5fbI57SZ5PEcSqRT/k0OToPliV889ID9U0byzgvmZLZPJeoGGP1BU9/6M3iOBSiv9RGCrd9FzSk0ihK2+KtHX5AQrBLWTh7pNiRhCI+RIp21r6OvP1biB1LHkrcC2RHPgB9VNu8+M9M=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(39860400002)(376002)(396003)(230922051799003)(82310400011)(186009)(64100799003)(451199024)(1800799012)(46966006)(40470700004)(36840700001)(40480700001)(2906002)(6636002)(70206006)(70586007)(5660300002)(40460700003)(4744005)(4326008)(8676002)(8936002)(316002)(54906003)(110136005)(41300700001)(47076005)(36756003)(478600001)(6666004)(2616005)(26005)(966005)(1076003)(86362001)(336012)(426003)(83380400001)(36860700001)(82740400003)(356005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2023 13:42:28.4996
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f76c51eb-0feb-4fa1-f5c2-08dc054f563a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB76.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6972

This series prevents the change of virtqueue address or state when a
device is in DRIVER_OK and not suspended. The virtio spec doesn't
allow changing virtqueue addresses and state in DRIVER_OK, but some devices
do support this operation when the device is suspended. The series
leaves the door open for these devices.

The series was suggested while discussing the addition of resumable
virtuque support in the mlx5_vdpa driver [0].

[0] https://lore.kernel.org/virtualization/20231219180858.120898-1-dtatulea@nvidia.com/T/#m044ddf540d98a6b025f81bffa058ca647a3d013e

Dragos Tatulea (2):
  vdpa: Track device suspended state
  vdpa: Block vq property changes in DRIVER_OK

 drivers/vhost/vdpa.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

-- 
2.43.0


