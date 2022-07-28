Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37899584067
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 15:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiG1Nxt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 09:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiG1Nxs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 09:53:48 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2055.outbound.protection.outlook.com [40.107.100.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12498EE30;
        Thu, 28 Jul 2022 06:53:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D7JgjdVOw0OWKJmtw2NRoFQ22Zr0iV9VuyeSQTKxvknPIZ5T7COL+goBBLc6R98Y9wDo07EaQvNZDwZCy/wagwSuSHqXV6js6NLC2rUhN7qE2X/HmeC/1F1ekRZGh2sovzbXLdF+wcCbZiP0cCTAqzMcFAdN4An3EgPm746HQHKvb2Io4cdjpsOGdatxgcEkAa06iRUiFBwECR0Nux2UqjQ8YQ26ggjRGMTqDQYyyJEj2OArOPc6MufHpvy7Ulat9/Q3QdKvY5VUbw9aPiRdHdY0v3YCty+Sum6N+dIpOjQ/ExpQvHmG9My2cirS6AwjNz9VfDoG+K0VdNLzDTYM6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aNcjT+sdwxV/ilXTDZdvi6SPlBzo6OrdI/fMZlBbE28=;
 b=Mf9Yspu+bCvAV+CSBIejY8/JRGlMclphYGm8IYNL3uFalXIqnU4Ra/SXytpK5n7F2rHtaaM0sCkIW7coIcJxmi2T758ozklPUv1DgFkw4lAQZHYUdKO0cIhd08gMJNGdOj3+ZLoBu/WqS/vPZFhv30U5CRYTrVtLKYTxa9qRD7wcJCpMcKVn0fJjotIAgR2Suy1hZkonUgsf/WlgEabdyX7i7FehwKNDxZgp3hrHxrZctPhOK/I7ePPJTvaj3j83Eb4vCuh2d4Id5FT3FRKaRyM0vscvaMns2yy74OeRgaJHWg+AHHAsteQoQKhXBYZ9AF0A1MRPF1prNRBEJF2tbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aNcjT+sdwxV/ilXTDZdvi6SPlBzo6OrdI/fMZlBbE28=;
 b=444LLUamiV0NWED3OcexfoEoc4TMJO1kV9tiB0ZUNv5i+a4aOMkAZTrYDsdMenPiOsPUuDYMQK6gDFxi1lDYpQ9UxJnk4nVsAUu+Zqxb0tXXzS2mmDvP8u/4xLs3pCUZbr5aTYL6NBY+rJ4GFqQLPhjWYqcCmcSEnXs5Cll9bSc=
Received: from BN9PR03CA0871.namprd03.prod.outlook.com (2603:10b6:408:13c::6)
 by MWHPR1201MB2542.namprd12.prod.outlook.com (2603:10b6:300:e8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 28 Jul
 2022 13:53:43 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::4d) by BN9PR03CA0871.outlook.office365.com
 (2603:10b6:408:13c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24 via Frontend
 Transport; Thu, 28 Jul 2022 13:53:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 13:53:43 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 28 Jul
 2022 08:53:41 -0500
Date:   Thu, 28 Jul 2022 08:53:20 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <seanjc@google.com>
CC:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: Possible 5.19 regression for systems with 52-bit physical
 address support
Message-ID: <20220728135320.6u7rmejkuqhy4mhr@amd.com>
References: <20220728134430.ulykdplp6fxgkyiw@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220728134430.ulykdplp6fxgkyiw@amd.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a4137aa-123e-45cd-7cd9-08da70a095cd
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2542:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bzx2dgg90GLHPDuDzAze1S3M+E+PF64SNmBgV03HgKRLKom1pg6V8M2tGL9XKXLMG3Vf430dD68HiGtUHetsawNR6HdN8BLWOQT6Q/AsCvDdb5wNtmSquRzpF9aRu7UCcVg0umDeDLHsg5hCPgMck+gga0NCmzTdBORlay8HXGiTnn/kL0blvNc8ngOdgleDp2o93oODK4GMc4kGGdnnmVJOIJ9laF10LpFvsPZ5kE5egmB/y8SaLSzPXtuTJUvxTB9W/S7aLTjlwmXRawDSCEmLxD11JSsxcRGsNWSfoOb6d3rBM5t9RRRuuwpKBFKsoX79pK2pKZ0HeVtp6hFCuavYc2/4BDAucjX/L7Zmn/iZSp4nPe00OnhrY0zqDMApEAQbv20e5IDYuHpk2CFwK8/Af/VySYxLNV78rdlLfEQbe1xwuwc8JlAw0tttMGi2mNUDmzcpElhli/LaSTE4RzpnBJZj4dOFspDlLmwD6m/X8t8jHhMOfS7ubuKq18m7SolLu73tpYMH6/pwtjq3yO8+82eIqmRQNFQGuk26SIB/IaZI8nlIBTPhGWwde69gbyu8XqVfGZc87I0DSIeWS7SXs93D6yFRQtBH5vIf8UBWomzerryHEvT5KNEWunu/hmFF1iYkGpezBjlyPeqHBhwcWksmjtlfs2rhS8GDlJkZZ45ObKDKdm81Jwbc7X3ySfSey84L4gk/5joR2H9MplT1gtJIX8xbO7lEXr5CmLCdgSespL4EmateKYTPchfGiyFQa9Z1M5u4c3aqVnHGt+DlWSFP9CZ/2VOZ/XroRv983bbOXSzFRRLCoSu7SALpTvb1B1X4xZdycD1kfB+n6J8VWugMe2DqT3X96DuIZxH9EK39X09eNV+1VN74Y209
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(39860400002)(396003)(46966006)(36840700001)(40470700004)(478600001)(8676002)(70206006)(336012)(4326008)(40480700001)(426003)(8936002)(966005)(83380400001)(40460700003)(26005)(5660300002)(70586007)(82740400003)(186003)(82310400005)(16526019)(356005)(6666004)(86362001)(6916009)(81166007)(2616005)(2906002)(47076005)(54906003)(36860700001)(36756003)(316002)(41300700001)(1076003)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 13:53:43.6071
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a4137aa-123e-45cd-7cd9-08da70a095cd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2542
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 28, 2022 at 08:44:30AM -0500, Michael Roth wrote:
> Hi Sean,
> 
> With this patch applied, AMD processors that support 52-bit physical

Sorry, threading got messed up. This is in reference to:

https://lore.kernel.org/lkml/20220420002747.3287931-1-seanjc@google.com/#r

commit 8b9e74bfbf8c7020498a9ea600bd4c0f1915134d
Author: Sean Christopherson <seanjc@google.com>
Date:   Wed Apr 20 00:27:47 2022 +0000

    KVM: x86/mmu: Use enable_mmio_caching to track if MMIO caching is enabled

> address will result in MMIO caching being disabled. This ends up
> breaking SEV-ES and SNP, since they rely on the MMIO reserved bit to
> generate the appropriate NAE MMIO exit event.
> 
> This failure can also be reproduced on Milan by disabling mmio_caching
> via KVM module parameter.
> 
> In the case of AMD, guests use a separate physical address range that
> and so there are still reserved bits available to make use of the MMIO
> caching. This adjustment happens in svm_adjust_mmio_mask(), but since
> mmio_caching_enabled flag is 0, any attempts to update masks get
> ignored by kvm_mmu_set_mmio_spte_mask().
> 
> Would adding 'force' parameter to kvm_mmu_set_mmio_spte_mask() that
> svm_adjust_mmio_mask() can set to ignore enable_mmio_caching be
> reasonable fix, or should we take a different approach?
> 
> Thanks!
> 
> -Mike
