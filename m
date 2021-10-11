Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03ECE4286D6
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 08:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbhJKGbd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 02:31:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26443 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234192AbhJKGbb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Oct 2021 02:31:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633933771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KEdFLRNz/Q/R/jANyrfs68VmplqYNMsovniI6reLjIY=;
        b=fyl6uq6C0FbaIs378mQx2jtLmOTjZq78InOlMXKavvKLdJTxwhuFoFb9/xTqMbWCOf6Fvd
        Ocn80somEcvu8yppumnujgWT2NgyqU67/PRGkrzIPpJaGGU0AJ8uDSOV0eI+h9kzNGWV6z
        /AMO/7EymRjNpwBaej0R/IZVvkpJPWE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-LN8mIuwfPXih_rEstfSlsw-1; Mon, 11 Oct 2021 02:29:29 -0400
X-MC-Unique: LN8mIuwfPXih_rEstfSlsw-1
Received: by mail-wr1-f71.google.com with SMTP id r21-20020adfa155000000b001608162e16dso12369819wrr.15
        for <kvm@vger.kernel.org>; Sun, 10 Oct 2021 23:29:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KEdFLRNz/Q/R/jANyrfs68VmplqYNMsovniI6reLjIY=;
        b=OwltzcAU/XCgGaZf+JVI52TQzQqj49RG3a8NhmjVsfXQj0nPD9zOkhAAYZJO73V/jD
         z9y/Dx5KAQcCTkXhc3pTd3dwPT/4fdku3XcuFw6m3I0IXYvmgEC5TICQl6mjQiv/hJQQ
         nGncZ4PhLQfvVnn9xJztui0ufSZTQIpLs1TpTQSmQ1jfLqz6MA/3u6jez2ftjOyg1yld
         dAZIZVDcNIxU/9fGWijtv3j9Gi6i6fYe2FunKVMiJi82P4JEwevGnkszH/9hEq7k+Lfd
         3ur72Y0pMzI8Eey2H/TJuXHA8NY+QHPX3u57SH04aQI4kLm1On7oAYEQB7aEDhjj1cMs
         cSmQ==
X-Gm-Message-State: AOAM532sVOUPFlj6DJ5OXkEfo3VCuSxhMYJ4c1rDMmabSFVD6JKOQlEZ
        qG7BpyAenasTV7mZAXx+YhXKv/mCZyOybSOuJMsUgVBOapq2g4PWAL6J3U4TgQiNLVc6fILDnmk
        O4GvM4YtTyXkW
X-Received: by 2002:a1c:2543:: with SMTP id l64mr19176095wml.9.1633933768644;
        Sun, 10 Oct 2021 23:29:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1o7EGjT31kVHA/qKateCR84NvgSWBjsArIHFhQbAyjn6eefrBnaIrBJXOScMkAYhaC113hQ==
X-Received: by 2002:a1c:2543:: with SMTP id l64mr19176073wml.9.1633933768358;
        Sun, 10 Oct 2021 23:29:28 -0700 (PDT)
Received: from thuth.remote.csb (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id f184sm6694880wmf.22.2021.10.10.23.29.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 23:29:27 -0700 (PDT)
To:     Eric Farman <farman@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20211008203112.1979843-1-farman@linux.ibm.com>
 <20211008203112.1979843-2-farman@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [RFC PATCH v1 1/6] KVM: s390: Simplify SIGP Set Arch handling
Message-ID: <912906c5-5932-c6d5-76c7-0751412c1344@redhat.com>
Date:   Mon, 11 Oct 2021 08:29:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211008203112.1979843-2-farman@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/10/2021 22.31, Eric Farman wrote:
> The Principles of Operations describe the various reasons that
> each individual SIGP orders might be rejected, and the status
> bit that are set for each condition.
> 
> For example, for the Set Architecture order, it states:
> 
>    "If it is not true that all other CPUs in the configu-
>     ration are in the stopped or check-stop state, ...
>     bit 54 (incorrect state) ... is set to one."
> 
> However, it also states:
> 
>    "... if the CZAM facility is installed, ...
>     bit 55 (invalid parameter) ... is set to one."
> 
> Since the Configuration-z/Architecture-Architectural Mode (CZAM)
> facility is unconditionally presented, there is no need to examine
> each VCPU to determine if it is started/stopped. It can simply be
> rejected outright with the Invalid Parameter bit.
> 
> Fixes: b697e435aeee ("KVM: s390: Support Configuration z/Architecture Mode")
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   arch/s390/kvm/sigp.c | 14 +-------------
>   1 file changed, 1 insertion(+), 13 deletions(-)
> 
> diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
> index 683036c1c92a..cf4de80bd541 100644
> --- a/arch/s390/kvm/sigp.c
> +++ b/arch/s390/kvm/sigp.c
> @@ -151,22 +151,10 @@ static int __sigp_stop_and_store_status(struct kvm_vcpu *vcpu,
>   static int __sigp_set_arch(struct kvm_vcpu *vcpu, u32 parameter,
>   			   u64 *status_reg)
>   {
> -	unsigned int i;
> -	struct kvm_vcpu *v;
> -	bool all_stopped = true;
> -
> -	kvm_for_each_vcpu(i, v, vcpu->kvm) {
> -		if (v == vcpu)
> -			continue;
> -		if (!is_vcpu_stopped(v))
> -			all_stopped = false;
> -	}
> -
>   	*status_reg &= 0xffffffff00000000UL;
>   
>   	/* Reject set arch order, with czam we're always in z/Arch mode. */
> -	*status_reg |= (all_stopped ? SIGP_STATUS_INVALID_PARAMETER :
> -					SIGP_STATUS_INCORRECT_STATE);
> +	*status_reg |= SIGP_STATUS_INVALID_PARAMETER;
>   	return SIGP_CC_STATUS_STORED;
>   }

I was initially a little bit torn by this modification, since, as you 
already mentioned, it could theoretically be possible that a userspace (like 
an older version of QEMU) does not use CZAM bit yet. But then I read an 
older version of the PoP which does not feature CZAM yet, and it reads:

"The set-architecture order is completed as follows:
• If the code in the parameter register is not 0, 1, or
   2, or if the CPU is already in the architectural
   mode specified by the code, the order is not
   accepted. Instead, bit 55 (invalid parameter) of
   the general register designated by the R 1 field of
   the SIGNAL PROCESSOR instruction is set to
   one, and condition code 1 is set.
• If it is not true that all other CPUs in the configu-
   ration are in the stopped or check-stop state, the
   order is not accepted. Instead, bit 54 (incorrect
   state) of the general register designated by the
   R 1 field of the SIGNAL PROCESSOR instruction
   is set to one, and condition code 1 is set.
• The architectural mode of all CPUs in the config-
   uration is set as specified by the code.
   ..."

So to me this sounds like "invalid parameter" has a higher priority than 
"incorrect state" anyway, so we likely never
should have reported here "incorrect state"...?

Thus, I think it's the right way to go now:

Reviewed-by: Thomas Huth <thuth@redhat.com>

