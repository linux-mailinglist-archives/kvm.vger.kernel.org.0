Return-Path: <kvm+bounces-2500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 755367F9B25
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 08:51:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DFD2CB2098B
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 07:51:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6209B10A01;
	Mon, 27 Nov 2023 07:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DV3r3shJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DB1E6
	for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 23:51:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWdUmCFpN2XGVMgm/lgtdUD+SgqvAhbr9+lRUf1kPLkvLvITLgDCuQTJgmhgsX82HnXUgNj8bRgcJ6/Q7HAEgJ5H1qrlez9oqIXV1NwxqA8KqYDrnrefdxoVIpVLCBAPvdJEPBqFH2LjBvNKJGNlCjJXPF4tzkUwQBbBrQoXXwNsIh1mJ2IW1OLUlAtw7zpJFBl8z/wwz0FCztTBJ//gVvMkEg9si0yzgj6vl1pXOKi+Gtn7DKMqqe7XHLNonO8qxru0oPREDjgByAIHyyvesqc3bdE1Qzx+wPulfyWY3utnv2B5Q4qt+7wNkPFNI/YtQFmRIMe2iVLkZmZk1jiCuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k5L4snLouOZ7xuQaWU1ZJxeKU/4CYhwBW5iCKY3dmzM=;
 b=ACLFt/R3wOsZd0wyph2cXRenBU4NQFXzspZLEIAIYZfpGEJskPQoPSrZvCfj0U8N5BntUHqVEpvC41lDMXTcBhY6f2BSdL1Sq93t79skF9Xug+oFX5i2zOwg0aVFfRLZofLkfvwzfbdAVaTWAd5jFOe4X6x99B0Tvl6+2TkaVFqg+/bIFkW9+11v1HhBuvXbhKZFoda4OXW4KqvQYn8frkZod2sWopm29Y1wr5tvXF7sD8YvpeEd21++xg8z/GOA9XfqCo184Gbid4TcA9zerSNbPJiwpQldIooOLLkNgOc+BHhOQQW3HowTxr0F8Toa4C3s95fFyHiz+hctMjasiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5L4snLouOZ7xuQaWU1ZJxeKU/4CYhwBW5iCKY3dmzM=;
 b=DV3r3shJZxCE3lAsupWNk0ljL0XI6Z8MvT6qDGAIHmE+elz2qfTFu2aoRhZTieImGdQDPEGDkLNcy6R98GFFhrlta69NOUnzmv/pcgkXXcLcMZSKCl8UhI1Ytez2koiXg2DpHe+vW6oQ96MhIfCyysMri8gE584s8i9iSXlJQMG2JxHvIoI38xkfqoVATWV2RgS9mrwBHFEeGgz1V4iBywyVJpAyqKxWvcoD7rrBvY5tcFfG46cn9jK+w2EBQ5YAQX6zr1mY22sM4hrMci0pg9ZDC1XONovWqKE38ITUVCuvcd0w7ZDVPb01mkrAxShk6orynhnOiyDHBEKad/TWhQ==
Received: from CH0PR03CA0021.namprd03.prod.outlook.com (2603:10b6:610:b0::26)
 by IA1PR12MB6211.namprd12.prod.outlook.com (2603:10b6:208:3e5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.27; Mon, 27 Nov
 2023 07:51:17 +0000
Received: from DS2PEPF00003440.namprd02.prod.outlook.com
 (2603:10b6:610:b0:cafe::3a) by CH0PR03CA0021.outlook.office365.com
 (2603:10b6:610:b0::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29 via Frontend
 Transport; Mon, 27 Nov 2023 07:51:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF00003440.mail.protection.outlook.com (10.167.18.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.17 via Frontend Transport; Mon, 27 Nov 2023 07:51:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 26 Nov
 2023 23:51:04 -0800
Received: from [172.27.19.67] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 26 Nov
 2023 23:50:57 -0800
Message-ID: <dca10fc2-7666-4f03-90ae-3f309e483921@nvidia.com>
Date: Mon, 27 Nov 2023 09:50:53 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 vfio 0/9] Introduce a vfio driver over virtio devices
Content-Language: en-US
To: "Michael S. Tsirkin" <mst@redhat.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: <jasowang@redhat.com>, <jgg@nvidia.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <parav@nvidia.com>,
	<feliu@nvidia.com>, <jiri@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>, <leonro@nvidia.com>,
	<maorg@nvidia.com>
References: <20231113080222.91795-1-yishaih@nvidia.com>
 <20231113050633-mutt-send-email-mst@kernel.org>
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231113050633-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003440:EE_|IA1PR12MB6211:EE_
X-MS-Office365-Filtering-Correlation-Id: dd6486ea-ad3f-47d1-ad23-08dbef1da2fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	KH6ailLw5FTkcPZEP1mQawb75kFeBY9cAULbfVG/Hm0W36Nctaufpr29cBS0T/beOgJ+rZywofhlPxpqwFCEHdAlL04MtFxQiPExlAA0boIw1XRRQ8ppy6zmB9Bo9zlqjDhihd1Jgz5XunMOrpkF2XfIm62btYKkXIx8cmo3Sf9LwHmpf87o445/z6irwyx3xZ/Er81D9L760qOSKjXzJlxxbKEfsKJpxGN/Gs0Zj2qJmSu5doKqQdBnNWQrlz96ponxAgClT8xqI8ewCduTN/UhiofNecGge8zbNETzi3vZ2Az+RuR6QrANYYPGKyLMcQUObsQ5aB+JfSMWH1fn8pG55RmuAk7Q8LdRqYS5mD443Q8tdrAo7ySC7WGV0ZOsrMtLdAIfV1YTSKPfVGpX2ANz3a4NyTpClZRr7rxEklWamFKmbQkfV2gWzpKddqI03eHY4B8oikMgISfLfwuc67btWG1+WfIDJyLEIXm+FD45VHzkCUbYi8kIoQY3TpG1Grh2VrWEp/Mx+9z/Vjb6buini7wshc9ao24JVMrOQmxJF7K3SNg1sbdVC7cADue9ANJ0fWQYm0144YQpdzL38YZBhK49qJAloar9SBGyPuuVkj/hjhKfHtP3ySBKprzhDT/VxEwkPK3phXn4L3D4PhTvxOA3r88RJ/dG31SKlS52IAR9mPSKyOQmXh4EDdNXcC+M5IRH2dc7Wfye3O/m3GDVgdAOZ5PhqH6Xf4RYTvYpI7D+vQ0V86ByKnRXIq8DHDj4+anAFA4jGiX1s0dfAg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(396003)(376002)(136003)(230922051799003)(451199024)(186009)(64100799003)(82310400011)(1800799012)(46966006)(40470700004)(36840700001)(40460700003)(2616005)(16526019)(107886003)(26005)(6666004)(53546011)(426003)(336012)(82740400003)(4326008)(8676002)(8936002)(5660300002)(31696002)(86362001)(478600001)(316002)(70206006)(70586007)(110136005)(54906003)(16576012)(36860700001)(83380400001)(47076005)(7636003)(356005)(31686004)(4744005)(41300700001)(40480700001)(36756003)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2023 07:51:16.8271
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd6486ea-ad3f-47d1-ad23-08dbef1da2fc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003440.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6211

On 13/11/2023 12:06, Michael S. Tsirkin wrote:
> On Mon, Nov 13, 2023 at 10:02:13AM +0200, Yishai Hadas wrote:
>> This series introduce a vfio driver over virtio devices to support the
>> legacy interface functionality for VFs.
> Because of LPC, pls allow a bit more time for review. Thanks!
>
Hi Michael and Alex,

Are we fine to proceed towards merging the series ?

 From my side, I plan to send V4 which will include:
- Rebase on top of the below patch from the Virtio area [1].
- Fix a leftover typo in Vfio (i.e. drop 'acc' from 
virtiovf_acc_vfio_pci_tran_ops).

[1] commit 3503895788d402d6a3814085ed582c364ec3e903
Author: Michael S. Tsirkin mst@redhat.com
Date:   Tue Oct 31 12:02:06 2023 -0400

     virtio_pci: move structure to a header

Yishai


