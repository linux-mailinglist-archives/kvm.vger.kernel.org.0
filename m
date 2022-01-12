Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CD548CD68
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 22:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiALVFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 16:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiALVFH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 16:05:07 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D158AC06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 13:05:06 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id i8-20020a17090a138800b001b3936fb375so14805394pja.1
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 13:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nYpE8qObJY8smRJsa3z2gCeio5ib7kZSmRctEM2XPHQ=;
        b=rkjRW1kY9KNBW9DnAWpTxjgdrVnPLw8wAGoiZADlB18nUm1wBzfboJPdKkwyRCx+hP
         CHmYVo7t1u6RV3udpGlW6iQwS3MnQ0eDYfr2UEoCgfmVZGY+yhFe9dyCo9kYnT/yv2D2
         iPhRTu1vun6WEN9p9bT/DEN/eTNtdTCbqDVt1yqmAZWWPNJ8EcmyTohAxbVesdnFbnhf
         fGjGm0G9qJsK6RY//yIUOuo3x+GKq2EmrP9zPIZ0xQCXc00uJ1m9cdx+hOWXoHsFDNXl
         MZmKJRed+ziINZWB36nAiZsz7d4Gkio2o4bWtpUglwdcCVTlRrfcfoJyr1q5Cz3atbDv
         pxPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nYpE8qObJY8smRJsa3z2gCeio5ib7kZSmRctEM2XPHQ=;
        b=7yhRFBCSG1xkUXk0ScN42GlcLs4umv2qxgj2v0kx+m0d8HHAS0+NvbnnhGS7+fexrv
         rJx98Z01iWgqYDfE14YyyuTkcFSBYLfpRuNzG30lLu18vb6MVaeUxAYXzeDcxTmB+4hR
         JzmAEiPRNwRuqRE1axP8E/jcwSDFgyUieHUSLdO4bH7rwlc4ew1/sqYjamb4SXMmk9Wb
         8ULVsY9BM2QwfnQW8oJ4Yd7c3qt91PhwD1VFmphHcbzzO0o5YSAVa+QqnxvghE0PVmkf
         JpFjxG4BTw5vB/79M4IXL0lMnc412t1ZVjmCvu16Qaom4rLgFx0kvkaQZKrajeLg98rf
         4CxQ==
X-Gm-Message-State: AOAM530sw+CSmsQTJ+/NvA/WwlATeWMl1pGNnfxT0ZAH7amSTN9BrU5X
        k9+xn4uGV8yj4/XAxWo45AbW5Q==
X-Google-Smtp-Source: ABdhPJzDNiAzjEeO1ewhKEFf2+ZnwvCwxaQqzOoYwzaabhtEL3iHda92pPrWRQiHy0IlSnoEeEtdSQ==
X-Received: by 2002:a63:88c7:: with SMTP id l190mr624434pgd.150.1642021506085;
        Wed, 12 Jan 2022 13:05:06 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b4sm6558684pjh.44.2022.01.12.13.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 13:05:05 -0800 (PST)
Date:   Wed, 12 Jan 2022 21:05:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Zhong <yang.zhong@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jun.nakajima@intel.com,
        kevin.tian@intel.com, jing2.liu@linux.intel.com
Subject: Re: [WARNING: UNSCANNABLE EXTRACTION FAILED][PATCH v2 1/3] selftest:
 kvm: Reorder vcpu_load_state steps for AMX
Message-ID: <Yd9CfnNhcQNGsUqA@google.com>
References: <20211222214731.2912361-1-yang.zhong@intel.com>
 <20211222214731.2912361-2-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211222214731.2912361-2-yang.zhong@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 22, 2021, Yang Zhong wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> For AMX support it is recommended to load XCR0 after XFD, so
> that KVM does not see XFD=0, XCR=1 for a save state that will
> eventually be disabled (which would lead to premature allocation
> of the space required for that save state).

It would be very helpful to clarify that XFD is loaded via KVM_SET_MSRS.  It took
me longer than it should have to understand what was going on.  The large amount of
whitespace noise in this patch certainly didn't help.  E.g. just a simple tweak:

  For AMX support it is recommended to load XCR0 after XFD, i.e. after MSRs, so

> It is also required to load XSAVE data after XCR0 and XFD, so
> that KVM can trigger allocation of the extra space required to
> store AMX state.
> 
> Adjust vcpu_load_state to obey these new requirements.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Yang Zhong <yang.zhong@intel.com>
> ---
>  .../selftests/kvm/lib/x86_64/processor.c      | 29 ++++++++++---------
>  1 file changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 00324d73c687..9b5abf488211 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -1192,9 +1192,14 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
>  	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
>  	int r;
>  
> -	r = ioctl(vcpu->fd, KVM_SET_XSAVE, &state->xsave);
> -        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XSAVE, r: %i",
> -                r);
> +	r = ioctl(vcpu->fd, KVM_SET_SREGS, &state->sregs);
> +	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_SREGS, r: %i",
> +		r);

If we're going to bother replacing spaces with tabs, might as well get rid of all
the gratuituous newlines as well.

> +
> +	r = ioctl(vcpu->fd, KVM_SET_MSRS, &state->msrs);
> +	TEST_ASSERT(r == state->msrs.nmsrs,
> +		"Unexpected result from KVM_SET_MSRS,r: %i (failed at %x)",
> +		r, r == state->msrs.nmsrs ? -1 : state->msrs.entries[r].index);

Most people not named "Paolo" prefer to align this with the opening "(" :-)

E.g.

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 97f8c2f2df36..971f41afa689 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1158,44 +1158,36 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
        int r;

        r = ioctl(vcpu->fd, KVM_SET_SREGS, &state->sregs);
-       TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_SREGS, r: %i",
-               r);
+       TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_SREGS, r: %i", r);

        r = ioctl(vcpu->fd, KVM_SET_MSRS, &state->msrs);
        TEST_ASSERT(r == state->msrs.nmsrs,
-               "Unexpected result from KVM_SET_MSRS,r: %i (failed at %x)",
-               r, r == state->msrs.nmsrs ? -1 : state->msrs.entries[r].index);
+                   "Unexpected result from KVM_SET_MSRS,r: %i (failed at %x)",
+                   r, r == state->msrs.nmsrs ? -1 : state->msrs.entries[r].index);

        if (kvm_check_cap(KVM_CAP_XCRS)) {
                r = ioctl(vcpu->fd, KVM_SET_XCRS, &state->xcrs);
-               TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XCRS, r: %i",
-                           r);
+               TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XCRS, r: %i", r);
        }

        r = ioctl(vcpu->fd, KVM_SET_XSAVE, &state->xsave);
-       TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XSAVE, r: %i",
-               r);
+       TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XSAVE, r: %i", r);

        r = ioctl(vcpu->fd, KVM_SET_VCPU_EVENTS, &state->events);
-       TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_VCPU_EVENTS, r: %i",
-               r);
+       TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_VCPU_EVENTS, r: %i", r);

        r = ioctl(vcpu->fd, KVM_SET_MP_STATE, &state->mp_state);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_MP_STATE, r: %i",
-                r);
+        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_MP_STATE, r: %i", r);

        r = ioctl(vcpu->fd, KVM_SET_DEBUGREGS, &state->debugregs);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_DEBUGREGS, r: %i",
-                r);
+        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_DEBUGREGS, r: %i", r);

        r = ioctl(vcpu->fd, KVM_SET_REGS, &state->regs);
-       TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_REGS, r: %i",
-               r);
+       TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_REGS, r: %i", r);

        if (state->nested.size) {
                r = ioctl(vcpu->fd, KVM_SET_NESTED_STATE, &state->nested);
-               TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_NESTED_STATE, r: %i",
-                       r);
+               TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_NESTED_STATE, r: %i", r);
        }
 }

