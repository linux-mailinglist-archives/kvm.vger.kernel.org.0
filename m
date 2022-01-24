Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8BEB4981D4
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 15:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233260AbiAXOP2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 09:15:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41596 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232281AbiAXOP1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 09:15:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643033727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qEoDw7zjkpUdI5GpDyaQSO4brAVPaHZ6Hb+32bug700=;
        b=Q9lSX8m8wF89QRUKCvWmgZd+Q8uHU6eUKnqaX9nDy5AJQ5IXh6cB94O/z/rHGiJ7dxgY5q
        SwIxUC2U8siwBg9pwOUPkEfPLlsDr2VhgbbWSqA3H9fw8QV85PHRYH+1pbfNGtY35pienJ
        NjKTpfMGytj0QC2baAAJqlMm6NHsHxQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-344-6bxf5y0rM6yAxLZAQwF4ig-1; Mon, 24 Jan 2022 09:15:25 -0500
X-MC-Unique: 6bxf5y0rM6yAxLZAQwF4ig-1
Received: by mail-ej1-f69.google.com with SMTP id q19-20020a1709064c9300b006b39291ff3eso2123080eju.5
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 06:15:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qEoDw7zjkpUdI5GpDyaQSO4brAVPaHZ6Hb+32bug700=;
        b=5y2cg19joqzTgMJoPZfmUo4Z8c5LO6wbbBI+A2zPlHN29nlavAtHVGrSlPCmtla8QP
         x8svQJqG7r5aMMZ7mRcWbGUz7lMkut2EVsD3MjWzAZ4RKTbrdNFysbh+T/d8xo9bPOuf
         0P6Uj71P5nEV4LfTDR+nH8radoFun8dbQJ3PHZY4nBa12z1lL3wSgkr0vneUX8zwlATq
         rvgiifMpPj2yMxUJ4sT/P9BTWvKYaZbwzy1X3dzSrcHOU9yjq5cJVf2Iw69vBG2vBwGe
         JMKR8Bgr7TdrEsyqo06MrSgvB3XETLxAf4pBj5U8DZknQnZ4tLa+hJdzdz6IRjKgeP8g
         w/Sw==
X-Gm-Message-State: AOAM5330Djkw3Ag0DwYT9XimAUOQwyYqFWUSYLcFAFtl2PNU34SJGWIB
        0bQbgj/GdEtR3GgK/Sik0MNYD94APtrFhGp6OhS5A/Nn/sRZYCuMIZiAMhpjhaJQ+Li1/4Rrohs
        rGuakZrZFSExh
X-Received: by 2002:a05:6402:524d:: with SMTP id t13mr15932504edd.106.1643033724361;
        Mon, 24 Jan 2022 06:15:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwC/c5o/wxRB+UBSDmMsKI4hII8nDfsdNW/NRqecjUewiUy1rw+EFFtJJdOmrT0xjocMvidcQ==
X-Received: by 2002:a05:6402:524d:: with SMTP id t13mr15932489edd.106.1643033724170;
        Mon, 24 Jan 2022 06:15:24 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id d6sm4471452eds.25.2022.01.24.06.15.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 06:15:23 -0800 (PST)
Message-ID: <b4ca7798-bd7b-4565-8132-023ae271da2d@redhat.com>
Date:   Mon, 24 Jan 2022 15:15:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [kvm-unit-tests PATCH 3/7] x86/debug: Test OUT instead of RDMSR
 for single-step #DB emulation test
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Alexander Graf <graf@amazon.de>
References: <20220120002923.668708-1-seanjc@google.com>
 <20220120002923.668708-4-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220120002923.668708-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/20/22 01:29, Sean Christopherson wrote:
> @@ -153,8 +152,7 @@ static unsigned long singlestep_emulated_instructions(void)
>   		"1:push %%rax\n\t"
>   		"xor %%rax,%%rax\n\t"
>   		"cpuid\n\t"
> -		"movl $0x1a0,%%ecx\n\t"
> -		"rdmsr\n\t"
> +		"out %%eax, $0x80\n\t"
>   		"popf\n\t"
>   		"lea 1b,%0\n\t"
>   		: "=r" (start) : : "rax", "ebx", "ecx", "edx"

This is a bit more "dangerous" if the tests are run on bare metal. 
Let's replace it with a

	movl $0x3fd, %%edx
	in %%edx, %%al

Queued with this change, thanks.

Paolo

