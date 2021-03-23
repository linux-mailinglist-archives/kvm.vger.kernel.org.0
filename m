Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E5934657A
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbhCWQjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:39:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55938 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233286AbhCWQjF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Mar 2021 12:39:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616517545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D6weZtocFnBCEx2KB5301dgGufT240mULVdpXRdDCN0=;
        b=bfg7JqGPrqyg8BMc1Fj6gOgARCRpVtYRuLsoR75POGg2cFjWpdy7IBU5C6CnraPGKcB2sg
        SE3ft30OwJf7yWGQK5OamXV2Qi5zwcIhKDchpRqESY/kN6gSHIM5/upYEC24C2rytvyJBh
        tT9B2JYKtcP42Xx186B1kgvXBX9U9Eo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-855NUvMkPMqzrJp_aViA3A-1; Tue, 23 Mar 2021 12:39:02 -0400
X-MC-Unique: 855NUvMkPMqzrJp_aViA3A-1
Received: by mail-wm1-f69.google.com with SMTP id a3so698416wmm.0
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 09:39:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D6weZtocFnBCEx2KB5301dgGufT240mULVdpXRdDCN0=;
        b=sKfKvjg4dzAm9+LRajD6yXnZUXhnyEWK04DGKdc7gAybvu8FjysoIslMe8kenkETzs
         SCRjv0qqv+d+4V76atlJpMSZSmklA2Cul8tsYroIVWHpvYe+DPnugc0n2k/eHoCcB9lD
         XJesGN/5cFoXOO16oODYvfJ/UhaAO+b8IEMq+lOY2DiP/qb59Ycnu823Jrpu05US1H/T
         A+lVgMZLlu6Yglwn9U7GcO7P6zhIQWvoTf4jBOePpF5VKr5mRU9ubT4J2lw/XuNONlPV
         qCmlC6ruKaYOkr+Rrj7oz5/Hfa0fndHKFirGilgta7Aj8E58xEqhZjSD3NhhcMtL3ADw
         PTBg==
X-Gm-Message-State: AOAM533mukbJ1W3iZswgsnzAnGHxqXIuEzQ7euNlV+oowKanIFe4SS24
        Pq0qKQPc+rVW3DtnBLHRepeGAtnDceYtGDC4VxUAbPBW6IlUzowBpDLnI33dkDqN/aKrGmre5nH
        5L4ML1RW5cBGL
X-Received: by 2002:adf:8562:: with SMTP id 89mr4930807wrh.101.1616517541374;
        Tue, 23 Mar 2021 09:39:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKvUUe1NQSERBzHVlgA+GOPmHPOwJubTjgP1O9G/oYv5jEATOiJ0EW7ujfn570henkj75IQA==
X-Received: by 2002:adf:8562:: with SMTP id 89mr4930777wrh.101.1616517541194;
        Tue, 23 Mar 2021 09:39:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j136sm3281428wmj.35.2021.03.23.09.38.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 09:39:00 -0700 (PDT)
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
To:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
References: <062acb801926b2ade2f9fe1672afb7113453a741.1616136308.git.kai.huang@intel.com>
 <20210322181646.GG6481@zn.tnic> <YFjoZQwB7e3oQW8l@google.com>
 <20210322191540.GH6481@zn.tnic> <YFjx3vixDURClgcb@google.com>
 <20210322210645.GI6481@zn.tnic>
 <20210323110643.f29e214ebe8ec7a4a3d0bc2e@intel.com>
 <20210322223726.GJ6481@zn.tnic>
 <20210323121643.e06403a1bc7819bab7c15d95@intel.com>
 <YFoNCvBYS2lIYjjc@google.com> <20210323160604.GB4729@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <41dd6e78-5fe4-259e-cd0b-209de452a760@redhat.com>
Date:   Tue, 23 Mar 2021 17:38:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210323160604.GB4729@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/03/21 17:06, Borislav Petkov wrote:
>> Practically speaking, "basic" deployments of SGX VMs will be insulated from
>> this bug.  KVM doesn't support EPC oversubscription, so even if all EPC is
>> exhausted, new VMs will fail to launch, but existing VMs will continue to chug
>> along with no ill effects....
>
> Ok, so it sounds to me like*at*  *least*  there should be some writeup in
> Documentation/ explaining to the user what to do when she sees such an
> EREMOVE failure, perhaps the gist of this thread and then possibly the
> error message should point to that doc.

That's important, but it's even more important *to developers* that the 
commit message spells out why this would be a kernel bug more often than 
not.  I for one do not understand it, and I suspect I'm not alone.

Maybe (optimistically) once we see that explanation we decide that the 
documentation is not important.  Sean, Kai, can you explain it?

Paolo

