Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D175A388C98
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 13:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349975AbhESLUZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 07:20:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27631 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349983AbhESLUL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 May 2021 07:20:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621423130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NWPwTLXUbkkuBeNGwn+3y597gm6t7tmE54rpjMpE4pA=;
        b=RKWa2iA9rxg69RsfOxR9jwKscMv7Fhob28ukgfKT56LqXY+LuSIfkSuM7TyJgnF/l48eU9
        gQ8jEjZQenGDyyaK0IkqOulyzt0ePcT38Edurz8qcswlmtKsyBS3OTBtICpxUG6BIgkNkK
        FnhPQaZ1KwVtz90da/4f05znrC04xCQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-Kdu7a_oBN96uXyU6DoBA9A-1; Wed, 19 May 2021 07:18:48 -0400
X-MC-Unique: Kdu7a_oBN96uXyU6DoBA9A-1
Received: by mail-wr1-f72.google.com with SMTP id h104-20020adf90710000b029010de8455a3aso7015955wrh.12
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 04:18:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NWPwTLXUbkkuBeNGwn+3y597gm6t7tmE54rpjMpE4pA=;
        b=Iy85iUwWyCZ+Dm0uyuTIlDDblDJ0pbLr3sCpmMaDET3u+jW6M+3k5x1hV4ZUUPFvzq
         TKaogoa7GujFiJlswe86KDUIhJsCJJaZNprnrtn5cBMTv3ZvROkmloUFFay3pEjYw35F
         UVYXXNUZlEpXzjo9rpywd5G4Kl+/JrL5SbkTH8JC+pOYeXrXYF6gQJkwgGnrOx7A7mRu
         3nijfn+R2p1HeOEPEmHx26AKVceSdyjEYESJAItKjXf7MbF6VuS10pV5smcecmQQzs+L
         X6z3bYLGHqeh8TVAPfljinnohtUGmvLTzioBpSJq+ketC5O480m8fO1iw0Y/cdTblPqS
         Kndw==
X-Gm-Message-State: AOAM531rjkiD5gm47Quk3g7WJTaXMHE3j4ztwZG3LbuuFF9krZxzZwId
        vmUIbUk6DwUc7VxjiaWTu1ChJ6kCp6x9sqJoKxHCbXAKq5qta5e24OF/lFnhGt2/j+QNhvfUVjl
        COFyQbVT/yPeu
X-Received: by 2002:a5d:6910:: with SMTP id t16mr13720347wru.416.1621423127668;
        Wed, 19 May 2021 04:18:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsKGojU2DgZBTVi6QJ5uaGR/qngB2I/7EjHlNBsabqXVj4gNUE+e0fQBwiJa1DS8Rsi1PZLg==
X-Received: by 2002:a5d:6910:: with SMTP id t16mr13720320wru.416.1621423127405;
        Wed, 19 May 2021 04:18:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v10sm28926558wrq.0.2021.05.19.04.18.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 May 2021 04:18:46 -0700 (PDT)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anup Patel <anup@brainfault.org>
Cc:     Anup Patel <anup.patel@wdc.com>,
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v18 00/18] KVM RISC-V Support
Message-ID: <d7d5ad76-aec3-3297-0fac-a9da9b0c3663@redhat.com>
Date:   Wed, 19 May 2021 13:18:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YKTsyyVYsHVMQC+G@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/05/21 12:47, Greg Kroah-Hartman wrote:
>> It is not a dumping ground for stuff that arch maintainers can not seem
>> to agree on, and it is not a place where you can just randomly play
>> around with user/kernel apis with no consequences.
>>
>> So no, sorry, not going to take this code at all.
>
> And to be a bit more clear about this, having other subsystem
> maintainers drop their unwanted code on this subsystem,_without_  even
> asking me first is just not very nice. All of a sudden I am now > responsible for this stuff, without me even being asked about it.
> Should I start throwing random drivers into the kvm subsystem for them
> to maintain because I don't want to?:)

(I did see the smiley), I'm on board with throwing random drivers in 
arch/riscv. :)

The situation here didn't seem very far from what process/2.Process.rst 
says about staging:

- "a way to keep track of drivers that aren't up to standards", though 
in this case the issue is not coding standards or quality---the code is 
very good---and which people "may want to use"

- the code could be removed if there's no progress on either changing 
the RISC-V acceptance policy or ratifying the spec

Of course there should have been a TODO file explaining the situation. 
But if you think this is not the right place, I totally understand; if 
my opinion had any weight in this, I would just place it in arch/riscv/kvm.

The RISC-V acceptance policy as is just doesn't work, and the fact that 
people are trying to work around it is proving it.  There are many ways 
to improve it:

- get rid of it;

- provide a path to get an exception;

- provide a staging place sot hat people to do their job of contributing 
code to Linux (e.g. arch/riscv/staging/kvm).

If everything else fail, I guess we can place it in 
drivers/virt/riscv/kvm, even though that's just as silly a workaround. 
It's a pity because the RISC-V virtualization architecture has a very 
nice design, and the KVM code is also a very good example of how to do 
things right.

Paolo

> If there's really no other way to do this, than to put it in staging,
> let's talk about it.  But saying "this must go here" is not a
> conversation...

