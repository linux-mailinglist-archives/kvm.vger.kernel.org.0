Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 464141206B6
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 14:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfLPNL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 08:11:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46550 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727730AbfLPNL7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 08:11:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576501917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OVZ8qCkz+iSuAIxbiMtdabWP4u3zkLCvZUfHLBEZANg=;
        b=bFYsSoF6wsaWHSGIa8fMWSmnlisBGqpzMeB/5StN+qkYm3f4Pxllgvb72Og57yg5HgQyxV
        2NTW+zKZUdIx2kv+tqFDyuh5hwP2GV43kv+3xuY7lhM72zixMXZXTW/MFNjarTQY/xIGf4
        xzlpkBZTrHT9S9toStN7tOiVrtGbeq0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-BKUK5Fx3NG2ly1c3EX0cgQ-1; Mon, 16 Dec 2019 08:11:56 -0500
X-MC-Unique: BKUK5Fx3NG2ly1c3EX0cgQ-1
Received: by mail-wm1-f70.google.com with SMTP id l13so1013828wmj.8
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 05:11:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OVZ8qCkz+iSuAIxbiMtdabWP4u3zkLCvZUfHLBEZANg=;
        b=AqZmxvsm7z2qoY9VElr9pGcu94kJcRIqlncVyVEcLQacjGfbFr4y6H6hzZpELb+mjA
         EhDxVxPgO8qa+Q2TPJAnRgbtHP7zvj+PAaJA38xq0N9wH0LKhtKm8YEGYnddUQhfK8KW
         1FKiepVZGFg3U6p8Q2PhRXRyYb8Lmj3NuaSaza3bcnoOvuDbDsy4G0okP32bbBrObjU0
         ZmVgJTrIPBFUzJOAjnKZ/lKoNcVewFF6QeTHzeBgIqhLZz4SsFJcCc+xjGflNgCui1Wi
         R1th9Dq45lufSklvVYBtIitH9WhhwlynzZpGSXi5NGYCOyTeWDAh7NScXtNahtHZMDAM
         jSVg==
X-Gm-Message-State: APjAAAU8LniWNtUIILYiJ2ojRWp2/5haoth22kAXALf1hohYngQf2x0W
        yySrQjkNA0CuK2NY9Lsg3F2zFZFas65U1PQpoeN+YJpyPGvQamZFGP5zW1jBkC60K0Oo2XcmEAe
        O6rlA5iP9IP6S
X-Received: by 2002:adf:e6c5:: with SMTP id y5mr29515766wrm.210.1576501915281;
        Mon, 16 Dec 2019 05:11:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqw2vtXsGXckWOealAxKsd8xz8B6EZdGgNEAj2cPIngxIU6E4STQELcYok94Tp665k14zzg/Fg==
X-Received: by 2002:adf:e6c5:: with SMTP id y5mr29515741wrm.210.1576501915086;
        Mon, 16 Dec 2019 05:11:55 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:cde8:2463:95a9:1d81? ([2001:b07:6468:f312:cde8:2463:95a9:1d81])
        by smtp.gmail.com with ESMTPSA id o16sm6585832wmc.18.2019.12.16.05.11.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 05:11:54 -0800 (PST)
Subject: Re: [PATCH 09/12] hw/intc/ioapic: Make ioapic_print_redtbl() static
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     John Snow <jsnow@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-block@nongnu.org, Richard Henderson <rth@twiddle.net>,
        xen-devel@lists.xenproject.org, Sergio Lopez <slp@redhat.com>
References: <20191213161753.8051-1-philmd@redhat.com>
 <20191213161753.8051-10-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <340e7a8b-b7c6-3f61-3646-c311c7c33f60@redhat.com>
Date:   Mon, 16 Dec 2019 14:11:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191213161753.8051-10-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/12/19 17:17, Philippe Mathieu-Daudé wrote:
> Since commit 0c8465440 the ioapic_print_redtbl() function is not
> used outside of ioapic_common.c, make it static, and remove its
> prototype declaration in "ioapic_internal.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  include/hw/i386/ioapic_internal.h | 1 -
>  hw/intc/ioapic_common.c           | 2 +-
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/include/hw/i386/ioapic_internal.h b/include/hw/i386/ioapic_internal.h
> index d46c87c510..8b743aeed0 100644
> --- a/include/hw/i386/ioapic_internal.h
> +++ b/include/hw/i386/ioapic_internal.h
> @@ -118,7 +118,6 @@ struct IOAPICCommonState {
>  
>  void ioapic_reset_common(DeviceState *dev);
>  
> -void ioapic_print_redtbl(Monitor *mon, IOAPICCommonState *s);
>  void ioapic_stat_update_irq(IOAPICCommonState *s, int irq, int level);
>  
>  #endif /* QEMU_IOAPIC_INTERNAL_H */
> diff --git a/hw/intc/ioapic_common.c b/hw/intc/ioapic_common.c
> index 5538b5b86e..72ea945377 100644
> --- a/hw/intc/ioapic_common.c
> +++ b/hw/intc/ioapic_common.c
> @@ -76,7 +76,7 @@ static void ioapic_irr_dump(Monitor *mon, const char *name, uint32_t bitmap)
>      monitor_printf(mon, "\n");
>  }
>  
> -void ioapic_print_redtbl(Monitor *mon, IOAPICCommonState *s)
> +static void ioapic_print_redtbl(Monitor *mon, IOAPICCommonState *s)
>  {
>      static const char *delm_str[] = {
>          "fixed", "lowest", "SMI", "...", "NMI", "INIT", "...", "extINT"};
> 

Queued, thanks.

Paolo

