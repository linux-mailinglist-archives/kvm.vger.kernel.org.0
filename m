Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42618B790E
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 14:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390249AbfISMNZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 08:13:25 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32933 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390230AbfISMNV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Sep 2019 08:13:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1568895201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=8upZbcqH4fXkVaLOW2dy/iZBybRVQ5oETpjiRcdE6KE=;
        b=QWjYt6kTT6NQgAI1P4uYQDm5I9Nn3Fj1EomjQvhktvUQ1oqmZs/ZueRQwj5Yg9yFHRdvY7
        6kzfRF/Na4g68q3sJ84+aFbOiuhcnf1VcV2SbJ6Ik7u4Htxg/v/ci+LnaUYqFKpSzTGDg3
        LJFtORYlZT8ho7vCf2Kn/QvWjMYDA5A=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-jB-hXzOSN-irNuYIzxjtcA-1; Thu, 19 Sep 2019 08:13:18 -0400
Received: by mail-wm1-f69.google.com with SMTP id f10so1486991wmh.8
        for <kvm@vger.kernel.org>; Thu, 19 Sep 2019 05:13:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8upZbcqH4fXkVaLOW2dy/iZBybRVQ5oETpjiRcdE6KE=;
        b=gBXoIA+Lwe5qnGkC1R5Y9fh9epZ6oweuezUnXi6p8V738FWJS6hi8a0RcIPTMMwHa+
         1cX5ymc7BraWCq+2MP3JLSTVRjEO/tNsSmUk3RcAPtJY/Rno6927BE3VlquL9um1QXaB
         0Lac6/qMO4kRlsx0wkAwV8fhL7bN1p3nx1/Kiz1+R54ljIK05svtAKFbE8wKo9G9xvPv
         Z8FW1uAfwQW4lYkIPNCP9DSRNmMG6gjngPxIf/Uv0N8cYlW9TBmwWnIK5IAFvotoAEPY
         h8D6KIpJx/zwTt2jgkO+Xx/JUgU7Ok0kLvp7vY1jvyRTLlI/vt5vp2jz0DBwr0VyIveh
         Eayw==
X-Gm-Message-State: APjAAAUnnimwcQye0IAeAFp7IEqoSk8sfMl/sW6x7tvmF6rDCfKucJn7
        ZnotcEasKzscwU9yHvs9POOO3Rb0HRMPuwz2CuCOZsPZtumaZq2IfGMyyF1mnDJF6KsnLtw1JdW
        fUcvZVGuZfjFb
X-Received: by 2002:a5d:6088:: with SMTP id w8mr6995248wrt.31.1568895197143;
        Thu, 19 Sep 2019 05:13:17 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyoqc728vUxzk+PlHiWZtsz6cgGkTTAs+KWHYRvgq+doGCowWOVSB7hkXrBEQJmElppYJsNwA==
X-Received: by 2002:a5d:6088:: with SMTP id w8mr6995221wrt.31.1568895196846;
        Thu, 19 Sep 2019 05:13:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c46c:2acb:d8d2:21d8? ([2001:b07:6468:f312:c46c:2acb:d8d2:21d8])
        by smtp.gmail.com with ESMTPSA id x6sm7878924wmf.38.2019.09.19.05.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Sep 2019 05:13:16 -0700 (PDT)
Subject: Re: [RFC PATCH v3 4/6] psci: Add hvc call service for ptp_kvm.
To:     Marc Zyngier <maz@kernel.org>,
        "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>,
        nd <nd@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <20190918080716.64242-1-jianyong.wu@arm.com>
 <20190918080716.64242-5-jianyong.wu@arm.com>
 <83ed7fac-277f-a31e-af37-8ec134f39d26@redhat.com>
 <HE1PR0801MB1676F57B317AE85E3B934B32F48E0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <629538ea-13fb-e666-8df6-8ad23f114755@redhat.com>
 <HE1PR0801MB167639E2F025998058A77F86F4890@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <ef6ab8bd-41ad-88f8-9cfd-dc749ca65310@redhat.com>
 <a1b554b8-4417-5305-3419-fe71a8c50842@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <56a5b885-62c8-c4ef-e2f8-e945c0eb700e@redhat.com>
Date:   Thu, 19 Sep 2019 14:13:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <a1b554b8-4417-5305-3419-fe71a8c50842@kernel.org>
Content-Language: en-US
X-MC-Unique: jB-hXzOSN-irNuYIzxjtcA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/09/19 13:39, Marc Zyngier wrote:
>> I don't think it's ugly but more important, using tk->tkr_mono.clock is
>> incorrect.  See how the x86 code hardcodes &kvm_clock, it's the same for
>> ARM.
> Not really. The guest kernel is free to use any clocksource it wishes.

Understood, in fact it's the same on x86.

However, for PTP to work, the cycles value returned by the clocksource
must match the one returned by the hypercall.  So for ARM
get_device_system_crosststamp must receive the arch timer clocksource,
so that it will return -ENODEV if the active clocksource is anything else.

Paolo

> In some cases, it is actually desirable (like these broken systems that
> cannot use an in-kernel irqchip...). Maybe it is that on x86 the guest
> only uses the kvm_clock, but that's a much harder sell on ARM. The fact
> that ptp_kvm assumes that the clocksource is fixed doesn't seem correct
> in that case.

