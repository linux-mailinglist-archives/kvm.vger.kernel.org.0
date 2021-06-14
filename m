Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5679E3A7102
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 23:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbhFNVLj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 17:11:39 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:39572 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhFNVLi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 17:11:38 -0400
Received: by mail-pj1-f46.google.com with SMTP id o88-20020a17090a0a61b029016eeb2adf66so228946pjo.4
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 14:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qHRLPYRPZJBt8mpUhiZSqookm+IZFM9rc0LYgrH0esQ=;
        b=T2CqVn/UQuDRIg2LFtKhhhOR8LNyvvCABg1khTCTYeUfNyyrD2MBL/P/bSpn3zi3YJ
         EQniD+/jJeCj7lmTKPEgUNR/xz+K3MCts8cQl33zvmBAGH0SR1cLDL5kz0KL6mOIU43b
         F5SCc/o5rpxogQm7RbFItILAQ7tQAlGQyOT6UvtDyCs/LyxIInu2YmiMh9iA0Ie6TMKL
         OZNOBrbRzIUghzmFmDB/gJlk/VemybnfyUmYwUWvmZTLsmj5V27gHTPJiSc736NAHrLO
         0kRELynvLE+PngkzvS0j4AenhrFblvaaYTek1cB/sQTl22epXJmePhWPtNDZH5J4EmGY
         2e6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qHRLPYRPZJBt8mpUhiZSqookm+IZFM9rc0LYgrH0esQ=;
        b=TYLu0i0bC7+x4uE+YLH71G8tph5/Plfm/2Mm23wITGLA6CKwPWn8X5gjeVeKAC8UWh
         zVqcSrmApZwRXXyZs9bvZaWyvF/1zkulbpI3kjGo11OVkgEhk5kEKdKgN2oOx/fIfHS6
         ECWcCmYfxZnNfCugMS9lLW0J+j+D9W82WXR7CMg2zLBwgsAFooWCfmuySzYvJRTFa13M
         zPpqO1mdzW3+0OhgevSSVyH1YPETX886ZOaxp2UhcWv+g8CUajE86yRVnw3czaRb5zlg
         4wHieXHmcoebjH8mRoL7hzohQ4ydW/BIkDZp0iZ4vx3YL6OlIqN3imZg8QAW4+fjlSfD
         rqNQ==
X-Gm-Message-State: AOAM532WOrGKBmP4Jrm8EYOigbz3g47sOzs3sN+FrP5WBWEMy8cgB/Dp
        LFyDt/Ymxj3KqOsdkkJZmMoEUKCdh6X1GA==
X-Google-Smtp-Source: ABdhPJx5S05uAIpTjO2YTL8rji6MchXkQkdnHEDyRaM/RDTR0KLtABd5BW3vkAX07kwjpy8lLWQWPA==
X-Received: by 2002:a17:90a:c210:: with SMTP id e16mr1132160pjt.234.1623704903655;
        Mon, 14 Jun 2021 14:08:23 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id a15sm13313024pff.128.2021.06.14.14.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 14:08:22 -0700 (PDT)
Date:   Mon, 14 Jun 2021 21:08:18 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 0/8] KVM: x86/mmu: Fast page fault support for the TDP MMU
Message-ID: <YMfFQnfsq5AuUP2B@google.com>
References: <20210611235701.3941724-1-dmatlack@google.com>
 <639c54a4-3d6b-8b28-8da7-e49f2f87e025@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <639c54a4-3d6b-8b28-8da7-e49f2f87e025@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14, 2021 at 11:54:59AM +0200, Paolo Bonzini wrote:
> On 12/06/21 01:56, David Matlack wrote:
> > This patch series adds support for the TDP MMU in the fast_page_fault
> > path, which enables certain write-protection and access tracking faults
> > to be handled without taking the KVM MMU lock. This series brings the
> > performance of these faults up to par with the legacy MMU.
> 
> Hi David,
> 
> I have one very basic question: is the speedup due to lock contention, or to
> cacheline bouncing, or something else altogether? In other words, what do
> the profiles look like before vs. after these patches?

The speed up comes from a combination of:
 - Less time spent in kvm_vcpu_gfn_to_memslot.
 - Less lock contention on the MMU lock in read mode.

Before:

  Overhead  Symbol
-   45.59%  [k] kvm_vcpu_gfn_to_memslot
   - 45.57% kvm_vcpu_gfn_to_memslot
      - 29.25% kvm_page_track_is_active
         + 15.90% direct_page_fault
         + 13.35% mmu_need_write_protect
      + 9.10% kvm_mmu_hugepage_adjust
      + 7.20% try_async_pf
+   18.16%  [k] _raw_read_lock
+   10.57%  [k] direct_page_fault
+    8.77%  [k] handle_changed_spte_dirty_log
+    4.65%  [k] mark_page_dirty_in_slot
     1.62%  [.] run_test
+    1.35%  [k] x86_virt_spec_ctrl
+    1.18%  [k] try_grab_compound_head
[...]

After:

  Overhead  Symbol
+   26.23%  [k] x86_virt_spec_ctrl
+   15.93%  [k] vmx_vmexit
+    6.33%  [k] vmx_vcpu_run
+    4.31%  [k] vcpu_enter_guest
+    3.71%  [k] tdp_iter_next
+    3.47%  [k] __vmx_vcpu_run
+    2.92%  [k] kvm_vcpu_gfn_to_memslot
+    2.71%  [k] vcpu_run
+    2.71%  [k] fast_page_fault
+    2.51%  [k] kvm_vcpu_mark_page_dirty

(Both profiles were captured during "Iteration 2 dirty memory" of
dirty_log_perf_test.)

Related to the kvm_vcpu_gfn_to_memslot overhead: I actually have a set of
patches from Ben I am planning to send soon that will reduce the number of
redundant gfn-to-memslot lookups in the page fault path.

> 
> Thanks,
> 
> Paolo
> 
