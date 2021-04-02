Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D4E3528DC
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 11:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbhDBJep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 05:34:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52084 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234626AbhDBJep (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Apr 2021 05:34:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617356084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zJGFIBZSsezFGTTBbG13IPXImkEHWvDslizpfbPB0uQ=;
        b=dyaYVvQKRelvsXllsHU2XlTeLGA4H5tQXN4vxY8lcx96C6CO3vGkhDDoJpGFozIPWz0Pda
        SG/TPjbugS62UeNNa3wFH9D++P+hSckV0fxjVSX5dkc6mvnDM6H8q9B5oFmf+JyARKYUg4
        iSbCZFAdlNb5rCh9c/aQbNjtT7+tVr0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-rrkkshfaMc209bzzenqeFg-1; Fri, 02 Apr 2021 05:34:42 -0400
X-MC-Unique: rrkkshfaMc209bzzenqeFg-1
Received: by mail-wr1-f71.google.com with SMTP id p12so4113852wrn.18
        for <kvm@vger.kernel.org>; Fri, 02 Apr 2021 02:34:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zJGFIBZSsezFGTTBbG13IPXImkEHWvDslizpfbPB0uQ=;
        b=nlHx8agiCy/Rt29qnEDVYHNv0kh6ZAP1ha78Ou/VFwts+UGLc8ROiGbqSOLq6A2EB4
         IPvu46Inpe4Q484sbpSoQtlYJdeIpGRpxj91m+V9l0W8cn9DuFQ6BSSLFt98/kzKFa2H
         RLu00uu2VEYBO+1uy2yZ/ilDWL8nCAFOiBQP1/4hL5z6xAl3RknlEbN8Szkj3T5BFhTD
         ++/X0f8jRzpR3yc7Bm4xX56uTc9dWHxQySvtdmS2InMUxdEWp8lxu8EsdHGNEI3NnC4o
         ngwDCRChY3hfSAxtEEE7XOrAEJ1S25yiY29vT3PEyXcEa6yTAowKxEEfGB7NQmJbDarG
         Fung==
X-Gm-Message-State: AOAM533bl5QqcRZdVUejXCAyQOvuNjWCYVgSdndEteTSpRrRmWXMGwRp
        WLu+PvTh0KzbjFJjTLArGHfwTWtaIV9gFkvAtInv+wy6EdEVWQCKhAzWvj21cnoEf1wARZlK8PY
        J9cXw8dxQRWW5
X-Received: by 2002:a5d:4281:: with SMTP id k1mr14190089wrq.374.1617356081543;
        Fri, 02 Apr 2021 02:34:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzslPTY0mG/gpsRSyUhJzlJel4lWe4u0X5pwOZzh65b3L/oleiPfC3FCPnam+2uy1nVt0y3nQ==
X-Received: by 2002:a5d:4281:: with SMTP id k1mr14190061wrq.374.1617356081285;
        Fri, 02 Apr 2021 02:34:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id p18sm13774521wrs.68.2021.04.02.02.34.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 02:34:40 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
References: <20210402005658.3024832-1-seanjc@google.com>
 <20210402005658.3024832-10-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 09/10] KVM: Don't take mmu_lock for range invalidation
 unless necessary
Message-ID: <417bd6b5-b7d0-ed22-adae-02150cdbfebe@redhat.com>
Date:   Fri, 2 Apr 2021 11:34:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210402005658.3024832-10-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/04/21 02:56, Sean Christopherson wrote:
> Avoid taking mmu_lock for unrelated .invalidate_range_{start,end}()
> notifications.  Because mmu_notifier_count must be modified while holding
> mmu_lock for write, and must always be paired across start->end to stay
> balanced, lock elision must happen in both or none.  To meet that
> requirement, add a rwsem to prevent memslot updates across range_start()
> and range_end().
> 
> Use a rwsem instead of a rwlock since most notifiers _allow_ blocking,
> and the lock will be endl across the entire start() ... end() sequence.
> If anything in the sequence sleeps, including the caller or a different
> notifier, holding the spinlock would be disastrous.
> 
> For notifiers that _disallow_ blocking, e.g. OOM reaping, simply go down
> the slow path of unconditionally acquiring mmu_lock.  The sane
> alternative would be to try to acquire the lock and force the notifier
> to retry on failure.  But since OOM is currently the _only_ scenario
> where blocking is disallowed attempting to optimize a guest that has been
> marked for death is pointless.
> 
> Unconditionally define and use mmu_notifier_slots_lock in the memslots
> code, purely to avoid more #ifdefs.  The overhead of acquiring the lock
> is negligible when the lock is uncontested, which will always be the case
> when the MMU notifiers are not used.
> 
> Note, technically flag-only memslot updates could be allowed in parallel,
> but stalling a memslot update for a relatively short amount of time is
> not a scalability issue, and this is all more than complex enough.

Proposal for the locking documentation:

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index b21a34c34a21..3e4ad7de36cb 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -16,6 +16,13 @@ The acquisition orders for mutexes are as follows:
  - kvm->slots_lock is taken outside kvm->irq_lock, though acquiring
    them together is quite rare.
  
+- The kvm->mmu_notifier_slots_lock rwsem ensures that pairs of
+  invalidate_range_start() and invalidate_range_end() callbacks
+  use the same memslots array.  kvm->slots_lock is taken outside the
+  write-side critical section of kvm->mmu_notifier_slots_lock, so
+  MMU notifiers must not take kvm->slots_lock.  No other write-side
+  critical sections should be added.
+
  On x86, vcpu->mutex is taken outside kvm->arch.hyperv.hv_lock.
  
  Everything else is a leaf: no other lock is taken inside the critical

Paolo

