Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1217E375C0D
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 21:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbhEFTzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 15:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbhEFTzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 15:55:06 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F06C061763
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 12:54:06 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id md17so3915554pjb.0
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 12:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5X2Rzdz2NH6PFACa6nLoC7A42J+KFjvAw56dSs0lpaE=;
        b=PAO26QlDYl2Eaz6UQDTfk1m4vmaRxaiLU57OIW7bF8FSGWOGuhiGemSq4gkBExTYy+
         QaVu0kNjNpaKFJ06WitlGYDa7YsBWqORokNmXqrOUM0TIfq68tCHT5JW+TK4wPq6ERvl
         wn9oQIEH+IBUhUkzNChsdmZj3JIvYw+Qs2ujeozWgkWeqweoQgAFXPtwVQ/GmITR/g9e
         Ze4hZ4gbPIoZbJMBrA3i4qsRD32yxuFhMkDFlgyqLgaHziTClwLuNF+V/F0JybFZE/ty
         q8CjaCT2rZbcKd4BSFgt7uYaAyKMlopKGXg/7Lcnl1bVbvGiKzL/HiFQMkZSEbswLOJz
         nKzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5X2Rzdz2NH6PFACa6nLoC7A42J+KFjvAw56dSs0lpaE=;
        b=PtHY1ub9nuMjxMWhHqfPAG87Jie3Gu/LuM58/q0JrYo1sreMX9DnkvoUGOL5Tj6eox
         PgOgjt3q70/RKYi3UFqpy2/uGMqTNBeKmCSgiCtE/SWvxIPBJGx+UvgjXQQLGL2Y1VLz
         LhHI1E3aBK5FWjy9F/KVu9AMGcIpzgLcg3c0PvXcere10Hl74JsvPlTMEJyuS9RbJvxo
         2dsWjwSNb1FOukyCH5RSjdUyR0XRaqFAk2dzdhtcwbfKAebHrc00YWLtJMrBh+1eMNCw
         VgY5kNx8Fy65pP/fpEbA96rdLVFbnd1fnkqsnKrt0UAhCcy0OVNJr76ahD1gzlmcYxlc
         40Gg==
X-Gm-Message-State: AOAM533u/fMdzUeqOJ+hy6HxNeWz/oWJUR/+YG8axN8JaLdtFKz5Pv9S
        x2fy2d81kqYs1NTV+xH8iLdGYQ==
X-Google-Smtp-Source: ABdhPJzyr6JltbHsiyBI0ltWUPDEmo62OOltEQVDT13tc2OnqVP+6J7HEcLf7Hrl96Jo3uXVIE7FHQ==
X-Received: by 2002:a17:90a:d24a:: with SMTP id o10mr19185659pjw.138.1620330845560;
        Thu, 06 May 2021 12:54:05 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id cp19sm2530785pjb.27.2021.05.06.12.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 12:54:04 -0700 (PDT)
Date:   Thu, 6 May 2021 19:54:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [patch 1/2] KVM: x86: add start_assignment hook to kvm_x86_ops
Message-ID: <YJRJWfM0yB+n+Ido@google.com>
References: <20210506185732.609010123@redhat.com>
 <20210506190419.451446263@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506190419.451446263@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 06, 2021, Marcelo Tosatti wrote:
> Index: kvm/arch/x86/kvm/x86.c
> ===================================================================
> --- kvm.orig/arch/x86/kvm/x86.c
> +++ kvm/arch/x86/kvm/x86.c
> @@ -11295,7 +11295,11 @@ bool kvm_arch_can_dequeue_async_page_pre
>  
>  void kvm_arch_start_assignment(struct kvm *kvm)
>  {
> -	atomic_inc(&kvm->arch.assigned_device_count);
> +	int ret;
> +
> +	ret = atomic_inc_return(&kvm->arch.assigned_device_count);
> +	if (kvm_x86_ops.start_assignment)
> +		kvm_x86_ops.start_assignment(kvm, ret);

This can be a static_call(), just needs an entry in kvm-x86-ops.h.

>  }
>  EXPORT_SYMBOL_GPL(kvm_arch_start_assignment);
>  
> 
> 
