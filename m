Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D00965E318
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 03:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjAEC5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 21:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjAEC5s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 21:57:48 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2046.outbound.protection.outlook.com [40.107.95.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846109FFF;
        Wed,  4 Jan 2023 18:57:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZ0473NoSMcF/Ot3LDjBuRTNTSoz9k6iW59pB7UkZM+Wokcc7sowYhKgrsO5M/coeY6T9pvAI71Vo/WE4ejH1RypbdVz1oTeWFzyNx9UgtVDAELXdNM+Er0btwccYz6CAU4cDdT9HduOmeWto+nlXDUK3BQb43U/Dg/l+y8VKE1gR8XJwAdh9kCWUu6+HyV8WSxYMxkergpkqpMuxbvpASr74G2A8DqvHt/4b66D3kXp+gDtdPJEr4aAFNf0ECfcioiWVdnEJq78opk4XuF0DxKHSxm5pqj7mmurr4+JPPkbhrgOrPGgDKcz6nWU4Yr17xoT1bmbqeDs+Xy7mI1Drw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aZ0jdtHwJSHbE9jSpxVyqhT4QNBcf5BOOOCjmUqTdE0=;
 b=ZW/+oThn0ghtefp8U8HJR7h9MRyiXCDaESzHsGM9rFdZXeUdF5XpZGkFUx3vqLuAJ60h6MpJ+a/3dFBlFdK6PKbIFdco3TudojuvPOb3B33iewTxBX/oWC098RH/J+iMS2r8LTKrvBrBdZxh9glEdybVXZm9abO/8u5Bs2sIvr25qdD5w55Wsu1Q9LI1WybzJm83tXEPqjSNl/5DC6DZgprQMSpcGeKTYU4nxi0nYE+PwLwcE1WPiBdzVCL6/OpZbyLlvaWZ5t0C5fno1KoRl0yDIAudMMadYU68ogwz5MszlHmoWZE0Ep+EdZhnzz4jtwlANcpEBTM75M/LvBelng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZ0jdtHwJSHbE9jSpxVyqhT4QNBcf5BOOOCjmUqTdE0=;
 b=sbrDVcZrzvcpCJ0W7zwFan5oIB2qNFqk/eS2IpN3bSN72CYl82E8qcMf7w7WgjO+pVoSHAXvTBM/IhH7oL5AItM1r5uNopfkCs3yjKx8pq7XrTn75GsvQUcbowkYpMRauN8x4Kqj0wZmg17Cmg01tJHqNuKupa826molrE/06II=
Received: from DS7PR03CA0043.namprd03.prod.outlook.com (2603:10b6:5:3b5::18)
 by BL1PR12MB5254.namprd12.prod.outlook.com (2603:10b6:208:31e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 02:57:45 +0000
Received: from DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::3c) by DS7PR03CA0043.outlook.office365.com
 (2603:10b6:5:3b5::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.14 via Frontend
 Transport; Thu, 5 Jan 2023 02:57:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT051.mail.protection.outlook.com (10.13.172.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5966.17 via Frontend Transport; Thu, 5 Jan 2023 02:57:44 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 4 Jan
 2023 20:57:43 -0600
Date:   Wed, 4 Jan 2023 11:21:05 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <vbabka@suse.cz>,
        <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>
Subject: Re: [PATCH RFC v7 00/64] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <20230104172105.tke5opbywcgq2fzl@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <Y6YQjJyoxKC5hfij@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y6YQjJyoxKC5hfij@zn.tnic>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT051:EE_|BL1PR12MB5254:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b619d84-6b30-48c5-3c31-08daeec89e46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i+z/KMhgVixZBfoza7xmaFkmxv+brd7sfz+zOGvtVrg0n7BZftSSj1tTKBPEVgEwBC8s4Erm8wE+uQFtMdzjaDb23WXvj4f5ssKWkv7UijHqAXlEe61OsYz8/YiaqAtNOzsgD4Zyjemc4JScxi0I93LRLk1gQkWnsCrHrL7gSMEoRjbTcktq55v+uJku3AM4/yeiCrmNjYp1iE1e5lS8QsBRBOu+sk3wTT5Pd9xDzbJm/pvdN1nsXHWOYbEKQKcykRrNzd6zOumAUMkbN0dnCySQcq51lU1QN0bo+VG8ikZvSlGL56WANt3ScvNO2wmHdnUG6MQEgz3Ih2wi0mYxkyx0qUZrTC65NmBvMgZYyUZYmHLKUW9LQ6g6YV3i5EjWXt/ElBa9lMvtHa/V7pMZ2MwPwRLLx7uxGUUjCfBfTmZpjMjvGAsU3bM9u5DZ97lEawT9ygUHK7M0vwlIUW4AIgGWrCfx5I9MIAXBeXNOIEkY8ThAd17GrwlRmf5Jd39Sk25UEvat3jKuMQDNHzhDAeKYptZcYQE0nJ3Y5JZpQiMSSZlpGe1Ls761TlphkcGWvnBnVgvOF/gXohWufnXBN0AY97XbEW1gwyOzjaHy1m6OzFGuSTp7i6Mh4kl6v2ZWBL2vpEgRJJTJzUOX1ASpgMw6rDcPQUtbLgueynjLPPR6sHmsCPrA1THdcTr4Twk2r9nQFniK8P2Eahdxi8HM1qN5cOrr8z+ph+P1xTqlv8DjZlHaeeheq0gpDb6tKhvAPPPR796MZnoynnnerYoEc/iNS4Bv5yt3Q5bKmrqo6BCthB1AqWaVL3eWkY/739ao
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199015)(46966006)(36840700001)(40470700004)(70586007)(44832011)(5660300002)(7416002)(7406005)(316002)(2906002)(41300700001)(54906003)(6916009)(8676002)(4326008)(8936002)(70206006)(2616005)(36860700001)(82310400005)(6666004)(45080400002)(36756003)(478600001)(186003)(26005)(47076005)(426003)(966005)(1076003)(16526019)(83380400001)(336012)(82740400003)(40480700001)(86362001)(81166007)(40460700003)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 02:57:44.1838
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b619d84-6b30-48c5-3c31-08daeec89e46
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5254
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 23, 2022 at 09:33:16PM +0100, Borislav Petkov wrote:
> On Wed, Dec 14, 2022 at 01:39:52PM -0600, Michael Roth wrote:
> > This patchset is based on top of the following patchset:
> > 
> >   "[PATCH v10 0/9] KVM: mm: fd-based approach for supporting KVM"
> >   https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flkml%2F20221202061347.1070246-1-chao.p.peng%40linux.intel.com%2FT%2F%23me1dd3a4c295758b4e4ac8ff600f2db055bc5f987&data=05%7C01%7Cmichael.roth%40amd.com%7Ce778b913794d41ca7a1b08dae524f21c%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638074244202143178%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=rhjtuPIYWrTN%2FtPHOb2HM5GGZ5cgHRCGVoqu8N1f7XY%3D&reserved=0
> 
> Well, not quite.
> 
> There's also this thing which is stuck in there:
> 
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fr%2F20221205232341.4131240-1-vannapurve%40google.com&data=05%7C01%7Cmichael.roth%40amd.com%7Ce778b913794d41ca7a1b08dae524f21c%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638074244202143178%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=L20ayS1IDUCuOjrs2HzVApzf5%2BmW48PhcsnZprn1RIM%3D&reserved=0
> 
> and I would appreciate reading that in the 0th message so that I don't
> scratch my head over why don't those patches apply and what else is
> missing...

That's correct, sorry for the confusion. With UPM v9 those tests were included
on top so when I ported to v10 I failed to recall it was now a separate
patchset I'd added on top.

-Mike

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpeople.kernel.org%2Ftglx%2Fnotes-about-netiquette&data=05%7C01%7Cmichael.roth%40amd.com%7Ce778b913794d41ca7a1b08dae524f21c%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638074244202143178%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=q4TNZvaptVOEPnx%2B6FJpg64v%2BUya14kO6PX1U422JXE%3D&reserved=0
