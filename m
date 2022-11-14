Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38BA26279AC
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 10:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236315AbiKNJ4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 04:56:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236399AbiKNJ4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 04:56:37 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3E7BE24;
        Mon, 14 Nov 2022 01:56:35 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id 4so9638496pli.0;
        Mon, 14 Nov 2022 01:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iv8aD5Z+J8UMbfgYhwe609HmQbmCamCps+Dpq149rpE=;
        b=FXStPibLbOG/9CCbZ8D/H9eLK7qnJZTYehf/duOCNvVyF+HgQ1FbkJPuA1PI7t1g1S
         5jJpjSiCiHyl5zFVThANYqAw3RipQ53N4UgzlebIpdwgjLcb9MxmdQaZla4kX7dGCWgh
         3S68ZQ5uCXe3FDytDdpMuH/pBDs8UxEOBoHYPf9GRPZajXfIs0+1E/bwjlW/EC0tySU7
         CuyK3SKCVPIGwObKUXA8JG7JpmFoRenYWTDovPmfBhkvCPFfTI5aRhXiRlJv6jEG3z0m
         9gOYYEl/GGiEbqKheSaGO+Cr2kjgBDKfLyRvxWWXNyqlDXLOuRYogSD5djnIu2CuVdei
         6Zew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Iv8aD5Z+J8UMbfgYhwe609HmQbmCamCps+Dpq149rpE=;
        b=h9NkQVkwh3Fa+4ugDQ61dlICQo5Euxi6dzP7P2Jxz8x+bIif5Ymk3kmfT1xwwQnhpx
         uPtmQiXqUqI3sdO1ZVXH6J7lppJ6GLqh8zHiqli+tHENSDdemeXcwNkb9N+qE4kfkVV0
         QM4hggLEjX6bS+DeSlfZ08PgWHelguzi5sRZBU/aeX8YIQKHuSJ2XkRCNbPITU9Io6lK
         QFDFNSKAliIMqd0bMcHF6rSZL+z3mn6fzofdSklYqpqdOTjX7Lg12CAp06IjZaAqCp/R
         hsuFRdqzJjyIAr4GpoJ/KA8U9D2PJGGkkJtlh7TL8oK9SR14fqs0v37OmJxiVbHtK2PN
         +sUQ==
X-Gm-Message-State: ANoB5pkFAfr1Ovku596H4Mg2nQfiDrzUVDI0IyZmqDceeh3eHx7nMM2f
        YpT99iM7DTMWllOuB1s51hw=
X-Google-Smtp-Source: AA0mqf74+7evEHWgYxy2OtfB5uirGA0xxicccVzJJREgHAU4SQkSiDZxt+Rin/iTcrWvbKAyAIuciA==
X-Received: by 2002:a17:903:552:b0:185:4889:7e03 with SMTP id jo18-20020a170903055200b0018548897e03mr13225424plb.80.1668419794919;
        Mon, 14 Nov 2022 01:56:34 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d29-20020aa797bd000000b0056c6e59fb69sm6266472pfq.83.2022.11.14.01.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 01:56:34 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/14] KVM: x86: Remove unnecessary export of kvm_get_apic_base()
Date:   Mon, 14 Nov 2022 17:55:55 +0800
Message-Id: <20221114095606.39785-4-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114095606.39785-1-likexu@tencent.com>
References: <20221114095606.39785-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Don't export x86's kvm_get_apic_base(), the helper isn't used by
KVM x86's vendor modules.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/x86.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e46e458c5b08..1c5a675dc04a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -463,7 +463,6 @@ u64 kvm_get_apic_base(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.apic_base;
 }
-EXPORT_SYMBOL_GPL(kvm_get_apic_base);
 
 enum lapic_mode kvm_get_apic_mode(struct kvm_vcpu *vcpu)
 {
-- 
2.38.1

