Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70422422CCE
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 17:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235976AbhJEPor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 11:44:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29172 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231513AbhJEPoq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 11:44:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633448575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pKDntHxzJOetHKbIPGUlL8NO/wbE042BlEFlU+R/BTE=;
        b=A0AUxVqj/YQodM1zJQG78Hq19h+ivq8l54O+8Bi3+lDJpRb8EK07NGVfrwqMUJITr0Eo1R
        J7oYgUj53Xx5sZxL+dOLj0/nezmuWitAWsjDxazjAxsXZscLXhsEdvqh1rFkNfykrxAVue
        IrzT+ia8jbpbBDYVAye9eOclGQuDARs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-RDgZgvMCOfi7O76yhPbauA-1; Tue, 05 Oct 2021 11:42:52 -0400
X-MC-Unique: RDgZgvMCOfi7O76yhPbauA-1
Received: by mail-wm1-f72.google.com with SMTP id 200-20020a1c00d1000000b0030b3dce20e1so1493692wma.0
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 08:42:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pKDntHxzJOetHKbIPGUlL8NO/wbE042BlEFlU+R/BTE=;
        b=sxJEi4He9aWfuZ52GR+5RU7Hdb77DmpzUS2yebBS/1zLd1R+IWbIfjfDaLb4JXx2bo
         Zi6RjujP9C3ZBqaPTpa0QX1FBngbmfj5qJ0/ty16+imusI/xyqBj8wSdfytwFi3meqTq
         fbO3vNTgLb9M+gMimsyNWryjx5sGdU31JF8eJAAUND+ry+Z/a66IZbkFPD7ZEMLo1kzx
         PiQ/DmZ9pNLa1MgfsL8UtkAIScaLFHUMGIoXuJKxiolbQyVdrKK6f7Wuafg3888sFwq5
         MYuhdkZGPqwlNiT+XPf4JmqrdFYyGZNlbFOGp7DbMbwCixG+OQtjvkIhzdbot7IdE7Xf
         QEYQ==
X-Gm-Message-State: AOAM530+aGpAU7B5hTLaJAOmFDUUpxAsNa8+dLe4Sksi1GL3O6SYMzTf
        LOTRL/Jywq39Cud4dfVsCi5WcPM/JPfVx04C8Y0kEbN+P048G2O5G1VYjQK8+8sBuDR8ecsObSB
        6k7fU8uQu8bqy
X-Received: by 2002:adf:a154:: with SMTP id r20mr22999664wrr.326.1633448570961;
        Tue, 05 Oct 2021 08:42:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyHSPI1IRwixTMGerHUDu4oO6qB21Y4tIuWzxQ2/xnPIsskWzR3SXr5r0UgA4SsVDAY0yR+Mg==
X-Received: by 2002:adf:a154:: with SMTP id r20mr22999647wrr.326.1633448570792;
        Tue, 05 Oct 2021 08:42:50 -0700 (PDT)
Received: from thuth.remote.csb (p549bb2bd.dip0.t-ipconnect.de. [84.155.178.189])
        by smtp.gmail.com with ESMTPSA id y191sm2699170wmc.36.2021.10.05.08.42.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 08:42:50 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 5/5] Use report_pass(...) instead of
 report(1/true, ...)
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211005090921.1816373-1-scgl@linux.ibm.com>
 <20211005090921.1816373-6-scgl@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <c3ee78df-3caf-f9a7-90c2-624ab09e5949@redhat.com>
Date:   Tue, 5 Oct 2021 17:42:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211005090921.1816373-6-scgl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/10/2021 11.09, Janis Schoetterl-Glausch wrote:
> Whitespace is kept consistent with the rest of the file.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>   s390x/css.c         |  4 ++--
>   s390x/diag288.c     |  2 +-
>   s390x/selftest.c    |  2 +-
>   s390x/smp.c         | 16 ++++++++--------
>   s390x/spec_ex.c     |  7 +++----
>   x86/asyncpf.c       |  7 +++----
>   x86/emulator.c      |  2 +-
>   x86/hyperv_stimer.c | 18 ++++++++----------
>   x86/svm_tests.c     | 17 ++++++++---------
>   x86/syscall.c       |  2 +-
>   x86/taskswitch2.c   |  2 +-
>   x86/tsc_adjust.c    |  2 +-
>   x86/vmx.c           |  6 +++---
>   x86/vmx_tests.c     | 36 ++++++++++++++++++------------------
>   14 files changed, 59 insertions(+), 64 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

