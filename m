Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FABB34CBB2
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 10:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbhC2IvP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 04:51:15 -0400
Received: from mail-dm3nam07on2074.outbound.protection.outlook.com ([40.107.95.74]:12693
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231596AbhC2Iur (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Mar 2021 04:50:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FspYOasyER17DYKOqS5iKVaak+Ch+UVKxZCIaV8Xhu6cCXEC8bn6yr/Uz7RLpGIS1dl1cHm0pDinitHiXfioigNqSBjriQn/apw5xs8DJjOcwVcLnE3stt6CYpYLalAAsheUzTW9fIce9B1kQkUYPM5gzxJ5PKdfMqaSzsQdEJTfPCvqHSdmdn2+VPkOUNTUuXTleKhBSxJygzD6FtWM8hqPYiMT/i30aqsRMsP3KnBheSH36uYF+p0lybUH+Kr2Rr+K6FfPqzHODqQf4rcLRMBtgBuq6JuDWFEqCC5ncliN6vTfLYEZsiEbvwtGb1vO47xlvslIlhJnR46rqFodhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ZICGZbCttH1NIeMBd9EkPLd2BenznACgSMbLqpQ048=;
 b=fBBEHCJkgUBuwmxjnJZ49IWgB3qAa4Vy+JrujtavQOVIzwx9+mdE/RPoPwovOI75UmxiyqkY+EqPLmBCHP6QXKWlrim2Rbf3JZNp+Evy7uUS7vYi87Av9oHTk/wtwECRbNDnYoO4fVbmQp+m6TveFbps3SpVGZKsU3uul9pgs3SQpaPTtbNq6OWuIz2jPlQT4oYLAyGqBmjafK842UC+Mh+QThSWBNLr6eqaQ/bZNXejs4pvd6hb2E10R7KDl3RdJTNfZ4rdaqvSdvqID/H9SW361hM5QI+43+6Qv9WVyjXa/8PynIYDn72fEFSvm3nluVm5dZU0UbRt1xBj1sBb9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ZICGZbCttH1NIeMBd9EkPLd2BenznACgSMbLqpQ048=;
 b=tNxOMKt/7yRWhEwQU/19Hv9DAxThbgxopUnowCN5zaahz1gKaR22YqMBTqDJv1XOk9w9RH8vZ5g5h5UmdDKpOIEK4kWRjaDs1ohw8fgQD5h988HFt4upObgAHROSDoSCnkFBo9JCJ08CY7pI2cNUiVwWDsoPcrDKA0TVYOtEnMhh236HkvgnFXit6rBTME3xo7mK4l3oO3DL8YcelSlRoBqENLf2xyTC8/KLavLpOd6pRt+i4Jih3M6R6lWB92+ynvV1vm1CZTovw+2utBAERG9MGHRcvuXYn29KXxuMxz1kvRIeALb5huBz7JZvqWVVve1WqJGqEGDQ4unMDot11w==
Received: from MWHPR1401CA0015.namprd14.prod.outlook.com
 (2603:10b6:301:4b::25) by MWHPR1201MB2527.namprd12.prod.outlook.com
 (2603:10b6:300:df::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Mon, 29 Mar
 2021 08:50:45 +0000
Received: from CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4b:cafe::6b) by MWHPR1401CA0015.outlook.office365.com
 (2603:10b6:301:4b::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend
 Transport; Mon, 29 Mar 2021 08:50:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT067.mail.protection.outlook.com (10.13.174.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 29 Mar 2021 08:50:45 +0000
Received: from [172.27.15.73] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Mar
 2021 08:50:41 +0000
Subject: Re: [PATCH 09/18] vfio/mdev: Add missing error handling to
 dev_set_name()
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
References: <9-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <9f2c8ad9-1366-5308-677a-c9727537663b@nvidia.com>
Date:   Mon, 29 Mar 2021 11:50:39 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <9-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25261077-3356-4714-6570-08d8f28fbe12
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2527:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB25277AAFC116C55DF29C4FE3DE7E9@MWHPR1201MB2527.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eGoCrCrEncQFEZQzp4LHotgiMvvJPvI2YtNnVYZIX4FelMisT3zM81s8GADxYHaBG8QoU6ZlyABTpHIlbzL7ACuSAoukvPVr9T3SPTeT4sALa1nUrZAds1qBJlK0Gu92bRDTbE7EdNSReHAVS2t22DMN3wVFEguWRD43rknC71uLCL4g5dM7cbYwAYMI/YBjV/thvPl5C6/ByjUhgZjhgdugapGz1fD2Po2PEHPolYeb9ulev7zihqQZkwOPhJR380/BTxZQdZZNCDWfahWYRPypy5j9/rJen/9ceufHdRsbyMmANNDMK9gOi5uAi5HIpgf0O2URzwzfC8loSSgXegMdVZs9nuwAnzwQvgZNRbVNr03ev8mAP1Lc/ewRI0HJKzVgxRgef6N0VYEoazGYEFxZ2HHjF/ymJAaL8aDd7KpuYfE1gTr8GZXaSdZBevBDRzqLCSsqw0q/Gj31/TVETojCOVPY6sPx3vhnowey199h8WCNH1aOeoVpsBGD8IpMLSNy974hGmiuQK6CmJBZQG581VRT9CUx5u5shnw5hN6pzN1pbz0iYEbUas3pZ5rBAmYfrV7GPkOAy38aREnsYLkI5u6eR+B/+ESPrc4W837JOEm2DKmpDwkEb9e+lnXJaP3SDW5sDMlm07SFjmoNxC8yb/y2bUoTZtH1fmMcICrLsDd6FqwYyhZtsQ3JN41m
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(346002)(396003)(36840700001)(46966006)(8676002)(426003)(336012)(53546011)(356005)(31686004)(36756003)(4744005)(8936002)(2906002)(7636003)(2616005)(26005)(31696002)(16526019)(82740400003)(186003)(316002)(54906003)(70586007)(86362001)(70206006)(16576012)(82310400003)(36860700001)(83380400001)(4326008)(36906005)(478600001)(47076005)(110136005)(107886003)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 08:50:45.4857
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25261077-3356-4714-6570-08d8f28fbe12
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2527
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/23/2021 7:55 PM, Jason Gunthorpe wrote:
> This can fail, and seems to be a popular target for syzkaller error
> injection. Check the error return and unwind with put_device().
>
> Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/vfio/mdev/mdev_core.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)

Looks good,

Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>

