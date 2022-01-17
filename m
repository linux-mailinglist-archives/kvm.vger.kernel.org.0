Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7FB490B52
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 16:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240363AbiAQPXc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 10:23:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:38384 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231831AbiAQPXb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 10:23:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642433011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eptcp3tAvcq5hmKWsJUSp8SYz6a+GwEZa29b9sA+JtM=;
        b=PQnlE/h67PWtX2nDFcQrCFIBi323IS5O6nwNuycmKgXu1w4i8X9UU38aBXjUplj7VxODBO
        HBnRCXe4dfVtjeuAyZ1wyVE2lFjE2HWNF9nyqB9KN41jVz7NdaL/SPivuVodEIkqiXJMbj
        N0LdWvi9nl3i9BOEXvb5/8D8PpUtzYA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-wEQA4DYJNoS9FyiZ-z5pKg-1; Mon, 17 Jan 2022 10:23:10 -0500
X-MC-Unique: wEQA4DYJNoS9FyiZ-z5pKg-1
Received: by mail-wm1-f72.google.com with SMTP id 24-20020a05600c229800b0034bfa8a1531so87372wmf.1
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 07:23:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eptcp3tAvcq5hmKWsJUSp8SYz6a+GwEZa29b9sA+JtM=;
        b=LMwlC2eAcwPuX91WqR9WyPyTDLZW0QmKBahzywZ6YwUemDV0G0DDOI6aNJzG6oKlC/
         KDRvp6WpAu4N5Bn7ZRIO0C0dgw+yW+JTaHcxAhEjycaVjd4/54MhPleXlCyi96odKC/G
         p3OcXkBer6diCInXIT5wWh6mxAWaS2N18uZ6Agsl8Up3oeq9wAZls/nTlPJJ7PfVuouu
         jisyP0A0v5OZ6QYKWUkF7dk1tRUnNndIVXOHmlS7RqmYMGlYbopdRXjXVoSbsSWeYeHk
         WmSgI1BX9CyiB4vl6fkVYry6LpGlX0K3nFHcF9ltpeX7TDrVpAMsRoJ2xv5bwaz+VMMO
         Z+Kw==
X-Gm-Message-State: AOAM530J0t7CeobzOMpE/tb+7e7lnasY0KzAaXwZXibuaDaWIDfBJgCW
        ye5yDM+qniCE6oKXlTBnavid/ywkHokUzfgFcIcqaneX6daHj5CZ7cvWo/o++K6IEYMMm96Hb3a
        O04Crh5F6oUQm
X-Received: by 2002:a5d:591a:: with SMTP id v26mr17775943wrd.557.1642432988509;
        Mon, 17 Jan 2022 07:23:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyan0rksifvJHIoHblxOJ60zZ1eEn4rTVauXh+dyyVNUHHQkMTF1U9LOQ8Be+iumOxosZj7UQ==
X-Received: by 2002:a5d:591a:: with SMTP id v26mr17775934wrd.557.1642432988357;
        Mon, 17 Jan 2022 07:23:08 -0800 (PST)
Received: from [192.168.8.100] (tmo-098-68.customers.d1-online.com. [80.187.98.68])
        by smtp.gmail.com with ESMTPSA id t125sm5251214wma.15.2022.01.17.07.23.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 07:23:07 -0800 (PST)
Message-ID: <32c83624-eb3b-05ea-6fb6-737bd9876db3@redhat.com>
Date:   Mon, 17 Jan 2022 16:23:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 0/9] s390x/pci: zPCI interpretation support
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220114203849.243657-1-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220114203849.243657-1-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/01/2022 21.38, Matthew Rosato wrote:
> For QEMU, the majority of the work in enabling instruction interpretation
> is handled via new VFIO ioctls to SET the appropriate interpretation and
> interrupt forwarding modes, and to GET the function handle to use for
> interpretive execution.
> 
> This series implements these new ioctls, as well as adding a new, optional
> 'intercept' parameter to zpci to request interpretation support not be used
> as well as an 'intassist' parameter to determine whether or not the
> firmware assist will be used for interrupt delivery or whether the host
> will be responsible for delivering all interrupts.

  Hi Matthew,

would it make sense to create a docs/system/s390x/zpci.rst doc file, too, 
where you could describe such new parameters like 'intassist' and 
'intercept' (or is it 'interp') ? ... otherwise hardly anybody except you 
will know how to use these parameters later...

  Thomas

