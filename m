Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE0B33D296
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 12:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbhCPLQC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 07:16:02 -0400
Received: from mail-bn8nam11on2050.outbound.protection.outlook.com ([40.107.236.50]:64960
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237119AbhCPLPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 07:15:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NHYSaAw6F0ijcNdBcnOdGpezkRNbTPeLcyeRTXKfL3BE/O8/ZQM5EoUgiJ51GQcT9apr9mjX5XgeqBpdsxvYAHw0g278tN+Y7cwIUmemWT5rzmtdzSEID+rXyx1X8TNnJJXzXKZPghlMI8lKo0qlancPb0EIb3Q9UL9CB05w5095dGclD0vwGYUpXKCNdmZzfe+HJVb0Jg+s1phDq2ycoyCcUHzQjc5p0+KT4wJfgAjgzyMdG9GiBE3Wjx/ni84Ov00xsoVcDt1YOYVLnlqUnNzqRnIa5wG6/D08x5h3rOcqxzEUtrs47bb2LR/ZlCcB+5h25xklm5cJfHWcVk2AGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDzmDjjkN/v6D+CLmkbUUCB9Yv9n+T577Rz69KWppa8=;
 b=TnmQUlQn07YJdJvJWkTqKOng/KQ4tm7Hz2cQQJF+7b+Bslin6bj888+02f1SxH1JWdzlgB07w40o7KBN7T9vqzpu3lBmUA4lmWD5v35NhLH6AN4SbHb/BQf8Qj3hMcoIViW7UHoGVtOcdEHkfCzIzOS63uyorqS83M2y0D0XVp17cWBnHKwrppxjclx0sMnE3eHDmaNglAMeNVNViOrld36atVk8wLFywiLke7Kl7BcySxg0dDf5rRh6vEZVXpFDPfbMerHDx7Rr6n547YwZc3A/4p5Gw7R5VZdSW+E7kZf0KVkznUs3DtGWJdFv9p4Cveo5b5wY6iS6ZU4NVKN7Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDzmDjjkN/v6D+CLmkbUUCB9Yv9n+T577Rz69KWppa8=;
 b=MJ5vYnoCFiDIKjQK8OwTjDo4qo4mCOOkFKaArboW7CzB3oEK8fYnKShUBw5Q48xRWG+cw0du43nNFiqN+Lq5UmZYOebU/iIKd+rjVvx2ULK5YIIRkIp0g9h/u+xc2hY/v7p+mPjVK42eAxjdzU7FvvMkSgw4P9MEVoSg1v1hrxygwOAWS84SD1pOZcStIC61NW5U4g4g1Wr19cRC8KILIsHtjkTCCjmBMtwJqRs6w6WatUYPXVs0PYtQNBVbGptZX1K3Det0Ak5P9bvpA+9k/2OdS1R0QfRJMunXunow2AhjTJGnfqN4lB3u5AkHdTyEgPT6N99IvXnww5jWqujWug==
Received: from BN6PR1401CA0014.namprd14.prod.outlook.com
 (2603:10b6:405:4b::24) by DM6PR12MB4313.namprd12.prod.outlook.com
 (2603:10b6:5:21e::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 11:15:22 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4b:cafe::d) by BN6PR1401CA0014.outlook.office365.com
 (2603:10b6:405:4b::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Tue, 16 Mar 2021 11:15:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Tue, 16 Mar 2021 11:15:22 +0000
Received: from [172.27.13.197] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Mar
 2021 11:15:15 +0000
Subject: Re: [PATCH v2 01/14] vfio: Remove extra put/gets around
 vfio_device->group
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Christoph Hellwig" <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <1-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <fe63ac68-c5f2-1905-ca67-80b17d2b47d8@nvidia.com>
Date:   Tue, 16 Mar 2021 13:15:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65f5a6bf-edbd-4e44-28a9-08d8e86cca7f
X-MS-TrafficTypeDiagnostic: DM6PR12MB4313:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4313062DC90410CB69F874D8DE6B9@DM6PR12MB4313.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7wSVR8AcIMdjOQFjZXTzpk1WtnVyhJJiNT34Kt4mokHeeE1pPIx5G6r2qeVlZSpW0qi3gixb35qM3VDmFhMBkCMXRd6C7Zc6Y/00dy2zJRQzh874NxrYKATZ5UCmxz36KyKSY5EwElgmqnkgRPNbX2YuLloZyNNupHP2XGF+Bm6usRtkNWGbW+GNI+p5QawZpt1z5dc7mXdMVIndQUwEm7aIrD/th7gZ3Fj+7V73G6J8cf9sKrcrb7vziR4H/BhuXmRddO+TDjgtF4Cz2wCBrgEcv12x4FGtIro5b1YyQZZSJ2L8k2hlKrrzFjFYe1n7z1lxbH4FvC6Z3ToEgKnWDtCezn4wvg1icyJ2D+8kGIByUj9NlbFSCJsWqSjX8wTkwN/A1Gs8gZlSViZ23No9R8CUQuCE56TJ6xj8Nx3EM4y0W1F+ZlT5yFwV98JIePox4mjI1J6MJMsBzknqRzHA/5sHVMK+xgy7le8V8u8Ze5XMwV8QbMoYXQ8lIn6npmM9h1E/wEkFDVWkqEyZ3n/gg3KRDyz/jp93w05g/rDDmBMEXi1uJgu0h3ncu9UpXpTSEzDd2EQfieOTyccelxi1P3syNwToif9bC/9F/MNiFRIqwIsGNRV+UKU9vlU8hhPJqoVasky/PdWhaXZ5vk+7uO78zKPS6iwie7DQkhkT7cTRlA1MKJYru9CKD/Ajm3VpaZOo9QL2RQNZYL6vtnBqwRptLFwuRTgxR3RaK/jQKgE=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(136003)(346002)(36840700001)(46966006)(4326008)(5660300002)(54906003)(110136005)(316002)(83380400001)(86362001)(2906002)(16526019)(6666004)(107886003)(34020700004)(47076005)(186003)(31686004)(2616005)(16576012)(31696002)(336012)(70586007)(82740400003)(70206006)(426003)(36860700001)(356005)(8676002)(8936002)(82310400003)(53546011)(478600001)(26005)(7636003)(36756003)(36906005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 11:15:22.2759
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65f5a6bf-edbd-4e44-28a9-08d8e86cca7f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4313
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/13/2021 2:55 AM, Jason Gunthorpe wrote:
> The vfio_device->group value has a get obtained during
> vfio_add_group_dev() which gets moved from the stack to vfio_device->group
> in vfio_group_create_device().
>
> The reference remains until we reach the end of vfio_del_group_dev() when
> it is put back.
>
> Thus anything that already has a kref on the vfio_device is guaranteed a
> valid group pointer. Remove all the extra reference traffic.
>
> It is tricky to see, but the get at the start of vfio_del_group_dev() is
> actually pairing with the put hidden inside vfio_device_put() a few lines
> below.
>
> A later patch merges vfio_group_create_device() into vfio_add_group_dev()
> which makes the ownership and error flow on the create side easier to
> follow.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/vfio/vfio.c | 21 ++-------------------
>   1 file changed, 2 insertions(+), 19 deletions(-)

Looks good,

Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>


