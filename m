Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6004D1F4D
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 18:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348683AbiCHRoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 12:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbiCHRoS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 12:44:18 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49263152A
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 09:43:21 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id p2so4218077ile.2
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 09:43:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=022kZssKRxaMpugjGKU5wCX5ZoP2APDtJSWAVWLNIMQ=;
        b=dA59ED+AFM+Fe2V8ZR21p+XklxvwaaUtpN1Ip52xrgzm4IEG+PdcjrBowbK5kKeixO
         c5n7Oy0iLUzwSDyixgpat0HfsjPRCaT3v2KLKZagI76RrlLHzMWPUkixdhpEJ8nLswwf
         2HcWB8SpNjZtMKXI296hWcEDZ4tUNHsrMOzsj4++AcudxjE587agyL0wzKbhKteJHQX1
         UvSKc3cRgYJo5IO0ztlbd1Z4y/xVMgDgK9k90Rhm1tAFo9ObPUS7mm7+QR2hboxHLpvB
         dsZVDckhrER6CTwzFUAOfZ7O/ziRRZ00VT0gZk7FxEujQuESJgyxx3/Ja46sb5vEPpEu
         LE8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=022kZssKRxaMpugjGKU5wCX5ZoP2APDtJSWAVWLNIMQ=;
        b=V/iOMQ+rhRrS5yrGssIoCOym15yfeCdR+n7Ub1K/++w61qprPGC3w7w6s2QPFV2gIY
         587Fm0tOj/taGONUKsPz3Q84UcxRAJiFgPSt6sCTN4BbHmB7Cnx3uNX4cH9fJNurEPtX
         OKtyv8jHxGJKDUN0/yqts/imT7/EccYxIomuooz4RKJjMhlgGCIxf3fs5iNRjAAk7wm0
         gQjD05MvzixO+ZwaxkVm80uv9X0DhEmsMK0jpmMw6u4vjPdOgP32XIbuppgZf8g+K+Ar
         yaeC+17Tiw9/Rz65brimj7MpnjNau2Wip2EhUAkMkh16jYJxIh90uPTC3PadnvBpSsZj
         PqZA==
X-Gm-Message-State: AOAM530o3By+YNY7SeRq/hkP+vdNKbaWVOMLWueGkrt+W2jOP8eDHLZO
        t++ce9+MquyFW1d+Ne3w+WE7sIX/ZN4UlA==
X-Google-Smtp-Source: ABdhPJzpifjGAbuu6xRUlnf5+5w0PowUD9oB5ib2xOZlLUbFVmQQfdultSBOPWNeGa1Cxn5pvTWrGQ==
X-Received: by 2002:a92:c24a:0:b0:2c2:8100:11ec with SMTP id k10-20020a92c24a000000b002c2810011ecmr15889480ilo.69.1646761400849;
        Tue, 08 Mar 2022 09:43:20 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id a18-20020a6b6c12000000b005ece5a4f2dfsm10029480ioh.54.2022.03.08.09.43.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 09:43:20 -0800 (PST)
Date:   Tue, 8 Mar 2022 17:43:16 +0000
From:   Oliver Upton <oupton@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: use kvcalloc for array allocations
Message-ID: <YieVtBPtKOyatej+@google.com>
References: <20220308163318.819164-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308163318.819164-1-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 08, 2022 at 11:33:18AM -0500, Paolo Bonzini wrote:
> Instead of using array_size, use a function that takes care of the
> multiplication.  While at it, switch to kvcalloc since this allocation
> should not be very large.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/cpuid.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index afcdd4e693e5..419eb8e14f79 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1248,8 +1248,7 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>  	if (sanity_check_entries(entries, cpuid->nent, type))
>  		return -EINVAL;
>  
> -	array.entries = vzalloc(array_size(sizeof(struct kvm_cpuid_entry2),
> -					   cpuid->nent));
> +	array.entries = kvcalloc(sizeof(struct kvm_cpuid_entry2), cpuid->nent, GFP_KERNEL);

Even though this allocation is short-lived, should we use
GFP_KERNEL_ACCOUNT instead?

Otherwise:

Reviewed-by: Oliver Upton <oupton@google.com>

Thanks!


>  	if (!array.entries)
>  		return -ENOMEM;
>  
> @@ -1267,7 +1266,7 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>  		r = -EFAULT;
>  
>  out_free:
> -	vfree(array.entries);
> +	kvfree(array.entries);
>  	return r;
>  }
>  
> -- 
> 2.31.1
> 
