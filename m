Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBEA03466EB
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 18:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbhCWR4I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 13:56:08 -0400
Received: from mail-dm6nam12on2060.outbound.protection.outlook.com ([40.107.243.60]:2016
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230173AbhCWRzi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 13:55:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Um0o/Pj9GunasrPRGTbq2j9j4xyeYJ9GQJa6ehhkcUwobKdC87S7T9LBkBCN3Q+4ndYLQTUqL2AiMGzUDKf1P4ykB4ytXvsG2YNryj86k0rS7H31jKoEYCzSt81ngHvSToJZXc5AAxmupbr33Fzaya12LQtVObw3gfXBM5Zy3qMZaui1v8/b32wlWXEJik/58aQHcRa7Wvh/MMzhFf7SZxHKanB/81KTxne4lWavJHArYKNkXhYew+9YS6OSY4topLcHUgPZHwIGUmXXoqKNKF9kMMYtAKgL9cab+MtDNUKe2EnkwlmRwq6Pbc+Qk7HI/m+Wc01A6MdmG1xYkc9G7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4PIbC/wFdKQFR4fPcnPRmuAGeheqBomLveTHM5nKmSQ=;
 b=GzkdCF44+ALypCGX2MxTdLL+x8X3+tjm5E1EGQ66K7ov+wvujVj6O2Bc+53YYY3uKi7Mia9ldr9NvKI1RYXtVwwmrb6e4aN7QISls4DUzMwD8MTq5JPkg6ewtx3kxUiNgZSZ5EHKuo3yw6VQtBA7EcOjVVb/covBUh+ySHdR91TM3JZi5kq/GordVzSabM9cWNiN9E6wykgQ9AuntLwTvw8tfHHusKUQ1bwQ62LMOnjgWFK/eiuN0BrCnRDUeofnWWfesdlS8YkfPIYr+/IA6lr2D5GqmgGtgVhRfhdB4SopIS7WMwVg5sZk/cg9iKgfKS1o1raTDOc9ds7US900WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4PIbC/wFdKQFR4fPcnPRmuAGeheqBomLveTHM5nKmSQ=;
 b=eAShh+5FFHzDI8ZOo9ZOHe9/E/Uga7ZXC74obqKmbvUgCJF7IMB3RJODgob1arzroTRf9kKiEfu5s092ahUU8ebJEiFQvpT4Jn85aMnfYVsVYNJ3JWkDQy1W3RfYp/WSFzvfHqu6RiI1y4Q65f1szqYpNjdBkJ9PZQSa/Dv+grA4cLE+sqSBe232SiDF+saX9zD/2cPyfcy62+9Ve56QM7JhcNTTdnp+dvvDSgVOk337mqyxgHgUOLguH0t1Nf5orq5qeQ6lHNFNCN3B8yZ69GT4Ho37I1GD/vPOnIh6mV++TYnzCPkdWw9LuyoRs+BUjr14XW2jYkUc4X5oV3+VWQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4483.namprd12.prod.outlook.com (2603:10b6:5:2a2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.25; Tue, 23 Mar
 2021 17:55:37 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 17:55:37 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 07/18] vfio/mdev: Add missing reference counting to mdev_type
Date:   Tue, 23 Mar 2021 14:55:24 -0300
Message-Id: <7-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: BL0PR0102CA0030.prod.exchangelabs.com
 (2603:10b6:207:18::43) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BL0PR0102CA0030.prod.exchangelabs.com (2603:10b6:207:18::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 17:55:36 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOlFf-001cgo-FL; Tue, 23 Mar 2021 14:55:35 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c88f8c67-cb33-4298-6109-08d8ee24dd12
X-MS-TrafficTypeDiagnostic: DM6PR12MB4483:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4483693068C04B3C15C64567C2649@DM6PR12MB4483.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mx/hdbMzTw/bWFNtJQLyhGedtPAb66XAgk6BVT9uNP+c6hj5z6sskLOCK0U1/tj8knHW/vKXvAMA/TpTHJaW6DBalBrPwdy+d7MyStd13s4cnNxrG2i4sAWI+cEKrtnIgNdsTjyCImbDPgrsQme8AlC4ADh9Z+wYhwRocvfeGBkQj1nOXzWCgMcZrvcwVcmWW+P6v8p5Xt6TkAMk6Ea2V6Qx0NZXgd5bSr3IfPN8yfl7CuYGGER9e8MpKXL/FCpQKrCe1ooHQnnx/kseKj8i23Kb2O0rpcUp7lQUwF5w8zUhmnu/a4W6svwbSl5yIC+VVN23tKx2XnXkCIZvGx4/a1bf2cEIpx3ZhI1WNd2H1XRtMt8pHl089ljWEkWki4MSPbG7Z1R91Qxe/vIwXSwIGo3nvfABA4UXcXr2AfPnh28rupSHN29/l0IT5aunVfvfF8r7mSu0akwQ2wGxJnJ0kAj154OH2zgOaW5f5W70uB5w+t+zyXvwdUCuIHanCc7YmVEdRyrkjFWYd312DQHtoL1keXKXugzPCmxSeNiCq1bpJUfzXZVOuEiMFq0XY5Q9HEjHSe2vBZXGej8O+Ay64+Y9HuEOmsQubvEss2rHPRR380ZghpgpaDdXL8Q5/YMs0e77hfm+aL953mOHVKOZSk6FDZcNB0uOzTQ9w5dT/aXRMpKMhmL6OS38rm6OrbvB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(136003)(396003)(346002)(186003)(26005)(36756003)(110136005)(5660300002)(38100700001)(66946007)(4326008)(66476007)(6666004)(2906002)(66556008)(54906003)(6636002)(478600001)(86362001)(316002)(8936002)(426003)(9746002)(9786002)(107886003)(8676002)(2616005)(83380400001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3dwmTcRTsUCiW9vIsntlFq2lfWd+4savseEybF8zFiEz2Va5P5AM/+c/Z54K?=
 =?us-ascii?Q?HouQG3jyGmpgbc2Turly1fXuQ5q3wNgDGj1/2deQuyCrFxfwuq+J8ow/s2VF?=
 =?us-ascii?Q?zC8VdGvyZLeft8ro7i/oKIg/9N74lc/7/SnCSpnNKnoQl+nCei9uVBjau1uQ?=
 =?us-ascii?Q?zj/ctItnPwWQIYy0I/a5SGMUjX921yptP2eK+ivJPtUMOGPMbpGM94gDzadx?=
 =?us-ascii?Q?eaBvJ5KOOmG4RTcthpkasyG572MLFQtG2wmZ6amROnwatem/fZ4Q1cG2KBee?=
 =?us-ascii?Q?kZROMU5FlUAxCcIfpAYksP2RiCInJS9T7fE8shHnNnogDr1TxW6NV42QHzmN?=
 =?us-ascii?Q?F5Gco7YRRq2QWSMJ3djZLrDemofzsrBsv3+nH3q+rcDeqF5L3YF5+NGyou/+?=
 =?us-ascii?Q?fSdQl1zDCWIidRHI86dzIaKc5V7Mbv29EPv/WB4Pqf/LJXnjpJgXZALIYqMr?=
 =?us-ascii?Q?UwWlEqSUrfCBTeGE77+p74lmbnFJHUGxTcfjphP894vsjiZRb+4kMdSPeP4E?=
 =?us-ascii?Q?eZlyQvJbGnCxq8Q9YNeHmf4p3LwpIBpKnHC8Y2JhFHosYaaY8D5P4v9GQ/iE?=
 =?us-ascii?Q?Hrpogg8DiWsvlmQZPlwIwKXnuBGfjT+7XM6jqgjnAYn7UF8RmmZzpivGsso7?=
 =?us-ascii?Q?shVo1Ns1qSWlNvY0FJtoii+WvBAiwe9w6gmpe0s8H94OWZv0GmwOqq9C15d5?=
 =?us-ascii?Q?v0ALmyrxeZuVZ10ouq1cbGFbI74fq7W1AYUoUzljyxePQ1ENQjvpO0ZwpdgR?=
 =?us-ascii?Q?J0TslV0eHIeVQtzMUlykvYZlvtIMkdsW1QMaPsA7zM3OR/x19wfgorvuLFK6?=
 =?us-ascii?Q?L8Rj9z0SjqvqiuyOMktbfxQucrJKM8ZPQ1teBs7mehdQ/V8Lq5HCHoa3ppgA?=
 =?us-ascii?Q?Y4lo13Y5CqCe/qtu5dDoB+C2dOAGxAD0F2YMyOoLPSm+gcZCrhKOw9F9+ECA?=
 =?us-ascii?Q?5qmUL9ihpE98vtuAyQ0EAZ9bf6WL8XYiEpxerw6zAN4YjPjbtBAOD2XqA4V1?=
 =?us-ascii?Q?SKbJ+VF7g2mwhvkdtUvl5VxupYF7X8RFX5Pd0xJX3r+/bSKbvJAbOocxKt2J?=
 =?us-ascii?Q?Ukxyh7TqDMUlI8745heRF6p50Vo/1NGgBYzYQVg6dwZfr9AfSXnuhvlBEDQ+?=
 =?us-ascii?Q?pegs3T2zELIdn2NeTzZLA0Wu6iXH8oZhwWCv51zRwqkLCa+pf0TQZ0B9sBTE?=
 =?us-ascii?Q?6MUoVOyuhOzn9C2OjHEmwCjpduQNqLDsyy3TjDyf7DhkWyshSv44XlxVzDme?=
 =?us-ascii?Q?f6EnrOnsVJCso7ZU1JlLIiluRgGGUMVlzQnWyX2HIT58LBpOia6urcGD53hB?=
 =?us-ascii?Q?x9tr03luG6quV+K44fwJ3Eat?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c88f8c67-cb33-4298-6109-08d8ee24dd12
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 17:55:36.9756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XCdcBOv4ECl3AzC2O4FPxhUswWk6D36gW+jzDHwRqy3IVUG40Cjd/x4maPGk1u97
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4483
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

struct mdev_type holds a pointer to the kref'd object struct mdev_parent,
but doesn't hold the kref. The lifetime of the parent becomes implicit
because parent_remove_sysfs_files() is supposed to remove all the access
before the parent can be freed, but this is very hard to reason about.

Make it obviously correct by adding the missing get.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 5219cdd6dbbc49..d43775bd0ba340 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -81,6 +81,8 @@ static void mdev_type_release(struct kobject *kobj)
 	struct mdev_type *type = to_mdev_type(kobj);
 
 	pr_debug("Releasing group %s\n", kobj->name);
+	/* Pairs with the get in add_mdev_supported_type() */
+	mdev_put_parent(type->parent);
 	kfree(type);
 }
 
@@ -106,6 +108,8 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
 
 	type->kobj.kset = parent->mdev_types_kset;
 	type->parent = parent;
+	/* Pairs with the put in mdev_type_release() */
+	mdev_get_parent(parent);
 
 	ret = kobject_init_and_add(&type->kobj, &mdev_type_ktype, NULL,
 				   "%s-%s", dev_driver_string(parent->dev),
-- 
2.31.0

