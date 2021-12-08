Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2A146D112
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 11:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhLHKgn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 05:36:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39700 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231649AbhLHKgm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 05:36:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638959590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RayQTkh5qpH6mtjxZMvxNcypFgvmmb7AUx1Fk9LTj+4=;
        b=QN5YiMGtrma6MKXSd6qUe9xLlW8RhhuXKJwUwO7qWxbKTy2HPux4bpZHEdsqOj/LALy2xf
        Evw078wAYGAZklG/zid9fHSauMoDylYW9ghoUYd4XHubwLl+rhEFnbikOekH3XiSJ+x/EK
        eJb18nTnkRDuNT+dO2mebXwQzsOk+io=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-8OIN9ZRZP1W_XKPSIDwihA-1; Wed, 08 Dec 2021 05:33:09 -0500
X-MC-Unique: 8OIN9ZRZP1W_XKPSIDwihA-1
Received: by mail-wr1-f71.google.com with SMTP id d3-20020adfa343000000b0018ed6dd4629so282990wrb.2
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 02:33:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RayQTkh5qpH6mtjxZMvxNcypFgvmmb7AUx1Fk9LTj+4=;
        b=nwXZR+yPxNlT0bi0BVVQzWoirIbNBM0Bx5Ibn32KF+GRom5XGcDPAHi+kMjuQTkMdl
         Gnw6F8lR0w2WucrGaDDJgE1oAUyyPZXzLqnEIqdZQleoa73xDA4q3HzaXFFxFOXKJv1t
         1EEs7k4rbk3bV2Uk2lkBAyIyqabBNxwlEIXfDbyd8hkhdcnUjhLxBoFn5a+97yU2xree
         5PjQjRu7jnkM0fibjY2mY63EBRn3UIvX254I9ufoz67DvM0isKxPF2/nu0wMldTnsP/e
         KYXv50cyt3aUbk5pbxLdAj6p+kxbsj6TCUEVOdPWgblSmTX6ZgzH86Wm1P265ZbC7Fyv
         GD0w==
X-Gm-Message-State: AOAM532pwpva8stdZTmD+F3RKW6chjq8QTH1gfHD9jIl7lfgRmlckoqi
        JtD5wFJQ5oZZgX+LzXzfK7K4AjSm8r33sGm6QFJ21JyBiDw0JQ2B9T+J5Q3B/0vkom8CbVYG9e+
        LCDAegsPkSXZL
X-Received: by 2002:a7b:c084:: with SMTP id r4mr14818911wmh.107.1638959588307;
        Wed, 08 Dec 2021 02:33:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzCVNR4UKiTjDXHNUsdpUY9bag14xixygVrEeDtZ/8H5d0/4dHEWXebtzLTc/3FxQrxTsIcdA==
X-Received: by 2002:a7b:c084:: with SMTP id r4mr14818853wmh.107.1638959587957;
        Wed, 08 Dec 2021 02:33:07 -0800 (PST)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id b197sm2265497wmb.24.2021.12.08.02.33.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 02:33:07 -0800 (PST)
Message-ID: <b3e786fe-a399-c35f-39d4-80d13456bbd8@redhat.com>
Date:   Wed, 8 Dec 2021 11:32:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 02/12] s390x/pci: don't use hard-coded dma range in
 reg_ioat
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20211207210425.150923-1-mjrosato@linux.ibm.com>
 <20211207210425.150923-3-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20211207210425.150923-3-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/12/2021 22.04, Matthew Rosato wrote:
> Instead use the values from clp info, they will either be the hard-coded
> values or what came from the host driver via vfio.
> 
> Fixes: 9670ee752727 ("s390x/pci: use a PCI Function structure")
> Reviewed-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   hw/s390x/s390-pci-inst.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)


Reviewed-by: Thomas Huth <thuth@redhat.com>

