Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D944927F719
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 03:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729980AbgJABUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 21:20:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48739 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbgJABUy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 21:20:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601515253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kX1VG8a6zkuD/3E46MJcm8aBltfxr0Y3fuQzYvb2RnM=;
        b=TKmUwDBPS2M3xeIMAxKsDbIESYX5qElwPSC8hD5J4DvNlUk58mX8CoNe2ibdA45TD8skag
        eOohQ+2aP9OPbyJDnWa581pLCXsZygscFl0HdFHdc6jtDc1WCWL4Q6wI2n4uzxul+/sK9i
        joHKcf9mBBns5PyN6lOEMrRJ/GBIauE=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-zAUl30KKO96cVcPN1d584Q-1; Wed, 30 Sep 2020 21:20:51 -0400
X-MC-Unique: zAUl30KKO96cVcPN1d584Q-1
Received: by mail-qk1-f198.google.com with SMTP id m23so2096801qkh.10
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 18:20:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kX1VG8a6zkuD/3E46MJcm8aBltfxr0Y3fuQzYvb2RnM=;
        b=t7IuxQ9+UJMvEkQvKrNeHQamEmj/5158bqTCq3EM03/qjTvwdFP3W10MGgo4/T2bvp
         y7YSPFj4PKjZnpjmvkc2fYjwkOop5REFb1jgOd8K2AlST8wwnGogyMZZZ593raTsuoaY
         gLRseayoPKG/+mEwLnbbJSH+jUm8l+LVWXQew5ruhg5x76o227Q363vxnQdc34/3HI6L
         n7R5wwawz44/ThUDRZQnUEa2oNyZdMrwAKdUToUopWQXM6RwH22EV+pCkw7E8loH3A1D
         fqO8EVGYsEvoRvdbbTFejlX2zBAaRqZh9waK3ZBnTai6FxqBVWKqdhcNf8pUk8HloMD0
         Qk6w==
X-Gm-Message-State: AOAM531OR097aaHJ/hWL/9Wzxwbqgb6iguzfSqAkFLLAVHv4LgjGgW3x
        kgfPkNrpInqxpXTaNyhazYLfzDCXwSUvYnfrtExGrG5Rz48VP93Ud1kKRcTOoJNtSTw39CshwVi
        zEauntKMl9Rhn
X-Received: by 2002:aed:2767:: with SMTP id n94mr5503181qtd.237.1601515250589;
        Wed, 30 Sep 2020 18:20:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwexGjkpxAISmZJU5rHDeSyZUsxTAK15C0TBN2t67Ns3CGcsxJR+LE5yAdOAZa+v7XnrjZbYA==
X-Received: by 2002:aed:2767:: with SMTP id n94mr5503153qtd.237.1601515250368;
        Wed, 30 Sep 2020 18:20:50 -0700 (PDT)
Received: from localhost.localdomain (toroon474qw-lp130-09-184-147-14-204.dsl.bell.ca. [184.147.14.204])
        by smtp.gmail.com with ESMTPSA id y46sm4714478qtc.30.2020.09.30.18.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 18:20:49 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com, "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v13 01/14] KVM: Documentation: Update entry for KVM_X86_SET_MSR_FILTER
Date:   Wed, 30 Sep 2020 21:20:31 -0400
Message-Id: <20201001012044.5151-2-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001012044.5151-1-peterx@redhat.com>
References: <20201001012044.5151-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It should be an accident when rebase, since we've already have section
8.25 (which is KVM_CAP_S390_DIAG318).  Fix the number.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 425325ff4434..136b11007d74 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6360,7 +6360,7 @@ accesses that would usually trigger a #GP by KVM into the guest will
 instead get bounced to user space through the KVM_EXIT_X86_RDMSR and
 KVM_EXIT_X86_WRMSR exit notifications.
 
-8.25 KVM_X86_SET_MSR_FILTER
+8.27 KVM_X86_SET_MSR_FILTER
 ---------------------------
 
 :Architectures: x86
-- 
2.26.2

