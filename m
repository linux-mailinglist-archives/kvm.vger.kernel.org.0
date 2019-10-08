Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCE3CF958
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 14:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730371AbfJHMKe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 08:10:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39490 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730156AbfJHMKe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 08:10:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570536632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=pngQ0vwHVB56h/jobOl8iouR8Lzdwz4DFAHZIXz1YJo=;
        b=UkQjRS7aB8zw6MEgrXLOpBMLzvwnCDbVXiorGym+Y0DTbKrxXPpGluipG2uUp3hjvRk5hc
        fqkiTZV6jvsTRwom0RTnTS5ZeBM58jJIvr2g+bo+jRP4/7lStedBAAx4y6Hqhhm4yS4uTJ
        5slqSBXteySbIX5bc9pTmVubZ3X0Zwk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-CyZoRcJnMb2E4OWrnyF2uQ-1; Tue, 08 Oct 2019 08:10:30 -0400
Received: by mail-wr1-f72.google.com with SMTP id i10so9041350wrb.20
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 05:10:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6zMWnhWUQlj0aSCWVdOWXNohTjSq/qy2IgKHvwvSv6M=;
        b=RFm+eGQCIiHJWSbrzds9t3n80fswNAgILgZorNbeWDZEh9lUBQTCGx7vRH0HpJWHvE
         xXCmz3OBFmhTvlBxE8TrHmaPIRlQpTeTk/Z7O3I0jl64oXivjSj3eQtiBNcTuOyYk43q
         6NZvaMeX1163PXhhKoFE3NpX/MEPlO6WfqmHswiA4aO4FXnBJv9QP9S3w+dN1ZZs3EYc
         bPzzKQPMkP0MEoCWKdt0rx0LWJsfDHzmCat8adFjt0B1yfmq1bNHgs5SY6HwzS6QuuFM
         azDu4DQPWeNEMGPzTR3nH7kjJ4oCcilmiGhGd+Qwl/bYrfy8RXJzbGS1iGucDi4Q+hek
         xaBA==
X-Gm-Message-State: APjAAAVbcBXwQtEZX830zRGHPPralZGr2jQEJPiimw8S5QqiS3eMzwio
        GwA59KZ0VXIoov3cYO/Us1wWcHpvb6r5CkXS5bAFvC/slrE/etYpTY0xHWFDQ28xwv6dex/sEm8
        g5/LMroFNDvFe
X-Received: by 2002:a1c:1901:: with SMTP id 1mr2494010wmz.28.1570536628850;
        Tue, 08 Oct 2019 05:10:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzS+xoZ+p7rS9V/Q9VUd/XL5bzTicr9GTRAH6vK1bW+xoTMaNGSPtSMQd0s4oZVraMk3qMbvA==
X-Received: by 2002:a1c:1901:: with SMTP id 1mr2493988wmz.28.1570536628558;
        Tue, 08 Oct 2019 05:10:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c419:feee:57d:5b72? ([2001:b07:6468:f312:c419:feee:57d:5b72])
        by smtp.gmail.com with ESMTPSA id m62sm2589238wmm.35.2019.10.08.05.10.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2019 05:10:28 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] vmexit: measure IPI and EOI cost
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     kvm <kvm@vger.kernel.org>
References: <1570116271-8038-1-git-send-email-pbonzini@redhat.com>
 <CANRm+Cz21QqUjoDMtj5Os0s63gJqL2LtCwVPdEsqGhuX=9Am7A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <dd7aa6e6-e4ef-7c71-3a9e-c51c7ab563e9@redhat.com>
Date:   Tue, 8 Oct 2019 14:10:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CANRm+Cz21QqUjoDMtj5Os0s63gJqL2LtCwVPdEsqGhuX=9Am7A@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: CyZoRcJnMb2E4OWrnyF2uQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/10/19 05:32, Wanpeng Li wrote:
> On Fri, 4 Oct 2019 at 00:00, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  x86/vmexit.c | 16 ++++++++++++++++
>>  1 file changed, 16 insertions(+)
>>
>> diff --git a/x86/vmexit.c b/x86/vmexit.c
>> index 66d3458..81b743b 100644
>> --- a/x86/vmexit.c
>> +++ b/x86/vmexit.c
>> @@ -65,22 +65,30 @@ static void nop(void *junk)
>>  }
>>
>>  volatile int x =3D 0;
>> +volatile uint64_t tsc_eoi =3D 0;
>> +volatile uint64_t tsc_ipi =3D 0;
>>
>>  static void self_ipi_isr(isr_regs_t *regs)
>>  {
>>         x++;
>> +       uint64_t start =3D rdtsc();
>>         eoi();
>> +       tsc_eoi +=3D rdtsc() - start;
>>  }
>>
>>  static void x2apic_self_ipi(int vec)
>>  {
>> +       uint64_t start =3D rdtsc();
>>         wrmsr(0x83f, vec);
>> +       tsc_ipi +=3D rdtsc() - start;
>>  }
>>
>>  static void apic_self_ipi(int vec)
>>  {
>> +       uint64_t start =3D rdtsc();
>>          apic_icr_write(APIC_INT_ASSERT | APIC_DEST_SELF | APIC_DEST_PHY=
SICAL |
>>                        APIC_DM_FIXED | IPI_TEST_VECTOR, vec);
>> +       tsc_ipi +=3D rdtsc() - start;
>>  }
>>
>>  static void self_ipi_sti_nop(void)
>> @@ -180,7 +188,9 @@ static void x2apic_self_ipi_tpr_sti_hlt(void)
>>
>>  static void ipi(void)
>>  {
>> +       uint64_t start =3D rdtsc();
>>         on_cpu(1, nop, 0);
>> +       tsc_ipi +=3D rdtsc() - start;
>>  }
>>
>>  static void ipi_halt(void)
>> @@ -511,6 +521,7 @@ static bool do_test(struct test *test)
>>         }
>>
>>         do {
>> +               tsc_eoi =3D tsc_ipi =3D 0;
>>                 iterations *=3D 2;
>>                 t1 =3D rdtsc();
>>
>> @@ -523,6 +534,11 @@ static bool do_test(struct test *test)
>>                 t2 =3D rdtsc();
>>         } while ((t2 - t1) < GOAL);
>>         printf("%s %d\n", test->name, (int)((t2 - t1) / iterations));
>> +       if (tsc_ipi)
>> +               printf("  ipi %s %d\n", test->name, (int)(tsc_ipi / iter=
ations));
>> +       if (tsc_eoi)
>> +               printf("  eoi %s %d\n", test->name, (int)(tsc_eoi / iter=
ations));
>> +
>>         return test->next;
>>  }
>=20
> Thanks for this, do you have more idea to optimize the virtual ipi latenc=
y?

I haven't thought about it recently; this was a patch I had written
years ago and I randomly found on my computer. :)

Paolo

