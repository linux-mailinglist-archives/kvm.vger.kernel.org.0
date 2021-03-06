Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4B132F78F
	for <lists+kvm@lfdr.de>; Sat,  6 Mar 2021 02:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhCFBki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 20:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhCFBkG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 20:40:06 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505C7C061760
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 17:40:06 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id ga23-20020a17090b0397b02900c0b81bbcd4so75328pjb.0
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 17:40:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :in-reply-to;
        bh=xX/55P6fzvPP+kG+riEc/RE6T+vgX3JT/FeKbV8wZec=;
        b=cqkjENhf6SfmvG3cJTO5IOLbDHJOY2IKbtMCIWiigCb/iJinZ+7WIlNn5WPNnlJjJk
         OlR0qk+8k/5RHOBFyZY1pL9CfTMZYtmADUwLHEiCBTwPz0F2OGa/PasdauGZw6/GaNnP
         wNVxyLoEq3mtVfd8E2/Co7Y6onzV1RcXYhY4v2Xr54AwfQ2wtcRfpdaoPWg6wdRd3n7J
         d9FVYBmQ/9C+XNJrCrYrbdJlIomB1TcsxvRNAyVV/cSZbaScNyhOFN6jhkLImiXKa6jq
         mvzAMUrm1+MyGBO0FFvxzo4kNXegZT7YU+/1CC0QYyBdnHnt0KuEVOcT5fRuCnAASykE
         Fwtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to;
        bh=xX/55P6fzvPP+kG+riEc/RE6T+vgX3JT/FeKbV8wZec=;
        b=iVtHuCc+NkjQ5S2ZH6ZzgruDLIxfNwkMJFpMU/sMKj7ChcRI1YQFzQShhQfvC5B4XF
         TuSAWeYmhFKMdxPmnFqYgQHdQZz4kVslFiDEic1+2Vvl1fVUl4I5LrallScjR/9842co
         6nZZBVbBJHbEQuMEi+DnFY1wNWN7c+weIWQltyPuuWwiF2e3/WvoTULElspvhBz/jo/7
         XdmhAQgbu6XrGA/CARO5tKyXHKUWWsf2oUA+AP/RH9wLQpnCy1gCeagaADqmrGsPgxXB
         qdFTSnOU0wDe3DAx7qWTaT9i6vWS1vM+y2gQPv/cHoBZHC/bC34rNz/U1tc6OScIW9yI
         r1kA==
X-Gm-Message-State: AOAM532ia0UqyNnYdQ2a/skkr9rIT6vOzbu8xMpZRpVd2oSMXvtLChek
        Y5Rs4E6K/dlD3SlB0ufKfQdIyQ==
X-Google-Smtp-Source: ABdhPJw4UarDJ5mYAf08tWOWBCaTWJdKCJjmp6ylq+RSgegSnMASdCGiDyV8GCT7AgWZ5jFf78sPNQ==
X-Received: by 2002:a17:90a:f010:: with SMTP id bt16mr13191132pjb.116.1614994805665;
        Fri, 05 Mar 2021 17:40:05 -0800 (PST)
Received: from google.com ([2620:15c:f:10:fc04:f9df:1efb:bf0c])
        by smtp.gmail.com with ESMTPSA id g6sm3609630pfi.15.2021.03.05.17.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 17:40:04 -0800 (PST)
Date:   Fri, 5 Mar 2021 17:39:58 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 03/28] KVM: nSVM: inject exceptions via
 svm_check_nested_events
Message-ID: <YELdblXaKBTQ4LGf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526172308.111575-4-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hopefully I got the In-Reply-To header right...

On Thu, May 28, 2020, Paolo Bonzini wrote:
> This allows exceptions injected by the emulator to be properly delivered
> as vmexits.  The code also becomes simpler, because we can just let all
> L0-intercepted exceptions go through the usual path.  In particular, our
> emulation of the VMX #DB exit qualification is very much simplified,
> because the vmexit injection path can use kvm_deliver_exception_payload
> to update DR6.

Sadly, it's also completely and utterly broken for #UD and #GP, and a bit
sketchy for #AC.

Unless KVM (L0) knowingly wants to override L1, e.g. KVM_GUESTDBG_* cases, KVM
shouldn't do a damn thing except forward the exception to L1 if L1 wants the
exception.

ud_interception() and gp_interception() do quite a bit before forwarding the
exception, and in the case of #UD, it's entirely possible the #UD will never get
forwarded to L1.  #GP is even more problematic because it's a contributory
exception, and kvm_multiple_exception() is not equipped to check and handle
nested intercepts before vectoring the exception, which means KVM will
incorrectly escalate a #GP->#DF and #GP->#DF->Triple Fault instead of exiting
to L1.  That's a wee bit problematic since KVM also has a soon-to-be-fixed bug
where it kills L1 on a Triple Fault in L2...

I think this will fix the bugs, I'll properly test and post next week.

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 90a1704b5752..928e11646dca 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -926,11 +926,11 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
        }
        case SVM_EXIT_EXCP_BASE ... SVM_EXIT_EXCP_BASE + 0x1f: {
                /*
-                * Host-intercepted exceptions have been checked already in
-                * nested_svm_exit_special.  There is nothing to do here,
-                * the vmexit is injected by svm_check_nested_events.
+                * Note, KVM may already have snagged exceptions it wants to
+                * handle even if L1 also wants the exception, e.g. #MC.
                 */
-               vmexit = NESTED_EXIT_DONE;
+               if (vmcb_is_intercept(&svm->nested.ctl, exit_code))
+                       vmexit = NESTED_EXIT_DONE;
                break;
        }
        case SVM_EXIT_ERR: {
@@ -1122,19 +1122,23 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
        case SVM_EXIT_INTR:
        case SVM_EXIT_NMI:
        case SVM_EXIT_NPF:
+       case SVM_EXIT_EXCP_BASE + MC_VECTOR:
                return NESTED_EXIT_HOST;
-       case SVM_EXIT_EXCP_BASE ... SVM_EXIT_EXCP_BASE + 0x1f: {
+       case SVM_EXIT_EXCP_BASE + DB_VECTOR:
+       case SVM_EXIT_EXCP_BASE + BP_VECTOR: {
+               /* KVM gets first crack at #DBs and #BPs, if it wants them. */
                u32 excp_bits = 1 << (exit_code - SVM_EXIT_EXCP_BASE);
                if (svm->vmcb01.ptr->control.intercepts[INTERCEPT_EXCEPTION] &
                    excp_bits)
                        return NESTED_EXIT_HOST;
-               else if (exit_code == SVM_EXIT_EXCP_BASE + PF_VECTOR &&
-                        svm->vcpu.arch.apf.host_apf_flags)
-                       /* Trap async PF even if not shadowing */
-                       return NESTED_EXIT_HOST;
                break;
        }
+       case SVM_EXIT_EXCP_BASE + PF_VECTOR:
+               /* Trap async PF even if not shadowing */
+               if (svm->vcpu.arch.apf.host_apf_flags)
+                       return NESTED_EXIT_HOST;
+               break;
        default:
                break;
        }
