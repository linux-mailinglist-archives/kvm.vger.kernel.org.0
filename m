Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42027263E16
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 09:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730316AbgIJHJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 03:09:38 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:26092 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730293AbgIJHHE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Sep 2020 03:07:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599721622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=rEbZ+IsVviGEL+xwewmo6vrAVeSIwVEEl/J4gj7wsM4=;
        b=GjfsQNhnD7U//YXBEpOFpVR8tAy3VT7XkeKCkrLyHiIYI5k6ExoCznRuQfvwpTdtOAM7Lk
        AToHoPntXj4mi9YC4BZnTWF0x0TvNAd9etARhTKpRbXyOjJyArEk1OkbP+HqwiJ+90JtnU
        ew4PPPy8H5qjIFtjJ2WPYc/hv+0u/3U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-S7bLtGHoMUSI18xYpkk9jw-1; Thu, 10 Sep 2020 03:07:01 -0400
X-MC-Unique: S7bLtGHoMUSI18xYpkk9jw-1
Received: by mail-wr1-f69.google.com with SMTP id k13so1887346wrw.16
        for <kvm@vger.kernel.org>; Thu, 10 Sep 2020 00:07:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=rEbZ+IsVviGEL+xwewmo6vrAVeSIwVEEl/J4gj7wsM4=;
        b=o+p/Nlyqdcee89jfV5wDSH8WJsgHo4YXl7LT5fa6fzmtAyjZz9jrJa0g9Mkeynj+Aj
         ATqNakh5UZ/LXFFNH7mR9dmRjvahUFUSm2b8SPPkBEe0xL+aOh3ZguVLrAWeSXzKLcq1
         hezFwO6obbGBX9Wdcd6f1mvbqHBOCfWv08yocHAoAF8i87UM+9Mogh4eoypfHqxwIar0
         roPKIeBXVJWrQcDvqORqS9fyy5enRzPKARYUtseEq6rjVLb9VhLk3pOpBDTUDphuId5i
         27O8NVWyPZWX3e51p5mDc9ncGVImRb6ly/RRTbBr+2GUIZXQNZyEeaSolibKL0DRoScg
         gO8A==
X-Gm-Message-State: AOAM530BEukK5GZbBH31kObDG21tVv7z44mcy226pQxxb1OfLmerDpuG
        KQV+K1Cu1PF+V8cwB6PKVCerWKGeMQUt6LE7t4/2L62Y25BtciXtKQj7ow0/G2PJUH6XmNr73LU
        M/fAyAayXG1n9
X-Received: by 2002:a1c:b407:: with SMTP id d7mr7418139wmf.59.1599721619819;
        Thu, 10 Sep 2020 00:06:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSYSt1/M42o2jGa+vN9HVlGiF1SarqJoe06oBnWlq55JaHohx62MXvEAqZdruDohRobHiy5A==
X-Received: by 2002:a1c:b407:: with SMTP id d7mr7418114wmf.59.1599721619652;
        Thu, 10 Sep 2020 00:06:59 -0700 (PDT)
Received: from [192.168.1.36] (65.red-83-57-170.dynamicip.rima-tde.net. [83.57.170.65])
        by smtp.gmail.com with ESMTPSA id 11sm2229961wmi.14.2020.09.10.00.06.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 00:06:59 -0700 (PDT)
Subject: Re: [PATCH 2/6] hw/core/stream: Rename StreamSlave as StreamSink
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jason Wang <jasowang@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        qemu-trivial@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Joel Stanley <joel@jms.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20200910070131.435543-1-philmd@redhat.com>
 <20200910070131.435543-3-philmd@redhat.com>
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
Message-ID: <4eabb327-a03b-747b-eadc-54e1c7b29d81@redhat.com>
Date:   Thu, 10 Sep 2020 09:06:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200910070131.435543-3-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/10/20 9:01 AM, Philippe Mathieu-Daudé wrote:
> In order to use inclusive terminology, rename 'slave stream'
> as 'sink stream'.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
[...]
> diff --git a/include/hw/stream.h b/include/hw/stream.h
> index ed09e83683d..8ca161991ca 100644
> --- a/include/hw/stream.h
> +++ b/include/hw/stream.h
> @@ -3,52 +3,52 @@
>  
>  #include "qom/object.h"
>  
> -/* stream slave. Used until qdev provides a generic way.  */
> -#define TYPE_STREAM_SLAVE "stream-slave"
> +/* stream sink. Used until qdev provides a generic way.  */
> +#define TYPE_STREAM_SINK "stream-slave"
>  
> -#define STREAM_SLAVE_CLASS(klass) \
> -     OBJECT_CLASS_CHECK(StreamSlaveClass, (klass), TYPE_STREAM_SLAVE)
> -#define STREAM_SLAVE_GET_CLASS(obj) \
> -    OBJECT_GET_CLASS(StreamSlaveClass, (obj), TYPE_STREAM_SLAVE)
> -#define STREAM_SLAVE(obj) \
> -     INTERFACE_CHECK(StreamSlave, (obj), TYPE_STREAM_SLAVE)
> +#define STREAM_SINK_CLASS(klass) \
> +     OBJECT_CLASS_CHECK(StreamSinkClass, (klass), TYPE_STREAM_SINK)
> +#define STREAM_SINK_GET_CLASS(obj) \
> +    OBJECT_GET_CLASS(StreamSinkClass, (obj), TYPE_STREAM_SINK)
> +#define STREAM_SINK(obj) \
> +     INTERFACE_CHECK(StreamSink, (obj), TYPE_STREAM_SINK)

Hmm being an interface, is it better to name it TYPE_SINK_STREAM?

