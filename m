Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247DC4561BB
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 18:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbhKRRtx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 12:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbhKRRtw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 12:49:52 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C00AC061574
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 09:46:52 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id n85so6752374pfd.10
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 09:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dsuS3eNeB8b/qtXnY2xvDYGXR2aF7cv/Utbyr7HwpZA=;
        b=kmIXIDpZKfMR/NLa0O906BLDK/RjljRK9R6Sev/H8rW+mo9l8vc+XFwam2QfYFDf8d
         rLqkSbqOnHSQDEVr59nJeNE8cUzWq/HdRNJABphWTVZQu/EaR3ZyH+7cxI4ZwEc/fS3w
         s3s1qUI2fiLk4gfzk9HYv68VEIz2xeswu91VDOTKDHABkKEvFLUv+pecNx7AWl9vZM2w
         bD5S/YBIjPSUeKp46q4ImDBWxzkKDAZRRotPTqdCgy2CeSu1XFieeDoqQgzxcVH9Jt5t
         +Ojltgu8EpXRcoJtBLduaFRD6AHlEBsLm82OIampANd1NI5Y425dQ+4zmCBt1ttIZc/k
         Bh6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dsuS3eNeB8b/qtXnY2xvDYGXR2aF7cv/Utbyr7HwpZA=;
        b=Kfb1TFL58UYpslT+D7EKdAgX8Wot448AqUV+v76CI6rst3cCfXTBn60ZTFqGwdePxZ
         BU5N0ijX0LiKLTXNOwCoIcR49HDBczHNEqYag8V4QhcjslOtDge0UIuzvz/RfjduZBKR
         vyoXcvMwajM/xKDazeQRZb8omECFPzx8IF6ZY2zcmTyfNo/qazW/0d9Xl0wX6WajBc5D
         kPAqN09D+VxHKjnJTI1m94UKHdlNNriv0df6XV5SR9U33Y5YfmTYGWQqezUFllodQ0Cg
         hgoMqLAT66TY7llQYo6WTChwpsKxpjw/tDLagfxMivz4JtwxVZkxoXL/HVbjcBk8cWog
         Q8rA==
X-Gm-Message-State: AOAM531bBOH2Vnb85l/btZmFiPpjEnyaiCYVIdN8HeYuhgArhCDWJCzI
        yHRgEYbewoE7RaRnxnIwgNQcsg==
X-Google-Smtp-Source: ABdhPJwn1QMptzOpvmAEQGwbpEHuiPLZqhKPlaPSu9L1Vt2ay/FTo0QEguavjO4yD/S14Xlcay5lyA==
X-Received: by 2002:a63:1343:: with SMTP id 3mr12737422pgt.326.1637257611806;
        Thu, 18 Nov 2021 09:46:51 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j17sm216834pgh.85.2021.11.18.09.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 09:46:51 -0800 (PST)
Date:   Thu, 18 Nov 2021 17:46:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH 0/6] KVM: Dirty Quota-Based VM Live Migration
 Auto-Converge
Message-ID: <YZaRh0wzg4DW4J0B@google.com>
References: <20211114145721.209219-1-shivam.kumar1@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211114145721.209219-1-shivam.kumar1@nutanix.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 14, 2021, Shivam Kumar wrote:
> One possible approach to distributing the overall scope of dirtying for a
> dirty quota interval is to equally distribute it among all the vCPUs. This
> approach to the distribution doesn't make sense if the distribution of
> workloads among vCPUs is skewed. So, to counter such skewed cases, we
> propose that if any vCPU doesn't need its quota for any given dirty
> quota interval, we add this quota to a common pool. This common pool (or
> "common quota") can be consumed on a first come first serve basis
> by all vCPUs in the upcoming dirty quota intervals.

Why not simply use a per-VM quota in combination with a percpu_counter to avoid bouncing
the dirty counter?

> Design
> ----------
> ----------
> 
> Initialization
> 

Feedback that applies to all patches:

> vCPUDirtyQuotaContext keeps the dirty quota context for each vCPU. It keeps

CamelCase is very frowned upon, please use whatever_case_this_is_called.

The SOB chains are wrong.  The person physically posting the patches needs to have
their SOB last, as they are the person who last handled the patches.

  Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
  Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
  Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
  Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
  Signed-off-by: Manish Mishra <manish.mishra@nutanix.com>

These needs a Co-developed-by.  The only other scenario is that you and Anurag
wrote the patches, then handed them off to Shaju, who sent them to Manish, who
sent them back to you for posting.  I highly doubt that's the case, and if so,
I would hope you've done due diligence to ensure what you handed off is the same
as what you posted, i.e. the SOB chains for Shaju and Manish can be omitted.

In general, please read through most of the stuff in Documentation/process.

> the number of pages the vCPU has dirtied (dirty_counter) in the ongoing
> dirty quota interval, and the maximum number of dirties allowed for the
> vCPU (dirty_quota) in the ongoing dirty quota interval.
> 
> struct vCPUDirtyQuotaContext {
> u64 dirty_counter;
> u64 dirty_quota;
> };
> 
> The flag dirty_quota_migration_enabled determines whether dirty quota-based
> throttling is enabled for an ongoing migration or not.
> 
> 
> Handling page dirtying
> 
> When the guest tries to dirty a page, it leads to a vmexit as each page is
> write-protected. In the vmexit path, we increment the dirty_counter for the
> corresponding vCPU. Then, we check if the vCPU has exceeded its quota. If
> yes, we exit to userspace with a new exit reason KVM_EXIT_DIRTY_QUOTA_FULL.
> This "quota full" event is further handled on the userspace side. 
> 
> 
> Please find the KVM Forum presentation on dirty quota-based throttling
> here: https://www.youtube.com/watch?v=ZBkkJf78zFA
> 
> 
> Shivam Kumar (6):
>   Define data structures for dirty quota migration.
>   Init dirty quota flag and allocate memory for vCPUdqctx.
>   Add KVM_CAP_DIRTY_QUOTA_MIGRATION and handle vCPU page faults.
>   Increment dirty counter for vmexit due to page write fault.
>   Exit to userspace when dirty quota is full.
>   Free vCPUdqctx memory on vCPU destroy.

Freeing memory in a later patch is not an option.  The purpose of splitting is
to aid bisection and make the patches more reviewable, not to break bisection and
confuse reviewers.  In general, there are too many patches and things are split in
weird ways, making this hard to review.  This can probably be smushed to two
patches: 1) implement the guts, 2) exposed to userspace and document.

>  Documentation/virt/kvm/api.rst        | 39 +++++++++++++++++++
>  arch/x86/include/uapi/asm/kvm.h       |  1 +
>  arch/x86/kvm/Makefile                 |  3 +-
>  arch/x86/kvm/x86.c                    |  9 +++++
>  include/linux/dirty_quota_migration.h | 52 +++++++++++++++++++++++++
>  include/linux/kvm_host.h              |  3 ++
>  include/uapi/linux/kvm.h              | 11 ++++++
>  virt/kvm/dirty_quota_migration.c      | 31 +++++++++++++++

I do not see any reason to add two new files for 84 lines, which I'm pretty sure
we can trim down significantly in any case.  Paolo has suggested creating files
for the mm side of generic kvm, the helpers can go wherever that lands.

>  virt/kvm/kvm_main.c                   | 56 ++++++++++++++++++++++++++-
>  9 files changed, 203 insertions(+), 2 deletions(-)
>  create mode 100644 include/linux/dirty_quota_migration.h
>  create mode 100644 virt/kvm/dirty_quota_migration.c

As for the design, allocating a separate page for 16 bytes is wasteful and adds
complexity that I don't think is strictly necessary.  Assuming the quota isn't
simply a per-VM thing....

Rather than have both the count and the quote writable by userspace, what about
having KVM_CAP_DIRTY_QUOTA_MIGRATION (renamed to just KVM_CAP_DIRTY_QUOTA, because
dirty logging can technically be used for things other than migration) define a
default, per-VM dirty quota, that is snapshotted by each vCPU on creation.  The
ioctl() would need to be rejected if vCPUs have been created, but it already needs
something along those lines because currently it has a TOCTOU race and can also
race with vCPU readers.

Anyways, vCPUs snapshot a default quota on creation, and then use struct kvm_run to
update the quota upon return from userspace after KVM_EXIT_DIRTY_QUOTA_FULL instead
of giving userspace free reign to change it the quota at will.  There are a variety
of ways to leverage kvm_run, the simplest I can think of would be to define the ABI
such that calling KVM_RUN with "exit_reason == KVM_EXIT_DIRTY_QUOTA_FULL" would
trigger an update.  That would do the right thing even if userspace _doesn't_ update
the count/quota, as KVM would simply copy back the original quota/count and exit back
to userspace.

E.g.

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 78f0719cc2a3..d4a7d1b7019e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -487,6 +487,11 @@ struct kvm_run {
                        unsigned long args[6];
                        unsigned long ret[2];
                } riscv_sbi;
+               /* KVM_EXIT_DIRTY_QUOTA_FULL */
+               struct {
+                       u64 dirty_count;
+                       u64 dirty_quota;
+               }
                /* Fix the size of the union. */
                char padding[256];
        };


Side topic, it might make sense to have the counter be a stat, the per-vCPU dirty
rate could be useful info even if userspace isn't using quotas.
