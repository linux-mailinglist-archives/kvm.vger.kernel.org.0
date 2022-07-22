Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03FB857E3C2
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 17:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235189AbiGVP2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 11:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234947AbiGVP1u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 11:27:50 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A739FE06
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 08:27:49 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id y24so4836759plh.7
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 08:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GvsJKETzIYJsxczzHJyFdH4tuugoZF3X8uPibH3AGEA=;
        b=pBOTejsyvveMutjphsKDBUaGpuKUFc4XMUEms1oWqHa/5DDWVtDdI4Jt3EjD+xFc/z
         lefXIIdQA+Cngt0ViiJMfjCrvLVsnHzHqwRDK2Iwp+F/DsQ7MV+jwSdKctK/UVf4qygv
         H9DjCQdrZRApSni5sXt+xLaXiYG25Zfxijifhk0hE+ht3f4BmGce4uebq6+qdbRkvXF4
         Di9jXoMG8Zd0HM8eZm7sI0+Zx4+CSp5xbwACis0wAgafasGHiEUIBoWctM1PTgtwwZiy
         KdYKILzZzLb0WE5xs8kDpDEFKexdDtkVlk0ggkCo0iTkHZ7bBwehl1veNh7SQPQf2vU5
         bXkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GvsJKETzIYJsxczzHJyFdH4tuugoZF3X8uPibH3AGEA=;
        b=faXQw2vqMkHiYlpjizAV9nBlyUyRn7sCAEnYwhj28w71QqkxzOak5+bWC7y9iU29I1
         OpOWXoOvMN+qqmcJmpHgcG9TubErB0guI3DcmR/r9n7EJPoBJKPKYyEixaCPGcM9ua57
         zYgaEFxhOyK0t/3PcLKSZAirRcKPlsOlRqRvcyi9mavirBzpl0ySKjaxjIDqxZDFTl3k
         cwxdDBzI3qB5z6oVQmxquK8+iifnqcMFGLyYAvA3nsNBMVn72vE9IxPfzcMI7bbOvxQw
         A3PTTv9WM409KQnYI8f9be4bI1eUyclBCByhghyphyMOXIynOPvtKyT+gpUPcnm05Zwc
         QiAQ==
X-Gm-Message-State: AJIora+bPaAbxXVP81wjJhqgfnb0F0CwEHCuEpBLqDC44wv19+YSWHvr
        WhSZFUT581K492PToQN7blNuuA==
X-Google-Smtp-Source: AGRyM1vGuWvC3KxSmAdtBwft7NJW+zK/QU+mBC8yea/Nf0X4k4yfoT+8Hs83yK4wxBTWv1gSlNXYZA==
X-Received: by 2002:a17:903:1208:b0:16b:81f6:e992 with SMTP id l8-20020a170903120800b0016b81f6e992mr420562plh.55.1658503668507;
        Fri, 22 Jul 2022 08:27:48 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id m1-20020a170902db0100b0016d295888e3sm3958168plx.241.2022.07.22.08.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 08:27:48 -0700 (PDT)
Date:   Fri, 22 Jul 2022 15:27:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        oliver.upton@linux.dev
Subject: Re: [PATCH] Revert "KVM: nVMX: Do not expose MPX VMX controls when
 guest MPX disabled"
Message-ID: <YtrB8JEuc1Il1EOO@google.com>
References: <20220722104329.3265411-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722104329.3265411-1-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 22, 2022, Paolo Bonzini wrote:
> Since commit 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX controls
> when guest MPX disabled"), KVM has taken ownership of the "load
> IA32_BNDCFGS" and "clear IA32_BNDCFGS" VMX entry/exit controls,
> trying to set these bits in the IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS
> MSRs if the guest's CPUID supports MPX, and clear otherwise.
> 
> The intent of the patch was to apply it to L0 in order to work around
> L1 kernels that lack the fix in commit 691bd4340bef ("kvm: vmx: allow
> host to access guest MSR_IA32_BNDCFGS", 2017-07-04): by hiding the
> control bits from L0, L1 hides BNDCFGS from KVM_GET_MSR_INDEX_LIST,
> and the L1 bug is neutralized even in the lack of commit 691bd4340bef.
> 
> This was perhaps a sensible kludge at the time, but a horrible
> idea in the long term and in fact it has not been extended to
> other CPUID bits like these:
> 
>   X86_FEATURE_LM => VM_EXIT_HOST_ADDR_SPACE_SIZE, VM_ENTRY_IA32E_MODE,
>                     VMX_MISC_SAVE_EFER_LMA
> 
>   X86_FEATURE_TSC => CPU_BASED_RDTSC_EXITING, CPU_BASED_USE_TSC_OFFSETTING,
>                      SECONDARY_EXEC_TSC_SCALING
> 
>   X86_FEATURE_INVPCID_SINGLE => SECONDARY_EXEC_ENABLE_INVPCID
> 
>   X86_FEATURE_MWAIT => CPU_BASED_MONITOR_EXITING, CPU_BASED_MWAIT_EXITING
> 
>   X86_FEATURE_INTEL_PT => SECONDARY_EXEC_PT_CONCEAL_VMX, SECONDARY_EXEC_PT_USE_GPA,
>                           VM_EXIT_CLEAR_IA32_RTIT_CTL, VM_ENTRY_LOAD_IA32_RTIT_CTL
> 
>   X86_FEATURE_XSAVES => SECONDARY_EXEC_XSAVES
> 
> These days it's sort of common knowledge that any MSR in
> KVM_GET_MSR_INDEX_LIST must allow *at least* setting it with KVM_SET_MSR
> to a default value, so it is unlikely that something like commit
> 5f76f6f5ff96 will be needed again.  So revert it, at the potential cost
> of breaking L1s with a 6 year old kernel.  

I would further qualify this with "breaking L1s with an _unpatched_ 6 year old
kernel".  That fix was tagged for stable and made it way to at least the 4.9 and
4.4 LTS releases.

> While in principle the L0 owner doesn't control what runs on L1, such an old
> hypervisor would probably have many other bugs.

And patching KVM to workaround L1 Linux bugs never ends well, e.g. see also the
hypercall patching snafu.

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
