Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867AD4207A9
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 10:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbhJDJAW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 05:00:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25871 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229631AbhJDJAV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 05:00:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633337912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x988Ui+c+vfAAmLIqziJI6EexnnYwYLQ/x9zWNbOLdg=;
        b=TwNXIYYtUWclrH3r8p9pnqA2TMyC3lFM2awpjYUTLsgysWotTzNgV87KHX/pF2bNBn81Ux
        7jWHhIoiQsM85cHOUPaqTR5FvpkYn1rBenkt51AJ6TmjqgDhjUYCrO93HWo+KmylzotKwT
        IydCflgSi6CBMmAB1+gSbTeDS3gDCvk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-V0DiIh_UOQySt1ZAYyKKXg-1; Mon, 04 Oct 2021 04:58:31 -0400
X-MC-Unique: V0DiIh_UOQySt1ZAYyKKXg-1
Received: by mail-ed1-f71.google.com with SMTP id x96-20020a50bae9000000b003d871ecccd8so1555283ede.18
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 01:58:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=x988Ui+c+vfAAmLIqziJI6EexnnYwYLQ/x9zWNbOLdg=;
        b=6Q5/sPM8f20gb++kWCNNljwL1Mxvp9hcyt90jdy+q7j3LQFw52IdOre4+QX0lsNfNQ
         Qky+Qa33swZp4pDSDkfzqLRpW0PaWWYVVgkI0rp5tdTWTStJcj3nXNdHzAQze1Hu0Vwj
         OKND4EfNwKx+DF73+nyQyd9JxXikNPKcwipKR2OAyshFmhFQIAwVaLon27XycS37HJao
         NiEu/A30EXhtg4YmN1DRus2lGxn8Lg8DVW2V8JXzezJkvSXwiGiuhbvO8XmrSRErPbqK
         v9fuehYaEwHFcfomVZCTdJYbgAmBRt95ZXwIpfEikk4FTmkb/qa2SW+4yBWPf3pcq808
         jKOQ==
X-Gm-Message-State: AOAM530+vkCH9goHHrMqHEoAib2ev3UCNS9mlIGx98ymM5HJvrt0ZJ+Q
        bheZcgQh3kMkHnVBzBRmAEYFee0wwkPfH9cYzMfKU3Ei+v91dCvonuDFNGI1NEv/vvqVI8ZVrc9
        sV+ihbIr4f5Yx
X-Received: by 2002:a50:ff14:: with SMTP id a20mr16824384edu.81.1633337910598;
        Mon, 04 Oct 2021 01:58:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3qfHpLJuyjpb6MtwvFvqa3LKkfmelPlkrd/kMPhmqTdP8vX0VHFbEmy8mw+EaIFZUIu92UA==
X-Received: by 2002:a50:ff14:: with SMTP id a20mr16824362edu.81.1633337910414;
        Mon, 04 Oct 2021 01:58:30 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id s3sm6209175eja.87.2021.10.04.01.58.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 01:58:30 -0700 (PDT)
Message-ID: <5cadb0b3-5e8f-110b-c6ed-4adaea033e58@redhat.com>
Date:   Mon, 4 Oct 2021 10:58:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v20 00/17] KVM RISC-V Support
Content-Language: en-US
To:     Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20210927114016.1089328-1-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210927114016.1089328-1-anup.patel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/09/21 13:39, Anup Patel wrote:
> This series adds initial KVM RISC-V support. Currently, we are able to boot
> Linux on RV64/RV32 Guest with multiple VCPUs.
> 
> Key aspects of KVM RISC-V added by this series are:
> 1. No RISC-V specific KVM IOCTL
> 2. Loadable KVM RISC-V module supported
> 3. Minimal possible KVM world-switch which touches only GPRs and few CSRs
> 4. Both RV64 and RV32 host supported
> 5. Full Guest/VM switch is done via vcpu_get/vcpu_put infrastructure
> 6. KVM ONE_REG interface for VCPU register access from user-space
> 7. PLIC emulation is done in user-space
> 8. Timer and IPI emuation is done in-kernel
> 9. Both Sv39x4 and Sv48x4 supported for RV64 host
> 10. MMU notifiers supported
> 11. Generic dirtylog supported
> 12. FP lazy save/restore supported
> 13. SBI v0.1 emulation for KVM Guest available
> 14. Forward unhandled SBI calls to KVM userspace
> 15. Hugepage support for Guest/VM
> 16. IOEVENTFD support for Vhost
> 
> Here's a brief TODO list which we will work upon after this series:
> 1. KVM unit test support
> 2. KVM selftest support
> 3. SBI v0.3 emulation in-kernel
> 4. In-kernel PMU virtualization
> 5. In-kernel AIA irqchip support
> 6. Nested virtualizaiton
> 7. ..... and more .....

Looks good, I prepared a tag "for-riscv" at 
https://git.kernel.org/pub/scm/virt/kvm/kvm.git.  Palmer can pull it and 
you can use it to send me a pull request.

I look forward to the test support. :)  Would be nice to have selftest 
support already in 5.16, since there are a few arch-independent 
selftests that cover the hairy parts of the MMU.

Paolo

