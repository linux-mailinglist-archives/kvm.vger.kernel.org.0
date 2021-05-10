Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726BE379772
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 21:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbhEJTK5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 15:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbhEJTK4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 15:10:56 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D184AC06175F
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 12:09:49 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id k15so1238791pgb.10
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 12:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mgdZMcvNYkjsPLV9hPmFw01fQwD6bWf6+x+1xi3tISM=;
        b=IfKnIJ2VyxRci+J3kp/Ql6Eo/hXM5QZS9Ez8aaAfuPw2VqWGOlPvLChA+WTXTku1WF
         to8/CPTQ/4FjOZGWfJGVg+pFCncRzBM1G/+CkT9P6wkD+rH8Qwg/F9l7bSZ9Q+JKV9FU
         3Zl4YsKDWBHNtWKIRLAf3PRd2zJs+Swv1lsyZPjFoR5RHQdrM7H/4IHScEI9Ty/PqCNG
         iVBA7HczDKmpe+LJN3OkoUoT0t9tF8dpziH/R3CDyiF46F1qQCqSczMju563Wbup8Fgd
         W0J1NzCp38TK50mWTieOhtjgR9qLaACLQcMOvAfHIle9rpvgX25nr7ZafJ3/wApV4Q0W
         nNAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mgdZMcvNYkjsPLV9hPmFw01fQwD6bWf6+x+1xi3tISM=;
        b=Jx7fn7WXJm+QSrtixPmYK9NGpNZxEFDD7D3u+48N8FU3KBMi2ljgxLQPECpMTRc0HX
         Wmasr8Rq5ZG2cyqL3i9MTGeaLFRC+BfD+flHB2PWc/Osq/wMlK+pCTPJ6vxr06lRl/fJ
         WY3XjJvbGxpYNw3ca1bcTa+zRxwmOR4mSCOI2HLUFCghSIost3yKggW5Bwtki0gPzBL1
         hIjo7GyBFvxBQgf/JQfP4jz5hb+JDx2GacLIMI3CzIHU3Vwz4oMeSLjXU1n8Ud8cBzad
         Tcylvyl2sWFlQ1z+QqiHKBRHTQsFGhsKItl8xOpImcKLkrtBzB3+YttD4j1K3lgrtAf4
         HCUQ==
X-Gm-Message-State: AOAM532fBWv/nsDcxAJLVY5AWUHLHo5hwsiUK9fjnWj6hGB/bw5Ib6Gz
        Yni4OEgP3qyTccZg5wF+mujKLg==
X-Google-Smtp-Source: ABdhPJw12h8+tFsY3t4ukeyKuMFQPy8tkkLsjsvVjJVLAzv6rMc55IvUbCU6a4WkCrbyUljO9MEpyA==
X-Received: by 2002:a62:e203:0:b029:28e:8267:e02e with SMTP id a3-20020a62e2030000b029028e8267e02emr26746639pfi.75.1620673789134;
        Mon, 10 May 2021 12:09:49 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id z25sm12528938pgu.89.2021.05.10.12.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 12:09:48 -0700 (PDT)
Date:   Mon, 10 May 2021 19:09:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM updates for Linux 5.13-rc2
Message-ID: <YJmE+NpAt4GTw/ZK@google.com>
References: <20210510181441.351452-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510181441.351452-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021, Paolo Bonzini wrote:
> Linus,
> 
> The following changes since commit 9ccce092fc64d19504fa54de4fd659e279cc92e7:
> 
>   Merge tag 'for-linus-5.13-ofs-1' of git://git.kernel.org/pub/scm/linux/kernel/git/hubcap/linux (2021-05-02 14:13:46 -0700)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
> 
> for you to fetch changes up to ce7ea0cfdc2e9ff31d12da31c3226deddb9644f5:
> 
>   KVM: SVM: Move GHCB unmapping to fix RCU warning (2021-05-07 06:06:23 -0400)
> 
> Thomas Gleixner and Michael Ellerman had some KVM changes in their
> late merge window pull requests, but there are no conflicts.
> 
> ----------------------------------------------------------------
> Sean Christopherson (17):
>       KVM: VMX: Do not advertise RDPID if ENABLE_RDTSCP control is unsupported
>       KVM: x86: Emulate RDPID only if RDTSCP is supported
>       KVM: SVM: Inject #UD on RDTSCP when it should be disabled in the guest
>       KVM: x86: Move RDPID emulation intercept to its own enum
>       KVM: VMX: Disable preemption when probing user return MSRs
>       KVM: SVM: Probe and load MSR_TSC_AUX regardless of RDTSCP support in host
>       KVM: x86: Add support for RDPID without RDTSCP
>       KVM: VMX: Configure list of user return MSRs at module init

I'm guessing I'm too late as usual and the hashes are set in stone, but just in
case I'm not...

This patch (commit b6194b94a2ca, "KVM: VMX: Configure...) has a bug that Maxim
found during code review.  The bug is eliminated by the very next patch (commit
e7f5ab87841c), but it will break bisection if bisection involves running a KVM
guest.  At a glance, even syzkaller will be affected :-(

>       KVM: VMX: Use flag to indicate "active" uret MSRs instead of sorting list
>       KVM: VMX: Use common x86's uret MSR list as the one true list
>       KVM: VMX: Disable loading of TSX_CTRL MSR the more conventional way
>       KVM: x86: Export the number of uret MSRs to vendor modules
>       KVM: x86: Move uret MSR slot management to common x86
>       KVM: x86: Tie Intel and AMD behavior for MSR_TSC_AUX to guest CPU model
>       KVM: x86: Hide RDTSCP and RDPID if MSR_TSC_AUX probing failed
>       KVM: x86: Prevent KVM SVM from loading on kernels with 5-level paging
>       KVM: SVM: Invert user pointer casting in SEV {en,de}crypt helpers
