Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E63B720A56
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 22:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbjFBUal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 16:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236104AbjFBUaj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 16:30:39 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD506E4A
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 13:30:33 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 46e09a7af769-6af6b5cf489so2252819a34.3
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 13:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685737833; x=1688329833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=10hRcwQ0GUO47GW14pu/UVUtmrspce6JF9a1n+Kc3qE=;
        b=Zz8mOG+01aBDLhMelg/oVY0aJ+ahToA3CsO5FgnuWse/iLJYWAvzRW8Thv3erz8/Qm
         Q8euilE9CNud+9F6VgkY9OI8T9W2gUKvmOWogqHWBfTbe+aokT5yvZcvGnEE3Om0BM8+
         g7MPCtSE5Dg9KezwmDNrexeCYs+YCorqP3h9KgGjjUQNSMH1EKlH6FTkkdXfaztTFuCb
         /chbxyT9iewP5HbgrkGQcogswZqYMjhBw169tZWg/WbH+F18r1M0WZ0yFkp9lfGmnUo2
         vW5jhTWRJodkqlrdYrEaE83bczJj/UZqeXj5WVjY2aW4SvPk9mZsYdkUp0nBdUODl9bG
         Si8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685737833; x=1688329833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=10hRcwQ0GUO47GW14pu/UVUtmrspce6JF9a1n+Kc3qE=;
        b=YNBKV7YLdFaRipwB29VGSU0NgxpnxEleKzjIJojlyXIffqSA73awZjltRHR40gbgmX
         Resf6wn0rIOcW0ikqMysStsFtspNx6c4f9Om303NHAmVvYqli4VHyuJmFS+UZNt7zlro
         2qbqTcNpYMpwDIYFS1wdxp7cEmlas3y3ZDXlZpdN/1L7qa/owkv2W8b7omrWHewd1dqk
         715tle+iNxmwAbAL3ZhTfjm0UOZGy7jA70as5PDuvYgy246vbHfPkUBCXCrC1SJOswV1
         j14g+nx4u2XZPVbe1Bha50l5cK13/j4PvwAU4rRGt9pS+p+ZxKdIXJG+bCy9eXFfmwKY
         R2Gg==
X-Gm-Message-State: AC+VfDw9qtL60ELXvPHPsYL/7ciN2+pkGRwc1MYmbqQDreDQ2AQqSwL+
        QddSIY2e/lk7yP0fDTiUx94=
X-Google-Smtp-Source: ACHHUZ49DbSF/X0jUtqmRxmK9L5eLFTOBftgLIkXQIZHoEIa5ad6d0gDp0cQuMTvw0tf+FqPJTKLAg==
X-Received: by 2002:a05:6830:3a92:b0:6b0:cde0:d9a with SMTP id dj18-20020a0568303a9200b006b0cde00d9amr3709371otb.21.1685737832986;
        Fri, 02 Jun 2023 13:30:32 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id 196-20020a6302cd000000b0053ef188c90bsm1628121pgc.89.2023.06.02.13.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 13:30:32 -0700 (PDT)
Date:   Fri, 2 Jun 2023 13:30:31 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Subject: Re: [PATCH v4 02/16] KVM: x86: Set vCPU exit reason to
 KVM_EXIT_UNKNOWN at the start of KVM_RUN
Message-ID: <20230602203031.GK1234772@ls.amr.corp.intel.com>
References: <20230602161921.208564-1-amoorthy@google.com>
 <20230602161921.208564-3-amoorthy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230602161921.208564-3-amoorthy@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 02, 2023 at 04:19:07PM +0000,
Anish Moorthy <amoorthy@google.com> wrote:

> Give kvm_run.exit_reason a defined initial value on entry into KVM_RUN:
> other architectures (riscv, arm64) already use KVM_EXIT_UNKNOWN for this
> purpose, so copy that convention.
> 
> This gives vCPUs trying to fill the run struct a mechanism to avoid
> overwriting already-populated data, albeit an imperfect one. Being able
> to detect an already-populated KVM run struct will prevent at least some
> bugs in the upcoming implementation of KVM_CAP_MEMORY_FAULT_INFO, which
> will attempt to fill the run struct whenever a vCPU fails a guest memory
> access.
> 
> Without the already-populated check, KVM_CAP_MEMORY_FAULT_INFO could
> change kvm_run in any code paths which
> 
> 1. Populate kvm_run for some exit and prepare to return to userspace
> 2. Access guest memory for some reason (but without returning -EFAULTs
>     to userspace)
> 3. Finish the return to userspace set up in (1), now with the contents
>     of kvm_run changed to contain efault info.
> 

As vmx code uses KVM_EXIT_UNKNOWN with hardware_exit_reason=exit reason,
Can we initialize hardware_exit_reason to -1.
It's just in case.


> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  arch/x86/kvm/x86.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ceb7c5e9cf9e..a7725d41570a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11163,6 +11163,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  	if (r <= 0)
>  		goto out;
>  
> +	kvm_run->exit_reason = KVM_EXIT_UNKNOWN;

+	kvm_run->hardware_exit_reason = -1;     /* unused exit reason value */

>  	r = vcpu_run(vcpu);
>  
>  out:
> -- 
> 2.41.0.rc0.172.g3f132b7071-goog
> 

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
