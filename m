Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28A93BAC7F
	for <lists+kvm@lfdr.de>; Sun,  4 Jul 2021 11:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhGDJhI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jul 2021 05:37:08 -0400
Received: from mail-dm6nam12on2062.outbound.protection.outlook.com ([40.107.243.62]:4352
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229476AbhGDJhI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Jul 2021 05:37:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QIeb9ejdtUkN5J2y9r8FKQoR256EMRbbN3ecGe3mPtzAzQIWho5D5T0ryT3SZjrZfaukyQmbd0/91DF6p2RPaR2HQrtP8CSAHFwX/2k4qKY39B/qVAsu0+Ac8wxexxRyGHiUH04shp2kpiGRC1uxU+qd8bTeqYYeLLTmABPKxOywsYjYLZLaWhIzk3oO+gKyQMjeOfX6bVUqLklvCeuUsXhVVGJQp/GPP9rWu97N7aCVtcGRTJDFqx4rENBmlHqeDQcRcyxn67vGTmze8gktu1wF3zXIqC656DKrzOUtmbSg+78gmJAJdUKWPk2DGiKQ6CVdRH2uc0U7ROgzioBHPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fl+U7MsM1rzctM5qH1exdZLT19WaO9aE6s9q6o93Lt8=;
 b=NGli8ieIEN4v7mdYy8qWd2J+7BzukC9TTOuv1FtEaegy9lIEF4iDEbwxthvuSShB7aDg/UJCp6Wz2W1hjcHmP4ENbpl0xO3N0QSCbDQl3UXm5+MFJtjLRrpB+cBC5MdikQcWH921SD6hrf4VTXpQ59bOoaBDehyhQlOBeprr/CjHITROoYwAhWcmYJ7YI3JIGrOzIy1olAh3JQsMYuvXMp++o5H8L7LyHeBULo+Q1+aivNKbrATEB/WRGQ8pSiv4Ia3mDtH9OxhdpV5emCUgNR0+3H3bY946Tple9tK5WhOPT+3xb8ME0wKx6flCYstOHaX5Xf++kgsiiNKe705+yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fl+U7MsM1rzctM5qH1exdZLT19WaO9aE6s9q6o93Lt8=;
 b=V6U9Apb9Pp781xm7hBvTqZ97P4mwHW9pPzgp5s2N4tCl5IpB6eY+u0OXN0e6QgxjOi044pjl6Sk6e50CDtf0Jk1R2ZQUzHQCnS68o55Of9tD0XHJ9s0vsZv/395vvL1QvfYwI3xkZTfJMB8GHI6FSwFvJ1kKupmxSKElD7jU203Ea1+1u3kb7g98V/0XUKBQXcqQWOiMYAHKugX8TQgk5DrXAzeWBkIrX1b961tH/QnKNYWuI53dt+9gDJ5xJk0rfa88FjgtTwCjVdWrkKVgOGorPp1o5aydTKunIt+xj89QXRpJ/XGsMQYawwsdpk+Dl51KbA8TIGxlkos2JmmBgA==
Received: from MWHPR04CA0045.namprd04.prod.outlook.com (2603:10b6:300:ee::31)
 by MN2PR12MB3310.namprd12.prod.outlook.com (2603:10b6:208:aa::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.27; Sun, 4 Jul
 2021 09:34:31 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ee:cafe::1b) by MWHPR04CA0045.outlook.office365.com
 (2603:10b6:300:ee::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend
 Transport; Sun, 4 Jul 2021 09:34:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4287.22 via Frontend Transport; Sun, 4 Jul 2021 09:34:31 +0000
Received: from [172.27.13.138] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 4 Jul
 2021 09:34:27 +0000
Subject: Re: [RFC v2 3/4] crypto: hisilicon/qm - Export mailbox functions for
 common use
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>, <yuzenghui@huawei.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
 <20210702095849.1610-4-shameerali.kolothum.thodi@huawei.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <2f9c5fee-fcd1-3512-fef8-f2707df621ba@nvidia.com>
Date:   Sun, 4 Jul 2021 12:34:25 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210702095849.1610-4-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fefa8b2f-1c65-452b-f0fc-08d93eceed1f
X-MS-TrafficTypeDiagnostic: MN2PR12MB3310:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3310A5260A8700DCC8E40A97DE1D9@MN2PR12MB3310.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: llyedbrRhHgD24XMeiJZ5FLBu4jWA0VYQnS1m+WLb9yl8QpnK4ctX/U4s348ESZpVpHtmx8fxmbNFKMABUGdh4suAzWXHRANnaJYilpCzVtgoIoCqlNWGAlV+miR0aaZ/Vi+w2CugSjKi+JK3tQXDrGKmbmhC4Uqmh79HoPXFXHYxpAhq47I1nA+d9KOBbiegPtfkjogF/5gfqhYxUVPFD0vx9YFAfmyeiMfb6nyB69XbVA74LCMwSfzVtZdHQYPie1OVrOS2iWdTbE4++s9pHDF5Ki2VN+C2LBAqmWmGrZTVqpLSmE7LMY662I4URAq5K/iwuQJ+we4rBWrq4tENcezCf0MFuj8Y5XZmPO9jeeqRJePFg9V66z+TCp8G2ALhrrB1VZoSs4n8eRTVlVUoeJUoYtdBDhW6A7ULOsyIx3AlyQYlY87bP2tmj9JYrKnpTU6DkLCq4QFip0ft2JhIZorblCz7u21CGcv6Y9UNn1gpcg93NzOj4fIa+ltDeT5HwAG9IuAhVFmuz7QPicz53Z6aqPsT7so38NxdsjhVEVlfLxIqVNrNo3qVdDNg7qXYjpzLNuHDckg2LzC8J4KiEkmXE7Ot5ekILMEMNmwT5Dpvb8uAuEmb49OLqalnV7TRa8Ejlk/eMM+h7vwZ54e+pj08NNkN9oxWvIsbPVOhkNpq07fElqobYLqqEjKEBUoyVoY3T9SbWyHXJg97QlU/Ji1tboOH0b5Qi1nfgY1uOg=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(346002)(46966006)(36840700001)(70586007)(70206006)(36860700001)(4326008)(8936002)(15650500001)(478600001)(426003)(16526019)(7416002)(47076005)(2906002)(86362001)(5660300002)(8676002)(186003)(2616005)(82310400003)(83380400001)(53546011)(36906005)(356005)(7636003)(82740400003)(36756003)(54906003)(110136005)(31686004)(316002)(336012)(16576012)(26005)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2021 09:34:31.0985
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fefa8b2f-1c65-452b-f0fc-08d93eceed1f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3310
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/2/2021 12:58 PM, Shameer Kolothum wrote:
> From: Longfang Liu <liulongfang@huawei.com>
>
> Export QM mailbox functions so that they can be used from HiSilicon
> ACC vfio live migration driver in follow-up patch.
>
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>   drivers/crypto/hisilicon/qm.c | 8 +++++---
>   drivers/crypto/hisilicon/qm.h | 4 ++++
>   2 files changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index ce439a0c66c9..87fc0199705e 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -492,7 +492,7 @@ static bool qm_qp_avail_state(struct hisi_qm *qm, struct hisi_qp *qp,
>   }
>   
>   /* return 0 mailbox ready, -ETIMEDOUT hardware timeout */
> -static int qm_wait_mb_ready(struct hisi_qm *qm)
> +int qm_wait_mb_ready(struct hisi_qm *qm)
>   {
>   	u32 val;
>   
> @@ -500,6 +500,7 @@ static int qm_wait_mb_ready(struct hisi_qm *qm)
>   					  val, !((val >> QM_MB_BUSY_SHIFT) &
>   					  0x1), POLL_PERIOD, POLL_TIMEOUT);
>   }
> +EXPORT_SYMBOL_GPL(qm_wait_mb_ready);
>   
>   /* 128 bit should be written to hardware at one time to trigger a mailbox */
>   static void qm_mb_write(struct hisi_qm *qm, const void *src)
> @@ -523,8 +524,8 @@ static void qm_mb_write(struct hisi_qm *qm, const void *src)
>   		     : "memory");
>   }
>   
> -static int qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
> -		 bool op)
> +int qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
> +	  bool op)
>   {
>   	struct qm_mailbox mailbox;
>   	int ret = 0;
> @@ -563,6 +564,7 @@ static int qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
>   		atomic64_inc(&qm->debug.dfx.mb_err_cnt);
>   	return ret;
>   }
> +EXPORT_SYMBOL_GPL(qm_mb);
>   
>   static void qm_db_v1(struct hisi_qm *qm, u16 qn, u8 cmd, u16 index, u8 priority)
>   {
> diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
> index acefdf8b3a50..18b010d5452d 100644
> --- a/drivers/crypto/hisilicon/qm.h
> +++ b/drivers/crypto/hisilicon/qm.h
> @@ -396,6 +396,10 @@ pci_ers_result_t hisi_qm_dev_slot_reset(struct pci_dev *pdev);
>   void hisi_qm_reset_prepare(struct pci_dev *pdev);
>   void hisi_qm_reset_done(struct pci_dev *pdev);
>   
> +int qm_wait_mb_ready(struct hisi_qm *qm);
> +int qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
> +	  bool op);
> +

maybe you can put it under include/linux/.. ?


>   struct hisi_acc_sgl_pool;
>   struct hisi_acc_hw_sgl *hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev,
>   	struct scatterlist *sgl, struct hisi_acc_sgl_pool *pool,
