Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57CF65A688A
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 18:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiH3Qjs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 12:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiH3Qjm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 12:39:42 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA610F4CA6
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 09:39:40 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 202so11158416pgc.8
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 09:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=pl55VXe93/eaO0FUVnAmZsJ/zazORbEd4JyeTN5FBe4=;
        b=sZgXb5KpzMUVlNOho2xaCwjrAWnIlnrZN1gJPO3IgB9x1NBNG29CgcunjlA9ivT9H7
         s5H/USTsix57ZV0JFU3nPfp4rPj2uNtudj0tUw1jazx141DfcRDxLITv58Kzly1WSKHK
         8K9gyHaS+3ApLeOUSgobFhBB+hb+CQIuDB6ArR1LoBTC7er33hbOT7otFQaPt7ZITjAm
         Y67NCDjK7bG2D4ZBsIhqWqpe7dffoGOHLWm4kCAW9AFRwlr+c4R8z9GXjok0KM1O5AAY
         /m3es1uFOIODCixancuXpGVaVtWbPlPo9ZL6bM+Q/Q9redH81UMwb42SPgRFoh2YEjJu
         X0jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=pl55VXe93/eaO0FUVnAmZsJ/zazORbEd4JyeTN5FBe4=;
        b=Qd3VVXpKUi3LeDkn/oXoF5D5okMJWpGK5iR0IY656Ut8FyEOf6BDwA49XEehD+XOY6
         vGbKUq/xBtZhrMCRtW8/2QeXs4HUhg7gvGofS4LIPPxxWDQgX/Ecz1SS1yBve6HciEs8
         KMb92D4AthXuZfzS5CwBhURVdMGhxBECLvRC+auBdI8tuRgH8vUG+qyjubCqn2lBf1lG
         n8yhPDTaueaxznFdzINoj3y/fyc0SeBVrUW4VBmayzAXSwt1opnecB+r8D/noP8sLmpQ
         PttyfTUT1TB/DVdkBKE9Fo4aLkQ8C4EOTz1e0/Jr7gmjB+4nP99swTr5Wqu7e33JgZqz
         Io6A==
X-Gm-Message-State: ACgBeo2grmlykH+y/fjkKKMb7OR1sWr0O1xC1Td60q0QP4d/NiEYrDpF
        snZBeC6GbEc4FXJVl38pvRXCZQ==
X-Google-Smtp-Source: AA6agR4AVDmhFbBbfKgvLudxGxu9UQHNDJLIegcdirau76BaDeGU/eLzJVxV7sDPnzAHexeFt9BqTw==
X-Received: by 2002:a63:804a:0:b0:42b:8b81:72b8 with SMTP id j71-20020a63804a000000b0042b8b8172b8mr15825444pgd.218.1661877580215;
        Tue, 30 Aug 2022 09:39:40 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t12-20020a62d14c000000b0052f3a7bc29fsm9564837pfl.202.2022.08.30.09.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 09:39:39 -0700 (PDT)
Date:   Tue, 30 Aug 2022 16:39:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v2 2/2] KVM: x86: update documentation for MSR filtering
Message-ID: <Yw49SBBvP6jTLcAw@google.com>
References: <20220712001045.2364298-1-aaronlewis@google.com>
 <20220712001045.2364298-3-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712001045.2364298-3-aaronlewis@google.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 12, 2022, Aaron Lewis wrote:
> Update the documentation to ensure best practices are used by VMM
> developers when using KVM_X86_SET_MSR_FILTER and
> KVM_CAP_X86_USER_SPACE_MSR.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 5c651a4e4e2c..bd7d081e960f 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4178,7 +4178,14 @@ KVM does guarantee that vCPUs will see either the previous filter or the new
>  filter, e.g. MSRs with identical settings in both the old and new filter will
>  have deterministic behavior.
>  
> +When using filtering for the purpose of deflecting MSR accesses to userspace,
> +exiting[1] **must** be enabled for the lifetime of filtering.  That is to say,
> +exiting needs to be enabled before filtering is enabled, and exiting needs to
> +remain enabled until after filtering has been disabled.  Doing so avoids the
> +case where when an MSR access is filtered, instead of deflecting it to
> +userspace as intended a #GP is injected in the guest.

Ugh, this entire section is a mess.  Among other issues, it never explicitly states
how MSR filtering interacts with KVM_CAP_X86_USER_SPACE_MSR.  This paragraph just
says filtering can be combined with the capability, but doesn't actually document
how KVM merges the two features.

  If an MSR access is not permitted through the filtering, it generates a
  #GP inside the guest. When combined with KVM_CAP_X86_USER_SPACE_MSR, that
  allows user space to deflect and potentially handle various MSR accesses
  into user space.

I also dislike the "deflecting" terminology.  Not because it's inaccurate, but
because KVM uses "intercepting" in pretty much every other piece of documentation.

> +[1] KVM_CAP_X86_USER_SPACE_MSR set with exit reason KVM_MSR_EXIT_REASON_FILTER.
>  
>  4.98 KVM_CREATE_SPAPR_TCE_64
>  ----------------------------
> @@ -7191,6 +7198,16 @@ KVM_EXIT_X86_RDMSR and KVM_EXIT_X86_WRMSR exit notifications which user space
>  can then handle to implement model specific MSR handling and/or user notifications
>  to inform a user that an MSR was not handled.
>  
> +When using filtering[1] for the purpose of deflecting MSR accesses to
> +userspace, exiting[2] **must** be enabled for the lifetime of filtering.  That
> +is to say, exiting needs to be enabled before filtering is enabled, and exiting
> +needs to remain enabled until after filtering has been disabled.  Doing so
> +avoids the case where when an MSR access is filtered, instead of deflecting it
> +to userspace as intended a #GP is injected in the guest.

Instead of copy-paste, I would rather just redirect the reader to KVM_X86_SET_MSR_FILTER
for details.

I'll post the below in a separate series for review.  I'm planning on queueing
patch 1, and there are other cleanups I want to do, e.g. KVM_CAP_X86_USER_SPACE_MSR
calls them MSR "traps", but that's misleading because "trap" in KVM x86 typically
means the interception happens _after_ the instruction has executed.

---
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Aug 2022 09:15:05 -0700
Subject: [PATCH] KVM: x86: Reword MSR filtering docs to more precisely define
 behavior

Reword the MSR filtering documentatiion to more precisely define the
behavior of filtering using common virtualization terminology.

  - Explicitly document KVM's behavior when an MSR is denied
  - s/handled/allowed as there is no guarantee KVM will "handle" the
    MSR access
  - Drop the "fall back" terminology, which incorrectly suggests that
    there is existing KVM behavior to fall back to
  - Fix an off-by-one error in the range (the end is exclusive)
  - Call out the interaction between MSR filtering and
    KVM_CAP_X86_USER_SPACE_MSR's KVM_MSR_EXIT_REASON_FILTER
  - Delete the redundant paragraph on what '0' and '1' in the bitmap
    means, it's covered by the sections on KVM_MSR_FILTER_{READ,WRITE}
  - Delete the clause on x2APIC MSR behavior depending on APIC base, this
    is covered by stating that KVM follows architectural behavior when
    emulating/virtualizing MSR accesses

Reported-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst | 68 +++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 5148b431ed13..2e0326cf85b1 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4104,15 +4104,15 @@ flags values for ``struct kvm_msr_filter_range``:
 ``KVM_MSR_FILTER_READ``
 
   Filter read accesses to MSRs using the given bitmap. A 0 in the bitmap
-  indicates that a read should immediately fail, while a 1 indicates that
-  a read for a particular MSR should be handled regardless of the default
+  indicates that read accesses should be denied, while a 1 indicates that
+  a read for a particular MSR should be allowed regardless of the default
   filter action.
 
 ``KVM_MSR_FILTER_WRITE``
 
   Filter write accesses to MSRs using the given bitmap. A 0 in the bitmap
-  indicates that a write should immediately fail, while a 1 indicates that
-  a write for a particular MSR should be handled regardless of the default
+  indicates that write accesses should be denied, while a 1 indicates that
+  a write for a particular MSR should be allowed regardless of the default
   filter action.
 
 flags values for ``struct kvm_msr_filter``:
@@ -4120,57 +4120,55 @@ flags values for ``struct kvm_msr_filter``:
 ``KVM_MSR_FILTER_DEFAULT_ALLOW``
 
   If no filter range matches an MSR index that is getting accessed, KVM will
-  fall back to allowing access to the MSR.
+  allow accesses to all MSRs by default.
 
 ``KVM_MSR_FILTER_DEFAULT_DENY``
 
   If no filter range matches an MSR index that is getting accessed, KVM will
-  fall back to rejecting access to the MSR. In this mode, all MSRs that should
-  be processed by KVM need to explicitly be marked as allowed in the bitmaps.
+  deny accesses to all MSRs by default.
 
-This ioctl allows user space to define up to 16 bitmaps of MSR ranges to
-specify whether a certain MSR access should be explicitly filtered for or not.
+This ioctl allows userspace to define up to 16 bitmaps of MSR ranges to deny
+guest MSR accesses that would normally be allowed by KVM.  If an MSR is not
+covered by a specific range, the "default" filtering behavior applies.  Each
+bitmap range covers MSRs from [base .. base+nmsrs).
 
-If this ioctl has never been invoked, MSR accesses are not guarded and the
-default KVM in-kernel emulation behavior is fully preserved.
+If an MSR access is denied by userspace, the resulting KVM behavior depends on
+whether or not KVM_CAP_X86_USER_SPACE_MSR's KVM_MSR_EXIT_REASON_FILTER is
+enabled.  If KVM_MSR_EXIT_REASON_FILTER is enabled, KVM will exit to userspace
+on denied accesses, i.e. userspace effectively intercepts the MSR access.  If
+KVM_MSR_EXIT_REASON_FILTER is not enabled, KVM will inject a #GP into the guest
+on denied accesses.
+
+If an MSR access is allowed by userspace, KVM's will emulate and/or virtualize
+the access in accordance with the vCPU model.  Note, KVM may still ultimately
+inject a #GP if an access is allowed by userspace, e.g. if KVM doesn't support
+the MSR, or to follow architectural behavior for the MSR.
+
+By default, KVM operates in KVM_MSR_FILTER_DEFAULT_ALLOW mode with no MSR range
+filters.
 
 Calling this ioctl with an empty set of ranges (all nmsrs == 0) disables MSR
 filtering. In that mode, ``KVM_MSR_FILTER_DEFAULT_DENY`` is invalid and causes
 an error.
 
-As soon as the filtering is in place, every MSR access is processed through
-the filtering except for accesses to the x2APIC MSRs (from 0x800 to 0x8ff);
-x2APIC MSRs are always allowed, independent of the ``default_allow`` setting,
-and their behavior depends on the ``X2APIC_ENABLE`` bit of the APIC base
-register.
-
 .. warning::
-   MSR accesses coming from nested vmentry/vmexit are not filtered.
+   MSR accesses as part of nested VM-Enter/VM-Exit are not filtered.
    This includes both writes to individual VMCS fields and reads/writes
    through the MSR lists pointed to by the VMCS.
 
-If a bit is within one of the defined ranges, read and write accesses are
-guarded by the bitmap's value for the MSR index if the kind of access
-is included in the ``struct kvm_msr_filter_range`` flags.  If no range
-cover this particular access, the behavior is determined by the flags
-field in the kvm_msr_filter struct: ``KVM_MSR_FILTER_DEFAULT_ALLOW``
-and ``KVM_MSR_FILTER_DEFAULT_DENY``.
-
-Each bitmap range specifies a range of MSRs to potentially allow access on.
-The range goes from MSR index [base .. base+nmsrs]. The flags field
-indicates whether reads, writes or both reads and writes are filtered
-by setting a 1 bit in the bitmap for the corresponding MSR index.
-
-If an MSR access is not permitted through the filtering, it generates a
-#GP inside the guest. When combined with KVM_CAP_X86_USER_SPACE_MSR, that
-allows user space to deflect and potentially handle various MSR accesses
-into user space.
+   x2APIC MSR accesses cannot be filtered (KVM silently ignores filters that
+   cover any x2APIC MSRs).
 
 Note, invoking this ioctl while a vCPU is running is inherently racy.  However,
 KVM does guarantee that vCPUs will see either the previous filter or the new
 filter, e.g. MSRs with identical settings in both the old and new filter will
 have deterministic behavior.
 
+Similarly, if userspace wishes to intercept on denied accesses,
+KVM_MSR_EXIT_REASON_FILTER must be enabled before activating any filters, and
+left enabled until after all filters are deactivated.  Failure to do so may
+result in KVM injecting a #GP instead of exiting to userspace.
+
 4.98 KVM_CREATE_SPAPR_TCE_64
 ----------------------------
 
@@ -6458,6 +6456,8 @@ wants to write. Once finished processing the event, user space must continue
 vCPU execution. If the MSR write was unsuccessful, user space also sets the
 "error" field to "1".
 
+See KVM_X86_SET_MSR_FILTER for details on the interaction with MSR filtering.
+
 ::
 
 

base-commit: 20909e0b2c47adfcf64c1d5c5af95fc6c3e5f610
-- 

