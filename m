Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254293BF279
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 01:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhGGXeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 19:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhGGXeB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 19:34:01 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BB1C061574
        for <kvm@vger.kernel.org>; Wed,  7 Jul 2021 16:31:19 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id y4so1490869pgl.10
        for <kvm@vger.kernel.org>; Wed, 07 Jul 2021 16:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sBp/KCSLuBhwQ1kjw0+4NY8DmxOjGcK1rRA8bKsITnw=;
        b=kuLWnef3pLZ8qeP5DH+PH5NFPQJ1juHZpaYreL5Q29lynQZY7sseOR9V1uUdcBpTEE
         zycmoJq3i/5tfjFJK8FfHikoBsIOigAhkcK9uH1jkmJ3QP79KQuMcNXzm1i6Ng71PZZ5
         NycUjxLm1bn8jp1Grh2HMprni1gEr2c+cO+SxmQ7RrwOJsYmz9xQSY8p8NAW94mFD+Uw
         eCd7clemXqEm4rmMLc5J1cjZxPZTclF8hNjqTwpq0AxdYBYTFrzjgYgEry4ftdMbdac0
         +F4pBj2q7mrKif8TN662ESizNbVcYmmpXx7b5Ewjn3ToOeTUmcMjL6VV+Fw7dIzyuV3+
         7wyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sBp/KCSLuBhwQ1kjw0+4NY8DmxOjGcK1rRA8bKsITnw=;
        b=j3qjSwHqQWt4LKMHIi9q+9i0FpgaWCCXoJFaiPYdSMUzK3gUVXMsyXRSYjDxNAaxHg
         DZGCgp51lj04LxVBV8NHOPeLAodnnZ4RgTfvTQ9XvTbsjMsQMzhs9d/LkhLmA5kEV176
         C33l9ybAD06ZbEAKfuSGDpW+fCKm6KCLXVF5EBRTClc6BgldkzELJSd24VzguBZ3EAym
         FWPZ0urftYpg3uZLmpBGvVyILN5fOue11Zffh8biGiIqP7AoRJmOT+NsYmKf2K0xg7cy
         8FlgxrP4eCcU4lUWFdlUbJAuLBAlT4Aub3ipI4O1txSKGb1FhgZeoy417kw5KOmFe/GB
         Xs2g==
X-Gm-Message-State: AOAM533fa6I/qeSvwDUhwQbiXvSI9kL2IL1Q6gyh2fGZcUU6VpRXj93Z
        GzrdEXxESEEDWJu887H5f2e+GMPPNqbacQ==
X-Google-Smtp-Source: ABdhPJwBR3MXtssGiOQ4tmIkIfl0zyd5DUts1bTMC6/CWU0frjjxFd/fsHeeX1f34L5W3CCEsIOTrQ==
X-Received: by 2002:a63:d14c:: with SMTP id c12mr28274938pgj.412.1625700679242;
        Wed, 07 Jul 2021 16:31:19 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id e2sm378871pgh.5.2021.07.07.16.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 16:31:18 -0700 (PDT)
Date:   Wed, 7 Jul 2021 23:31:14 +0000
From:   David Matlack <dmatlack@google.com>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v1 2/4] KVM: stats: Update doc for histogram statistics
Message-ID: <YOY5QndV0O3giRJ2@google.com>
References: <20210706180350.2838127-1-jingzhangos@google.com>
 <20210706180350.2838127-3-jingzhangos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210706180350.2838127-3-jingzhangos@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 06, 2021 at 06:03:48PM +0000, Jing Zhang wrote:
> Add documentations for linear and logarithmic histogram statistics.
> Add binary stats capability text which is missing during merge of
> the binary stats patch.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 36 +++++++++++++++++++++++++++++++---
>  1 file changed, 33 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 3b6e3b1628b4..948d33c26704 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5171,6 +5171,9 @@ by a string of size ``name_size``.
>  	#define KVM_STATS_TYPE_CUMULATIVE	(0x0 << KVM_STATS_TYPE_SHIFT)
>  	#define KVM_STATS_TYPE_INSTANT		(0x1 << KVM_STATS_TYPE_SHIFT)
>  	#define KVM_STATS_TYPE_PEAK		(0x2 << KVM_STATS_TYPE_SHIFT)
> +	#define KVM_STATS_TYPE_LINEAR_HIST	(0x3 << KVM_STATS_TYPE_SHIFT)
> +	#define KVM_STATS_TYPE_LOG_HIST		(0x4 << KVM_STATS_TYPE_SHIFT)
> +	#define KVM_STATS_TYPE_MAX		KVM_STATS_TYPE_LOG_HIST
>  
>  	#define KVM_STATS_UNIT_SHIFT		4
>  	#define KVM_STATS_UNIT_MASK		(0xF << KVM_STATS_UNIT_SHIFT)
> @@ -5178,11 +5181,13 @@ by a string of size ``name_size``.
>  	#define KVM_STATS_UNIT_BYTES		(0x1 << KVM_STATS_UNIT_SHIFT)
>  	#define KVM_STATS_UNIT_SECONDS		(0x2 << KVM_STATS_UNIT_SHIFT)
>  	#define KVM_STATS_UNIT_CYCLES		(0x3 << KVM_STATS_UNIT_SHIFT)
> +	#define KVM_STATS_UNIT_MAX		KVM_STATS_UNIT_CYCLES
>  
>  	#define KVM_STATS_BASE_SHIFT		8
>  	#define KVM_STATS_BASE_MASK		(0xF << KVM_STATS_BASE_SHIFT)
>  	#define KVM_STATS_BASE_POW10		(0x0 << KVM_STATS_BASE_SHIFT)
>  	#define KVM_STATS_BASE_POW2		(0x1 << KVM_STATS_BASE_SHIFT)
> +	#define KVM_STATS_BASE_MAX		KVM_STATS_BASE_POW2
>  
>  	struct kvm_stats_desc {
>  		__u32 flags;
> @@ -5214,6 +5219,22 @@ Bits 0-3 of ``flags`` encode the type:
>      represents a peak value for a measurement, for example the maximum number
>      of items in a hash table bucket, the longest time waited and so on.
>      The corresponding ``size`` field for this type is always 1.
> +  * ``KVM_STATS_TYPE_LINEAR_HIST``
> +    The statistics data is in the form of linear histogram. The number of
> +    buckets is specified by the ``size`` field. The size of buckets is specified
> +    by the ``hist_param`` field. The range of the Nth bucket (1 <= N < ``size``)
> +    is [``hist_param``*(N-1), ``hist_param``*N), while the range of the last
> +    bucket is [``hist_param``*(``size``-1), +INF). (+INF means positive infinity
> +    value.) The bucket value indicates how many times the statistics data is in
> +    the bucket's range.
> +  * ``KVM_STATS_TYPE_LOG_HIST``
> +    The statistics data is in the form of logarithmic histogram. The number of
> +    buckets is specified by the ``size`` field. The base of logarithm is
> +    specified by the ``hist_param`` field. The range of the Nth bucket (1 < N <
> +    ``size``) is [pow(``hist_param``, N-2), pow(``hist_param``, N-1)). The range
> +    of the first bucket is [0, 1), while the range of the last bucket is
> +    [pow(``hist_param``, ``size``-2), +INF). The bucket value indicates how many
> +    times the statistics data is in the bucket's range.
>  
>  Bits 4-7 of ``flags`` encode the unit:
>    * ``KVM_STATS_UNIT_NONE``
> @@ -5246,9 +5267,10 @@ unsigned 64bit data.
>  The ``offset`` field is the offset from the start of Data Block to the start of
>  the corresponding statistics data.
>  
> -The ``unused`` field is reserved for future support for other types of
> -statistics data, like log/linear histogram. Its value is always 0 for the types
> -defined above.
> +The ``hist_param`` field is used as a parameter for histogram statistics data.
> +For linear histogram statistics data, it indicates the size of a bucket. For
> +logarithmic histogram statistics data, it indicates the base of the logarithm.
> +Only base of 2 is supported fo logarithmic histogram.
>  
>  The ``name`` field is the name string of the statistics data. The name string
>  starts at the end of ``struct kvm_stats_desc``.  The maximum length including
> @@ -7182,3 +7204,11 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
>  of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
>  the hypercalls whose corresponding bit is in the argument, and return
>  ENOSYS for the others.
> +
> +8.35 KVM_CAP_STATS_BINARY_FD
> +----------------------------
> +
> +:Architectures: all
> +
> +This capability indicates the feature that userspace can get a file descriptor
> +for every VM and VCPU to read statistics data in binary format.

This should probably be in a separate patch with a Fixes tag.

Fixes: fdc09ddd4064 ("KVM: stats: Add documentation for binary statistics interface")

> -- 
> 2.32.0.93.g670b81a890-goog
> 
