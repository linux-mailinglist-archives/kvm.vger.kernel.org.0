Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2A146D07E
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 11:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhLHKI0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 05:08:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44838 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229772AbhLHKIZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 05:08:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638957893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=seZrGQmXeEuKGQyGFf5JkGZu8lxesI1wCr3AFLFyMKw=;
        b=TYa2T/bbHF/lI+8zVur+wjj2rjwatTQ6n9wkp9tOZW9GmOog4Y77I+6JFcZ6r3qH6CnDRX
        b2iC+wxYQOkLxAVRyJTn2MhIE1ydGEX/1DJI7wJp71mdV4wiQ7pcO+euoezjJOiMHK5QCg
        MkILVhFIBwhw/jH0RaSE3B9qfv+qBGQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-zpyNXKO-OVmHiYekzAIwxw-1; Wed, 08 Dec 2021 05:04:52 -0500
X-MC-Unique: zpyNXKO-OVmHiYekzAIwxw-1
Received: by mail-wr1-f72.google.com with SMTP id o4-20020adfca04000000b0018f07ad171aso261846wrh.20
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 02:04:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=seZrGQmXeEuKGQyGFf5JkGZu8lxesI1wCr3AFLFyMKw=;
        b=jy3nfK8H4A51pD8owTNRDaikBm71XXQYKS4gkWJ/hc8FTiA+HBYuA9l8VElAlyega5
         H2XLchw3W9cz/tKD+8h4PcrFfY5hZ5CgX8yC2XgWMDqaNs3SxDPXqOCULCEhP2Wgi+K3
         bz/31Q1J2SUTSK01WBPzaUNzwGCNO2fdD0YMpBDL7qoBTShBaQiCp1QYnNDtK9KHjMYI
         kPKByYHPSIa1gQoc812le/7pVucSFsq4leEDtwkkIixM4icZOg5/GqZhhMpODJMoDy2j
         05/PCAs5alsxC9R8HxUPEoGJQ2WWyhlj8bWbyCAbXMT9S1hHQZqn8N5YgXLC98KvZ51K
         c6og==
X-Gm-Message-State: AOAM530UukeMz97GIHRykxdHhrCFk0+p00jWqxiDe3Vbqs9shmbwicEZ
        6eXki27eqzTJ+dD6/ebFe6QSZQAfEcrriNzxEwCAMDDo7oPD2OUPKsS4Xd9nnKkIGzUMBlIl9wH
        FdP9q8V4Trgqj
X-Received: by 2002:a05:600c:3846:: with SMTP id s6mr14777959wmr.55.1638957891516;
        Wed, 08 Dec 2021 02:04:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzdcNwEWa7rgCxr52WTfkeLsyMwjlEgzt5mtjl0IAuWFdeXWYYn1Ccg/hLEM3PH/NUR+dqiDQ==
X-Received: by 2002:a05:600c:3846:: with SMTP id s6mr14777914wmr.55.1638957891267;
        Wed, 08 Dec 2021 02:04:51 -0800 (PST)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id y12sm2277928wrn.73.2021.12.08.02.04.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 02:04:50 -0800 (PST)
Message-ID: <804a914d-3e1d-1439-f8b5-3b514cda0f6e@redhat.com>
Date:   Wed, 8 Dec 2021 11:04:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 06/32] s390/airq: allow for airq structure that uses an
 input vector
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-7-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20211207205743.150299-7-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/12/2021 21.57, Matthew Rosato wrote:
> When doing device passthrough where interrupts are being forwarded
> from host to guest, we wish to use a pinned section of guest memory
> as the vector (the same memory used by the guest as the vector).
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
[...]
> diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
> index 880bcd73f11a..dfd4f3276a6d 100644
> --- a/arch/s390/pci/pci_irq.c
> +++ b/arch/s390/pci/pci_irq.c
[...]
> @@ -443,7 +443,7 @@ static int __init zpci_directed_irq_init(void)
>   		zpci_ibv[cpu] = airq_iv_create(cache_line_size() * BITS_PER_BYTE,
>   					       AIRQ_IV_DATA |
>   					       AIRQ_IV_CACHELINE |
> -					       (!cpu ? AIRQ_IV_ALLOC : 0));
> +					(!cpu ? AIRQ_IV_ALLOC : 0), 0);

Nit: Indentation changed

> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 52c376d15978..ff84f45587be 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -241,7 +241,7 @@ static struct airq_info *new_airq_info(int index)
>   		return NULL;
>   	rwlock_init(&info->lock);
>   	info->aiv = airq_iv_create(VIRTIO_IV_BITS, AIRQ_IV_ALLOC | AIRQ_IV_PTR
> -				   | AIRQ_IV_CACHELINE);
> +				| AIRQ_IV_CACHELINE, 0);

dito

>   	if (!info->aiv) {
>   		kfree(info);
>   		return NULL;
> 

  Thomas

