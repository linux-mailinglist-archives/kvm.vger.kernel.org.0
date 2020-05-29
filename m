Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F541E7919
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 11:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgE2JOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 05:14:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25661 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726039AbgE2JOD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 05:14:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590743642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=1yAA2Gblxac6R7HJKEYC4MTAq2ctCRtB+zh8G6toK/8=;
        b=hzzQZA9lA8e9lMKnvVWls9QtIX5sDcO2AyiGJUQuvp7IRxzGEQAJgb8UqZA2iIggmz6IPQ
        yOC+394JVYjB+GvQtJKnQ8tIr/RZ8X8ygSAn7sTkd+ZbbJgW054ZH+aNpWkN85sfi910Fa
        hKLkuxRAJImno5G+rw66X50TYzVZKsQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-YMTdmiyhOAe9JzG97GBHQQ-1; Fri, 29 May 2020 05:13:58 -0400
X-MC-Unique: YMTdmiyhOAe9JzG97GBHQQ-1
Received: by mail-wr1-f72.google.com with SMTP id z10so803813wrs.2
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 02:13:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=1yAA2Gblxac6R7HJKEYC4MTAq2ctCRtB+zh8G6toK/8=;
        b=h2/6bemGj9u9b9YhXKbUk062fm8xGU4KUE6w7AzVvyhl1uGvB+8ea3hNf46d1MxOwk
         diXG6iCUHfmJm47H/oZzLT3JzPPtE4ki1WzVILbTUM9Rh/2oXKJHwZAtSrmBVJis1M6B
         CGx39CtPvxFNwp0fZZ5VQmKuG8PSkfUaJRnC+fe+jvzdJt6pE9TJ3spGmVjjs601dg45
         pwU2esoKrx84ty/zOpBoyo+An/kUS956yojm2nGR8Lad6g/amw/vvjCqp6px0V/zMXpu
         odi2tOh/0OS6rvEJyix/LBGlx2Jc/G87WAS601FFKgmAXic06iPi+Pg9V8lj1Ah7o4iL
         ckkA==
X-Gm-Message-State: AOAM530N4zfr4lNyStvFiuR4aCB6nLzBKF6E/34zAOPGQJEsxSeovsiU
        cMiNvOWyqIIJLBrzq8K5kBVyYgjIXNzPDM7TYl5PUw2MokCSv9BWvIixgNRMHg115kH7stv56rc
        JTNqhl+MwDT6J
X-Received: by 2002:a1c:1f90:: with SMTP id f138mr7811549wmf.33.1590743637186;
        Fri, 29 May 2020 02:13:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHx2Omz06oUefIrOCtnguOtjvxokNWVoZNXnSnaEHHSVvDJ1NdxRYimFHTthFDoB/H1fDN7A==
X-Received: by 2002:a1c:1f90:: with SMTP id f138mr7811495wmf.33.1590743636672;
        Fri, 29 May 2020 02:13:56 -0700 (PDT)
Received: from [192.168.1.34] (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id s19sm9353130wmj.21.2020.05.29.02.13.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 02:13:56 -0700 (PDT)
Subject: Re: [RFC v2 09/18] target/i386: sev: Unify SEVState and SevGuestState
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-10-david@gibson.dropbear.id.au>
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
Message-ID: <1a066443-a8f4-417a-9561-9a8a5e52ecce@redhat.com>
Date:   Fri, 29 May 2020 11:13:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200521034304.340040-10-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/21/20 5:42 AM, David Gibson wrote:
> SEVState is contained with SevGuestState.  We've now fixed redundancies
> and name conflicts, so there's no real point to the nested structure.  Just
> move all the fields of SEVState into SevGuestState.
> 
> This eliminates the SEVState structure, which as a bonus removes the
> confusion with the SevState enum.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  target/i386/sev.c | 79 ++++++++++++++++++++---------------------------
>  1 file changed, 34 insertions(+), 45 deletions(-)
[...]
>      sev_guest = sev;
> -    s = &sev->state;
> -    s->state = SEV_STATE_UNINIT;
> +    sev->state = SEV_STATE_UNINIT;

:)

Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

