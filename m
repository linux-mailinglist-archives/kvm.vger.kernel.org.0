Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C6842F5FD
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 16:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240707AbhJOOr1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 10:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240681AbhJOOr0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 10:47:26 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CF8C061764
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 07:45:20 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id om14so7328364pjb.5
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 07:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IR+QEQspy4/zxmXMc2vgWc5H1UTYOLUo1wLeanr8/iQ=;
        b=JqXMJt0uSact6gDgr7GsbCywSysEhx1l3R1P9FVoW8uu4jcfpO9K9RUybkSYCsn0RO
         gat9vT4x/AHt4hFlagf7TdqR1xHuNeFpAi0VcFreIddYrFuyQOpiTpbe+75hlQq8K0/Y
         CfliDt0jSrkhyHCTziU/FwCmMz8Dl4VzCorZCFZkQg/KAt2KaSNey6G0IcOS/xIhFXUw
         YREPPvppHI9mOl0mTiO6pbvYy7TVKHzNRmE4SkjIEtoATziIpwjF3fDG80xXsmhmh1CZ
         gqovCJMK3LZFhzWA4kTVtQSZh84xTjewVKRZ4c0ZMSQzVMfukm61fw/ixyehvmM68fBL
         B75Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IR+QEQspy4/zxmXMc2vgWc5H1UTYOLUo1wLeanr8/iQ=;
        b=sRePrYbmQNmDNSLTMxyW0teC2f+qS9zx7DlMRSpnvIWNukYtJLYx6csF6kFA51cCAU
         LVArQ4UeLX0PkeKiusTH8v5+3f7Rtv9zBZrrfU3c4hpIsX5XL5gOXGj1T/s71nsTBRFj
         ff+gIgKdYbBfd8ZjTXyaOP0JcWFjd7Zz/+Fhg4qU43gPW9yFfXeaoDrGtEx6fTgWSRRS
         tIXZz2Vheu9QPsSKDeM5GRl45Z+PZg65s32VRRVE1KkT8gVncWbdL/Le3RUFXD30cfSj
         taA5dwy7UxFHbIubzZecE/08vpybjRxEdVU+MouJhdIRyws874eTUoiZ65Sb8RqiZ6+F
         ixNw==
X-Gm-Message-State: AOAM533dLFb2E4Q8Pk1m4HKn1IZxEX3bhJlQh4ITTcl3YweY/cRxssPp
        EQSeUj4w94jJby1xJTe8RL2e9g==
X-Google-Smtp-Source: ABdhPJwq+trHBeK6LraF4Hr2dn7GkrzScTWLGYQfnYCiWwlL4mgThSJMCeOxCfIwY8A9mwgH157/oQ==
X-Received: by 2002:a17:90a:2ecb:: with SMTP id h11mr14093722pjs.196.1634309119673;
        Fri, 15 Oct 2021 07:45:19 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m10sm11309389pjs.21.2021.10.15.07.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 07:45:18 -0700 (PDT)
Date:   Fri, 15 Oct 2021 14:45:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hao Xiang <hao.xiang@linux.alibaba.com>
Cc:     kvm@vger.kernel.org, shannon.zhao@linux.alibaba.com,
        pbonzini@redhat.com, xiaoyao.li@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: VMX: Remove redundant handling of bus lock vmexit
Message-ID: <YWmT+k9X9+SO0pJv@google.com>
References: <1634299161-30101-1-git-send-email-hao.xiang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1634299161-30101-1-git-send-email-hao.xiang@linux.alibaba.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 15, 2021, Hao Xiang wrote:
> Hardware may or may not set exit_reason.bus_lock_detected on BUS_LOCK
> VM-Exits. Dealing with KVM_RUN_X86_BUS_LOCK in handle_bus_lock_vmexit
> could be redundant when exit_reason.basic is EXIT_REASON_BUS_LOCK.
> 
> We can remove redundant handling of bus lock vmexit. Unconditionally Set
> exit_reason.bus_lock_detected in handle_bus_lock_vmexit(), and deal with
> KVM_RUN_X86_BUS_LOCK only in vmx_handle_exit().
> 
> Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>

Code review feedback generally doesn't warrant a Suggested-by.  The intent of
Suggested-by is to give credit to the idea/approach of a patch, so unless the
review feedback suggests a completely different, noting the input in the delta
(as you did below) is sufficient.  And then that way you don't need to juggle
the Suggested-by vs Co-developed-by for me.

> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

> Signed-off-by: Hao Xiang <hao.xiang@linux.alibaba.com>
> ---
> v1 -> v2: a little modifications of comments
> v2 -> v3: addressed the review comments
> 
>  arch/x86/kvm/vmx/vmx.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 116b089..7fb2a3a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5562,9 +5562,13 @@ static int handle_encls(struct kvm_vcpu *vcpu)
>  
>  static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
>  {
> -	vcpu->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
> -	vcpu->run->flags |= KVM_RUN_X86_BUS_LOCK;
> -	return 0;
> +	/*
> +	 * Hardware may or may not set the BUS_LOCK_DETECTED flag on BUS_LOCK
> +	 * VM-Exits. Unconditionally set the flag here and leave the handling to
> +	 * vmx_handle_exit().

+1 for "Unconditionally" instead of "Force".  Any objection to rewording the
second half slightly?

	/*
	 * Hardware may or may not set the BUS_LOCK_DETECTED flag on BUS_LOCK
	 * VM-Exits. Unconditionally set the flag here and let vmx_handle_exit()
	 * handle all flavors of bus-lock exits.
	 */

Not a big deal in this case, but in the future please give reviewers a chance to
respond and wait for discussion to settle before sending a new version, e.g. I
would happily have replied to Xiaoyao's suggestion in v2.
