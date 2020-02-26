Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 714141702D4
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 16:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgBZPkv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 10:40:51 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47437 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728174AbgBZPkv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Feb 2020 10:40:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582731649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lN1iHVBVTfIfB7ji7VzuZjr7mz9R8NosIhfDUiZT0NM=;
        b=KZWw8cKk27TSCy2/cK/4KcVZV8iFad7H17kVv/SEVhMm4Wgd7h2uEj3YZClka8qd6OUJ9b
        aVn3KwLeyvil9h66lKBKmw+opgymDyEND+ThImKPWGobZZ9sAy8OUwYbsqqJWSa3a6FJvf
        pI5/8JFqWHLZnWGp54UUfG6emeQcEVo=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-VgZmQQOYMiOkMgjgbRBidg-1; Wed, 26 Feb 2020 10:40:44 -0500
X-MC-Unique: VgZmQQOYMiOkMgjgbRBidg-1
Received: by mail-qk1-f200.google.com with SMTP id c66so4631751qkb.13
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 07:40:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lN1iHVBVTfIfB7ji7VzuZjr7mz9R8NosIhfDUiZT0NM=;
        b=oIUwBhIIVUg4btvKWtmVC06oAY/DQd+7MEkDmPaBsySXbx40R3+nr0BYuPY3ZD0K6W
         nOFD2qb4n0PqEZ5AaALFHB1fyUdJXw+dvt9tt/J7B8GygXjh6jsAfv/0NcnSvDcSy0u5
         Gl7ls+UvbnyY/jjQvGd6HqeRXVbC9giwtUSJTBZBWNkPvHZjeGLupN0zvQ9tuFJsjP2E
         2KNZYrOPEp8lx+u1WxjQNywfW23WgK0Pehs0Vw2ZfkKkSwUbrMUV7449pXamIuT+3CT6
         CiVd46QWYrylFLQdsrQau2QM8kZq20kT+d4yrocRXiJnwOLBx6goFERAhRDfWFjhZ1+8
         hGAw==
X-Gm-Message-State: APjAAAWN9edSG2jZ0ay9G4qK6Ik6ltBFgXmo92jcpZfpXLMwdUBbSPiC
        Is4D0MSGfmI8z9Zr3OPKrjYWtiQ5dyTakQDkNgJwy4j5qyuvJziUsqWypsP5TffwpfJo+avBTyu
        5zkMChf0E/zRX
X-Received: by 2002:ad4:5304:: with SMTP id y4mr5567626qvr.56.1582731644388;
        Wed, 26 Feb 2020 07:40:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqwk5flmscz923q+3xiHfIvkHr7LD1KvRMcLS6ExXBggTGPVz+iM9Xj3bzYnRcbKQHPao9mdYA==
X-Received: by 2002:ad4:5304:: with SMTP id y4mr5567598qvr.56.1582731644049;
        Wed, 26 Feb 2020 07:40:44 -0800 (PST)
Received: from xz-x1 (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id s19sm1311044qkj.88.2020.02.26.07.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 07:40:43 -0800 (PST)
Date:   Wed, 26 Feb 2020 10:40:41 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Zhoujian (jay)" <jianjay.zhou@huawei.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "wangxin (U)" <wangxinxin.wang@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>
Subject: Re: [PATCH v3] KVM: x86: enable dirty log gradually in small chunks
Message-ID: <20200226154041.GB140200@xz-x1>
References: <20200224032558.2728-1-jianjay.zhou@huawei.com>
 <20200224170538.GH37727@xz-x1>
 <B2D15215269B544CADD246097EACE7474BB1B778@dggemm508-mbx.china.huawei.com>
 <20200225160758.GB127720@xz-x1>
 <20200225190715.GA140200@xz-x1>
 <B2D15215269B544CADD246097EACE7474BB21BF6@dggemm508-mbx.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <B2D15215269B544CADD246097EACE7474BB21BF6@dggemm508-mbx.china.huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 26, 2020 at 04:59:40AM +0000, Zhoujian (jay) wrote:
> 
> 
> > -----Original Message-----
> > From: Peter Xu [mailto:peterx@redhat.com]
> 
> [...]
> 
> > > > > > @@ -3320,6 +3326,10 @@ static long
> > > > > kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
> > > > > >  	case KVM_CAP_COALESCED_PIO:
> > > > > >  		return 1;
> > > > > >  #endif
> > > > > > +#ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> > > > > > +	case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2:
> > > > > > +		return KVM_DIRTY_LOG_MANUAL_CAPS;
> > > > >
> > > > > We probably can only return the new feature bit when with CONFIG_X86?
> 
> Since the meaning of KVM_DIRTY_LOG_MANUAL_CAPS will change accordingly in
> different archs, we can use it in kvm_vm_ioctl_enable_cap_generic, how about:
> 
> @@ -3347,11 +3351,17 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>  {
>         switch (cap->cap) {
>  #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> -       case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2:
> -               if (cap->flags || (cap->args[0] & ~1))
> +       case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2: {
> +               u64 allowed_options = KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE;
> +
> +               if (cap->args[0] & KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE)
> +                       allowed_options = KVM_DIRTY_LOG_MANUAL_CAPS;
> +
> +               if (cap->flags || (cap->args[0] & ~allowed_options))
>                         return -EINVAL;
>                 kvm->manual_dirty_log_protect = cap->args[0];
>                 return 0;
> +       }

Looks good to me.

> 
> [...]
> 
> >> How about:
> > >
> > > ==========
> > >
> > > diff --git a/arch/x86/include/asm/kvm_host.h
> > > b/arch/x86/include/asm/kvm_host.h index 40a0c0fd95ca..fcffaf8a6964
> > > 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1697,4 +1697,7 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
> > >  #define GET_SMSTATE(type, buf, offset)         \
> > >         (*(type *)((buf) + (offset) - 0x7e00))
> > >
> > > +#define KVM_DIRTY_LOG_MANUAL_CAPS
> > (KVM_DIRTY_LOG_MANUAL_PROTECT | \
> > > +
> > KVM_DIRTY_LOG_INITIALLY_SET)
> > > +
> > >  #endif /* _ASM_X86_KVM_HOST_H */
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h index
> > > e89eb67356cb..39d49802ee87 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -1410,4 +1410,8 @@ int kvm_vm_create_worker_thread(struct kvm *kvm,
> > kvm_vm_thread_fn_t thread_fn,
> > >                                 uintptr_t data, const char *name,
> > >                                 struct task_struct **thread_ptr);
> > >
> > > +#ifndef KVM_DIRTY_LOG_MANUAL_CAPS
> > > +#define KVM_DIRTY_LOG_MANUAL_CAPS
> > KVM_DIRTY_LOG_MANUAL_PROTECT
> > > +#endif
> > > +
> > 
> > Hmm... Maybe this won't work, because I saw that asm/kvm_host.h and
> > linux/kvm_host.h has no dependency between each other (which I thought they
> > had).  Right now in most cases linux/ header can be included earlier than the
> > asm/ header in C files.  So intead, maybe we can move these lines into
> > kvm_main.c directly.
> 
> I did some tests on x86, and it works. Looks good to me.
> 
> > 
> > (I'm thinking ideally linux/kvm_host.h should include asm/kvm_host.h  within
> > itself, then C files should not include asm/kvm_host.h  directly. However I dare
> > not try that right now without being able to  test compile on all archs...)
> > 
> But, I see include/linux/kvm_host.h has already included asm/kvm_host.h in the
> upstream. Do I understand your meaning correctly?

Oh you are right, my eyeball missed that... :)

Then we should be able to remove the asm/kvm_host.h in most of the C
files.  I'll prepare a patch for it.

Thanks,

-- 
Peter Xu

