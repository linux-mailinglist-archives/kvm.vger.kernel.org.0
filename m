Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B834DDF75
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 17:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239442AbiCRQ6O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 12:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239435AbiCRQ5r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 12:57:47 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2415B2BEC41
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 09:56:29 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id s72so2727671pgc.5
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 09:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gePMaavqVc7aMCJv7Sy8LS7HNWGHWMrg3RoSxAFxOEI=;
        b=MJtPdhEU5oQSJNmjHjctPiIbHqVwsfsqjkJU2yfbPhCq/C0Ks8sPolTG4KkMfeBU0f
         vBbreTBvO980Ue4IYAcAZCUeTuFzCjKyg0SXI3VPxLUmvvlcJb8KNTzJ2sI+oHpXGwVD
         OFIdQ3f3PkbDd5r3yTorUqRC00oAUIXC+SYPcxCCAIsdCscTkS6N9SHrdDpXlFGP52gG
         IsJmxxg7sr0J8W45/t3g9yD0AhRZBsCeln7ZG10oHnWAE3pWneFrKRdp3VrlkKSRpkRK
         SFpjzMr1J2jWFKw0vhkqBD413ENpkMKF+RZF13SJnju0Z6J2XxG+Qs+I4FRymb0nJs/u
         QQSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gePMaavqVc7aMCJv7Sy8LS7HNWGHWMrg3RoSxAFxOEI=;
        b=3gGvf9Hj8kk5RPrKDP9JAX0WW74ghZYlriIO4ahD7Hefe+6wXWM8JEJaTMyvl0qFIy
         OQPdv4q35xTfNDIhVuNrD5NxZNjXZk3J/Py+OKOHbIMP/rGs3b+w5oLL6E0tDxNHQS6M
         0EhOr9kIvNr1/GWYUBA/hNBKvm3Yr8guXgtPDv/o6KjAP4CueYT/3L3xAeBYtC1OpF9l
         vJb1whXfISxG8PWFOeZckIGChTeetQJj4kOLNohXQ9l4AmlZRpvxoiY5fh15wogwcu+p
         udNelujHuMdjQ3dUFL93kPj6n2H/EKt0nYordbKEv3thyF6SEM5AitfXirEzJ7UKUUtG
         HXKw==
X-Gm-Message-State: AOAM532MiQIeNY8tQzLmKyHFWfVOav4XhXhA+SmSZg5L4dIDVsKigRMA
        EY/jG/OKPqsMOwlVppUBTLY=
X-Google-Smtp-Source: ABdhPJwCKkd4oD8/ksvahj/nXz3LgsZx8/RgQTnPC96APZYRn5sF/E2JpQmfdX33//ri1uz7JxHf7g==
X-Received: by 2002:a63:41c5:0:b0:378:3b1e:7ac7 with SMTP id o188-20020a6341c5000000b003783b1e7ac7mr8470547pga.266.1647622588613;
        Fri, 18 Mar 2022 09:56:28 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id h22-20020a056a001a5600b004f7c17b291asm10167674pfv.87.2022.03.18.09.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:56:28 -0700 (PDT)
Date:   Fri, 18 Mar 2022 09:56:27 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Philippe Mathieu-Daud??? <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Daniel P. Berrang???" <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, Connor Kuehl <ckuehl@redhat.com>,
        seanjc@google.com, qemu-devel@nongnu.org, erdemaktas@google.com,
        isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH v3 09/36] KVM: Introduce kvm_arch_pre_create_vcpu()
Message-ID: <20220318165627.GB4049379@ls.amr.corp.intel.com>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-10-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317135913.2166202-10-xiaoyao.li@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 17, 2022 at 09:58:46PM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> Introduce kvm_arch_pre_create_vcpu(), to perform arch-dependent
> work prior to create any vcpu. This is for i386 TDX because it needs
> call TDX_INIT_VM before creating any vcpu.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  accel/kvm/kvm-all.c    | 7 +++++++
>  include/sysemu/kvm.h   | 1 +
>  target/arm/kvm64.c     | 5 +++++
>  target/i386/kvm/kvm.c  | 5 +++++
>  target/mips/kvm.c      | 5 +++++
>  target/ppc/kvm.c       | 5 +++++
>  target/s390x/kvm/kvm.c | 5 +++++
>  7 files changed, 33 insertions(+)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 27864dfaeaaa..a4bb449737a6 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -465,6 +465,13 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
>  
>      trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
>  
> +    ret = kvm_arch_pre_create_vcpu(cpu);
> +    if (ret < 0) {
> +        error_setg_errno(errp, -ret,
> +                         "kvm_init_vcpu: kvm_arch_pre_create_vcpu() failed");
> +        goto err;
> +    }
> +
>      ret = kvm_get_vcpu(s, kvm_arch_vcpu_id(cpu));
>      if (ret < 0) {
>          error_setg_errno(errp, -ret, "kvm_init_vcpu: kvm_get_vcpu failed (%lu)",
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index a783c7886811..0e94031ab7c7 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -373,6 +373,7 @@ int kvm_arch_put_registers(CPUState *cpu, int level);
>  
>  int kvm_arch_init(MachineState *ms, KVMState *s);
>  
> +int kvm_arch_pre_create_vcpu(CPUState *cpu);
>  int kvm_arch_init_vcpu(CPUState *cpu);
>  int kvm_arch_destroy_vcpu(CPUState *cpu);
>  
> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> index ccadfbbe72be..ae7336851c62 100644
> --- a/target/arm/kvm64.c
> +++ b/target/arm/kvm64.c
> @@ -935,6 +935,11 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      return kvm_arm_init_cpreg_list(cpu);
>  }
>  
> +int kvm_arch_pre_create_vcpu(CPUState *cpu)
> +{
> +    return 0;
> +}
> +

Weak symbol can be used to avoid update all the arch.

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
