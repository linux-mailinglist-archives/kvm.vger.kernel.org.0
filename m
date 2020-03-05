Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C654617AB20
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 18:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgCERD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 12:03:56 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35080 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725944AbgCERD4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Mar 2020 12:03:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583427834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+gBea8Ut08GlhDI9hHgDu2CcQmB1gpx84oWYQvMgPMQ=;
        b=b1+NSMYQFkYHcZjSXg970nD7DkOgwDS9opLYhHay+XJiNCaZdRdmMl7/jBtBdYGRnShUbJ
        Q8yIWdKxSY5u55aWMPgFO01rNCP8ayzaHHK/g2aTDdVGTGzNxBwZwCiR53T7K/AZ4P+L1X
        6IdCFAguPrhmGpVE97fCcJZzg/BQGGA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-uv-1zJ3QPMudXjTTkpif0Q-1; Thu, 05 Mar 2020 12:03:53 -0500
X-MC-Unique: uv-1zJ3QPMudXjTTkpif0Q-1
Received: by mail-wr1-f71.google.com with SMTP id q18so2546100wrw.5
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 09:03:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+gBea8Ut08GlhDI9hHgDu2CcQmB1gpx84oWYQvMgPMQ=;
        b=Z7xrU37852/6n/P+9DLCrGLh5ayv867hJe1qXCIBCBHGxwBwqmZUhEHczZm0TVecbE
         26t5/V8UZkG/6KVt+PbtN0JG6pb9kDb4Bta4pETINwNCOXBgJMDJyx8LJ54//2/2HyUz
         W47JaiZCFCZ6nIKabuZNXdDpBNpjhUTfYiE7ExFQ+Stv0DhYC/RfQXgImHllUTD9cri8
         lgI2YQ0VKn1O48YTqlM5GDjpnB4Gtu+fvi8WBoBbg4B6MBg/6H/FhnlGAZjeI+9gigxX
         6m4LIhQU0ROc/F3oGSMybA1YNHH8nKLNYIycFo+ipFowILuzSLfIzlwlSi1yqKzuGLiM
         20Gw==
X-Gm-Message-State: ANhLgQ1GVBRnYLBjDJZ7FTvW2GWAVyXRGLqCVH/m47QVPR+ojQquLxob
        mCui1ZLMC/fS3kY0AlxshLRWppRsIW6DAacn1OMgfuwhTdBGnzS6eYGx8zsyGePyhVzGO278oz1
        WH6Ya9JJL4Ajl
X-Received: by 2002:a1c:e087:: with SMTP id x129mr10558800wmg.18.1583427831524;
        Thu, 05 Mar 2020 09:03:51 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsdHGDwU1gMubIJZjsDgm2LvNu9TaryVqAyIVNzhRd1nEfTk0rLwmch7tF0Njrf/WO2RWDI6Q==
X-Received: by 2002:a1c:e087:: with SMTP id x129mr10558775wmg.18.1583427831226;
        Thu, 05 Mar 2020 09:03:51 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:9def:34a0:b68d:9993? ([2001:b07:6468:f312:9def:34a0:b68d:9993])
        by smtp.gmail.com with ESMTPSA id x8sm34059043wro.55.2020.03.05.09.03.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 09:03:50 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] x86: Move definition of some exception
 vectors into processor.h
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org
References: <20200304074932.77095-1-xiaoyao.li@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3ad11480-94cc-af2d-e852-1ac556f02e32@redhat.com>
Date:   Thu, 5 Mar 2020 18:03:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200304074932.77095-1-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/03/20 08:49, Xiaoyao Li wrote:
> Both processor.h and desc.h hold some definitions of exception vector.
> put them together in processor.h
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  lib/x86/desc.h      | 5 -----
>  lib/x86/processor.h | 3 +++
>  x86/debug.c         | 1 +
>  x86/idt_test.c      | 1 +
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/x86/desc.h b/lib/x86/desc.h
> index 00b93285f5c6..0fe5cbf35577 100644
> --- a/lib/x86/desc.h
> +++ b/lib/x86/desc.h
> @@ -91,11 +91,6 @@ typedef struct  __attribute__((packed)) {
>      "1111:"
>  #endif
>  
> -#define DB_VECTOR   1
> -#define BP_VECTOR   3
> -#define UD_VECTOR   6
> -#define GP_VECTOR   13
> -
>  /*
>   * selector     32-bit                        64-bit
>   * 0x00         NULL descriptor               NULL descriptor
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 103e52b19d82..67ba416b73ff 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -15,6 +15,9 @@
>  #  define S "4"
>  #endif
>  
> +#define DB_VECTOR 1
> +#define BP_VECTOR 3
> +#define UD_VECTOR 6
>  #define DF_VECTOR 8
>  #define TS_VECTOR 10
>  #define NP_VECTOR 11
> diff --git a/x86/debug.c b/x86/debug.c
> index c5db4c6ecf5a..972762a72ce8 100644
> --- a/x86/debug.c
> +++ b/x86/debug.c
> @@ -10,6 +10,7 @@
>   */
>  
>  #include "libcflat.h"
> +#include "processor.h"
>  #include "desc.h"
>  
>  static volatile unsigned long bp_addr;
> diff --git a/x86/idt_test.c b/x86/idt_test.c
> index aa2973301ee0..964f119060ee 100644
> --- a/x86/idt_test.c
> +++ b/x86/idt_test.c
> @@ -1,4 +1,5 @@
>  #include "libcflat.h"
> +#include "processor.h"
>  #include "desc.h"
>  
>  static int test_ud2(bool *rflags_rf)
> 

Queued, thanks.

Paolo

