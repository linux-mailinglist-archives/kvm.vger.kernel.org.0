Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB09B87718
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 12:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406167AbfHIKSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 06:18:12 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:47046 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406160AbfHIKSM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 06:18:12 -0400
Received: by mail-wr1-f66.google.com with SMTP id z1so97732972wru.13
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2019 03:18:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cuVKDc0uavb8FjLQUAtTTA5OlojkA129esFBNoztMxo=;
        b=X0thpVHnFT+w9b+QtIZ+D4yHmZGxNPCfiH3doopAM1RaGNiRRPlmlkHUNV2zl8x0HO
         snzvfbSP8uw4ntGRM59gQivoKQwq/B2LpEw87GUO+GGBRExSQ/aUGsX1IEXAaHUn80cv
         KK//94myn2Qaezu/g9c0zX1P3TQ3x0XSeBF3T/9wFlupAeTMn1jQMyd5MHCqJzHATKpu
         IqZxxPOEebGZeNeIwvIzNnuoquOhVAzCenWUPk3fXmmJE0VPO3GVWV5irX814pNzaX37
         kUFU/+TFOXlNhXvmw+QTKCR6vOEelbIhwzkwm8thQnbYEoSVFoi0pM5f9t4ZmQziLyv/
         J3og==
X-Gm-Message-State: APjAAAXz1rP8TyZBi/HNA7XKYdh4r8pxorYVs3rCImTZhMfGQ5Zc4FiK
        0lMBP16GmQZmjr7pbXnPap5S3A==
X-Google-Smtp-Source: APXvYqwGlQdoLBApaInPPRuk+HOjO5hFnd6m+xzhuho3EgmDFnNdQo4FMdSiYqdiHuankaDhNx4XOA==
X-Received: by 2002:adf:f744:: with SMTP id z4mr3790705wrp.211.1565345889872;
        Fri, 09 Aug 2019 03:18:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b42d:b492:69df:ed61? ([2001:b07:6468:f312:b42d:b492:69df:ed61])
        by smtp.gmail.com with ESMTPSA id y16sm209844185wrg.85.2019.08.09.03.18.09
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 03:18:09 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] selftests: kvm: Adding config fragments
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Shuah Khan <shuah@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        sean.j.christopherson@intel.com,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, kvm list <kvm@vger.kernel.org>,
        Dan Rue <dan.rue@linaro.org>
References: <20190809072415.29305-1-naresh.kamboju@linaro.org>
 <0a0e0563-aba7-e59c-1fbd-547126d404ed@redhat.com>
 <CA+G9fYt4QPjHtyoZUfe_tv+uT6yybHehymuDWBFHL-QH3K-PxA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <28a9ac44-7ae2-7892-4e68-59245b6dc27b@redhat.com>
Date:   Fri, 9 Aug 2019 12:18:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+G9fYt4QPjHtyoZUfe_tv+uT6yybHehymuDWBFHL-QH3K-PxA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/19 09:53, Naresh Kamboju wrote:
>> I think this is more complicated without a real benefit, so I'll merge v2.
> With the recent changes to 'kselftest-merge' nested configs also get merged.
> Please refer this below commit for more details.

Sure---both v2 and v3 work but this one adds more config files with
little benefit.

Paolo
