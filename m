Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A99167DCC2
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 04:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbjA0D4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 22:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjA0D4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 22:56:45 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0E961D6A;
        Thu, 26 Jan 2023 19:56:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ofwWvW1ugMSRaY6PaozT/FSHtqQBKf2pDLpNZ/LPAuZKsEMd1bhKap7j8XSAwGNFkPxcZpuPXUWppgtVJjUk3+Wv7Ps0CkxPDY0HNZw9rQ5h9Nc5ASE+hzZ2PooFRVVDlzDTRAv846fWMA2EDNYZ0u6cu8L2GvVgvDzp4YMAu5HL5ipZbjdsuIbAbL2uEjsTs97VsZEFtx/5fNqoKt+2Z+qcs+QjzuwYtCZeYWeCERTXoMHLWrOATtUlX1x9S5B7LqTlMZ2kRuADK9myBrmzF15hhI+Pp3BtTomlOOGk1EMOTxNVSXwTSMYIpZyOVr3RQ1IC6Qg9j+xxXgONJvRv5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ITqkDJd1BmhTSMM+q2gKfRuRTUX6Y0NcbTampoYR3b0=;
 b=ViD6fZEOG6ilXldVjVPGvIPPfGPwligcbwch5P6Y4bv0UxHeNUrn5ITA1EuRJgZLHd7KWkEVucjP5Cjao6OxHc5vNFSJ0eRGn3d1FMQkMqlH7bTeKeUXTWb7kjZag9FWo8LfYdD+3rB29PMK8UF4VBja6etPpPHUeeUc36Ww9wDPj66C2H3c9mnJWVPCZ7dht40Ke8NX4LG6enKsGmZ8G8WYqyCGsa1h3K25u3wQ8uVwePLzWRpFeQ6CCyK53NhrE5Tz7vCb4GhOx62aUveWwT+lUTTYW5pxJIShBpt9l/n6eD9mzQCewP1IPB8s2hBlgZbqRs9v5f1wFWCdzO4Z0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ITqkDJd1BmhTSMM+q2gKfRuRTUX6Y0NcbTampoYR3b0=;
 b=YNPYdL0yE6VTfzf5mBReVSWIwZ4V8wddCAmm/51/Eizqk2KB5f9x0URlIsxHIoWXRHRf6vV7N5N5D+H9LeRS52yTI/QunXpkTV7X1xuuzjDmS1hulF34Nl61ftuqiKsXs4FMfebWBVCuPq2a7wO/nMjtVu17yTGmzcGEs8q5cGg=
Received: from DS7PR03CA0257.namprd03.prod.outlook.com (2603:10b6:5:3b3::22)
 by MN0PR12MB5740.namprd12.prod.outlook.com (2603:10b6:208:373::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 03:56:39 +0000
Received: from DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b3:cafe::fd) by DS7PR03CA0257.outlook.office365.com
 (2603:10b6:5:3b3::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Fri, 27 Jan 2023 03:56:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT028.mail.protection.outlook.com (10.13.173.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.21 via Frontend Transport; Fri, 27 Jan 2023 03:56:39 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 26 Jan
 2023 21:56:29 -0600
From:   Alexey Kardashevskiy <aik@amd.com>
To:     Alexey Kardashevskiy <aik@amd.com>
CC:     <kvm@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Borislav Petkov" <bp@alien8.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [Question PATCH kernel] x86/amd/sev/nmi+vc: Fix stack handling (why is this happening?)
Date:   Fri, 27 Jan 2023 14:56:16 +1100
Message-ID: <20230127035616.508966-1-aik@amd.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT028:EE_|MN0PR12MB5740:EE_
X-MS-Office365-Filtering-Correlation-Id: 7512e605-bbab-4ead-1db1-08db001a7e58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7vJEF7viiOYTgLAQHRniUyl5KTGAW7snsb79j7Ns7LEDYV18I57aTEKpd6o4K+lQH2vHGxDZEYiviGHwDktHIIdgRg3gytbtsfzPPIJhDyaadGTUi645uu6D1PWdGm9G4chtyd9oizG1inTnFzS/tX1Is7ard+PkpJlnd/UJilL5nifxixQV5t/JUyPo5hMbMYfu4KJ9l6lHnCl08BHU2Sr0H5LXdT2oKtZOXpmIGqjAC1vuYNK0VHBQJWmcd5sThJQ/1VOlVfFaL404v6rUyluP/+pafWjf9foPlX+tM6SYVHr2JKqAeEREe/hbFLdNtieKd4BVX6S15Mx1OrBpE/g3bBSJalJ2valLs+51FBcX14+hOyIzMDcjYenI5ThkurKhgp2gx1F9ExOwgshmTG2yq7wi/iRcwvTyXlUQm77AZcN/8yKtOL2+0HRrmo8jKGc4szV577Y101Fj+DW48da+feSSgPwN4ekjbZHUXBrbdAPWcWWhKhnR+AaTzntVWAX73fW4jAu90OyfEnJAE5xjdEW78QaKnuZw+creAwRZg13vUrxqcYUf9BZfS1G5a/pESm0ELc7vFCskK1F6yD/DVCPVixMTnVnBA2SVUS+GEcsKoSggANulhVrtCCtmayMR1OtxgVRqO2m39fFfZfu8rn2eYWmCeUbvLKOEuhyYCmnTKy9QeaGjp99Tlz8IEdBf1hEwoxRBEUEquT/FLYDFg7SNKK8JsEIMZM2R7hiuCEbsR0d8UO6Kj+/XaDqGlDpmshtHrd6YfF233pUsTdc6tle3+QwEb5xd488btf6V9IsglbuTtfIyTJMalaHT
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199018)(46966006)(36840700001)(40470700004)(6200100001)(40460700003)(356005)(2906002)(81166007)(1076003)(36860700001)(2616005)(7049001)(26005)(16526019)(6666004)(7416002)(426003)(186003)(83380400001)(40480700001)(4326008)(30864003)(70206006)(70586007)(8676002)(47076005)(336012)(5660300002)(36756003)(6862004)(316002)(82740400003)(8936002)(966005)(54906003)(37006003)(19627235002)(45080400002)(41300700001)(478600001)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 03:56:39.1129
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7512e605-bbab-4ead-1db1-08db001a7e58
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5740
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD SEV-ES guest kernels compiled without CONFIG_PARAVIRT crash when
"perf" executes. "./perf record sleep 20" is an example.

Some debugging revealed this happens when CONFIG_PARAVIRT_XXL is not
defined. The problem seems to be that between DEFINE_IDTENTRY_RAW(exc_nmi)
and actual reading of DB7 (which in turn causes #VC) every function is
inlined and no stack frame is created (?). Replacing __always_inline with
noinline in  local_db_save() or native_get_debugreg() fixes the problem.

The crash does not happen with CONFIG_PARAVIRT_XXL as in this case
paravirt_get_debugreg() is used and there is an indirect call via
PVOP_CALL1(). It has not been noticed as the most configs have CONFIG_XEN
enabled which enables CONFIG_PARAVIRT_XXL.

This happens with the recent tip/master, here is my test kernel
and the config:
https://github.com/aik/linux/commits/debug_dr7

Found this while testing DebugSwap (which also fixes the crash as
it eliminates DB7 interception == #VC):
https://lore.kernel.org/all/20230120031047.628097-1-aik@amd.com

Define local_db_save_exc_nmi() to demostrate that the problem better.

Why is this crash happening and how to fix that? I am still reading
the assembly but was hoping for a shortcut here :) Thanks,

aik-Standard-PC-i440FX-PIIX-1996 login: [A[   15.775303] BUG: NMI stack guard page was hit at 0000000003983d50 (stack is 000000007feb1fa4..00000000574369c2)
[   15.775314] stack guard page: 0000 [#1] PREEMPT SMP NOPTI
[   15.775316] CPU: 0 PID: 790 Comm: sleep Not tainted 6.2.0-rc4_aik-debugswap_ruby-954bhost #73
[   15.775322] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown unknown
[   15.775323] RIP: 0010:error_entry+0x17/0x140
[   15.775326] Code: f8 e9 98 fd ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 56 48 8b 74 24 08 48 89 7c 24 08 52 51 50 41 50 41 51 41 52 41 53 53 <55> 41 54 41 55 41 56 41 57 56 31 f6 31 d2 31 c9 45 31 c0 45 31 c9
[   15.775328] RSP: 0000:fffffe2446b2b000 EFLAGS: 00010097
[   15.775332] RAX: fffffe2446b2b0a8 RBX: 0000000000000000 RCX: ffffffffb3a00fed
[   15.775333] RDX: 0000000000000000 RSI: ffffffffb3a00b69 RDI: fffffe2446b2b0a8
[   15.775336] RBP: fffffe2446b2b0a8 R08: 0000000000000000 R09: 0000000000000000
[   15.775337] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[   15.775338] R13: 0000000000000000 R14: 000000000002dd80 R15: 0000000000000000
[   15.775339] FS:  0000000000000000(0000) GS:ffff94b17dc00000(0000) knlGS:ffff94b17dc00000
[   15.775340] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   15.775341] CR2: fffffe2446b2aff8 CR3: 00080000167b8000 CR4: 00000000003506f0
[   15.775342] Call Trace:
[   15.775352]  <NMI>
[   15.775355]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775357]  ? exc_page_fault+0x11/0x120
[   15.775360]  ? asm_exc_page_fault+0x22/0x30
[   15.775364]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775365]  ? exc_page_fault+0x11/0x120
[   15.775367]  ? asm_exc_page_fault+0x22/0x30
[   15.775368]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775369]  ? exc_page_fault+0x11/0x120
[   15.775371]  ? asm_exc_page_fault+0x22/0x30
[   15.775372]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775373]  ? exc_page_fault+0x11/0x120
[   15.775374]  ? asm_exc_page_fault+0x22/0x30
[   15.775375]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775376]  ? exc_page_fault+0x11/0x120
[   15.775378]  ? asm_exc_page_fault+0x22/0x30
[   15.775379]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775380]  ? exc_page_fault+0x11/0x120
[   15.775381]  ? asm_exc_page_fault+0x22/0x30
[   15.775382]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775383]  ? exc_page_fault+0x11/0x120
[   15.775384]  ? asm_exc_page_fault+0x22/0x30
[   15.775385]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775386]  ? exc_page_fault+0x11/0x120
[   15.775388]  ? asm_exc_page_fault+0x22/0x30
[   15.775389]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775390]  ? exc_page_fault+0x11/0x120
[   15.775391]  ? asm_exc_page_fault+0x22/0x30
[   15.775392]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775393]  ? exc_page_fault+0x11/0x120
[   15.775395]  ? asm_exc_page_fault+0x22/0x30
[   15.775396]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775397]  ? exc_page_fault+0x11/0x120
[   15.775398]  ? asm_exc_page_fault+0x22/0x30
[   15.775399]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775400]  ? exc_page_fault+0x11/0x120
[   15.775401]  ? asm_exc_page_fault+0x22/0x30
[   15.775403]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775404]  ? exc_page_fault+0x11/0x120
[   15.775405]  ? asm_exc_page_fault+0x22/0x30
[   15.775406]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775407]  ? exc_page_fault+0x11/0x120
[   15.775408]  ? asm_exc_page_fault+0x22/0x30
[   15.775409]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775410]  ? exc_page_fault+0x11/0x120
[   15.775412]  ? asm_exc_page_fault+0x22/0x30
[   15.775413]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775414]  ? exc_page_fault+0x11/0x120
[   15.775415]  ? asm_exc_page_fault+0x22/0x30
[   15.775416]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775420]  ? exc_page_fault+0x11/0x120
[   15.775421]  ? asm_exc_page_fault+0x22/0x30
[   15.775422]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775423]  ? exc_page_fault+0x11/0x120
[   15.775425]  ? asm_exc_page_fault+0x22/0x30
[   15.775426]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775427]  ? exc_page_fault+0x11/0x120
[   15.775431]  ? asm_exc_page_fault+0x22/0x30
[   15.775432]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775433]  ? exc_page_fault+0x11/0x120
[   15.775435]  ? asm_exc_page_fault+0x22/0x30
[   15.775436]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775437]  ? exc_page_fault+0x11/0x120
[   15.775438]  ? asm_exc_page_fault+0x22/0x30
[   15.775439]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775440]  ? exc_page_fault+0x11/0x120
[   15.775441]  ? asm_exc_page_fault+0x22/0x30
[   15.775442]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775443]  ? exc_page_fault+0x11/0x120
[   15.775445]  ? asm_exc_page_fault+0x22/0x30
[   15.775446]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775447]  ? exc_page_fault+0x11/0x120
[   15.775448]  ? asm_exc_page_fault+0x22/0x30
[   15.775449]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775450]  ? exc_page_fault+0x11/0x120
[   15.775454]  ? asm_exc_page_fault+0x22/0x30
[   15.775455]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775456]  ? exc_page_fault+0x11/0x120
[   15.775458]  ? asm_exc_page_fault+0x22/0x30
[   15.775459]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775460]  ? exc_page_fault+0x11/0x120
[   15.775461]  ? asm_exc_page_fault+0x22/0x30
[   15.775462]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775463]  ? exc_page_fault+0x11/0x120
[   15.775465]  ? asm_exc_page_fault+0x22/0x30
[   15.775466]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775467]  ? exc_page_fault+0x11/0x120
[   15.775468]  ? asm_exc_page_fault+0x22/0x30
[   15.775469]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775470]  ? exc_page_fault+0x11/0x120
[   15.775471]  ? asm_exc_page_fault+0x22/0x30
[   15.775472]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775473]  ? exc_page_fault+0x11/0x120
[   15.775475]  ? asm_exc_page_fault+0x22/0x30
[   15.775476]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775477]  ? exc_page_fault+0x11/0x120
[   15.775478]  ? asm_exc_page_fault+0x22/0x30
[   15.775482]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775483]  ? exc_page_fault+0x11/0x120
[   15.775485]  ? asm_exc_page_fault+0x22/0x30
[   15.775486]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775487]  ? exc_page_fault+0x11/0x120
[   15.775488]  ? asm_exc_page_fault+0x22/0x30
[   15.775490]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775491]  ? exc_page_fault+0x11/0x120
[   15.775492]  ? asm_exc_page_fault+0x22/0x30
[   15.775493]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775494]  ? exc_page_fault+0x11/0x120
[   15.775495]  ? asm_exc_page_fault+0x22/0x30
[   15.775496]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775497]  ? exc_page_fault+0x11/0x120
[   15.775499]  ? asm_exc_page_fault+0x22/0x30
[   15.775500]  ? check_preemption_disabled+0x8/0xe0
[   15.775502]  ? __sev_es_ist_enter+0x13/0x100
[   15.775503]  ? exc_nmi+0x10e/0x150
[   15.775505]  ? end_repeat_nmi+0x16/0x67
[   15.775506]  ? asm_exc_double_fault+0x30/0x30
[   15.775507]  ? asm_exc_double_fault+0x30/0x30
[   15.775508]  ? asm_exc_double_fault+0x30/0x30
[   15.775509]  </NMI>
[   15.775509]  <#VC>
[   15.775510]  ? __show_regs.cold+0x18e/0x23d
[   15.775511]  </#VC>
[   15.775511]  <#DF>
[   15.775512]  ? __die_body.cold+0x1a/0x1f
[   15.775513]  ? die+0x26/0x40
[   15.775517]  ? handle_stack_overflow+0x44/0x60
[   15.775518]  ? exc_double_fault+0x14b/0x180
[   15.775519]  ? asm_exc_double_fault+0x1f/0x30
[   15.775520]  ? restore_regs_and_return_to_kernel+0x22/0x22
[   15.775521]  ? asm_exc_page_fault+0x9/0x30
[   15.775522]  ? error_entry+0x17/0x140
[   15.775523]  </#DF>
[   15.775523] WARNING: stack recursion on stack type 6
[   15.775524] Modules linked in: msr efivarfs
[   15.837935] ---[ end trace 0000000000000000 ]---

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 arch/x86/include/asm/debugreg.h | 29 ++++++++++++++++++++
 arch/x86/kernel/nmi.c           |  2 +-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index b049d950612f..396e2ea114dc 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -125,6 +125,35 @@ static __always_inline void local_db_restore(unsigned long dr7)
 		set_debugreg(dr7, 7);
 }
 
+/* noinline here inline __always_inline'd native_get_debugreg(int regno) */
+static noinline unsigned long native_get_debugreg7(void)
+{
+	unsigned long dr7;
+	asm("mov %%db7, %0" :"=r" (dr7));
+	return dr7;
+}
+
+static __always_inline unsigned long local_db_save_exc_nmi(void)
+{
+	unsigned long dr7;
+
+	if (static_cpu_has(X86_FEATURE_HYPERVISOR) && !hw_breakpoint_active())
+		return 0;
+
+	dr7 = native_get_debugreg7();
+	dr7 &= ~0x400; /* architecturally set bit */
+	if (dr7)
+		set_debugreg(0, 7);
+	/*
+	 * Ensure the compiler doesn't lower the above statements into
+	 * the critical section; disabling breakpoints late would not
+	 * be good.
+	 */
+	barrier();
+
+	return dr7;
+}
+
 #ifdef CONFIG_CPU_SUP_AMD
 extern void set_dr_addr_mask(unsigned long mask, int dr);
 #else
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index cec0bfa3bc04..400b5b6b74f6 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -503,7 +503,7 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
 	 */
 	sev_es_ist_enter(regs);
 
-	this_cpu_write(nmi_dr7, local_db_save());
+	this_cpu_write(nmi_dr7, local_db_save_exc_nmi());
 
 	irq_state = irqentry_nmi_enter(regs);
 
-- 
2.39.1

