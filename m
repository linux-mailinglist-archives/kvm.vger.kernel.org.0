Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5217BCEFD
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 16:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344830AbjJHO4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 10:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234339AbjJHO4m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 10:56:42 -0400
Received: from AUS01-ME3-obe.outbound.protection.outlook.com (mail-me3aus01olkn2148.outbound.protection.outlook.com [40.92.63.148])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387AFB3;
        Sun,  8 Oct 2023 07:56:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2w3skakuJlkm6qU94OPPsF2EVMYow5tcxyzOBqNC5KV3rsY4JsvwaymYrj9z0wi8OFq47UK4bx2JOW75lyO/1UFC3li0yn2G3MlZzFi6Tb68oQYHjCrVSLuv5mqDo9OA2u8TF6x9w2j8C2L+QktwCKzQESIeoFfFfPAOF8AX3S9WKcTJajXfJW6hPotpgUGsxUwjS8a8mAjnT2sNry7kIhUit5dr3GIho1AKm16fOjt8emdF/1Eb4woNR8YmX0vBcHLa2aYtiE2VxK0gTm3KPuogaUVUAmECLPgWK9ykdJP+XElPBHVX+LQgB0bppdHeQeyBfjYD5pwhqhpj397Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tApWIMZaO912qHnzgVfU6tDTZddSnki3baiHmbsKoeM=;
 b=ORekvS5GsTwP/4nnk/ho5aR+VWwq1aIDyIATQRIf0UYNJt0fuTVeOKoWqx1wiUaPetqfg8IuL+GQi9gZ5rdY7wsB6QGMKwZDyRHOlST+0NBubvz33Pe2jJC/Y6YYheo8TT+NEEI/ORDJ/0Kn/9Y+6G/L9mR4xaawkfN8Ee3Xx/pXYvyCTXvwZ9It04xkic/2Q75dImb/0IFq0b2TvH4iT4OqSygyqB40w5FipxE3LDNGVR9kyEo4XNNDB901OJVR4VS75oVUmHwGiDSpvAf4IgIOagzPP7qn6JC1KmdNh6NhPqFu1qPj8C0FfzwfdeZlp6IEirBuxLTEBc2/XRbZ8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tApWIMZaO912qHnzgVfU6tDTZddSnki3baiHmbsKoeM=;
 b=PbdJ6mzny3jLJ2WMRXRjX7nB4ZMaQ8Ew3FO7JQLtL1ZoiVFRBAsfWsR1fv1sGThN/0Rmnkhv5aJEgqgDzZz5oeQgvHmKkIB1hphQFTwPq9mlacGMMgK0y0x7GIo3/paLkko1D1danJwybUDKXOWrP46me/lNeKJKoTkRv0H/OTL54bqUKry9GuchWwlj1o9nbNDJ9HhR0PNISLY4iZb1NXx2I7vdj3l5VH9nnu0heJfGMzBxU0D/Zk1FbRSrC7dslJZ2vT57hXh7rHXX5m9FcAq7H44ABK88O5PJK23PM62v5AAbZyr19PyvCUKXeE14pqmWBXIrE4b3ZF2z0iRf8g==
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:ac::13) by
 SY4P282MB1371.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:a2::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6813.21; Sun, 8 Oct 2023 14:56:35 +0000
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::e39e:17fc:36d8:1ea8]) by SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::e39e:17fc:36d8:1ea8%3]) with mapi id 15.20.6838.040; Sun, 8 Oct 2023
 14:56:35 +0000
From:   Tianyi Liu <i.pear@outlook.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        namhyung@kernel.org, irogers@google.com, adrian.hunter@intel.com,
        Tianyi Liu <i.pear@outlook.com>
Subject: [PATCH v2 3/5] KVM: implement new perf interfaces
Date:   Sun,  8 Oct 2023 22:56:10 +0800
Message-ID: <SY4P282MB108456E39C664F79EC0292249DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <SY4P282MB1084ECBCC1B176153B9E2A009DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
References: <SY4P282MB1084ECBCC1B176153B9E2A009DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [xAU9EoBRPnMxN3DdhbNcR6zfJ7d1j812xI7i1Rqnz4Ym4NO0kHakmw==]
X-ClientProxiedBy: SG2PR02CA0115.apcprd02.prod.outlook.com
 (2603:1096:4:92::31) To SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:ac::13)
X-Microsoft-Original-Message-ID: <20231008145610.7786-1-i.pear@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SY4P282MB1084:EE_|SY4P282MB1371:EE_
X-MS-Office365-Filtering-Correlation-Id: 579365f9-de45-481a-6905-08dbc80ec3a4
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2pLdw1fhNxjH2oJDI7HUaoka2KzQiAM8nDT1rptY4gsQ0pLrQnT8M9GV/QqoIexqrl/g/hMTxV1vfaGgZLtmuFr2npiPSHf71OrD67n9bx2zsfs12Jd5qg6iu77Vv9QkO2RQcSK+iSjCY7kVFMODbvdobHqSUGKtYjbGbcQ2yKqWEmCpbSFI8dMObD4Bnc3Wu9+Gap6KTDnJgk2MY3frRMR2Wwfrpwam3mTQQV5wqrw6TV/LN5mZflIigLNxqafBBKVYoaQVwfiKEU4yIkm5/DYH3jjzyFfEugINJ6ZGFOft/KRvodSATmMNkXU07f+u+M449j4rK92lo5fvDJ681aUcYfz5binCDZ/HX62vJWZ+C7adULT6VuGw4Zvpk/6joMilxKZ5ECDu8WX2ttD3NIVR8OaZtHuD0MuNJgBhgyJf6mOCcFMkbOW5AGM3VANrG5R3jB/3WLJl28YuaE0h/Dw+USOyLgvZc5Nm+5EVMm2Z/WaqPcrUTyj0X6BWD0LXu5Ny3SINWEOi2T1akb0X+HhS3taTjdQWQk1k5FBRw3ZYAX/HvnyVgEpj2ivuYQLwCtNiMQw/NoMVp9YdXG6Kk7lMnkZkIORZt9VcpsLpn8vn4aP01Hrrza/vaNp5yf1N
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dQcWig7s3tkGMgPMPn7D0e6wDdOveeklD1mvV2Ob8/58rQVmgnaV+oXuLiXG?=
 =?us-ascii?Q?brYK1S3PTwjUxk1n4SRhCwaCtD9LlbZBsTpn9KX2ZA8u4Lnsa5pABiO46rxo?=
 =?us-ascii?Q?NyLzAg7Y9YcUFzT2QtbT9TuHius4i4/wLFBbJshBuGY5NAHHu6MM7MSlVgPR?=
 =?us-ascii?Q?7h1CSggW+ELUu76+6FBkeWTfFvq2GmJBn8VrdLCoUnGVVBJjLqU4UkP/MXir?=
 =?us-ascii?Q?NdMPZcAHYeNCmc3LlmnjuGrri3pUMS4cA3IOsMAfA1gsolXQH2dA1SgxURjk?=
 =?us-ascii?Q?KXqFNbIt6LSPYknHLCF/DeeNLB62Dpu5VEIyaeK3ZadjJOnGMT7c11hAMBNK?=
 =?us-ascii?Q?x1TlS1rxQ/dzzWlm4JwKa7sQdKbUU1iDYJBmM8GUqvicHD1cRGKccWAnkIII?=
 =?us-ascii?Q?/G64l/vAK/ZONWWpNYVVOxGMUC1qD3pFwue0NcebzdKLXH9YTXzjK3bA6uwC?=
 =?us-ascii?Q?Zcir8fM0AKxE7QzbYYHYJH9yHaNRJP2bA5REw19e9wWpGg4Xz+VUCaYESNT+?=
 =?us-ascii?Q?s912wDwb3Rx6RnDl1ubwhLzqXsn2mu517qqTP5LgTY3KaMpvaNs1EReQQohZ?=
 =?us-ascii?Q?+d74drTyo0NkHni8A8XkbmVSiPfBa6Zfw3/Z1sAiQrdRrG8etBs88EdBAnac?=
 =?us-ascii?Q?R9m9jNL3RXTLDdlJGi7F4crapL6t+A/fKYKBBcb9Hj6FlTzI6yZ8OMlq6Vwx?=
 =?us-ascii?Q?ia5SvSNtBJuENpKUN0MeH2lY/Qi+4yklcCmEp8DBjM51G39+NmD7h2sxg74Z?=
 =?us-ascii?Q?WU0Zxh19idkV953GH192/9jx32rSjjAYaqeunLaI3xZxGNISgppivfQScmdJ?=
 =?us-ascii?Q?YGebMvyluC3oVdUqRnk7zlsEtzKVKVWxvM2jPYMEJIFnmCWe6j2+xk8FN4da?=
 =?us-ascii?Q?kMSgDTvwm4EwBmmYRTm/77Ct0Ao36JvnhTzL6NfaS1N0huY+OMUoq8oWVD1W?=
 =?us-ascii?Q?Td0MgkK/VRL8r/a7TVLUZsdSXCa6r+h6DGkk0dDUPFpK8CM5d7rSLGbPILBq?=
 =?us-ascii?Q?ub4T2sxrI0IgR44SOznyZ9JmCVUKDPUTUwr8KYJ2LL8Vkejd1Mcovl3aY08d?=
 =?us-ascii?Q?lbKhME6qA00WG1NlP79srFRUB9zNpD7+nrss/b71zKuK/EzxiJvz7lLCwPPE?=
 =?us-ascii?Q?mw7f9PhTWikirWPNJaCN80B5Huc+T0LLcsuJ9ALXP6Vqyha9ss7+H3fNqHsi?=
 =?us-ascii?Q?BgtyHGC14hMbDa67U3hIkT4n7JvyxkZKnAXxGJJQarpK42+83zHR7icnXoXb?=
 =?us-ascii?Q?WHkdbYOOxQJwtbIN66IT?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 579365f9-de45-481a-6905-08dbc80ec3a4
X-MS-Exchange-CrossTenant-AuthSource: SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2023 14:56:35.1163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY4P282MB1371
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch provides two KVM implementations for the following new perf
interfaces, just redirecting them to the arch-specific implementations:

- get_frame_pointer: Return the frame pointer of the running vm.
- read_virt: Read data from a virtual address of the running vm.

Signed-off-by: Tianyi Liu <i.pear@outlook.com>
---
 virt/kvm/kvm_main.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 486800a70..6fd6ee6c0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6018,6 +6018,9 @@ static unsigned int kvm_guest_state(void)
 	if (!kvm_arch_vcpu_in_kernel(vcpu))
 		state |= PERF_GUEST_USER;
 
+	if (kvm_arch_vcpu_is_64bit(vcpu))
+		state |= PERF_GUEST_64BIT;
+
 	return state;
 }
 
@@ -6032,9 +6035,31 @@ static unsigned long kvm_guest_get_ip(void)
 	return kvm_arch_vcpu_get_ip(vcpu);
 }
 
+static unsigned long kvm_guest_get_frame_pointer(void)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+	if (WARN_ON_ONCE(!kvm_arch_pmi_in_guest(vcpu)))
+		return 0;
+
+	return kvm_arch_vcpu_get_frame_pointer(vcpu);
+}
+
+static bool kvm_guest_read_virt(void *addr, void *dest, unsigned int length)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+	if (WARN_ON_ONCE(!kvm_arch_pmi_in_guest(vcpu)))
+		return false;
+
+	return kvm_arch_vcpu_read_virt(vcpu, addr, dest, length);
+}
+
 static struct perf_guest_info_callbacks kvm_guest_cbs = {
 	.state			= kvm_guest_state,
 	.get_ip			= kvm_guest_get_ip,
+	.get_frame_pointer	= kvm_guest_get_frame_pointer,
+	.read_virt		= kvm_guest_read_virt,
 	.handle_intel_pt_intr	= NULL,
 };
 
-- 
2.42.0

