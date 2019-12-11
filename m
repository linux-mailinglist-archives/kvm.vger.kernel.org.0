Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2DD811C08C
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 00:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfLKX2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 18:28:34 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48824 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726890AbfLKX2d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 18:28:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576106912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8N2VTWKYaoek2MhT9jeNFkodFByKtGdL7R1oeX08/MU=;
        b=Gkhj8uzPSk2wy0svmnPIzzDoqaQz+KeDI5j2D28sSES81l0Xvow4B5xlc7lq/Kv0quNC5g
        q2tARvZ4i3rUzB8SH5GcmoeaZU8q1rGMIQonoOZzWSZSNIX6sXOS3BrW1dB0A58dtFg+wE
        b3sQKRUjfw1UA6xwaLyX5HtPWV/BY/g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-04i6izvaNMSzM6QR9agA1Q-1; Wed, 11 Dec 2019 18:28:30 -0500
X-MC-Unique: 04i6izvaNMSzM6QR9agA1Q-1
Received: by mail-wr1-f70.google.com with SMTP id b13so235834wrx.22
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 15:28:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8N2VTWKYaoek2MhT9jeNFkodFByKtGdL7R1oeX08/MU=;
        b=A4Pks3NjUUZqo0sHIfM94GxSIVrUe36fHej06YF9FeR6sRS9x4DUcPUCaPO086iQ6R
         yWKbcHZELvxNFl3awMrMww2gGeo23PsJ75gHmCH7StomwO7U0AEogjZHjWmgR/jtYZKM
         HPUQYhQ6gtkWNb1Lwxec2gzOteOSVahqcps9/zmoGwevune55p5pnMDCV3KDc/DkPFE8
         vk386KrOkaBIMUeXCPtecNFmCMS7MC+NZzLqHOkSa+PGe2XMbpBOjoMMtQtxdrsaQHpv
         hDc2se76Xs6Wbx98uZrQe5O6gqH9J3KziBDVvV7Q/3y3+UHhB1zwYeqMvPiq+THWHJeY
         pD8g==
X-Gm-Message-State: APjAAAUtRmZKAVe2llBps6uXXHFIwep1AilLI+dnhjRae3yi7YgGTpIV
        dMEyQuyZbWgCM5OqRm6OTxWvjHHLbuXwOaAp/6ALA4uATQ8IzZ1Z8ruooOnr0GteqNM0ZSLhH2N
        8+9AzVQhY2JCl
X-Received: by 2002:a5d:4651:: with SMTP id j17mr2661083wrs.237.1576106909758;
        Wed, 11 Dec 2019 15:28:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqwtDih10uBkUdWYAfbe65JA1ATiOMPLbwKMKCsUlC7MesSRuyAIYC2eS4f1nsy/Ltf04UErOw==
X-Received: by 2002:a5d:4651:: with SMTP id j17mr2661056wrs.237.1576106909460;
        Wed, 11 Dec 2019 15:28:29 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id j21sm4545674wmj.39.2019.12.11.15.28.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 15:28:29 -0800 (PST)
Subject: Re: [PATCH v2 1/3] KVM: x86: assign two bits to track SPTE kinds
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Junaid Shahid <junaids@google.com>
References: <1569582943-13476-1-git-send-email-pbonzini@redhat.com>
 <1569582943-13476-2-git-send-email-pbonzini@redhat.com>
 <CANgfPd8G194y1Bo-6HR-jP8wh4DvdAsaijue_pnhetjduyzn4A@mail.gmail.com>
 <20191211191327.GI5044@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4e850c10-ff14-d95e-df22-0d0fd7427509@redhat.com>
Date:   Thu, 12 Dec 2019 00:28:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191211191327.GI5044@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/19 20:13, Sean Christopherson wrote:
> Assuming we haven't missed something, the easiest fix would be to reduce
> the MMIO generation by one bit and use bits 62:54 for the MMIO generation.

Yes, and I mistakenly thought it would be done just by adjusting 
PT64_SECOND_AVAIL_BITS_SHIFT.

I will test and send formally something like this:

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f92b40d798c..aa2d86f42b9a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -405,11 +405,13 @@ static inline bool is_access_track_spte(u64 spte)
 }
 
 /*
- * Due to limited space in PTEs, the MMIO generation is a 19 bit subset of
+ * Due to limited space in PTEs, the MMIO generation is a 18 bit subset of
  * the memslots generation and is derived as follows:
  *
  * Bits 0-8 of the MMIO generation are propagated to spte bits 3-11
- * Bits 9-18 of the MMIO generation are propagated to spte bits 52-61
+ * Bits 9-17 of the MMIO generation are propagated to spte bits 54-62
  *
+ * We don't use bit 63 to avoid conflicting with the SVE bit in EPT PTEs.
+ *
  * The KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS flag is intentionally not included in
  * the MMIO generation number, as doing so would require stealing a bit from
@@ -418,15 +418,16 @@ static inline bool is_access_track_spte(u64 spte)
  * requires a full MMU zap).  The flag is instead explicitly queried when
  * checking for MMIO spte cache hits.
  */
-#define MMIO_SPTE_GEN_MASK		GENMASK_ULL(18, 0)
+#define MMIO_SPTE_GEN_MASK		GENMASK_ULL(17, 0)
 
 #define MMIO_SPTE_GEN_LOW_START		3
 #define MMIO_SPTE_GEN_LOW_END		11
 #define MMIO_SPTE_GEN_LOW_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
 						    MMIO_SPTE_GEN_LOW_START)
 
-#define MMIO_SPTE_GEN_HIGH_START	52
-#define MMIO_SPTE_GEN_HIGH_END		61
+/* Leave room for SPTE_SPECIAL_MASK.  */
+#define MMIO_SPTE_GEN_HIGH_START	PT64_SECOND_AVAIL_BITS_SHIFT
+#define MMIO_SPTE_GEN_HIGH_END		62
 #define MMIO_SPTE_GEN_HIGH_MASK		GENMASK_ULL(MMIO_SPTE_GEN_HIGH_END, \
 						    MMIO_SPTE_GEN_HIGH_START)
 static u64 generation_mmio_spte_mask(u64 gen)


Paolo

