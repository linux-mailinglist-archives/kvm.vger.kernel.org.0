Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F51E36FB2C
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 15:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbhD3NIq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 09:08:46 -0400
Received: from mail-dm3nam07on2074.outbound.protection.outlook.com ([40.107.95.74]:54881
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230175AbhD3NIp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 09:08:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXK+FmM2ZX6k3NB2AEHW9Kh17xib5tql71SHyZpn+57lfXxsWaKnI8wLK5MW7gpMcYJ09bInbQ1tKKd4m8EhRv3o2LQmSOUAVJf1HRz/RvmdoD+5eubSj0ENMQyZeiUToPBal/ZhPbznqIHE1gd9mrS6mCUd+mduOdmNaFZ8AMw5wJuSOX0WsqwmKOA2ySWLtPhefQ9kVRHNlPltkyRa8xLpvUt7EK9a/w//PdBlcwxOkSw8mjTi5CXkcabZQvCoGJpTmX1ofvVGzIJ77hAuQcIgYre0lFrWrqn9Zoadqzfnw4OAiN3smeDzezmzDCAFT+uPVGkjcuir004VMqxCCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N45C3fQWgq4PdzETiiO8AMHaHdrUdTbdssx+Z8ha4SU=;
 b=B/ERNy+1RR4TDFmphgrUu5lQgQnRpaBHN+5Rx0AmCHsZF0vbk0Y7V0+v/TPLXie7AMq04/P0YOu18tG+SIQ1qHGdUUWb1fPBfu9hpo+E58hRkHJV00k366clECebnQl1ypTmFZ3mZc5GllchqNuGl4kkKYjOeuVwfIskJpQPBn7gQ/6lWfcMwChtD3tEnwpSol9sfJd9m+/2dEA/LheYjuLkOaDtfaxnBzILTDemhJQ7QCX6wCUJadExyCi/4ysgpe+LHmdNGLa+gYaiqsChFHBAUFnXlbJTzj2lhZ1TsmQ6guxF6B1KGtgZUqa514bJk+bzUDkk6aM2eMI+SPSVEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N45C3fQWgq4PdzETiiO8AMHaHdrUdTbdssx+Z8ha4SU=;
 b=Yip8m5R/NtelZJZYKP2J5GSK7vj4GbjPnDF9pa5xi7nQPxpsxy+us9OzCbmZHSNNdI5hYGsAs722W9RTiHST8ga8AOIH/TyK7OTUeBz2sVuqCML0wpLc8awj/rutLK4rpmq/6c494AcRXdGO7FQIkhr7kTl4L+PgEhzlDFsmPAbQptppE5L7cY9+QGpfGysKm8Ga8O4Gd5N3V867A3GKvg6k5d0mPPz0kmbcOKwPDlKUG6eXI2pAQ85Kqx2sU+3WDUdcVjiPuMd//vvcDTzQaisZdVloK+tWepTRcqRujGUrPKqCfrBd1OYrTtCCAG2veIemWFlO/dRMxVkO/wIm9w==
Received: from MW4PR03CA0271.namprd03.prod.outlook.com (2603:10b6:303:b5::6)
 by BN8PR12MB4980.namprd12.prod.outlook.com (2603:10b6:408:a8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 30 Apr
 2021 13:07:56 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::a5) by MW4PR03CA0271.outlook.office365.com
 (2603:10b6:303:b5::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend
 Transport; Fri, 30 Apr 2021 13:07:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 13:07:56 +0000
Received: from [10.20.22.163] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 30 Apr
 2021 13:07:54 +0000
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
To:     Marc Zyngier <maz@kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Christoffer Dall" <christoffer.dall@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, Vikram Sethi <vsethi@nvidia.com>,
        Jason Sequeira <jsequeira@nvidia.com>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
 <20210429162906.32742-2-sdonthineni@nvidia.com>
 <20210429122840.4f98f78e@redhat.com>
 <470360a7-0242-9ae5-816f-13608f957bf6@nvidia.com>
 <20210429134659.321a5c3c@redhat.com>
 <e3d7fda8-5263-211c-3686-f699765ab715@nvidia.com>
 <87czucngdc.wl-maz@kernel.org>
From:   Shanker R Donthineni <sdonthineni@nvidia.com>
Message-ID: <7c685ae6-938b-9d99-20e6-f51398543441@nvidia.com>
Date:   Fri, 30 Apr 2021 08:07:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87czucngdc.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cedf8ce0-3549-4e80-a7a9-08d90bd8f8a9
X-MS-TrafficTypeDiagnostic: BN8PR12MB4980:
X-Microsoft-Antispam-PRVS: <BN8PR12MB4980AE8C4896B9BF7ECBDC9AC75E9@BN8PR12MB4980.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0lr9O+EacWTBS3lD3mD71yituUzeFW1t3qrgJWSGqeIpY4itLvDC/8YCmLX5VZoSVMCdpxz26By1K+sni41lK28zhF0G6C0N51a5jfftsXHelS0cAQgXklvYu2RgoLhFQDpsEWf2m6flX8yTcQQYaZcae+9PAgj/uRR2CTuFgH0HnuLFU2XHWx2Uh9YFL07/1bY0Z6Fn3er6trM+ByCbFIBfyID8UJ41e5INU9azpzYDV/N89hNdOeKnpVApEb6v7y4qaOrjZb/CcJv4ml83GBTMvMzqkvVpTWKauV0VIxLg/4/zIMm+VZX/bEQkD2cpWR6//sYiP8QTMBcDIrsJZsVeNg+DbacVgKTtGnq9eh8Hj7779d5E8QhxkXHoX+/+vS0k5qQE0cR8ssSMimEfRd9LlzsalCDFYw79rUAiGHiz2aKv1iDPpQeUHUEDiwKCxFuP9VPEG1OaQvqGnNL1LGMPJD2paU35WpzQ7AGmcOKpQy8DYdM+k6Yq17PCI5dVcIs0F3K6D/+8EO3s5sdT8lBJou3wJGrA903Cvr16cXQIKxZcmPYN2X0FZHIXe/ns2vmftHcxSTVE9A29glMJ6ShcAKsPkSutjkWld1vXCZVOMUQjzcvn9rkLkcnXOjQuFrCiYUvIMhNaTV5AkuYraIv+PN8RbRiNf6NY/2/6WGyIXyCLi8J92Oaa5OeJSXE0
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(36840700001)(46966006)(70206006)(5660300002)(26005)(186003)(6666004)(7636003)(4326008)(36756003)(83380400001)(8936002)(82740400003)(8676002)(2616005)(16526019)(70586007)(426003)(356005)(82310400003)(107886003)(336012)(47076005)(86362001)(6916009)(36860700001)(316002)(54906003)(31696002)(478600001)(2906002)(16576012)(36906005)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 13:07:56.1305
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cedf8ce0-3549-4e80-a7a9-08d90bd8f8a9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB4980
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Marc,

On 4/30/21 6:47 AM, Marc Zyngi
>>>> We've two concerns here:
>>>>    - Performance impacts for pass-through devices.
>>>>    - The definition of ioremap_wc() function doesn't match the host
>>>> kernel on ARM64
>>> Performance I can understand, but I think you're also using it to mask
>>> a driver bug which should be resolved first.  Thank
>> We’ve already instrumented the driver code and found the code path
>> for the unaligned accesses. We’ll fix this issue if it’s not
>> following WC semantics.
>>
>> Fixing the performance concern will be under KVM stage-2 page-table
>> control. We're looking for a guidance/solution for updating stage-2
>> PTE based on PCI-BAR attribute.
> Before we start discussing the *how*, I'd like to clearly understand
> what *arm64* memory attributes you are relying on. We already have
> established that the unaligned access was a bug, which was the biggest
> argument in favour of NORMAL_NC. What are the other requirements?
>
We are  relying  on NORMAL_NC mapping for PCI prefetchable BARs instead of DEVICE_nGnRE in baremetal and VM.
No other requirement other than this.

-Shanker

