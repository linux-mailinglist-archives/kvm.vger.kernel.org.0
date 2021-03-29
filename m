Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C9C34CB1B
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 10:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbhC2InT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 04:43:19 -0400
Received: from mail-dm6nam10on2067.outbound.protection.outlook.com ([40.107.93.67]:15687
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235085AbhC2ImQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Mar 2021 04:42:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oi7K5u7lrb94aufqCu+QrRzSLyyaVAQQ8xFjqABpj1UZQuCDtMCAIHrG/LvoBQf6UG9WqeOgD7hPDiiAr9yNYWXklwg9hseWIVYHkWblGqnrCKRmMXJhGjWmeTLRurlQjvYTVartrwhustCdSMWW/Dvycggkp8/1opXubno/5Aw84qek/mq5S5C9gvlPLDQ1olhfQ3NfsYbfR8lxSFHReyXWDNcrKpjW/R1lcGGW5JkrjXmGfUbGYwL/WXb37GfwGrbAleF+hAk4JSka0eoaz1YMaI3rLI/WQ6mA7IazD2lpGrmuNvMcVirCotZlAH1qdW1RqiVveQunoiOWeWJexQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B7+FX24AYYzrLbuFO7i0N0uUs+vX1u2qdAFtJT34yqQ=;
 b=d4A4vMVymGRCijyEJq5tJAMs3e11hk+PGhjZkqEGre8Mu9DFo0bZegn2TJg0/MgQ9p5LHI0HZzd61WotJ1vD4P6gI1PkEAuOU/yVdCk+N/hp+g6u6aLmRybk267BVuYJ1nQcCTp2TpyQy5GAaMPLAiuZ1RpSbnZLM1YWcclN4qxEb18lCHcBf4iztQnAKZ3ZoDrpisQ00+rG5UwSjhtBH0nsy2aifOCb/GUoSJnQ4L2iV+1GKksAtcqVhvtickGSkKeQBVSg+ZyXlt735s0ePjzH9NOq65GhpLHQDKpsRX1Ek2nQOVM690No4SH7qCBkLbkw91ZHxACR2GlUVNOyVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B7+FX24AYYzrLbuFO7i0N0uUs+vX1u2qdAFtJT34yqQ=;
 b=KKCFR+eGXQpQXIX729IWPon3hv9Chq3ltHycJKgwLLENE8M+SnTW70tbSyirhkswQ4PNdEjpLybdEwsx7dHXEuVDM9ynl7yRXAoyT5pzX4TJD+iRugOlfMbgWjIeK06c+awzijpFyvLPfSHy1sOTz71ayI0KwaBKTRhCCbRYhW7MJtcrqy+EDn+kPknWrQaMp3pk8+vP4/7mhkl7mKUbAUsBMeMSVNLqCUXcALABN+johdKzC4JAse2fWoCmG6uCpi26iWJpyMZhUf7CXrYrWKb6Wk6w5DjQREMoM6V4WDPPkVVuhJzl3Oqy1xua0FJYAx7dOf+QQ/d1d0VyicO2JA==
Received: from MWHPR01CA0046.prod.exchangelabs.com (2603:10b6:300:101::32) by
 BN6PR12MB1156.namprd12.prod.outlook.com (2603:10b6:404:1f::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.25; Mon, 29 Mar 2021 08:42:14 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:101:cafe::a7) by MWHPR01CA0046.outlook.office365.com
 (2603:10b6:300:101::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend
 Transport; Mon, 29 Mar 2021 08:42:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 29 Mar 2021 08:42:13 +0000
Received: from [172.27.15.73] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Mar
 2021 08:42:09 +0000
Subject: Re: [PATCH 05/18] vfio/mdev: Do not allow a mdev_type to have a NULL
 parent pointer
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dong Jia Shi <bjsdjshi@linux.vnet.ibm.com>,
        Neo Jia <cjia@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <5-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <caebee40-0a26-ca2c-9888-7dc107c3c626@nvidia.com>
Date:   Mon, 29 Mar 2021 11:42:02 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <5-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfb57694-65a1-4e0c-a80a-08d8f28e8cf4
X-MS-TrafficTypeDiagnostic: BN6PR12MB1156:
X-Microsoft-Antispam-PRVS: <BN6PR12MB11568AB2556F370F5B03C288DE7E9@BN6PR12MB1156.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 67051l7HFxnTMwjyfy7JrDOckEnKKmHcx9rY6QIRmLiWGrCPITvdUdMWc7xUSkfBORS1ICngYc5OGOoaixTGG9/L6LrjNOHw5Zr5FEu3FutCGqqsidsC15GuR4pJKhkDG/8SPRh7tEtIYjLTUROi6GYtFjMq3aUDGKA//xWaBmIMtrJJWgGOFa/neLhvrY3rr8s5+T7br4JHrEgX3Tnmsb/iXU5PqYe+ydCokuNbbdyyDFsu7L781DsxzUy6gNH560SS8LUc16GDIc3sQ7QPafdIKLNbMGMZ1Q5dfhzk4Zv74BwFHr7k94654n8+GDSMt38NqxdPI0f1FHhp5muUY0xi420+6ZHuowKf/LT7fdRjfImTu7/oKxv7WdoZrmVdo/pfx0ijaOmpqoZQD2sHVDIDGbAqn+6admSGTaO56Bw3ETEcRw9gfHMCSNhKvh9CA8avlrR9Imy40cKiA7QG2Me4xhhKz9qnxpGzV0atVx3pih7jpPFxyQK2IR9Ep6iJYDZZ27v1XvppqUJToxoEVoMRemhy3ve0iJWKqxbH+H2Ezq+z+KbpDyDspBV2Kmp6ebANGaZZ3w/2FV/jTOQTlkN+TVvSPPC6DPFewYBmw2AKMkx+xjrx46KZrjW9CpyJCs8N5SNgoTuKwSOU0yueZpFNzE9ksrQx2d2Il0tVrp+Rrt5nsiCGaPaSzUVhp657
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(376002)(346002)(46966006)(36840700001)(6666004)(478600001)(356005)(2616005)(26005)(4744005)(70206006)(54906003)(5660300002)(31686004)(70586007)(16576012)(53546011)(82310400003)(110136005)(186003)(8676002)(107886003)(7636003)(82740400003)(4326008)(36906005)(36860700001)(86362001)(16526019)(36756003)(47076005)(31696002)(8936002)(2906002)(336012)(316002)(426003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 08:42:13.6087
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cfb57694-65a1-4e0c-a80a-08d8f28e8cf4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1156
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/23/2021 7:55 PM, Jason Gunthorpe wrote:
> There is a small race where the parent is NULL even though the kobj has
> already been made visible in sysfs.
>
> For instance the attribute_group is made visible in sysfs_create_files()
> and the mdev_type_attr_show() does:
>
>      ret = attr->show(kobj, type->parent->dev, buf);
>
> Which will crash on NULL parent. Move the parent setup to before the type
> pointer leaves the stack frame.
>
> Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---

Looks good,

Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>

