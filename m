Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B451E790E
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 11:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgE2JLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 05:11:41 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38649 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725710AbgE2JLk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 05:11:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590743499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=ZmladyTmooEwtW8t8Idh/cXKSlbG8JN1qRhfd3e4VjQ=;
        b=IdJJw1uirXFll33PDqx17G2JxmDwIB4gxrahAVX7lAQ4AlLzRdZIP+7ZhL4Y8vVsrIJT5o
        z6QpqhFvDjDT5dFZAQBR+325asQ6pZXGMJhR1kFS0lEs69xjEHF+datA0uaANZXgbuTVsz
        gQ1iUP8kROk9IDm8RVaagSMEcq01bo0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-7a11FN4JOVag8HoVPN44Tg-1; Fri, 29 May 2020 05:11:37 -0400
X-MC-Unique: 7a11FN4JOVag8HoVPN44Tg-1
Received: by mail-wm1-f72.google.com with SMTP id k185so542663wme.8
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 02:11:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ZmladyTmooEwtW8t8Idh/cXKSlbG8JN1qRhfd3e4VjQ=;
        b=ZZyqYjw1KILv6DZ4E8xg6WLFt5cetuPuvb6yHXb3lZBiZn2MZbwiWBPgmEkr2FM1Ry
         DNpLmPx4NzBGw4Y098Sq1QJUp73nFKRjZtxdLS86Cn5l4nuZL2WgVrGmJtjx6mI/HxZW
         9+q4ha8aUF/IAsfNDFw6aOMg7SP4p2NNOZ1K6zeZu8ccpy67FKzk9woYNVLVf1MJiSWB
         REKZ9t1iaPG5t9Q4VOXEWJqklTuFv+V6DChbJ60hH3uL29bMYYgnwoCMl6Xt68K+hyww
         cGpw2KRmKJpRo4Ocfk8UoSwp6YdhaIPO6RMzycf84WHavZgjoFOPGsy06OaN1Do4znvE
         B2PQ==
X-Gm-Message-State: AOAM532DGCGpfyFt/gP6HRvyS6TfCCJGcXvx5REL3RDWUtEbEDn3+q0V
        /pDx+T98xu7607KlixXWcHBKQXySQhsriXQDFX4I8wfeYhDe9FqJTlWPjrAJrPyv/amNzaakiHr
        jaHh+CpDSui5m
X-Received: by 2002:a1c:6606:: with SMTP id a6mr7202255wmc.37.1590743496381;
        Fri, 29 May 2020 02:11:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyUsBBgQVLd416S+QKQrLChguP9FU4Shy/gp+IMLIfAeig10SQGLJJWs3mmfD5c7J93VI/mGw==
X-Received: by 2002:a1c:6606:: with SMTP id a6mr7202224wmc.37.1590743496103;
        Fri, 29 May 2020 02:11:36 -0700 (PDT)
Received: from [192.168.1.34] (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id s72sm5953427wme.35.2020.05.29.02.11.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 02:11:35 -0700 (PDT)
Subject: Re: [RFC v2 06/18] target/i386: sev: Remove redundant cbitpos and
 reduced_phys_bits fields
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-7-david@gibson.dropbear.id.au>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Autocrypt: addr=philmd@redhat.com; keydata=
 mQINBDXML8YBEADXCtUkDBKQvNsQA7sDpw6YLE/1tKHwm24A1au9Hfy/OFmkpzo+MD+dYc+7
 bvnqWAeGweq2SDq8zbzFZ1gJBd6+e5v1a/UrTxvwBk51yEkadrpRbi+r2bDpTJwXc/uEtYAB
 GvsTZMtiQVA4kRID1KCdgLa3zztPLCj5H1VZhqZsiGvXa/nMIlhvacRXdbgllPPJ72cLUkXf
 z1Zu4AkEKpccZaJspmLWGSzGu6UTZ7UfVeR2Hcc2KI9oZB1qthmZ1+PZyGZ/Dy+z+zklC0xl
 XIpQPmnfy9+/1hj1LzJ+pe3HzEodtlVA+rdttSvA6nmHKIt8Ul6b/h1DFTmUT1lN1WbAGxmg
 CH1O26cz5nTrzdjoqC/b8PpZiT0kO5MKKgiu5S4PRIxW2+RA4H9nq7nztNZ1Y39bDpzwE5Sp
 bDHzd5owmLxMLZAINtCtQuRbSOcMjZlg4zohA9TQP9krGIk+qTR+H4CV22sWldSkVtsoTaA2
 qNeSJhfHQY0TyQvFbqRsSNIe2gTDzzEQ8itsmdHHE/yzhcCVvlUzXhAT6pIN0OT+cdsTTfif
 MIcDboys92auTuJ7U+4jWF1+WUaJ8gDL69ThAsu7mGDBbm80P3vvUZ4fQM14NkxOnuGRrJxO
 qjWNJ2ZUxgyHAh5TCxMLKWZoL5hpnvx3dF3Ti9HW2dsUUWICSQARAQABtDJQaGlsaXBwZSBN
 YXRoaWV1LURhdWTDqSAoUGhpbCkgPHBoaWxtZEByZWRoYXQuY29tPokCVQQTAQgAPwIbDwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4AWIQSJweePYB7obIZ0lcuio/1u3q3A3gUCXsfWwAUJ
 KtymWgAKCRCio/1u3q3A3ircD/9Vjh3aFNJ3uF3hddeoFg1H038wZr/xi8/rX27M1Vj2j9VH
 0B8Olp4KUQw/hyO6kUxqkoojmzRpmzvlpZ0cUiZJo2bQIWnvScyHxFCv33kHe+YEIqoJlaQc
 JfKYlbCoubz+02E2A6bFD9+BvCY0LBbEj5POwyKGiDMjHKCGuzSuDRbCn0Mz4kCa7nFMF5Jv
 piC+JemRdiBd6102ThqgIsyGEBXuf1sy0QIVyXgaqr9O2b/0VoXpQId7yY7OJuYYxs7kQoXI
 6WzSMpmuXGkmfxOgbc/L6YbzB0JOriX0iRClxu4dEUg8Bs2pNnr6huY2Ft+qb41RzCJvvMyu
 gS32LfN0bTZ6Qm2A8ayMtUQgnwZDSO23OKgQWZVglGliY3ezHZ6lVwC24Vjkmq/2yBSLakZE
 6DZUjZzCW1nvtRK05ebyK6tofRsx8xB8pL/kcBb9nCuh70aLR+5cmE41X4O+MVJbwfP5s/RW
 9BFSL3qgXuXso/3XuWTQjJJGgKhB6xXjMmb1J4q/h5IuVV4juv1Fem9sfmyrh+Wi5V1IzKI7
 RPJ3KVb937eBgSENk53P0gUorwzUcO+ASEo3Z1cBKkJSPigDbeEjVfXQMzNt0oDRzpQqH2vp
 apo2jHnidWt8BsckuWZpxcZ9+/9obQ55DyVQHGiTN39hkETy3Emdnz1JVHTU0Q==
Message-ID: <4c045f9e-9506-b33c-3fc6-0ed9ce118569@redhat.com>
Date:   Fri, 29 May 2020 11:11:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200521034304.340040-7-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/21/20 5:42 AM, David Gibson wrote:
> The SEVState structure has cbitpos and reduced_phys_bits fields which are
> simply copied from the SevGuestState structure and never changed.  Now that
> SEVState is embedded in SevGuestState we can just access the original copy
> directly.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  target/i386/sev.c | 19 +++++++------------
>  1 file changed, 7 insertions(+), 12 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

