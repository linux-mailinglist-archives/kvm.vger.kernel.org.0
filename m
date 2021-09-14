Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0075A40B7B1
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 21:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbhINTN6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 15:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbhINTNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 15:13:51 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA625C0613D8
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 12:12:25 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id r2so129227pgl.10
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 12:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JavJkkOpz22nHzp7w49aNBW1DkmZK4vezafTuT+JB/Q=;
        b=tXfF+z4Yp+j8wWRQ41nGFR/bXPMSsEbE/fDdg9Ns4z8fATNJ/9CmhIyx7vMmciv2sS
         URPJp/bYnqqm6wnuQVv5PLqBxYPDevjCgEdRXIf6irJlaBZJW2Sllz792nFeQAKz1iEO
         VAilgKi1UEnb0ptCIEVmobEbo9Ir7l59XB6VfJGEj9KErgoP/CFurKO0p1Ykov6cUvQH
         Bg03uL9DzFdnrrq4VXEoFjjm5830Rj0EvGlmkBPxfhBhxKN12Y3ucm9GC8gxLivYI/RB
         kVdGHmmfZtqLW/XJZLKcxABywnOXIoK8nmx62ep4A0IpVC+JyhKvIvs4MuvvjUJp0HID
         x7lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JavJkkOpz22nHzp7w49aNBW1DkmZK4vezafTuT+JB/Q=;
        b=kX6m+D6xcaTp4f3pSth+64QCp7LgFY4Luv6I+0PZyz2Dlzu9xvSsKBiUU0vu7CiRmr
         8OxmVz2QvKt+0W1pOLuMZSWLMyk+Ur37UUqeYYRmhPNGHNK0e7xBEKCPuwnOtrdgIPa4
         9eDx1x+4YZBO17I0X1ESa7/XfrPPLYjxJF7PJjYazJXpocSSj2uCVD4X92nuDZ7A1Su2
         dTQstXc2SCX4QKo+bDPeqy/Bo28uCWQ/QyjelxEdgaphtaNryQwRS/+3v8uoI/9lo4uH
         UGCetylKXwwbc2DSOrgtZSVPg7+NDqkawlzOAAsHjYzBYtpBFeSpZS6D6tHSCJTngm20
         vSHw==
X-Gm-Message-State: AOAM532GkoX1Fx8ElT9LpkxkKYK57g32FPMBeDBWHY2zEsVTEH1LwFSg
        46Fvamrr6/7K8lszLElm95R/mw==
X-Google-Smtp-Source: ABdhPJyHgXtFJpbpPr/S9sU8/wZ71wAYHggypbi7CIkwpk2dzuEbyfuFjIVCzgGueErMBWwFt58rHg==
X-Received: by 2002:a63:1247:: with SMTP id 7mr16718436pgs.366.1631646744947;
        Tue, 14 Sep 2021 12:12:24 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p27sm6765934pfq.164.2021.09.14.12.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 12:12:24 -0700 (PDT)
Date:   Tue, 14 Sep 2021 19:12:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Tempelman <natet@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] KVM: SEV: Disable KVM_CAP_VM_COPY_ENC_CONTEXT_FROM
 for SEV-ES
Message-ID: <YUD0FIVTyW8c79b6@google.com>
References: <20210914190125.3289256-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210914190125.3289256-1-pgonda@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 14, 2021, Peter Gonda wrote:
> Copying an ASID into new vCPUs will not work for SEV-ES since the vCPUs
> VMSAs need to be setup and measured before SEV_LAUNCH_FINISH. Return an
> error if a users tries to KVM_CAP_VM_COPY_ENC_CONTEXT_FROM from an
> SEV-ES guest. The destination VM is already checked for SEV and SEV-ES
> with sev_guest(), so this ioctl already fails if the destination is SEV
> enabled.
> 
> Enabling mirroring a VM or copying its encryption context with an SEV-ES
> VM is more involved and should happen in its own feature patch if that's
> needed. This is because the vCPUs of SEV-ES VMs need to be updated with
> LAUNCH_UPDATE_VMSA before LAUNCH_FINISH. This needs KVM changes because
> the mirror VM has all its SEV ioctls blocked and the original VM doesn't
> know about the mirrors vCPUs.

mirror's, or I guess mirrors'? :-)

> Fixes: 54526d1fd593 ("KVM: x86: Support KVM VMs sharing SEV context")
> 
> V2:
>  * Updated changelog with more information and added stable CC.

Nit, but this in the section ignored by git (below the ---) so that omitted from
the committed changelog.

> Signed-off-by: Peter Gonda <pgonda@google.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Nathan Tempelman <natet@google.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: kvm@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Reviewed-by: Sean Christopherson <seanjc@google.com>

> ---

Git ignores stuff in this section.

>  arch/x86/kvm/svm/sev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 75e0b21ad07c..8a279027425f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1728,7 +1728,7 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>  	source_kvm = source_kvm_file->private_data;
>  	mutex_lock(&source_kvm->lock);
>  
> -	if (!sev_guest(source_kvm)) {
> +	if (!sev_guest(source_kvm) || sev_es_guest(source_kvm)) {
>  		ret = -EINVAL;
>  		goto e_source_unlock;
>  	}
> -- 
> 2.33.0.309.g3052b89438-goog
> 
