Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB6637070A
	for <lists+kvm@lfdr.de>; Sat,  1 May 2021 13:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhEALhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 May 2021 07:37:06 -0400
Received: from mail-bn7nam10on2040.outbound.protection.outlook.com ([40.107.92.40]:39177
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231882AbhEALhF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 May 2021 07:37:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zy4fgBhTiyM8tX10pLAKZOHZxyD2sPgTY+DbVecOKYH6BRmGaxGBhxrIyr8YYEeNoeO8QDz/c4S7JKp8W+cSibXinjSMsmULDg6HNfJ6Ix0rEyxqhkvuv5nFkwbdINqmAimHLIVXjHN5KpmbJe13RmSN6aB26d5k3AmSDWkV0ces2/mFPakAPPQQdLmePIGr4mfPA1TTZAYQSHsp+0U2rdUuwZHUBgf21GDlsv4hJTIW9c04XrBFdENEFQ3lg7O2xzIq4lxIoSqt0fR/xJDiZXGULq0vwJ/glxWzciZcP+wHGnJSbhyuhs30Nb3AQaZDdgvsU+JVnxcxhPX83Lskng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lv38/X3wWd/GIGKZLH5hS3g6xqgeipf7rz8Chh2bFsI=;
 b=fUW0ujfZN83n8D4uOx3t/GQu2qigWfbQNktcTdgkDR6orp5n9qmidY/i9Y4fWw5Na/s64JI7H8obNpnrpdyKhHNxVQLfWBLgDHAYHiUMSalFFAtyH2LTjVH4BsmJuFIner4qnhn3Xdx0XSoeY7kQGWDQIkrX88Qf5JHtAOGtlohigKn90hdh8YdI1CrcDTrUJiKCmre3pMDCD+a4QPrNk/Iqs8TEniraB6+yYxv/ObJpj2j6BULcXVH03WWdv80KfczS2wrqP+P5BCN5Eh1dK/1kYC+LbKasKL0Z6PGNvcCpnBYxBvBpL6Ci0tP4PVVDLe40qAOtQbqD0sBh3QKvDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lv38/X3wWd/GIGKZLH5hS3g6xqgeipf7rz8Chh2bFsI=;
 b=Q/PP6kweCb+pTFafKUIyXmqfPGKOEAfQ6yDY4bIXh14nQKrbvLT61AfRdAtufY9hrUaIIe5i0R78sIB1qQx9uX3yB6v9Zx9dCI0ICTfwI5LN8y9k6zw5vBthJ9elOrz4e9PTdkobgS+3s3a9MXuNCWf33SiNOIZKcgqywEdNlYgmuYnjK4+dqfk6Z+tW3cLs5ZWHIBG5UXH8rRKh8qXGJFh4LOaEdvLLnkeoFUywyIJg6l+y3NHoyijlUzqhWcLnI1bVx+dgsXWPJjTUwk1ZK53mI1zebQr8Fg0JzMrxvNb3vDLPrlyOlQHuktuVhexJJGE2zGim4erUuGv9YzCVtw==
Received: from DM6PR17CA0024.namprd17.prod.outlook.com (2603:10b6:5:1b3::37)
 by BN9PR12MB5081.namprd12.prod.outlook.com (2603:10b6:408:132::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Sat, 1 May
 2021 11:36:14 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::c1) by DM6PR17CA0024.outlook.office365.com
 (2603:10b6:5:1b3::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend
 Transport; Sat, 1 May 2021 11:36:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4087.27 via Frontend Transport; Sat, 1 May 2021 11:36:14 +0000
Received: from [10.20.22.163] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 1 May
 2021 11:36:12 +0000
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
To:     Marc Zyngier <maz@kernel.org>, Vikram Sethi <vsethi@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Christoffer Dall" <christoffer.dall@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Sequeira <jsequeira@nvidia.com>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
 <20210429162906.32742-2-sdonthineni@nvidia.com>
 <20210429122840.4f98f78e@redhat.com>
 <470360a7-0242-9ae5-816f-13608f957bf6@nvidia.com>
 <20210429134659.321a5c3c@redhat.com>
 <e3d7fda8-5263-211c-3686-f699765ab715@nvidia.com>
 <87czucngdc.wl-maz@kernel.org>
 <1edb2c4e-23f0-5730-245b-fc6d289951e1@nvidia.com>
 <878s4zokll.wl-maz@kernel.org>
 <BL0PR12MB2532CC436EBF626966B15994BD5E9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <87eeeqvm1d.wl-maz@kernel.org>
From:   Shanker R Donthineni <sdonthineni@nvidia.com>
Message-ID: <49e26646-9f05-ccb8-f5c1-73a92ab79972@nvidia.com>
Date:   Sat, 1 May 2021 06:36:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87eeeqvm1d.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 712ee9e5-5449-4892-24a4-08d90c9553e4
X-MS-TrafficTypeDiagnostic: BN9PR12MB5081:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5081D28D71C931021D68265FC75D9@BN9PR12MB5081.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: poI786eFL5JMORuNzCT77SLGX81kcU7ufo05fySGtUrfTro7w9gOfISkDkRIHSwq/mZ8SUQiL7FaL7n2UclrzuHEq1bslR7V672DqLvNKdc/RdFMtCY0nQfxWWoTvbrqdnw+a92cS4mGebFB2HgJREdiKz2MNV5bbDPMdWHCpDGhIOfsl1xABBD5i4X+MrSKfRg8yHJAvk2/VZfwva5LULMoB4L/XPpo+rGILAXjrKrrQlV00YCKLDZtZ4TqYXHK8Y/7NSw69vY6dijXT6s2QKussIX8//62B7e/NTgg7phaZiSJWgmNz+9Hlw01/bPdVtzC3XlYeTMnVv29CB/TFj/ug+8wVSYWuQeCFYOFYMEci7+2J3gl85bV9G3iKNse9Ngh2aRUEUonpX8V9oIBn+P7NaCQsyasBjWsZxSW/EuD96nyAvBTjr34wAjmcgztj8eZFO6ISNQj3sz9fTiEvwPwYKjHeLOICEW3NGip6Alo8nI3FXJyK5peVv1yGMp7PfDv9tKgKwm4Rkvoi0FkDuC513FED7hOoYIAhytN2TBulvGz+xCwbWy6w9EgN4Wowj9c7uH72AVMExcz9jfRfJSmKXl69X7bErTjvpckDnwojPqDGAkaUSjdZYLuSD1pOjx+wZdMq/VvyNuYmOjOOi3s3MaylUUdeyQNzCHvU0FBxbKWlLz9uYsGbfqmOJod0Ib2gVk0PzugJKbehOWN8w==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(346002)(396003)(46966006)(36840700001)(53546011)(70206006)(426003)(478600001)(36906005)(7636003)(86362001)(83380400001)(356005)(4326008)(2906002)(8676002)(70586007)(82310400003)(47076005)(31686004)(36860700001)(82740400003)(8936002)(336012)(36756003)(316002)(107886003)(2616005)(16526019)(6636002)(54906003)(16576012)(110136005)(26005)(186003)(5660300002)(31696002)(21314003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2021 11:36:14.5647
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 712ee9e5-5449-4892-24a4-08d90c9553e4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 5/1/21 4:30 AM, Marc Zyngier wrote:
>> I think Device GRE has some practical problems.
>> 1. A lot of userspace code which is used to getting write combined
>> mappings to GPU memory from kernel drivers does memcpy/memset on it
>> which can insert ldp/stp which can crash on Device Memory Type. From
>> a quick search I didn't find a memcpy_io or memset_io in
>> glibc. Perhaps there are some other functions available, but a lot
>> of userspace applications that work on x86 and ARM baremetal won't
>> work on ARM VMs without such changes. Changes to all of userspace
>> may not always be practical, specially if linking to binaries
> This seems to go against what Alex was hinting at earlier, which is
> that unaligned accesses were not expected on prefetchable regions, and
> Shanker latter confirming that it was an actual bug. Where do we stand
> here?
>
We agreed to call it a driver bug if it's not following Linux write-combining
API ioremap_wc() semantics. So far I didn't find whether unaligned accesses
allowed or not for WC regions explicitly in Linux documentation. Page faults
due to driver unaligned accesses in kernel space will be under driver control,
we'll fix it.

Driver uses the architecture agnostic functions that are available in the Linux
kernel and expecting the same behavior in VM vs Baremetal. We would like
to keep the driver implementation is architecture-independent as much as
possible and support VM unaware. For ARM64, VM's ioremap_wc() definition
doesn't match baremetal.

We don't have any control over the userspace applications/drivers/libraries as
Vikram saying. Another example GCC memset() function uses 'DC ZVA' which
triggers an alignment fault if the actual memory type is device_xxx.



