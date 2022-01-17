Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCF4490B8C
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 16:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240541AbiAQPi7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 10:38:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33849 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237314AbiAQPi6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 10:38:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642433935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wOusBN6XfQOfHOxleziR5QfImcP1X7Da7CkR+CRdf1o=;
        b=OkRbs5wUa1bQ4yXgdArXNEL+N+CODOPzLn+uRNvIzbjeQrmm56dq+NJVL1iy69VP5ynhmY
        miyhY2a+NppJDONCgZRTkib//U0NYbkjr1AIUOpm5YCfNWprTov3QyeWcnbh9EOFn9LtJv
        a8rL+8dxazFHiFgSVHX1J9AZz+DtkMw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-5yeV-wcgM_m8ca0Im621ig-1; Mon, 17 Jan 2022 10:38:37 -0500
X-MC-Unique: 5yeV-wcgM_m8ca0Im621ig-1
Received: by mail-wm1-f71.google.com with SMTP id c188-20020a1c35c5000000b00346a2160ea8so5520845wma.9
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 07:38:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wOusBN6XfQOfHOxleziR5QfImcP1X7Da7CkR+CRdf1o=;
        b=vSdLHQm89yh/aQhOnzlzh+/D2LVgLq+RR2unGax/SmK0SLx9zUF9RbUelaDl1nInqW
         1PCOi0LfgFeAGNhI+CR3jFu1JuHi/421mD3EmSX248vqc4y00PSOfZ77h8OuE2c8DW3C
         h8kAneBLn4bdJdfCvleb+W8zb+fqDiuGy0ZZST408jsMBaqvqQzZVw6LpVtS3XCpznye
         pt9vqKwoqbAJw6pEu+U6BwoH0zw29mHMX0OdQ8u3fLVczTXwk+vqwQmRQzpxhdcuEJpV
         TxHxwVPgwB181tBSDcqld8fsMg8xMUhmYRh/mSq8Fu7OtBIFXTPiJYdT9x+lJyy4th8k
         3MsA==
X-Gm-Message-State: AOAM532Z07W45+BQcVjUg/dhZgIFUOK3fiOi+jqeu95aGhwcKqvxLfyo
        DO+3/cw+B4wLNQbdLGbV1AlhOz/X1G0L+Zjn1h3NDKbrjpW2Ww07Fg5LIh+L7X9qcVYrrDFDWtK
        v/Lht7GMtfAVa
X-Received: by 2002:a05:600c:364b:: with SMTP id y11mr18294642wmq.156.1642433908560;
        Mon, 17 Jan 2022 07:38:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzobrH/M5S9n0iOAFC2L0Ob4FJaT4FkMiqTq/8tKjyizFX/APce3EwLHrb4nAWo53clG/YK7Q==
X-Received: by 2002:a05:600c:364b:: with SMTP id y11mr18294636wmq.156.1642433908407;
        Mon, 17 Jan 2022 07:38:28 -0800 (PST)
Received: from [192.168.8.100] (tmo-098-68.customers.d1-online.com. [80.187.98.68])
        by smtp.gmail.com with ESMTPSA id o1sm3562904wri.12.2022.01.17.07.38.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 07:38:27 -0800 (PST)
Message-ID: <9f55cf89-9d58-b1c5-0d97-d0730498b62f@redhat.com>
Date:   Mon, 17 Jan 2022 16:38:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 4/9] s390x/pci: enable for load/store intepretation
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220114203849.243657-1-mjrosato@linux.ibm.com>
 <20220114203849.243657-5-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220114203849.243657-5-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/01/2022 21.38, Matthew Rosato wrote:
> Use the associated vfio feature ioctl to enable interpretation for devices
> when requested.  As part of this process, we must use the host function
> handle rather than a QEMU-generated one -- this is provided as part of the
> ioctl payload.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   hw/s390x/s390-pci-bus.c          | 70 +++++++++++++++++++++++++++++++-
>   hw/s390x/s390-pci-inst.c         | 63 +++++++++++++++++++++++++++-
>   hw/s390x/s390-pci-vfio.c         | 52 ++++++++++++++++++++++++
>   include/hw/s390x/s390-pci-bus.h  |  1 +
>   include/hw/s390x/s390-pci-vfio.h | 15 +++++++
>   5 files changed, 199 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
> index 01b58ebc70..a39ccfee05 100644
> --- a/hw/s390x/s390-pci-bus.c
> +++ b/hw/s390x/s390-pci-bus.c
...
> @@ -1360,6 +1427,7 @@ static Property s390_pci_device_properties[] = {
>       DEFINE_PROP_UINT16("uid", S390PCIBusDevice, uid, UID_UNDEFINED),
>       DEFINE_PROP_S390_PCI_FID("fid", S390PCIBusDevice, fid),
>       DEFINE_PROP_STRING("target", S390PCIBusDevice, target),
> +    DEFINE_PROP_BOOL("interp", S390PCIBusDevice, interp, true),
>       DEFINE_PROP_END_OF_LIST(),
>   };

Since this is something that the user can see, would it maybe make sense to 
provide a full word instead of an abbreviation here? I.e. "interpret" or 
"interpretation" instead of "interp" ?

  Thomas

