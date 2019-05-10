Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3301C1A5A2
	for <lists+kvm@lfdr.de>; Sat, 11 May 2019 01:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfEJXwS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 May 2019 19:52:18 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43958 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbfEJXwS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 May 2019 19:52:18 -0400
Received: by mail-pf1-f194.google.com with SMTP id c6so3992248pfa.10
        for <kvm@vger.kernel.org>; Fri, 10 May 2019 16:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ONLn5hyzXh34P88pwk+qOsuV8W3xIEYUXnBtk6FqORM=;
        b=aL/oXWGLu6uoiK9oGjtovc5GqKgkn1Ur5iFlriUPGf1kA3JWwhJU5topfnJirWODnI
         of9PtnmV1Zg8eBPSDI5K8EGYZfm2R7G3ec0l46I4m+9KHalBSIaVFtG06DaF7EWTvnzd
         gwS/rhNoGFfvPtvhQFa/s2cfbG4UTOss1UAyXwFz5Fh0qtM52dSvPMAMReFImOfmBvid
         g7vdF522QuhmJQ0GuUntJ5LBlOz7kzfHNK1IiX6PbcEsRadUvRilKFgZaic3qSruveEr
         EBSyB0sPtPO5eCC2VemuxynVy9BdQMuNvpikcj5aQvH6XRyuqRNHdrCPZD0KfOD5Wwa7
         rkeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ONLn5hyzXh34P88pwk+qOsuV8W3xIEYUXnBtk6FqORM=;
        b=B2lWOCilj6uluYuhG3yMH61q8h6+Js1l2VGOyEQ3tloh7L6qRvSdvsA73Bt4FNLLCK
         hlbh3pWU1vxW3sFd6rXiXmXfVc5e6TZFxt+WHV9rbyFoVFDncPXPGMFFQTcKCoXoIDLw
         JXFKcfMUwKC5slmqKW3Ihv9Cla+PeNY6HjEQ8750FblEIHS1XcRDc6B06N0+Eg/iTs8Z
         2UDw6aYHQ80IFc5hnb4WosR1YzlLT3rhnFIOsz6nO2x2GJeIAJG0WrPaE1flRAoxn7KL
         nyxZrwclxI0+UB7Ray7Y8t+xn5XT7dnybpAte1Hor13lTcDsR6Pkf1Z9zHPdKoDiaCu4
         y/JQ==
X-Gm-Message-State: APjAAAXg7S1eYYa9BDT1xYDgUY5McNyBtT0vXEScqJRRt9CRuNYXEabO
        F9mIvaCZWzOInBjCjDM6IQs=
X-Google-Smtp-Source: APXvYqxWk3hTJcWUKm2IXjq/9Jj5/DTmlD9iudsvUCURNG//To3jYvwEVkOehw2QZzm3hPYIM+rCCQ==
X-Received: by 2002:a65:6145:: with SMTP id o5mr16920225pgv.262.1557532337323;
        Fri, 10 May 2019 16:52:17 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id d186sm3521402pfd.183.2019.05.10.16.52.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 16:52:16 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [kvm-unit-tests PATCH] x86: Set "APIC Software Enable" after APIC
 reset
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <653454de-11d5-4341-940e-7fdfdd8545ae@oracle.com>
Date:   Fri, 10 May 2019 16:52:14 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <76866905-5211-45EF-8A77-4D5DB62D4010@gmail.com>
References: <20190502140856.4136-1-nadav.amit@gmail.com>
 <653454de-11d5-4341-940e-7fdfdd8545ae@oracle.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On May 10, 2019, at 4:37 PM, Krish Sadhukhan =
<krish.sadhukhan@oracle.com> wrote:
>=20
>=20
>=20
> On 05/02/2019 07:08 AM, nadav.amit@gmail.com wrote:
>> From: Nadav Amit <nadav.amit@gmail.com>
>>=20
>> After the APIC is reset, some of its registers might be reset. As the
>> SDM says: "When IA32_APIC_BASE[11] is set to 0, prior initialization =
to
>> the APIC may be lost and the APIC may return to the state described =
in
>> Section 10.4.7.1". The SDM also says that after APIC reset "the
>> spurious-interrupt vector register is initialized to 000000FFH". This
>> means that after the APIC is reset it needs to be software-enabled
>> through the SPIV.
>>=20
>> This is done one occasion, but there are (at least) two occasions =
that
>> do not software-enable the APIC after reset (__test_apic_id() and =
main()
>> in vmx.c).
>>=20
>> Move APIC SPIV reinitialization into reset_apic(). Remove SPIV =
settings
>> which are unnecessary after reset_apic() is modified.
>>=20
>> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>> ---
>>  lib/x86/apic.c | 1 +
>>  x86/apic.c     | 1 -
>>  2 files changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/lib/x86/apic.c b/lib/x86/apic.c
>> index 2aeffbd..4e7d43c 100644
>> --- a/lib/x86/apic.c
>> +++ b/lib/x86/apic.c
>> @@ -161,6 +161,7 @@ void reset_apic(void)
>>  {
>>      disable_apic();
>>      wrmsr(MSR_IA32_APICBASE, rdmsr(MSR_IA32_APICBASE) | APIC_EN);
>> +    apic_write(APIC_SPIV, 0x1ff);
>>  }
>>    u32 ioapic_read_reg(unsigned reg)
>> diff --git a/x86/apic.c b/x86/apic.c
>> index 3eff588..7ef4a27 100644
>> --- a/x86/apic.c
>> +++ b/x86/apic.c
>> @@ -148,7 +148,6 @@ static void test_apic_disable(void)
>>      verify_disabled_apic_mmio();
>>        reset_apic();
>> -    apic_write(APIC_SPIV, 0x1ff);
>>      report("Local apic enabled in xAPIC mode",
>>  	   (rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) =3D=3D =
APIC_EN);
>>      report("CPUID.1H:EDX.APIC[bit 9] is set", cpuid(1).d & (1 << =
9));
>=20
> While you are at it, would you mind replacing "0xf0" with APIC_SPIV in =
enable_apic() also ?
>=20
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

Will do. Thanks.

