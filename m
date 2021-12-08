Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF2846D0E8
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 11:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbhLHKZj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 05:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbhLHKZj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 05:25:39 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CD1C061746;
        Wed,  8 Dec 2021 02:22:07 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id r5so1676642pgi.6;
        Wed, 08 Dec 2021 02:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=AkjuFGC1Zb3ZOgF3UawiFRpJnUR5P1/09K86HNxgPXQ=;
        b=IcxLoF23jnafoZvKbYIyquvGvSfYa50hKbme4qYN8/xrdPnKlUau17kH+PqpfVIn+Y
         07YEe10iu+EfNuN2HcnIEGwnx/ptWJfaPKpn/gpE227GIb4YzcSln9lB0Y1uxa0bRaiw
         IFQdeP5UeHI8oRueGWfGOo9TDxaMa5UlSaAySVw83LrpUEgkYIXS2RHnFqREMLWEGB9t
         y+C0BjmRaWwOA9nNGbPJP6WVFBrR1wK8J6DG3+sCwHdq+MRHYEv1PWCZepKShGVHw7J3
         iAuhOPnGmLIz/kKI3cgsRCWBXrrdaGSGVSWoIXUoVBW/Y96y1cmswSci1Rnc0cv0OXRg
         J9kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=AkjuFGC1Zb3ZOgF3UawiFRpJnUR5P1/09K86HNxgPXQ=;
        b=drJGGDJOp7xoqd4VxAwBfhF2/sNc8HCDpcYXKLxwYEPPeQxUUPbgykFVMLonUbSszK
         wpoygmh+vdO+r1VTZr8b0dWylheEDceN6MzlrRnYAkI0dMhz4lu+VbHZ9C5P09k4WY0Z
         iH6xdxW5Nytz3SmctdgKi1E0yt+a8biCv+Oo/41RtEfaMcEw0xLDCABrt7jCDbIGoICL
         wNFUUS6ZhIb2ExkpzvBzylycz9/1cwuK//HM9JMML+yATrckwWILlF+ndh7yz8+o47Fd
         nnPHk0JSc0ugurAcyTB/5NNm1VdIF4uftrOgnVE0DnwG34i6q5uJDo8GtWDDNwJlLvYq
         nwpw==
X-Gm-Message-State: AOAM531oVzSQ8avzXsBTmyjDIGQBAtqT7a/SuXhNecbxRp1iuB6yjlNl
        7n9Og7eGj3xikxIbp4fiGjA=
X-Google-Smtp-Source: ABdhPJyaA/HV60/fcOOjKzH3yzDJn7blxMkSBdAx/KECm1wZZOZX6VpSDM+bjDb5p+XAnrwvA03nvQ==
X-Received: by 2002:a63:e954:: with SMTP id q20mr27796390pgj.375.1638958927021;
        Wed, 08 Dec 2021 02:22:07 -0800 (PST)
Received: from localhost.localdomain ([43.128.78.144])
        by smtp.gmail.com with ESMTPSA id v3sm2099204pga.78.2021.12.08.02.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 02:22:06 -0800 (PST)
Date:   Wed, 8 Dec 2021 18:21:58 +0800
From:   Aili Yao <yaoaili126@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yaoaili@kingsoft.com
Subject: Re: [PATCH v2] KVM: LAPIC: Per vCPU control over
 kvm_can_post_timer_interrupt
Message-ID: <20211208182158.571fcdee@gmail.com>
In-Reply-To: <Ya/s17QDlGZi9COR@google.com>
References: <20211124125409.6eec3938@gmail.com>
        <Ya/s17QDlGZi9COR@google.com>
Organization: ksyun
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 Dec 2021 23:23:03 +0000
Sean Christopherson <seanjc@google.com> wrote:

> 
>  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
>  {
> -       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> +       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> +              (kvm_mwait_in_guest(vcpu) || kvm_hlt_in_guest(vcpu));
>  }
> 
>  bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
>  {
> -       return kvm_x86_ops.set_hv_timer
> -              && !(kvm_mwait_in_guest(vcpu->kvm) ||
> -                   kvm_can_post_timer_interrupt(vcpu));
> +       /*
> +        * Don't use the hypervisor timer, a.k.a. VMX Preemption Timer, if the
> +        * guest can execute MWAIT without exiting as the timer will stop
> +        * counting if the core enters C3 or lower.  HLT in the guest is ok as
> +        * HLT is effectively C1 and the timer counts in C0, C1, and C2.
> +        *
> +        * Don't use the hypervisor timer if KVM can post a timer interrupt to
> +        * the guest since posted the timer avoids taking an extra a VM-Exit
> +        * when the timer expires.
> +        */
> +       return kvm_x86_ops.set_hv_timer &&
> +              !kvm_mwait_in_guest(vcpu->kvm) &&
> +              !kvm_can_post_timer_interrupt(vcpu));
>  }
>  EXPORT_SYMBOL_GPL(kvm_can_use_hv_timer);
> 

Sorry, I am little confused here now:
if kvm_can_post_timer_interrupt(vcpu) return true(cpu-pm enabled), then the kvm_can_use_hv_timer will always be false;
if kvm_can_post_timer_interrupt(vcpu) return false(cpu-pm disable),then kvm_mwait_in_guest(vcpu->kvm) can't be true ether;
It seems we don't need kvm_mwait_in_guest(vcpu->kvm) here?

Sorry, I am just a little confused and not too sure about this, if anything wrong, just ignore it.

Thanks!
