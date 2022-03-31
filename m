Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192AD4EDCBE
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 17:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238227AbiCaP0b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 11:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238219AbiCaP0a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 11:26:30 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0064C1BBF42
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 08:24:42 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n18so23708671plg.5
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 08:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xRax+JRUfYO5DmaeRq6LU0yH9RYNMUvPwNZPXC45DeI=;
        b=axWqP3J2Tn3FyohgJvAMgcKuw2VAsX032WLRPxNDpq1k+k8zd+dzMwtxp9z3UhLS2B
         tXkY9NaxYMwrepn9gU8G0lIK10VxIinXGrt4HwfwbH76IBZMJ2OtYJsHnATuD5lVREqm
         wPiPAHSH58NTnqIiuARkzYjBv2kNNAqBpZkcY6gvHy5kJxRRWBRjt6JvjHcziVt1OiAu
         I7FOQoJzyyxwMNsGDI4HIUoPpTe02Jl+CX6M4zgQTmNI1kcGKk60C/X01j/SxUxtM4lH
         AUK7IrpxYcioeZnWaY6KyoATVY0s+viW4wOMLUhG2BjNgiYdS0B4TzuDqy2kKIr7fgR2
         Q0jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xRax+JRUfYO5DmaeRq6LU0yH9RYNMUvPwNZPXC45DeI=;
        b=JwF8Sj0f+ZHNAB3tW3uOz8ES6DXJbnABImDR9MzbmayYq+tfavrj99hiPiTH14WOL0
         A4FiIoLKF6e6Ae3QQ4jADqfdvkXoSSLNxv8ctUPMyuqdDZiwcvD+o0sxFL6WCIytbMIG
         drMoPdQ83jxDivnGnF5cGuDq/FDmtGrPxOLsg4monwgKg603D7twv1U6T4fxJ5rMTx0O
         dBUzBtgbng9pRYWNgnyIhmyf8v0iFbCVMyaRr2J8yJt1iVqxGBDptzggPUGtw7zvNx5M
         gjhR7JATnhj4S9HXEpL/b1wzc5SGdjqXHhol2gFgC0ejYKcMESxoUi0elNkp0QNL+Djj
         Ct1g==
X-Gm-Message-State: AOAM532C6oOU6z5AmyPwejyQ9uYqHBgUWhv+FL3T6a23vbEHfhhcQACE
        8L/a4VjcfXYLceSoV64Z114m0g==
X-Google-Smtp-Source: ABdhPJxuH5sSVTfs126h4p10bpad3L+gGPpheZfesg4n//Y7LJqdh1pg3PY170yBt4myJ1/EBGyW2A==
X-Received: by 2002:a17:902:cf08:b0:151:9d28:f46f with SMTP id i8-20020a170902cf0800b001519d28f46fmr5815317plg.53.1648740282071;
        Thu, 31 Mar 2022 08:24:42 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k6-20020a056a00134600b004faba67f9d4sm29282336pfu.197.2022.03.31.08.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 08:24:41 -0700 (PDT)
Date:   Thu, 31 Mar 2022 15:24:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v3 2/3] KVM: Documentation: Update kvm_run structure for
 dirty quota
Message-ID: <YkXHtc2MiwUxpMFU@google.com>
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
 <20220306220849.215358-3-shivam.kumar1@nutanix.com>
 <YkT4bvK+tbsVDAvt@google.com>
 <ae21aee2-41e1-3ad3-41ef-edda67a8449a@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae21aee2-41e1-3ad3-41ef-edda67a8449a@nutanix.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 31, 2022, Shivam Kumar wrote:
> 
> On 31/03/22 6:10 am, Sean Christopherson wrote:
> > On Sun, Mar 06, 2022, Shivam Kumar wrote:
> > > Update the kvm_run structure with a brief description of dirty
> > > quota members and how dirty quota throttling works.
> > This should be squashed with patch 1.  I actually had to look ahead to this patch
> > because I forgot the details since I last reviewed this :-)
> Ack. Thanks.
> > > +	__u64 dirty_quota;
> > > +Please note that this quota cannot be strictly enforced if PML is enabled, and
> > > +the VCPU may end up dirtying pages more than its quota. The difference however
> > > +is bounded by the PML buffer size.
> > If you want to be pedantic, I doubt KVM can strictly enforce the quota even if PML
> > is disabled.  E.g. I can all but guarantee that it's possible to dirty multiple
> > pages during a single exit.  Probably also worth spelling out PML and genericizing
> > things.  Maybe
> > 
> >    Please note that enforcing the quota is best effort, as the guest may dirty
> >    multiple pages before KVM can recheck the quota.  However, unless KVM is using
> >    a hardware-based dirty ring buffer, e.g. Intel's Page Modification Logging,
> >    KVM will detect quota exhaustion within a handful of dirtied page.  If a
> >    hardware ring buffer is used, the overrun is bounded by the size of the buffer
> >    (512 entries for PML).
> Thank you for the blurb. Looks good to me, though I'm curious about the exits
> that can dirty multiple pages.

Anything that touches multiple pages.  nested_mark_vmcs12_pages_dirty() is an
easy example.  Emulating L2 with nested TDP.  An emulated instruction that splits
a page.  I'm pretty sure FNAME(sync_page) could dirty an entire page worth of
SPTEs, and that's waaay too deep to bail from.

Oof, loking at sync_page(), that's a bug in patch 1.  make_spte() guards the call
to mark_page_dirty_in_slot() with kvm_slot_dirty_track_enabled(), which means it
won't honor the dirty quota unless dirty logging is enabled.  Probably not an issue
for the intended use case, but it'll result in wrong stats, and technically the
dirty quota can be enabled without dirty logging being enabled.

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 4739b53c9734..df0349be388b 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -182,7 +182,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
                  "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
                  get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));

-       if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
+       if (spte & PT_WRITABLE_MASK) {
                /* Enforced by kvm_mmu_hugepage_adjust. */
                WARN_ON(level > PG_LEVEL_4K);
                mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);


And thinking more about silly edge cases, VMX's big emulation loop for invalid
guest state when unrestricted guest is disabled should probably explicitly check
the dirty quota.  Again, I doubt it matters to anyone's use case, but it is treated
as a full run loop for things like pending signals, it'd be good to be consistent.

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 84a7500cd80c..5e1ae373634c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5511,6 +5511,9 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
                 */
                if (__xfer_to_guest_mode_work_pending())
                        return 1;
+
+               if (!kvm_vcpu_check_dirty_quota(vcpu))
+                       return 0;
        }

        return 1;
