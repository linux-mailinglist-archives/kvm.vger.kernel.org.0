Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C875FD67D
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 10:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiJMI4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 04:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiJMIz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 04:55:59 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC40F88CB;
        Thu, 13 Oct 2022 01:55:57 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id 10so1280176pli.0;
        Thu, 13 Oct 2022 01:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VSEyTUffz4Qb3bpIvONtLStYVlQKu1503GyQBO6++fU=;
        b=cMreJXESw6TihUxvWfRaAv2sY9e/44Ierdxl0FVkp/5ZrFvjaNNZFopfJUZHQJggyv
         17Pk8lCy73It5xemwUsin/Q9RWnXahHh5oa93a1484pY75gDO+EI7FZJMLtM5Ly27GUq
         1AOmlkS490R29OpE0NFnADGMinc/4OlptqWRHavSeGqbvCGsCALZ+aeLNxAMSv7k25P/
         +hVrsG+/AZ3ViIe71fcBjWZnocC5TLwnrNr9VNGOVtO9SQPN5xoEiKPSwWs1DGGXyovj
         U7cACzeSBIbcm4HdTG6FRHV7oHiqg2dSUawbZW2ZhEzO5O0UW3csChUKnKdiK3/VyEtc
         zOoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VSEyTUffz4Qb3bpIvONtLStYVlQKu1503GyQBO6++fU=;
        b=dGkl2ETK7u9wd4WrCDByUsUND5RN61dEaRusWnoQUnkytsghR6C96HPMi3zYxjGpa5
         oxAhrqKjfiO0zlEhio4PKjRprA65af+vtF8xL5WNin1+qZh7+YHiqA/9EG26jTQzQbU/
         F1xO1djkAY+pbhHC7+cKR3Tm2Z7LFt1ZFNF6FrIpKkG7h6+AWS4Fg4MNn2uNarRjdAmx
         Hxi/cjF1nXbBWsP21iZ2uTmOSWVQwhmYQtQK0hN/Ja5EMLGpQI2jNKrf5m9qNHlI5NKs
         g0nrHRx0I4nq3UwdCzPrBGAUYEIxwLAV7UumStDbWgFEFyHQ8fqxYxK+dnwmZD+ZfAHF
         mjaA==
X-Gm-Message-State: ACrzQf1gmNOcedbA4ipIFHl36+4Ys8yGDD5yXD7HB4psFG3UWGgjnqMT
        kmP/Lqxnt6nIttf5GtcPTBtrWeY8eWU=
X-Google-Smtp-Source: AMsMyM7xPQRdgIYQRWUKf2Gywb8hcjOcFiGYKHc5I34W8dk4HO4ZJUCdMDNSCmEzGnjcpsEM0VeXDw==
X-Received: by 2002:a17:902:c405:b0:181:2355:68ea with SMTP id k5-20020a170902c40500b00181235568eamr26185246plk.70.1665651357050;
        Thu, 13 Oct 2022 01:55:57 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id f23-20020aa79697000000b00562664d5027sm1412552pfk.61.2022.10.13.01.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 01:55:56 -0700 (PDT)
Date:   Thu, 13 Oct 2022 01:55:54 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sagi Shahar <sagis@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v9 016/105] KVM: TDX: create/destroy VM structure
Message-ID: <20221013085554.GA2756200@ls.amr.corp.intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
 <07bf749357bbf1acd20b09d7ab1fac940082632c.1664530907.git.isaku.yamahata@intel.com>
 <CAAhR5DFrwP+5K8MOxz5YK7jYShhaK4A+2h1Pi31U_9+Z+cz-0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAhR5DFrwP+5K8MOxz5YK7jYShhaK4A+2h1Pi31U_9+Z+cz-0A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 12, 2022 at 03:30:26PM -0700,
Sagi Shahar <sagis@google.com> wrote:


> > +int tdx_vm_init(struct kvm *kvm)
> > +{
> > +       struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +       cpumask_var_t packages;
> > +       int ret, i;
> > +       u64 err;
> > +
> > +       /* vCPUs can't be created until after KVM_TDX_INIT_VM. */
> > +       kvm->max_vcpus = 0;
> 
> The fact that vCPUs can't be created until KVM_TDX_INIT_VM is called
> will make it difficult to implement intra host migration. See longer
> discussion below.
...
> Me, Sean and Isaku had a short discussion offline regarding the
> interaction between the proposed API in this patch and intra-host
> migration. To summarize:
> 
> For intra-host migration you generally want the destination VM to be
> initialized including the right number of vCPUs before you migrate the
> source VM state into it.
> The proposed API makes it difficult since it forces the destination VM
> to call KVM_TDX_INIT_VM before creating vCPUs which initializes TDX
> state and allocate a new hkid for the destination VM which would never
> be used. This can create a resource limitation on migrating VMs where
> there shouldn't be one.
> 
> To solve this issue there are 2 main proposed changes to the API:
> 
> 1. Add a new API based on ioctl(KVM_ENABLE_CAP) to let userspace
> modify the max number of vcpus:
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 43a6a7efc6ec..6055098b025b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6278,6 +6278,18 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>                 }
>                 mutex_unlock(&kvm->lock);
>                 break;
> +       case KVM_CAP_MAX_VCPUS:
> +               r = -EINVAL;
> +               if (cap->args[0] > KVM_MAX_VCPUS)
> +                       break;
> +
> +               mutex_lock(&kvm->lock);
> +               if (!kvm->created_vcpus) {
> +                       kvm->max_vcpus = cap->args[0];
> +                       r = 0;
> +               }
> +               mutex_unlock(&kvm->lock);
> +               break;
>         case KVM_CAP_MAX_VCPU_ID:
>                 r = -EINVAL;
>                 if (cap->args[0] > KVM_MAX_VCPU_IDS)
> 
> 2. Modify the existing API such that max_vcpus will be set to
> KVM_MAX_VCPUS like in regular VMs and during KVM_TDX_INIT_VM, if the
> user created more vCPUs than the number specified, KVM_TDX_INIT_VM
> will fail.
> 
> For option (1), there are some possible variations:
> 1.a. Do we keep the max_vcpus argument in KVM_TDX_INIT_VM? If so, we
> need to check if max_vcpus matches the number of max_vcpus already set
> and fail otherwise.
> 1.b. Do we require KVM_ENABLE_CAP_VM(KVM_CAP_MAX_VCPUS) to be called?
> Theoretically, we can set max_vcpus to the KVM default KVM_MAX_VCPUS
> and allow the user to change it as long as vcpus hasn't been created.
> If KVM_ENABLE_CAP_VM(KVM_CAP_MAX_VCPUS), the behavior will remain the
> same as regular VMs right now.
> 
> In my opinion, the cleanest solution would be option 1 (new
> KVM_CAP_MAX_VCPUS API) while removing the max_vcpus argument from
> KVM_TDX_INIT_VM and setting the initial max_vcpus to KVM_MAX_VCPUS and
> not requiring the new ioctl to be called unless userspace wants to
> specifically limit the number of vcpus. In that case,
> KVM_CAP_MAX_VCPUS can be called at any time until vcpus are created.

Regarding to KVM_CAP_MAX_CPUS vs KVM_TDX_INIT_VM, KVM_CAP_MAX_CPUS is more
generic, KVM_CAP_MAX_CPUS  would be better.  This follows tsc frequency.

If option (1) is adapted, the logic should go to the common code, i.e. under
linux/virt/kvm/, because there is nothing specific to x86.  I don't see any use
case other than TDX, though.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
