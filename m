Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1330F42C6A4
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 18:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbhJMQqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 12:46:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20166 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230216AbhJMQqM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 12:46:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634143449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j4IIg+iC2kFSzqeje9srAKgG1bZMm2bxB3b31Ksk9Zs=;
        b=ebm1ARhldmpHRt8Eewvs4JnlyOnEuf8zI7B6hDmZchcoErMFuHt2RxfMI5r8G6BvET1nbi
        DixQYgq330r8QTd15IjwuSKAnsKetsFPZL9P7RibvablpVic1MMoUdEXeuzPQ69vkgFwdw
        PeplknbHuKKOziXVoHkzHFb7K4WJYfc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-FlBJDxJFOTSjeAfw7IKYYQ-1; Wed, 13 Oct 2021 12:44:07 -0400
X-MC-Unique: FlBJDxJFOTSjeAfw7IKYYQ-1
Received: by mail-ed1-f69.google.com with SMTP id x5-20020a50f185000000b003db0f796903so2757762edl.18
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 09:44:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j4IIg+iC2kFSzqeje9srAKgG1bZMm2bxB3b31Ksk9Zs=;
        b=Ic5F02m6bldlaFp85Az62Xmx3cGd7m2pcMe6l9azSkNTHEConScSFVEuWMkmLtQdPn
         bj27KgZF6pN327YfzEGWMeW2r7qAlhqSo6cspCJ2OWJSf8lmRhiZ+ZYo5XZ7f0KTM0XQ
         OhwjhZRnx0BoNddrWTzPMNhswt6eta8p9Mx+92j0g7ZpQGxnc0LbWUJHBzLsb+5LgbII
         YmjgTtWAq0+7scO95fzKyhOvXp1zhMdvPYOYr+dFlCVcPs11ueDPMGR+PG20CIw9h/dZ
         2Jts/B5eff5tX1/1kHQEmxtY9wS3TLNFN7ifvfOkQtIMS8A16DWxkngImFrXgy030Sex
         6SsQ==
X-Gm-Message-State: AOAM530S6ywqelLj11/Jf8aG36AzKLlAcGKFVbyCZ9VUDA+mwCDHleCS
        BHPD5JKjtvNu4yxsIjlIk4I+0Rwj+gIi5ZE31uRJiDqkju/4RJDMRlFWSXQFVghuFeIK96AZcoO
        fFfSX0NOhrGP4
X-Received: by 2002:a05:6402:1296:: with SMTP id w22mr623428edv.390.1634143446616;
        Wed, 13 Oct 2021 09:44:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0UO0MdgebdD4c/liKR2jNzt2HwnrR66up5T8uzX5U3JU7IgbPC1jZcdNx3CWaLh1bCRrf6Q==
X-Received: by 2002:a05:6402:1296:: with SMTP id w22mr623403edv.390.1634143446403;
        Wed, 13 Oct 2021 09:44:06 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id k3sm87780ejk.7.2021.10.13.09.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 09:44:06 -0700 (PDT)
Date:   Wed, 13 Oct 2021 18:44:04 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     ahmeddan@amazon.com
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, nikos.nikoleris@arm.com,
        graf@amazon.com
Subject: Re: [kvm-unit-tests PATCH v2 1/3] lib/string: Add stroull and strtoll
Message-ID: <20211013164404.p67oye265bj5ucwm@gator.home>
References: <08d356da-17ce-d380-1fc9-18ba7ec67020@amazon.com>
 <20210927153028.27680-1-ahmeddan@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927153028.27680-1-ahmeddan@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 27, 2021 at 03:30:26PM +0000, ahmeddan@amazon.com wrote:
> From: Daniele Ahmed <ahmeddan@amazon.com>
> 
> Add the two functions strtoull and strtoll.
> This is in preparation for an update
> in x86/msr.c to write 64b values
> that are given as inputs as strings by
> a user.
> 
> Signed-off-by: Daniele Ahmed <ahmeddan@amazon.com>
> ---
>  lib/stdlib.h |  2 ++
>  lib/string.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 76 insertions(+)
> 
> diff --git a/lib/stdlib.h b/lib/stdlib.h
> index 33c00e8..48e10f0 100644
> --- a/lib/stdlib.h
> +++ b/lib/stdlib.h
> @@ -9,5 +9,7 @@
>  
>  long int strtol(const char *nptr, char **endptr, int base);
>  unsigned long int strtoul(const char *nptr, char **endptr, int base);
> +long long int strtoll(const char *nptr, char **endptr, int base);
> +unsigned long long strtoull(const char *nptr, char **endptr, int base);
>  
>  #endif /* _STDLIB_H_ */
> diff --git a/lib/string.c b/lib/string.c
> index ffc7c7e..dacd927 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -242,6 +242,80 @@ unsigned long int strtoul(const char *nptr, char **endptr, int base)
>      return __strtol(nptr, endptr, base, false);
>  }
>  
> +static unsigned long long __strtoll(const char *nptr, char **endptr,
> +                              int base, bool is_signed) {
> +    unsigned long long acc = 0;
> +    const char *s = nptr;
> +    int neg, c;
> +
> +    assert(base == 0 || (base >= 2 && base <= 36));
> +
> +    while (isspace(*s))
> +        s++;
> +
> +    if (*s == '-') {
> +        neg = 1;
> +        s++;
> +    } else {
> +        neg = 0;
> +        if (*s == '+')
> +            s++;
> +    }
> +
> +    if (base == 0 || base == 16) {
> +        if (*s == '0') {
> +            s++;
> +            if (*s == 'x' || *s == 'X') {
> +                 s++;
> +                 base = 16;
> +            } else if (base == 0)
> +                 base = 8;
> +        } else if (base == 0)
> +            base = 10;
> +    }
> +
> +    while (*s) {
> +        if (*s >= '0' && *s < '0' + base && *s <= '9')
> +            c = *s - '0';
> +        else if (*s >= 'a' && *s < 'a' + base - 10)
> +            c = *s - 'a' + 10;
> +        else if (*s >= 'A' && *s < 'A' + base - 10)
> +            c = *s - 'A' + 10;
> +        else
> +            break;
> +
> +        if (is_signed) {
> +            long long sacc = (long long)acc;
> +            assert(!check_mul_overflow(sacc, base));
> +            assert(!check_add_overflow(sacc * base, c));
> +        } else {
> +            assert(!check_mul_overflow(acc, base));
> +            assert(!check_add_overflow(acc * base, c));
> +        }
> +
> +        acc = acc * base + c;
> +        s++;
> +    }
> +
> +    if (neg)
> +        acc = -acc;
> +
> +    if (endptr)
> +        *endptr = (char *)s;
> +
> +    return acc;
> +}
> +
> +long long int strtoll(const char *nptr, char **endptr, int base)
> +{
> +    return __strtoll(nptr, endptr, base, true);
> +}
> +
> +unsigned long long int strtoull(const char *nptr, char **endptr, int base)
> +{
> +    return __strtoll(nptr, endptr, base, false);
> +}
> +
>  long atol(const char *ptr)
>  {
>      return strtol(ptr, NULL, 10);
> -- 
> 2.32.0
> 
>

Hi Daniele,

I just sent an alternative to this patch which doesn't requiring
duplicating as much code.

Thanks,
drew

 
> 
> 
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
> 
> 
> 

