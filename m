Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0666958E730
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 08:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiHJGPH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 02:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiHJGPE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 02:15:04 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::60f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7966555B;
        Tue,  9 Aug 2022 23:15:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HEXArPLlnMgzWixgVOTlXyzfYObWyfG33dm61azdroCRC+LmQSM38oNj903Sjastn1izWgKv2/GXvQa4IOANqjyRyRT4JOc8vEt8WukwahgilCInJiN2PiZmvXl7J1Jit9Eg0sIfcoFC5f8qMhRPgM1YA7Kjyy+5pE+hVBtLKbvwnNq+5XzzW3Ajm0PSc4dlpxv7USIZoBadVudqBZiwE6/OQ2W8vqOPWa1S3j4ynsoHmDdqqyCB4NZ4wMkqwmea4ed4YpGSJ2Wrf8SJWIQtqRGFFgUpop1KlYXnyh28ubXGRRU53BdDLqBEL8weqJuElXysUcx1D6PnOLCl/f6vOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O+FS/Kl16tw7VhK3S/8TQWrebXA+HNq8NiRCKqQfG/c=;
 b=CTHFV6XAp8dkitbIrMkw6FESlhItb97Wx76QaFSgKxjNoY9sRp8VEhMwS1WTHIJ3gl23o+Y0Sm4YIi1Rk0J26r0wstm7Z0XuPPILves4eaLrvnaWDQrqCKwgrArJE57FmUZg20/n9UJJDKOOrW5ds2f3Ljw8vvFysPi9IdxfrQ1kSpIkz+XeAwPTSTy6rgaFjn3ZC6iqCNHgSTlGNdSOlGZ+UlgX5ru5gByBa0llzU8gQ0o9bvoH9yG/gzkOegqf047jhZny6sNdcgcIPe5UqysOsqLFE8KIeBrUSvtrni4EykqEOBaed4tg2iBQ3eyPuCtVApfDt1R8y6m3uW14cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+FS/Kl16tw7VhK3S/8TQWrebXA+HNq8NiRCKqQfG/c=;
 b=gKobG6OheG54VEn01Yj2v0moAluTHYL3+ZSZiBIGlPxpGKugsUmS2ZG/yNvg58PhQ3Ara77yq2zNq0dSrjc4GDA0iZrpJ3E1IPA1b+ulb7/eUsInXnVEcFX6/O3Y0dA+efYDmLL2Ak9H9vTOdGzinsBL6++kUBPvsTd3Co5yKRA=
Received: from MW4PR04CA0250.namprd04.prod.outlook.com (2603:10b6:303:88::15)
 by BN8PR12MB3044.namprd12.prod.outlook.com (2603:10b6:408:45::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Wed, 10 Aug
 2022 06:14:58 +0000
Received: from CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::5e) by MW4PR04CA0250.outlook.office365.com
 (2603:10b6:303:88::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14 via Frontend
 Transport; Wed, 10 Aug 2022 06:14:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT024.mail.protection.outlook.com (10.13.174.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5525.11 via Frontend Transport; Wed, 10 Aug 2022 06:14:58 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 10 Aug
 2022 01:14:52 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
        <mlevitsk@redhat.com>
Subject: [PATCHv3 4/8] KVM: SVM: Report NMI not allowed when Guest busy handling VNMI
Date:   Wed, 10 Aug 2022 11:42:22 +0530
Message-ID: <20220810061226.1286-5-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220810061226.1286-1-santosh.shukla@amd.com>
References: <20220810061226.1286-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba4b4b65-0d07-44b3-fa09-08da7a97a6f4
X-MS-TrafficTypeDiagnostic: BN8PR12MB3044:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XW8kJVfma+gdkZW02yaullU0ufbKmB5JtX5oKRDSzxcLpAwtIbTBaybdumYhdJp3Y72R4QYhac2n0vztqRicW5PaGuZx8rLwSx6rP7ijguDzXDjUqUmcNDknONLcLx1a2acf67edB4hfxy/qfhW68Jislxv5eFe/9zztQNL7/3c+7V6VyDt3Oo5LhNf2mAi/jOTa4gkRQrR0aaDf2JjKLzikuXhHhkDAM9TmV2ONycjgQbF9r64YocI74ZH1xaTUDgdZmwpjga8XbXbZQ9jGxuSH1BFerXZFjoLKqGOwDT5Ht1+qeqKX8ya5QSMTENXJrscNbwTCiFgSW2mcE2pobwhZrhLhPvDZznfLaeD/eU9V61yckI0KjmpUegN0jWhu3Fpv15Wz+gydoMFc0AssIFwsGnZfZF2vFc3TVGByn3I0vZCOTwPUntZGkysyoj83o6UQpRWmFTxYAZ8AIygUJQvaKYJKL/ih/bestdD+HEDj/Xm1Tnm9cEi1j5t0u6r8E4elOBsNjPluqBRIdXztRPsy/Ch1wTNL1FKbkoe66gGnz3AY6WMOpvrZxI2l86XghXLsIgua44+iLTxJzhqE9zsD5hvb2YNPMADmjpQ46ueqXQiTXGFe8EOfwvtscLqrH/G5oiOevf3FqOArI8EsSgA8nCE2pEhiOkI3ouwDP86/kFQgapxRv0RWNFuxj68rTcSBEuFKuZQu5sWcxm6vZrqZeNKIdJOrm/Y+yhHkg02t1lpnhv2y/1Iv8hW02cLFTtcbDQHpDpSSdUBZONzbnb/DqZ8L5LXAeAKTyk+amC0PH6sjitD57LtFM18sjOkHYhSEMYb2bnBWamOArQpE5Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(39860400002)(346002)(396003)(36840700001)(40470700004)(46966006)(36860700001)(70206006)(70586007)(83380400001)(81166007)(8676002)(4326008)(36756003)(2906002)(8936002)(40460700003)(82740400003)(356005)(6916009)(54906003)(186003)(26005)(16526019)(426003)(336012)(47076005)(478600001)(5660300002)(7696005)(41300700001)(44832011)(316002)(1076003)(2616005)(6666004)(40480700001)(82310400005)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 06:14:58.4038
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba4b4b65-0d07-44b3-fa09-08da7a97a6f4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3044
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the VNMI case, Report NMI is not allowed when V_NMI_PENDING is set
which mean virtual NMI already pended for Guest to process while
the Guest is busy handling the current virtual NMI. The Guest
will first finish handling the current virtual NMI and then it will
take the pended event w/o vmexit.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
v3:
- Added is_vnmi_pending_set API so to check the vnmi pending state.
- Replaced is_vnmi_mask_set check with is_vnmi_pending_set.

v2:
- Moved vnmi check after is_guest_mode() in func _nmi_blocked().
- Removed is_vnmi_mask_set check from _enable_nmi_window().
as it was a redundent check.

 arch/x86/kvm/svm/svm.c |  6 ++++++
 arch/x86/kvm/svm/svm.h | 10 ++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f0ac197fd965..e260e8cb0c81 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3598,6 +3598,9 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
 	if (is_guest_mode(vcpu) && nested_exit_on_nmi(svm))
 		return false;
 
+	if (is_vnmi_enabled(svm) && is_vnmi_pending_set(svm))
+		return true;
+
 	ret = (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) ||
 	      (vcpu->arch.hflags & HF_NMI_MASK);
 
@@ -3734,6 +3737,9 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (is_vnmi_enabled(svm) && is_vnmi_pending_set(svm))
+		return;
+
 	if ((vcpu->arch.hflags & (HF_NMI_MASK | HF_IRET_MASK)) == HF_NMI_MASK)
 		return; /* IRET will cause a vm exit */
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index cc98ec7bd119..7857a89d0ec8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -584,6 +584,16 @@ static inline void clear_vnmi_mask(struct vcpu_svm *svm)
 		svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
 }
 
+static inline bool is_vnmi_pending_set(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = get_vnmi_vmcb(svm);
+
+	if (vmcb)
+		return !!(vmcb->control.int_ctl & V_NMI_PENDING);
+	else
+		return false;
+}
+
 /* svm.c */
 #define MSR_INVALID				0xffffffffU
 
-- 
2.25.1

