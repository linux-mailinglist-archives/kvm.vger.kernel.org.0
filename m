Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5FA3589BA
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 18:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbhDHQ1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 12:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbhDHQ1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 12:27:37 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D752C061760
        for <kvm@vger.kernel.org>; Thu,  8 Apr 2021 09:27:24 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id nh5so1417177pjb.5
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 09:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pFuDqpry+4TZw3DgKBp/+LrpcD/pO8gvJ2OYLTlpRh0=;
        b=WhJ/7YAT+dzojpuhUIDWxkQnrM0jd79M/UmHPaTjcCc+ZmQdnIQhYKZ1y/efQt9mje
         FSPv4cdfq3iWq7WTotn3wlP32PNr81TknyF0MjqgIbOlKq0Xett31BdbtaDyKwEBFhRT
         i6dur2nLr9Q0bNF6PEw50Z1aZwk7PWJwrFWYTuDT+3yNn13UR/dPf7opr9VS7gsgV5WG
         7wkq0MVSNe7OtIJfQrVURqRlv0I451WmzsnAF3+gB+JBlC4SS1XaRH4KvX2ppQJXL0Rk
         00vu6fyWUaC1rAuLid3h4S/HlHSreOpUCMzwsllSnNd2pe+aqyvVX6rP3ckfb5NsOHbT
         mmRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pFuDqpry+4TZw3DgKBp/+LrpcD/pO8gvJ2OYLTlpRh0=;
        b=LHTAaQb/lLc5TILCreLVDsFf1rc2D3or5wG0X8QY/huZFDN5SjvktGvW6XPlQxps1V
         I4ofutSF74rRuP1pfOkjNB+OiwwhKiMSJ8LV/25pGF7frG26vVsDyIGUGW6OFho73U14
         aLE+l8/ZTbz6RpzcU4ZrFfOPKINbexGKo/klevgbRZg5tJlfKK3HWnYfDoKVCvvSjdkG
         44VgJl8jExcp7tohacS1SBU7yD0BiKdDc+ALNf1Eg4N1z5v8cLBhkwcR7Gcvwc7qcRSs
         sexsxj9r+pu6VhcFLg/QggeYlwSUS68StsoiVXhmlUiGchD8Au8dgHkuxeMFdyLwEmCb
         R0XA==
X-Gm-Message-State: AOAM533TQiLNIbxLXBXaDEOfQZ5lrIP4yfPm7vCOVZz5DzIRLofercDm
        aH4ZvO0LtlpFzLrW/CxASQ7K5Q==
X-Google-Smtp-Source: ABdhPJzuuhc4h5g1YBldubeScPuR6e9Y5XWPZLesz6E0YCgyjKwN/lXZTxDBBRaPbnEd6OwT2fPNgA==
X-Received: by 2002:a17:90a:5b0b:: with SMTP id o11mr8997121pji.150.1617899243784;
        Thu, 08 Apr 2021 09:27:23 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id m14sm20141858pgb.0.2021.04.08.09.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 09:27:23 -0700 (PDT)
Date:   Thu, 8 Apr 2021 16:27:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 07/17] KVM: x86/mmu: Check PDPTRs before allocating
 PAE roots
Message-ID: <YG8u5zv/5+WCYEVT@google.com>
References: <20210305011101.3597423-1-seanjc@google.com>
 <20210305011101.3597423-8-seanjc@google.com>
 <CANRm+CzUAzR+D3BtkYpe71sHf_nmtm_Qmh4neqc=US2ETauqyQ@mail.gmail.com>
 <f6ae3dbb-cfa5-4d8b-26bf-92db6fc9eab1@redhat.com>
 <YG8lzKqL32+JhY0Z@google.com>
 <8b7129ed-0377-7b91-c741-44ac2202081a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b7129ed-0377-7b91-c741-44ac2202081a@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 08, 2021, Paolo Bonzini wrote:
> On 08/04/21 17:48, Sean Christopherson wrote:
> > Freaking PDPTRs.  I was really hoping we could keep the lock and pages_available()
> > logic outside of the helpers.  What if kvm_mmu_load() reads the PDPTRs and
> > passes them into mmu_alloc_shadow_roots()?  Or is that too ugly?
> 
> The patch I have posted (though untested) tries to do that in a slightly
> less ugly way by pushing make_mmu_pages_available down to mmu_alloc_*_roots.

Yeah, I agree it's less ugly.  It would be nice to not duplicate that code, but
it's probably not worth the ugliness.  :-/

For your approach, can we put the out label after the success path?  Setting
mmu->root_pgd isn't wrong per se, but doing so might mislead future readers into
thinking that it's functionally necessary. 


diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index efb41f31e80a..93f97d0a9e2e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3244,6 +3244,13 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
        u8 shadow_root_level = mmu->shadow_root_level;
        hpa_t root;
        unsigned i;
+       int r;
+
+       write_lock(&vcpu->kvm->mmu_lock);
+
+       r = make_mmu_pages_available(vcpu);
+       if (r)
+               goto out_unlock;

        if (is_tdp_mmu_enabled(vcpu->kvm)) {
                root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
@@ -3252,8 +3259,10 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
                root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true);
                mmu->root_hpa = root;
        } else if (shadow_root_level == PT32E_ROOT_LEVEL) {
-               if (WARN_ON_ONCE(!mmu->pae_root))
-                       return -EIO;
+               if (WARN_ON_ONCE(!mmu->pae_root)) {
+                       r = -EIO;
+                       goto out_unlock;
+               }

                for (i = 0; i < 4; ++i) {
                        WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
@@ -3266,13 +3275,15 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
                mmu->root_hpa = __pa(mmu->pae_root);
        } else {
                WARN_ONCE(1, "Bad TDP root level = %d\n", shadow_root_level);
-               return -EIO;
+               r = -EIO;
+               goto out_unlock;
        }

        /* root_pgd is ignored for direct MMUs. */
        mmu->root_pgd = 0;
-
-       return 0;
+out_unlock:
+       write_unlock(&vcpu->kvm->mmu_lock);
+       return r;
 }

 static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
@@ -3281,7 +3292,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
        u64 pdptrs[4], pm_mask;
        gfn_t root_gfn, root_pgd;
        hpa_t root;
-       int i;
+       int i, r;

        root_pgd = mmu->get_guest_pgd(vcpu);
        root_gfn = root_pgd >> PAGE_SHIFT;
@@ -3289,6 +3300,10 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
        if (mmu_check_root(vcpu, root_gfn))
                return 1;

+       /*
+        * On SVM, reading PDPTRs might access guest memory, which might fault
+        * and thus might sleep.  Grab the PDPTRs before acquiring mmu_lock.
+        */
        if (mmu->root_level == PT32E_ROOT_LEVEL) {
                for (i = 0; i < 4; ++i) {
                        pdptrs[i] = mmu->get_pdptr(vcpu, i);
@@ -3300,6 +3315,12 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
                }
        }

+       write_lock(&vcpu->kvm->mmu_lock);
+
+       r = make_mmu_pages_available(vcpu);
+       if (r)
+               goto out_unlock;
+
        /*
         * Do we shadow a long mode page table? If so we need to
         * write-protect the guests page table root.
@@ -3311,8 +3332,10 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
                goto set_root_pgd;
        }

-       if (WARN_ON_ONCE(!mmu->pae_root))
-               return -EIO;
+       if (WARN_ON_ONCE(!mmu->pae_root)) {
+               r = -EIO;
+               goto out_unlock;
+       }

        /*
         * We shadow a 32 bit page table. This may be a legacy 2-level
@@ -3323,8 +3346,10 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
        if (mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
                pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;

-               if (WARN_ON_ONCE(!mmu->lm_root))
-                       return -EIO;
+               if (WARN_ON_ONCE(!mmu->lm_root)) {
+                       r = -EIO;
+                       goto out_unlock;
+               }

                mmu->lm_root[0] = __pa(mmu->pae_root) | pm_mask;
        }
@@ -3352,8 +3377,9 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)

 set_root_pgd:
        mmu->root_pgd = root_pgd;
-
-       return 0;
+out_unlock:
+       write_unlock(&vcpu->kvm->mmu_lock);
+       return r;
 }

 static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
@@ -4852,14 +4878,10 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
        r = mmu_alloc_special_roots(vcpu);
        if (r)
                goto out;
-       write_lock(&vcpu->kvm->mmu_lock);
-       if (make_mmu_pages_available(vcpu))
-               r = -ENOSPC;
-       else if (vcpu->arch.mmu->direct_map)
+       if (vcpu->arch.mmu->direct_map)
                r = mmu_alloc_direct_roots(vcpu);
        else
                r = mmu_alloc_shadow_roots(vcpu);
-       write_unlock(&vcpu->kvm->mmu_lock);
        if (r)
                goto out;


