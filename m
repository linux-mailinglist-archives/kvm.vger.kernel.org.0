Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD57B475E49
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 18:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245165AbhLORMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 12:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbhLORMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 12:12:38 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18F0C061574
        for <kvm@vger.kernel.org>; Wed, 15 Dec 2021 09:12:37 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id t18so39327648wrg.11
        for <kvm@vger.kernel.org>; Wed, 15 Dec 2021 09:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=h/DJ40RMS/YFYrjy3BSP+Whe+JdaPtMAVaJH8hS/loU=;
        b=Lfl7DBc2ut2fLMVvG1lMmjEkSg+4iuA3NR4JIPGLox3MOyqKjM8pLiKh8phcGeuWt7
         beTbLmEUzLNCXkPEcw8cbgM/mb65n9z5EfWOiX4jNbUjIBii/op05F+80oQiXwEbUzAw
         qRPxwma6WF8JAXTMAPrY1tLu4yMXBFsNcbr3uukrl0okQTxm0oTT3LVGOicPWTkr2eVY
         V7AErP5sCbBNQncXCdToe4l8/8nwEjSDqb3jZ6mp6D31gkteUiUy8BOGKb1dkV0sp2GH
         mlyzgBnkc+PA7NaRU47n609BuPOlTEBDSzIagnU3pZ0KNezHX1EviogWtq3HElx+pIOp
         gR9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=h/DJ40RMS/YFYrjy3BSP+Whe+JdaPtMAVaJH8hS/loU=;
        b=2P571qBuCSACU8KD8VY0+k4NNgIA3OUkW9x1fH0AiFbQWpdaMJzNMZrqiklt26zzvu
         HoiGg9PdXHvkyzFUtQmVQi0av6kt+KwP8rF11B7x1DuBPiSliaSvL6H3mqtvDQ/mRr7w
         6Xxun1GtixecpdaGYR6OXCfOwnjxKE2CLq2VrKDcxkrBPP2wVG34LpkgULHrtsKxDpK3
         zFT+PopgawC7NJuDC3iQO9DJIMz5ohE6BtgELEflrRU6HfSq3tmMdH2PWOX1jBGXxQNo
         jbwXZ6U10XrUyeGMD+4Ez9HHMwI85MNyTD17byVdMVNq2NU95jDJZk/eCseioWtjNZA9
         Zw9Q==
X-Gm-Message-State: AOAM532yabXa+dP7M2q+6SSfM6vA0wAsyGcjrLnUxmnR+fF3WWBObPnF
        cYQrJyd+sEFOZ2KAbPfIMyQ=
X-Google-Smtp-Source: ABdhPJw1yDVtopfEyIyLJ7SBVb6hwM0MW7isNXDHbtz52Z8ByVqcVyshlQ97X460uwQ2m71ZXnwknA==
X-Received: by 2002:adf:8b8a:: with SMTP id o10mr5260578wra.569.1639588356370;
        Wed, 15 Dec 2021 09:12:36 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id h15sm6785541wmq.32.2021.12.15.09.12.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 09:12:36 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <d1f248ca-51ce-639f-b6dc-fec05b00cd61@redhat.com>
Date:   Wed, 15 Dec 2021 18:12:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] selftests: KVM: Fix non-x86 compiling
Content-Language: en-US
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
References: <20211214151842.848314-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211214151842.848314-1-drjones@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/21 16:18, Andrew Jones wrote:
> Attempting to compile on a non-x86 architecture fails with
> 
> include/kvm_util.h: In function ‘vm_compute_max_gfn’:
> include/kvm_util.h:79:21: error: dereferencing pointer to incomplete type ‘struct kvm_vm’
>    return ((1ULL << vm->pa_bits) >> vm->page_shift) - 1;
>                       ^~
> 
> This is because the declaration of struct kvm_vm is in
> lib/kvm_util_internal.h as an effort to make it private to
> the test lib code. We can still provide arch specific functions,
> though, by making the generic function symbols weak. Do that to
> fix the compile error.
> 
> Fixes: c8cc43c1eae2 ("selftests: KVM: avoid failures due to reserved HyperTransport region")
> Cc: stable@vger.kernel.org
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>   tools/testing/selftests/kvm/include/kvm_util.h | 10 +---------
>   tools/testing/selftests/kvm/lib/kvm_util.c     |  5 +++++
>   2 files changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index da2b702da71a..2d62edc49d67 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -71,15 +71,6 @@ enum vm_guest_mode {
>   
>   #endif
>   
> -#if defined(__x86_64__)
> -unsigned long vm_compute_max_gfn(struct kvm_vm *vm);
> -#else
> -static inline unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
> -{
> -	return ((1ULL << vm->pa_bits) >> vm->page_shift) - 1;
> -}
> -#endif
> -
>   #define MIN_PAGE_SIZE		(1U << MIN_PAGE_SHIFT)
>   #define PTES_PER_MIN_PAGE	ptes_per_page(MIN_PAGE_SIZE)
>   
> @@ -330,6 +321,7 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm);
>   
>   unsigned int vm_get_page_size(struct kvm_vm *vm);
>   unsigned int vm_get_page_shift(struct kvm_vm *vm);
> +unsigned long vm_compute_max_gfn(struct kvm_vm *vm);
>   uint64_t vm_get_max_gfn(struct kvm_vm *vm);
>   int vm_get_fd(struct kvm_vm *vm);
>   
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index daf6fdb217a7..53d2b5d04b82 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2328,6 +2328,11 @@ unsigned int vm_get_page_shift(struct kvm_vm *vm)
>   	return vm->page_shift;
>   }
>   
> +unsigned long __attribute__((weak)) vm_compute_max_gfn(struct kvm_vm *vm)
> +{
> +	return ((1ULL << vm->pa_bits) >> vm->page_shift) - 1;
> +}
> +
>   uint64_t vm_get_max_gfn(struct kvm_vm *vm)
>   {
>   	return vm->max_gfn;
> 

Applied, thanks.

Paolo
