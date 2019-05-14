Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 582081C042
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 03:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfENBGq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 21:06:46 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41934 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbfENBGp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 21:06:45 -0400
Received: by mail-pl1-f193.google.com with SMTP id f12so5312591plt.8
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 18:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=AjMdc5Ivwa9D5/q+mpDD9LTQQ65QClF6sxVL+Y7KREE=;
        b=ZtDmYPHgtWCmGvxlCHhmBjXcPjLuyhiyJI4nmyGQ4G68+KmfS13NuZcQSToo2CDBCA
         rrDnT7cVXn45h3JBYwKrnaWbJKmQpLtXWuS5H4o1Nwj98Q6uTIgLDnig3AnbrvK/bp1C
         yETLEv5+fVVfHKQ16Bql02++WfVqxWviAbXGnWZjEAjquSQmmAYjXGx/V/yGMl/eLxet
         XF7irGuxpPAPN6v5iFPTBtlePHR6JVBWsWapRUJYkaYOEjtbLB2ICXQRCW750SOSSB2H
         3OlgFITdlpFvUuh8JXZYoB8Bm9oJSv3jDs2dAX6gMRSBy70d+CMTrL1Gv0/2if/5lJ8A
         1HjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=AjMdc5Ivwa9D5/q+mpDD9LTQQ65QClF6sxVL+Y7KREE=;
        b=Qreu72NWpzN+MGTkqqD1pZE+HfA4oXHoUgHx4a4bK0EvAPw/5+VfStjRTZ/tsBigQz
         Bv3cqlnjwsjo8onoQKu3MLJZGU2vGs9TJtq1K+nGT3ca4EfzSC7DKwId5cjHvHgvlYNK
         4dWt7OBtK6SnnqgxFzW20Reu7k3AA8EKCantYq+1w1Bo4+I7VDbJiQ4quRhOTu/GItJo
         fBaGy7Hd20Hn1Mg3bRmWeI59OjaZH+Lht0AZCpepWfQrCfuC4fgosvmunlYaXgjeGxnw
         pE8RiInVsJSIYY1L9ccdJGQ/aKn0ZZt+JhwKtmXsoZUJQkfQVnB7oLWKF0Xt8fJn/7sO
         IohA==
X-Gm-Message-State: APjAAAX2mIpON6X6keL0bAOBHchDE38ET57t4WozMjRbEXPRLmzV9ZB8
        Cr60VIiuPcppAv6uMtJCnzXRwzAUCKQ=
X-Google-Smtp-Source: APXvYqyICkHGoKf9mTzQrrTwLM5A6tQ6zC2SZmi2GUTuaM7Ft1VcVT5jfYd+/IoIVp+zLY26sKdQWw==
X-Received: by 2002:a17:902:aa5:: with SMTP id 34mr34978318plp.263.1557796004705;
        Mon, 13 May 2019 18:06:44 -0700 (PDT)
Received: from [10.21.20.225] (50-204-119-4-static.hfc.comcastbusiness.net. [50.204.119.4])
        by smtp.gmail.com with ESMTPSA id k7sm17308810pfk.93.2019.05.13.18.06.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 18:06:43 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [kvm-unit-tests PATCH] x86: Set "APIC Software Enable" after APIC
 reset
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <76866905-5211-45EF-8A77-4D5DB62D4010@gmail.com>
Date:   Mon, 13 May 2019 18:06:39 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <2ADA443D-02FD-48A4-8BC9-7392A18CD2EF@gmail.com>
References: <20190502140856.4136-1-nadav.amit@gmail.com>
 <653454de-11d5-4341-940e-7fdfdd8545ae@oracle.com>
 <76866905-5211-45EF-8A77-4D5DB62D4010@gmail.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On May 10, 2019, at 4:52 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
>> On May 10, 2019, at 4:37 PM, Krish Sadhukhan =
<krish.sadhukhan@oracle.com> wrote:
>>=20
>>=20
>>=20
>> On 05/02/2019 07:08 AM, nadav.amit@gmail.com wrote:
>>> From: Nadav Amit <nadav.amit@gmail.com>
>>>=20
>>> After the APIC is reset, some of its registers might be reset. As =
the
>>> SDM says: "When IA32_APIC_BASE[11] is set to 0, prior initialization =
to
>>> the APIC may be lost and the APIC may return to the state described =
in
>>> Section 10.4.7.1". The SDM also says that after APIC reset "the
>>> spurious-interrupt vector register is initialized to 000000FFH". =
This
>>> means that after the APIC is reset it needs to be software-enabled
>>> through the SPIV.
>>>=20
>>> This is done one occasion, but there are (at least) two occasions =
that
>>> do not software-enable the APIC after reset (__test_apic_id() and =
main()
>>> in vmx.c).
>>>=20
>>> Move APIC SPIV reinitialization into reset_apic(). Remove SPIV =
settings
>>> which are unnecessary after reset_apic() is modified.
>>>=20
>>> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
>>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>>> ---
>>> lib/x86/apic.c | 1 +
>>> x86/apic.c     | 1 -
>>> 2 files changed, 1 insertion(+), 1 deletion(-)
>>>=20
>>> diff --git a/lib/x86/apic.c b/lib/x86/apic.c
>>> index 2aeffbd..4e7d43c 100644
>>> --- a/lib/x86/apic.c
>>> +++ b/lib/x86/apic.c
>>> @@ -161,6 +161,7 @@ void reset_apic(void)
>>> {
>>>     disable_apic();
>>>     wrmsr(MSR_IA32_APICBASE, rdmsr(MSR_IA32_APICBASE) | APIC_EN);
>>> +    apic_write(APIC_SPIV, 0x1ff);
>>> }
>>>   u32 ioapic_read_reg(unsigned reg)
>>> diff --git a/x86/apic.c b/x86/apic.c
>>> index 3eff588..7ef4a27 100644
>>> --- a/x86/apic.c
>>> +++ b/x86/apic.c
>>> @@ -148,7 +148,6 @@ static void test_apic_disable(void)
>>>     verify_disabled_apic_mmio();
>>>       reset_apic();
>>> -    apic_write(APIC_SPIV, 0x1ff);
>>>     report("Local apic enabled in xAPIC mode",
>>> 	   (rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) =3D=3D =
APIC_EN);
>>>     report("CPUID.1H:EDX.APIC[bit 9] is set", cpuid(1).d & (1 << =
9));
>>=20
>> While you are at it, would you mind replacing "0xf0" with APIC_SPIV =
in enable_apic() also ?
>>=20
>> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>=20
> Will do. Thanks.

Actually, adding write to APIC_SPIV to reset_apic() was wrong. I=E2=80=99l=
l send a
fixed version later that just modifies the places where APIC_SPIV should =
be
reset.

