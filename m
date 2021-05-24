Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B642E38F52A
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 23:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbhEXVwR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 17:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbhEXVwP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 17:52:15 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C586C061574
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 14:50:45 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id h20-20020a17090aa894b029015db8f3969eso11343414pjq.3
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 14:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1LIxY7Ij3UrUOv7Il7P47ofsQIlqfktbuapxHDHzy9s=;
        b=XSHnRITS8nxoftyiOoXlCMe4sR9i1NxJcUp5NBp6zR97O3o1TsPjpDr4wYxD3WdWhc
         i5sThETjwzSJZTDPMKR1n3eyrmop8QhDSda4cNgpLVHhNvqtBvwm02GoAHJDuANs0SYE
         dsU52zcDMiSpL9eGDdqQOF4f81bgfzFZCPi7KnzL//GiH/LsAcKL3q5fT9eZk5YprqEw
         wcj9SZoTmGMMWPRyYaEAGqJROGe20yQbXcfzETZczk+vMwzdcWeZiyAvxvC54rBfxfQY
         9Bl1LUaVxr1LkcHroTYIh89UyQF6DukJbePqTrdz2F3+GYrTUFyOPcE0rJXLQob7MijR
         6ZxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1LIxY7Ij3UrUOv7Il7P47ofsQIlqfktbuapxHDHzy9s=;
        b=pIO77SV9WX+abYIPdqiZNU+eaATy16+FNUlnASWNhnZKTnK01B7zm5YoyCrPOJu2kH
         bwj+oDCo+FLt5VNRVLttvAFAHrPWGxItGdR53/U0MSWPKKzeuuyNXQ4zXmGr4OJSGCxk
         DFvIq8NPWu1g72vnckT15tdoXo+QuXzahQhTLkgnj5ruwFhdIzGixi6UEr8E/yK99ove
         9PUA4d1WQ0fQa5ZbjUrADTK5+EGpr9uEgKce1ysnw/DaYuM7fdTxJ0vWW8dleheVUroT
         stNgo4SQYkf8W5H0VI32zwUPIwOd2EK5cmzwgYksJiDfXUEekZD+6IoKWWyr63yIGcRI
         U+NQ==
X-Gm-Message-State: AOAM5319iWIdAZJubrfz0seTLgqxply3NCg6NfzQXeMpDzWwHrwf7rh9
        d2t/BpIJ7gV7CsTWeBLLZEvrQw==
X-Google-Smtp-Source: ABdhPJwemR0Csu7duh/l9o7U7SM+60b46wfosFlH/WytvymUKyVC7vyQyWpdSfuaq8B26q2ab5Cl6g==
X-Received: by 2002:a17:90a:cc06:: with SMTP id b6mr1298484pju.19.1621893044680;
        Mon, 24 May 2021 14:50:44 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id k21sm11880753pgb.56.2021.05.24.14.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 14:50:43 -0700 (PDT)
Date:   Mon, 24 May 2021 21:50:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jing Liu <jing2.liu@linux.intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jing2.liu@intel.com
Subject: Re: [PATCH RFC 4/7] kvm: x86: Add new ioctls for XSAVE extension
Message-ID: <YKwfsIT5DuE+L+4M@google.com>
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-5-jing2.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210207154256.52850-5-jing2.liu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Feb 07, 2021, Jing Liu wrote:
> The static xstate buffer kvm_xsave contains the extended register
> states, but it is not enough for dynamic features with large state.
> 
> Introduce a new capability called KVM_CAP_X86_XSAVE_EXTENSION to
> detect if hardware has XSAVE extension (XFD). Meanwhile, add two
> new ioctl interfaces to get/set the whole xstate using struct
> kvm_xsave_extension buffer containing both static and dynamic
> xfeatures. Reuse fill_xsave and load_xsave for both cases.
> 
> Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
> ---
>  arch/x86/include/uapi/asm/kvm.h |  5 +++
>  arch/x86/kvm/x86.c              | 70 +++++++++++++++++++++++++--------
>  include/uapi/linux/kvm.h        |  8 ++++
>  3 files changed, 66 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 89e5f3d1bba8..bf785e89a728 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -362,6 +362,11 @@ struct kvm_xsave {
>  	__u32 region[1024];
>  };
>  
> +/* for KVM_CAP_XSAVE_EXTENSION */
> +struct kvm_xsave_extension {
> +	__u32 region[3072];

Fool me once, shame on you (Intel).  Fool me twice, shame on me (KVM).

As amusing as kvm_xsave_really_extended would be, the required size should be
discoverable, not hardcoded.  Nothing prevents a hardware vendor from inventing
a newfangled feature that requires yet more space.

As an alternative to adding a dedicated capability, can we leverage
GET_SUPPORTED_CPUID, leaf CPUID.0xD, to enumerate the minimum required size and
state that the new ioctl() is available if the min size is greater than 1024?
Or is that unnecessarily convoluted...
