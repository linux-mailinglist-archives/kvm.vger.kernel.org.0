Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 401A51206A7
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 14:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbfLPNJd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 08:09:33 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33408 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727743AbfLPNJc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Dec 2019 08:09:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576501771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Jk6Cpq3pdn1ZWdM3Du7M0QmuQp8H64fwAOoLUEB6AA=;
        b=H0tW7ty9hdVE2rrhbOKB6O8YTVZVc8lQ4DL6/aBU0dX+M8+1n0S+m/BY6GclWqVtjfhY2X
        lpdzIODkXjkx56C6VqSrCnvKR5hqiGtDNG9bUAKqWaGM7eLRxCWOCf7UdDR4gfADVPooD8
        f2LaOK2yOXHUiaXEK23XW228bXtEtrk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-0YrmZn2VOuuV0nDamIIJxQ-1; Mon, 16 Dec 2019 08:09:30 -0500
X-MC-Unique: 0YrmZn2VOuuV0nDamIIJxQ-1
Received: by mail-wm1-f70.google.com with SMTP id t4so1020828wmf.2
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 05:09:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5Jk6Cpq3pdn1ZWdM3Du7M0QmuQp8H64fwAOoLUEB6AA=;
        b=MCmqF7qUGarlfKjqtcXUsGKQhP7DfqBrlyRjJ1csFN/D1aRqcAFKNlvAiiVB6kbIWE
         nUi0yf+69TwzUKsnib1PQ1j56zxETVTG7rNB7WX82ckIgrNpyWVqueaDtNQmbS2juRVv
         1PlucNTJMTLiOYA7zgFeo9i7niuIlixvEHOsJvtZc8x6N9JWI4snt4zXByhuxx96XypJ
         cl1if3ZqYp/6agcr7r8Yf96G8lRoQ2D1J6ohyk+xsUg/phHxwdP2b1iml5vDd9j9T13N
         40r1rPoftIhnP8w+UnFTvZcaK1JohlLlsP+QkjMyfM5k1CLoPA1AESqVtyHEEeE5vOoK
         orWA==
X-Gm-Message-State: APjAAAXfA3mzkz/Ne0oCwxfNGbqMT3lzCFySe0Qr+z/Fl8b25UQcr7i+
        EhOKnty5R1Jpw4b3pAsZx78CMJP2r6Qrc7hrU0plL5wKcs9p05BRZ7v6W7buaQmeDJIpwohgEAz
        eCzsKATUpkP9S
X-Received: by 2002:adf:806e:: with SMTP id 101mr31411908wrk.300.1576501769478;
        Mon, 16 Dec 2019 05:09:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqwYyxUkn02vgY6dZmRCZwsGERI4x52mCVKPdFOym4lzQgGYRZERott/od+zxPFmJAq+fK4eBQ==
X-Received: by 2002:adf:806e:: with SMTP id 101mr31411887wrk.300.1576501769266;
        Mon, 16 Dec 2019 05:09:29 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id l2sm20367946wmi.5.2019.12.16.05.09.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 05:09:28 -0800 (PST)
Subject: Re: [PATCH 04/12] hw/i386/pc: Remove obsolete cpu_set_smm_t typedef
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
 <20191213161753.8051-5-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a4d450dd-fa12-6a02-8225-37d467ed3628@redhat.com>
Date:   Mon, 16 Dec 2019 14:09:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191213161753.8051-5-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/12/19 17:17, Philippe Mathieu-Daudé wrote:
> In commit f809c6051 we replaced the use of cpu_set_smm_t callbacks
> by using a Notifier to modify the MemoryRegion. This prototype is
> now not used anymore, we can safely remove it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  include/hw/i386/pc.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
> index bc7d855aaa..743141e107 100644
> --- a/include/hw/i386/pc.h
> +++ b/include/hw/i386/pc.h
> @@ -212,8 +212,6 @@ void pc_cmos_init(PCMachineState *pcms,
>                    ISADevice *s);
>  void pc_nic_init(PCMachineClass *pcmc, ISABus *isa_bus, PCIBus *pci_bus);
>  
> -typedef void (*cpu_set_smm_t)(int smm, void *arg);
> -
>  void pc_i8259_create(ISABus *isa_bus, qemu_irq *i8259_irqs);
>  void ioapic_init_gsi(GSIState *gsi_state, const char *parent_name);
>  
> 

Queued, thanks.

Paolo

