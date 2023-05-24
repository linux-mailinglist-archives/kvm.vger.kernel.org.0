Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD9170FAD7
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 17:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237271AbjEXPyI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 11:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbjEXPyE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 11:54:04 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2620093;
        Wed, 24 May 2023 08:54:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MuZHcTV2c1Hw6aFt1H2HzXbUVNHyje4SH4mBJhg1WSZ9mypLuoV3HRZG/U2ANlDGNfOOpt+IUcJohX5WfpmQ9xQyWAXvo4KDCkfuY4HB1O9p7bRT9c8bUbcwq8a7dU6Dnl4iO8unJ5S3lIpt+Nq4XdrIQ2paCGROfnejQok09R+iPDBl7zu0Rtrs5w1b/N+CDJoVK3bdkW0ccz4eT8lBAN/Bq1S99ECOrJk7nsYyffXB2yaFHVwXwvjqvQP4C8svyiJsLHlbg6f3MWDvqkBUfcYaAPvfv9sHkcXKxUA5FvHoO8b18ojWmr2g71QN9RU6ObzWvGz9Yu0OmW8gz4p6Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F8KNqdnjtKWcEXSXUqLQ+v026bq+7atcJwrPjkBLIxQ=;
 b=JWHqASk00xWb7J3fYm4ueJ65ZTe5/KkdkcD6LKdisAkHOXjkBs0rhoP+u4czyTQLCwenHGiXxwNu1tZfS7Tf7K083VoRmCbW8WPStb/Boa97U50EaykpuZUdKIubCrcU0qzQc2EMztOcZ40P/X84Y8EXAw1Hh4auniW6TkjHq09n3uOkqOW1pCsqW3eMImcYP0ymH8UCaA5gLoVf3Nnt+9lMTSEPup5PwUqYq912A36B8HNDc2/AN/R1FYohP/vJuWirzw65wIvM9Ed0h8x5yMuL51vZuLdWnVpBfiIrPRNheBLeagDWPuQziOULRslDFvao5b8VypIqK+jwVgRUFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8KNqdnjtKWcEXSXUqLQ+v026bq+7atcJwrPjkBLIxQ=;
 b=Ah7gqAOCkFqdXAn+gT2Duiz+YRHvfxY29CEUHAtuQFHqQ5SPYdovr8NMhtVpefOODDNdkSDWTEZ0ldDOwDVIZwLy4UxLiT1hkDstOAsPwnQeWdAQqe09PjaWVWkMFEen+9QHXHPPfOUKAkMHxwK9WvIPDiXvn1JG0iB31cnivA0=
Received: from BN9PR03CA0058.namprd03.prod.outlook.com (2603:10b6:408:fb::33)
 by CH3PR12MB8209.namprd12.prod.outlook.com (2603:10b6:610:123::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Wed, 24 May
 2023 15:54:00 +0000
Received: from BN8NAM11FT101.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fb:cafe::ca) by BN9PR03CA0058.outlook.office365.com
 (2603:10b6:408:fb::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15 via Frontend
 Transport; Wed, 24 May 2023 15:54:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT101.mail.protection.outlook.com (10.13.177.126) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6433.16 via Frontend Transport; Wed, 24 May 2023 15:53:59 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 24 May
 2023 10:53:59 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [RFC PATCH v2 0/6] SVM guest shadow stack support
Date:   Wed, 24 May 2023 15:53:33 +0000
Message-ID: <20230524155339.415820-1-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT101:EE_|CH3PR12MB8209:EE_
X-MS-Office365-Filtering-Correlation-Id: f00dbde6-3216-49c1-13c6-08db5c6f1705
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1+XA7MpPBFyl9F1PGjydwpXFMz0iiod2Pe4jnfj/LoCjHkAD+BdW79eAFkNJsFotTrswSwZ4//uB1rtQCDWw088YX3R1M81HZ0Ej2kWYnrjHkOfjHbnuKVlSwa9MFTHQSoitqX38+pLcn/vj3uplDM5HAI/SDM4Sd6ruk9yW+Rv96ItVodaVSwGwTFBYly8IQgI7gIDH7FmnmhL+nun7nd/IBmvUB0fl/VfH+V54CXPbq9rI6ZWoxDF6pQEnORPSK2H8xtIicj/XvzlhgpyPYjMHaQStTbrhdHN2midWm4neQH+iSFaV6nvFCgggo3JT3EESXy7xZBbCruw69wlyz6oXnmUJ3N29FWJwnnmGodmuoFcK3jT8PkQnTfBAB667Iqte1iqjz27mEKOXP3N3omd/NcF4mgXYFWwK8ghVbqrYjkHyNoeZ2168wE4CFPfBV7cW0fwlciGi0IFv7YbUNtYu3lfypBdHxZ/e+lNMB0K7CP5c8/rPiFhIXdvcOU4XpG8ugNyA8uHeBCCMon8E1IfDyMYMh5IfH/wsitrhAABdLDxI8mvsNOTKmeBCOMw7+oAA7/l8n2+PMdodd56oJtdawb+cSLgIeXUG1im5zjoA/zk0UD7JkJ/+DYXlPe1hx8xxAF7JRW0OCZJNqiCMlwsmTPKXAFVoMNKnAa4drPpVF+iwzVSuTUwbMRZ6q7X9QQ5fmiZzenJnyNZWXVwk2tlmJUcyy35pYenG55XqvithqNXqz2r82VadI7MqV2SY/EUjyCnQYYHxWxG8qjT+uVHSes1wyFWn5A+2GNmXZdk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199021)(40470700004)(46966006)(36840700001)(54906003)(6666004)(26005)(1076003)(70586007)(70206006)(316002)(4326008)(6916009)(7696005)(41300700001)(966005)(478600001)(8936002)(8676002)(5660300002)(40460700003)(40480700001)(2616005)(83380400001)(86362001)(426003)(336012)(36756003)(2906002)(82740400003)(356005)(81166007)(82310400005)(44832011)(186003)(16526019)(36860700001)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 15:53:59.9766
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f00dbde6-3216-49c1-13c6-08db5c6f1705
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT101.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8209
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD Zen3 and newer processors support shadow stack, a feature designed to
protect against ROP (return-oriented programming) attacks in which an attacker
manipulates return addresses on the call stack in order to execute arbitrary
code. To prevent this, shadow stacks can be allocated that are only used by
control transfer and return instructions. When a CALL instruction is issued, it
writes the return address to both the program stack and the shadow stack. When
the subsequent RET instruction is issued, it pops the return address from both
stacks and compares them. If the addresses don't match, a control-protection
exception is raised.

Shadow stack and a related feature, Indirect Branch Tracking (IBT), are
collectively referred to as Control-flow Enforcement Technology (CET). However,
current AMD processors only support shadow stack and not IBT.

This series adds support for shadow stack in SVM guests and builds upon
the support added in the CET guest support patch series [1]. Additional
patches are required to support shadow stack enabled guests in qemu [2]
and glibc [3].

[1]: CET guest support patches
https://lore.kernel.org/all/20230511040857.6094-1-weijiang.yang@intel.com/

[2]: CET qemu patches
https://patchwork.ozlabs.org/project/qemu-devel/patch/20201013051935.6052-2-weijiang.yang@intel.com/

[3]: glibc tree containing necessary updates
https://gitlab.com/x86-glibc/glibc/-/tree/users/hjl/cet/master/

---

v2:
  - Rebased on v3 of the Intel CET virtualization series, dropping the
    patch that moved cet_is_msr_accessible to common code as that has
    been pulled into the Intel series.
  - Minor change removing curly brackets around if statement introduced
    in patch 6/6.

---

Note to maintainers:

This series is split into two parts. This series pertains to KVM and
should apply to the KVM tree. Another patch which I will be submitting
separately entitled, "[RFC PATCH v2] x86/sev-es: Include XSS value in
GHCB CPUID request", pertains to the guest kernel and should apply to
the tip tree. However, I realized that both series depend on the
following line from patch 5/6 in this series:

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index e7c7379d6ac7..8f91376273e0 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -677,5 +677,6 @@ DEFINE_GHCB_ACCESSORS(sw_exit_info_1)
 DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
 DEFINE_GHCB_ACCESSORS(sw_scratch)
 DEFINE_GHCB_ACCESSORS(xcr0)
+DEFINE_GHCB_ACCESSORS(xss)

 #endif

Please advise on how to resolve this situation.

Thanks,
John

John Allen (6):
  KVM: x86: SVM: Emulate reads and writes to shadow stack MSRs
  KVM: x86: SVM: Update dump_vmcb with shadow stack save area additions
  KVM: x86: SVM: Pass through shadow stack MSRs
  KVM: SVM: Save shadow stack host state on VMRUN
  KVM: SVM: Add MSR_IA32_XSS to the GHCB for hypervisor kernel
  KVM: SVM: Add CET features to supported_xss

 arch/x86/include/asm/svm.h |  1 +
 arch/x86/kvm/svm/sev.c     | 25 +++++++++++-
 arch/x86/kvm/svm/svm.c     | 84 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h     |  2 +-
 4 files changed, 109 insertions(+), 3 deletions(-)

-- 
2.39.1

