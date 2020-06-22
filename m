Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC7F203E61
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 19:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730195AbgFVRuk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 13:50:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52889 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729992AbgFVRuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 13:50:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592848237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lgwNAJWwYoE/4bIWpNCf54Q99GS0qz3OjZWTJofTHOM=;
        b=bJFNsHNKKg9yI/7+DYFaWSTQTADd5shcf0ZYEDcOSZZ0E9ybQIp1gkYhzJPuKPrXY88DZe
        yVLWv8s/lsX6aMAMIBugLlKpEtkBuk31nArw9EnbFQOtJ87MCYbgSBzQvA2GzN1lawFs3Q
        7NqI/9VYWYLFD5VIHLk3+h/NlYnFPvI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-FTw7Yp5XOLuGIuxgGVyRfQ-1; Mon, 22 Jun 2020 13:50:35 -0400
X-MC-Unique: FTw7Yp5XOLuGIuxgGVyRfQ-1
Received: by mail-wr1-f71.google.com with SMTP id o12so9377168wrj.23
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 10:50:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lgwNAJWwYoE/4bIWpNCf54Q99GS0qz3OjZWTJofTHOM=;
        b=WDB/mvzT5VOKRSKsRMc1ymswEAeVSZZcU5SKm8J2Bz3OtUlh5w8Fxw+o7rOyeA+54+
         bEONsX+PE8JpJU+KTe0G7kczx6Swo2l9kXl+KFvGGMx2M3vBkSMRtmNf9DElGNWjy752
         tQEBX8jc3SjWLtNa5BW67PZZWSMR5oOtWP29Q+UVfKEoUuSJmV85H+xdrUOP0Ha90b3X
         nQmeewV8hnycUSaCNzvDQk+JxCxcnAP95j25dNkgetOkvRbXN0iwhpHSmPlfz/6sR+UT
         KD2oi/NZo9OXno4Jx8zdHbYpabHxlrleTPiQZan28f+dBXi/Ns4HFPGpIU/eOhKeWojh
         QMsw==
X-Gm-Message-State: AOAM530RsylbN9N4a0vONDxHjfpJZLohUIh4Rf7Rp5fmpWeKXdLDbWg5
        DyYAk4dUIMz3mhaaO2MmkNeB/HxshqsdfCnRe43IJQpe+4RP4JHk/elgJ4zfXRNAqvj+2I1HCQy
        8vnDvioHiRjcf
X-Received: by 2002:a1c:f707:: with SMTP id v7mr10572891wmh.2.1592848234319;
        Mon, 22 Jun 2020 10:50:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrzpOz7bvgeQ0Og7my2hgJS5V1XAFZzkku1AWlvmHALKxWh4EKLhxdM3dvSWlfPv2jcJQu+A==
X-Received: by 2002:a1c:f707:: with SMTP id v7mr10572875wmh.2.1592848234050;
        Mon, 22 Jun 2020 10:50:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:fd64:dd90:5ad5:d2e1? ([2001:b07:6468:f312:fd64:dd90:5ad5:d2e1])
        by smtp.gmail.com with ESMTPSA id d28sm20395668wrc.50.2020.06.22.10.50.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 10:50:33 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v1 0/8] Minor fixes, improvements, and
 cleanup
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com
References: <20200622162141.279716-1-imbrenda@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d64aa7d3-c4a5-193b-a488-07251be34d62@redhat.com>
Date:   Mon, 22 Jun 2020 19:50:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200622162141.279716-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/20 18:21, Claudio Imbrenda wrote:
> This patch series provides a bunch of small improvements, fixes and
> cleanups.
> Some of these fixes are needed for an upcoming series that will
> significantly refactor and improve the memory allocators.
> 
> Claudio Imbrenda (8):
>   x86/cstart.S: initialize stack before using it
>   x86: add missing PAGE_ALIGN macro from page.h
>   lib: use PAGE_ALIGN
>   lib/alloc.c: add overflow check for calloc
>   lib: Fix a typo and add documentation comments
>   lib/vmalloc: fix potential race and non-standard pointer arithmetic
>   lib/alloc_page: make get_order return unsigned int
>   lib/vmalloc: add locking and a check for initialization
> 
>  lib/x86/asm/page.h |  2 ++
>  lib/alloc_page.h   |  2 +-
>  lib/alloc_phys.h   |  2 +-
>  lib/vmalloc.h      |  8 ++++++++
>  lib/alloc.c        | 36 +++++++++++++++++++++++++++++++++++-
>  lib/alloc_page.c   |  2 +-
>  lib/vmalloc.c      | 34 +++++++++++++++++++++++-----------
>  x86/cstart.S       |  2 +-
>  8 files changed, 72 insertions(+), 16 deletions(-)
> 

Queued, thanks.

Paolo

