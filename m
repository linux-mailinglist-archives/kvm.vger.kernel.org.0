Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4427347712
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 12:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbhCXLZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 07:25:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46630 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231811AbhCXLYn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Mar 2021 07:24:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616585082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lh92eKH08v+5P713WfsuE7oYAeLerhzo8+IyAgchy40=;
        b=dSdi+gIthq4sDmvI2lCpQs6dY3QSULZ1umXA7XmX8+LvUZpI6zFy9jLJ6a7ySFUUDOTTPJ
        Wnd/FnYdkcZ2Zqd9beqMPvbqSp4INdY97bBNMUDso/rN5mA2BiZF6YSQ+7GyOYpZud4SpU
        JOfTwpiN9oCvS02CoaVDGNKBsJOL1hU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-yTUaBDrcMMa8RgiIcpZ5Rg-1; Wed, 24 Mar 2021 07:24:41 -0400
X-MC-Unique: yTUaBDrcMMa8RgiIcpZ5Rg-1
Received: by mail-wm1-f69.google.com with SMTP id w10so519685wmk.1
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 04:24:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Lh92eKH08v+5P713WfsuE7oYAeLerhzo8+IyAgchy40=;
        b=bHuserHJr0LhWU06+LWCE9Sm55IjWxeYTqZA7DwllEiNzEJpszLR9heu8zvumbu1Eg
         1LGGRxi4GimxPmu28jVi8l0RlevuSzply2Wct0VTOPITuc6K7eRHUXQ5PCdYKV2BMuYJ
         mobOGpLkzd8hd9iwjrurSyF705g8fyrTCpNrwXm9aDQnh6q1dUg9erMGBwvObV5uYqWO
         Y/HXxcQHCrkaFV24lRE4LrovxTCiymSzBOfn34Id/PkHfmUl+X9W8Kqc5uIzfmh4aTFu
         3pdLf/NG874D1abXGlF9PEosidr3rqRykT3CXIyJYevA0l6639bsrsjC0SbWosmWjlEc
         jzBA==
X-Gm-Message-State: AOAM531cojZioPnk4V63bbExHKwg0GGBn7jTrteioRuVZzP8wzqxW4Tf
        1wxfbwle4h7+20XyD4/0g5pcYNI//BStTv6bUn9dMkxQSuH/kJeO2kMQ4a7usyXTBQ3EoDtDUDr
        +bsAZvzQvoF2t
X-Received: by 2002:a5d:47c4:: with SMTP id o4mr2910655wrc.138.1616585080069;
        Wed, 24 Mar 2021 04:24:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzISiGwzhOJ3OFW1AOV7TUCEjxSzOLMAw0VEpovQznGB5jkO7qA6BNwL6xgIZ4D1NB0cUGCFQ==
X-Received: by 2002:a5d:47c4:: with SMTP id o4mr2910626wrc.138.1616585079801;
        Wed, 24 Mar 2021 04:24:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id s9sm2306712wmh.31.2021.03.24.04.24.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 04:24:38 -0700 (PDT)
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
To:     Kai Huang <kai.huang@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
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
 <YFoVmxIFjGpqM6Bk@google.com> <20210323163258.GC4729@zn.tnic>
 <b35f66a10ecc07a1eecb829912d5664886ca169b.camel@intel.com>
 <236c0aa9-92f2-97c8-ab11-d55b9a98c931@redhat.com>
 <20210324234839.bf5bef54fd7a84030cf1bcf8@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <da541070-e884-4f97-531d-d97409a42e02@redhat.com>
Date:   Wed, 24 Mar 2021 12:24:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210324234839.bf5bef54fd7a84030cf1bcf8@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/03/21 11:48, Kai Huang wrote:
>>> +/* Error message for EREMOVE failure, when kernel is about to leak EPC page */
>>> +#define EREMOVE_ERROR_MESSAGE \
>>> +       "EREMOVE returned %d (0x%x), kernel bug likely.  EPC page leaked, SGX may become
>>> unusuable.  Please refer to Documentation/x86/sgx.rst for more information."
>> Rewritten:
>>
>> EREMOVE returned %d and an EPC page was leaked; SGX may become unusable.
>> This is a kernel bug, refer to Documentation/x86/sgx.rst for more information.
> Fine to me, although this would have %d (0x%x) -> %d change in the code.
> 

Yeah you can of course keep the 0x%x part.

Paolo

