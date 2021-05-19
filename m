Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FBD389288
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 17:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354751AbhESP2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 11:28:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59147 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354737AbhESP2I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 May 2021 11:28:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621438007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BPRLpBAjZNhjflwwDzXS2G9ItWCI1OxLrIqekCHLw0A=;
        b=SjBLDta38XjBY3kvpYLWmFbYGGv6UB3Tds2kQHKIDvMHwtGKFnWpUMhj/fDHeIwpTrbXQL
        g2GroXzVUy/CnlwXxdStUKT3imWSdGkUkTpTZFqCf2yDhl8W5guwCfn0UE1iRy2fti7EAZ
        APf8iADb00YAaGTZ2K6wxm1HqXlkqhc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-PA2UgSoLPjeEjxRJaAflCg-1; Wed, 19 May 2021 11:26:45 -0400
X-MC-Unique: PA2UgSoLPjeEjxRJaAflCg-1
Received: by mail-wr1-f72.google.com with SMTP id i15-20020a5d558f0000b029011215b1cf5cso928926wrv.22
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 08:26:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BPRLpBAjZNhjflwwDzXS2G9ItWCI1OxLrIqekCHLw0A=;
        b=Oo0TBNPacx163g7y43Z6HvS/AvgzRWLndW2870vqRcgtbV21uz8dSgd3MXheGkHyFD
         f5zbekv9uHJQtKVEo4gz4PzrWOqtMhjkCGKK2OovaZJwTFV/YBBAfBA0RrsK+oy+hB8N
         9mXsHGdWsT8gU8U35m4F8pMBn1Nvvwt8Kw4qfiWWiFlOHgq8bMhsbs4cF56/lxb4Etza
         hbJWypWEvIJ91eifUTyAwKHhVf4lGqxzvKA8SZK61mHXcTTKX+ZllGNMbi5m/iW9n7td
         6MkG9h66IKlfM6vGFwtqsG+GfM/56H35E0Si/e+8YG6ePbqCPZ8IjEomqNdWihzvLdJM
         dv8g==
X-Gm-Message-State: AOAM530pODq+Cw+mLJe+ofFFmPpsuuXqk9u1P0QwVwhNiTdUQGOJ9Dbe
        RET87OYZRgx5tyn0AwMg07jkBZa7cbsTX3s/2K7Jl9CnSi/eLGTpbR4JGQwd7UmeRD+UPqfQJfN
        VkkQOQtNy/IrI
X-Received: by 2002:a5d:570c:: with SMTP id a12mr15048772wrv.354.1621438003869;
        Wed, 19 May 2021 08:26:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKFgM0dMznbTO2YJBPi9PLyM0fdlyyhnY2E+SOMK4tY3xOEu2tCm4NOpliSoEFl1o4vdaeSw==
X-Received: by 2002:a5d:570c:: with SMTP id a12mr15048755wrv.354.1621438003711;
        Wed, 19 May 2021 08:26:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y137sm350209wmc.11.2021.05.19.08.26.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 May 2021 08:26:43 -0700 (PDT)
Subject: Re: [PATCH v18 00/18] KVM RISC-V Support
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Anup Patel <anup@brainfault.org>, Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-staging@lists.linux.dev
References: <20210519033553.1110536-1-anup.patel@wdc.com>
 <YKSa48cejI1Lax+/@kroah.com>
 <CAAhSdy18qySXbUdrEsUe-KtbtuEoYrys0TcmsV2UkEA2=7UQzw@mail.gmail.com>
 <YKSgcn5gxE/4u2bT@kroah.com> <YKTsyyVYsHVMQC+G@kroah.com>
 <d7d5ad76-aec3-3297-0fac-a9da9b0c3663@redhat.com>
 <YKUDWgZVj82/KiKw@kroah.com>
 <daa30135-8757-8d33-a92e-8db4207168ff@redhat.com>
 <YKUZbb6OK+UYAq+t@kroah.com> <20210519150814.GY1955@kadam>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1ce20fe0-0fea-406a-f7bf-1dde686b411a@redhat.com>
Date:   Wed, 19 May 2021 17:26:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210519150814.GY1955@kadam>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/05/21 17:08, Dan Carpenter wrote:
> It's sort of frustrating that none of this information was in the commit
> message.
> 
> "This code is not ready to be merged into the arch/risc/ directory
> because the RISC-V Foundation has not certified the hardware spec yet.
> However, the following chips have implemented it ABC12345, ABC6789 and
> they've already shipping to thousands of customers since blah blah blah
> so we should support it."
> 
> I honestly thought it was an issue with the code or the userspace API.

Yes, I was expecting this to be in the staging TODO file - I should have 
been more explicit with Anup.

Paolo

