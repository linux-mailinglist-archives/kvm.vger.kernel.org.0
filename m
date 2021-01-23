Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53AC30178F
	for <lists+kvm@lfdr.de>; Sat, 23 Jan 2021 19:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbhAWSSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Jan 2021 13:18:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26065 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbhAWSSH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 23 Jan 2021 13:18:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611425800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fh+H/iCB+MjwdNT+WaGZbG/tm/Jjf5+Yfa9yEKDsKMU=;
        b=gJv+8032sVygL0P9+iMYFyJwx2P/qdRUSsitoJjX/MFbO/9kaAooH+ChZnprY6FqU8VkeG
        EqKx0/zMqefWIbTEvz4Lyghc9CKa+kEiEJyIUwNfON1IpdN/FONJsx3hG0lLwltaA/nO1B
        l1Uas4BIhwEcApSVFvcKC2tzGnY1AfI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-CLAOU3uCMgSWBTGK_Z4_MA-1; Sat, 23 Jan 2021 13:16:38 -0500
X-MC-Unique: CLAOU3uCMgSWBTGK_Z4_MA-1
Received: by mail-ed1-f71.google.com with SMTP id j11so4063711edy.20
        for <kvm@vger.kernel.org>; Sat, 23 Jan 2021 10:16:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fh+H/iCB+MjwdNT+WaGZbG/tm/Jjf5+Yfa9yEKDsKMU=;
        b=EF058+UqqaUE5hXkjU2onMBKrG9hTMopknwrPPZFTlit5PMvXAOLxh4ufBUtE9mZO8
         36nygyV+zadnlMxcbl1ABTBiIBXHQ0ySp0UA509h5V9n7PxDmc+3OhqOGxis9YmshYNz
         yOQuK/I4AfDkKWZWOtC91iDos6yvz77SybYiT7Ers3Kin7cGOjSeruoVK6QL4FlUe1uy
         ioISYQdyDLA+wNfgXiF9+rBX+32x/Iv57naCXAF4JDE1kuy5mfqi1MjIiZvY3uVA+9ZF
         OP/ubywQwdVvasyXCwwPtHkSiVYwIwIGbkq5RbJDk4XmaxxEjNsaEZrqswTwG8KSGH1S
         OgHA==
X-Gm-Message-State: AOAM531siw/VfClXIIOtl5zx0CwDctBTdbQb2Yuvmp7lbPmRWKGE3zMs
        uadvJ9Vdb3fncQ+N9VRA75Zl+7gwbFNP6rltyZ4wkbXcg1C1pEx70x46feqQaYw2vZYq7tBC9+H
        bHCi9wWd3RVYM
X-Received: by 2002:a17:906:e84:: with SMTP id p4mr1806300ejf.141.1611425797227;
        Sat, 23 Jan 2021 10:16:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzzAQ5A5pNzVzlEQm+C6DbfBNkXUBCoGPsQ6yLTkqCvUJdVDgcUACJ4yMefQhpyin06lZKuqw==
X-Received: by 2002:a17:906:e84:: with SMTP id p4mr1806283ejf.141.1611425797090;
        Sat, 23 Jan 2021 10:16:37 -0800 (PST)
Received: from [192.168.1.124] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id p26sm7620691edq.94.2021.01.23.10.16.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Jan 2021 10:16:36 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v1 0/2] Fix smap and pku tests for new
 allocator
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, lvivier@redhat.com, nadav.amit@gmail.com,
        krish.sadhukhan@oracle.com, dmatlack@google.com, seanjc@google.com
References: <20210121111808.619347-1-imbrenda@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4dbfc9ad-7438-524b-f6ec-1e00b9e13cb8@redhat.com>
Date:   Sat, 23 Jan 2021 19:16:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210121111808.619347-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/01/21 12:18, Claudio Imbrenda wrote:
> The recent fixes to the page allocator broke the SMAP test.
> 
> The reason is that the test blindly took a chunk of memory and used it,
> hoping that the page allocator would not touch it.
> 
> Unfortunately the memory area affected is exactly where the new
> allocator puts the metadata information for the 16M-4G memory area.
> 
> This causes the SMAP test to fail.
> 
> The solution is to reserve the memory properly using the reserve_pages
> function. To make things simpler, the memory area reserved is now
> 8M-16M instead of 16M-32M.
> 
> This issue was not found immediately, because the SMAP test needs
> non-default qemu parameters in order not to be skipped.
> 
> I tested the patch and it seems to work.
> 
> While fixing the SMAP test, I also noticed that the PKU test was doing
> the same thing, so I went ahead and fixed that test too in the same
> way. Unfortunately I do not have the right hardware and therefore I
> cannot test it.
> 
> 
> 
> I would really appreciate if someone who has the right hardware could
> test the PKU test and see if it works.
> 
> 
> 
> 
> Claudio Imbrenda (2):
>    x86: smap: fix the test to work with new allocator
>    x86: pku: fix the test to work with new allocator
> 
>   x86/pku.c  | 5 ++++-
>   x86/smap.c | 9 ++++++---
>   2 files changed, 10 insertions(+), 4 deletions(-)
> 

Queued, thanks.

Paolo

