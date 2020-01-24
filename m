Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A54A147965
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 09:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbgAXI2H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 03:28:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55004 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725843AbgAXI2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jan 2020 03:28:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579854485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=XysGKl8wSy3ACF+TGJ2RQ77WThxpttNsPExhz9CTm5Q=;
        b=IMaohlhhsjtEl5vapXD1JmO4EkwnL1une3LKM+K/SG6r8ml+A5mU8aAmqgLVSWPWaHIOaZ
        //blxslI+4LR339+0mLk0zA/VhORHfYvDmGQQqgKzqc6C+6NRUQqDrzosrjdtwzKtNu+8S
        O729BAIxFceY1mwnK37s93dHuMc0al8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-dThhH9DwN16VXoHCqI7Y4g-1; Fri, 24 Jan 2020 03:28:04 -0500
X-MC-Unique: dThhH9DwN16VXoHCqI7Y4g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 25F2D18C35A0;
        Fri, 24 Jan 2020 08:28:03 +0000 (UTC)
Received: from [10.36.117.150] (ovpn-117-150.ams2.redhat.com [10.36.117.150])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A51728996;
        Fri, 24 Jan 2020 08:28:01 +0000 (UTC)
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
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <b16cbc73-20b2-4955-52a7-1b133aa33cc4@redhat.com>
Date:   Fri, 24 Jan 2020 09:28:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <9a17ce2d-bfce-0a1f-dfa7-3d798af4d5ab@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23.01.20 14:56, David Hildenbrand wrote:
> On 23.01.20 14:54, Janosch Frank wrote:
>> On 1/23/20 2:45 PM, David Hildenbrand wrote:
>>> On 21.01.20 14:42, Janosch Frank wrote:
>>>> Let's stop and start instead of using setup to run a function on a
>>>> cpu.
>>>>
>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>>>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>>>> Acked-by: David Hildenbrand <david@redhat.com>
>>>> ---
>>>>  s390x/smp.c | 21 ++++++++++++++-------
>>>>  1 file changed, 14 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/s390x/smp.c b/s390x/smp.c
>>>> index e37eb56..3e8cf3e 100644
>>>> --- a/s390x/smp.c
>>>> +++ b/s390x/smp.c
>>>> @@ -53,7 +53,7 @@ static void test_start(void)
>>>>  	psw.addr = (unsigned long)test_func;
>>>>  
>>>>  	set_flag(0);
>>>> -	smp_cpu_setup(1, psw);
>>>> +	smp_cpu_start(1, psw);
>>>>  	wait_for_flag();
>>>>  	report(1, "start");
>>>>  }
>>>> @@ -109,6 +109,7 @@ static void test_store_status(void)
>>>>  	report(1, "status written");
>>>>  	free_pages(status, PAGE_SIZE * 2);
>>>>  	report_prefix_pop();
>>>> +	smp_cpu_stop(1);
>>>>  
>>>>  	report_prefix_pop();
>>>>  }
>>>> @@ -137,9 +138,8 @@ static void test_ecall(void)
>>>>  
>>>>  	report_prefix_push("ecall");
>>>>  	set_flag(0);
>>>> -	smp_cpu_destroy(1);
>>>>  
>>>> -	smp_cpu_setup(1, psw);
>>>> +	smp_cpu_start(1, psw);
>>>>  	wait_for_flag();
>>>>  	set_flag(0);
>>>>  	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
>>>> @@ -172,9 +172,8 @@ static void test_emcall(void)
>>>>  
>>>>  	report_prefix_push("emcall");
>>>>  	set_flag(0);
>>>> -	smp_cpu_destroy(1);
>>>>  
>>>> -	smp_cpu_setup(1, psw);
>>>> +	smp_cpu_start(1, psw);
>>>>  	wait_for_flag();
>>>>  	set_flag(0);
>>>>  	sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
>>>> @@ -192,7 +191,7 @@ static void test_reset_initial(void)
>>>>  	psw.addr = (unsigned long)test_func;
>>>>  
>>>>  	report_prefix_push("reset initial");
>>>> -	smp_cpu_setup(1, psw);
>>>> +	smp_cpu_start(1, psw);
>>>>  
>>>>  	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
>>>>  	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
>>>> @@ -223,7 +222,7 @@ static void test_reset(void)
>>>>  	psw.addr = (unsigned long)test_func;
>>>>  
>>>>  	report_prefix_push("cpu reset");
>>>> -	smp_cpu_setup(1, psw);
>>>> +	smp_cpu_start(1, psw);
>>>>  
>>>>  	sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
>>>>  	report(smp_cpu_stopped(1), "cpu stopped");
>>>> @@ -232,6 +231,7 @@ static void test_reset(void)
>>>>  
>>>>  int main(void)
>>>>  {
>>>> +	struct psw psw;
>>>>  	report_prefix_push("smp");
>>>>  
>>>>  	if (smp_query_num_cpus() == 1) {
>>>> @@ -239,6 +239,12 @@ int main(void)
>>>>  		goto done;
>>>>  	}
>>>>  
>>>> +	/* Setting up the cpu to give it a stack and lowcore */
>>>> +	psw.mask = extract_psw_mask();
>>>> +	psw.addr = (unsigned long)cpu_loop;
>>>> +	smp_cpu_setup(1, psw);
>>>> +	smp_cpu_stop(1);
>>>> +
>>>>  	test_start();
>>>>  	test_stop();
>>>>  	test_stop_store_status();
>>>> @@ -247,6 +253,7 @@ int main(void)
>>>>  	test_emcall();
>>>>  	test_reset();
>>>>  	test_reset_initial();
>>>> +	smp_cpu_destroy(1);
>>>>  
>>>>  done:
>>>>  	report_prefix_pop();
>>>>
>>>
>>> With this patch, I get timeouts under TCG. Seems to loop forever.
>>>
>> The branch works on lpar and kvm without a problem.
> 
> Which could mean that either TCG is broken or your test is broken (e.g.,
> a race condition that does not trigger under LPAR because it's faster,
> or some undocumented/not guaranteed behavior).
> 

So, the test works every now and then under TCG.

It seems to work very reliably with "-smp 2"

With smp 8, it sometimes works, sometimes not.

t480s: ~/git/kvm-unit-tests (kein Branch, Rebase von s390x-prep) $
./s390x-run s390x/smp.elf -smp 8
/home/dhildenb/git/qemu/s390x-softmmu/qemu-system-s390x -nodefaults
-nographic -machine s390-ccw-virtio,accel=tcg -chardev stdio,id=con0
-device sclpconsole,chardev=con0 -kernel s390x/smp.elf -smp 8 # -initrd
/tmp/tmp.UL9ZaqoKBW
SMP: Initializing, found 8 cpus
PASS: smp: start
PASS: smp: stop
PASS: smp: stop store status: prefix
PASS: smp: stop store status: stack
PASS: smp: store status at address: running: incorrect state
PASS: smp: store status at address: running: status not written
PASS: smp: store status at address: stopped: status written
PASS: smp: ecall: ecall
PASS: smp: emcall: ecall
PASS: smp: cpu reset: cpu stopped
PASS: smp: reset initial: clear: psw
PASS: smp: reset initial: clear: prefix
PASS: smp: reset initial: clear: fpc
PASS: smp: reset initial: clear: cpu timer
PASS: smp: reset initial: clear: todpr
PASS: smp: reset initial: initialized: cr0 == 0xE0
PASS: smp: reset initial: initialized: cr14 == 0xC2000000
PASS: smp: reset initial: cpu stopped
SUMMARY: 18 tests

EXIT: STATUS=1

t480s: ~/git/kvm-unit-tests (kein Branch, Rebase von s390x-prep) $
./s390x-run s390x/smp.elf -smp 8
/home/dhildenb/git/qemu/s390x-softmmu/qemu-system-s390x -nodefaults
-nographic -machine s390-ccw-virtio,accel=tcg -chardev stdio,id=con0
-device sclpconsole,chardev=con0 -kernel s390x/smp.elf -smp 8 # -initrd
/tmp/tmp.csifrEDgnC
SMP: Initializing, found 8 cpus
PASS: smp: start
PASS: smp: stop
PASS: smp: stop store status: prefix
FAIL: smp: stop store status: stack
PASS: smp: store status at address: running: incorrect state
PASS: smp: store status at address: running: status not written
PASS: smp: store status at address: stopped: status written
[... hang]


Note that there is a previous failure for "smp: stop store status:
stack" whenever the test will hang later.


-- 
Thanks,

David / dhildenb

