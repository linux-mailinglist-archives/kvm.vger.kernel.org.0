Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4EF643B7DC
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 19:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237750AbhJZRG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 13:06:28 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:17062 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237736AbhJZRGY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 13:06:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1635267840; x=1666803840;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=6kDLGeMpJKwudtVd1YdeeOTt2e+QvvKaxbuyboohxRQ=;
  b=Ooyq34AuuI5DxYd0nnqF0BFY+RDiIzfKupy5QoaW7UMhqCLemLoozTLt
   GJc/52M0bAHwLc+ju2Lqmxm1V/xfJAMJH0W4a25wR1BdEr+t+GRmnvSHb
   ulfR+9SjL/BFnOB0DtwS91GOJJwGAgk9v1zrBBsIp1SUvwGP4bD6llZi7
   ekhBRV2JkfxXHpsDd2VJ5NkSAIgF4nM5mxx9UztbX/VLMCO3iDImECRAs
   rvXviPj7/vjgtFztJHePDS3VcBKaZ2tgVxwopMfhXtBcWC0vrf2CkrmUx
   ChFAFPDpZ+2vS9L/+t8JwtRQtaD+SLR3IBOi+lOOmYTypFEKDP/cwKRbt
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,184,1631548800"; 
   d="scan'208";a="295633734"
Received: from mail-bn8nam12lp2175.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.175])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2021 01:03:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZBPMipQItybQzMRwSWWyeiseBNYGKXHe066zf8KMRf0ixi/UoNjvRR0e4+1TQthqlYQ9CWBVj8/LPn5xN6uQ2XV4u+7y1IesUyZ0U18ytVFfrT24u3qC/uUMK7BtXWe9RWNQeeEswSCoZt+lTKMhNfM6yXgZqwPU9ImQY0PX/8K6sIjqhGQwt6Icl0MOOpp4xvbGS7XJXWQ9Lo587xAk223GC1AWED1C1jpr9AcKfjGEFrJnAs5u0Wxo1nziW/6vUzAYbOU25eSKpOFRWP/SEpM7hnTZxzzi1KVS0ViyOUPjtLd4R2GQWSVr/+SS6lmbqUFjldEGL6GV+QDirJO2CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VX2kYy+IrRU0aSE9vFYN4zrfG7rtL3Xys4XmdRTWIu8=;
 b=UgZnE/z6o3GmdnN3+FNLaUbskzrFNN+5z/TeNatAHeX6dAS+qKHgKLxbPUDeHEOr9iEgOqIJngCk/lQngQTrGFEjWoVvS799LWnkEE4iznBXP43fXX+hWQRs0uct/RieN+W/euUaFP5rheKzwABH4HpkTpHPKZXnfsL672TpQYMLtqnr9pIRYKXcMCIiWMg7UTxq0mViqs/SFhEuiOaDcbVQB1y6PnFOxAES3F84biWzIMg4bDKm62RhVGYuoy8Tg9zxb/R5mWTjh4kDdjQqSFYpg8yzsPsdV9Wx0sPrJFoQRRzlsPmOMH9uj38gX5MG+X4idGPJel0f2GrGXa28Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VX2kYy+IrRU0aSE9vFYN4zrfG7rtL3Xys4XmdRTWIu8=;
 b=dvvb2KPZPnYaAnaEgBNJhqaHYJtRbfIgECMGBa8R91eBcp9ACN/tQiy0OTTO5T/krnR1/dBIJ0h0iBYYIIFf2bwAdwe7vjCwvjusH1ArPZ7MUFVER7CsEW7MAs0RD8UkztJW3+9f0K8JT282UPcFb810tLo16is+3sdLjumoENg=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB8314.namprd04.prod.outlook.com (2603:10b6:303:135::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Tue, 26 Oct
 2021 17:03:11 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97%8]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 17:03:11 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>,
        Ian Huang <ihuang@ventanamicro.com>
Subject: [PATCH 3/3] RISC-V: KVM: Fix GPA passed to __kvm_riscv_hfence_gvma_xyz() functions
Date:   Tue, 26 Oct 2021 22:31:36 +0530
Message-Id: <20211026170136.2147619-4-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211026170136.2147619-1-anup.patel@wdc.com>
References: <20211026170136.2147619-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0018.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::28) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.162.126.221) by MA1PR0101CA0018.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:21::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Tue, 26 Oct 2021 17:03:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b459cbb-0bba-4478-edb1-08d998a27d8d
X-MS-TrafficTypeDiagnostic: CO6PR04MB8314:
X-Microsoft-Antispam-PRVS: <CO6PR04MB8314837883D727D22FA2FBB68D849@CO6PR04MB8314.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zBc2VvrOmeyYVHJQAlDmOXwmbxJ8VRjWlUAFJjY793FfrbMooJpHV9c0pPppnU9KQV91NCpNg5BtJcCc+7hwHbb9d0N+OOjTgAE4m+CWi25rqE8SXDaw7N8LXEPLwz016fXRRJDoeMbwZRPmoOzsy17HcRBEe0KbQ0LObNJ5SesDJqWzjDOAydbxFyBiAwJDGGFj3lbJgr8dFGjDrJjgxUKLFOfinr2Af2hlrYyKThW+26e2SfsajK1bwyksV0emv8Mr4/qsqyFSRND1o4JduMBLeb4Iv1cDwYRBlrbxXY53LXwWdPalJRe/qw69xJO/6h7zSSpWTcpA1MXXwiaOQ/x7aW5l+F+waE4pAF020OAnm6jr5m0tM1j2JiiPkaZ+5QU1b2yfcebf3LTnZXUxJ1T3KtaP3FNVCKgFQskSLKdKtqa0Ai4cppXp0cAvFGFD+Cvh5L2pKmD7a1e9nemCzsoxwx72D89sxRsGQn+CjdaLdynHQbpqdO0tN36mhkqTz2ZbhCDLCSrj9nuXHKztxVJxYtWGwp+GoPUN4vqgAJ+n9GxmQw5eOJra+jD6SFiC5mfvtHuV7Sf67FhSijdNHWodkV30t8YhMjUBXP7lpLqnzGCS+2SQlkdBHxaZiITVw7124gpkvp+VQd/YOMin+tfg1G+if0xbAe8En12/w47Wbe2W9PXh2LxqaIhPgOrmlKYGf1b0DRpB2U6brhgOKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(4326008)(5660300002)(26005)(44832011)(2906002)(956004)(52116002)(2616005)(8886007)(38350700002)(7696005)(55016002)(83380400001)(186003)(38100700002)(82960400001)(54906003)(110136005)(316002)(8676002)(8936002)(7416002)(36756003)(86362001)(66556008)(508600001)(66476007)(66946007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?72l4vHc2Ty+x9Cb3lofzn26wrf6VbWdNACUyAzpTqskBj8NaNiLPL0XUw07R?=
 =?us-ascii?Q?DsKtlXApr8Wqj1XdyRLM4VQXGxjVtEOYWMsvNVRvxX+1WBSdRda+esHKQkj6?=
 =?us-ascii?Q?dAvlCyPhkHNCeKrxIzNUmHLzk67ysyqjCWdu4CTr62Y6Mi1I3NL+w0uaWPwp?=
 =?us-ascii?Q?u2rgbIt5YbWaTo+ld5jvCgrHesYtFbKm8A/TOq682TrzMproJoaqHBYPbdPU?=
 =?us-ascii?Q?65qLQLly7HPti16dl7e69nSo9e5McLYTNJz54s4sfPzo0lnqZHBHLDN2Oypd?=
 =?us-ascii?Q?I91lRsN11a6tonvqFR0dpkq7tdsh6zo0erzowwscGN1pO8r6Q0GWRw+SlIj3?=
 =?us-ascii?Q?Hfl4SmQ8GookpNmKZiV0B06AtKn78YDCvqyRJ/F32nZ8V6HRZAMgRbqR4PQs?=
 =?us-ascii?Q?C7RTZH4NWNGGkKbhFYWqBLS05/b4E3U7/mj595y7oKcum9Q0GYnmk9gzg3ne?=
 =?us-ascii?Q?DU8wltTgzqc+m5rOLFP61zcM1GJHxlEXdZXTlXcxHbG+gdo75MhKTFV4KamZ?=
 =?us-ascii?Q?D9zTmHzWWTRwsama0Kut3TZGmlyGNjbn5suGi410uBIL0qR+ELoVJKh7rvFp?=
 =?us-ascii?Q?ISeCR9Er8H0HMm/p19GDI6T15qC8C2CYuG8nOtqTKthohtApCglFeRISBvjJ?=
 =?us-ascii?Q?gW9zlg973mi3isLED1whXHqKFPzJMZAB3NY5laoXUeo0Plc5B0EYXuVZ+yPx?=
 =?us-ascii?Q?Zz39Nbh+AQnkDaRHdt/QPIKUA00/Z5hWa54hW9neLKjwBS9JZ9eDQgtvCd2O?=
 =?us-ascii?Q?qcD14QgSH1LLma1vrMA+kiYaFf7pyEIl2jO8sXwr1zoKSgS7alOgfpigP9A7?=
 =?us-ascii?Q?lWSXukEYmfdwPIaE/727MIdDnCuGo5creJv+tTnI4pMefJDzXWo99NO3Jm8l?=
 =?us-ascii?Q?NV8YbgtTiZhnbikEuJz1zJndty4Ek3zUulp/pSeK4Vjxc3ztHkfXSZEdMpnC?=
 =?us-ascii?Q?DLVVSNbTgxc80X1DrRL9/55JYiAobR+zzs+J/1IZgVfYNWMz9H6MRloTsKrH?=
 =?us-ascii?Q?Oh9yG48LjAaXCb8ErlM5Fd4VObRNqJ8OFNwELvzIpiEHdUOrWuPvHzqz0Tnb?=
 =?us-ascii?Q?RUwLbKKB/40M2rAS07oYG4Xuy9lSCG+REqoX09UqP+ahagpLFkEhTEvLTD5L?=
 =?us-ascii?Q?ps6EjHp9rc4knoebOS98D3shkeGiEk1bNNF5X18SiFEUwd/cHfIlpIjj7rGP?=
 =?us-ascii?Q?Oe42BN5SQXDeoUQw7Ow6gdPwxehit/46NAwv48RKk5sEYaA5JqQMxlQpK7WF?=
 =?us-ascii?Q?Ix/XN9Ggue1kp6FY4SkjJ5Px2tTB1cHQcKPTdtNwUr9EH9mBh+PQRuISBPMY?=
 =?us-ascii?Q?l9iWYU5W8vltRQmXM3LpGno0Jv+/Nl7yn5EEW7eADBtuANMAyrL2Y8hkTBgG?=
 =?us-ascii?Q?yQzCnRIuBUUZkWoCyqGMtrqBRpqdmpKaVVGObzVVeCRuqpaO3XO8fEIr2L/w?=
 =?us-ascii?Q?xQfL2jELppFNtU3WkcrYii8pnq9bbXTLs3cOjdpeg1azBrxGb0/MT2Fx3ZZq?=
 =?us-ascii?Q?CwvTN9vcBZ6sJRJSKA1iyQHzq6maZOn4Wx4nBH+qPQeNr7l3wNFeJgNt5XKX?=
 =?us-ascii?Q?PN3vaz2uaEkveuVQ9uNIYKuo3w2wimyJwRQApbvhEIj3ngJ3U6b+WmvTnwdr?=
 =?us-ascii?Q?m9f8q+0slkY1mSHiV3qkDn0=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b459cbb-0bba-4478-edb1-08d998a27d8d
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 17:03:11.1200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wzzsl04IxhQTt6eBDChz2j9Cl/j74L1tEes4KQRIaTXcd7dlHzZEIMxwA3/DCxOZHgaHvamRmjjPKnSvNbtgvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8314
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The parameter passed to HFENCE.GVMA instruction in rs1 register
is guest physical address right shifted by 2 (i.e. divided by 4).

Unfortunately, we overlooked the semantics of rs1 registers for
HFENCE.GVMA instruction and never right shifted guest physical
address by 2. This issue did not manifest for hypervisors till
now because:
  1) Currently, only __kvm_riscv_hfence_gvma_all() and SBI
     HFENCE calls are used to invalidate TLB.
  2) All H-extension implementations (such as QEMU, Spike,
     Rocket Core FPGA, etc) that we tried till now were
     conservatively flushing everything upon any HFENCE.GVMA
     instruction.

This patch fixes GPA passed to __kvm_riscv_hfence_gvma_vmid_gpa()
and __kvm_riscv_hfence_gvma_gpa() functions.

Fixes: fd7bb4a251df ("RISC-V: KVM: Implement VMID allocator")
Reported-by: Ian Huang <ihuang@ventanamicro.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/include/asm/kvm_host.h | 5 +++--
 arch/riscv/kvm/tlb.S              | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index d27878d6adf9..25ba21f98504 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -214,9 +214,10 @@ static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 
-void __kvm_riscv_hfence_gvma_vmid_gpa(unsigned long gpa, unsigned long vmid);
+void __kvm_riscv_hfence_gvma_vmid_gpa(unsigned long gpa_divby_4,
+				      unsigned long vmid);
 void __kvm_riscv_hfence_gvma_vmid(unsigned long vmid);
-void __kvm_riscv_hfence_gvma_gpa(unsigned long gpa);
+void __kvm_riscv_hfence_gvma_gpa(unsigned long gpa_divby_4);
 void __kvm_riscv_hfence_gvma_all(void);
 
 int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
diff --git a/arch/riscv/kvm/tlb.S b/arch/riscv/kvm/tlb.S
index c858570f0856..899f75d60bad 100644
--- a/arch/riscv/kvm/tlb.S
+++ b/arch/riscv/kvm/tlb.S
@@ -31,7 +31,7 @@
 
 ENTRY(__kvm_riscv_hfence_gvma_vmid_gpa)
 	/*
-	 * rs1 = a0 (GPA)
+	 * rs1 = a0 (GPA >> 2)
 	 * rs2 = a1 (VMID)
 	 * HFENCE.GVMA a0, a1
 	 * 0110001 01011 01010 000 00000 1110011
@@ -53,7 +53,7 @@ ENDPROC(__kvm_riscv_hfence_gvma_vmid)
 
 ENTRY(__kvm_riscv_hfence_gvma_gpa)
 	/*
-	 * rs1 = a0 (GPA)
+	 * rs1 = a0 (GPA >> 2)
 	 * rs2 = zero
 	 * HFENCE.GVMA a0
 	 * 0110001 00000 01010 000 00000 1110011
-- 
2.25.1

