Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08CD412F16
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 09:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhIUHKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 03:10:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59178 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230026AbhIUHKu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 03:10:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632208162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XjFX8TMy06JKFo29b5wtP7D4GUJciYA0H9pKx9SvMnM=;
        b=WUVw2YBM04u+n1R5RZxzSPXjc8JVZ8m34jvQU48kV+HuSE9AIzwAY4zopgAp57OZDcl8Qf
        k5GWj9ofPaTLpk84x/uFs8dERDUgCG5ZjItaH/MfoJHimUpm0FGcPm70qYsttpfOAaVWWT
        6Vra+p3yQE3kJ7EU0tNrsBn7g28rSTc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-gacI-UzxMcC9UUF2DGT0fg-1; Tue, 21 Sep 2021 03:09:19 -0400
X-MC-Unique: gacI-UzxMcC9UUF2DGT0fg-1
Received: by mail-ed1-f72.google.com with SMTP id h24-20020a50cdd8000000b003d8005fe2f8so14006864edj.6
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 00:09:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XjFX8TMy06JKFo29b5wtP7D4GUJciYA0H9pKx9SvMnM=;
        b=lgtZYBb6wdL1F44cWc1kDz9bqzf8fO1kBkItqc3lF9fKLaDQX7Ibg2+R8knfZNwbDX
         nz16P1pKYICb6IU81sxxZrUhAxQTjJcwb9lRqUqrb67u+k3UGZqm6vrUxiWTqGq629vl
         ixzVwORbF/YePuuoI54tc4wGFIXS6t4Bi8h+8NjacG6HgVO/v3ek8Ztx06wiRyfys76S
         eOzGPAvAl/qzQyE7ZMuEtHkr9JkhRQTczVXgcWPniqZF06XyIlqBs0p8IstuPiOcpM7F
         qsuQ9fRnd2ekY4dMfbPb0Vc8AAo/zChNIQfBIo1wUg2prlJeXqedw7awayF8Vsr3MRxm
         fHZw==
X-Gm-Message-State: AOAM53080uYnAnRLGVItm8SBCLZ8pyvWXfPbuhGkxlot2SYz+e4Vk9tv
        LeYVQmMFl7IrLbKrTa7HDtHKmI5pDqXlxFh2oc/fffFs66OsDLMROWw7opQSnFs7OzM0E3jAcGF
        6ivWYU5XqroVj
X-Received: by 2002:a05:6402:5186:: with SMTP id q6mr34420790edd.64.1632208158707;
        Tue, 21 Sep 2021 00:09:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyp+nqzB/L7XPOlCkV3Kf+TstkeUZIEG99Ro+U4OsVAaj3p8YvQky54QCUhsjWONz2ie8sFMw==
X-Received: by 2002:a05:6402:5186:: with SMTP id q6mr34420775edd.64.1632208158565;
        Tue, 21 Sep 2021 00:09:18 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id x7sm3936808ede.86.2021.09.21.00.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 00:09:17 -0700 (PDT)
Date:   Tue, 21 Sep 2021 09:09:15 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 1/2] selftests: KVM: Fix compiler warning in
 demand_paging_test
Message-ID: <20210921070915.mmubmdqqkf2qsit6@gator.home>
References: <20210921010120.1256762-1-oupton@google.com>
 <20210921010120.1256762-2-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210921010120.1256762-2-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 21, 2021 at 01:01:19AM +0000, Oliver Upton wrote:
> Building demand_paging_test.c with clang throws the following warning:
> 
> >> demand_paging_test.c:182:7: error: logical not is only applied to the left hand side of this bitwise operator [-Werror,-Wlogical-not-parentheses]
>                   if (!pollfd[0].revents & POLLIN)
> 
> Silence the warning by placing the bitwise operation within parentheses.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index e79c1b64977f..10edae425ab3 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -179,7 +179,7 @@ static void *uffd_handler_thread_fn(void *arg)
>  			return NULL;
>  		}
>  
> -		if (!pollfd[0].revents & POLLIN)
> +		if (!(pollfd[0].revents & POLLIN))

That's a bug fix. If revents was e.g. POLLPRI then this logic
wouldn't have done what it's supposed to do. Maybe we should
better call out that this is a fix in the summary and add a
fixes tag?

Anyway,

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

>  			continue;
>  
>  		r = read(uffd, &msg, sizeof(msg));
> -- 
> 2.33.0.464.g1972c5931b-goog
> 

