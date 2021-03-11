Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AA3337213
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 13:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbhCKMJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 07:09:44 -0500
Received: from mail-dm6nam11on2088.outbound.protection.outlook.com ([40.107.223.88]:41212
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232757AbhCKMJh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 07:09:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIGw+CL//NbxrxvY25viMBlrskjlXjIVuN28PNfE717eoB0pBcWMfGrHEFdPPiRnyKwunuAjAQujmK1iXJJnUCAsei0qyQ6OyKVzVA8xSnPa6DDsiCEoL8mLMFPtPY0OCFeUukdqy7B9jaNPJmvPCDMWmy9qSIUQaSJiNUSiJWdPTx3uDXJ1o0aVJmGk66u3k+oAFxdsmUKH4UO1UjyadkT88nat08LfD6xDdJQ0OR46rUohA+vdcXR9STjeTcj1dZjgz76RfeM6BKTnKedmMCdhOdKy31kcgF+O/6RtbcYG01cnKoiG7WvaMsuvDavXWn5rb6DRCI0R180xl01q+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aNsocgBo3jkBZT8Woo1IHFwETIluN6/9sMG5KVGHk6c=;
 b=gq1ewo+bOj4eG7VrOMmGMApdLoe3CV4enwoFsHIIT8ptLQqYSdCtG1gHwzHJWWA9ESJ1h21Q0N6d5uXVLOGjVUc2HDT3OP7NfnUuGipa9CRyR+4ILslpX9bPRk331B2iMMGUmK1Er32A0dWwudo6LsZmGDjlxMScH7rkB7OLvvlMpyHGOz0VTiG2tnZIPrRNLub1eGdVh4vdH3yoLTKXVAmfxPg8hHQq8kwJEjtLKuCdL8eYZFWUKRzKO4tQd+dG+UCK9BSdIlX3RPa/k9pi3mTiWr+E69oZeL9zbYVrhFtl+r0bFIk/K7QlUMslddooUkQyIOAJw8KbaGmHfcxEug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aNsocgBo3jkBZT8Woo1IHFwETIluN6/9sMG5KVGHk6c=;
 b=Njx6EIugPaCANpyfZVMTZFVSYMF5shiLwddTPzKBscPyKk5+g8BxpggLTBfK/YFgc8NXxLYej6/zZQo/Z9qhzG/D1tZ9+NW/iwel1ktLXhifb4aIpIiNKdd+EcO4T24UHeywFA6mELcQu3hNctR10TmXR2CM9kx1GlY1D6OPI2ayQSjOwYZSxcvtBwkHMoTFP6hu22MoL7DabBnMFtpIlTLtTKHplGJleqhyn0hmEd6YAh2YTDUGsmTlQATQiRSGnVLQn5bf6suPrYXKN/QHsYUtnGLgFSUG7ks00hxlKdaIw8KW51DwfWCAMOsGI97bdkatU2nMll8J4EiKgc4jyw==
Received: from MWHPR18CA0049.namprd18.prod.outlook.com (2603:10b6:300:39::11)
 by DM6PR12MB3340.namprd12.prod.outlook.com (2603:10b6:5:3d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.29; Thu, 11 Mar
 2021 12:09:35 +0000
Received: from CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:39:cafe::c0) by MWHPR18CA0049.outlook.office365.com
 (2603:10b6:300:39::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 12:09:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT052.mail.protection.outlook.com (10.13.174.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 12:09:34 +0000
Received: from [172.27.11.33] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 12:09:28 +0000
Subject: Re: [PATCH 9/9] vfio/pci: export igd support into vendor vfio_pci
 driver
To:     Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>
CC:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <mjrosato@linux.ibm.com>, <aik@ozlabs.ru>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
 <20210309083357.65467-10-mgurtovoy@nvidia.com> <20210310081508.GB4364@lst.de>
 <20210310123127.GT2356281@nvidia.com> <20210311113706.GC17183@lst.de>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <8dbe2c19-10f8-16e3-56ec-8026de84acc5@nvidia.com>
Date:   Thu, 11 Mar 2021 14:09:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210311113706.GC17183@lst.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db64f0f8-b1dd-47db-3fc3-08d8e4868924
X-MS-TrafficTypeDiagnostic: DM6PR12MB3340:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3340F12A768619768BB93FADDE909@DM6PR12MB3340.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t/lv864Yr/gk5QiyflQnTInhHowtkF9PUPe6+63z9rIHX6HgxXuJixKlCCfZ9iDtfkdw7r9YjLXurc+ZuWzwm+p3MHyWC3Hm77OdXaaRJIClKB9ir4FmCrRbwZx9Va039vo9EsvqwwYvmetB7BLJH+6hrhli+317a6yMjlNvEzvOr3K01CHZC7HVJYOVCWT2h7UCV9uZitiTuP0PrjXvZEqP90+HrB2TLD0/g/MuPO6S0WVe/vLMj+n3TI4hE5F+keEvtetuaXa2LHPNMo2jGlL40pouYUZ49tam8TGdcVoT+4hg5Zeu6VJ5AAZQ1ATj5XWq2NYBRY3N4/ew5Cn6KHOiQl31cQGToTsRV4+b2RcLmUu6fuSpcHoKpXxHtUzGYg2Lsn7QtKQewqaoFvVYXSCiDx53eTq3oKWPdEtc1rQ1psIajAzKSeuIm/zon/p8nfAeTge0mC8eVJ4U/4+opdZFPGTDBImur1VZtRRgnmuGcM9RcnXIRdwTLDP0Ic7qqFptxJpfvP25FsGTFUEtMafap2WZO1rdpCQM6C7fWvykYXHAQ/azX0OsuSQErD84/B9ZC/GYJwavd0SQEMhflUnPGn+E/tKdfuHI2Z6RzcZ9jJk8XgsCueuYNgqWVzRknsMsVA9wd7t1BR9zu7plu0XL4E4IvZNyMGO+QKvrfRs3TKqjxNr7dYaDbURloHOYhy90MD/ZF+FlSF+PwsR1iNipFmbHll3AiYCmdJuZ46w=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(346002)(136003)(36840700001)(46966006)(6666004)(82310400003)(478600001)(26005)(4326008)(426003)(36860700001)(31686004)(47076005)(2616005)(110136005)(70206006)(8936002)(6636002)(70586007)(54906003)(16526019)(82740400003)(53546011)(7636003)(5660300002)(336012)(356005)(36906005)(186003)(316002)(8676002)(2906002)(16576012)(34070700002)(36756003)(31696002)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 12:09:34.9380
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db64f0f8-b1dd-47db-3fc3-08d8e4868924
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3340
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/11/2021 1:37 PM, Christoph Hellwig wrote:
> On Wed, Mar 10, 2021 at 08:31:27AM -0400, Jason Gunthorpe wrote:
>> Yes, that needs more refactoring. I'm viewing this series as a
>> "statement of intent" and once we commit to doing this we can go
>> through the bigger effort to split up vfio_pci_core and tidy its API.
>>
>> Obviously this is a big project, given the past comments I don't want
>> to send more effort here until we see a community consensus emerge
>> that this is what we want to do. If we build a sub-driver instead the
>> work is all in the trash bin.
> So my viewpoint here is that this work doesn't seem very useful for
> the existing subdrivers given how much compat pain there is.  It
> defintively is the right way to go for a new driver.

This bring us back to the first series that introduced mlx5_vfio_pci 
driver without the igd, nvlink2 drivers.

if we leave the subdrivers/extensions in vfio_pci_core it won't be 
logically right.

If we put it in vfio_pci we'll need to maintain it and extend it if new 
functionality or bugs will be reported.

if we create a new drivers for these devices, we'll use the compat layer 
and hopefully after few years these users will be using only 
my_driver_vfio_pci and we'll be able to remove the compat layer (that is 
not so big).

We tried almost all the options and now we need to progress and agree on 
the design.

Effort is big and I wish we won't continue with experiments without a 
clear view of what exactly should be done.

So we need a plan how Jason's series and my series can live together and 
how can we start merging it gradually.


