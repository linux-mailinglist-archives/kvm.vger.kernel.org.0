Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC1B1735CD
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 12:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgB1LEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 06:04:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35081 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726700AbgB1LEo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 06:04:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582887883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4NwBb3gPzbNESjmzKghH4PmFNKF0sxtRmNOJkDLP0Wc=;
        b=N3Xeq0+hxmF0iTW5ebKMiY2MzAzEAxtXcEQ+vH4W4B9gbQ4uBFchhTL7qtfkEJrxKsR9j+
        A7Ydlf3Ol2fUWR78xkh3GZnOQAESpvojyiqQnLuiZ9mTwABXAWiVFd0k5TL1ilZ1RQs6/E
        0tXpuqkjp7SQPo3rbyvg7JfMwyVphZ0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-o1xB8kH7MAau7UGeBJQcgw-1; Fri, 28 Feb 2020 06:04:41 -0500
X-MC-Unique: o1xB8kH7MAau7UGeBJQcgw-1
Received: by mail-wm1-f69.google.com with SMTP id o24so571970wmh.0
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 03:04:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4NwBb3gPzbNESjmzKghH4PmFNKF0sxtRmNOJkDLP0Wc=;
        b=XOxKygzJov/JOvSNCqrzeZnQzGZKLpc0EP+IzKZg+Fhzkykv+/wMV+2TTaAp6K1g7z
         KZGvtb8J2vmf7kep+NxgUNr0WHVPyygg8O6OgTClndfY/0vV5/w3x9FtzDWvEDv6MXB+
         Irf8pMFHDvKVw0NJ1YZthWRzexcPLPol86vqlCdjmkSSP0naY8QcL9k1gkeXjus6EMx9
         wDEJp1BJUh0kmhImC+Q4zrWOgsoMCTL8OmKwRpl/jjbjiF4A1fPFhXi0fFW7aJIrTex+
         lnovxFfBylnOUXg1laRULFVUD7NMi9PVbV9JwDoMh24k8m2tTft+BhEqgRktamXfHJil
         TKNw==
X-Gm-Message-State: APjAAAXZjhzLV3vs702cjs4dGgEknNeFUD4YrU3olrxlK8CMCxfgrGyf
        HcX6o3ds+etXtmeIDqv5t+JO9OgjkLjJPy6J98M/ykIHFFqFKu38Ayklvqs19TJv4psM6FazCw/
        4vAJcAwl88z8Q
X-Received: by 2002:adf:fec4:: with SMTP id q4mr4370534wrs.368.1582887879989;
        Fri, 28 Feb 2020 03:04:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqwVsWh2PiOMxxwM+euEPtyzo53Dt/uhQoswVA42KNds53YV0JnWZ9TBe0eb34DP2jXY4z3J8A==
X-Received: by 2002:adf:fec4:: with SMTP id q4mr4370503wrs.368.1582887879709;
        Fri, 28 Feb 2020 03:04:39 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:d0d9:ea10:9775:f33f? ([2001:b07:6468:f312:d0d9:ea10:9775:f33f])
        by smtp.gmail.com with ESMTPSA id u185sm1813625wmg.6.2020.02.28.03.04.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 03:04:39 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 2/7] pci: use uint32_t for unsigned long
 values
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org
Cc:     oupton@google.com, drjones@redhat.com
References: <20200226074427.169684-1-morbo@google.com>
 <20200226094433.210968-1-morbo@google.com>
 <20200226094433.210968-4-morbo@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <91b0fdf5-a948-ef61-8b05-1c5757937521@redhat.com>
Date:   Fri, 28 Feb 2020 12:04:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200226094433.210968-4-morbo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/02/20 10:44, Bill Wendling wrote:
> The "pci_bar_*" functions use 64-bit masks, but the results are assigned
> to 32-bit variables. Use 32-bit masks, since we're interested only in
> the least significant 4-bits.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  lib/linux/pci_regs.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/linux/pci_regs.h b/lib/linux/pci_regs.h
> index 1becea8..3bc2b92 100644
> --- a/lib/linux/pci_regs.h
> +++ b/lib/linux/pci_regs.h
> @@ -96,8 +96,8 @@
>  #define  PCI_BASE_ADDRESS_MEM_TYPE_1M	0x02	/* Below 1M [obsolete] */
>  #define  PCI_BASE_ADDRESS_MEM_TYPE_64	0x04	/* 64 bit address */
>  #define  PCI_BASE_ADDRESS_MEM_PREFETCH	0x08	/* prefetchable? */
> -#define  PCI_BASE_ADDRESS_MEM_MASK	(~0x0fUL)
> -#define  PCI_BASE_ADDRESS_IO_MASK	(~0x03UL)
> +#define  PCI_BASE_ADDRESS_MEM_MASK	(~0x0fU)
> +#define  PCI_BASE_ADDRESS_IO_MASK	(~0x03U)
>  /* bit 1 is reserved if address_space = 1 */
>  
>  /* Header type 0 (normal devices) */
> 

Removing the "U" is even better because it will then sign-extend
automatically.

Paolo

