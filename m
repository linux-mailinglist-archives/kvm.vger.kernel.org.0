Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECD56170A6
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbiKBW1d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiKBW1b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:27:31 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC19100A
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:27:30 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id y13so17678977pfp.7
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IkisCoYjfZaTobaBNzuvGkutbPUag6VJeOaYOz4JBAQ=;
        b=AQER4z7tFb0LF1x7APVk/7A/ow3nhFpQBzb68WILdjmb9/J8BP/+FmiJvfG/QJG3QM
         myCt6XknexcTh1afQOzkYqHg8wCsST+fj2NblSGEUsBMiki0qmOGhddpgZ6GGy4/MH65
         TgAD3S4a/p9hO82cEg+68U4CrTdIdUHPAG/zEQ+irNvDFzKG+S5L83bK/J9tQjyCijSB
         wyevGfiFC/AjWJ9WZH7/tPskPrghURJoVM2YFY9q8vaPQ+v+sGxEzEIIAaOHljoGoKmj
         kT7iBrNzbRSBPZzFt2HT7rQfrfvnND9m1HiZvcKPlDOG1KSCpvgtWYY/ywOe1umw03s0
         qr3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IkisCoYjfZaTobaBNzuvGkutbPUag6VJeOaYOz4JBAQ=;
        b=Z/vRm/tiNxuM4h+AGmrKnoZFCwWaS2RG4T9qe8NQaQ5LE0iq4ydcQ+lQ4WFz6yGoW1
         /lGF4ONSg98rPsAOkBI95SSvJpZbZJYo+N87HpKnCrRiY9OsJTRJTHQkagGciUAPl6q/
         QDR34i6j7TTO1xY52FZq1YdY0p71luKHYnmet26vt0IOGGyY4JSiSKoVEOQUfbgyG1vb
         jmIoRy4PVCAIll5q32ovZtaqcw7c5jRR4osJd4P6OR+LP1sDSdPxFemwvCUm8S9ZDYbS
         sHpvJzvNf6dQjEvuO5+ofFDhovCrLimpaYVUk39faS/2Azwias2Rg16YlEJ6QduIUAKm
         hF8w==
X-Gm-Message-State: ACrzQf2dA5kamGXOrtMwJ/JxWM0L6UdTEjcAkregHtkoY880dWTFS1rb
        QzjO8oWqOUJYqn+oHvlEtQl9mw==
X-Google-Smtp-Source: AMsMyM63tr6xPjeShe/zYBHapBuuod3N0OMncBiNhz5WYrNqwP+Xm85PGNLPsqIvQnFwbXrjZ5rQeA==
X-Received: by 2002:a05:6a02:10a:b0:461:26b8:1c95 with SMTP id bg10-20020a056a02010a00b0046126b81c95mr22449088pgb.503.1667428049896;
        Wed, 02 Nov 2022 15:27:29 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t29-20020aa7947d000000b005625d6d2999sm8945409pfq.187.2022.11.02.15.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 15:27:29 -0700 (PDT)
Date:   Wed, 2 Nov 2022 22:27:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Anish Ghulati <aghulati@google.com>,
        Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH v2] KVM: x86: Use SRCU to protect zap in
 __kvm_set_or_clear_apicv_inhibit()
Message-ID: <Y2Luzh+6aErzgeU4@google.com>
References: <20221102205359.1260980-1-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102205359.1260980-1-bgardon@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 02, 2022, Ben Gardon wrote:
> kvm_zap_gfn_range() must be called in an SRCU read-critical section, but
> there is no SRCU annotation in __kvm_set_or_clear_apicv_inhibit(). This
> can lead to the following warning via
> kvm_arch_vcpu_ioctl_set_guest_debug() if a Shadow MMU is in use (TDP
> MMU disabled or nesting):
> 
> [ 1416.659809] =============================
> [ 1416.659810] WARNING: suspicious RCU usage
> [ 1416.659839] 6.1.0-dbg-DEV #1 Tainted: G S        I
> [ 1416.659853] -----------------------------
> [ 1416.659854] include/linux/kvm_host.h:954 suspicious rcu_dereference_check() usage!
> [ 1416.659856]
> ...
> [ 1416.659904]  dump_stack_lvl+0x84/0xaa
> [ 1416.659910]  dump_stack+0x10/0x15
> [ 1416.659913]  lockdep_rcu_suspicious+0x11e/0x130
> [ 1416.659919]  kvm_zap_gfn_range+0x226/0x5e0
> [ 1416.659926]  ? kvm_make_all_cpus_request_except+0x18b/0x1e0
> [ 1416.659935]  __kvm_set_or_clear_apicv_inhibit+0xcc/0x100
> [ 1416.659940]  kvm_arch_vcpu_ioctl_set_guest_debug+0x350/0x390
> [ 1416.659946]  kvm_vcpu_ioctl+0x2fc/0x620
> [ 1416.659955]  __se_sys_ioctl+0x77/0xc0
> [ 1416.659962]  __x64_sys_ioctl+0x1d/0x20
> [ 1416.659965]  do_syscall_64+0x3d/0x80
> [ 1416.659969]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Always take the KVM SRCU read lock in __kvm_set_or_clear_apicv_inhibit()
> to protect the GFN to memslot translation. The SRCU read lock is not
> technically required when no Shadow MMUs are in use, since the TDP MMU
> walks the paging structures from the roots and does not need to look up
> GFN translations in the memslots, but make the SRCU locking
> unconditional for simplicty.
> 
> In most cases, the SRCU locking is taken care of in the vCPU run loop,
> but when called through the KVM_SET_GUEST_DEBUG IOCTL, the SRCU read
> lock is missing.

Nit, it not just KVM_SET_GUEST_DEBUG.  If it were just KVM_SET_GUEST_DEBUG, I
might have advocated putting the fix KVM_SET_GUEST_DEBUG.

> Tested: ran tools/testing/selftests/kvm/x86_64/debug_regs on a DBG
> 	build. This patch causes the suspicious RCU warning to disappear.
> 	Note that the warning is hit in __kvm_zap_rmaps(), so
> 	kvm_memslots_have_rmaps() must return true in order for this to
> 	repro (i.e. the TDP MMU must be off or nesting in use.)
> 
> Reported-by: Greg Thelen <gthelen@google.com>
> Fixes: 36222b117e36 ("KVM: x86: don't disable APICv memslot when inhibited")
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
