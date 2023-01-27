Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A712B67EF3F
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 21:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbjA0UGi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 15:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233037AbjA0UGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 15:06:09 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20627.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::627])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B043A87C;
        Fri, 27 Jan 2023 12:05:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mIG6GzZbsr0lrv5MBoky3paRa9iZWjwo2nkipGreTUj7HR/0KpmRo88/VqXGpk3bqce6lzVtU9R0TewHUqvgAOOweRStRyOWJ58pOASX10SW0STre6/eh/5F/e5qkc04s95OviUdu2+pIc+xEddEtlpy5utnPa+AanqDuaRd55iKh3+Tc+8GgSJ2S1pBUOj4pP6/dyGiV+fSazxuw/R+pZsMtNpsGcoOMtyPtAVNG/T3yqwMSJdbS2X08lMj6XP9Lh1CxTfdSsHbbEm/xKLn9Hf1HP33dD894sXJ73UsTaL8dE+Kx0W1Uh8Aiqp6X5JmzzjKvsdMoARdH7MAkCqEJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o7EmmtTfdC1T2cy1HdvKUC7kTulqclX17gm9CF+M76o=;
 b=RQCY3oEDTPRqE7cyizjGO9M+j83o4d1gLgGKOIqEQWxtLegS7QdBwF4EHxm1lXbrpfqAu3VC3VuSmniJMBs2pvEMsbsW9pGkIIA/SbnRRsOIrcGZrFonVgybMIJyK43RZFQUxpD8f5j7HkUTqq32TLODOtUGpwbzpGjF/Syr4ubf4CQi86876ihOUojsE34kc4NrySGnEc1NTKXsqLvPqIlJApAL6XjA+JhSFdipT5jT3n7ecTqXoBbXArQ43sLgNpNQBF2R8S7NgdZtHSrsPxBhEbUQTx1KDx1XyFiPwAwO/Dbwvacuqcrzqww8QaOnOuAaJwTvnyzI0gYz9/96+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7EmmtTfdC1T2cy1HdvKUC7kTulqclX17gm9CF+M76o=;
 b=asCisvUzJrfR14Og7RP/mS0grPh2gsbr777KreyStjvscxOBUhvtQVPLBVXLvqwaU1AFCtrxWIdTCvBI0ftYFVErTiDCZVpvoq0DUc08QjecUgyi9KkczxK3XxuOGUttTTCiJ4NP52K0Qi3PA6N3B5EPS4UcUAjUHGR2Csk4chhQuRxijYlSsAc8kWhEMKuR4VnyELda04BCd6kGmHMZhQ98sVSu8QkOl2Rhed5MJ7VYnpWwefm6No3S4N1as+5SovWjH9oHAobUfNUCdnv5hd1seMUvhRh1mAdpJyAR/5OWIrLtNWovuhWBqNNFTax6wRoh2OdGuLBJEhCCVFc3rg==
Received: from BN0PR04CA0065.namprd04.prod.outlook.com (2603:10b6:408:ea::10)
 by DS0PR12MB8365.namprd12.prod.outlook.com (2603:10b6:8:f8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.20; Fri, 27 Jan
 2023 20:05:11 +0000
Received: from BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ea:cafe::10) by BN0PR04CA0065.outlook.office365.com
 (2603:10b6:408:ea::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Fri, 27 Jan 2023 20:05:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT039.mail.protection.outlook.com (10.13.177.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21 via Frontend Transport; Fri, 27 Jan 2023 20:05:11 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 12:05:02 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 12:05:02 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Fri, 27 Jan 2023 12:05:00 -0800
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <kevin.tian@intel.com>, <robin.murphy@arm.com>,
        <joro@8bytes.org>, <will@kernel.org>, <agross@kernel.org>,
        <andersson@kernel.org>, <konrad.dybcio@linaro.org>,
        <yong.wu@mediatek.com>, <matthias.bgg@gmail.com>,
        <thierry.reding@gmail.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>
CC:     <vdumpa@nvidia.com>, <jonathanh@nvidia.com>,
        <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH 4/4] vfio: Do not allocate domain if broken_unmanaged_domain
Date:   Fri, 27 Jan 2023 12:04:20 -0800
Message-ID: <42f5cec9d3f03eab3af9509bd5a730f6a1414989.1674849118.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674849118.git.nicolinc@nvidia.com>
References: <cover.1674849118.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT039:EE_|DS0PR12MB8365:EE_
X-MS-Office365-Filtering-Correlation-Id: 16aa347e-5ccd-4e8c-007b-08db00a1cc0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R6jo/E9hj+aFlwNh+ZQngKjzIs7s9C8Rr0TWz7tvftdukTv9brVHYi1ddAvd/5iVqpfpkuimTGThpauWSYwJVkpg1YpiKR3l80PUi97R+UEmGlMmpRMplN8zDQBw/XcFc0qAbYoiRU7q7zqFYpY3NAvGiMA9FAnR6rXHhpvCkS9tw8bGSjTqAV/5Top83N4/+Uh6zWp212eKGEiRT6dxeWdONz2z0urkGUdQ7ZkPnAb5SpWSj7Kt+hahPTAM8VMiFhpTdrv28fYSc/LwO5xc+BN0Iznsnm3NXQjBOeXo98voPXVDyrc2F1rHxROhyiSblkSo11tVDICFujNSRW25kdEVu8wERS2Zp1sOJourGD16KBPP4VBXW8zeyOiGIzXQXfHvU7pYO9sdcF/iGLFMGHLik5mSdVtqlpbuN/YXR6lswn8ecbA5TDhuqoyueOVjKPSVe044afcqHdNFlJ+B80i7HKB+JVmpQH3as6ogq+4CJjTFwxqwKetgCFzcYkfl05bxVSJJfk96zrQGi/VUkuNRRRpOZl3jEBjpzq3oKdGr8Ee741cGkUycZhDOkT6SgohZoOG54yQl/O1cKer3eVyEXcY2KrA4rc3v+Obfxjdx6My61NZpLi2/eM2n+eUimeXTWCxnaBDQyanfshLiaPgkbFra79JkWXr8p3OhzBPBV/9d39Hn3SlJUVOiNB2Aj1CUfl/i5UyDMutc/9p2sv2ZiLOymE9zIC7VH6ETIh8=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(39860400002)(136003)(346002)(451199018)(36840700001)(46966006)(40470700004)(8936002)(2616005)(5660300002)(41300700001)(70206006)(2906002)(70586007)(4326008)(8676002)(7696005)(336012)(186003)(6666004)(26005)(83380400001)(426003)(86362001)(82310400005)(47076005)(82740400003)(316002)(7636003)(4744005)(7416002)(478600001)(54906003)(110136005)(36756003)(356005)(40460700003)(40480700001)(921005)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 20:05:11.4190
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16aa347e-5ccd-4e8c-007b-08db00a1cc0b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8365
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a sanity of the broken_unmanaged_domain flag to reject the use of
vfio_iommu_type1 in the early stage, if the flag is set by the iommu
driver.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 23c24fe98c00..6ec238aefe89 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2170,7 +2170,10 @@ static int vfio_iommu_domain_alloc(struct device *dev, void *data)
 {
 	struct iommu_domain **domain = data;
 
-	*domain = iommu_domain_alloc(dev->bus);
+	if (device_iommu_unmanaged_supported(dev))
+		*domain = iommu_domain_alloc(dev->bus);
+	else
+		*domain = NULL;
 	return 1; /* Don't iterate */
 }
 
-- 
2.39.1

