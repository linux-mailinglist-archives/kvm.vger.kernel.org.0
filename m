Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA557CD0B8
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 01:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343819AbjJQX0l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 19:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbjJQX0a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 19:26:30 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C67A103
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 16:26:22 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5893cd18b10so3521198a12.0
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 16:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697585182; x=1698189982; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bv6pLgT3niI5QMgEV9JgHmwHVkKxDi1wi/ZrGYG6pjg=;
        b=ohfoXsCT8bR51uGwjI55KdZCgfmNKHTNVLSmGsjppICBxaOBPCt1rr4xA2KvjSgjp8
         5CUsKzAiwOzJlqGH0+Py4lcxfQiTOS2YLGZGgoODppsv2N4sFblP8fnCf3yvnV67nc+G
         PiGYpm0yvBYG8PY3VUWvHQMn69UJQydb3P+Lhx+CEfztuPI1NEXgxeFprFi+0ZvccSM6
         dzSezuv1nmch6G6t174IkhCiOQB6vFpKnzi1rXSdQBXBQgPLxN/TocczZSqkm327xeFY
         LtBFEUaUfmV5d8I2FFdhttupWoIKLacIQbla2+RAvbSZPUK2HjlzMGhERYVEXhSqm4iz
         88Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697585182; x=1698189982;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bv6pLgT3niI5QMgEV9JgHmwHVkKxDi1wi/ZrGYG6pjg=;
        b=vnppz1PfKRav0n6DtoNh/BXhQKWsbsNTYlpTuq8dLFjFKX0gLQ5NxPlLWgjWph1jvI
         v4neRCQdE0O1WmUXp0ecohQJSJWWBgQvrXVansjATuRyfnU+PJ4Fmp+1hfXDVFzolm5P
         5YXNebNnqRH+EF+LZibsfLIDIqCZUFt6EgtW/AYbTdRP18fcvmhPceyHZj9dOpW7MsD4
         1v5v+enr0wEBjuU3loU35CF2EDdb6exFHj7UvvfVhQ93q2IQ5c25QZYM/TNtn+6gTwYN
         SvV4TWYBbk4OxISgh57kLgqw4fbNJCwuM+4ZBevIkjMjahqSUe6z6I51uNpEpAUTsR+t
         tHSA==
X-Gm-Message-State: AOJu0YwzKKcefCKH6xUQBfWjCDl5AJoihd4Exj02ItMpbFJoSxojoo1H
        xv98LlFT2Gt4uQigcxbamtnmXGt9yKB7
X-Google-Smtp-Source: AGHT+IHobD1UfT/vL/XwFh2pm8crYWO3oS0sT9ep5edXvwbbNrgraJv3wFMyWgNVhRQEDNotpD5JOEsnu1BF
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:6a02:710:b0:5ab:f060:34b5 with SMTP id
 cb16-20020a056a02071000b005abf06034b5mr80449pgb.6.1697585181809; Tue, 17 Oct
 2023 16:26:21 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue, 17 Oct 2023 23:26:10 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231017232610.4008690-1-mizhang@google.com>
Subject: [PATCH] KVM: x86: Update the variable naming in kvm_x86_ops.sched_in()
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>
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

Update the variable with name 'kvm' in kvm_x86_ops.sched_in() to 'vcpu' to
avoid confusions. Variable naming in KVM has a clear convention that 'kvm'
refers to pointer of type 'struct kvm *', while 'vcpu' refers to pointer of
type 'struct kvm_vcpu *'.

Fix this 9-year old naming issue for fun.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7c228ae05df0..394e1a31c02c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1703,7 +1703,7 @@ struct kvm_x86_ops {
 
 	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
 
-	void (*sched_in)(struct kvm_vcpu *kvm, int cpu);
+	void (*sched_in)(struct kvm_vcpu *vcpu, int cpu);
 
 	/*
 	 * Size of the CPU's dirty log buffer, i.e. VMX's PML buffer.  A zero

base-commit: 437bba5ad2bba00c2056c896753a32edf80860cc
-- 
2.42.0.655.g421f12c284-goog

