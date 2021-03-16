Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC77533D305
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 12:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbhCPL25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 07:28:57 -0400
Received: from mail-eopbgr700083.outbound.protection.outlook.com ([40.107.70.83]:35521
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229901AbhCPL2j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 07:28:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mg9hgDlSsLGO44pAKvT+rkLijreV/En7uvsp2h/HaKdlhZ1Ana/3A3EVZjccyNFUbQbc4Zi6Js4TpP4y06+PeX2iOicCIvPmDIjR36Yy8LnCgLtCfx7MJ+SmSP02HiXm8bR5gkC1LGh8SsSfmjDX8jtk+qAsT1kunpv4Jhf4T+LMVDK8Cq+RvDtNM8ElyqfNZlBTfuIIKMIgQT6ojcXdMBB7mYsa9yMpFu7Q06kpmeGce+h+H6LhX6mCFLgrjSVLJeC2hbuHLqa7EL04U4Yy2zsfWFqPRuE39eAdh3tCA454dF2WvbQw5HwOpC31ehwyIgNaM4lhWPLgrlY3CyBgfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ql0U6OCPYIFFZK2TAdj+skiAq8NncehHL6/JYhv1VV0=;
 b=j8sHD3GhOkjkN+BUen5b71rzAl4VCp2VIexiyvOB+/XeFb37Oe3msg8Yb0mAeMJOZK1hSgKyt6iPUR5wgkibbwoJwGrWvlBTPlf9M0Oj1nkSBQeXDEOzG7pi3qIH2X/a9HhjHd0TTIG2ndIdUAijPYxSu2X4sGmH0Ox3nk3w1QnwW4UkhFiaiaNgfoOBPEJouWBdhfJhqgIowzl2YKRKNmmZlVjsf000Xj+N6mdbM9rqvzSL+NIw8+cBWr2sPoajlYC62omIsP8xbPzJ73FllZ/8PQ5m9rxbVx+VLCJDxZXqn4n/9E2P4MAr7k5BcXVHIi8qkNK0i8RXZ1ZGHq4YvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=canonical.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ql0U6OCPYIFFZK2TAdj+skiAq8NncehHL6/JYhv1VV0=;
 b=d1nJnEWAW1DnI/Vo+y72HmTUxTTFNISAMO6BRTsOhMxnfk1Iz4rXTOzBGhTYFcuXpqD1R8fQT/5gfNtgYaXnz77WnPOCJ6zGLEBVnd/5DbRMpoDZdDD0YxgIYFX/N2QqdqLCONAjk5/bqHEUhyZab/UrOnbYzv42cqhu7rPpJIvWT7nRYh9LyXYPvnx7Sl3b6iPs28MwkBvvNCIrrgaPWnG329wQxROpztZyWLGiUuYyIAZG++Ga89kSqyqsc17Fe7kIQubtEJ+1fWVrrkwAfBzHS3QI2Sx6emIY1Tq/auX5nwJm4JRgLbKwfSRUuEj5lCEw1jHHiwYYI+SARXGr1Q==
Received: from BN0PR04CA0117.namprd04.prod.outlook.com (2603:10b6:408:ec::32)
 by BN6PR1201MB0035.namprd12.prod.outlook.com (2603:10b6:405:4d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 11:28:31 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::4) by BN0PR04CA0117.outlook.office365.com
 (2603:10b6:408:ec::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Tue, 16 Mar 2021 11:28:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Tue, 16 Mar 2021 11:28:31 +0000
Received: from [172.27.13.197] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Mar
 2021 11:28:26 +0000
Subject: Re: [PATCH v2 08/14] vfio/pci: Re-order vfio_pci_probe()
To:     Jason Gunthorpe <jgg@nvidia.com>, <kvm@vger.kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        "Leon Romanovsky" <leonro@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <8-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <48f9b1e7-9d31-a8a0-2b0e-44408559172b@nvidia.com>
Date:   Tue, 16 Mar 2021 13:28:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <8-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b3566a7-867a-46aa-07e6-08d8e86ea0cd
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0035:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB00356AD46A27A6598CB51850DE6B9@BN6PR1201MB0035.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kCO/Uf1xG0+OGKXpI7SQysVUnr4WWt+ZJGtWIxrco3WEaOB4VBFLxFD1mqVKA8gnpZKxz9v+Ux+C60ihxmgenJwHBPYx2oH7z1opAaRz6F4oqn5PT/gUugAOVtNORq1QmKmJujuc/9B9eezlm7CKvxWu8CkSOY8cPXuxhW67KmajBfUffQ4AziqtPO2VAxlbND87XN3zrw65JCOG5PwooFRqDmdIy0pJstfwaXMRtoqSiwoXgYdm65AxEUzJK+5cG7mlLYSIS4G4v4XVihf7zBKp4bQPvFTWJ3frJgVD0hS3dEaI4prbGc0ShayPcDbdhuFuDBYmZB6G8RZwzXatYZjnVz8DPEPTG3+gCr7gY6RFIW1nzsfk4PaSX6Bv5Fy5PhHBdr2uw86T2ZqSrOvYYF9JfGAqVNeuzr93yfWdaaGNBYSzBV88HV+1SHt6sDGhEngktPzYbbFW3+btDycoLFlLsfBGQixT6cOOg86Pdd3+o9nacmVp+NtaROCyie6Qetz3/p/RU+IRNEov9VkS3BDYZC9nQkC/3KPbWZXyYcGk9k74yoK1rA5w2dLSthuggDkhuK0D0ttURX9y61EGeUymfnIK9GVaFZru9blUtbXOJW2LET9bAWmmEKlFlit0yF4+Q/SAC0GC7iwl3/UiEJDJyN2F4ePr1YBc5c5sq4ezikNQhZThwDB7742TIoCiKF/s+wrv4VBVMobvw0LquW5QQiJyfswHgQxvlrNZS9FYwOmZV5Xjy/S6UTeHZP4D
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(376002)(346002)(46966006)(36840700001)(34020700004)(2906002)(6666004)(8936002)(47076005)(36860700001)(7416002)(82310400003)(478600001)(70206006)(110136005)(16576012)(4744005)(36906005)(8676002)(316002)(53546011)(26005)(70586007)(5660300002)(4326008)(336012)(186003)(86362001)(31696002)(426003)(107886003)(356005)(7636003)(54906003)(16526019)(82740400003)(36756003)(31686004)(83380400001)(2616005)(169823001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 11:28:31.3194
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b3566a7-867a-46aa-07e6-08d8e86ea0cd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0035
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/13/2021 2:56 AM, Jason Gunthorpe wrote:
> vfio_add_group_dev() must be called only after all of the private data in
> vdev is fully setup and ready, otherwise there could be races with user
> space instantiating a device file descriptor and starting to call ops.
>
> For instance vfio_pci_reflck_attach() sets vdev->reflck and
> vfio_pci_open(), called by fops open, unconditionally derefs it, which
> will crash if things get out of order.
>
> Fixes: cc20d7999000 ("vfio/pci: Introduce VF token")
> Fixes: e309df5b0c9e ("vfio/pci: Parallelize device open and release")
> Fixes: 6eb7018705de ("vfio-pci: Move idle devices to D3hot power state")
> Fixes: ecaa1f6a0154 ("vfio-pci: Add VGA arbiter client")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/vfio/pci/vfio_pci.c | 17 +++++++++--------
>   1 file changed, 9 insertions(+), 8 deletions(-)

Looks good,

Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>


