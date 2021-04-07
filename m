Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3EF356ED9
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 16:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353035AbhDGOfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 10:35:48 -0400
Received: from mail-mw2nam10on2060.outbound.protection.outlook.com ([40.107.94.60]:60033
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353027AbhDGOfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 10:35:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I+hhqIAY0RCQcO/mbvgHJzxFu3Wlv/9bi4lHoUvVn+1h8c4GJ41Xtg69f9ntNYQ1cwN8cEHHHPbKBxp08k4Be0EjD9Yig6HZyfg+wONmRFWbEyVwJ8Y5U6ktUnoNp2ixhLTsRdz17tyfzUIZZSjs7nW+4xQCjWVJl9SKmpusBZMtU1wFNVEczcsQ1zhbZCwv/4FdNbdh2tSARYEgq3QZziNeSikzxisAB5VYp9X6AZBtmZfh3fPRsQHa+yO2R7egtbkc2RcaIF8blZSr8GhhIHIEHZJhbGK9hI6BC/b0hYebT2JkuQWSeEl+DcQerNn8NnRWNIuYz57SzxW852K3kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lfuS9SMozW6paXLgj30CByHXSbsAyghtdi8oT2kLZyI=;
 b=VNMl/18iG8TFVHjKyMkospy/P/XeupEXpdQ78MBY0yovl8tdRwLZH02DB4j8mkX2ek9Xg++EheEajVFY767jN0yrG0yWz7AXw6gndo10KX1EQGiNwiLMKxtEZ92ddYf+SFKGDDZ1CfEVKB0NCbjrIB1HQd6pYasrLbwp1Ug/hdYU5jlEKDl9so1KnyN6w/8aONKWbym0WAjN/7sGI0le/vtMrls7r3UWHxba3d3oGRWxx1FCHZuxI7WSvzduVWo6oAxd5fdh/eKjckwT2hfp7AbLEXVRgarZn2YFm3fjB4w/yCI1GWNeydd+A1o39XAokuhw97OuOAybwrvREstQ3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lfuS9SMozW6paXLgj30CByHXSbsAyghtdi8oT2kLZyI=;
 b=Foh2yeTebtGin/ZLs7iFgI+6vTWyYuBuU9kyt2J6n6QCArsbB1vGU0Sri3Bf88UxXCLefGK8Ebhl6V+ZGMdxuPS/gcvDIjyc4C/Zb6MrMKk0QyBDTTlDeCFwcp+NT4bngy2MlcP3Z1BUWbyPNx8/jOsnLVJVKfXlxtTSYu4DqWr87gZWcNNYoZjT49IDkFUtNGYXlKoVV4dJ2rTdIqYoTRtRY0Yqbvs4iMWM1kRXQMHN6cHmWwypP93zCpLirOKd61RiVkFRooJ3/J8DTPLlxxg6VsTg/J0fHrpD8lRsCnt5S5VyyXt+IHIWlbBlRggr4vVpq73TomdqfCEmkmXOrw==
Received: from BN6PR1401CA0007.namprd14.prod.outlook.com
 (2603:10b6:405:4b::17) by DM8PR12MB5399.namprd12.prod.outlook.com
 (2603:10b6:8:34::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Wed, 7 Apr
 2021 14:35:36 +0000
Received: from BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4b:cafe::83) by BN6PR1401CA0007.outlook.office365.com
 (2603:10b6:405:4b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Wed, 7 Apr 2021 14:35:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT061.mail.protection.outlook.com (10.13.177.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 14:35:35 +0000
Received: from [172.27.11.15] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 14:35:33 +0000
Subject: Re: [PATCH 1/3] virtio: update reset callback to return status
To:     Cornelia Huck <cohuck@redhat.com>
CC:     <mst@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>,
        <oren@nvidia.com>, <nitzanc@nvidia.com>
References: <20210407120924.133294-1-mgurtovoy@nvidia.com>
 <20210407154444.04d6304b.cohuck@redhat.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <8be467dc-8920-05d0-4d6d-9c61fe721120@nvidia.com>
Date:   Wed, 7 Apr 2021 17:35:29 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210407154444.04d6304b.cohuck@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d3370e8-a43a-4cdb-52ac-08d8f9d26852
X-MS-TrafficTypeDiagnostic: DM8PR12MB5399:
X-Microsoft-Antispam-PRVS: <DM8PR12MB5399E9B3B0C5CE4E868115E7DE759@DM8PR12MB5399.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EHyXb2R/Rysv8XSJcOmALWGvIuZYrytIIqCKpPJ0MJX1r5zg6vgXaNn32oNyg/OA+tAvT0gz0SICQ3gyVFzgoJWxw78e6yOt9MPszQeJxsH5pqrr/yKKZhsVVlWd4xG6wOh9pUsr1SSorS0p+YPiU37uz612X6OtW5IUr29e0ok+ww4NxFxLekqk1XC4bXtNlnSehHSabw6LwNxRBLSMD0pXaidCV3sKbcDaSm/p+i0dbtcpYhwxxpSSmYu/SogDy990xtX/Rj1TDi6VnpZgOyiRMMb2XERKa+zkqGPchxzEKBlHMSfBn+K9+XCaMPso7MRDnjPxWm5koAH3FXPMp70FKjT8csuINY7FCIQiCEdcEIqrx+Cuz8+2yC2RoH2edkh6h/qDI3mxadGkBsWANAMj5BU6v416BN6utHuXf84TAZkaE3VwvXPMxQb3D2+ipp0P/J2siMGSLK7w5JzdQfWJY7RaxZrdX35srguK5z8iCf1bOKf+gnykk0dEGbZ3P3+0QXmmmgQFGHxuCVHbCjkQmrtn4TLhnoJzks7jnA5HPJjDyjEY+3guni8ZcV5WJTWcp/DbrZJIElLT+4QYR4+U9ubmfIVSov+78dMr+x6jmaralWq7oHVN+SZXnd6f4hwKT8U/R6vk6OkOKrsua9ldc+F+LLwRkXtZie0KsQ1WE8oHdo2dtoJyaXr/Mdx+
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39860400002)(396003)(46966006)(36840700001)(54906003)(15650500001)(426003)(4326008)(2906002)(186003)(16526019)(316002)(2616005)(36906005)(82310400003)(478600001)(83380400001)(86362001)(16576012)(356005)(7636003)(31696002)(82740400003)(107886003)(26005)(336012)(36860700001)(70586007)(6666004)(8936002)(47076005)(36756003)(31686004)(8676002)(53546011)(5660300002)(70206006)(6916009)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 14:35:35.9830
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d3370e8-a43a-4cdb-52ac-08d8f9d26852
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5399
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/7/2021 4:44 PM, Cornelia Huck wrote:
> On Wed, 7 Apr 2021 12:09:22 +0000
> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
>
>> The reset device operation, usually is an operation that might fail from
>> various reasons. For example, the controller might be in a bad state and
>> can't answer to any request. Usually, the paravirt SW based virtio
>> devices always succeed in reset operation but this is not the case for
>> HW based virtio devices.
>>
>> This commit is also a preparation for adding a timeout mechanism for
>> resetting virtio devices.
>>
>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>> ---
>>   drivers/remoteproc/remoteproc_virtio.c |  3 ++-
>>   drivers/virtio/virtio.c                | 22 +++++++++++++++-------
>>   drivers/virtio/virtio_mmio.c           |  3 ++-
>>   drivers/virtio/virtio_pci_legacy.c     |  3 ++-
>>   drivers/virtio/virtio_pci_modern.c     |  3 ++-
>>   drivers/virtio/virtio_vdpa.c           |  3 ++-
>>   include/linux/virtio_config.h          |  5 +++--
>>   7 files changed, 28 insertions(+), 14 deletions(-)
> You missed drivers/s390/virtio/virtio_ccw.c.
>
> virtio_ccw_reset() should probably return -ENOMEM on allocation failure
> and forward the return code of ccw_io_helper().

thanks, I found another 1-2 places that I missed. I'll update in v2.

