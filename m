Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B137A4505A4
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 14:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhKONkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 08:40:01 -0500
Received: from mail-bn1nam07on2075.outbound.protection.outlook.com ([40.107.212.75]:33188
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230501AbhKONjp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 08:39:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=joAdTXqOETrQ3Z4m5FHlCp5jYP2Bj3YCcPSyl1KAnIBbXl6fwGKe3ROX0q575WwggSW2ZFP+CJ82ETY8kTVRqyXfw1O1cbvR/Lb/GARujvBdyBgWNUvUEh+yWO1KEnhCTMYs+/VqgnWQqRCbQS1R81SPGfTUFi4m9Yc504TxNgu+rczbh7s+RvqpWbdk+6Hk21bZ5Pv8dyFgc9sq1x3BnTmI2JnUdxlvFOGKfaTCIbVFbQK1QQUuHMIovPohLk4NIhYTwVKlC7McchuPTcPqJ+x6hyjgl/pW+UWNjdFKdPPpc1ndwFkdrWRqs3LsPfIL/KDYSzpSt24GfdTq1pDMfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NOVJu/Vs0SpJMmoL6t8mU26zbLNVpi4koACjvyhMBiQ=;
 b=JtDUexbrzhfkqR6b1bK0MFJEbF6am7NhG0rU0SmCtCNs12LdZvKXYshqUFNdO8aZ2F5Bdbln4SHaubjeUJMg4PqDF8N7s5Kq3a61D483Wt0IHDQq4i0nu1oYQ0OFbXtVYR7RudgXHjMUWLk0/wb+uPMzXRey7uU4rg7YCbeyArSvKeEd+AojqB+zLSwy7zaQLYQEaAiC9fawi5kvVy5maTBIoDh/n0Y9giUPT5oOgoZrmAW6P0CWcTcjlCJJlw4qIHA6o1WQDSb8BMk6UaLTQ4t+bOrNDrPkwj1GTfxBNSWkrtHqNuBNXpNUYjrkC40jyXqtWJyDweEO0myiiXDJNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOVJu/Vs0SpJMmoL6t8mU26zbLNVpi4koACjvyhMBiQ=;
 b=LEa7KawOcFFZgaTMnliyw/UWgCsDeY68vFAeAMxN9yvB37VmTpelqGHU1VK5pJnvBzZVk2epJgYEQ7bICejBF+5NPMFFEPzmgk5kWmxMbDZpHAYAiPutgCUK3i41AvJ7E9qks9cTmBeKc4pigGfGPw8eSLtL/DmAD8bD6f4218Sc5cbd5o70hu01ZsoL9cYXlyuTJRD2Khe6fj7Y4+a9C1cjb3LLiJYJWNKRFm2wXzLC0gZLTDccE7BJ7iMhFKtshaj6EAUCTrnvzEk9rB5pOXMdFskdnpJsTWR/07udQidfhUP/juw+9KEk4BolV25NkHEEFCe90UK6sF3vCzfqww==
Received: from MW2PR2101CA0011.namprd21.prod.outlook.com (2603:10b6:302:1::24)
 by CH2PR12MB4182.namprd12.prod.outlook.com (2603:10b6:610:ae::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Mon, 15 Nov
 2021 13:36:48 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::80) by MW2PR2101CA0011.outlook.office365.com
 (2603:10b6:302:1::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.5 via Frontend
 Transport; Mon, 15 Nov 2021 13:36:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Mon, 15 Nov 2021 13:36:47 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 15 Nov
 2021 13:36:47 +0000
Received: from nvidia-Inspiron-15-7510.nvidia.com (172.20.187.5) by
 mail.nvidia.com (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Mon, 15 Nov 2021 13:36:43 +0000
From:   <abhsahu@nvidia.com>
To:     <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Abhishek Sahu <abhsahu@nvidia.com>
Subject: [RFC 0/3] vfio/pci: Enable runtime power management support
Date:   Mon, 15 Nov 2021 19:06:37 +0530
Message-ID: <20211115133640.2231-1-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53dffb52-9d69-43d6-2baa-08d9a83cf922
X-MS-TrafficTypeDiagnostic: CH2PR12MB4182:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4182180A683825F7F2793B10CC989@CH2PR12MB4182.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /f9tMX5Y9BZJMtYsWSZ7xjgpow+ojHP/IRtZpP4cB7U/7G7k2Y0GaQUyk8fl/LT9PMpUhjJe/gCMPZXGtfpXutuuGIIykHdVxIdxppavSzvYzv5FtySJhj3mXDPJfP77Hgw4/QJ3EOD6hM3ENQdPu7zeKgpHRkRP59temfkmQczOw4xsXYbkZi81c1ZYJMSe+VrEcwf0sXP9ydBz7rN+TcAw1p3e+TxfRbsIcxryRT0UwKI1Z7mE1osE8NPdaTY6GZKVy5iBop70mFsmrZu79Od2pbWMgs3JbILXa/7ZmG+xw+CuVE6XyybxU55Oo4hh6uEgyXBeESOpNA3d9vmt27qpNXzmePZgaoFvvc+742hiy5dPMLpBWU3waaUcPaaWNa615vaPjgcMsJAsiAmqV3V0NTbD12GCc4JIolAjoJubZKKbkjnfZ3kDrCVZp39ARmv9y5x3nSnGJnmhb/NNq/5JW4yMrDKIOaEv/yA8FJPIzKmk81BlJQAF77+1q4Wa65kaN/t8PVrITM60k69uJUbOSwMYAVr+Eouz6NKHll2xIfgFnXEUWV1hfWfyWQz6KgmM0qp1pOAwBGkLSzkQ/mU+xcZ6h1FYsxKPRMPt9tKvZK8a8aeu9zh4LsCLtTJzJYm8c6k6bAC4ic2+W4uzHtc4RBWJ0o1i6mOpakbf2fIdDM7Nd2MQjtJa6pme84SFe4pNgVyTJJxmuP5odrpr/Q==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(82310400003)(508600001)(70586007)(356005)(107886003)(7696005)(7636003)(8676002)(86362001)(47076005)(36756003)(70206006)(8936002)(36906005)(336012)(316002)(110136005)(2876002)(4326008)(1076003)(5660300002)(6666004)(2906002)(186003)(54906003)(2616005)(36860700001)(83380400001)(426003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 13:36:47.9836
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53dffb52-9d69-43d6-2baa-08d9a83cf922
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4182
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Abhishek Sahu <abhsahu@nvidia.com>

Currently, there is very limited power management support available
in the upstream vfio-pci driver. If there is no user of vfio-pci device,
then it will be moved into D3Hot state. Similarly, if we enable the
runtime power management for vfio-pci device in the guest OS, then the
device is being runtime suspended (for linux guest OS) and the PCI
device will be put into D3hot state (in function
vfio_pm_config_write()). If the D3cold state can be used instead of
D3hot, then it will help in saving maximum power. The D3cold state can't
be possible with native PCI PM. It requires interaction with platform
firmware which is system-specific. To go into low power states
(including D3cold), the runtime PM framework can be used which
internally interacts with PCI and platform firmware and puts the device
into the lowest possible D-States. This patch series registers the
vfio-pci driver with runtime PM framework and uses the same for moving
the physical PCI device to go into the low power state.

The current PM support was added with commit 6eb7018705de ("vfio-pci:
Move idle devices to D3hot power state") where following point was
mentioned regarding D3cold state.

 "It's tempting to try to use D3cold, but we have no reason to inhibit
  hotplug of idle devices and we might get into a loop of having the
  device disappear before we have a chance to try to use it."

With the runtime PM, if the user want to prevent going into D3cold then
/sys/bus/pci/devices/.../d3cold_allowed can be set to 0 for the
devices where the above functionality is required instead of
disallowing the D3cold state for all the cases.

Abhishek Sahu (3):
  vfio/pci: register vfio-pci driver with runtime PM framework
  vfio/pci: virtualize PME related registers bits and initialize to zero
  vfio/pci: use runtime PM for vfio-device into low power state

 drivers/vfio/pci/vfio_pci.c        |   3 +
 drivers/vfio/pci/vfio_pci_config.c | 210 ++++++++++++++++++++++++++---
 drivers/vfio/pci/vfio_pci_core.c   | 166 ++++++++++++-----------
 include/linux/vfio_pci_core.h      |   7 +-
 4 files changed, 288 insertions(+), 98 deletions(-)

-- 
2.17.1

