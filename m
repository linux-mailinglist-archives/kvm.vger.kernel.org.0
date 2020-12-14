Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0BF2DA355
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 23:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407839AbgLNWYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 17:24:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36273 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388348AbgLNWYY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 17:24:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607984578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PFnADkNrSU05lKGQOlWcjWuzeRqXlzDdOnLf5WYh1I8=;
        b=hOQj7Q1jphbtGrvkKcpkf1HwsNw2RFgbVo3v2sXQ+rf489KbwivVVke5+WB2Tj2qU6UVMk
        e+i6/0SC9j+CdWfaOGODRy4Nc8I+y35QIEjx1AGUTy7rmcB9hdR+Q32Q7QK2OonZBdU2ZX
        fxeknNAn6sdnuCjMtgeyI093lq/GrlA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-XvSuSftpOSCnm-S0D1xVyg-1; Mon, 14 Dec 2020 17:22:56 -0500
X-MC-Unique: XvSuSftpOSCnm-S0D1xVyg-1
Received: by mail-ed1-f70.google.com with SMTP id dc6so8955356edb.14
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 14:22:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=PFnADkNrSU05lKGQOlWcjWuzeRqXlzDdOnLf5WYh1I8=;
        b=fjk66yUT1cUVp+Z3Ql9zpuY5WtJGkU9WbcJ2ZSsckSAQcg8UTwzBgZFy2z0ghuT4+Z
         DSfxiqBrIYCPpztrhons7KD13XfrCFGmDneHJM6NNnJ/gt11Ocdo7RGNQJBIo09uTpqJ
         v/48vl31RANgbHk8QFMs5FGqIYCO6kDURj6QsrtEd6jqhI9t5ZbweimO6I/WUNhfC7fx
         84a7bscw+yezPvOB/ZusatjTNLffsFwmvm4sYnyQD0+VRRdEOG0SQd8YES+oFFKs5A5H
         Tb6BKL+znw9rO4nViXWU9EZH76+gvBeMv0WKh4FDyJZblpsJ1oZqGDBzNJUMgMijQcMH
         ZMLw==
X-Gm-Message-State: AOAM533yqwZ7mfKomUZvpcm0dpfmRfYt+qw4U9yOehsSvZy/lNgEgwbB
        +PAaIkvlbqfYZA/+OgUZbQbYcr7tII8UBeIzuoplA0sAr4aUkXgqftcXkqC7Sm+h7/S/vLFjFKP
        htuAyNWhwR6ZK
X-Received: by 2002:a05:6402:1155:: with SMTP id g21mr27878046edw.53.1607984575261;
        Mon, 14 Dec 2020 14:22:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwoF8gvttPC8esfVTfY/n6n7wthWBleVkCN2uotw8Z3brdklZUlaN1X8DqFhLF+owqoM6DLxw==
X-Received: by 2002:a05:6402:1155:: with SMTP id g21mr27878032edw.53.1607984575074;
        Mon, 14 Dec 2020 14:22:55 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id i18sm16207422edq.79.2020.12.14.14.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 14:22:53 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com
Subject: Re: [PATCH v3 02/17] KVM: x86/xen: fix Xen hypercall page msr handling
In-Reply-To: <432C977E-0E29-4FFC-86FF-9958601DAB40@infradead.org>
References: <20201214083905.2017260-1-dwmw2@infradead.org>
 <20201214083905.2017260-3-dwmw2@infradead.org>
 <87czzcw020.fsf@vitty.brq.redhat.com>
 <58AC82A4-ADE4-4A8F-9522-16B8A4B9CBDD@infradead.org>
 <877dpkvz8w.fsf@vitty.brq.redhat.com>
 <432C977E-0E29-4FFC-86FF-9958601DAB40@infradead.org>
Date:   Mon, 14 Dec 2020 23:22:52 +0100
Message-ID: <873608vxhf.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> writes:

> On 14 December 2020 21:44:47 GMT, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>This actually looks more or less like hypercall distinction from after
>>PATCH3:
>>
>>	if (kvm_xen_hypercall_enabled(vcpu->kvm))
>>		return kvm_xen_hypercall(vcpu);
>>
>>        if (kvm_hv_hypercall_enabled(vcpu->kvm))
>>  	        return kvm_hv_hypercall(vcpu);
>>
>>....
>>
>>so my idea was why not do the same for MSRs?
>
> Can you define kvm_hv_msr_enabled()?
>
> Note kvm_hv_hypercall_enabled() is based on a value that gets written
> through the MSR, so it can't be that.

When Hyper-V emulation appeared in KVM we (unfortunately) didn't add a
capability to globaly enable and disable it so to be backwards
compatible we'll have to define kvm_emulating_hyperv() as 'true' for
now as that's how KVM behaves. This, however, doesn't mean we can't add
e.g. a module parameter to disable Hyper-V emulation. Also, we can
probably check guest CPUIDs and if Hyper-V's signature wasn't set we can
return 'false'.

<rant>
Having Hyper-V emulation in KVM 'always enabled' may not be a big deal
from functional point of view but may not be ideal from security
standpoint as bugs in arch/x86/kvm/hyperv.c become exploitable even from
Linux guests.
</rant>

-- 
Vitaly

