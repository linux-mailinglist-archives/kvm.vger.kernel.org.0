Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99F47A6A2A
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 19:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbjISRut (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 13:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233001AbjISRum (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 13:50:42 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC24D6
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 10:50:28 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59b6a51f360so67437087b3.1
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 10:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695145827; x=1695750627; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NNgnTGU4YpsPoVFc3PtBmlT7XDV3ZwiZBqdVlE5z4mo=;
        b=hz0YU6pNsOErHC0u0JJLS//HILuF3SAwtXIqX5jWQEP8FCBvdGgKJSmdScNU8+f2cb
         ZlHM+Bc0WIlmTxGTyp3YelzvvgS2sHTZe4+LHXv+anQBhgCLX8Tnttrcu808wr+qTeVy
         ETGZFYos2AyOVdgZUVK6Jl/qDvuyiqatzFXemm2tHjs/NKn37Jr3xQt4EzZv10ADzR8f
         jCc0OJE4vxb/Zumbf0CN3Mgt3AP9QtIoXcmMboBnnXpTjRxkpGpBF8N4ezGPBl3yyUdc
         gu9tDVZM4aVFEM8yd8gAxsQ6q1TZTR82EoFif2f17FsBY4CbQVigD25gD+HryqMPnSsR
         nviA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695145827; x=1695750627;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NNgnTGU4YpsPoVFc3PtBmlT7XDV3ZwiZBqdVlE5z4mo=;
        b=pzPVPGNbDYCL5bS1drCHYAKjvrs2e6Pyi0Rj2H+YxzIPps+Z66uly73lyZgcVk166H
         jt0UdkWl2bb9U70eY4Y6dcW81DsAr5gDwg7nfk6a741dG+faHLktKr9w8p20D96ZIAs3
         fyg4stK+L4NKMztnUAiUjN413ptEdtsAw0YmWDLQcUU/TetqpeRgmRkZR7+3Jr8FbF+E
         xb9flA1LocywkFQh/p2csS1eZIgIvk3pDxxMNGgJgNOfQn9yYB3XHwDsmMuNunBFLaW2
         +V8XeRBiGMyd3fqolgrY23CIZIjUeXXq0TmH51QrcTUla1XbpJZOLYeD72Q83u3DF3Xx
         qmng==
X-Gm-Message-State: AOJu0YxbvxtLd32UdRRJexhsneJzhF2EfpAyOjaQJG/mGTs1h88j/EUS
        swW6DO9F2ILANROhFnam/CE54p9LZH3Toz6Ql8clFFo/rtEMxB0Lwsqa4aGln9588N2TlIzoQ8r
        hVqypJXfAr0J1pL8Rum6tLDs1PjNVP/kSJmH0Izm2/vWRp86e+52bhQfSPiX0a2kTGV9SyFo=
X-Google-Smtp-Source: AGHT+IEu56riQdG7TAOdvAS2CxA7zpebYty6rvbyBf23leV5Zz1VX6/KIxfw4Os8Nq3PKH1WkglynetaSy09CpEecQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:8d0d:0:b0:d84:c154:9b7d with SMTP
 id n13-20020a258d0d000000b00d84c1549b7dmr6424ybl.12.1695145827325; Tue, 19
 Sep 2023 10:50:27 -0700 (PDT)
Date:   Tue, 19 Sep 2023 10:50:14 -0700
In-Reply-To: <20230919175017.538312-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230919175017.538312-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230919175017.538312-3-jingzhangos@google.com>
Subject: [PATCH v1 2/4] KVM: arm64: Document KVM_ARM_GET_REG_WRITABLE_MASKS
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
 Documentation/virt/kvm/api.rst | 42 ++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 21a7578142a1..2defb5e198ce 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6070,6 +6070,48 @@ writes to the CNTVCT_EL0 and CNTPCT_EL0 registers using the SET_ONE_REG
 interface. No error will be returned, but the resulting offset will not be
 applied.
 
+4.139 KVM_ARM_GET_REG_WRITABLE_MASKS
+-------------------------------------------
+
+:Capability: KVM_CAP_ARM_SUPPORTED_FEATURE_ID_RANGES
+:Architectures: arm64
+:Type: vm ioctl
+:Parameters: struct reg_mask_range (in/out)
+:Returns: 0 on success, < 0 on error
+
+
+::
+
+        #define ARM64_FEATURE_ID_SPACE_SIZE	(3 * 8 * 8)
+        #define ARM64_FEATURE_ID_RANGE_IDREGS	BIT(0)
+
+        struct reg_mask_range {
+                __u64 addr;             /* Pointer to mask array */
+                __u32 range;            /* Requested range */
+                __u32 reserved[13];
+        };
+
+This ioctl copies the writable masks for Feature ID registers to userspace.
+The Feature ID space is defined as the AArch64 System register space with
+op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
+
+The mask array pointed to by ``addr`` is indexed by the macro
+``ARM64_FEATURE_ID_SPACE_IDX(op0, op1, crn, crm, op2)``, allowing userspace
+to know what bits can be changed for the system register described by ``op0,
+op1, crn, crm, op2``.
+
+The ``range`` field describes the requested range of registers. The valid
+ranges can be retrieved by checking the return value of
+KVM_CAP_CHECK_EXTENSION_VM for the KVM_CAP_ARM_SUPPORTED_FEATURE_ID_RANGES
+capability, which will return a bitmask of the supported ranges. Each bit
+set in the return value represents a possible value for the ``range``
+field.  At the time of writing, only bit 0 is returned set by the
+capability, meaning that only the value ``ARM64_FEATURE_ID_RANGE_IDREGS``
+is valid for ``range``.
+
+The ``reserved[13]`` array is reserved for future use and should be 0, or
+KVM may return an error.
+
 5. The kvm_run structure
 ========================
 
-- 
2.42.0.459.ge4e396fd5e-goog

