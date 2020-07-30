Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E55233463
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 16:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbgG3O3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 10:29:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41561 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726275AbgG3O3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 10:29:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596119349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=ON1OtNmWc+sWirLzhHcY0wMbAE33llek/hkyMukuUBI=;
        b=G7s11llMYP63/BIQPCPzBb643P3M5x/dJW8gdnfEWYTQ1bGg70crpcGoZPBiMt3QgDWYHy
        PUFa1Y2mhU+ZZP7GOsDpoVuo3kJ9DiUUA7ZQ8/YMb1X+UHmSbiRU92CPBsvJK1HZPQTRxM
        6/HiXWrQSXCN81zezdWN4mTUbMgP+ws=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-ho1GYLvxMfuUc7QNv9pOWw-1; Thu, 30 Jul 2020 10:29:07 -0400
X-MC-Unique: ho1GYLvxMfuUc7QNv9pOWw-1
Received: by mail-wr1-f71.google.com with SMTP id b13so5256306wrq.19
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 07:29:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ON1OtNmWc+sWirLzhHcY0wMbAE33llek/hkyMukuUBI=;
        b=Dm5nK8PQFmV+94ks6JTgnV1OrhZYxUVvFMUCyjTnptO0JnyrinYvll5zVKYwef5IPs
         7nAsYToUWsIGAjc4HPhBBX4F5fxLt26IyGfREEQ1Frk7uZxh8MnGlW/+r3lkT2T69Eec
         xWxq4pa9T4a4UIb+l0LzJ7ouNsdFnThDm+fJfG9pJiEHjirKXayJpVmn8lJzqTcFjCHf
         iGyEh4Al7KWPGkKJSxw++YFZ4NqB7MEZogWErgujO4o40OofFn4vHDivFeOKdeihiOiY
         Uo8d5+7x+4VZ/y1bGacmyp6+3wVDphq9EUJ9tJ+FuBphGpPf3bwmByKkaM6jPlTaYq8P
         E+6w==
X-Gm-Message-State: AOAM533MG74WdyoW73sVQJiam/fPZPPmgYud4bqSq0V9Yfzu6MjEJCpO
        6MARyI7q77mtbGym8QminHY9VNONOgygey5gi1xBsIH8DcGQXCUe/MmJaffy7P3Q6ChOJdio3AD
        ct9oF7hX8H4A2
X-Received: by 2002:a1c:7c16:: with SMTP id x22mr12930099wmc.76.1596119346603;
        Thu, 30 Jul 2020 07:29:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxRk9Toidnn/8nNPJ92iTbSlGujn51nI+mWtmy4pxgPlXrvSf4iyFihMZ4GDNXrvGVTR5MsuQ==
X-Received: by 2002:a1c:7c16:: with SMTP id x22mr12930082wmc.76.1596119346396;
        Thu, 30 Jul 2020 07:29:06 -0700 (PDT)
Received: from [192.168.1.39] (214.red-88-21-68.staticip.rima-tde.net. [88.21.68.214])
        by smtp.gmail.com with ESMTPSA id h199sm9307047wme.42.2020.07.30.07.29.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 07:29:05 -0700 (PDT)
Subject: Re: [PATCH-for-5.1? v2 0/2] util/pagesize: Make
 qemu_real_host_page_size of type size_t
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     qemu-devel@nongnu.org, Stefano Garzarella <sgarzare@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>, qemu-block@nongnu.org,
        qemu-ppc@nongnu.org, Kaige Li <likaige@loongson.cn>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kevin Wolf <kwolf@redhat.com>, kvm@vger.kernel.org,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20200730141245.21739-1-philmd@redhat.com>
 <20200730142220.GA7120@work-vm>
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
Message-ID: <1338b920-28a6-8f9f-693d-b3852b7e54de@redhat.com>
Date:   Thu, 30 Jul 2020 16:29:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200730142220.GA7120@work-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/30/20 4:22 PM, Dr. David Alan Gilbert wrote:
> * Philippe Mathieu-DaudÃ© (philmd@redhat.com) wrote:
>> Since v1:
>> Make QEMU_VMALLOC_ALIGN unsigned in a previous patch
> 
> Nah, not for 5.1 - it feels like the type of thing that might on a
> really bad day create a really subtle bug.

Ack :)

