Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E41500729
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 09:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240552AbiDNHnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 03:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240460AbiDNHma (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 03:42:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 743BD5677F
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 00:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649922005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RQ5CWUGjT4K4xbXyZ8WaQBFYz0mKZYfkG8ySlVTr0k4=;
        b=FHgVyH6DSnDZ6zocRxb7JVMKtXlby4n3NkdDGze6XpwndrFWRqAg8zSVQ4Rh9HIHoEN6nH
        ti5qOHub6t2dLSxAKxP61ceCZWiDBqJhSho/Vq8Te0n4M984J/BUQJAGH9FP6lRfgbs5ea
        5fLn5bn8CN2zc0PfUARQoJ6QZSPuLrg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-4VnvEsw1Nvm-SapdnWd0mw-1; Thu, 14 Apr 2022 03:40:02 -0400
X-MC-Unique: 4VnvEsw1Nvm-SapdnWd0mw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFD39101AA45;
        Thu, 14 Apr 2022 07:40:01 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C256841D40E;
        Thu, 14 Apr 2022 07:40:01 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 04/22] KVM: x86/mmu: rephrase unclear comment
Date:   Thu, 14 Apr 2022 03:39:42 -0400
Message-Id: <20220414074000.31438-5-pbonzini@redhat.com>
In-Reply-To: <20220414074000.31438-1-pbonzini@redhat.com>
References: <20220414074000.31438-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If accessed bits are not supported there simple isn't any distinction
between accessed and non-accessed gPTEs, so the comment does not make
much sense.  Rephrase it in terms of what happens if accessed bits
*are* supported.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 7d4377f1ef2a..07a7832f96cb 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -151,7 +151,7 @@ static bool FNAME(prefetch_invalid_gpte)(struct kvm_vcpu *vcpu,
 	if (!FNAME(is_present_gpte)(gpte))
 		goto no_present;
 
-	/* if accessed bit is not supported prefetch non accessed gpte */
+	/* Prefetch only accessed entries (unless A/D bits are disabled). */
 	if (PT_HAVE_ACCESSED_DIRTY(vcpu->arch.mmu) &&
 	    !(gpte & PT_GUEST_ACCESSED_MASK))
 		goto no_present;
-- 
2.31.1


