Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1385A146526
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 10:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgAWJyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 04:54:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31418 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726103AbgAWJya (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 04:54:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579773269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JdY/01YnxgEcf8jBEhI8KPQzD/6+XrjHVp2ZZDmVmCk=;
        b=LHNQSCBYIuzDd4nMLaVBvJbdcJsK/v8i2iYh2URjlVKPWS2HRFiSuBIl4/i/PA3qDrGimP
        +uAH0gy4Ht3/rvD7Vse9wJaWQyqOwCHCXgyVDW+sOqTAKYpci5jUaBraKeEHr2rRgJJqNJ
        cG4V7HWCwvzpmN4yyEq3K0CirFourcQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-eluI9qwcPpureUx1GZ6MJw-1; Thu, 23 Jan 2020 04:54:27 -0500
X-MC-Unique: eluI9qwcPpureUx1GZ6MJw-1
Received: by mail-wr1-f71.google.com with SMTP id f17so1459740wrt.19
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 01:54:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JdY/01YnxgEcf8jBEhI8KPQzD/6+XrjHVp2ZZDmVmCk=;
        b=G7zEyhtFLJcT5CHytoa2Zcmou5iLK/rARYG+QBI1WqQ9QwB2RR5KYOlpMVjLmXli+s
         CeKDfb9h+GuW33GxbICR953E49ugAPT6Ep1wR0AFjEk3qSlDsC6r+lXo/YwQRy+kyJ4U
         d6HdSrgvfN/wNvF/1OotwLoQYDwybL2wdp5oGZxFLvKBPRe2v/aeayl0e8o7qpmDLyjQ
         IdazYIUGETkzsegOfnFK5lqcFktbL1JUl/EmWwJP7D3mrLmDlzrtEdfEm0+UKEyBG5Xv
         6aM4fhARzBhItBR8ohrNazjMphmEsoNz/bbdFV8vb4Nd/gTWKM+dmHUoZq/Jpv8mYS5S
         /vug==
X-Gm-Message-State: APjAAAWN8wmvGYpgjOrWjnlajBqgc0F0CmUxwBTbFs6q1IjYCK2MKvEc
        Lr8MK3KRyYP97XvX4Zv8g5oE6yp32GoAeuVlDOpgqSDFtv1FbgxBofYE/tBbh+kqFpp4EMO5Lyr
        b/Npi7gUF32Ed
X-Received: by 2002:adf:d183:: with SMTP id v3mr17317241wrc.180.1579773266284;
        Thu, 23 Jan 2020 01:54:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqyAtrBi9gbReQo2xoYrZX95q69/GNjES5FxPk/zX0+P2S8Pau4UYtndwwrsnAMcOxolIcX0Xg==
X-Received: by 2002:adf:d183:: with SMTP id v3mr17317202wrc.180.1579773266023;
        Thu, 23 Jan 2020 01:54:26 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id c9sm2166949wme.41.2020.01.23.01.54.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 01:54:25 -0800 (PST)
Subject: Re: [PATCH] KVM: nVMX: set rflags to specify success in
 handle_invvpid() default case
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
References: <1579749241-712-1-git-send-email-linmiaohe@huawei.com>
 <8736c6sga7.fsf@vitty.brq.redhat.com>
 <1a083ac8-3b01-fd2d-d867-2b3956cdef6d@redhat.com>
 <87wo9iqzfa.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ee7d815f-750f-3d0e-2def-1631be66a483@redhat.com>
Date:   Thu, 23 Jan 2020 10:54:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <87wo9iqzfa.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/01/20 10:45, Vitaly Kuznetsov wrote:
>>> SDM says that "If an
>>> unsupported INVVPID type is specified, the instruction fails." and this
>>> is similar to INVEPT and I decided to check what handle_invept()
>>> does. Well, it does BUG_ON(). 
>>>
>>> Are we doing the right thing in any of these cases?
>>
>> Yes, both INVEPT and INVVPID catch this earlier.
>>
>> So I'm leaning towards not applying Miaohe's patch.
> 
> Well, we may at least want to converge on BUG_ON() for both
> handle_invvpid()/handle_invept(), there's no need for them to differ.

WARN_ON_ONCE + nested_vmx_failValid would probably be better, if we
really want to change this.

Paolo

