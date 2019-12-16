Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26C3D1206A1
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 14:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbfLPNI4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 08:08:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51449 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727576AbfLPNIz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 08:08:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576501734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qVps0ksEeffzPKmQcVs/p+Pjxq+Vz+TDTh2GnN60Xxw=;
        b=QaA0YpNGA4s0bEgnFdYlxAsNQbLAykr36zszp2vwqGsPeJlAqRk1gteLGwyNFHZG5aSdUC
        aFsWRPQ8RrWkrEh+tGVRsGtA3sUeTXRMkyBNAIRrz9RSLmDWIctn/HuoLaEV8EvhT1078D
        alTBbS+sc4AUOp8Hax1A3+2Pl05DIUM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-_YPUuulqPgSuW3lSvrvz0g-1; Mon, 16 Dec 2019 08:08:53 -0500
X-MC-Unique: _YPUuulqPgSuW3lSvrvz0g-1
Received: by mail-wr1-f69.google.com with SMTP id l20so3697464wrc.13
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 05:08:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qVps0ksEeffzPKmQcVs/p+Pjxq+Vz+TDTh2GnN60Xxw=;
        b=fvu7Ej5W5PsBv99DLz16KlzcW/RZMq+e9vfDeF2ydfJ/sN0VL7Keb5T0ZX00rKPzcB
         lRCGKLEC65P9G3s96DF7/l8Yxki0zjtfQqsmuCaCO6PiYs6WzIBh3iKk1X1xmIlh3H2x
         BXOyiWENhAMa1Vn+qPEkDPIFk0ZcEC34QZeVf6U4oJTengSRXUgu1coo16/PxhzyxXTO
         89MJR4l+oSWX375AP1aOUMJDNP4MZvvmWJD7o3eAsh8H8bQOganDQbHPRW9vBkA3K+xA
         HWGaqJMa8WKu3VIVFmtED1UIYWxTj9Eb/IWi4cdFprwutFh59XWOkGcjs0s6kSHibcpS
         Lp5w==
X-Gm-Message-State: APjAAAWKWYk04t01EgB6QQB6ekFNr/PsoyeCIxOS9YtTQX78vklNFqoR
        hAB+NuNoa3n3Ct4kbR3cjCW1S2ajAgcUBO8AhXmD3l7Q7wYiLg6JJSj+/M8apyhA7IWHof52t90
        5CDvgh8bU8gBf
X-Received: by 2002:adf:b648:: with SMTP id i8mr30617222wre.91.1576501731217;
        Mon, 16 Dec 2019 05:08:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqw5r6BjWyq15DIgwSERvxbOhPXbbbeovtPSwMIC0Ga4pAhcnI6btOTfyyoXbuuWBe0pFwLUzg==
X-Received: by 2002:adf:b648:: with SMTP id i8mr30617202wre.91.1576501731026;
        Mon, 16 Dec 2019 05:08:51 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id x11sm21078428wmg.46.2019.12.16.05.08.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 05:08:50 -0800 (PST)
Subject: Re: [PATCH 03/12] hw/i386/pc: Remove obsolete pc_pci_device_init()
 declaration
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
 <20191213161753.8051-4-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <39ca6020-193e-294b-2845-f5bab35609ef@redhat.com>
Date:   Mon, 16 Dec 2019 14:08:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191213161753.8051-4-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/12/19 17:17, Philippe Mathieu-Daudé wrote:
> In commit 1454509726 we removed the pc_pci_device_init()
> deprecated function and its calls, but we forgot to remove
> its prototype. Do that now.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  include/hw/i386/pc.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
> index 9866dfbd60..bc7d855aaa 100644
> --- a/include/hw/i386/pc.h
> +++ b/include/hw/i386/pc.h
> @@ -211,7 +211,6 @@ void pc_cmos_init(PCMachineState *pcms,
>                    BusState *ide0, BusState *ide1,
>                    ISADevice *s);
>  void pc_nic_init(PCMachineClass *pcmc, ISABus *isa_bus, PCIBus *pci_bus);
> -void pc_pci_device_init(PCIBus *pci_bus);
>  
>  typedef void (*cpu_set_smm_t)(int smm, void *arg);
>  
> 

Queued, thanks.

Paolo

