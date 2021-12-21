Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B1547BC6B
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 10:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236026AbhLUJFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 04:05:52 -0500
Received: from mail-sn1anam02on2089.outbound.protection.outlook.com ([40.107.96.89]:58830
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229728AbhLUJFv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 04:05:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kUxjtwrrnw0FbyWQtNMTIxs4N+6SLbAr4kHZ5YIv2cmdjHg/j0Hmw47e+3fsbGY90k8EZpqtyQ5L6DrukCwkDeUHv6xviqDD8KSp6VkmIepbFyoS1fNMx9hDzKuxGBGkLQmzHqYJc6BOyFAEfWQMO6OOzR89KH8/LO/mi3IQdsHte658TX/sQ2ryR6faEpwfAcH3GdJVfJ751t25Srz21gzcAhWfPLsEoMk4dtN1np4ssL05GooXEJaF0xgj4Tq2NnVll230KZZ0eZ5ABhQfanYfKMrdhiNo0q9vTHQafT3BXn8pBImxx2q346IKrD11iTgI4i1gaacBt28McTBUDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=caYdKyXX/58EqY2W9ytSuiyScnXCSqGf9dxryFyCxjA=;
 b=TxyjXbhApmejV5Do8xATVLsr6sMdeSjgeSWfmu6h8OBHZMLI/3iyWgxzTt9tdHB7rj1OFCb76s1L6HB6HBJ6SWPhHQNUGFHbNigDOdAkd2/3p5Cx37/F2KH37M7JHGmnwpq4Htg8wKE59LYvZiNk8XY1o58uVBN/v+siBxiY/KNzt8ZbkiI/TW+Myii2l8arCd8R3WdnCQomgajzR1TwKM2iTJbuWx/b/KsiE0fmq78v2ySmWimGSHScin0fakFfsNgSwThChn8dZRsmPP/l6UGQxDy5tLov7pgQkM5Xn6nfvCAjVlUKL2R0VeaM+g5HcupVRD0Q3dm2Oh2GxX2Z0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=caYdKyXX/58EqY2W9ytSuiyScnXCSqGf9dxryFyCxjA=;
 b=J8a4UAToFfEIFUUXBJlFYg+XtmMjRhB10DITS/Ls8ykbgvaJcynoE5i4gEVnQZT0NksFo0oML6Hyu9IYTJfrGNecBeQQz+uAi462A9WBtOU4QAcTFHjgmYu5jCB+poNpM/DfyhSYkAVWyNES2TtbbyuuHc3RSY9v7NXUTv6bR4LS+q/hS2kd8cABTIv9RSLWXH+IoISJ5H63LTiLQLfYKdoM96hlYhowx0DpSpzxw3aCeh6E+9Q8FCxH1F+04zWi/eE/R2vHd3bBI2kk1WncghnqwI1Rk0S4nIBYvKbebeyJixgrNtCL+5ctPx365hZAbM1Ri4KcpgMcLxJWam+RyQ==
Received: from MW4PR03CA0256.namprd03.prod.outlook.com (2603:10b6:303:b4::21)
 by CY4PR12MB1366.namprd12.prod.outlook.com (2603:10b6:903:40::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 21 Dec
 2021 09:05:48 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b4:cafe::ac) by MW4PR03CA0256.outlook.office365.com
 (2603:10b6:303:b4::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14 via Frontend
 Transport; Tue, 21 Dec 2021 09:05:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Tue, 21 Dec 2021 09:05:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Dec
 2021 09:05:47 +0000
Received: from foundations-user-AS-2114GT-DNR-C1-NC24B.nvidia.com
 (172.20.187.5) by rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.986.9; Tue, 21 Dec 2021 01:05:47 -0800
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <wanpengli@tencent.com>, <vkuznets@redhat.com>, <mst@redhat.com>,
        <somduttar@nvidia.com>, <kechenl@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v2 0/3] KVM: x86: add per-vCPU exits disable capability
Date:   Tue, 21 Dec 2021 01:04:46 -0800
Message-ID: <20211221090449.15337-1-kechenl@nvidia.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e7d732c-77ab-406e-45a0-08d9c46114bc
X-MS-TrafficTypeDiagnostic: CY4PR12MB1366:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1366A614C82A4FD478B02ED4CA7C9@CY4PR12MB1366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1AMUToHACduJ+LD30qYwioHnKHPUZVuuZYhV60Qz1lVH8/Jg61AIZ2xJkUTGCGJDY+gKU7FDi/qZpUeqyE83pan62qLZGgWdihhZ4LuDUoiyy5U8u2WL5CakrFmwJ7k45KO7D7+U3NQfp/PlQknePt8ZIXq/N6iECGldpgE0//G4oeCOLUvU8TDTF7krT8gDSvh7v89q92/0Ka1mWEpE50t+1+CvfzwvL5wbfVWYZzv8sktpdEA8c+E9GnkcUd5wQKVdVbLjoZGptW6SO/tUnd30TMccm2ERrSjDv7w32kledyKO6bGAMciancfhwcS3Vlkj8X0iBi1716CY20R4hHO8JHrs5ZVl5j5Xy1s5lElvA33PsN+7Qk7hk47VbHXfh5jXHexke0oUjO//vmyPS42J8+AHeAkHn4EZbCHElPay9JexM+YEK6uu16fiHgWw+ulboxkv2kw+N2TZrhK5moNrm5AuQGH6wh5Mg/8Nq5uypp61tWvSe30fBsDNz/4zn6k24rhrHixyaBk+VSLGoc9I3aKBft35J28mjXrLbbEtXjEgjieYbs82c8/Pqj4S7l7ADGVhh3MmAlYxoR5dRg6Ud1AoYvkFdxFIXV8b+GbJO4+SAeZ6RYTddFUOU11Gzl3K35ZHH1iMw+oh8P2eezFlgKaTI640/f3UXzJQDaET+MsWjlz28yd8W/OFW/mAwy/QC4265HTc/tig3UPhi6CcST+yc3ueu/tlS1k5sVt5yYl144j+0lyFlNNCf2fnNigWK6OW338hdyXE0ZrghLGPP3BsyO26mW1bBgaoXeU51Bh4Axh/b1CsvkTFVymHGaSwgqhr/rxskq+M1xZb5w==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700002)(36860700001)(16526019)(70586007)(186003)(26005)(316002)(336012)(70206006)(4326008)(8676002)(83380400001)(82310400004)(54906003)(356005)(110136005)(1076003)(8936002)(40460700001)(86362001)(7696005)(508600001)(81166007)(426003)(5660300002)(47076005)(34020700004)(2906002)(36756003)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 09:05:48.7296
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e7d732c-77ab-406e-45a0-08d9c46114bc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1366
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Summary
===========
Introduce support of vCPU-scoped ioctl with KVM_CAP_X86_DISABLE_EXITS
cap for disabling exits to enable finer-grained VM exits disabling
on per vCPU scales instead of whole guest. This patch series enabled
the vCPU-scoped exits control on HLT VM-exits.

Motivation
============
In use cases like Windows guest running heavy CPU-bound
workloads, disabling HLT VM-exits could mitigate host sched ctx switch
overhead. Simply HLT disabling on all vCPUs could bring
performance benefits, but if no pCPUs reserved for host threads, could
happened to the forced preemption as host does not know the time to do
the schedule for other host threads want to run. With this patch, we
could only disable part of vCPUs HLT exits for one guest, this still
keeps performance benefits, and also shows resiliency to host stressing
workload running at the same time.

Performance and Testing
=========================
In the host stressing workload experiment with Windows guest heavy
CPU-bound workloads, it shows good resiliency and having the ~3%
performance improvement. E.g. Passmark running in a Windows guest
with this patch disabling HLT exits on only half of vCPUs still
showing 2.4% higher main score v/s baseline.

Tested everything on AMD machines.


v1->v2 (Sean Christopherson) :
- Add explicit restriction for VM-scoped exits disabling to be called
  before vCPUs creation (patch 1)
- Use vCPU ioctl instead of 64bit vCPU bitmask (patch 3), and make exits
  disable flags check purely for vCPU instead of VM (patch 2)


Best Regards,
Kechen

Kechen Lu (3):
  KVM: x86: only allow exits disable before vCPUs created
  KVM: x86: move ()_in_guest checking to vCPU scope
  KVM: x86: add vCPU ioctl for HLT exits disable capability

 Documentation/virt/kvm/api.rst     |  4 +++-
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  7 +++++++
 arch/x86/kvm/cpuid.c               |  2 +-
 arch/x86/kvm/lapic.c               |  2 +-
 arch/x86/kvm/svm/svm.c             | 20 +++++++++++++++-----
 arch/x86/kvm/vmx/vmx.c             | 26 ++++++++++++++++++--------
 arch/x86/kvm/x86.c                 | 24 +++++++++++++++++++++++-
 arch/x86/kvm/x86.h                 | 16 ++++++++--------
 9 files changed, 77 insertions(+), 25 deletions(-)

-- 
2.30.2

