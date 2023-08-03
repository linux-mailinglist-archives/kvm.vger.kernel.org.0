Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A7B76EBA4
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 16:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236610AbjHCOCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 10:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236424AbjHCOB0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 10:01:26 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60AE4224
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 07:00:53 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 46e09a7af769-6bcb15aa074so710181a34.0
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 07:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691071250; x=1691676050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e0/jj8XZe2G0/16QSZpeAFh+25Re5O97IU/+Y05CM7U=;
        b=TMj2mDCqaHn1I7iRa95PfoZqVLDu/uigTDCqaamPwaAEITunT4atuoTgcUVlgBPnRw
         r9t77Nd1b81S5uWJ2kTsuaAKAZzGaDh3aQhlysDm3e0smm74UJk7QqrGyKlHgolWQ1oV
         BYTvJZWl3coXumhKXwtQCBRKooFyE83LZLiX//OaK/MO+9qMKtAitngfpAKeg8sHCatd
         FnzumKuNswefhxaXUjYJdke2RFBYXqpDcyicniWDFkFcx8vsBTuROU4lZYSlvhS9QyWf
         +rknPZGQ23JeiHt4vjxadRmvReQ8JARfNQ/8FKj3cy5Z1CFzxuegd967m0jIQ8Eia0qn
         cHCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691071250; x=1691676050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e0/jj8XZe2G0/16QSZpeAFh+25Re5O97IU/+Y05CM7U=;
        b=Q5UVK8dgqGxNWrk0LT/BrDCUybIYpoYz9mNZmp5iXaxUbBGkA1fKIUm1RgH29KXYg/
         W8TOlBbM8fWprSdcH8ddjbQZGYcwdnFUu+3R9ADaMDPoVnln/2B2by101dZb0bFdkZmt
         3/7dURPuGu8OjKSce62FIYXUEwRDF014UYAZPdZzbbg2Sz/IA3mJ4t3tq6dlMF1q3JKX
         Id9CuBrz9SbLDJeptWQ4TRLul5NDTilLaj7UOlu7dKL2Hwl2W5w6dDbunA9iGTO3ZZch
         lpaKr5ep8iByJo8h5cNBmcWtZEcSxB7WZphvv2QluL1NaMyBCHmSHGVQwtxoPMuD5eDD
         kxow==
X-Gm-Message-State: ABy/qLbBPeV8nFf2YqiJWbOQwB0BtkhQC+vr+XfR+UzaWhuax8o+hx+C
        dSiDT0zt7QIg7UVzRxMFmhxDVA==
X-Google-Smtp-Source: APBJJlFN0Rk5STEm5jArdHCeyZjSMbEocsbopm5itxXndoi1sdc8VNe6PTE/U5cndrjgITYvO07ytA==
X-Received: by 2002:a9d:4f1a:0:b0:6bc:b06c:9277 with SMTP id d26-20020a9d4f1a000000b006bcb06c9277mr6918980otl.7.1691071250017;
        Thu, 03 Aug 2023 07:00:50 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id e14-20020a0568301e4e00b006b29a73efb5sm11628otj.7.2023.08.03.07.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 07:00:49 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v3 07/10] RISC-V: KVM: avoid EBUSY when writing the same machine ID val
Date:   Thu,  3 Aug 2023 11:00:19 -0300
Message-ID: <20230803140022.399333-8-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230803140022.399333-1-dbarboza@ventanamicro.com>
References: <20230803140022.399333-1-dbarboza@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right now we do not allow any write in mvendorid/marchid/mimpid if the
vcpu already started, preventing these regs to be changed.

However, if userspace doesn't change them, an alternative is to consider
the reg write a no-op and avoid erroring out altogether. Userpace can
then be oblivious about KVM internals if no changes were intended in the
first place.

Allow the same form of 'lazy writing' that registers such as
zicbom/zicboz_block_size supports: avoid erroring out if userspace makes
no changes in mvendorid/marchid/mimpid during reg write.

Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_onereg.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index e752e2dca8ed..818900f30859 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -235,18 +235,24 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
+		if (reg_val == vcpu->arch.mvendorid)
+			break;
 		if (!vcpu->arch.ran_atleast_once)
 			vcpu->arch.mvendorid = reg_val;
 		else
 			return -EBUSY;
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(marchid):
+		if (reg_val == vcpu->arch.marchid)
+			break;
 		if (!vcpu->arch.ran_atleast_once)
 			vcpu->arch.marchid = reg_val;
 		else
 			return -EBUSY;
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(mimpid):
+		if (reg_val == vcpu->arch.mimpid)
+			break;
 		if (!vcpu->arch.ran_atleast_once)
 			vcpu->arch.mimpid = reg_val;
 		else
-- 
2.41.0

