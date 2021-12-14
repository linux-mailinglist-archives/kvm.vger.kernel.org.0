Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38B4474037
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 11:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbhLNKQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 05:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232921AbhLNKQT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 05:16:19 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F1CC061574;
        Tue, 14 Dec 2021 02:16:18 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id r25so60734072edq.7;
        Tue, 14 Dec 2021 02:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=445u48yHpxCOH4+r5sFhiE6WEBZ/71ccqyhWQWuVdis=;
        b=RCDvl+K1uMHvEyXw+Z4wTHm9twKhDwMHxW+HSfvYuOmwswM2jojklyv5vgszCrnLXH
         MIQOBQV+d6FrsOKoSWe/SmLZ8V/M9nSoDdQAetx8v5Zk+CalB93A3qE8b5Bi8Y6LyvkN
         d32jRQE9OteTLLV3bXqwN/GCOWYiDGzIkwxr+AZAAtDu5r5otmm5aLksC9pBSYI7Ia7g
         I+fq37W7x9phzWhQV6cDtrY85t0/UdUeh8nsjsmuA7z32pDK3lCWVqKymtT27So5azKS
         VGnN23EBVDagEZfshh5NmbsaArPgShgWPWfu2dy41mpXPAh6kbuerOlp/ol3RHckd3B3
         mE5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=445u48yHpxCOH4+r5sFhiE6WEBZ/71ccqyhWQWuVdis=;
        b=fCsSnK157sEBP/4YwUXuuMprWaXfpX3ZHVOFQjzxwjSUrMuBUJZooznlLxSS1+Ez+u
         EHw+6O6yFGH3MW2snCcrIUlPHgOFOFpw5ETq7pPhTZioV7xKhvYqdnchwwI90mhLOuvU
         EZUGnU+OI8XW33VDY48Gib5ztujkdVWMSJ9n4NoFHPlCQ3Q7c2XlpAo2v0hH1UdmLxVL
         i3a/Lxjb5cTKbmj3ACt0joh8og9q7u9cOm88z9EftzjozygF5/NEnrdrmWoK/WsWzf4M
         56/v0+VdjkW1F899OMz82Bug7Wlr2xiNSdJsg9mOWX29d3BdKkucmIS4FfNMNAaIFAeZ
         iT3A==
X-Gm-Message-State: AOAM530NF3FDwPdlPX3ub4iLuAR0/HwapKY4jzSu4EiogrsvibaXS+/F
        jPRO5XxqjdJaDi4+561/21I=
X-Google-Smtp-Source: ABdhPJwCA7dHJHDuJN80UV6qEdk9L1LwvE6ogZ1hYfSQHxhqq71VuvnIgHEvMp8lcXOQ0pp1UbVlwg==
X-Received: by 2002:aa7:d445:: with SMTP id q5mr6459659edr.330.1639476976729;
        Tue, 14 Dec 2021 02:16:16 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id cy26sm7583824edb.7.2021.12.14.02.16.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 02:16:16 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <d513db49-bb94-becf-be7e-f26dceb3e1bf@redhat.com>
Date:   Tue, 14 Dec 2021 11:16:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 09/19] kvm: x86: Prepare reallocation check
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Cc:     "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-10-yang.zhong@intel.com>
 <fc113a81-b5b8-aaae-5799-c6d49b77b2b4@redhat.com>
 <BN9PR11MB5276416CED5892C20F56EB888C759@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <BN9PR11MB5276416CED5892C20F56EB888C759@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/21 08:06, Tian, Kevin wrote:
>> - if (dynamic_enabled & ~guest_fpu->user_perm) != 0, then this is a
>> userspace error and you can #GP the guest without any issue.  Userspace
>> is buggy
>
> Is it a general guideline that an error caused by emulation itself (e.g.
> due to no memory) can be reflected into the guest as #GP, even
> when from guest p.o.v there is nothing wrong with its setting?

No memory is a tricky one, if possible it should propagate -ENOMEM up to 
KVM_RUN or KVM_SET_MSR.  But it's basically an impossible case anyway, 
because even with 8K TILEDATA we're within the limit of 
PAGE_ALLOC_COSTLY_ORDER.

So, since it's not easy to do it right now, we can look at it later.

Paolo
