Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBAE46D10B
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 11:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhLHKeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 05:34:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55291 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231728AbhLHKeP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 05:34:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638959443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nFLvTdLLgJdJ+8hfg5MAV9SEj87wM7ur8FtX5wKRGG8=;
        b=KUU8JPkJbO8mXg9v85tmEKs5KbneI1RhRAAczWwuFVA7pHgE58MMedULWXbH5rtAqfeCxZ
        JVtVlHJY/3Vjxl6D966BNy1ULxUqxr3fMKh47Nf7MuuoebEUUVyJS+vPg3TQ1zpxbDY0R/
        TrUtJygMpEnsq917aP2y7DkniE9KtKA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-2gHxksCJPuKc2bmM2sBRBA-1; Wed, 08 Dec 2021 05:30:42 -0500
X-MC-Unique: 2gHxksCJPuKc2bmM2sBRBA-1
Received: by mail-wm1-f72.google.com with SMTP id 201-20020a1c04d2000000b003335bf8075fso1098437wme.0
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 02:30:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nFLvTdLLgJdJ+8hfg5MAV9SEj87wM7ur8FtX5wKRGG8=;
        b=J5LhvXRSffBH8u5v+EWWLotUNmUcjFnQUdVAMrmev6D81iPGD73lvZZOitxTOEMy4R
         boaiY0eSnIyv6cD1YsX4+ybWojOus0I0j8/3VsvV5wKj3R2NyJ7kJ10M15irIw8skZAZ
         Uo3fTcOSrVBupEI3sdjYBzw11IeX3LRLL0+QkYqHDTv/Z/FHUEXrJJ+UhJlGKmQghm6B
         AwSr/cbnxqsdlLQYCmFEPlTcZPvwXzzixkPbD4RWzmKrqZxtUoTaQW8ovpvr9jlViTIl
         S5j8Xd4sfWrE7zksm9FamI/6+FyR6LrK2IIzKknhnn5x0U9qq8CO/r11bXj0LM5K7e9t
         Q1PA==
X-Gm-Message-State: AOAM530TBlv9umsLoSQeoPShbrMONGCOKbe4ksuMppYVUGJ5oZYrGc9j
        fGsnioOnotoSplHEM7spcy4lQ5c1kCc3kM0r39BmbJ8S/nGG8Bf7X3Sz54MEa9geI+jkjn2yRx2
        v3lLJa/FtxzSo
X-Received: by 2002:a5d:6101:: with SMTP id v1mr59703847wrt.598.1638959441099;
        Wed, 08 Dec 2021 02:30:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxGWtan1SHhwgUWFImrM3l8CbHw6BLDBYjHCZ9PClhi0QBXTuoFfZId+a5LuC7mNd50LNKlag==
X-Received: by 2002:a5d:6101:: with SMTP id v1mr59703815wrt.598.1638959440855;
        Wed, 08 Dec 2021 02:30:40 -0800 (PST)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id o4sm6411525wmq.31.2021.12.08.02.30.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 02:30:40 -0800 (PST)
Message-ID: <cea4e291-0537-bf15-38c7-7c9385427ab1@redhat.com>
Date:   Wed, 8 Dec 2021 11:30:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 01/12] s390x/pci: use a reserved ID for the default PCI
 group
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20211207210425.150923-1-mjrosato@linux.ibm.com>
 <20211207210425.150923-2-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20211207210425.150923-2-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/12/2021 22.04, Matthew Rosato wrote:
> The current default PCI group being used can technically collide with a
> real group ID passed from a hostdev.  Let's instead use a group ID that
> comes from a special pool (0xF0-0xFF) that is architected to be reserved
> for simulated devices.

Maybe mention that this is not a problem for migration since zPCI currently 
can't be migrated anyway (as mentioned in the discussion of an earlier 
version of this patch)

Acked-by: Thomas Huth <thuth@redhat.com>


> Fixes: 28dc86a072 ("s390x/pci: use a PCI Group structure")
> Reviewed-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   include/hw/s390x/s390-pci-bus.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/hw/s390x/s390-pci-bus.h b/include/hw/s390x/s390-pci-bus.h
> index aa891c178d..2727e7bdef 100644
> --- a/include/hw/s390x/s390-pci-bus.h
> +++ b/include/hw/s390x/s390-pci-bus.h
> @@ -313,7 +313,7 @@ typedef struct ZpciFmb {
>   } ZpciFmb;
>   QEMU_BUILD_BUG_MSG(offsetof(ZpciFmb, fmt0) != 48, "padding in ZpciFmb");
>   
> -#define ZPCI_DEFAULT_FN_GRP 0x20
> +#define ZPCI_DEFAULT_FN_GRP 0xFF
>   typedef struct S390PCIGroup {
>       ClpRspQueryPciGrp zpci_group;
>       int id;
> 

