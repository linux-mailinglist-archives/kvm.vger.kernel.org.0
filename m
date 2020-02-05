Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9022815336B
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 15:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgBEOyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 09:54:03 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42088 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727070AbgBEOyC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 09:54:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580914441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IAbY+Yr9/eO31ocuCCsfW4JHEc/zKedrcNZ590XXkuc=;
        b=ZDeWCgvJ+9SuyBphVQoQex6eiipb+tm4KFSU1U0mL9SNyiV7ilnDBlr/21fpph8eAWOSzh
        mS4lE3hE16sT7EKR5N6TuBn2Kj2zo70iY4Av4U16vaxHsDFkwh3A5oQS2kVgnUgFPBLGio
        LRgTynES0ONoZ8qi3pSChUusxwcIYgA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-TmbU8mGcMIeyKrcK7J-9Zg-1; Wed, 05 Feb 2020 09:53:44 -0500
X-MC-Unique: TmbU8mGcMIeyKrcK7J-9Zg-1
Received: by mail-wm1-f72.google.com with SMTP id y125so2054975wmg.1
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 06:53:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IAbY+Yr9/eO31ocuCCsfW4JHEc/zKedrcNZ590XXkuc=;
        b=uhCHtRHqSnvzqBinrX6XekwVLBwkIJ+0rr8XFsK8TPHdepd4tlGD4iH55NcQoZpigJ
         yTmjGQyzxAFw3gYIEsy9HH8+DfD1wJf00RYqvkJ7lLwtUSzjfIlj6vppSIdlh6/Yr/7M
         51PZGRFOfgi484r0b/4UxHOovc10HuzXDeKUNYMMOxPQCb8ZmgvQooBK20fu8LN1kLZn
         thvgSll4M9KcoxENzZoXyxhcBtVlzAN0kzXIRjoNu+IhHMENhcTU82w3O5KNiucfo7+h
         yaMlp6oPjwYAl250pD+7biCopup6FdpeuqP6635ZhJdiWoMuWndjnJRiLTF0/MGOdHy1
         zpHg==
X-Gm-Message-State: APjAAAXTmb02W4LCuG/y/txNUFWyUX++a3Vfglw2wSfEBnkcFvz42OYL
        HQAcr9fLfQkSxOJHXYh/VwYiv7KFujTw+dSe7+lL0zW9KMdor8Rrc4UqZF7B7CapznfbyrCySwS
        Trhf5KHNcNYm9
X-Received: by 2002:adf:ed09:: with SMTP id a9mr12568524wro.350.1580914423777;
        Wed, 05 Feb 2020 06:53:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqz4uM/x/8RTwBkdiICJD8IV48N7CDDFK2+/pLfMxQ3+hcFqA1/YQpAgUC0SFoYYkKnZRG1C1g==
X-Received: by 2002:adf:ed09:: with SMTP id a9mr12568501wro.350.1580914423593;
        Wed, 05 Feb 2020 06:53:43 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a9f0:cbc3:a8a6:fc56? ([2001:b07:6468:f312:a9f0:cbc3:a8a6:fc56])
        by smtp.gmail.com with ESMTPSA id q14sm60827wrj.81.2020.02.05.06.53.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 06:53:43 -0800 (PST)
Subject: Re: [PATCH 3/3] kvm: mmu: Separate pte generation from set_spte
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
References: <20200203230911.39755-1-bgardon@google.com>
 <20200203230911.39755-3-bgardon@google.com>
 <87pnetkuov.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1adc4784-8567-d008-4d78-957fd33585ed@redhat.com>
Date:   Wed, 5 Feb 2020 15:53:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <87pnetkuov.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/02/20 14:52, Vitaly Kuznetsov wrote:
>> +	spte = make_spte(vcpu, pte_access, level, gfn, pfn, *sptep, speculative,
>> +			 can_unsync, host_writable, sp_ad_disabled(sp), &ret);
> I'm probably missing something, but in make_spte() I see just one place
> which writes to '*ret' so at the end, this is either
> SET_SPTE_WRITE_PROTECTED_PT or 0 (which we got only because we
> initialize it to 0 in set_spte()). Unless this is preparation to some
> other change, I don't see much value in the complication.
> 
> Can we actually reverse the logic, pass 'spte' by reference and return
> 'ret'?
> 

It gives a similar calling convention between make_spte and
make_mmio_spte.  It's not the most beautiful thing but I think I prefer it.

But the overwhelming function parameters are quite ugly, especially
old_spte.  I don't think it's an improvement, let's consider it together
with the rest of your changes instead.

Paolo

