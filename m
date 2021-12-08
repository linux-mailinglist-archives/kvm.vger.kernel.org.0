Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F1D46D18C
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 12:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbhLHLIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 06:08:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30604 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229751AbhLHLIc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 06:08:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638961500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UZbO0LnRrqLmc+0f803IugxgNgvQhh8eWZ/uaUGTo8o=;
        b=gzcWvTE+nPvd6ny1N1MYn/YI78BkvgpBFJKYkzQIxNOvIXEWTCiExXTdgAaqPS2pIE2RHC
        g2rU+TnnGycHHWD/EiWwEuYw/aWdevXujMADZjkXc5VVEoZW/bvHl/RMHzPq1wVOnycJNW
        SVd08k3PiXfnCWgx8BGLhxs1NcPNwlk=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-411-WfTtJTG0MD6-a3htz-6Jew-1; Wed, 08 Dec 2021 06:04:59 -0500
X-MC-Unique: WfTtJTG0MD6-a3htz-6Jew-1
Received: by mail-qk1-f198.google.com with SMTP id a10-20020a05620a066a00b0046742e40049so2442299qkh.14
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 03:04:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UZbO0LnRrqLmc+0f803IugxgNgvQhh8eWZ/uaUGTo8o=;
        b=tNPNM2rPpkI2WGpejBfvAyLkPjarSWUuX04PZG2dLueJtooVT5oKQ2YekE7bglPUWT
         G5sMCc62BWqf25lH8CXVnhwq7gUiDAu3ndOYaosIacfuv2WASQVSmdgUOUChbAmnbP3n
         9t57xnivlCX4dO4CVvdKfdS3poB0qLMDlC3YK00A6/ykgYhLtDvPCzJmqCDz9QrCzB63
         5AdMSNQWQRMY/LFR7LdalANbRKX0edsQiWZgeBQSmeEP5On7kf03F1f1+O9LOiFYh2+F
         LBZya9vnuKwVoQcDbwHku+pITGdlDpo+8/Y+5ulX+/4YMUcjzIzQuYkqM70ECt8K29VF
         PhCA==
X-Gm-Message-State: AOAM532WBcLNzqyW7yNcyH7aoXDxC1ql6RJQXG3V0ewCvOfpy5ehR4c6
        p2IK1C8EDXOILi0NeS9BMWRDPiFaKy7sZuV4daHD9ph1NAegbbES/raeNnYilh31g61fwed63av
        oW2A3uW+bCcvo
X-Received: by 2002:ac8:5f4b:: with SMTP id y11mr6777520qta.489.1638961498882;
        Wed, 08 Dec 2021 03:04:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzgN0rWSvHKVHCI5PSeWvItw9tW3kzgnEh9zvBsDacWuW8j8anEVDgJ2qQvafxqnL1SqBttdg==
X-Received: by 2002:ac8:5f4b:: with SMTP id y11mr6777472qta.489.1638961498663;
        Wed, 08 Dec 2021 03:04:58 -0800 (PST)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id f34sm1642977qtb.7.2021.12.08.03.04.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 03:04:58 -0800 (PST)
Message-ID: <acf34693-3097-6734-b2d6-e64817f26b1d@redhat.com>
Date:   Wed, 8 Dec 2021 12:04:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 08/12] s390x/pci: don't fence interpreted devices without
 MSI-X
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20211207210425.150923-1-mjrosato@linux.ibm.com>
 <20211207210425.150923-9-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20211207210425.150923-9-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/12/2021 22.04, Matthew Rosato wrote:
> Lack of MSI-X support is not an issue for interpreted passthrough
> devices, so let's let these in.  This will allow, for example, ISM
> devices to be passed through -- but only when interpretation is
> available and being used.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   hw/s390x/s390-pci-bus.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
> index 451bd32d92..503326210a 100644
> --- a/hw/s390x/s390-pci-bus.c
> +++ b/hw/s390x/s390-pci-bus.c
> @@ -1096,7 +1096,7 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
>               pbdev->interp = false;
>           }
>   
> -        if (s390_pci_msix_init(pbdev)) {
> +        if (s390_pci_msix_init(pbdev) && !pbdev->interp) {
>               error_setg(errp, "MSI-X support is mandatory "
>                          "in the S390 architecture");
>               return;
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

