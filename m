Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2322E1875B9
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 23:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732841AbgCPWeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 18:34:09 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:60076 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732840AbgCPWeJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 18:34:09 -0400
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Mar 2020 18:34:07 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584398047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=0ePNtHrVhZr0mnBx/2XRCSUAuhkVoN8Lzr9FhAIeq5g=;
        b=ZFz/XuElDuvg7Ekr0U9sZtw0we46aPjVtVs8qMXLm4+w/pg0HThvQfUQRXhMfUu2XZXL8H
        OoXKDylAbKdQtDjsUfUME+xPL26DmbPWy5jUyh+RIoGHqPsdMy4+BOMhE/t1eRc6MMNzQd
        DTonpxitOHMXE4SxER9biT2pGfVNVDU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-PZst-SwSPcqvSnnNxdk48g-1; Mon, 16 Mar 2020 18:27:32 -0400
X-MC-Unique: PZst-SwSPcqvSnnNxdk48g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8FE6A800D50
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 22:27:31 +0000 (UTC)
Received: from [10.10.120.172] (ovpn-120-172.rdu2.redhat.com [10.10.120.172])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EF8FE60BEE;
        Mon, 16 Mar 2020 22:27:30 +0000 (UTC)
Subject: Re: [Patch v1] x86: Fix the logical destination mode test
Cc:     Marcelo Tosatti <mtosatti@redhat.com>, thuth@redhat.com,
        nilal@redhat.com
References: <1583795750-33197-1-git-send-email-nitesh@redhat.com>
 <20200310140323.GA7132@fuller.cnet>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <4993e419-5eef-46ba-5dd0-e35c7103190b@redhat.com>
Date:   Mon, 16 Mar 2020 18:27:30 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200310140323.GA7132@fuller.cnet>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/10/20 10:03 AM, Marcelo Tosatti wrote:
> On Mon, Mar 09, 2020 at 07:15:50PM -0400, Nitesh Narayan Lal wrote:
>> There are following issues with the ioapic logical destination mode te=
st:
>>
>> - A race condition that is triggered when the interrupt handler
>> =C2=A0 ioapic_isr_86() is called at the same time by multiple vCPUs. D=
ue to this
>>   the g_isr_86 is not correctly incremented. To prevent this a spinloc=
k is
>>   added around =E2=80=98g_isr_86++=E2=80=99.
>>
>> - On older QEMU versions initial x2APIC ID is not set, that is why
>> =C2=A0 the local APIC IDs of each vCPUs are not configured. Hence the =
logical
>> =C2=A0 destination mode test fails/hangs. Adding =E2=80=98+x2apic=E2=80=
=99 to the qemu -cpu params
>> =C2=A0 ensures that the local APICs are configured every time, irrespe=
ctive of the
>> =C2=A0 QEMU version.
>>
>> - With =E2=80=98-machine kernel_irqchip=3Dsplit=E2=80=99 included in t=
he ioapic test
>> =C2=A0 test_ioapic_self_reconfigure() always fails and somehow leads t=
o a state where
>> =C2=A0 after submitting IOAPIC fixed delivery - logical destination mo=
de request we
>> =C2=A0 never receive an interrupt back. For now, the physical and logi=
cal destination
>> =C2=A0 mode tests are moved above test_ioapic_self_reconfigure().
>>
>> Fixes: b2a1ee7e ("kvm-unit-test: x86: ioapic: Test physical and logica=
l destination mode")
>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> Looks good to me.

Hi,

I just wanted to follow up and see if there are any more suggestions for =
me to
improve this patch before it can be merged.


>
>> ---
>>  x86/ioapic.c      | 11 +++++++----
>>  x86/unittests.cfg |  2 +-
>>  2 files changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/x86/ioapic.c b/x86/ioapic.c
>> index 742c711..3106531 100644
>> --- a/x86/ioapic.c
>> +++ b/x86/ioapic.c
>> @@ -432,10 +432,13 @@ static void test_ioapic_physical_destination_mod=
e(void)
>>  }
>> =20
>>  static volatile int g_isr_86;
>> +struct spinlock ioapic_lock;
>> =20
>>  static void ioapic_isr_86(isr_regs_t *regs)
>>  {
>> +	spin_lock(&ioapic_lock);
>>  	++g_isr_86;
>> +	spin_unlock(&ioapic_lock);
>>  	set_irq_line(0x0e, 0);
>>  	eoi();
>>  }
>> @@ -501,6 +504,10 @@ int main(void)
>>  	test_ioapic_level_tmr(true);
>>  	test_ioapic_edge_tmr(true);
>> =20
>> +	test_ioapic_physical_destination_mode();
>> +	if (cpu_count() > 3)
>> +		test_ioapic_logical_destination_mode();
>> +
>>  	if (cpu_count() > 1) {
>>  		test_ioapic_edge_tmr_smp(false);
>>  		test_ioapic_level_tmr_smp(false);
>> @@ -508,11 +515,7 @@ int main(void)
>>  		test_ioapic_edge_tmr_smp(true);
>> =20
>>  		test_ioapic_self_reconfigure();
>> -		test_ioapic_physical_destination_mode();
>>  	}
>> =20
>> -	if (cpu_count() > 3)
>> -		test_ioapic_logical_destination_mode();
>> -
>>  	return report_summary();
>>  }
>> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
>> index f2401eb..d658bc8 100644
>> --- a/x86/unittests.cfg
>> +++ b/x86/unittests.cfg
>> @@ -46,7 +46,7 @@ timeout =3D 30
>>  [ioapic]
>>  file =3D ioapic.flat
>>  smp =3D 4
>> -extra_params =3D -cpu qemu64
>> +extra_params =3D -cpu qemu64,+x2apic
>>  arch =3D x86_64
>> =20
>>  [cmpxchg8b]
>> --=20
>> 1.8.3.1


--=20
Nitesh

