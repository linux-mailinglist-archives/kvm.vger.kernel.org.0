Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5535E1E78EF
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 11:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgE2JB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 05:01:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34935 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725601AbgE2JB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 05:01:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590742915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=1fL5wfeIwGE12GxlumPph1/jcS+wHqC7Tch9KeZY/8g=;
        b=PrFGRjoA+OsaQOxLglXPtVJ/ybL0nMbk4P+Q4oqcRpbVW9PtGsLOlhH0yB/U8tdIlwfpg3
        nnEv16FRqb3G+6u+V00wvzFG1cfNjfqQAAupr1wc31k4rMyDVU8bT+mcb4xXuKtZRZHcbo
        hhoFrPhu4YualZWQSdsg1Fo1W3ipBzY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-YFdP7YolO8i4DmLPVPab6Q-1; Fri, 29 May 2020 05:01:54 -0400
X-MC-Unique: YFdP7YolO8i4DmLPVPab6Q-1
Received: by mail-wm1-f69.google.com with SMTP id 18so539593wmu.1
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 02:01:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=1fL5wfeIwGE12GxlumPph1/jcS+wHqC7Tch9KeZY/8g=;
        b=DXSH8co53uW3bCI2z5+te6KVTS8NkEDPeTLBOuJ6zEaB1Q0bTymmvutxUrgazyd5zx
         AsC74g29emxZM8XX7iEePOfYIRRh9LZwGqmoglAagi4r5tBkitA5zXBOGsKWscJzkBsD
         Da8ORt3Jr/aMN0+IcDXTX8qZXDB4/lIqtV5evRcd01DHlTIa4u3soBhaeU/+BabB2Olg
         aER9CdT54pfTOuZRuk2qm1eO+dm3O2bv4uHrLfgO3rXZJEo1NjbHNhKP6JVdYzhhRER4
         bg/dWQlMkayKiA/FWOJgIk7vhM4RbP71ROdecTsx0QHR0nrZSCanrqtd8dQe2CcAZwC+
         VqtQ==
X-Gm-Message-State: AOAM532xPvSKAocscAHeSyOtUXmqUonB3ij5X45eavej/Hg6pOVugHAI
        9/xjzsvorCbBJ6gDxrlLy8fXCE0aPABjunsTfMKbEvpXSm+82ihD+XiCg+Qs7eZqpxxBaoMpoA2
        KoT+NHtlhO+JJ
X-Received: by 2002:a5d:42cd:: with SMTP id t13mr7504869wrr.355.1590742913062;
        Fri, 29 May 2020 02:01:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlyySbxKCORRgSd+HqtInsBA/mHuUjU/XFB7HZ98TCEAZ5DkcMiHIamHigGb42Vcg46KCFjQ==
X-Received: by 2002:a5d:42cd:: with SMTP id t13mr7504851wrr.355.1590742912841;
        Fri, 29 May 2020 02:01:52 -0700 (PDT)
Received: from [192.168.1.34] (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id i15sm9419176wml.47.2020.05.29.02.01.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 02:01:52 -0700 (PDT)
Subject: Re: [RFC v2 01/18] target/i386: sev: Remove unused QSevGuestInfoClass
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-2-david@gibson.dropbear.id.au>
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
Message-ID: <e351ef56-4cdf-bc8c-4fc8-9583df7ab836@redhat.com>
Date:   Fri, 29 May 2020 11:01:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200521034304.340040-2-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/21/20 5:42 AM, David Gibson wrote:
> This structure is nothing but an empty wrapper around the parent class,
> which by QOM conventions means we don't need it at all.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  target/i386/sev.c      | 1 -
>  target/i386/sev_i386.h | 5 -----
>  2 files changed, 6 deletions(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 51cdbe5496..2312510cf2 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -287,7 +287,6 @@ static const TypeInfo qsev_guest_info = {
>      .name = TYPE_QSEV_GUEST_INFO,
>      .instance_size = sizeof(QSevGuestInfo),
>      .instance_finalize = qsev_guest_finalize,
> -    .class_size = sizeof(QSevGuestInfoClass),
>      .class_init = qsev_guest_class_init,
>      .instance_init = qsev_guest_init,
>      .interfaces = (InterfaceInfo[]) {
> diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
> index 8ada9d385d..4f193642ac 100644
> --- a/target/i386/sev_i386.h
> +++ b/target/i386/sev_i386.h
> @@ -41,7 +41,6 @@ extern char *sev_get_launch_measurement(void);
>  extern SevCapability *sev_get_capabilities(void);
>  
>  typedef struct QSevGuestInfo QSevGuestInfo;
> -typedef struct QSevGuestInfoClass QSevGuestInfoClass;
>  
>  /**
>   * QSevGuestInfo:
> @@ -64,10 +63,6 @@ struct QSevGuestInfo {
>      uint32_t reduced_phys_bits;
>  };
>  
> -struct QSevGuestInfoClass {
> -    ObjectClass parent_class;
> -};
> -
>  struct SEVState {
>      QSevGuestInfo *sev_info;
>      uint8_t api_major;
> 

Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

