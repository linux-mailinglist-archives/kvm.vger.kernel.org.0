Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E216A4D10
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 22:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjB0VWJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 16:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjB0VWH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 16:22:07 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B98522DF5;
        Mon, 27 Feb 2023 13:22:03 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id h8so4927402plf.10;
        Mon, 27 Feb 2023 13:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=huKJjrYkqha1WmoI8qO3tyhpUNpfWcMnNwc/JfMVqIo=;
        b=D1K0QXEdbSw+65pP9v8xEx9I6JejZ7uRCpkZhJ2OS74G9WK5Ywu0CcWcE+LsGnWio6
         r/kYebKtdX/kQUR5ERVsxE0FFxZXJXufw7/eSfJmx6OqmgzaSbu5375EJKC4nxfkJCRB
         NaiA0M2Cz7dsn/9Ma2yr+Iy4cWqY5mE0FbTWxtO9YhiDw8uvw9BmcBdb2d2XdlmWIsRG
         dTfHihztEi6aoeOj59M+9dnIpUr6bJCvrlNHorV4A8MlI4JKSIZeiCM+nEnSBCZ3kKNg
         HqLrLPx782zl6bjCexVdXbYJrNrUgHK+A9v3GZeM9v3MQETP5pPcS/r5xVYBm9r0we0m
         vfGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=huKJjrYkqha1WmoI8qO3tyhpUNpfWcMnNwc/JfMVqIo=;
        b=vZ5Cy9OymhP27UedPdF1EtYwsbLMgINZXpSRQEjsLBCOlZyHzX51yiNNwL1MdqhPvg
         8AshWAhE9XpWIfdTeeNQvyhBxSzLZYXVVHwd34IrXgu040Kl9Ia+QQxF+3a/PEdyZINK
         edYEEuWbEE8lNXHiC3ctjTRFBBCjSSpvC7S6y0ud+6B/fvdAJAjXN5KgyLsa3bTI6aSg
         aQT5zC8NP2FtH0ETNcxNGcm5TH980vsLjP3OBwo3/tXfOIRN+g79U0MaK+qh9LlH5cu1
         oXdLX0bGBKXLmhHMbtnGVuKwt6FJTGQoXVI/x0JF8LVwa9YVB+afpIS9TCFMTwUdYg8p
         QpLw==
X-Gm-Message-State: AO0yUKXpe27b1DE8Ae3tS+HUWpKcCoGDUsN3Jmyi53xFPCuw+IJOp0Uq
        rhpxfKTTJ420AGKk/+WQQxw=
X-Google-Smtp-Source: AK7set+tLSxVxzVWVIsF8bpbEA7uwq+BMUM47Ixq/J7ImPqAaC11XsJKb2f2F7EKduOM0gr2td/E8g==
X-Received: by 2002:a17:902:ce8f:b0:196:3088:5dd6 with SMTP id f15-20020a170902ce8f00b0019630885dd6mr504403plg.13.1677532922774;
        Mon, 27 Feb 2023 13:22:02 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id iz17-20020a170902ef9100b001947222676csm4995612plb.249.2023.02.27.13.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 13:22:02 -0800 (PST)
Date:   Mon, 27 Feb 2023 13:22:00 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 016/113] KVM: TDX: Add place holder for TDX VM
 specific mem_enc_op ioctl
Message-ID: <20230227212200.GE4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <e846968f2e1c554b3ecc1a876e0bb691727d34fc.1673539699.git.isaku.yamahata@intel.com>
 <19645255d65fdfd184b92b5192cac83a27c430fb.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <19645255d65fdfd184b92b5192cac83a27c430fb.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 19, 2023 at 02:40:17AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index 16053ec3e0ae..781fbc896120 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -37,6 +37,14 @@ static int vt_vm_init(struct kvm *kvm)
> >  	return vmx_vm_init(kvm);
> >  }
> >  
> > +static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
> > +{
> > +	if (!is_td(kvm))
> > +		return -ENOTTY;
> > +
> > +	return tdx_vm_ioctl(kvm, argp);
> > +}
> > +
> >  struct kvm_x86_ops vt_x86_ops __initdata = {
> >  	.name = KBUILD_MODNAME,
> >  
> > @@ -179,6 +187,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> >  	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
> >  
> >  	.dev_mem_enc_ioctl = tdx_dev_ioctl,
> > +	.mem_enc_ioctl = vt_mem_enc_ioctl,
> >  };
> 
> IIUC, now both AMD and Intel have mem_enc_ioctl() callback implemented, so the
> KVM_X86_OP_OPTIONAL() of it can be changed to KVM_X86_OP(), and the function
> pointer check can be removed in the IOCTL:

Makes sense. Merged the following patch into the patch. Thanks for it.


> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-
> ops.h
> index 8dc345cc6318..a59852fb5e2a 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -116,7 +116,7 @@ KVM_X86_OP(enter_smm)
>  KVM_X86_OP(leave_smm)
>  KVM_X86_OP(enable_smi_window)
>  #endif
> -KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
> +KVM_X86_OP(mem_enc_ioctl)
>  KVM_X86_OP_OPTIONAL(mem_enc_register_region)
>  KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
>  KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c936f8d28a53..dfa279e35478 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6937,10 +6937,6 @@ long kvm_arch_vm_ioctl(struct file *filp,
>                 goto out;
>         }
>         case KVM_MEMORY_ENCRYPT_OP: {
> -               r = -ENOTTY;
> -               if (!kvm_x86_ops.mem_enc_ioctl)
> -                       goto out;
> -
>                 r = static_call(kvm_x86_mem_enc_ioctl)(kvm, argp);
>                 break;
>         }
> 
> [snip]
> 

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
