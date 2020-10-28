Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71CE429DB43
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 00:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389622AbgJ1XsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Oct 2020 19:48:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28741 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727534AbgJ1XsD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Oct 2020 19:48:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603928881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IT/EThefC3oSO/BW+27Fa6cj0opkp2OAAvr9i7UvIII=;
        b=IIFJyLlra7LL0kbjnTBMif6dSpDejXLKRK1Ovv8C1Jdu78KmMu4MUKmq7rhvP7tGMcaukW
        OnyaOzoBuPYRjY417zMwifKxbQLqC+DqZ16o7f3Wg9856Z/26ymyFrQd0sqGQrJRQNj1BZ
        GvxGBc4dOA8o6e79WbhPOFcvODxjrcg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-tl_HIlPUPpy86sYq5HwMhQ-1; Wed, 28 Oct 2020 03:45:03 -0400
X-MC-Unique: tl_HIlPUPpy86sYq5HwMhQ-1
Received: by mail-wr1-f72.google.com with SMTP id x16so1765221wrg.7
        for <kvm@vger.kernel.org>; Wed, 28 Oct 2020 00:45:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IT/EThefC3oSO/BW+27Fa6cj0opkp2OAAvr9i7UvIII=;
        b=Om1g8jXRwAs2P8l9Z3dldZOq7tsxAccHouzqY270HH4SXDZBGYPV+kaWs1PL3uqoBx
         2Ii39bPyTJmyNgBOFDtz1ntaA5VImYTxu+tOOcodwgBododTIci23LGUYY3Z3q+gCxTG
         8ZhJjSkFXAbmpK5V5Psq+yQsSO/gG8LzbkW02HF6oY/dGH6M1TC3dXn2GUjpkGj31sxq
         ZanDbwhmQUa0AjuUF3n9U/SR843DVp+RGxrGu16EDZhzVz2yaQG2xbQnnwzodxAdEm8z
         ujsRx7GXyFa1GRnOjrxa8QDfwJEKvKTPX50qBBAegv4et1W34glNEnHT4A6KsBf6cofp
         Fu0A==
X-Gm-Message-State: AOAM530DNsSHsiz8CR4hcPfqwyojBADwu9vwRUTx3muFkyWumqWPOyUV
        gzFUpZpTl4LBH+NYKvJf3jMiH4ElVBbNRHcEgo6Pcd9k6NBhNcn3OwJLu0NWx2o4hiLt3QLTnim
        n39vb7xa+sHTD
X-Received: by 2002:a1c:7f95:: with SMTP id a143mr6367156wmd.167.1603871102516;
        Wed, 28 Oct 2020 00:45:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXP6hBNa4ddKsUSErcQcq4TcuG91nufkWLxAmGUkxfPMp4IVoxgSQqj+h6pX9jcaScm9ztXA==
X-Received: by 2002:a1c:7f95:: with SMTP id a143mr6367139wmd.167.1603871102319;
        Wed, 28 Oct 2020 00:45:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u6sm4885576wmj.40.2020.10.28.00.45.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 00:45:01 -0700 (PDT)
Subject: Re: [PATCH 0/4] kvm: Add a --enable-debug-kvm option to configure
To:     AlexChen <alex.chen@huawei.com>, chenhc@lemote.com,
        pasic@linux.ibm.com, borntraeger@de.ibm.com, mtosatti@redhat.com,
        cohuck@redhat.com
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-s390x@nongnu.org,
        zhengchuan@huawei.com, zhang.zhanghailiang@huawei.com
References: <5F97FD61.4060804@huawei.com> <5F991998.2020108@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <404f58a5-180d-f3d7-dbcc-b533a29e6a94@redhat.com>
Date:   Wed, 28 Oct 2020 08:44:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <5F991998.2020108@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/10/20 08:11, AlexChen wrote:
> The current 'DEBUG_KVM' macro is defined in many files, and turning on
> the debug switch requires code modification, which is very inconvenient,
> so this series add an option to configure to support the definition of
> the 'DEBUG_KVM' macro.
> In addition, patches 3 and 4 also make printf always compile in debug output
> which will prevent bitrot of the format strings by referring to the
> commit(08564ecd: s390x/kvm: make printf always compile in debug output).

Mostly we should use tracepoints, but the usefulness of these printf
statements is often limited (except for s390 that maybe could make them
unconditional error_reports).  I would leave this as is, maintainers can
decide which tracepoints they like to have.

Paolo

