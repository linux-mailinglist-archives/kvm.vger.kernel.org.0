Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CB61E7900
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 11:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgE2JFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 05:05:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25745 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725971AbgE2JFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 05:05:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590743122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=24UnZud1dS9MlmJH790ihCYOiVC6o2UeJxwgc3IzbaU=;
        b=Goccg8wCS2zNfIi9bzUR93GXkpCwf5fHQPOqXuRp3kpDhU6mxScru5EZEBFB+seoIEn28m
        +pS+3lJEj3huBKIbubum0zkZBRz0E9cIpJ38F4iNgikrdZcHhYprxIneT3jDxV746TKGID
        ARfvoN9dHkPfbP4Lji53tkosa2MBQwg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-bB1mT3c5MBiGQFDLupHkgA-1; Fri, 29 May 2020 05:05:20 -0400
X-MC-Unique: bB1mT3c5MBiGQFDLupHkgA-1
Received: by mail-wm1-f69.google.com with SMTP id u11so433563wmc.7
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 02:05:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=24UnZud1dS9MlmJH790ihCYOiVC6o2UeJxwgc3IzbaU=;
        b=sO6sLimCmViIZXKfR8cRhOzyvxtXi05IT4yjJ6IHYBJ8TaP2rL7dX+gw3CramCRH/i
         kGOI7Vb/Pd1NvNp7j7OclzoUEj7jWViAgQsgNEU8x5fmHnEJI7XMj/lFeRTZLmONI/UB
         wwpGOqKO4R5HrrSdThIaKEq8G0bjckvDehj3/uWb96Ot0px0YG5A6mulAF82n815x0GP
         9c8Myf17UYwSmKnA+2+aylq5HtrhOYzUMgWKvAj738J6yp3leFlVUKoxhPEPwyUPZgV8
         zzC4L4McItjKybxmS598HCzrGSiJ4Fd67UqcIl2y6kP9vPfhXWVTxVN0ytkV54XB1i2E
         mEcg==
X-Gm-Message-State: AOAM533OIFkQnywr98ZqF0L+AEUGUNRiBNRRkDXCWLaH8i4QzDuDRR4Z
        U5orAp2ab9Ip6PPC2bKxe+cxkcS/FZCTLI/5PzQWuqHPhCgWbPZNcbIyFk9hB52oBfNl18vuZSV
        4ExLuFbk0ItBo
X-Received: by 2002:a05:600c:2256:: with SMTP id a22mr7368926wmm.18.1590743118745;
        Fri, 29 May 2020 02:05:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/9MCcpOwVWZqjJ374KFfRtwh7OtaAxvN47bAxtR3NW2kIykKHyL+5ppqNmSWlEn8VEbxQxA==
X-Received: by 2002:a05:600c:2256:: with SMTP id a22mr7368916wmm.18.1590743118595;
        Fri, 29 May 2020 02:05:18 -0700 (PDT)
Received: from [192.168.1.34] (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id 5sm9739133wmd.19.2020.05.29.02.05.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 02:05:18 -0700 (PDT)
Subject: Re: [RFC v2 03/18] target/i386: sev: Rename QSevGuestInfo
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-4-david@gibson.dropbear.id.au>
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
Message-ID: <7d230494-5f85-bc9a-739a-08eef2ec3a0a@redhat.com>
Date:   Fri, 29 May 2020 11:05:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200521034304.340040-4-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/21/20 5:42 AM, David Gibson wrote:
> At the moment this is a purely passive object which is just a container for
> information used elsewhere, hence the name.  I'm going to change that
> though, so as a preliminary rename it to SevGuestState.
> 
> That name risks confusion with both SEVState and SevState, but I'll be
> working on that in following patches.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  target/i386/sev.c | 87 ++++++++++++++++++++++++-----------------------
>  1 file changed, 44 insertions(+), 43 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

