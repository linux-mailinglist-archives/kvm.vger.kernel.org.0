Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DAC436C07
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 22:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhJUU0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 16:26:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46684 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231503AbhJUU0o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 16:26:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634847868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WqR1AyPl1u8ioxeffQRkkXLn9UXo2BEAxySenrVz0ac=;
        b=S1CYpgpqQj0uydmga6r2cnkXWu0UXUyotbg+VDVVpS7KQzhGUHPbWwUNY86B3PgwBVtmyO
        DzpPRYZvrig0VTHObxCtkmKDxlKP5IMZyJwG+v1riuLQbGJj3StfM7kxXTx/ntK7QptigS
        2mqnaVQ6A0lD9VQkrJZT5NnmTfmT49k=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-dKh6yFknMM-4CEkg1dMJNg-1; Thu, 21 Oct 2021 16:24:26 -0400
X-MC-Unique: dKh6yFknMM-4CEkg1dMJNg-1
Received: by mail-ed1-f72.google.com with SMTP id r25-20020a05640216d900b003dca3501ab4so1524344edx.15
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 13:24:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WqR1AyPl1u8ioxeffQRkkXLn9UXo2BEAxySenrVz0ac=;
        b=toQdiF/OditN4/VNJByT7rvQdFjsoAKH+q5qzO34YdYzIIJqNxrT2u9duvTByRvE3b
         30ApVeAmMPcYSyITRpQcaVQt9+WWI5B5Br7QFplgUJnJDjF0IBZJk8vEaExt4KDUB19F
         0F/wRKT34zqDzqLoA4yCGmHzrTpXRvGTWzhLJ98X+0+pRCSFkq0W+EgLpz8NYl5yFE8X
         lkBQ7dNDKGd1tBdRC/yPwt0PZIquyXWkHqfBJYsJ3FXsm5rXiITyMSKFVEKWx2767tL9
         nL1NlIs9RmyAuaKVetm0aYM/wxMMokYFSqZ2OmQNXpCkedviZZs7z5v+6IYsm5kjq8gU
         cssg==
X-Gm-Message-State: AOAM532sbQ3ilL67WIvce1VhORH0Mblj5abmxk5vPG/6Hb6UDmzKh93c
        kX3B2swD8RenGRiCGrzGzQKD6L9hIXArmGiZUNrDDCOzwKJ2fHtgcjeuDWxLrk40Y7mX7nAzjPy
        /nB8nKPclwQxw
X-Received: by 2002:a05:6402:40c2:: with SMTP id z2mr10959871edb.41.1634847864762;
        Thu, 21 Oct 2021 13:24:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRdRnvXqevWS/EA1VgTwQ4HpbeflIMgHgEoGaDJRQDUtRiiBSKyM8FUyvNVPIF3tcazyG+Sg==
X-Received: by 2002:a05:6402:40c2:: with SMTP id z2mr10959846edb.41.1634847864542;
        Thu, 21 Oct 2021 13:24:24 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id kd8sm2960904ejc.69.2021.10.21.13.24.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 13:24:23 -0700 (PDT)
Message-ID: <d938f3d1-4399-32c3-85b1-119b04c5e5c5@redhat.com>
Date:   Thu, 21 Oct 2021 22:24:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: selftests: Fix nested SVM tests when built with
 clang
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Ricardo Koller <ricarkol@google.com>
References: <20210930003649.4026553-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210930003649.4026553-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/09/21 02:36, Jim Mattson wrote:
> Though gcc conveniently compiles a simple memset to "rep stos," clang
> prefers to call the libc version of memset. If a test is dynamically
> linked, the libc memset isn't available in L1 (nor is the PLT or the
> GOT, for that matter). Even if the test is statically linked, the libc
> memset may choose to use some CPU features, like AVX, which may not be
> enabled in L1. Note that __builtin_memset doesn't solve the problem,
> because (a) the compiler is free to call memset anyway, and (b)
> __builtin_memset may also choose to use features like AVX, which may
> not be available in L1.
> 
> To avoid a myriad of problems, use an explicit "rep stos" to clear the
> VMCB in generic_svm_setup(), which is called both from L0 and L1.

Queued, thanks.  It would be nice if llvm at least had gcc's 
-minline-all-stringops and/or -mstringop-strategy=rep_byte, but even on 
gcc it wasn't really sure to work without those options.

Paolo

