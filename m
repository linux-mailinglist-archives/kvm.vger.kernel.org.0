Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E1C28696B
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 22:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgJGUxt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 16:53:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23205 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728275AbgJGUxt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 16:53:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602104028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kX1VG8a6zkuD/3E46MJcm8aBltfxr0Y3fuQzYvb2RnM=;
        b=RW79OtBBgNLIh8nFY2B1yJ9ZrdyaSOQwcmgPRncM/uNyHlqQ6gEyHrB9eX3FzJydwIOlD1
        5m6JCGkjTBJYOVTAlEMqRgDNlxdXcC1lIVbSImzBPv+FNfcgmHp4iF6BWUI7u9eUPtTxIz
        L81nuTw3n5KNK8uL1BXlWi9Vd1a1uT8=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-m-0XymHlPRiEJBjJP_Wazg-1; Wed, 07 Oct 2020 16:53:46 -0400
X-MC-Unique: m-0XymHlPRiEJBjJP_Wazg-1
Received: by mail-qv1-f70.google.com with SMTP id 99so2218992qva.1
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 13:53:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kX1VG8a6zkuD/3E46MJcm8aBltfxr0Y3fuQzYvb2RnM=;
        b=Cq3oArqF2TF2jsXnMWyDk3yPyE6XpnaSE4UmiBHTRwYZ2CopVklHrJCD5SPU7f9EUH
         G8UuynkdOyzne3szXVqUc595nQ5sxcETcog6qla06zf6mcRMI1FCBf34vG3ggoCkSrWk
         IWQBGMbDbQ7XEusWPTrOvi9DdnTgQdLIz/MvgJ00HzqcDmQud/CeUN0I3j68VCbQqTWE
         L+b63JDJ/u1Exu1BaMepIvA9V5SAZwCSqlMbXNWFQaxLR6Mj0zkKJ8DEoEjUk2StKaiJ
         H5h6UaPLLKf3R8kUoQl0gJ3/FdoPLKcCN8C1ctOmk6u6MYGnWbcNLHWH+uxCw+eXVkUD
         xM5g==
X-Gm-Message-State: AOAM532S3O98WTtnw8CAIEmCmF94eS4z3yKINg1OGfPpMzY+Ki1AvH4n
        7Lg5cRCj4C3vf7dCFruDITHyScvhXZKbDEdUzaN7bBQDrwru9ZX88CSwry0sOqhx1rIj1tPG4q7
        jU4PiKTBDrDCt
X-Received: by 2002:a37:a054:: with SMTP id j81mr4629826qke.23.1602104025800;
        Wed, 07 Oct 2020 13:53:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyL2cVzMVNA9GlSWo/fbUOzV8IgbQ37ZjN4M5sK55UpooCzprJA1mGC9Vb1RztHEuEaHNw97g==
X-Received: by 2002:a37:a054:: with SMTP id j81mr4629812qke.23.1602104025619;
        Wed, 07 Oct 2020 13:53:45 -0700 (PDT)
Received: from xz-x1.redhat.com (toroon474qw-lp140-04-174-95-215-133.dsl.bell.ca. [174.95.215.133])
        by smtp.gmail.com with ESMTPSA id j24sm2390695qkg.107.2020.10.07.13.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 13:53:45 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andrew Jones <drjones@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH v14 01/14] KVM: Documentation: Update entry for KVM_X86_SET_MSR_FILTER
Date:   Wed,  7 Oct 2020 16:53:29 -0400
Message-Id: <20201007205342.295402-2-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201007205342.295402-1-peterx@redhat.com>
References: <20201007205342.295402-1-peterx@redhat.com>
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

