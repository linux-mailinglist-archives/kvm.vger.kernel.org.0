Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 190A67834D1
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 23:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjHUVWx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 17:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjHUVWw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 17:22:52 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3DAC7
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 14:22:51 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-68a6cd7c6eeso126369b3a.3
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 14:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692652971; x=1693257771;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TZjKmN2RwCOaKmK2FOh0/B5JVNZ5GZx+ppkHECabwV4=;
        b=Ytn1S2ChtywK+UFTQgJsDSmGueC/W1riOOQ+i/E0TNd+rxq/9sFkJufp3hCciYfUtS
         mKhC0SN5+CT/cesFvisgkOKIfcAZxRZEvFt7R6J9nQG4AAxaNLIh8u8JAC8IUfW8yJEt
         c6BoR6SRk0/RFht2Lq1/0wTviTg5WvlUpGmVKpay6Ff+XHJ3iXtpleI9+5sYC+Riv0gS
         FZ0EfRCFCEhX0pJqQjlXiEV6g02iGGeM1BMAAFfkSHPSBw+AOr3/l2nfb3A5bn9CF7OL
         1WJmEkVGBMiRaXLdalj6d/syC7V8apkmsXs0wWajN0gk+QHGnhRXYpqWIPBphvyGKDYF
         mMVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692652971; x=1693257771;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TZjKmN2RwCOaKmK2FOh0/B5JVNZ5GZx+ppkHECabwV4=;
        b=Rr1oqYhiBJyNTRvXD/THsdnIXiFCsZg6pWyNNqcF2khM/2GF7+EtJ2W55URCQVFk+z
         jcV7S0Nmg0cfIUWe8P3cbNloFirhaMkNTToJxj73GX+ugCiMIpEsdRj1UAEiBB1HX8uk
         Z4y32/0DVvwNP3TwcS9id6UpVgWk3rBIj8sK1xbKTZAV7CC8fyJm43OInIsfjTiX4i/2
         gL/Bl+Rp/tiguCfuXoF8jXhKTlSypw5YIsYNsvmV5GtTcTqg2iFhwjKExnNo6ysQ/0hl
         jdisckAJRB4s/de9Vb1nPSJDSBxYCessTgSDjUO/8za3MIqTbQobNMeBv07I+LjuFTEy
         9jtw==
X-Gm-Message-State: AOJu0YwMO497kBFuxdfZrd6ac2RN124c1KOtURl3HwdEEpiQbJa/m38R
        J4EiU3+x1fcvlLgDlCxyaQt0HqiZVeFC042N4NADRQ2xI43GV5fb2/MqaysC8nTCvfoCQuQUR3s
        Tob6kRmAcVf708nUwsASV82PAQMtuPUGIZ5i3yyjJCayw4FchNuDVVCvoMH/9YmNe6Kpvc2k=
X-Google-Smtp-Source: AGHT+IEcDg6B/oh1rCoCGlC92/2TOpx8G/XgwPNB4nOK1QwRTXWaoMm1LBpe2JKxMruWdz+Xn7e2Ok5ygaxUgEeMWA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:2284:b0:686:df16:f887 with
 SMTP id f4-20020a056a00228400b00686df16f887mr4852466pfe.6.1692652970907; Mon,
 21 Aug 2023 14:22:50 -0700 (PDT)
Date:   Mon, 21 Aug 2023 14:22:34 -0700
In-Reply-To: <20230821212243.491660-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230821212243.491660-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230821212243.491660-3-jingzhangos@google.com>
Subject: [PATCH v9 02/11] KVM: arm64: Document KVM_ARM_GET_REG_WRITABLE_MASKS
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add some basic documentation on how to get feature ID register writable
masks from userspace.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 Documentation/virt/kvm/api.rst | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c0ddd3035462..92a9b20f970e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6068,6 +6068,35 @@ writes to the CNTVCT_EL0 and CNTPCT_EL0 registers using the SET_ONE_REG
 interface. No error will be returned, but the resulting offset will not be
 applied.
 
+4.139 KVM_ARM_GET_REG_WRITABLE_MASKS
+-------------------------------------------
+
+:Capability: none
+:Architectures: arm64
+:Type: vm ioctl
+:Parameters: struct reg_mask_range (in/out)
+:Returns: 0 on success, < 0 on error
+
+
+::
+
+        #define ARM64_FEATURE_ID_SPACE_SIZE	(3 * 8 * 8)
+
+        struct reg_mask_range {
+                __u64 addr;             /* Pointer to mask array */
+                __u64 reserved[7];
+        };
+
+This ioctl would copy the writable masks for feature ID registers to userspace.
+The Feature ID space is defined as the System register space in AArch64 with
+op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
+To get the index in the mask array pointed by ``addr`` for a specified feature
+ID register, use the macro ``ARM64_FEATURE_ID_SPACE_IDX(op0, op1, crn, crm, op2)``.
+This allows the userspace to know upfront whether it can actually tweak the
+contents of a feature ID register or not.
+The ``reserved[7]`` is reserved for future use to add other register space. For
+feature ID registers, it should be 0, otherwise, KVM may return error.
+
 5. The kvm_run structure
 ========================
 
-- 
2.42.0.rc1.204.g551eb34607-goog

