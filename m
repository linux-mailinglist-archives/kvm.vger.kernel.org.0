Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B32245F2A6
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 18:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239650AbhKZROg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 12:14:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35907 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229672AbhKZRMg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 12:12:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637946563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oJRbVgERr9nHJtHlBxfAUiQ5IlIj7tB/ekCKPBmxO0Q=;
        b=hNq31kYwLmY0p426wEZ5QisRBWuXEns/MMf4Sk/pQIGpw/kMkpw+Hpke0xQHAm6HeoznQa
        FaiQd5sEBsXEUeaQrzzcTJfaISneslgGJ6buz6WIaC2Xu+qaSzBNYg/WKCIU1tByGll3JT
        itkSiuWZfScx0lveL+z/FiNKGeqNI+w=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-R3dHHZeGPPCoqBYtQW6kCA-1; Fri, 26 Nov 2021 12:09:21 -0500
X-MC-Unique: R3dHHZeGPPCoqBYtQW6kCA-1
Received: by mail-wr1-f71.google.com with SMTP id x17-20020a5d6511000000b0019838caab88so1786880wru.6
        for <kvm@vger.kernel.org>; Fri, 26 Nov 2021 09:09:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=oJRbVgERr9nHJtHlBxfAUiQ5IlIj7tB/ekCKPBmxO0Q=;
        b=ws298DUxZ3joD4UPWmMXiwtaCdnyBFWuJ6ZnX0aGY7TNmC154nWYWn1MnNJM/1TjsF
         6nDbpdVrJFFOxiBYuDCp8bSXjUAvDMoI81CCODqBCuaQ1WiysLphV1kXdGM8RQh7IIjt
         73yFVk1zjEmmOXYPga59Vukq4SGjkahBHOk+1ooeYvNCaa28C4PMOUcLlhdGBemdt3Og
         1D0rgWA0Gmb8syvFbmmprzL8t+GBqD8+T/XC4vHGF+q8ThSHaQk2tzsSx0eubnAILiF6
         o7SeLq3bpw928KKUorEdCmCCAaxVeIJeuCjyJututPMVmwXSXNGDsr8I688p/bWwvQOf
         2sRA==
X-Gm-Message-State: AOAM530wOV09MMO5Vkgf3aJfGbnjZxYIAoeIfHEv7vt6uNRVzKHhR5Cn
        aJ3cEnf8jzXnL04vXj4eI9jTp3A3SBMk9Vo0+i8txUsNvW2a5JKf4eE3GDWcGxii4ntP4tzj8dX
        0peCt/6BtPInM
X-Received: by 2002:adf:f542:: with SMTP id j2mr15018869wrp.616.1637946560596;
        Fri, 26 Nov 2021 09:09:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwL5L/tD86RCqX1ISPfhzJW00g+afueiNingL26c2hmcDa5qME3mu8KGtYbsk2q2oF3mxNTgQ==
X-Received: by 2002:adf:f542:: with SMTP id j2mr15018833wrp.616.1637946560333;
        Fri, 26 Nov 2021 09:09:20 -0800 (PST)
Received: from [192.168.3.132] (p5b0c69e1.dip0.t-ipconnect.de. [91.12.105.225])
        by smtp.gmail.com with ESMTPSA id j40sm7815934wms.16.2021.11.26.09.09.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 09:09:19 -0800 (PST)
Message-ID: <963e5934-094d-3ed5-3a49-c25dd7a17fb8@redhat.com>
Date:   Fri, 26 Nov 2021 18:09:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3 3/3] KVM: s390: gaccess: Cleanup access to guest pages
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211126164549.7046-1-scgl@linux.ibm.com>
 <20211126164549.7046-4-scgl@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20211126164549.7046-4-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26.11.21 17:45, Janis Schoetterl-Glausch wrote:
> Introduce a helper function for guest frame access.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/gaccess.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index c09659609d68..9193f0de40b1 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -866,6 +866,20 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>  	return 0;
>  }
>  
> +static int access_guest_page(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
> +			     void *data, unsigned int len)
> +{
> +	const unsigned int offset = offset_in_page(gpa);
> +	const gfn_t gfn = gpa_to_gfn(gpa);
> +	int rc;
> +
> +	if (mode == GACC_STORE)
> +		rc = kvm_write_guest_page(kvm, gfn, data, offset, len);
> +	else
> +		rc = kvm_read_guest_page(kvm, gfn, data, offset, len);
> +	return rc;
> +}
> +
>  int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>  		 unsigned long len, enum gacc_mode mode)
>  {
> @@ -896,10 +910,7 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>  	rc = guest_range_to_gpas(vcpu, ga, ar, gpas, len, asce, mode);
>  	for (idx = 0; idx < nr_pages && !rc; idx++) {
>  		fragment_len = min(PAGE_SIZE - offset_in_page(gpas[idx]), len);
> -		if (mode == GACC_STORE)
> -			rc = kvm_write_guest(vcpu->kvm, gpas[idx], data, fragment_len);
> -		else
> -			rc = kvm_read_guest(vcpu->kvm, gpas[idx], data, fragment_len);
> +		rc = access_guest_page(vcpu->kvm, mode, gpas[idx], data, fragment_len);
>  		len -= fragment_len;
>  		data += fragment_len;
>  	}
> @@ -920,10 +931,7 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
>  	while (len && !rc) {
>  		gpa = kvm_s390_real_to_abs(vcpu, gra);
>  		fragment_len = min(PAGE_SIZE - offset_in_page(gpa), len);
> -		if (mode)
> -			rc = write_guest_abs(vcpu, gpa, data, fragment_len);
> -		else
> -			rc = read_guest_abs(vcpu, gpa, data, fragment_len);
> +		rc = access_guest_page(vcpu->kvm, mode, gpa, data, fragment_len);
>  		len -= fragment_len;
>  		gra += fragment_len;
>  		data += fragment_len;
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

