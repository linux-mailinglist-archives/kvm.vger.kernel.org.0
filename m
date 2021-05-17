Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F0E382A6B
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 12:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236528AbhEQLAD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 07:00:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53195 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236471AbhEQLAC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 07:00:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621249126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lNjIA89QTeEsEjYOIrBUNsIb9fLDPAS0lmsFeSxUGuE=;
        b=hcalDiYRiPFQXKuQd0hcG1t77IlE0rCxIbaUd7j5OWVAosdX+7B5h389tG4PWDMSIUcWZy
        9RBCUpAvJ/6Dy+NDLnNShTsLD7jyTx94eDcjVhKi/q9s9bFzyRDDzxnjj41zmfypJDjL5U
        ZTMRxZSzAefwtpZIW5VtrrkdW40OiHE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-riLxkcWkOZqEzDBnyDAfFA-1; Mon, 17 May 2021 06:58:44 -0400
X-MC-Unique: riLxkcWkOZqEzDBnyDAfFA-1
Received: by mail-wr1-f71.google.com with SMTP id h104-20020adf90710000b029010de8455a3aso3649146wrh.12
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 03:58:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lNjIA89QTeEsEjYOIrBUNsIb9fLDPAS0lmsFeSxUGuE=;
        b=TkLSxGP7zKYjarGqYu4WiV2KsKXEvktZ2D4OLbxCarbWjkleDs4i3zXjyWdh9xAfPr
         DtjtLQs7oeQWKp95khnbpsSPRmqlB7K8YJqc2aIw7hZLFx/EGyju391brKM1Jb7TVMsg
         J0gd+0r/GNmMN0zww5y7raBVRzBsJobDEZn3bov4LN+IgRiohCHv9ikdM2yZ3MnGkE9A
         pZLd/tN9XSjQcd22ND/3gZt9Clg0W+R0VJevICMaQ6gUziTjld/BIMnoSP+XYJ/X24Uj
         Bfzpj1pOj6bIrRP7rwbjr1hoDWaTvsa4IJZgNPZ+29zfvV/xB9fgya/CWTYpZr6gBDEk
         iYfA==
X-Gm-Message-State: AOAM530+LX0etuxCMkkMlXRDncsJmfLphsovDpgKXvrzBmNSpbyjX07B
        TwNNVS2Gz1pst4xh6emRbOlpDMt4ho/Ga2wWv5/jolr/vdBaGiQ0jF+XqMlmDZ+yRT8VyY6RyvX
        KAKl4A+XQTrNP
X-Received: by 2002:a05:600c:3643:: with SMTP id y3mr22496444wmq.159.1621249123318;
        Mon, 17 May 2021 03:58:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4qvQzqe632RrIuYr/JxsN2c3xP8ULhehAVuKf0daIIpUPPXnOcOS7r62i4CPNqp790kfOcw==
X-Received: by 2002:a05:600c:3643:: with SMTP id y3mr22496394wmq.159.1621249123170;
        Mon, 17 May 2021 03:58:43 -0700 (PDT)
Received: from [192.168.1.36] (31.red-83-51-215.dynamicip.rima-tde.net. [83.51.215.31])
        by smtp.gmail.com with ESMTPSA id u9sm14617084wmc.38.2021.05.17.03.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 03:58:42 -0700 (PDT)
Subject: Re: [PULL v9 00/13] Cgs patches
To:     David Gibson <david@gibson.dropbear.id.au>, pasic@linux.ibm.com,
        dgilbert@redhat.com, pair@us.ibm.com, qemu-devel@nongnu.org,
        brijesh.singh@amd.com
Cc:     Thomas Huth <thuth@redhat.com>, cohuck@redhat.com,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        ehabkost@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        mtosatti@redhat.com,
        Richard Henderson <richard.henderson@linaro.org>,
        mdroth@linux.vnet.ibm.com, borntraeger@de.ibm.com,
        qemu-s390x@nongnu.org, Greg Kurz <groug@kaod.org>,
        qemu-ppc@nongnu.org, pragyansri.pathi@intel.com,
        jun.nakajima@intel.com, andi.kleen@intel.com, pbonzini@redhat.com,
        David Hildenbrand <david@redhat.com>, frankja@linux.ibm.com
References: <20210208060538.39276-1-david@gibson.dropbear.id.au>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <814d9c38-1de2-bf4a-ff57-595eb6672562@redhat.com>
Date:   Mon, 17 May 2021 12:58:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210208060538.39276-1-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

On 2/8/21 7:05 AM, David Gibson wrote:

> ----------------------------------------------------------------
> Generalize memory encryption models
...

>  create mode 100644 backends/confidential-guest-support.c
>  create mode 100644 docs/confidential-guest-support.txt
>  create mode 100644 docs/papr-pef.txt
>  create mode 100644 hw/ppc/pef.c
>  create mode 100644 include/exec/confidential-guest-support.h
>  create mode 100644 include/hw/ppc/pef.h

Could we have an entry in MAINTAINERS for these files?

Thanks,

Phil.

