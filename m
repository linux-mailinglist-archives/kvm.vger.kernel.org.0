Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C393584042
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 15:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiG1NqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 09:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiG1Npr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 09:45:47 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9341661D82;
        Thu, 28 Jul 2022 06:45:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bMVeZIi7IIwT+TQu9ZjFNc5KoaNsIZneVFiXyxSrZKLyk9Y8Ne3kiByOeV7x7XMdVkd8KRGaf/FG4+azW3HEdr9vKcqmzndIZpy5jIaH4+7PE8LkIc/6pnKdYzba68Q9OgTHs+Zlrif28t5PmHMOTwkk+eAMp3BTbsLgiAaxAl3Pa0TcwdcDwS9Hd7kx0ZeHbAF5blyEHZkbr8DVkLA++rOSrUclTkOpBfLz6RXVqjM2J5ehiVEQ/pcC6XbhLzLvyHjUYCzSkInNVovW+jKupBhD8PWeCveePuZZ9b8xOkBqtaamnMt31oelVNY9rSSCVst9O4coYCrITw/Stcx9xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sCYmpIlNiV51gzZNOnmcf/o3xy/Uy06xSdY4vy71K9s=;
 b=kHer0QyGpWuZZrzekgq0I1NqYb6xMpS4R7ggeYjsmUtFmy0D3HuaT4NM9EVGlxscxrNGvvjGWbPIan7M1HO9hmSwuGv64gqpYS3AiYYGzGBGg17A0uUMJkJvK9Zx5pCBvaWiH9rDR0WCs56vsmnrmgfITuMfUVFF+9BqWPfjBvMzc4v5r69QWol8gQzlm9GeNUg1joezVzG2o/2662SRAP8wK/RrHZOHLieZDmhASTbltPo8f7DP9PsELhmYGU79KCMAtmC4/im8Vq5F55X1ox7OF+3jqR379OMFzntT4NCA1WpUPqV8cvlE9JyOn1urTbEOKjvXT8M4y2vssIgTDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCYmpIlNiV51gzZNOnmcf/o3xy/Uy06xSdY4vy71K9s=;
 b=wG32dGZrkbm7fpN0/U6M6f/WjI+ohvfTHzoLbqGdXHmTpBrw7+j1BBD4DSflvlk8wcBEEhLwZftKG3r+op/71RN4ZzQBRImhgNAMFsazHQmb/40oGCaHhLtnYNsIw72A8a8hRFyOsFb514yaDvmXIirVHD3RhMReKisJ5MxcNIk=
Received: from DS7PR03CA0208.namprd03.prod.outlook.com (2603:10b6:5:3b6::33)
 by SN7PR12MB7021.namprd12.prod.outlook.com (2603:10b6:806:262::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Thu, 28 Jul
 2022 13:45:45 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b6:cafe::df) by DS7PR03CA0208.outlook.office365.com
 (2603:10b6:5:3b6::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.10 via Frontend
 Transport; Thu, 28 Jul 2022 13:45:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 13:45:44 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 28 Jul
 2022 08:45:43 -0500
Date:   Thu, 28 Jul 2022 08:44:30 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <seanjc@google.com>
CC:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: re: Possible 5.19 regression for systems with 52-bit physical
 address support
Message-ID: <20220728134430.ulykdplp6fxgkyiw@amd.com>
In-Reply-To: 20220420002747.3287931-1-seanjc@google.com
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21c41e81-08aa-49f8-a564-08da709f785e
X-MS-TrafficTypeDiagnostic: SN7PR12MB7021:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AptLxT/0AVBMxcQwalw2vEsT0oxr8he/vsUjPWJFvMSiJt8ymyiNZcmrd3R3vb/OqXfQ/J7Re+i9KafVYJcfuoELOEK0LKasGTFE5N6UQnfb56JDSqGuUcXZGtTh5eOTosq6rrWHhZ/1tw+lp5Qrn+480++v98ocN9IOT6N2ovxgGNZ9CrSXxNocvCDy28GMtvgnLnlJq+55T6OpPtOsRaxQPMD9LB1AywhV+UfNklLIWxEyfuAyEh9CgQgvHWsb4kUW0rgNpcz8RdeSd3umo/SMehWiVTXyp0Stkr8qhnHvApaQ9TMuSJ49FF63VOFh13PQlPGIGh+5qYU4AsyVMCR08GYSIP1pWFRWxlt+d40nMvfIzbC7wVYkHIodV7+mV3CKdiIKVhyExQHlt4a09ZtUi0jWquxwOCQ/SR75787t/W9vv+PAYadKushupUXJmOQratENf/y3CVLa4S0D/euPPA9ojOo0afZRukbHxkTpGB/T7aGt7ZHAnPpYFb7DJyaAVKzLWFO3U4ihYrxSLAwt6M4s5UIxC0HLJTDxaVdd2QFSPRSQOA39NeUdrm70POpFVX/Kdy9brHpEzb8uhTGRQPiYnqqnaW7w0mHfk7UiWTrFJgvTrksqFkzcKxTcpWE6DVWz3G4p7tQmcD3tM76CpkcTj2paLtexoJ4veske98zJ0prCYMm172o7B1jJKh0Yw83yH3lbhIJ8YJe9ip5QiesoeEYwmkjpddLCUsJfd3fxZvJGD5dSbZTVWtQ6VPsjD9cqAlK+nOKtgtbMYrIbVytDXHLBTRuvbIwP2j6T2yb84BjldjB1VzseYv83h1FzIeiQfp5yAbf9/xkwLg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(136003)(376002)(396003)(46966006)(36840700001)(40470700004)(2616005)(44832011)(86362001)(54906003)(4744005)(8936002)(8676002)(6916009)(4326008)(316002)(41300700001)(16526019)(186003)(36756003)(6666004)(70586007)(5660300002)(70206006)(336012)(426003)(81166007)(47076005)(356005)(1076003)(2906002)(83380400001)(40460700003)(82310400005)(26005)(82740400003)(478600001)(36860700001)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 13:45:44.6988
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 21c41e81-08aa-49f8-a564-08da709f785e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7021
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

With this patch applied, AMD processors that support 52-bit physical
address will result in MMIO caching being disabled. This ends up
breaking SEV-ES and SNP, since they rely on the MMIO reserved bit to
generate the appropriate NAE MMIO exit event.

This failure can also be reproduced on Milan by disabling mmio_caching
via KVM module parameter.

In the case of AMD, guests use a separate physical address range that
and so there are still reserved bits available to make use of the MMIO
caching. This adjustment happens in svm_adjust_mmio_mask(), but since
mmio_caching_enabled flag is 0, any attempts to update masks get
ignored by kvm_mmu_set_mmio_spte_mask().

Would adding 'force' parameter to kvm_mmu_set_mmio_spte_mask() that
svm_adjust_mmio_mask() can set to ignore enable_mmio_caching be
reasonable fix, or should we take a different approach?

Thanks!

-Mike
