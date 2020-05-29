Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD321E7923
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 11:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgE2JQX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 05:16:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59194 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726411AbgE2JQW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 05:16:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590743780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=Zl7ylGEHGJpPdoCTpkeGkwtQ16SJnH7ZIfyt/iYUhB4=;
        b=HW4Xmfjmt60vFf2MjjhXNBcXAo4vTPrUd5qyKD6+OlrRSxtLGryVQ6ms0WKduDPv99z3GQ
        lWo9FV9brLh8G4FR/bzpxePRA78V506zfUjRpFHnWW38ovp8R1+6aa/vwbyGf1duOYA+9Y
        n93ga1vBWeg/43U7ruE0rVu39pLVxww=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-cqAyTv5-O3inh9lQKwPMbg-1; Fri, 29 May 2020 05:16:18 -0400
X-MC-Unique: cqAyTv5-O3inh9lQKwPMbg-1
Received: by mail-wr1-f69.google.com with SMTP id y7so787585wrd.12
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 02:16:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Zl7ylGEHGJpPdoCTpkeGkwtQ16SJnH7ZIfyt/iYUhB4=;
        b=GRYo2fiCv124f/cUj9po6pvcbDB+KX5tH9DTuAZhbWtNy6p4K+OvYtkip+85+XaCGb
         oWK47Nf/inqtReF37ZQ8lmjd1ypf+DnvVJV3R+Iprlt7OjzRzffNDXFMtk27oID7n6rU
         j0uRZ/f5LG37IFfrem0RWVf7Ew4cwOtJK13PZh+001l6WtbzCRRzS72Qy6J6rkDa+R51
         TG/hOB/GnqBWswwmSjMLJVekTJ/pA+Xmb+AAcaz3wCiDVEYormGRtTre80m1UPwgy2+r
         aXd6KjeKjyqRNZ/eY5d71SeLnxfgSh/xBHvptCsguZNPlXAd1RcDLa3w7VjW4p4L4h0f
         FhAg==
X-Gm-Message-State: AOAM5327BtfpRWL22wsr/CgEPy/L1fP9cfzvVqpS5hpkSYx7GnHr8Lpa
        olJ+WwxCbmzIYnaHIfjWKArvfe42wjWWLc7wmWvDBdXnf9k1nky2g4TOrOaqQtxariicLq8gYRE
        4xvRAHPEd+A/Y
X-Received: by 2002:a1c:658a:: with SMTP id z132mr7444161wmb.20.1590743777163;
        Fri, 29 May 2020 02:16:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9w7FIhyxCBovRw0iYmyxT9IzKaR8QS4FOr6QWOageAxBoXA/I4KsyEwstnvIjl+gu/pQgpw==
X-Received: by 2002:a1c:658a:: with SMTP id z132mr7444151wmb.20.1590743777015;
        Fri, 29 May 2020 02:16:17 -0700 (PDT)
Received: from [192.168.1.34] (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id z6sm8972660wrh.79.2020.05.29.02.16.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 02:16:16 -0700 (PDT)
Subject: Re: [RFC v2 16/18] guest memory protection: Add Error ** to
 GuestMemoryProtection::kvm_init
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-17-david@gibson.dropbear.id.au>
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
Message-ID: <6e52c2fe-ffb5-aa0e-d552-4fd922dc7c66@redhat.com>
Date:   Fri, 29 May 2020 11:16:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200521034304.340040-17-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/21/20 5:43 AM, David Gibson wrote:
> This allows failures to be reported richly and idiomatically.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  accel/kvm/kvm-all.c                    |  4 +++-
>  include/exec/guest-memory-protection.h |  2 +-
>  target/i386/sev.c                      | 31 +++++++++++++-------------
>  3 files changed, 19 insertions(+), 18 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

