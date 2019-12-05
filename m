Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED7B113A5A
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 04:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbfLED2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 22:28:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31933 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728132AbfLED2V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 22:28:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575516499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp:autocrypt:autocrypt;
        bh=5rXDkwa1pKPwOp3k84tGGr+IGg9j4HXgJqyCzBqu+Ng=;
        b=ZXyHptZcYD5n4b5xNTxdsZ156snrDugKB0XI+7rljgqCDDwbnKFSCC0LNks+pd54XK/56V
        nIrVHP6bHT++dcpoRL2afLKfUm0GfJ8yNyNtz49dVKlNsfNrDjVVjHqI44sL3x1r2RBtfF
        bGMwaYsBPSw8kLVhrAO25Nn9b20F7Q4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-pHIEREgNPTaO6L0eaybjWA-1; Wed, 04 Dec 2019 22:28:16 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21614800EB8;
        Thu,  5 Dec 2019 03:28:15 +0000 (UTC)
Received: from [10.72.12.152] (ovpn-12-152.pek2.redhat.com [10.72.12.152])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A4AD1600D5;
        Thu,  5 Dec 2019 03:28:09 +0000 (UTC)
Subject: Re: [kvm-unit-tests Patch v1 2/2] x86: ioapic: Test physical and
 logical destination mode
To:     Christophe de Dinechin <christophe.de.dinechin@gmail.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com,
        mtosatti@redhat.com
References: <1573044429-7390-1-git-send-email-nitesh@redhat.com>
 <1573044429-7390-3-git-send-email-nitesh@redhat.com>
 <7hblsw8fji.fsf@crazypad.dinechin.lan>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <5fac8c7b-ddcd-de22-568d-bc7ab6c7c71f@redhat.com>
Date:   Wed, 4 Dec 2019 22:28:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <7hblsw8fji.fsf@crazypad.dinechin.lan>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: pHIEREgNPTaO6L0eaybjWA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 11/28/19 5:25 AM, Christophe de Dinechin wrote:
> Nitesh Narayan Lal writes:
>
>> This patch tests the physical destination mode by sending an
>> interrupt to one of the vcpus and logical destination mode by
>> sending an interrupt to more than one vcpus.
>>
>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>> ---
>>  x86/ioapic.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 65 insertions(+)
>>
>> diff --git a/x86/ioapic.c b/x86/ioapic.c
>> index c32dabd..31aec03 100644
>> --- a/x86/ioapic.c
>> +++ b/x86/ioapic.c
>> @@ -405,12 +405,73 @@ static void test_ioapic_self_reconfigure(void)
>>  	report("Reconfigure self", g_isr_84 == 1 && e.remote_irr == 0);
>>  }
>>
>> +static volatile int g_isr_85;
>> +
>> +static void ioapic_isr_85(isr_regs_t *regs)
>> +{
>> +	++g_isr_85;
>> +	set_irq_line(0x0e, 0);
>> +	eoi();
>> +}
>> +
>> +static void test_ioapic_physical_destination_mode(void)
>> +{
>> +	ioapic_redir_entry_t e = {
>> +		.vector = 0x85,
>> +		.delivery_mode = 0,
>> +		.dest_mode = 0,
>> +		.dest_id = 0x1,
>> +		.trig_mode = TRIGGER_LEVEL,
>> +	};
>> +	handle_irq(0x85, ioapic_isr_85);
>> +	ioapic_write_redir(0xe, e);
>> +	set_irq_line(0x0e, 1);
>> +	do {
>> +		pause();
>> +	} while(g_isr_85 != 1);
> Does this loop (and the next one) end up running forever if the test
> fails? Would it be worth adding some timeout to detect failure?

AFAIK there is already a timeout in place. i.e., if we don't receive an
interrupt then eventually the timeout will occur and the test will terminate.

>
>> +	report("ioapic physical destination mode", g_isr_85 == 1);
>> +}
>> +
>> +static volatile int g_isr_86;
>> +
>> +static void ioapic_isr_86(isr_regs_t *regs)
>> +{
>> +	++g_isr_86;
>> +	set_irq_line(0x0e, 0);
>> +	eoi();
>> +}
>> +
>> +static void test_ioapic_logical_destination_mode(void)
>> +{
>> +	/* Number of vcpus which are configured/set in dest_id */
>> +	int nr_vcpus = 3;
>> +	ioapic_redir_entry_t e = {
>> +		.vector = 0x86,
>> +		.delivery_mode = 0,
>> +		.dest_mode = 1,
>> +		.dest_id = 0xd,
>> +		.trig_mode = TRIGGER_LEVEL,
>> +	};
>> +	handle_irq(0x86, ioapic_isr_86);
>> +	ioapic_write_redir(0xe, e);
>> +	set_irq_line(0x0e, 1);
>> +	do {
>> +		pause();
>> +	} while(g_isr_86 < nr_vcpus);
>> +	report("ioapic logical destination mode", g_isr_86 == nr_vcpus);
>> +}
>> +
>> +static void update_cr3(void *cr3)
>> +{
>> +	write_cr3((ulong)cr3);
>> +}
>>
>>  int main(void)
>>  {
>>  	setup_vm();
>>  	smp_init();
>>
>> +	on_cpus(update_cr3, (void *)read_cr3());
>>  	mask_pic_interrupts();
>>
>>  	if (enable_x2apic())
>> @@ -448,7 +509,11 @@ int main(void)
>>  		test_ioapic_edge_tmr_smp(true);
>>
>>  		test_ioapic_self_reconfigure();
>> +		test_ioapic_physical_destination_mode();
>>  	}
>>
>> +	if (cpu_count() > 3)
>> +		test_ioapic_logical_destination_mode();
>> +
>>  	return report_summary();
>>  }
>
> --
> Cheers,
> Christophe de Dinechin (IRC c3d)
>
-- 
Thanks
Nitesh

