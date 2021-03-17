Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9716633FBC6
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 00:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhCQXZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 19:25:29 -0400
Received: from mail-mw2nam10on2088.outbound.protection.outlook.com ([40.107.94.88]:52320
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229558AbhCQXZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 19:25:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hjO/j139lqeo1VG2nHOieUh08VDvVxCRLZwVYXRfs3RIxtsoc46sVpDcN29L3eS6+WQMfITW+lVeETGnTe8tU06NcQj0F7bGaDxfOLmBjr+j4TNcdx5AoV2/EHNxoytSPeeo8loIFfMnURkqNqtmali73bOkRtil/6r01c3JUyNsIzyEXuih/fvwyUjkoFuduumhQFAI/10UPlK3rWRaCXH9bO+bo6LJpnD8ZcSbIIOV/T+09AhlJHOyHvRdW4XJKu0/B/ON2vM1e4KovFZJFj6hSmSlY7ODzKaOdWrksGVFQ49+ZVm3JEH5/Z/IB5YJ6+zhPwFhxreksQvpjGNSNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RXKARkoFp1dic6jAGHd0TEe2hsGLz84FGCsP66KbpBE=;
 b=KXEITzPPHhjyqSVPS4Pa6ldG7VXAG2k0PPdNi9qW6IXCn+9e6eud8LMOLazIX2Ek0QqiUHq49lgVbd939VfPYjJLtwBUu3+cfgXk3bPROx2m8DaRpUVaWtW/PEgoQMmAqkznQKDguMJa4YdIfarFutu4AvBgpAs9qqDTf8FXFiEpQOtB9bgs77q0AgDmrzLuwtll/Ujk03AcH3DdITaEehjiCgBsTgLdMD+occIqtE3MN6YeMgAM2nh28hmITXzZqPziRVg1B6e/u0g7/vYpd27rz86Yqzka/pyTM3V73HILpsSvnsCG7Lcj2okMWE3PNrqKY1fal08JRpHB18nSpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=oss.nxp.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RXKARkoFp1dic6jAGHd0TEe2hsGLz84FGCsP66KbpBE=;
 b=AoqMbI+iREuslF86f/1JIF38IK8lAhhvTQKY0+SEZckcPEsre606ltXWZtXLlzId3jWj3BnGHBZvfL8bBAZiwqQD1wLXEq7UsuS5dpTpHn1Fll+ltXnKfwhSy0oxZMPdT+t+fFtsMa7REGt994niII0pJrj750viRKO8DfenFdB1QTYOUbGqOt2PDmtAS0rrK8TP5FZeEiVZ2FR6anTYLjVyzCM1bqcNNdSQWcyiaKr9uoZyly8fuxDs3szvN15moLPR2577tk1Rk88YPU6NIYfegw3h1x0Bay57TrGvGKFbOXpKUk7PTEtWsBb9SxiRcYeatX149NC9Qc9St08NWQ==
Received: from BN6PR17CA0011.namprd17.prod.outlook.com (2603:10b6:404:65::21)
 by DM6PR12MB2635.namprd12.prod.outlook.com (2603:10b6:5:45::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38; Wed, 17 Mar
 2021 23:25:11 +0000
Received: from BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:65:cafe::79) by BN6PR17CA0011.outlook.office365.com
 (2603:10b6:404:65::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Wed, 17 Mar 2021 23:25:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; oss.nxp.com; dkim=none (message not signed)
 header.d=none;oss.nxp.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT007.mail.protection.outlook.com (10.13.177.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 23:25:11 +0000
Received: from [172.27.0.0] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 17 Mar
 2021 23:25:06 +0000
Subject: Re: [PATCH v2 14/14] vfio: Remove device_data from the vfio bus
 driver API
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        "Eric Auger" <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        <linux-doc@vger.kernel.org>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Christoph Hellwig" <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <14-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <696b9873-1d96-0c5a-166c-c2a5ae7b66b8@nvidia.com>
Date:   Thu, 18 Mar 2021 01:24:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <14-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6db0c0be-ec1b-41f6-0f64-08d8e99be91f
X-MS-TrafficTypeDiagnostic: DM6PR12MB2635:
X-Microsoft-Antispam-PRVS: <DM6PR12MB263564F5123C0BE9D9D46EF1DE6A9@DM6PR12MB2635.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:202;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Y7rat7956+/1Sw0i7+6p3ERQ7ACsrF+cG046BG9eB4SwU4JDWGwR49/USzKnFHgvK/1XLkmBZD/mnezbZFPQ6e3C6UKMXv0rk4RPEYRUooZKer3PtEodCOztHgLiUrC/thsi4OX9GEQnEb+8mIGT5sf67cOO6bgmSpYbBh1OF8TM/HDmfg6pm+J1sUNFnClxul2Sb3oZ7rLHKpHDGpMhD0ZxfPprK6ZWXqK5Nqlo0oejR4RuXjvjH2L6QczHUfO9bI8iKINWFn7bJh0f4CeokNz/sUUCB9RZ2VHmce62SDH4V21qBxcAoSXLY8h+77UveBJzkW4Q7Ld1m/g7qi6MJDzdvuV2acvbH02txaswa0eU8wOd5WI4O6Gs0JtItTj+qi7ywr4EVbT40a69YLL3iMUFQOvWjVFSXGqo2s3/TsDQtAUtkjhNiipvvrFRcxlGVD+kG6AWYOulWwfrw65n7IWOn3xHztah/ACasKX9PZqLZAn4zNPCXwrjCjkUOZPVYOBQZehPx4I+/h9svxxEGwqNJQdnfvb+6djU6VYpu/TDZ5dg1UGwA6zndKKQ7TjmYhKTgqaDHI3RwSEHEb+iHYSrjaTCIqjhxEIXbCyONlIb4Z1ds8pVlBfDB40hEOgEP7FCMqj+eKrgMYquw19udmcRcvNfCdfp0RmeVoN/oGwveRudbXnwKraL8LYLGoI4g/hsVqztXOrrlZBVusMJ6F/zMzlrhhhcdvRR0qhC6Q=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39860400002)(46966006)(36840700001)(4326008)(16526019)(8676002)(34020700004)(107886003)(36906005)(478600001)(186003)(7416002)(31696002)(7636003)(70206006)(82740400003)(356005)(316002)(31686004)(336012)(70586007)(2906002)(16576012)(54906003)(36756003)(8936002)(82310400003)(47076005)(86362001)(2616005)(426003)(53546011)(5660300002)(4744005)(110136005)(26005)(83380400001)(36860700001)(6666004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 23:25:11.1625
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6db0c0be-ec1b-41f6-0f64-08d8e99be91f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2635
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/13/2021 2:56 AM, Jason Gunthorpe wrote:
> There are no longer any users, so it can go away. Everything is using
> container_of now.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   Documentation/driver-api/vfio.rst            |  3 +--
>   drivers/vfio/fsl-mc/vfio_fsl_mc.c            |  5 +++--
>   drivers/vfio/mdev/vfio_mdev.c                |  2 +-
>   drivers/vfio/pci/vfio_pci.c                  |  2 +-
>   drivers/vfio/platform/vfio_platform_common.c |  2 +-
>   drivers/vfio/vfio.c                          | 12 +-----------
>   include/linux/vfio.h                         |  4 +---
>   7 files changed, 9 insertions(+), 21 deletions(-)


Looks good,

Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>

