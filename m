Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D2B3B357B
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 20:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbhFXSRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 14:17:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20476 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232533AbhFXSRr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 14:17:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624558527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6oYmAaxF1m0ypshAXrxOXpFe7grcqzSbU76jZq5pQc4=;
        b=PNcu9gTMi97F66d0LiYo67JVbAUYFKlr/MIK6OYUE6fBl7krxNXcQtVkXON77CAW9eE/Mj
        Ax2N1i+xtBjgYar7XWzG8Lc/l97jOx3UXCNDkXErePCiT25zO+4PIqmB8k7ACHepChQJ06
        mMy50XhwfR0mHYEBsU5BNFxjVosLqHE=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-PaEIH-S6NtqyZszhsHBcEw-1; Thu, 24 Jun 2021 14:15:26 -0400
X-MC-Unique: PaEIH-S6NtqyZszhsHBcEw-1
Received: by mail-io1-f70.google.com with SMTP id 13-20020a05660220cdb02904e9d997e803so5075083ioz.20
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 11:15:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6oYmAaxF1m0ypshAXrxOXpFe7grcqzSbU76jZq5pQc4=;
        b=lExFwyCplUxXvXfPEIP6FOAIOfQljELhWLYBdyv3MlvOSz6CuywxvKv872mvIdvzE5
         x3CVUUDesO9CMvtkgIBAaf2L9LtgOCXdVKsLXPFZXSWUfh9v5piQt4zx/zCkVdQnxBjS
         bph9kQIOQMPchOGm6id9ACKEed/2wvsZDisLRF7sfqvhIz005yUScoJsAA+y6WUp4Jeo
         V6lVPZ4g6j/QxyQYS/bd23R5Y/vsLR6WgtKlztZNob2BfBQKGWgijrEwOMcYK3HfmVWR
         vdxIw+8VB+luxwqql44r6obP4+3yaCpxEkblmfEoZooW8Q/TCVI5WHMTjImA7CTvxUyC
         z8oA==
X-Gm-Message-State: AOAM533G1oeGqI4ZF6BXqDjzkOT2ZqHr91IiJcBpJqOFo06HJFV6aBpc
        i6tPaQGA3W8kisnjzu9F/PAhVlOz8PYlTQuGz6vhaD2OdoU3oO7D8ch5gIYXohhrvwVBiYi4A2N
        416b4KI51odj2lllCgTymrLvxpbt6tI18rVVKztc5J6orldKTwCMr8ZmOV6xp/Q==
X-Received: by 2002:a92:2004:: with SMTP id j4mr4627827ile.53.1624558525373;
        Thu, 24 Jun 2021 11:15:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJaP8C3FxzWVbVxDDMkYVrrRulTZoc5GrgopLwqVo4msNj6pOvE/OkExDtHEmU59FudWjoFg==
X-Received: by 2002:a92:2004:: with SMTP id j4mr4627786ile.53.1624558524837;
        Thu, 24 Jun 2021 11:15:24 -0700 (PDT)
Received: from t490s.redhat.com (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id m19sm2170100ilj.52.2021.06.24.11.15.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 11:15:24 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 9/9] KVM: X86: Optimize zapping rmap
Date:   Thu, 24 Jun 2021 14:15:23 -0400
Message-Id: <20210624181523.11065-1-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210624181356.10235-1-peterx@redhat.com>
References: <20210624181356.10235-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using rmap_get_first() and rmap_remove() for zapping a huge rmap list could be
slow.  The easy way is to travers the rmap list, collecting the a/d bits and
free the slots along the way.

Provide a pte_list_destroy() and do exactly that.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 45 +++++++++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b21e52dfc27b..719fb6fd0aa0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -954,6 +954,38 @@ unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
 	return count;
 }
 
+/* Return true if rmap existed and callback called, false otherwise */
+static bool pte_list_destroy(struct kvm_rmap_head *rmap_head,
+			     int (*callback)(u64 *sptep))
+{
+	struct pte_list_desc *desc, *next;
+	int i;
+
+	if (!rmap_head->val)
+		return false;
+
+	if (!(rmap_head->val & 1)) {
+		if (callback)
+			callback((u64 *)rmap_head->val);
+		goto out;
+	}
+
+	desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
+
+	while (desc) {
+		if (callback)
+			for (i = 0; i < desc->spte_count; i++)
+				callback(desc->sptes[i]);
+		next = desc->more;
+		mmu_free_pte_list_desc(desc);
+		desc = next;
+	}
+out:
+	/* rmap_head is meaningless now, remember to reset it */
+	rmap_head->val = 0;
+	return true;
+}
+
 static struct kvm_rmap_head *__gfn_to_rmap(gfn_t gfn, int level,
 					   struct kvm_memory_slot *slot)
 {
@@ -1310,18 +1342,7 @@ static bool rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			  struct kvm_memory_slot *slot)
 {
-	u64 *sptep;
-	struct rmap_iterator iter;
-	bool flush = false;
-
-	while ((sptep = rmap_get_first(rmap_head, &iter))) {
-		rmap_printk("spte %p %llx.\n", sptep, *sptep);
-
-		pte_list_remove(rmap_head, sptep);
-		flush = true;
-	}
-
-	return flush;
+	return pte_list_destroy(rmap_head, mmu_spte_clear_track_bits);
 }
 
 static bool kvm_unmap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-- 
2.31.1

