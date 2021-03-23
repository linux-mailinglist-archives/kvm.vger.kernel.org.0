Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607F73465ED
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 18:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCWRGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 13:06:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53414 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229951AbhCWRGZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Mar 2021 13:06:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616519184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fjHx4YqqWT4jRpiy21F/4VchU5onhpYM5ZCEE4eX3QA=;
        b=NZPQ/moMw131oh6GfgyD0XFofmVelNmmizhyH6nP2YccW1Th36ZUvsv7XubYLouy3Rp+8N
        2Rxi/p3geW3cJtNRi8FwZtf2/Gi9125t7x/VvzXHgZUJzPqY+J+nyhlRsHDa+Raen3Rh0Y
        UU3tO0BmjgSKqW03CtXtelqq9o21Nqc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-3sHFbHgmMm2oWq8IRSghKQ-1; Tue, 23 Mar 2021 13:06:22 -0400
X-MC-Unique: 3sHFbHgmMm2oWq8IRSghKQ-1
Received: by mail-wr1-f70.google.com with SMTP id r12so1381876wro.15
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 10:06:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fjHx4YqqWT4jRpiy21F/4VchU5onhpYM5ZCEE4eX3QA=;
        b=KXZfbjaz9xrAI+qPkc+BtH5pCKeaSdHArXHFffRX7JqPoTQENVX0XP0VPTFpfW6NOi
         p+fZP4oXZ3axCF4s3RFyyRTlMTWYj7DkQVphZXSIWMPkNl+Nto8EBtfSmFkiFxyX6kKJ
         DcRJRjkrtbui1QvjszYDibt9tWW/AKhTrDvg08O7tuK3a41Zl3nxMm8R2rX/IORmNHd6
         TDt5JRvBNCcezyN/yz0HvpfGqN5TfQK3b+HI4IVh9aR9VE1as64ru5tU5Wp/lHnJsthq
         PgZRwAa32F/kdvPr5lJWOmMYLCTmYf9Kbyol3XrfLaicgW0/u/v6/J/Q/AJka+4G3DX1
         Zd9g==
X-Gm-Message-State: AOAM530TfeXRfWlzEpGWGRo1zKw6/MLgcieTjVWvoriUu9/U+H+XVusi
        uX4v6IXgPF8/jp417Bi2BhCj17hOZ9DwXE3Xg9ojMiK6OYfO97zJLhK4tOefD4lT81dZiGt/Twj
        2h32170+b4T/u
X-Received: by 2002:a05:600c:4410:: with SMTP id u16mr4229749wmn.174.1616519181650;
        Tue, 23 Mar 2021 10:06:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyotb4LNeNf75U1fuOq54/VPcBZtHl/Lh33p5sPHaEyqCaTmUbKH7AZxpPK8zNuZdZ8ptethg==
X-Received: by 2002:a05:600c:4410:: with SMTP id u16mr4229733wmn.174.1616519181478;
        Tue, 23 Mar 2021 10:06:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u2sm24717945wrp.12.2021.03.23.10.06.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 10:06:20 -0700 (PDT)
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Borislav Petkov <bp@alien8.de>, Kai Huang <kai.huang@intel.com>,
        kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
References: <YFjoZQwB7e3oQW8l@google.com> <20210322191540.GH6481@zn.tnic>
 <YFjx3vixDURClgcb@google.com> <20210322210645.GI6481@zn.tnic>
 <20210323110643.f29e214ebe8ec7a4a3d0bc2e@intel.com>
 <20210322223726.GJ6481@zn.tnic>
 <20210323121643.e06403a1bc7819bab7c15d95@intel.com>
 <YFoNCvBYS2lIYjjc@google.com> <20210323160604.GB4729@zn.tnic>
 <41dd6e78-5fe4-259e-cd0b-209de452a760@redhat.com>
 <YFofNRLPGpEWoKtH@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5d5eacef-b43b-529f-1425-0ec27b60e6ad@redhat.com>
Date:   Tue, 23 Mar 2021 18:06:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YFofNRLPGpEWoKtH@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/03/21 18:02, Sean Christopherson wrote:
>> That's important, but it's even more important *to developers* that the
>> commit message spells out why this would be a kernel bug more often than
>> not.  I for one do not understand it, and I suspect I'm not alone.
>> 
>> Maybe (optimistically) once we see that explanation we decide that the
>> documentation is not important.  Sean, Kai, can you explain it?
>
> Thought of a good analogy that can be used for the changelog and/or docs:
> 
> This is effectively a kernel use-after-free of EPC, and due to the way SGX works,
> the bug is detected at freeing.  Rather than add the page back to the pool of
> available EPC, the kernel intentionally leaks the page to avoid additional
> errors in the future.
> 
> Does that help?

Very much, and for me this also settles the question of documentation. 
Borislav or Kai, can you add it to the commit message?

Paolo

