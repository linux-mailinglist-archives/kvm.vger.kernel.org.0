Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81D54A48A6
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 14:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379166AbiAaNum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 08:50:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44795 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1359684AbiAaNum (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 Jan 2022 08:50:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643637041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E1qcvv1M9eZ7W8o85j2L42q1oejQGPwtKMSOzd1jhjI=;
        b=cF+aEVfIuCJFVIDHvL4L7DwxadOIZZRmZ/wBtITDvhD+X+AvrQ2tWJoaxx59U8F2QeB30B
        MafjL25rRGiOTgZ8d8xfCC9lfgUiUZ9Xtve8jqQ9cZ12MV05o+r1Sl0Ky5WQjLVNLLKy26
        ja/5C5fh+LWfO3oZR/t+giaVOBjXI6c=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-hFqGgjZ4M5Wn6Mk4dw7tPw-1; Mon, 31 Jan 2022 08:50:40 -0500
X-MC-Unique: hFqGgjZ4M5Wn6Mk4dw7tPw-1
Received: by mail-ed1-f71.google.com with SMTP id j1-20020aa7c341000000b0040417b84efeso6958482edr.21
        for <kvm@vger.kernel.org>; Mon, 31 Jan 2022 05:50:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=E1qcvv1M9eZ7W8o85j2L42q1oejQGPwtKMSOzd1jhjI=;
        b=Nz9yuE8aHRC6okOut/SSpE5k+eiduxCMDeoi9/++J6Lk9LxcrtOEpjE8jtx5LIfPRz
         uWi/y3ITfkZzFwaobANzLi9Hwa8bjlai81eypoy0GwqAn6krwYV5bx+b5y9oi5XkYrkH
         gBaEGh2BzlmZX4WIXq96HKpR61QFqZFmZ6Ija34z9n1lV4wuNO+9nws5lfOvnx+f1qhk
         y9c0uCu3akU5mpSIe4lJplV8IN1ZJW7JPJe/GHj7BR0llInbNWqcW7KlI9N+ozg0I2Ij
         TM/dw+4Hi00Halr5BCX1fN6pdc+oSSTmS91KQB2iEhYcRoamRGCPLwByCFrgzAV8PTt1
         BppQ==
X-Gm-Message-State: AOAM530ulcf+Db2rXVs0eL/H8fi1bbnyLmXJWIw1KZsJwu1W4R/relQs
        UVjXx6/lGaTkJKjwmQddl6XOpzRDMVlfwx8paVAartklSN/aiDShlTHuAsg8JexUttBhhJ+CMTn
        nEDR858+NnWID
X-Received: by 2002:a05:6402:2052:: with SMTP id bc18mr20361202edb.63.1643637039000;
        Mon, 31 Jan 2022 05:50:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzEoYSZD7hVDKUy0PlYZAYtWmIvRK6Hyrt/GJgtOdB8gsOfLvbKUL5KQ8tX2us37oY4/IpfNA==
X-Received: by 2002:a05:6402:2052:: with SMTP id bc18mr20361192edb.63.1643637038838;
        Mon, 31 Jan 2022 05:50:38 -0800 (PST)
Received: from ?IPV6:2003:cb:c709:b200:f007:5a26:32e7:8ef5? (p200300cbc709b200f0075a2632e78ef5.dip0.t-ipconnect.de. [2003:cb:c709:b200:f007:5a26:32e7:8ef5])
        by smtp.gmail.com with ESMTPSA id h6sm13394468ejx.164.2022.01.31.05.50.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 05:50:38 -0800 (PST)
Message-ID: <defe074e-0215-cb9a-39e7-cc4dcbf75785@redhat.com>
Date:   Mon, 31 Jan 2022 14:50:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [kvm-unit-tests PATCH v1 1/5] lib: s390x: smp: add functions to
 work with CPU indexes
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, seiden@linux.ibm.com
References: <20220128185449.64936-1-imbrenda@linux.ibm.com>
 <20220128185449.64936-2-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220128185449.64936-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28.01.22 19:54, Claudio Imbrenda wrote:
> Knowing the number of active CPUs is not enough to know which ones are
> active. This patch adds 2 new functions:
> 
> * smp_cpu_addr_from_idx to get the CPU address from the index
> * smp_cpu_from_idx allows to retrieve the struct cpu from the index
> 
> This makes it possible for tests to avoid hardcoding the CPU addresses.
> It is useful in cases where the address and the index might not match.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/smp.h |  2 ++
>  lib/s390x/smp.c | 12 ++++++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
> index a2609f11..69aa4003 100644
> --- a/lib/s390x/smp.h
> +++ b/lib/s390x/smp.h
> @@ -37,6 +37,7 @@ struct cpu_status {
>  
>  int smp_query_num_cpus(void);
>  struct cpu *smp_cpu_from_addr(uint16_t addr);
> +struct cpu *smp_cpu_from_idx(uint16_t addr);

s/addr/idx/


-- 
Thanks,

David / dhildenb

