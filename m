Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C971514797B
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 09:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729384AbgAXIiN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 03:38:13 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48853 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725843AbgAXIiN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Jan 2020 03:38:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579855091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=vE6mP/lD7oC8QHJwMnhuQZpixan3XCyVM2MFPi6yK7M=;
        b=FVoJlNmBhfh9TCuq4V7onDGb2yzj6i723aJ1dQ9NWhmuisbGk/W9OrN+82wHlU4yx0p1Zb
        2ANiPCxcD1v2eIJC4WhHRSNmIPp3NWewBJG/bLXcyY6Ox/IQ0vNRmFN9pNENamZBrwhY/x
        E2kycnDhi57c+ijGnWtbi/lRL3RvVfA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-zO7VIg5tMG2ovu90z1tKlA-1; Fri, 24 Jan 2020 03:38:09 -0500
X-MC-Unique: zO7VIg5tMG2ovu90z1tKlA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 635B714E3;
        Fri, 24 Jan 2020 08:38:08 +0000 (UTC)
Received: from [10.36.117.150] (ovpn-117-150.ams2.redhat.com [10.36.117.150])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06DC185784;
        Fri, 24 Jan 2020 08:38:06 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v4 2/9] s390x: smp: Only use smp_cpu_setup
 once
From:   David Hildenbrand <david@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, cohuck@redhat.com
References: <20200121134254.4570-1-frankja@linux.ibm.com>
 <20200121134254.4570-3-frankja@linux.ibm.com>
 <ef7894ff-4179-6730-ce28-c48e7730eff8@redhat.com>
 <e09c42a7-279a-7e8b-8241-26c69940cdd0@linux.ibm.com>
 <9a17ce2d-bfce-0a1f-dfa7-3d798af4d5ab@redhat.com>
 <b16cbc73-20b2-4955-52a7-1b133aa33cc4@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <8deec98c-d384-bc2e-2790-7b47fcfd2d62@redhat.com>
Date:   Fri, 24 Jan 2020 09:38:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <b16cbc73-20b2-4955-52a7-1b133aa33cc4@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.01.20 09:28, David Hildenbrand wrote:
> On 23.01.20 14:56, David Hildenbrand wrote:
>> On 23.01.20 14:54, Janosch Frank wrote:
>>> On 1/23/20 2:45 PM, David Hildenbrand wrote:
>>>> On 21.01.20 14:42, Janosch Frank wrote:
>>>>> Let's stop and start instead of using setup to run a function on a
>>>>> cpu.
>>>>>
>>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>>>>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>>>>> Acked-by: David Hildenbrand <david@redhat.com>
>>>>> ---
>>>>>  s390x/smp.c | 21 ++++++++++++++-------
>>>>>  1 file changed, 14 insertions(+), 7 deletions(-)
>>>>>
>>>>> diff --git a/s390x/smp.c b/s390x/smp.c
>>>>> index e37eb56..3e8cf3e 100644
>>>>> --- a/s390x/smp.c
>>>>> +++ b/s390x/smp.c
>>>>> @@ -53,7 +53,7 @@ static void test_start(void)
>>>>>  	psw.addr =3D (unsigned long)test_func;
>>>>> =20
>>>>>  	set_flag(0);
>>>>> -	smp_cpu_setup(1, psw);
>>>>> +	smp_cpu_start(1, psw);
>>>>>  	wait_for_flag();
>>>>>  	report(1, "start");
>>>>>  }
>>>>> @@ -109,6 +109,7 @@ static void test_store_status(void)
>>>>>  	report(1, "status written");
>>>>>  	free_pages(status, PAGE_SIZE * 2);
>>>>>  	report_prefix_pop();
>>>>> +	smp_cpu_stop(1);
>>>>> =20
>>>>>  	report_prefix_pop();
>>>>>  }
>>>>> @@ -137,9 +138,8 @@ static void test_ecall(void)
>>>>> =20
>>>>>  	report_prefix_push("ecall");
>>>>>  	set_flag(0);
>>>>> -	smp_cpu_destroy(1);
>>>>> =20
>>>>> -	smp_cpu_setup(1, psw);
>>>>> +	smp_cpu_start(1, psw);
>>>>>  	wait_for_flag();
>>>>>  	set_flag(0);
>>>>>  	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
>>>>> @@ -172,9 +172,8 @@ static void test_emcall(void)
>>>>> =20
>>>>>  	report_prefix_push("emcall");
>>>>>  	set_flag(0);
>>>>> -	smp_cpu_destroy(1);
>>>>> =20
>>>>> -	smp_cpu_setup(1, psw);
>>>>> +	smp_cpu_start(1, psw);
>>>>>  	wait_for_flag();
>>>>>  	set_flag(0);
>>>>>  	sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
>>>>> @@ -192,7 +191,7 @@ static void test_reset_initial(void)
>>>>>  	psw.addr =3D (unsigned long)test_func;
>>>>> =20
>>>>>  	report_prefix_push("reset initial");
>>>>> -	smp_cpu_setup(1, psw);
>>>>> +	smp_cpu_start(1, psw);
>>>>> =20
>>>>>  	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
>>>>>  	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
>>>>> @@ -223,7 +222,7 @@ static void test_reset(void)
>>>>>  	psw.addr =3D (unsigned long)test_func;
>>>>> =20
>>>>>  	report_prefix_push("cpu reset");
>>>>> -	smp_cpu_setup(1, psw);
>>>>> +	smp_cpu_start(1, psw);
>>>>> =20
>>>>>  	sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
>>>>>  	report(smp_cpu_stopped(1), "cpu stopped");
>>>>> @@ -232,6 +231,7 @@ static void test_reset(void)
>>>>> =20
>>>>>  int main(void)
>>>>>  {
>>>>> +	struct psw psw;
>>>>>  	report_prefix_push("smp");
>>>>> =20
>>>>>  	if (smp_query_num_cpus() =3D=3D 1) {
>>>>> @@ -239,6 +239,12 @@ int main(void)
>>>>>  		goto done;
>>>>>  	}
>>>>> =20
>>>>> +	/* Setting up the cpu to give it a stack and lowcore */
>>>>> +	psw.mask =3D extract_psw_mask();
>>>>> +	psw.addr =3D (unsigned long)cpu_loop;
>>>>> +	smp_cpu_setup(1, psw);
>>>>> +	smp_cpu_stop(1);
>>>>> +
>>>>>  	test_start();
>>>>>  	test_stop();
>>>>>  	test_stop_store_status();
>>>>> @@ -247,6 +253,7 @@ int main(void)
>>>>>  	test_emcall();
>>>>>  	test_reset();
>>>>>  	test_reset_initial();
>>>>> +	smp_cpu_destroy(1);
>>>>> =20
>>>>>  done:
>>>>>  	report_prefix_pop();
>>>>>
>>>>
>>>> With this patch, I get timeouts under TCG. Seems to loop forever.
>>>>
>>> The branch works on lpar and kvm without a problem.
>>
>> Which could mean that either TCG is broken or your test is broken (e.g=
.,
>> a race condition that does not trigger under LPAR because it's faster,
>> or some undocumented/not guaranteed behavior).
>>
>=20
> So, the test works every now and then under TCG.
>=20
> It seems to work very reliably with "-smp 2"
>=20
> With smp 8, it sometimes works, sometimes not.
>=20
> t480s: ~/git/kvm-unit-tests (kein Branch, Rebase von s390x-prep) $
> ./s390x-run s390x/smp.elf -smp 8
> /home/dhildenb/git/qemu/s390x-softmmu/qemu-system-s390x -nodefaults
> -nographic -machine s390-ccw-virtio,accel=3Dtcg -chardev stdio,id=3Dcon=
0
> -device sclpconsole,chardev=3Dcon0 -kernel s390x/smp.elf -smp 8 # -init=
rd
> /tmp/tmp.UL9ZaqoKBW
> SMP: Initializing, found 8 cpus
> PASS: smp: start
> PASS: smp: stop
> PASS: smp: stop store status: prefix
> PASS: smp: stop store status: stack
> PASS: smp: store status at address: running: incorrect state
> PASS: smp: store status at address: running: status not written
> PASS: smp: store status at address: stopped: status written
> PASS: smp: ecall: ecall
> PASS: smp: emcall: ecall
> PASS: smp: cpu reset: cpu stopped
> PASS: smp: reset initial: clear: psw
> PASS: smp: reset initial: clear: prefix
> PASS: smp: reset initial: clear: fpc
> PASS: smp: reset initial: clear: cpu timer
> PASS: smp: reset initial: clear: todpr
> PASS: smp: reset initial: initialized: cr0 =3D=3D 0xE0
> PASS: smp: reset initial: initialized: cr14 =3D=3D 0xC2000000
> PASS: smp: reset initial: cpu stopped
> SUMMARY: 18 tests
>=20
> EXIT: STATUS=3D1
>=20
> t480s: ~/git/kvm-unit-tests (kein Branch, Rebase von s390x-prep) $
> ./s390x-run s390x/smp.elf -smp 8
> /home/dhildenb/git/qemu/s390x-softmmu/qemu-system-s390x -nodefaults
> -nographic -machine s390-ccw-virtio,accel=3Dtcg -chardev stdio,id=3Dcon=
0
> -device sclpconsole,chardev=3Dcon0 -kernel s390x/smp.elf -smp 8 # -init=
rd
> /tmp/tmp.csifrEDgnC
> SMP: Initializing, found 8 cpus
> PASS: smp: start
> PASS: smp: stop
> PASS: smp: stop store status: prefix
> FAIL: smp: stop store status: stack
> PASS: smp: store status at address: running: incorrect state
> PASS: smp: store status at address: running: status not written
> PASS: smp: store status at address: stopped: status written
> [... hang]
>=20
>=20
> Note that there is a previous failure for "smp: stop store status:
> stack" whenever the test will hang later.
>=20
>=20

In smp_cpu_stop_nolock(), when you do a SIGP_STOP_AND_STORE_STATUS, you
wait until the target CPU is stopped.

This does, however, not guarantee that the state has already been stored
- especially not if the target CPU is already stopped.

Stop and Store Status
The addressed CPU performs the stop function, fol-
lowed by the store-status operation (see =93Store Sta-
tus=94 on page 4-82). The CPU does not necessarily
complete the operation, or even enter the stopped
state, during the execution of SIGNAL PROCES-
SOR ..."

So there is a race in your code. I do wonder how you can test if the
order on the target CPU has been executed, without issuing another SIGP
operation (e.g., restart) or by testing if the content to be stored was
all changed ...

--=20
Thanks,

David / dhildenb

