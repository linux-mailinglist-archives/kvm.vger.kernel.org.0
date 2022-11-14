Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1CCF6279AE
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 10:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236629AbiKNJ4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 04:56:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236419AbiKNJ4j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 04:56:39 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0723165A2;
        Mon, 14 Nov 2022 01:56:37 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id s196so9828426pgs.3;
        Mon, 14 Nov 2022 01:56:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sZzbiUUovd/knB9WKfRQOL0A2eGvTbe8l4R1H4rSzDg=;
        b=QWvM9ArtgMtR6hTyVC8lBBUinc428E0xRHcZYLDJKB6peRLsW1DxSnlXIJG8sgAmof
         LOsEvPthMMigNG1sKlwnEhK9gfDKukd/hoVWTW4ahYt6f5tT/p9PqNArh97hi6yFAevz
         1DPACG8BKRKoF7ola4/ogOWRjyfA4+FL87OXbuGmGuQPfB/+agImSuavB/H0cNtEGm2p
         1GgSWBsSdIixxX4r21ig0wUFy+34uBuIpdm/gRrV4bjpbA56L9aNMpDpdXeqH6hJmETa
         wU/MSvqN+1e9ot9ogTqJnNU5qClO9V/WYOPEt1LQqVABpsxuZQCihjd2dzMlMrzUjM1e
         pk/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sZzbiUUovd/knB9WKfRQOL0A2eGvTbe8l4R1H4rSzDg=;
        b=WoiCnxffb5+dk0WSnMBTYc8LkySGdcIG5E/fdjJhIG/wNQQu3L0KK3US2ilhbVH0Ks
         PR2487q3Zu+JPkcHu8SVlxYIhvteMvs2mUwEk+5L04pY5sZvDkDq7qYMK1gLBMWGfIEl
         CmLU9a2xjDAZRcCKXomsEHRa6z89A/6c7Skhr9ZB7m6HG9SNdI5gs18f0Yx5LbAgQ//R
         5/7syfbGG1baC4PRsC+vIWAzfldUUdQVjGzNHJpOOY5NxKYWGvXcTwV+rma6w2UCEoq+
         u8rE6m5im3tRPrUdLc6ahGb9wjiPJcopgs/PqZ3/9htT/tVwgoEqI8iPjADsUn8+DVur
         o3SA==
X-Gm-Message-State: ANoB5pnxFcoZwEulU/dNcTJ7d7oKEkUnVYyxhqq1/98Psmie8pqQMLxx
        8ycTXVBXX6SiQRY97Sr6afUT+MGjHX+zbB3m
X-Google-Smtp-Source: AA0mqf5PDmly7AdCJGPD6R5du9295x5scJD8lpbMqByzhP9dEWBPp7jVslw95qCIeHhiXSB4Hk7zUg==
X-Received: by 2002:a63:d810:0:b0:46f:98ce:2311 with SMTP id b16-20020a63d810000000b0046f98ce2311mr10986521pgh.413.1668419797169;
        Mon, 14 Nov 2022 01:56:37 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d29-20020aa797bd000000b0056c6e59fb69sm6266472pfq.83.2022.11.14.01.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 01:56:36 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/14] KVM: x86: Remove unnecessary export of kvm_set_apic_base()
Date:   Mon, 14 Nov 2022 17:55:56 +0800
Message-Id: <20221114095606.39785-5-likexu@tencent.com>
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

Don't export x86's kvm_set_apic_base(), the helper isn't used by
KVM x86's vendor modules.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/x86.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1c5a675dc04a..38a42ca86ab2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -490,7 +490,6 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	kvm_recalculate_apic_map(vcpu->kvm);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_set_apic_base);
 
 /*
  * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
-- 
2.38.1

