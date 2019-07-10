Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9488964B32
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 19:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfGJRGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 13:06:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53880 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbfGJRGg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 13:06:36 -0400
Received: by mail-wm1-f65.google.com with SMTP id x15so3052135wmj.3
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2019 10:06:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SuU894j2CqbQVv4bnyUW2+R4vG8fuhuKA/J00hF+rLg=;
        b=MnPwFTn+EjwLkW8QzupbTtEhwTLORHwyO/T3JPWYO8TSAbNC3i+EAPHXMJF8HM5E2C
         heYgHS+56aBfdXtYCoGX8aZyHqXyMWlh50VTCxikQDf4KFGLktVk4OC/7f1YC0nAxDQ8
         TfwyAG6pzCnU8GPF0bitujp+F6femJQWBn/VxefInB8dgI7zo4tsO8Yau/RFwFEX6f5c
         qpzlhZXE4ulAqhCGs2VD5+UQqqqJjWa/E9vdkULaVjb4gRJFu+lTBTEkiaJj+MU4gjbS
         Jek11BxK3SVGCJ++0sgXKfvhKACKlAKKzX5cMrKGCqD9BjCv9io3zY1VctV+Mh58NbrY
         keLg==
X-Gm-Message-State: APjAAAXREc9NfbBI44X7DFB0mmBmrVakrpTK9SZWmttiLYntVy5r3IK0
        0XlJ/G5MgYj+SuVve/XFIFMF3g==
X-Google-Smtp-Source: APXvYqxb+rtpI9aVwVTc6cdO7+RFuhsGOwpHABF0Jid8dPtXLKobZgZewcHJIAdGJh1w9sh7/ty/zA==
X-Received: by 2002:a1c:a01a:: with SMTP id j26mr6345399wme.112.1562778394142;
        Wed, 10 Jul 2019 10:06:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab? ([2001:b07:6468:f312:d066:6881:ec69:75ab])
        by smtp.gmail.com with ESMTPSA id b203sm3130748wmd.41.2019.07.10.10.06.33
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 10:06:33 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] arm: Add PL031 test
To:     Andre Przywara <andre.przywara@arm.com>,
        Alexander Graf <graf@amazon.com>
Cc:     kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        kvmarm@lists.cs.columbia.edu
References: <20190710132724.28350-1-graf@amazon.com>
 <20190710180235.25c54b84@donnerap.cambridge.arm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <35e19306-d31b-187b-185d-e783f8d5a51a@redhat.com>
Date:   Wed, 10 Jul 2019 19:06:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190710180235.25c54b84@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/07/19 19:02, Andre Przywara wrote:
>> + * This test verifies whether the emulated PL031 behaves
>> correctly.
> ^^^^^^^^
> 
> While I appreciate the effort and like the fact that this actually
> triggers an SPI, I wonder if this actually belongs into
> kvm-unit-tests. After all this just test a device purely emulated in
> (QEMU) userland, so it's not really KVM related.
> 
> What is the general opinion on this? Don't we care about this
> hair-splitting as long as it helps testing? Do we even want to extend
> kvm-unit-tests coverage to more emulated devices, for instance
> virtio?

I agree that it would belong more in qtest, but tests in not exactly the
right place is better than no tests.

Paolo
