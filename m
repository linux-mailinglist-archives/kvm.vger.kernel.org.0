Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75202435639
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 00:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhJTXBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 19:01:22 -0400
Received: from mail-mw2nam12on2060.outbound.protection.outlook.com ([40.107.244.60]:21504
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229842AbhJTXBW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 19:01:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eHAiUohTSEaEhmjzDqb5n71XoH1quwwpFZ+jRM3sGmlCrkiqZoNm4zB3T/1lij+oe3oM0urnv2yVR5NSB9FVFWVd+DgaL79J1cYHmjftwxT9kMgJRnz4vgsYbmglbEGc1y5b0TymuJ7bWChBz82GGiihGw0s+kpKs/mmLL2UbwYwKJlk9hlhvkdbmnnyjBYAfZu5tp+ARqyVjXfa8R0KnJ/j3T7Dyh5FVRio8Cg9t5VegICxikfDpmRDWY7H6JzfL0mp1T7KZ5dN6kYW1uOa06vH9cZlTfjKYL1wHSp+QMwwJzwlE6McBFabB1pZ6PW9dEQbVuhVA0tW6X0xy+fz9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j+VucUUc6QyYgXDe1gLQiAAn2bMcBp5yBVb5NIEOnDs=;
 b=jDUTBaKs4I+W4OmVJo9H8VyCTzmKWLTr06QKc8w1Vn1C9SeGMgp0jyZQugD9j63lUHoDTQH2zDMOssZU3byo/bBnkUqeLjXhsijgZc64wWlBwxchbUeH9slRDL1Nmes5ZUO5iEc6LyHHGHFi0G1rms/wJT7hYm5ZVfBmX80MUFKlJVJp7DmDRZVLTkVNoQuvLakfvDYJsSoGsgvyInd4rqbyLuHX4VhdytvppbAcRU0opVLSgv5l/qRthxhVzIW5geISD64zmXaGxVrxeu/cZHGK+gyRoRqGwjRYYWtzigpp+tYejXprQ2h4/fb1S+Y0wkzngBDLTtSRZTQLyFkxTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j+VucUUc6QyYgXDe1gLQiAAn2bMcBp5yBVb5NIEOnDs=;
 b=ZqmOgBrEvW3jS+beeRdKoHrCgYmKA76B31MBgFT5m36nD+1rzCwH+I6W4WJqjYRo97KZlhH7VPi9xHbunadhLAi5WBk/uHv/IO9jYGmxnkq/KwrVx/ydEfcGFHva93OGxyI4FlVhET4CJ5sj4mn4xbFhf3/tglabkXPj3cLBKKs=
Received: from MWHPR20CA0036.namprd20.prod.outlook.com (2603:10b6:300:ed::22)
 by DM5PR12MB1641.namprd12.prod.outlook.com (2603:10b6:4:10::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Wed, 20 Oct
 2021 22:59:04 +0000
Received: from CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ed:cafe::33) by MWHPR20CA0036.outlook.office365.com
 (2603:10b6:300:ed::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend
 Transport; Wed, 20 Oct 2021 22:59:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT024.mail.protection.outlook.com (10.13.174.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 22:59:01 +0000
Received: from ashkalra_ubuntu_server.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 20 Oct 2021 17:59:00 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
CC:     <brijesh.singh@amd.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <marcorr@google.com>, <masa.koz@kozuka.jp>, <pgonda@google.com>,
        <thomas.lendacky@amd.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>
Subject: [PATCH 2/2] KVM: SEV: Flush cache on non-coherent systems before RECEIVE_UPDATE_DATA
Date:   Wed, 20 Oct 2021 22:58:48 +0000
Message-ID: <20210914210951.2994260-3-seanjc@google.com> (raw)
X-Mailer: git-send-email 2.17.1
References: <20210914210951.2994260-3-seanjc@google.com>
In-Reply-To: <20210914210951.2994260-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49f63be8-9b5f-487c-75a0-08d9941d350f
X-MS-TrafficTypeDiagnostic: DM5PR12MB1641:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1641B74E35F32EAF4DEDEE238EBE9@DM5PR12MB1641.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Q517ttm8mjJGeGqC5XbCwYvuuRTQ6M77Jru3ZTFi7qQ0iURpCS04w4lljGiDaCTK6sT+kAEzihbcR5uRcOqFFLPO9NruR85WTiOcifugBnATgmnQDx6BrL1elcGiTCKYxKCBHj9k77o0vOMu5lwqIPu/yU3REKAZ4pYQ/1p3n49kyY5blz7Q2bwSAuEJWi3LFTtLdBZu/RcOQP6Uphp5sPbEuq+cNzXbu0M43K236kxgWkqIm9v2D74VQPW+IM5pmwD/5c4K8bgTHikEuhR8ZLheqMcgBXAWtdN1XFQ+kv5O8IhYHAju5hHrOs7USpCEVIwshWiFZqb+b5GiMA+w54PXDnWtw8o8fTwBaXXe349pXWZXol7YSQW81bQ6ivIoVqcvKexkATIBjZRzdKvNScUyZtlMxxV/B+NPgPaCdazOXfJJ6MBrnhpRXmVeXudbq/HJeDwgPLUppge8Av8caerul0/XzB5HeHZHRpBcCHh83ZzD/fGRA4qDrJ1k9S2Q7XYx4uCO4N3ILKD4EUQKR8/wHp+0EsXlEQQwB/i8CyGZdES9gnjTY3wCSjm2NCq/G3TIF8EO7JWO+eS0xom0swN2YGNXy1pWVLKGTJwSBMJ9bmQhFgDf5OPhZ4wZUgviLz4lMCHcxk9zrK980j26Lejkx2ndnS2i+A8euejurGjQTh/1CHqapwag4v5+Cuwm993vINkEwDATXURVkHRMR++2xbqk9D9Xs1I1PPGwaI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(83380400001)(186003)(6666004)(7416002)(16526019)(54906003)(55446002)(8936002)(86362001)(110136005)(4326008)(508600001)(36860700001)(9686003)(426003)(1076003)(336012)(82310400003)(356005)(316002)(26005)(61793004)(70206006)(47076005)(5660300002)(81166007)(70586007)(2906002)(8676002)(4744005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 22:59:01.3224
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49f63be8-9b5f-487c-75a0-08d9941d350f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1641
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Hello Paolo,

I am adding a SEV migration test as part of the KVM SEV selftests.

And while testing SEV migration with this selftest, i observed
cache coherency issues causing migration test failures, so really
need this patch to be added.

Tested-by: Ashish Kalra <ashish.kalra@amd.com>
