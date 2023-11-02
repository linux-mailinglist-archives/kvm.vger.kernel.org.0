Return-Path: <kvm+bounces-382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10E8F7DF1EC
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 13:02:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFC2D281B9F
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 12:02:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6ECC1862A;
	Thu,  2 Nov 2023 12:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="T+jOFR+8"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679E5168AF
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 12:02:10 +0000 (UTC)
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875B110F8
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 05:02:07 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-694ed847889so852432b3a.2
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 05:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1698926527; x=1699531327; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ftnYGlHohU4PgAvOLDfsNbFmXMcl+RaArmfMB/fCVZg=;
        b=T+jOFR+8YUBSxO12vO53oCoIukGFpca/JywKIajBwzf3v3VdE/wUsYzG32sjxJVR4c
         +9ZHUOvqPMaGaIUfoSClF44U8nOeXepH6kD0C8KwWbjmNLNzFOn0O47moht18tVoEDv6
         99xwWaKryihz/Euxj8t6JhgQN6gbpmdkpE1LWIYQ/fIi36zj5dirgdtrMqxJd+1o4p1t
         XHsYpr21UJikwH2Cwa10hq/99llIbo33DGLTN34S7daCVPxEd7xF1IIowf13GdD3x4Eq
         WmmpP3yjZQT14KYBbf2q/PZ0E52hnxBNdw9d8U9YqtTK2gK5GWeT0SfdTeHit9XYfOfH
         mVXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698926527; x=1699531327;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ftnYGlHohU4PgAvOLDfsNbFmXMcl+RaArmfMB/fCVZg=;
        b=lctfU+U8+MXJnW8i/yL9djIyNcPrFhM/WNrRNcBnMrONkQ+VU5k/3Pb8i5yvtKWkTZ
         2sMmzQcgcEMUes2hVISHeBxWsaNCYRxHLag9Bz1YongqKDpVkeotdSYmssgrptaLMq6i
         HfDTMr7gcMhFHjoan5OVAYI0DZkliZfLr9T0cxc9l/wUaqPEFHuhBir8T+UYqse/LTLD
         Lf0aFRDiVYeMU1Eud9FOj5ViVxdwMC7+i2QNzCuRT4tQPmUBv42qsB2sR9Cf+8KOt1AA
         TyXPuD44dYusFDH9EhOe3LzfBhEcfFZdP7OHlFZoXSGZca4HH7Js8caGjCJa6BnKSzU7
         x/Tw==
X-Gm-Message-State: AOJu0YxG9bAmLvCmshf+uhYrTWRv53cO7+sRoR6GgUDKeeeqKI1dgavI
	JIftCNpGQursU+qrarE2YPkHvg==
X-Google-Smtp-Source: AGHT+IGak6vYxyYxJboQzPYtlVELlojzQHOYOuIewHMFX+Z9YpUdKomQpySY+4ZD8wRCrq38FcVPbQ==
X-Received: by 2002:a17:902:d50d:b0:1cc:3875:e654 with SMTP id b13-20020a170902d50d00b001cc3875e654mr12967681plg.26.1698926526894;
        Thu, 02 Nov 2023 05:02:06 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id l12-20020a170902f68c00b001cc0f6028b8sm2969008plg.106.2023.11.02.05.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 05:02:06 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org
Cc: greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	tjytimi@163.com,
	alex@ghiti.fr,
	conor.dooley@microchip.com,
	ajones@ventanamicro.com,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Haibo Xu <haibo1.xu@intel.com>,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] KVM: riscv: selftests: Add Svadu Extension to get-reg-list testt
Date: Thu,  2 Nov 2023 12:01:25 +0000
Message-Id: <20231102120129.11261-5-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231102120129.11261-1-yongxuan.wang@sifive.com>
References: <20231102120129.11261-1-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Update the get-reg-list test to test the Svadu Extension is available
for guest OS.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
---
 .../testing/selftests/kvm/riscv/get-reg-list.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index 9f99ea42f45f..972538d76f48 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -49,6 +49,7 @@ bool filter_reg(__u64 reg)
 	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZICSR:
 	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZIFENCEI:
 	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZIHPM:
+	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_SVADU:
 		return true;
 	/* AIA registers are always available when Ssaia can't be disabled */
 	case KVM_REG_RISCV_CSR | KVM_REG_RISCV_CSR_AIA | KVM_REG_RISCV_CSR_AIA_REG(siselect):
@@ -340,6 +341,7 @@ static const char *isa_ext_id_to_str(__u64 id)
 		"KVM_RISCV_ISA_EXT_ZICSR",
 		"KVM_RISCV_ISA_EXT_ZIFENCEI",
 		"KVM_RISCV_ISA_EXT_ZIHPM",
+		"KVM_RISCV_ISA_EXT_SVADU",
 	};
 
 	if (reg_off >= ARRAY_SIZE(kvm_isa_ext_reg_name)) {
@@ -700,6 +702,10 @@ static __u64 fp_d_regs[] = {
 	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_D,
 };
 
+static __u64 svadu_regs[] = {
+	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_SVADU,
+};
+
 #define BASE_SUBLIST \
 	{"base", .regs = base_regs, .regs_n = ARRAY_SIZE(base_regs), \
 	 .skips_set = base_skips_set, .skips_set_n = ARRAY_SIZE(base_skips_set),}
@@ -739,6 +745,9 @@ static __u64 fp_d_regs[] = {
 #define FP_D_REGS_SUBLIST \
 	{"fp_d", .feature = KVM_RISCV_ISA_EXT_D, .regs = fp_d_regs, \
 		.regs_n = ARRAY_SIZE(fp_d_regs),}
+#define SVADU_REGS_SUBLIST \
+	{"svadu", .feature = KVM_RISCV_ISA_EXT_SVADU, .regs = svadu_regs, \
+		.regs_n = ARRAY_SIZE(svadu_regs),}
 
 static struct vcpu_reg_list h_config = {
 	.sublists = {
@@ -876,6 +885,14 @@ static struct vcpu_reg_list fp_d_config = {
 	},
 };
 
+static struct vcpu_reg_list svadu_config = {
+	.sublists = {
+	BASE_SUBLIST,
+	SVADU_REGS_SUBLIST,
+	{0},
+	},
+};
+
 struct vcpu_reg_list *vcpu_configs[] = {
 	&h_config,
 	&zicbom_config,
@@ -894,5 +911,6 @@ struct vcpu_reg_list *vcpu_configs[] = {
 	&aia_config,
 	&fp_f_config,
 	&fp_d_config,
+	&svadu_config,
 };
 int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
-- 
2.17.1


