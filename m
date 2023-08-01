Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127AD76B874
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 17:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbjHAPU0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 11:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234056AbjHAPUW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 11:20:22 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002702107
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 08:20:15 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5646e695ec1so599977a12.1
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 08:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690903215; x=1691508015;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a5ITWAYN9R9rtf6GERIf9S362dBjLzTbE/fVZh0ZgOI=;
        b=fTiv3bmYN2oeWLkbMRJWsRtibsFGBoi0gQkakqnsftyey8XKIY3KI9TWKC8m7nSIjs
         NU3H7wmRc2rc7oOlaOdQL2IBo45YKH5vcbK0iGjj0t4gfvif1gUgKclwpH/iyXmxh1NC
         3xDB8SEk5B/REEVEbmivjGhpoLf7jrnXFq/6HiJ5bOtUsLoETZHjbgsRNPpMjw+B5Eqx
         Kk721CF0oK4/0A+jq8UCjBsKLFh2/nHmEeOqzZNrY+cZac9cU8hOVCWV/eZ7Z3XeSSHj
         Tfpkt3e+/dxWeOl1WibUD/ZMPoJo1dGQoeKBly6GsqqSic3dS7+AYCkOAScuEABTaNdU
         4mzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690903215; x=1691508015;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a5ITWAYN9R9rtf6GERIf9S362dBjLzTbE/fVZh0ZgOI=;
        b=ap9C7hQ6LsMFhIDiCoIrwgeLtnMpNM2HltZrX3mYYV5nAfXylKsvv23ESCkH9YJWA9
         FzvXt6JTnr5nXiBQ/rhK80JWS7UC+C7pgTdFiUAdga3MRd106rw32XQjPqi7cSYaFU96
         Gk4up0tvlxNe1xVQR5uzGfqTbZQYOnRWNl9WRaHeuocuN5g6vvBVHdB8UcBvplDUpyj0
         fqU9VHnmLQCCcz7Yao7ItB6i5TQZS4XK7ZuHPZchRqpEO81XV5M5Xzius06KOMTWWU21
         hzG3U5cFd1NK1E45VH1peAFE5O9zOt+kRvdb3cpzmhsLPA4E3ws/xM6dyk3LyM9cxBlE
         G5VQ==
X-Gm-Message-State: ABy/qLYmePOxE5PQGjZfbP0P+TsvQcF14QexJo10ldOGso0EtfZkzG80
        yexjEyMRp6wt3vduxMQ9krpZGR/4PeJR7UNE9fvcAVputgHT6/icuMmooArO+k1dsO64tmSa3/w
        CmHMidllEHgbTdOa58QK93NBQi/de0oIYefoIr7CFg88kp6Z8VR82LS2LoQ3wDuPjCrDvTHc=
X-Google-Smtp-Source: APBJJlEnPd5fAD0Aj5PY28l23CVy0dGlj5CAymKDeYm7SNgmyFCz9I6QMeDLMfXxJSbBI+IkBdoRqH8Wa5L+RyznOw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:903:1cb:b0:1bb:cf58:532f with SMTP
 id e11-20020a17090301cb00b001bbcf58532fmr62253plh.0.1690903215344; Tue, 01
 Aug 2023 08:20:15 -0700 (PDT)
Date:   Tue,  1 Aug 2023 08:19:58 -0700
In-Reply-To: <20230801152007.337272-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230801152007.337272-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801152007.337272-3-jingzhangos@google.com>
Subject: [PATCH v7 02/10] KVM: arm64: Document KVM_ARM_GET_FEATURE_ID_WRITABLE_MASKS
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
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add some basic documentation on how to get feature ID register writable
masks from userspace.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 Documentation/virt/kvm/api.rst | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c0ddd3035462..e6cda4169764 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6068,6 +6068,32 @@ writes to the CNTVCT_EL0 and CNTPCT_EL0 registers using the SET_ONE_REG
 interface. No error will be returned, but the resulting offset will not be
 applied.
 
+4.139 KVM_ARM_GET_FEATURE_ID_WRITABLE_MASKS
+-------------------------------------------
+
+:Capability: none
+:Architectures: arm64
+:Type: vm ioctl
+:Parameters: struct feature_id_writable_masks (out)
+:Returns: 0 on success, < 0 on error
+
+
+::
+
+        #define ARM64_FEATURE_ID_SPACE_SIZE	(3 * 8 * 8)
+
+        struct feature_id_writable_masks {
+                __u64 mask[ARM64_FEATURE_ID_SPACE_SIZE];
+        };
+
+This ioctl would copy the writable masks for feature ID registers to userspace.
+The Feature ID space is defined as the System register space in AArch64 with
+op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
+To get the index in ``mask`` array for a specified feature ID register, use the
+macro ``ARM64_FEATURE_ID_SPACE_IDX(op0, op1, crn, crm, op2)``.
+This allows the userspace to know upfront whether it can actually tweak the
+contents of a feature ID register or not.
+
 5. The kvm_run structure
 ========================
 
-- 
2.41.0.585.gd2178a4bd4-goog

