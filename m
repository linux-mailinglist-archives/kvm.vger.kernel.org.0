Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2447014A058
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 09:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbgA0I6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 03:58:11 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50550 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729331AbgA0I6L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Jan 2020 03:58:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580115490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uyk72xarWIQ4qzz+XnzCWWPRYXQDBN3Q30Mw1xKhGyI=;
        b=Gh+1zvdl4ZS21QmLJsEb5l99yBGvArauPxQVqWk/cUGo6EtCk27oP5MU06GBhGnghRTAeL
        Rb+B5k5SWXjVX/c7aY67m8h6EqqZLoJKW7rFtYX+chgP3s+/fLZNw9yepP8RT7fDPa9x9t
        WfcZkmepeKOQ64Uu+/rQqtREGrXr670=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-Z4o-_i3tMFOPnKTPat1Pag-1; Mon, 27 Jan 2020 03:58:09 -0500
X-MC-Unique: Z4o-_i3tMFOPnKTPat1Pag-1
Received: by mail-wr1-f70.google.com with SMTP id c6so5718860wrm.18
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2020 00:58:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=uyk72xarWIQ4qzz+XnzCWWPRYXQDBN3Q30Mw1xKhGyI=;
        b=IkdZWeHTsWQlOD6KnVFhKIhIZ9r4bjQK2iNV9D6QgscmjGS2ezGOBIVd4wgAfdEwO6
         2bGGx6UVx6gnK/zs7l04GJJogXJ+Zwa8Hv5+wfWy4Fb1Kw6AOl/domA3IN/Y9pl7llos
         hDrL4/X6K8ACFFSY/6UUhkhmmhLyVerv8Ww7hZTE7EDQYQsMNR7l0Nt1j249mzngDuL3
         fqsCjL5N3UNC0qHZb09UAw+TOIwO+XwABK4/DuPASsR96bquG3yC28/CErJMpfIhpBqh
         pFmj2iq1BQ1ehVV2cZGHyYRvYs58X7O3VBfJnse1m5M8JNQf10zV5lCf80/h54rm0J2s
         b6+A==
X-Gm-Message-State: APjAAAVmxkhymQ3OAmpStLDyqsTZSmwt8e4/nw98P6WIebnkInyGhGAY
        I6FuZXZU3/YSupVFgcwC+xGc1K4LycKgG/8YB0DzDH/3V0wyct5Wpb3pDYSNepVb47fGR163qKG
        /TTuPMyB6/hXb
X-Received: by 2002:a1c:a1c1:: with SMTP id k184mr4893802wme.129.1580115487927;
        Mon, 27 Jan 2020 00:58:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqyt3OinQkUFAunpsKkT8TapyHOFDsD/NNKXyGWTg+FyCZ9rvS5eldqDIqHjZvmiWmLD4IcS9A==
X-Received: by 2002:a1c:a1c1:: with SMTP id k184mr4893785wme.129.1580115487728;
        Mon, 27 Jan 2020 00:58:07 -0800 (PST)
Received: from vitty.brq.redhat.com ([195.39.4.224])
        by smtp.gmail.com with ESMTPSA id b21sm18855343wmd.37.2020.01.27.00.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 00:58:07 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86: Unexport x86_fpu_cache and make it static
In-Reply-To: <20200127001330.27741-1-sean.j.christopherson@intel.com>
References: <20200127001330.27741-1-sean.j.christopherson@intel.com>
Date:   Mon, 27 Jan 2020 09:58:09 +0100
Message-ID: <87y2ttmg2m.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Make x86_fpu_cache static now that FPU allocation and destruction is
> handled entirely by common x86 code.
>

git grep on kvm/next agrees :-)

> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

> ---
>
> Pretty sure I meant to include this in the vCPU creation cleanup, but
> completely forgot about it.
>
>  arch/x86/include/asm/kvm_host.h | 1 -
>  arch/x86/kvm/x86.c              | 3 +--
>  2 files changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 77d206a93658..f300a250ab51 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1266,7 +1266,6 @@ struct kvm_arch_async_pf {
>  };
>  
>  extern struct kvm_x86_ops *kvm_x86_ops;
> -extern struct kmem_cache *x86_fpu_cache;
>  
>  #define __KVM_HAVE_ARCH_VM_ALLOC
>  static inline struct kvm *kvm_arch_alloc_vm(void)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7e3f1d937224..78b7e1f08845 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -227,8 +227,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>  
>  u64 __read_mostly host_xcr0;
>  
> -struct kmem_cache *x86_fpu_cache;
> -EXPORT_SYMBOL_GPL(x86_fpu_cache);
> +static struct kmem_cache *x86_fpu_cache;
>  
>  static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt);

-- 
Vitaly

