Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A6F34FC92
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 11:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbhCaJWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 05:22:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44046 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234568AbhCaJWF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 05:22:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617182524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zVTROcBb9bzk8v36Iv2BqaLwng0q/XnAhHIMpKNn/Ys=;
        b=J7OQhVGOOFbTrGOOalIS61arlTXGZTMGd+Pp2qw+5dNfaKNe0yJ95hBbc4cGQa+xZcnfhL
        PEY0DJQa6i/rxbmZX6xgITlBrjaPfi5je2wAKQh8btuTABKK/iWOkOzdxypdR3GKdV95OM
        N4jboCb3HOuPojYhKJgAZIuSmgXIqBs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-Mt34MXa8NpiN-2friIKHbQ-1; Wed, 31 Mar 2021 05:22:02 -0400
X-MC-Unique: Mt34MXa8NpiN-2friIKHbQ-1
Received: by mail-ed1-f69.google.com with SMTP id q25so773196eds.16
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 02:22:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zVTROcBb9bzk8v36Iv2BqaLwng0q/XnAhHIMpKNn/Ys=;
        b=WyacIhxVpMXPzPYYeDqKRjITUo2tGUpvd5AE//eHjuYj47DFpg35eotJLdWvqMpfZF
         8KjGc2PFMbgpiokqdKZ/OHyvkJ6Y67P9xcLa0oQrdKbc2LPuhzsGZvKT2J1vK1o2ofNI
         zEdXDgKfTlj4EJYFAUYgJSmD9QXL4HagXs8J8MCDgCg88ghUs0DT+oPOyvkrnbS83yc3
         bh/PaX9EM5Yh7AD/dRzHXt9ch7Vo8wOCHjA+vivfOfQ0voxkRUF7p/wl9Uzi5lYep2eI
         0lVUuVDYIjznXbTswNf1k0dRtwvAvsszRfTRd5dgMmOBqNJG9zUiMrhPyjEhMYMHYMCP
         WUZw==
X-Gm-Message-State: AOAM530ijavXGmYGFeFblP2xeTnF17gbR+NpLvKvuJHKBYskhj8Nh2Dp
        ORIyUbd+LL3ET4zibqs1cIxTeTMi7r4KP4cIk4wIBq6FvWElciza+o/0B0ANA+u4KROeogeGljb
        dHv+rbbQdGO2J
X-Received: by 2002:a17:906:26c9:: with SMTP id u9mr2490738ejc.520.1617182521410;
        Wed, 31 Mar 2021 02:22:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKa9uTF2uTziE05IHjX/X7hZq3YmL9WZwLFu1Pz7aA1dpsCjRo6rR9QXD1luH8TZAUg/dkxw==
X-Received: by 2002:a17:906:26c9:: with SMTP id u9mr2490728ejc.520.1617182521264;
        Wed, 31 Mar 2021 02:22:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id q19sm786118ejy.50.2021.03.31.02.21.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 02:22:00 -0700 (PDT)
Subject: Re: [PATCH v16 00/17] KVM RISC-V Support
To:     Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
References: <20210115121846.114528-1-anup.patel@wdc.com>
 <mhng-a4e92a0a-085d-4be0-863e-6af99dc27c18@palmerdabbelt-glaptop>
 <CAAhSdy0F7gisk=FZXN7jmqFLVB3456WunwVXhkrnvNuWtrhWWA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a49a7142-104e-fdaa-4a6a-619505695229@redhat.com>
Date:   Wed, 31 Mar 2021 11:21:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CAAhSdy0F7gisk=FZXN7jmqFLVB3456WunwVXhkrnvNuWtrhWWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/03/21 07:48, Anup Patel wrote:
> 
> It seems Andrew does not want to freeze H-extension until we have virtualization
> aware interrupt controller (such as RISC-V AIA specification) and IOMMU. Lot
> of us feel that these things can be done independently because RISC-V
> H-extension already has provisions for external interrupt controller with
> virtualization support.

Yes, frankly that's pretty ridiculous as it's perfectly possible to 
emulate the interrupt controller in software (and an IOMMU is not needed 
at all if you are okay with emulated or paravirtualized devices---which 
is almost always the case except for partitioning hypervisors).

Palmer, are you okay with merging RISC-V KVM?  Or should we place it in 
drivers/staging/riscv/kvm?

Either way, the best way to do it would be like this:

1) you apply patch 1 in a topic branch

2) you merge the topic branch in the risc-v tree

3) Anup merges the topic branch too and sends me a pull request.

Paolo

