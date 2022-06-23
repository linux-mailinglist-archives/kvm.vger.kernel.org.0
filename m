Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4045589B0
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 22:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbiFWUBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 16:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbiFWUBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 16:01:43 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A424396A9;
        Thu, 23 Jun 2022 13:01:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Co4GHUa5WYY6rVCIoyjlQRDERyL3FGc5U3ZiV0/YSevyIG5k5c1Lq68AttlssKew+EIsWlygIXgNMxMFgdwZEgvZyP5Yaahox9TC+zRtChniEK3Eew8hWyn8kxG02++2hcXaviStyjEqJ3+fDWBKIJa7C7D3btlemFm3jFG4BFaoB1EiGCb6Zd+4JFVFREwEW7vE+1vOSnTnj3En//IoXr5w/9D5R8HXFLJmfmsNshxu9YdA2iIt+oPJzLGgk/9Wv9Iyc+ui2itbgmPJ5EJQB+ERaBwwkkm1Zih5Ry68LhE1jg4UcOEBZ4wfLqLUtckWAeX3MLalnckgRG+ltN/0YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cgJ77wZrDNZZI/c74qOyQalK+y4UD39aNlCVjefkCFU=;
 b=jcQNyoDxf9DZ28cF1cY8UrK5SXvOHuE98dl7iyP0PjcjWC+kM26bgPbljF3H+CESlLLM7Uxev0Be/1yztLTewuTx/qOzgSRSy+Si7jekukMgMixSOiNmBAs8PHaq8MgAl/mHuevqs5FZBYS8lwb8U0gBp6OlVL4CrlP9WrNqC7HF9wYTpsAxh37G0PA0s9fwHMSIcsWuRZrRL9uLy+ojVZ7hRPqwfpAUHZMfrW1ZKgiJ6rjuK+GO/EGSma5mMSDTxvYhP7oA97c/evHB7C9WS0voO7/BlXS7W3gZtd0oheBbxTqOV2BkaBXH8SmH0TJ7B7I2XIQiepvlFQDHCQycUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cgJ77wZrDNZZI/c74qOyQalK+y4UD39aNlCVjefkCFU=;
 b=UdqzXgp2vPSZy6Lt6lbHAFTnWPiadhpa8O1Y/fnR2uJ/8E5TW7TdKCZyzC6zGdSi5Fnn4j3ABwyZ1rvIEZo3LEF3E3h3p8g9c22R69nDANYUj2yN2C6HIRuCy6Uf06uuIpsxZGNE+q+iYBZIMHXsWLKROxJvlTo4pxbqjLjBK1Fnlis9BhEe8COX0+LCC1z2Mh5R3iMuNoUuz1oa0kWLOSSMv4SH9twNtyEPY/EmZSHTBYKqwUx5TK5rj+vdWg0aVvpw2kKc3R3Q4BRkd0j34oGAzEOmeWOFi0rUkHP9RSEKjI1UktHX+vNvhRm8bVJGLpAC5zv5D4/F+y9f3Y8ecQ==
Received: from DM6PR03CA0077.namprd03.prod.outlook.com (2603:10b6:5:333::10)
 by CH2PR12MB3813.namprd12.prod.outlook.com (2603:10b6:610:2c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Thu, 23 Jun
 2022 20:01:37 +0000
Received: from DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::a0) by DM6PR03CA0077.outlook.office365.com
 (2603:10b6:5:333::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Thu, 23 Jun 2022 20:01:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT021.mail.protection.outlook.com (10.13.173.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Thu, 23 Jun 2022 20:01:37 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 23 Jun
 2022 20:01:36 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 23 Jun
 2022 13:01:35 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 23 Jun 2022 13:01:33 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <robin.murphy@arm.com>,
        <robdclark@gmail.com>, <baolu.lu@linux.intel.com>,
        <matthias.bgg@gmail.com>, <orsonzhai@gmail.com>,
        <baolin.wang7@gmail.com>, <zhang.lyra@gmail.com>,
        <jean-philippe@linaro.org>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>, <kevin.tian@intel.com>
CC:     <suravee.suthikulpanit@amd.com>, <alyssa@rosenzweig.io>,
        <dwmw2@infradead.org>, <yong.wu@mediatek.com>,
        <mjrosato@linux.ibm.com>, <gerald.schaefer@linux.ibm.com>,
        <thierry.reding@gmail.com>, <vdumpa@nvidia.com>,
        <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <thunder.leizhen@huawei.com>, <tglx@linutronix.de>,
        <chenxiang66@hisilicon.com>, <christophe.jaillet@wanadoo.fr>,
        <john.garry@huawei.com>, <yangyingliang@huawei.com>,
        <jordan@cosmicpenguin.net>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: [PATCH v3 2/5] vfio/iommu_type1: Prefer to reuse domains vs match enforced cache coherency
Date:   Thu, 23 Jun 2022 13:00:26 -0700
Message-ID: <20220623200029.26007-3-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220623200029.26007-1-nicolinc@nvidia.com>
References: <20220623200029.26007-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75f04611-1fe9-4f3a-87e4-08da55532e48
X-MS-TrafficTypeDiagnostic: CH2PR12MB3813:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3ANiL2ol6JRxsySqqh5zZx+M9SaAgOzRGLmWTi+hka87xak42yNXAmkib7DaHXljd212hiDpFUmRgWRDgqD0cjwSyXDZBuOAbV5EVT0j78H7acGoDFjleMUtDsEzENZ3/z8isiISbIpHQTRMzRSXUQZdyYzb6BeYLprTY8jtcYQSiCxVKWfLWoF182VqwiDfWOI5Uc885D5AOxnRqibLg+mlk8ijioJwWpdikqkyRM0YTCjBpep573T5KSb4V0KXpYqia/TaJYtuGggA9CtvJ00Wxy8+CiduZKj5LJXMiRzQIN007IEIz7gG0eZQXEV1NC3hjEZ4kEBXPZ348m3VO8ylFGfuZc8L2pmqv2P+BW30FewDzZcDWdkFgPFjKJCEvZq623uS1FB9SaC0RK6L/y9vy6HINy0OdKVqztPmGBdilDea1N+e/okIIeVr0cvRNrfPnJSiaaXa3xoYUoCYVBDZgwiTzt1XRPR4wiCNjhOk+Zh4V8XiOn957EZlDxglmK63NeXhmjkNYse2KNuQl+59uLmkBGZps7/dgBz6hhlksXTDy1fSkYLQylmYtpgXOjCIcBztRcEYhZ7bKBTwgb74i+nBLIEHtjmrXS3YqHF6NlIyzFg6N498MXP2NyRR4W658yDkwOYQDLIIw3VjcnJXANUL4kYjKb9mMJW2EVxj7Y7rd1xYQeRmpYQVq6DNgVBPWxUGAJ0y8BF2W390Cs3CgCK2ES7i51IwdNrugJQeb2IDjypeq5umq2BRYjgGOKqxa8GeYsh2dEpFziEhIwIlF2h2mmsP/DD/V1/DgBmezoP8fWXzeFdxYApib4FPFnq8naJQ9D8gM0qo31k036HySx0oTkGmquRD7ckNeCiaAL7mM5WNYfK1c0fWPmrpULTI6WP56IsVoqAsiSQoCw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(136003)(40470700004)(36840700001)(46966006)(8936002)(36860700001)(7416002)(41300700001)(336012)(356005)(1076003)(40460700003)(83380400001)(36756003)(186003)(47076005)(70586007)(5660300002)(70206006)(426003)(2616005)(82310400005)(26005)(7696005)(478600001)(8676002)(6666004)(110136005)(54906003)(921005)(316002)(2906002)(82740400003)(7406005)(86362001)(4326008)(40480700001)(81166007)(83996005)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 20:01:37.2248
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75f04611-1fe9-4f3a-87e4-08da55532e48
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3813
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

The KVM mechanism for controlling wbinvd is based on OR of the coherency
property of all devices attached to a guest, no matter whether those
devices are attached to a single domain or multiple domains.

On the other hand, the benefit to using separate domains was that those
devices attached to domains supporting enforced cache coherency always
mapped with the attributes necessary to provide that feature, therefore
if a non-enforced domain was dropped, the associated group removal would
re-trigger an evaluation by KVM.

In practice however, the only known cases of such mixed domains included
an Intel IGD device behind an IOMMU lacking snoop control, where such
devices do not support hotplug, therefore this scenario lacks testing and
is not considered sufficiently relevant to support.

After all, KVM won't take advantage of trying to push a device that could
do enforced cache coherency to a dedicated domain vs re-using an existing
domain, which is non-coherent.

Simplify this code and eliminate the test. This removes the only logic
that needed to have a dummy domain attached prior to searching for a
matching domain and simplifies the next patches.

It's unclear whether we want to further optimize the Intel driver to
update the domain coherency after a device is detached from it, at
least not before KVM can be verified to handle such dynamics in related
emulation paths (wbinvd, vcpu load, write_cr0, ept, etc.). In reality
we don't see an usage requiring such optimization as the only device
which imposes such non-coherency is Intel GPU which even doesn't
support hotplug/hot remove.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index c13b9290e357..f4e3b423a453 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2285,9 +2285,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	 * testing if they're on the same bus_type.
 	 */
 	list_for_each_entry(d, &iommu->domain_list, next) {
-		if (d->domain->ops == domain->domain->ops &&
-		    d->enforce_cache_coherency ==
-			    domain->enforce_cache_coherency) {
+		if (d->domain->ops == domain->domain->ops) {
 			iommu_detach_group(domain->domain, group->iommu_group);
 			if (!iommu_attach_group(d->domain,
 						group->iommu_group)) {
-- 
2.17.1

