Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3A4435247
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 20:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhJTSDt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 14:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbhJTSDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 14:03:46 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1065C06161C
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 11:01:31 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id m21so23173975pgu.13
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 11:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fIOWvvheP/foSUqutVRe3v80PqQQZrCS1Qz2l94o6DY=;
        b=DF0ITmidyypP/1vFAYw58HJ7juNe6ByTa05aBQzhbVBF3wjrgbJufReIpJaE5DaeU+
         sSnSb9ab7k/L6mirv5iZI+3dYqaO6jnrzAb8Zr8KwGzuTiBNdd7RakdsnMNUNKGHkMlR
         j/TKThhDTZE5N9jOJsDItUDnT8Td5jy9ygLHd0bZzYfaGOKQUt0t5O7Alue6wPpxIp7f
         osEfl3xBlLFpnZHTcJ3OQGyBX1oSZMmu1JMbEDGlaXPcdB2+M6BUVMLRjQRiZP0FVBMG
         PFl2dH3/tzOfbErFHmV3O7ZcMO8hyK+67uUFUFyHNhOGOJxMulG0YYMP7TZz5eeIN+zJ
         9uew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fIOWvvheP/foSUqutVRe3v80PqQQZrCS1Qz2l94o6DY=;
        b=Q8AQfojn8/3qtIXHyE3yaLUxYLJenkUpgMf9TY8KIjTVJZA4e4Lh/mldXbhQ53gQSf
         CJMi84iEQ4NFlAuV1A3scZco5bqBnJbLmcBK6mYvowBqEU7nTF5Ft9Ap9r3FlYpzcc5Z
         3vaHOz283xbkpz9xXo3MVWXq4oOC9fNGR8TPMZygkoTzxLe/OekQObWbpvLjjsXkmVow
         gGDO9KhWEcHDRcHQpsmqcGlncbBNqxYnKsTf8E0v5ld2U/jUwfJzy++fPJ3F9/q0DpOW
         HBKGyfRcwo0RaNeVyh3VxTZyLQVMMd77hGKW2Mn/NDybPJoZ9wrFtAgDFx+4p45OJjvK
         3tFw==
X-Gm-Message-State: AOAM532ZM1I+YUHuphiTFej1bAFk41FUekvp72YPKakz6S9s0VezJNI4
        oLa8Oy1qhXFnPMQhJQnm5QrSdmSBccTNhA==
X-Google-Smtp-Source: ABdhPJy9ityxByz49mMnJdD7sPneMqKiAmnIK6wvAdMw6sq8mQOALH+wsjbwPf+zNciNz0XNQL9syQ==
X-Received: by 2002:a63:3548:: with SMTP id c69mr579181pga.111.1634752891140;
        Wed, 20 Oct 2021 11:01:31 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y4sm3681593pfa.90.2021.10.20.11.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 11:01:30 -0700 (PDT)
Date:   Wed, 20 Oct 2021 18:01:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, zxwang42@gmail.com, marcorr@google.com,
        jroedel@suse.de, varad.gautam@suse.com,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH kvm-unit-tests 2/2] replace tss_descr global with a
 function
Message-ID: <YXBZdoeeRqmqU76l@google.com>
References: <20211020165333.953978-1-pbonzini@redhat.com>
 <20211020165333.953978-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211020165333.953978-3-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Jim again

On Wed, Oct 20, 2021, Paolo Bonzini wrote:
> @@ -255,4 +255,16 @@ static inline void *get_idt_addr(idt_entry_t *entry)
>  	return (void *)addr;
>  }
>  
> +extern gdt_desc_entry_t *get_tss_descr(void);
> +
> +static inline unsigned long get_gdt_entry_base(gdt_desc_entry_t *entry)

Bad naming again, base4 doesn't exist for segment descriptors.  It's a bit
wordy, but maybe this?

static inline unsigned long get_system_desc_base(gdt_system_desc_entry_t *entry)

> +{
> +	unsigned long base;
> +	base = entry->base1 | ((u32)entry->base2 << 16) | ((u32)entry->base3 << 24);
> +#ifdef __x86_64__
> +	base |= (u64)entry->base4 << 32;
> +#endif
> +	return base;
> +}
> +
>  #endif
