Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB2C177B84
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 17:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730060AbgCCQD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 11:03:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58766 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729484AbgCCQDz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 11:03:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583251435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/tRzL6U8zBIIOVOwiT19rvws3udmiVdmkMlNTXIZwbg=;
        b=gua9GkdF657u7bbrTLVXHOZNkk4e1uQdxYnyue1RNiUlHjGZls6wAs3BD6aQE0dScJjzRp
        rU8LsqYQENb9sb4HXKRZ3KwdZZnJLoTY/OcWkv1javn1YrVyEk4+VhDTCwZRDR++psSsBs
        lW+0Ie78MV3UelKW7sMvkoWlMnyXbs8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-BSQOkcSjOve_0tQBbF_f3A-1; Tue, 03 Mar 2020 11:03:53 -0500
X-MC-Unique: BSQOkcSjOve_0tQBbF_f3A-1
Received: by mail-wr1-f71.google.com with SMTP id w6so1413810wrm.16
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 08:03:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=/tRzL6U8zBIIOVOwiT19rvws3udmiVdmkMlNTXIZwbg=;
        b=sO0YpIHJUkDSmjq8UIzykaTaehr8dl33odcZJkKRLbhmhsE5N1IvRHLFVQeiY+GnF2
         esjSZO6tDfEb6N6JUvqfDzDDumMHWgU2iVp+VLLXmJBLoFtI/vfaAK8cuKj+vUXf+Uoj
         o7BzL5k930sK0B2RmXtxCOEfchtMJ5jAf2AuDwNeKKcGlDTnUAFD0489MfJM0r9nDsaz
         gUE+twk7NsMDFeFiLMLj7KMfSZ9CDZbQBy7ZQYU8IA9++6deel8+WpFbvNMkV9nBqOJl
         zYDzeB+txn0Ccd5YFooyxCT0G4YEFzKZOIkOG8s7OW1T4hwIqK4jF0U/IguO2gh3v+vb
         kBpA==
X-Gm-Message-State: ANhLgQ1eb50jRfvp2QAdPQwoP/LN3xZbqsU5JQ7LwLyQ5S8I+ShRA1HQ
        SR4CPtd1KYQsNybRMKdEfVpJTLyzeEJ/t8L0H6gXUHoDdLJ95DLUp1/YsPK7xBhug6LYxe8buO2
        dvOWPq/uJ827B
X-Received: by 2002:a1c:1f56:: with SMTP id f83mr4925970wmf.101.1583251432282;
        Tue, 03 Mar 2020 08:03:52 -0800 (PST)
X-Google-Smtp-Source: ADFU+vv9qk3kYMC9VwTgKWNbztNGZDgmdaZ4MofqEtQmju3UA91sffxYiA5AEMHy7QlEh1Q22+5+Mw==
X-Received: by 2002:a1c:1f56:: with SMTP id f83mr4925947wmf.101.1583251432026;
        Tue, 03 Mar 2020 08:03:52 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 25sm98565wmg.30.2020.03.03.08.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 08:03:51 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v2 53/66] KVM: x86: Do kvm_cpuid_array capacity checks in terminal functions
In-Reply-To: <20200302235709.27467-54-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com> <20200302235709.27467-54-sean.j.christopherson@intel.com>
Date:   Tue, 03 Mar 2020 17:03:50 +0100
Message-ID: <87d09tfms9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Perform the capacity checks on the userspace provided kvm_cpuid_array
> in the lower __do_cpuid_func() and __do_cpuid_func_emulated().
> Pre-checking the array in do_cpuid_func() no longer adds value now that
> __do_cpuid_func() has been trimmed down to size, i.e. doesn't invoke a
> big pile of retpolined functions before doing anything useful.
>
> Note, __do_cpuid_func() already checks the array capacity via
> do_host_cpuid(), "moving" the check to __do_cpuid_func() simply means
> removing a WARN_ON().
>
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index eebd7f613f67..f879fcbd6fb2 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -478,8 +478,12 @@ static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
>  
>  static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
>  {
> -	struct kvm_cpuid_entry2 *entry = &array->entries[array->nent];
> +	struct kvm_cpuid_entry2 *entry;
>  
> +	if (array->nent >= array->maxnent)
> +		return -E2BIG;
> +
> +	entry = &array->entries[array->nent];
>  	entry->function = func;
>  	entry->index = 0;
>  	entry->flags = 0;
> @@ -516,7 +520,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  	r = -E2BIG;
>  
>  	entry = do_host_cpuid(array, function, 0);
> -	if (WARN_ON(!entry))
> +	if (!entry)
>  		goto out;
>  
>  	switch (function) {
> @@ -787,9 +791,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  static int do_cpuid_func(struct kvm_cpuid_array *array, u32 func,
>  			 unsigned int type)
>  {
> -	if (array->nent >= array->maxnent)
> -		return -E2BIG;
> -
>  	if (type == KVM_GET_EMULATED_CPUID)
>  		return __do_cpuid_func_emulated(array, func);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

