Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2604903A5
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 09:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiAQIWN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 03:22:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36977 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231253AbiAQIWM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 03:22:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642407732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sg8p8AHi3UJdK9z4yX9nhx3FRx/VOIBzKvjT8S0Q3JM=;
        b=BLYO01mWMZQfbK88AihTaKEINUI0Y5nJMTwkvUxYoNJu0SV/XqZmrSH9azCjxeAQ6nOHG+
        /9O8bkv0p3HRazOQtPFTtXoxNGSxi1I9ZNIcX+CTxfA6YEi2sQB5hzkB/Rad6fapoU/HfA
        n3JWU3MXLfapU1AqRinE2hXJzeLgZBQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-278-gqy_uLuqNcmexTrgAV5F-Q-1; Mon, 17 Jan 2022 03:22:10 -0500
X-MC-Unique: gqy_uLuqNcmexTrgAV5F-Q-1
Received: by mail-wm1-f70.google.com with SMTP id 7-20020a1c1907000000b003471d9bbe8dso3412580wmz.0
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 00:22:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sg8p8AHi3UJdK9z4yX9nhx3FRx/VOIBzKvjT8S0Q3JM=;
        b=pFfL8rkDCjp47gu8epFGU25BEnVgZbPiOZI9ccFQ4kVUAxqH98MYNrx+WfjERzp1xK
         xORyIbkgRRnCmVm7+9+WSUV6/jsfjZLz11cQLtpfbjFY4a9a8xYFW1e5TyLmLExslnYX
         45qrgQXj/aBniPoisADXmiK80Ot/RL4jDH5vkg/pfCwokDNSPO6FyyoxXPImE+0sX9OJ
         fKIsBuOvE9K/XeXWWI553EmADvSjTEcv88oGCcvISihm2UcCG3v0TRPll66xMbHMqbhb
         KckdsYNL0T2b3uq7JQO0z0uAl2equqrka+bFoFVl8CGjce/QkhahjG6Ell2Gx122ZHs8
         43fQ==
X-Gm-Message-State: AOAM5310gfaknNWRpl2Z2ysRFDoW8rDOR8g8ruPeuXESBcyisUzzeeCH
        iJ4NkS4hhs8VYXTvdUOUItKp3vbztvPO5kRCOg0f8mWFRwFRfBXIMeu8hipA6MVA+9NPrXBtXbw
        ANd3SaFjLq11p
X-Received: by 2002:adf:e78e:: with SMTP id n14mr18512286wrm.631.1642407729427;
        Mon, 17 Jan 2022 00:22:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyfX6DyGdjNVfeccUpaF9Hfqtqa45OuD18xrFo42Uf+iDexJ9TwGxZgQm8IYyKvOJYF6w6HHw==
X-Received: by 2002:adf:e78e:: with SMTP id n14mr18512267wrm.631.1642407729203;
        Mon, 17 Jan 2022 00:22:09 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id u1sm7671679wrs.97.2022.01.17.00.22.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 00:22:08 -0800 (PST)
Message-ID: <b8c2663b-69df-913f-8da1-de6b7bd189ce@redhat.com>
Date:   Mon, 17 Jan 2022 09:22:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: linux-next: manual merge of the kvm tree with the risc-v tree
Content-Language: en-US
To:     Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmer@dabbelt.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul Walmsley <paul@pwsan.com>, KVM <kvm@vger.kernel.org>,
        Atish Patra <atishp@atishpatra.org>,
        Atish Patra <atishp@rivosinc.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        linux-riscv <linux-riscv@lists.infradead.org>
References: <20220112114024.7be8aac6@canb.auug.org.au>
 <20220117085431.7bef9ebc@canb.auug.org.au>
 <CAAhSdy3gEW+SC1GCH0V4iVA9h1sxeVV-V=x4kG7w_9tcVTtamw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAAhSdy3gEW+SC1GCH0V4iVA9h1sxeVV-V=x4kG7w_9tcVTtamw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/17/22 05:13, Anup Patel wrote:
> The commit c62a76859723 ("RISC-V: KVM: Add SBI v0.2 base extension")
> is already merged in Linus' tree.
> 
> Since you are yet to send PR for 5.17, we have two options:
> 1) Rebase your for-next branch upon latest Linus' tree master branch
> 2) Send "RISC-V: Use SBI SRST extension when available" in the
> next batch of changes for 5.17 after 5.17-rc1
> 
> Let me know if you want me to rebase and send v8 patch of
> "RISC-V: Use SBI SRST extension when available"
> 
> In future, we should coordinate and use a shared tag for such
> conflicting changes.

Palmer should just send it to Linus and note "enum sbi_ext_id has a 
trivial conflict" in the pull request message.

We'll sort it out better in the future, but it's such a minor conflict 
that it is not even a nuisance.

Paolo

