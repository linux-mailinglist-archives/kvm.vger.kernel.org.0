Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFAE3185985
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 04:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgCODBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 23:01:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37700 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726610AbgCODBO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Mar 2020 23:01:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584241273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FRJJgorlYb/Dr1PqrpATC8AHYdzBhDh2W2NAQ//YJHM=;
        b=HIK3w0pi8oEMNHcXhTqj60in1Ko9imp0hu/TGaVnh45FodolKkDua/vSxxtnZXeoR3aVPE
        BZo1DnL7DqvxjP6TUrXmp6CBIENbVwN51fQnxSUE2nXOMNsbqOhPtRIw04BdPGhXd4FfSc
        mT2ZBlQ/A7Ks36F7yeTaiMG9tYMROSw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-1uFr6rOCMp6-ZB_sJ1j2lw-1; Sat, 14 Mar 2020 06:58:56 -0400
X-MC-Unique: 1uFr6rOCMp6-ZB_sJ1j2lw-1
Received: by mail-wr1-f71.google.com with SMTP id w11so5777354wrp.20
        for <kvm@vger.kernel.org>; Sat, 14 Mar 2020 03:58:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FRJJgorlYb/Dr1PqrpATC8AHYdzBhDh2W2NAQ//YJHM=;
        b=s9gSLOvRlHDsW3xnb5Kwtc0l8NmxWHu9nM1DelIpYMGsNHx1daLHIl/8JxZEc9JC6x
         2UNcDbXB+n88lHKtska3hr2kRasX9+1r2vXRGEJckuIzgDkrld7pxc4mkAhlQ9sl3uIB
         NvoTZuWcxA0DyEz+qz3tVY2m2NAOMneuL308AoxCMwGpqKV//nxUQd0yMMw2IkyY7QPI
         utrS9yP6YMAzKH0kxXy9hZfC08vfA87A3u+GREo1Q2WsX9FuTtk21tlf8EcfdibBB8QO
         HkDQONueiiePvSo5pMESasafk9s8xLEJic0CWLW876ZTWkXcZRGbX73630WN9e/Tquue
         W8yQ==
X-Gm-Message-State: ANhLgQ3StY9U7Rw/tnfG4gNxAa4gmtynaTwPenIbVdCSlInaJmMpDZ38
        E1dusQjU+78IGBLUULs6TZSBnWD5GbTh80o70hOX04d38LJQs9IStZndQPFahIKa/y9rrFyQW8L
        y9cyMDOmuWV/d
X-Received: by 2002:adf:b650:: with SMTP id i16mr12258083wre.316.1584183535476;
        Sat, 14 Mar 2020 03:58:55 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtMHHycdtd+2e2MBLdM6Bn1NobzIs9n83uWxIcXLROYUTVISIInszSOL7n6dB0RgYEcPM2jTQ==
X-Received: by 2002:adf:b650:: with SMTP id i16mr12258065wre.316.1584183535179;
        Sat, 14 Mar 2020 03:58:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7de8:5d90:2370:d1ac? ([2001:b07:6468:f312:7de8:5d90:2370:d1ac])
        by smtp.gmail.com with ESMTPSA id n14sm9566443wmi.19.2020.03.14.03.58.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2020 03:58:54 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: s390x: Provide additional num-guest-pages
 adjustment
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, thuth@redhat.com
References: <20200312104055.8558-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <77c7ee95-dba0-e35f-b03c-3a5252c41c66@redhat.com>
Date:   Sat, 14 Mar 2020 11:58:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200312104055.8558-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/03/20 11:40, Andrew Jones wrote:
> s390 requires 1M aligned guest sizes. Embedding the rounding in
> vm_adjust_num_guest_pages() allows us to remove it from a few
> other places.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  tools/testing/selftests/kvm/demand_paging_test.c | 4 ----
>  tools/testing/selftests/kvm/dirty_log_test.c     | 5 +----
>  tools/testing/selftests/kvm/include/kvm_util.h   | 8 +++++++-
>  3 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index c1e326d3ed7f..ae086c5dc118 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -378,10 +378,6 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
>  	guest_num_pages = (vcpus * vcpu_memory_bytes) / guest_page_size;
>  	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
>  
> -#ifdef __s390x__
> -	/* Round up to multiple of 1M (segment size) */
> -	guest_num_pages = (guest_num_pages + 0xff) & ~0xffUL;
> -#endif
>  	/*
>  	 * If there should be more memory in the guest test region than there
>  	 * can be pages in the guest, it will definitely cause problems.
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 518a94a7a8b5..8a79f5d6b979 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -296,10 +296,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>  	guest_num_pages = (1ul << (DIRTY_MEM_BITS -
>  				   vm_get_page_shift(vm))) + 3;
>  	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
> -#ifdef __s390x__
> -	/* Round up to multiple of 1M (segment size) */
> -	guest_num_pages = (guest_num_pages + 0xff) & ~0xffUL;
> -#endif
> +
>  	host_page_size = getpagesize();
>  	host_num_pages = vm_num_host_pages(mode, guest_num_pages);
>  
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 707b44805149..ade5a40afbee 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -164,7 +164,13 @@ unsigned int vm_num_guest_pages(enum vm_guest_mode mode, unsigned int num_host_p
>  static inline unsigned int
>  vm_adjust_num_guest_pages(enum vm_guest_mode mode, unsigned int num_guest_pages)
>  {
> -	return vm_num_guest_pages(mode, vm_num_host_pages(mode, num_guest_pages));
> +	unsigned int n;
> +	n = vm_num_guest_pages(mode, vm_num_host_pages(mode, num_guest_pages));
> +#ifdef __s390x__
> +	/* s390 requires 1M aligned guest sizes */
> +	n = (n + 255) & ~255;
> +#endif
> +	return n;
>  }
>  
>  struct kvm_userspace_memory_region *
> 

Queued, thanks.

Paolo

