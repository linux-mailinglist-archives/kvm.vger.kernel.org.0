Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24807559A6
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 04:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbjGQCfv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jul 2023 22:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbjGQCft (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jul 2023 22:35:49 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11olkn2096.outbound.protection.outlook.com [40.92.18.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CA5187;
        Sun, 16 Jul 2023 19:35:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eeaTsF5Ccu3og/Pntzm4Uu+1daf4nprT/lwW1XKZWFwP1r62F/r8EzfqW1dO8oQlKB+TB6r7jvaki2KGLGw4gGfhokTkFRBL0C3raYhsYETaja2qLO2KQY1nn1AKLkyeSEQsReBsZNGAh7K4N2+nT6Q+XZF4uoVrV3Wn7H9mdxXVEZH9l7EOV/VwPBwYKlhQphvKK7PabOMu6fJO7E52egZBQ0WSZZNUDxOWsP3akbvetpmb5kcudZFHcWM9gQPMmxjqF3VbbkRKVbzUXVMl7DdN8dz2zjFPx7klTXP6fqCmejJboKMJHqGdiUR18UV7od7dwJOn027j1E93c7YNOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BUu4/aGIansB7VuFhF6Ja5PFVk0zDd5wwRpWG4Uo28w=;
 b=nBbFb4axeJ/Dk69KvD8j/zDmFIDSN/B5fpUxi09F91AzTLvbgG2TWmEY+R2KGeUcnFGDh0fCtRm/6ku8fxwVYX1zGss47kiq2/q3Q0mCkesjN7IetK+QzsvK2FU7gX3yo3wM8Pgy5tuUsBcLcCeC1/1EL+eucg/QnF7kzsFn033ObIUbjfL6E/etwm0Nw4pF7OC0PyPPFCdR1O2X5ZV4JFMxUsmdhv2nO+oNf4RoQdovoWhNjOlDUeOL3FnbIKR+8bVqCJd/pPnjWcPPwFfHDw/7zpq+r4T+Ov4STBv6TJDrByQEknORNeHycXvEx8I9IkgU6cMGmEuiiky7lnSpAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BUu4/aGIansB7VuFhF6Ja5PFVk0zDd5wwRpWG4Uo28w=;
 b=OnFy4+DfGgBImTm/+55lKEsiO2Whiy78pmetrS8O/dHyXiZ6y2BkWw7NCWOno/iFY6Z0x4mk2VOB1Jg8BqDViQWiYKQ+JGMcTdetearI2HeDZqehXXu5pM8QHvXOg4T+KT6gvMJ2qAtgDbqh+vN2de45ZEgUU/XREV8eGBzP2uvutyEE0RGuQXZJD/m2CyqFFGTAxJb0FBasU0Jak2JsY168Y0Ma30V1TWnzjWJflQ7nNgQFXDRlHfIi//P88sYHaOl1KKtVMkeaE42H0dW/Jyv4k3xjI/9IVSLzCu4y1W3Raom5wZw+qsjHRmH+NXBF8W84ZQ0ClO2aCn9H3bqvSw==
Received: from BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
 by PH0PR03MB6512.namprd03.prod.outlook.com (2603:10b6:510:be::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.32; Mon, 17 Jul
 2023 02:35:46 +0000
Received: from BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::d952:a79b:d824:3b0]) by BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::d952:a79b:d824:3b0%4]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 02:35:46 +0000
From:   Wang Jianchao <jianchwa@outlook.com>
To:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Cc:     arkinjob@outlook.com, zhi.wang.linux@gmail.com,
        xiaoyao.li@intel.com, linux-kernel@vger.kernel.org
Subject: [RFC V3 2/6] KVM: x86: exchange info about lazy_tscdeadline with msr
Date:   Mon, 17 Jul 2023 10:35:19 +0800
Message-ID: <BYAPR03MB41336B6D3290591092F3A0EACD3BA@BYAPR03MB4133.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1689561323-3695-1-git-send-email-jianchwa@outlook.com>
References: <1689561323-3695-1-git-send-email-jianchwa@outlook.com>
Content-Type: text/plain
X-TMN:  [dsYfPumXbQ7BslJksmc2vPl9tDiNGnt/wTx4e61/i7E=]
X-ClientProxiedBy: SI2P153CA0023.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::6)
 To BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
X-Microsoft-Original-Message-ID: <1689561323-3695-3-git-send-email-jianchwa@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB4133:EE_|PH0PR03MB6512:EE_
X-MS-Office365-Filtering-Correlation-Id: e16679b7-4076-4bcb-9cb4-08db866e8614
X-MS-Exchange-SLBlob-MailProps: Cq7lScuPrnqpUrHVo6HYXI9uowj33ZBSsqF9XXx3JwdM1zoaAT1sevltCFgyhfczsjjpgQJUDHuUoy3mgreuMBDDdSvE7mCYMaf5e2MOl75wqKuqTdws8iy1bT2APnZxYZR9Co1Kkn/PWlKezgI21KxmGwfnrYhXn3pJekgVNo/W2VMO3L+flnZ3ZDTaGG/kywp971RwVEr2q1zqfsmVipQUxDdjSDK6ZJAR7RtmpggfDCce/Q4lrvnroUa2K7MLcRxe9LGHilisP5WzfzjLvQzFiDbBSuRdmhFci2dKUShq4goD+7SCVXylXOkqmmnD7pTzdnR8IE28fQbIAuJKSPWWtm0vhp3v6micWL5vke60kBDa5w3exPi4G2nH0EMZxOEjnf+VSw9IfP+4yd3+Q/lGPH0SXxVCcrp7zRimvmXec6ViflLYc6lGkaZvKw5S0Wu5259G1XCz2WiCkg162E3ZqpSfYt/YllQqE1Te/1pamTOCMP8x6EoVkqYjd9PPfSxV4ukMFOnLyZ2btjhv7DndzZnd1J0GXlB2dDYP9leOrPQE6j2XGCaM4QyY4kP5ElbGfgn7nVMpdVX06p9SSnJVgKLzyKkJsD6iv3XlRY+iw0Tq+e0TWe1chVM+lDpHsHhQPNOk51EHC8HVgxkEdU8Ej1xre+xPlSUut2QcajhTd1yECrNrhViMp7W/oyHLSeaqDnTY3Wsm1DhUrOuOO+XfTTv5dg8sjZ2Sx6Dj4nHmWAGpBt4wP9AhjK6C55/jzSZxmaso7Fc=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AE2p1cdABd8NqaoQELunsTEo4O36jwWqvLn2p1f5PfcXvhzC/wGaQR9My0HsAHQLD3Tn8mM4G3/pqBIRk+XG/yMInUxUW7Ynt8lpoxt+PcxAicYfm06rZMjpFlllVRkArTCySn05zIBbSnoMrwQfwnumHip+Aqe2aXNwYigHbSFBVUxWaf3RVbUYGLS7EAT41DS4oArTAe2LcUogcLvRDCH9ByLTeyNvTnx4uT8lMFHrxH/sMFW0pXAuitOqF1YgJYDZWm9Wim8xvvx2HRMSMW6qyGKIUO/vgydWHEdAyUNCRg+NYqTjSRXoWkuksqp2OjjKppGEj5ASi3Uv4j7xaxOCL5PKBj7BkqqJ+7PHT/5EVL+bHK1lY99CcRLTrKh1mmyM3y+aeDtUrySjT9d+vXhDMDJcX4o3K87LBItEaHFfomhL/nJ/3s41M+4RQBVGE+CZZDzGDX3nQlow1NFn3xRjkmAG9ea2mHxkvsS/nADTmcsdtQ+e9SjT+ONmNDYiDTR0v5FdsQq2cWvmHcCF6Moclv+8IHnqaQNZz8hZu6Th0SDbxh62li6u+k74fehJ
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pxz8BtPzKUmHu4kbOnNwLAoF3y6HbNn6ubnFGKOuj93b2TRsBbdaU6SXn7c4?=
 =?us-ascii?Q?o4qCcPJxNeUWSH4fOCyE5kfzdDaHLtIXCpmo5NV5stVwnGICnxjHio7UlpEA?=
 =?us-ascii?Q?dOqxe7tKDnjD+2k/42Y3+r91bdtPGL6tt1PSYOSUf7lUmuWvhfZU1KFI9w7w?=
 =?us-ascii?Q?TiTJ7C+3eLKy4fHjxwcT6lipSAYJFVvpEh4OpPF8OYxBaFUlCrT+xwCv7HwY?=
 =?us-ascii?Q?Rpovt9+v2+9qIXg6T/by1iuqlma6Qb37lhhpON6bXbLj9NT2TL7aF8tUtrYN?=
 =?us-ascii?Q?nVnCIemDmaj9HIEgvxcDLVontNTp+003z7qX3k1dyQr3d/G8oFgzJ3CXWOEk?=
 =?us-ascii?Q?K3gaZxLv7XV+Gj8kkH12xGfb+/b6w2urngs5pyJU4qAsysKNQ+CjjH7/eMpI?=
 =?us-ascii?Q?LOg7FfLXXX9a20+AFiqY1X1Xh2pJ4tyPIz/HgFH+ut2hE3ng4ImcQB83CxaG?=
 =?us-ascii?Q?znijira++6JLafugzudEPn73Kv3XG1yGDYbSMm3QYTLwsFW70omR7bQWkEny?=
 =?us-ascii?Q?MRrdgksGW1yiV4vmRWxm7Wh8V7oGHjkWd76/qhfDPDD3rGLeYbJ1DfyRZcub?=
 =?us-ascii?Q?Ow0LEr18l4vzz4+I6A6WRqPIReJf0aWP3/hXLP9bu8jHXMfXzbVpg2Q7Z1rL?=
 =?us-ascii?Q?0X81ElTWqBpaSsiPsG+6YsFlcUhdoT4Vp7gLXjcaiupkyQLhp5OoeA2At1+v?=
 =?us-ascii?Q?v0nPrftZCV1znyxSA9rJUSKyFEbcnv64wIasr6xMqNmwETx+LQpubiq6ZgEB?=
 =?us-ascii?Q?zkZyOHA+FBK2seEZIJWjA13yWcBXd6ExKMxiJyODRAm9jp8jU+mprllvYgYB?=
 =?us-ascii?Q?ZXGBtaDW5/JwKuEgwoy9bANxrJgnRqQhZAUu9qdIYFEFaxPGskI8oriDgCHb?=
 =?us-ascii?Q?xsgGtH6AzabaVkkx/w9O3J9qircnUEaKQyQZzQvm2MT2vZYw9uAH221Mfm3/?=
 =?us-ascii?Q?wVYIOdcU5mr/Kxyh/uSBKamIDa+lGB4ix6f45YxilepUpJKiREMP5VlHv8U1?=
 =?us-ascii?Q?WORuA+eCusTIe9WBOLxxX968ev3R9Hz403BOicMXFb3KX6ir7ql/AM4gextL?=
 =?us-ascii?Q?URv4znBeiYkxdUDFJq4nsJcdlRnNXvP6QhVphHTbAem6qLseoEF6siwgy5M+?=
 =?us-ascii?Q?dA07ydSJYw28G66afd3845v3gh3Sy/vYtAHOSzlSI7JJciiuKBT0CQI6WDI3?=
 =?us-ascii?Q?Sg5pK1LoRDeny1wJBv4VeTv36ANuio3Ibg/Wj/xOf7mbSgSf2UxRJNqXNpA?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e16679b7-4076-4bcb-9cb4-08db866e8614
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB4133.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2023 02:35:46.0541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR03MB6512
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The lazy tsc deadline hasn't work in this version but just tranmit
the physical addrss from gust to host sdie.
 - Add data structure in both guest and host side
 - If feature is enabled, set msr of lazy tscdeadline when guest
   cpu is initialized and clear it when cpu is offlined.
 - Add msr set/get emulation code in host side.

Signed-off-by: Li Shujin <arkinjob@outlook.com>
Signed-off-by: Wang Jianchao <jianchwa@outlook.com>
---
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kernel/kvm.c           | 13 +++++++++++++
 arch/x86/kvm/x86.c              | 13 +++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 28bd383..439e4a7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -713,6 +713,10 @@ struct kvm_queued_exception {
 	bool has_payload;
 };
 
+struct kvm_host_lazy_tscdeadline {
+	u64 msr_val;
+};
+
 struct kvm_vcpu_arch {
 	/*
 	 * rip and regs accesses must go through
@@ -944,6 +948,8 @@ struct kvm_vcpu_arch {
 		struct gfn_to_hva_cache data;
 	} pv_eoi;
 
+	struct kvm_host_lazy_tscdeadline lazy_tscdeadline;
+
 	u64 msr_kvm_poll_control;
 
 	/* set at EPT violation at this point */
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 1cceac5..91eb333 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -67,6 +67,7 @@ early_param("no-steal-acc", parse_no_stealacc);
 
 static DEFINE_PER_CPU_DECRYPTED(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);
 DEFINE_PER_CPU_DECRYPTED(struct kvm_steal_time, steal_time) __aligned(64) __visible;
+DEFINE_PER_CPU_DECRYPTED(struct kvm_lazy_tscdeadline, kvm_lazy_tscdeadline) __aligned(64) __visible;
 static int has_steal_clock = 0;
 
 static int has_guest_poll = 0;
@@ -379,6 +380,16 @@ static void kvm_guest_cpu_init(void)
 
 	if (has_steal_clock)
 		kvm_register_steal_time();
+
+	if (kvm_para_has_feature(KVM_FEATURE_LAZY_TSCDEADLINE)) {
+		struct kvm_lazy_tscdeadline *ptr = this_cpu_ptr(&kvm_lazy_tscdeadline);
+		unsigned long pa;
+
+		BUILD_BUG_ON(__alignof__(kvm_lazy_tscdeadline) < 4);
+		memset(ptr, 0, sizeof(*ptr));
+		pa = slow_virt_to_phys(ptr) | KVM_MSR_ENABLED;
+		wrmsrl(MSR_KVM_LAZY_TSCDEADLINE, pa);
+	}
 }
 
 static void kvm_pv_disable_apf(void)
@@ -452,6 +463,8 @@ static void kvm_guest_cpu_offline(bool shutdown)
 	if (kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL))
 		wrmsrl(MSR_KVM_MIGRATION_CONTROL, 0);
 	kvm_pv_disable_apf();
+	if (kvm_para_has_feature(KVM_FEATURE_LAZY_TSCDEADLINE))
+		wrmsrl(MSR_KVM_LAZY_TSCDEADLINE, 0);
 	if (!shutdown)
 		apf_task_wake_all();
 	kvmclock_disable();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6b9bea..dbbae8f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1551,6 +1551,7 @@ static const u32 emulated_msrs_all[] = {
 
 	MSR_K7_HWCR,
 	MSR_KVM_POLL_CONTROL,
+	MSR_KVM_LAZY_TSCDEADLINE,
 };
 
 static u32 emulated_msrs[ARRAY_SIZE(emulated_msrs_all)];
@@ -3873,7 +3874,13 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		vcpu->arch.msr_kvm_poll_control = data;
 		break;
+	case MSR_KVM_LAZY_TSCDEADLINE:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_LAZY_TSCDEADLINE))
+			return 1;
+
+		vcpu->arch.lazy_tscdeadline.msr_val = data;
 
+		break;
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
@@ -4229,6 +4236,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		msr_info->data = vcpu->arch.msr_kvm_poll_control;
 		break;
+	case MSR_KVM_LAZY_TSCDEADLINE:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_LAZY_TSCDEADLINE))
+			return 1;
+
+		msr_info->data = vcpu->arch.lazy_tscdeadline.msr_val;
+		break;
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MCG_CAP:
-- 
2.7.4

