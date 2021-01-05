Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D86B2EB217
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 19:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbhAESH4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 13:07:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22246 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726132AbhAESH4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Jan 2021 13:07:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609869989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RUDwOl/6SWNVrAvOoL5QSIp3GpHmmT4c6iVV0F9vJZ0=;
        b=HvOpBu0Crhx6GOeQFcvidKo1ujs7nrM+6paXTMzIrg0P7ibE9pQLJZbXvGVSlrecw1yYMR
        644+FBqpu/CJWik//YaIbzwB5VuvmDipm7cnqK/ZNVqVO3Cj20woAi+qsFJN6W7jDGsBZu
        vbwuKaTrx+1dtutdsdRMqSqL9h0o72g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-R7RRqvXuN6mtJKvTmN5Kxg-1; Tue, 05 Jan 2021 13:06:26 -0500
X-MC-Unique: R7RRqvXuN6mtJKvTmN5Kxg-1
Received: by mail-wr1-f70.google.com with SMTP id b8so153701wrv.14
        for <kvm@vger.kernel.org>; Tue, 05 Jan 2021 10:06:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RUDwOl/6SWNVrAvOoL5QSIp3GpHmmT4c6iVV0F9vJZ0=;
        b=PQM8dPPx54jH5JylUupWG5ApSzv7ZMc8DI2roePKLxVhmdo0SUmG1R252UL2r85Lbb
         mFZ4Ul6UJ8tgGi1MEyuBLhwCF+3dHq+947rLl/c1B+VLRYlSu9LqgWRrXWOJFWNMjumC
         Q641Iycg15pBO7dhc5QgOi3DJvlwgjXpHhSDrnDrW4WXCSvfROjhOY0aG+jQgIn0rIF/
         95gvMhwq3Nht4BRfNZ41fNNzOMWm290uEFXZjHr0c+chnylJ2iiB2xCxARcXl1uc9DiY
         5ZKnVNfKlTYKwGwKAXnZhKoLwjcH/T3SQxwraRuKjeUp4K0PV1POOmrzB+ENZ6E3NcUk
         g1/A==
X-Gm-Message-State: AOAM533wPNbERCgFRqvDHO1l+IXpkMZtu9cgA4xboPhs3FR+djYetMvu
        RNc6124CIiDTD28ExSw1ZMUeP9zukxY08n7D9PZL49ksPm90+KTsBkaNhliokzLKhzyb7pQTn+v
        g1Pr22jNS3B00
X-Received: by 2002:a1c:4c0a:: with SMTP id z10mr295115wmf.95.1609869985678;
        Tue, 05 Jan 2021 10:06:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJweWbGa4AN+kyDNxhehOdA30gt2g68hXJoTud14aDQC4GHV6bTcsL0UXX4fLItXDS5wx4m9vg==
X-Received: by 2002:a1c:4c0a:: with SMTP id z10mr295096wmf.95.1609869985420;
        Tue, 05 Jan 2021 10:06:25 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r15sm762264wrq.1.2021.01.05.10.06.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jan 2021 10:06:24 -0800 (PST)
Subject: Re: reproducible BUG() in kvm_mmu_get_root() in TDP MMU
To:     Ben Gardon <bgardon@google.com>, leohou1402 <leohou1402@gmail.com>
Cc:     "maciej.szmigiero@oracle.com" <maciej.szmigiero@oracle.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "cannonmatthews@google.com" <cannonmatthews@google.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "pshier@google.com" <pshier@google.com>,
        "pfeiner@google.com" <pfeiner@google.com>,
        "junaids@google.com" <junaids@google.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "yulei.kernel@gmail.com" <yulei.kernel@gmail.com>,
        "kernellwp@gmail.com" <kernellwp@gmail.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
References: <4bf6fcae-20e7-3eae-83ec-51fb52110487@oracle.com>
 <8A352C2E-E7D2-4873-807F-635A595DCAEF@gmail.com>
 <CANgfPd_cbBxWHmPsw0x5NfKrMXzij3YAAiaq665zxn5nnraPGg@mail.gmail.com>
 <CANgfPd8fFB6QM3bOhxQ0WPjw6f5FLqBm1ynCenAxymByq4Lz5g@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f360715b-e61b-7e68-1aa9-84df51331d95@redhat.com>
Date:   Tue, 5 Jan 2021 19:06:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd8fFB6QM3bOhxQ0WPjw6f5FLqBm1ynCenAxymByq4Lz5g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/01/21 18:49, Ben Gardon wrote:
> for_each_tdp_mmu_root(kvm, root) {
>          kvm_mmu_get_root(kvm, root);
>          <Do something, yield the MMU lock>
>          kvm_mmu_put_root(kvm, root);
> }
> 
> In these cases the get and put root calls are there to ensure that the
> root is not freed while the function is running, however they do this
> too well. If the put root call reduces the root's root_count to 0, it
> should be removed from the roots list and freed before the MMU lock is
> released. However the above pattern never bothers to free the root.
> The following would fix this bug:
> 
> -kvm_mmu_put_root(kvm, root);
> +if (kvm_mmu_put_root(kvm, root))
> +       kvm_tdp_mmu_free_root(kvm, root);

Is it worth writing a more complex iterator struct, so that 
for_each_tdp_mmu_root takes care of the get and put?

Paolo

