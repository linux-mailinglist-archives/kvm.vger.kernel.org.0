Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76927218D8F
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 18:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730486AbgGHQxV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 12:53:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26640 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730382AbgGHQxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 12:53:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594227199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=EZCLxs8Gbz8KI3l3a26hQyzfqOKbIwnGZ4aP272Qt4M=;
        b=I3xUXCYOoSK1aSNQLrDb4wKMF9ngRR/VrPwJNQN85wUNBSRdjMe3KB8z8R1fQl63eCdrZq
        RC5VKWigZkIIGbOKoO8EZFmLi4QAarL/5j/Aeuc5phBov1orV7BpTfU1UIGj7UwkxI+71I
        LIQHFWWxHl0nD9guqcxUNp4SVhsCgY8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-9V1XsEDEMMmvEIvSVbu_Kg-1; Wed, 08 Jul 2020 12:53:15 -0400
X-MC-Unique: 9V1XsEDEMMmvEIvSVbu_Kg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB36610A8662;
        Wed,  8 Jul 2020 16:53:04 +0000 (UTC)
Received: from [10.36.113.117] (ovpn-113-117.ams2.redhat.com [10.36.113.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C32185BAC3;
        Wed,  8 Jul 2020 16:53:03 +0000 (UTC)
Subject: Re: [kvm-unit-tests v3 PATCH] s390x/cpumodel: The missing DFP
 facility on TCG is expected
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
References: <20200708150025.20631-1-thuth@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <0ba16f78-d2aa-fa39-95be-5e0c927e8f95@redhat.com>
Date:   Wed, 8 Jul 2020 18:53:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200708150025.20631-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08.07.20 17:00, Thomas Huth wrote:
> When running the kvm-unit-tests with TCG on s390x, the cpumodel test
> always reports the error about the missing DFP (decimal floating point)
> facility. This is kind of expected, since DFP is not required for
> running Linux and thus nobody is really interested in implementing
> this facility in TCG. Thus let's mark this as an expected error instead,
> so that we can run the kvm-unit-tests also with TCG without getting
> test failures that we do not care about.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  v3:
>  - Moved the is_tcg() function to the library so that it can be used
>    later by other tests, too
>  - Make sure to call alloc_page() and stsi() only once
> 
>  v2:
>  - Rewrote the logic, introduced expected_tcg_fail flag
>  - Use manufacturer string instead of VM name to detect TCG
> 
>  lib/s390x/vm.c   | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/vm.h   | 14 ++++++++++++++
>  s390x/Makefile   |  1 +
>  s390x/cpumodel.c | 19 +++++++++++++------
>  4 files changed, 74 insertions(+), 6 deletions(-)
>  create mode 100644 lib/s390x/vm.c
>  create mode 100644 lib/s390x/vm.h
> 
> diff --git a/lib/s390x/vm.c b/lib/s390x/vm.c
> new file mode 100644
> index 0000000..c852713
> --- /dev/null
> +++ b/lib/s390x/vm.c
> @@ -0,0 +1,46 @@
> +/*
> + * Functions to retrieve VM-specific information
> + *
> + * Copyright (c) 2020 Red Hat Inc
> + *
> + * Authors:
> + *  Thomas Huth <thuth@redhat.com>
> + *
> + * SPDX-License-Identifier: LGPL-2.1-or-later
> + */
> +
> +#include <libcflat.h>
> +#include <alloc_page.h>
> +#include <asm/arch_def.h>
> +#include "vm.h"
> +
> +/**
> + * Detect whether we are running with TCG (instead of KVM)
> + */
> +bool vm_is_tcg(void)
> +{
> +	const char qemu_ebcdic[] = { 0xd8, 0xc5, 0xd4, 0xe4 };
> +	static bool initialized = false;
> +	static bool is_tcg = false;
> +	uint8_t *buf;
> +
> +	if (initialized)
> +		return is_tcg;
> +
> +	buf = alloc_page();
> +	if (!buf)
> +		return false;
> +
> +	if (stsi(buf, 1, 1, 1))
> +		goto out;
> +
> +	/*
> +	 * If the manufacturer string is "QEMU" in EBCDIC, then we
> +	 * are on TCG (otherwise the string is "IBM" in EBCDIC)
> +	 */
> +	is_tcg = !memcmp(&buf[32], qemu_ebcdic, sizeof(qemu_ebcdic));
> +	initialized = true;
> +out:
> +	free_page(buf);
> +	return is_tcg;
> +}
> diff --git a/lib/s390x/vm.h b/lib/s390x/vm.h
> new file mode 100644
> index 0000000..33008d8
> --- /dev/null
> +++ b/lib/s390x/vm.h
> @@ -0,0 +1,14 @@
> +/*
> + * Functions to retrieve VM-specific information
> + *
> + * Copyright (c) 2020 Red Hat Inc
> + *
> + * SPDX-License-Identifier: LGPL-2.1-or-later
> + */
> +
> +#ifndef S390X_VM_H
> +#define S390X_VM_H
> +
> +bool vm_is_tcg(void);
> +
> +#endif  /* S390X_VM_H */
> diff --git a/s390x/Makefile b/s390x/Makefile
> index ddb4b48..98ac29e 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -51,6 +51,7 @@ cflatobjs += lib/s390x/sclp-console.o
>  cflatobjs += lib/s390x/interrupt.o
>  cflatobjs += lib/s390x/mmu.o
>  cflatobjs += lib/s390x/smp.o
> +cflatobjs += lib/s390x/vm.o
>  
>  OBJDIRS += lib/s390x
>  
> diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
> index 5d232c6..116a966 100644
> --- a/s390x/cpumodel.c
> +++ b/s390x/cpumodel.c
> @@ -11,14 +11,19 @@
>   */
>  
>  #include <asm/facility.h>
> +#include <vm.h>
>  
> -static int dep[][2] = {
> +static struct {
> +	int facility;
> +	int implied;
> +	bool expected_tcg_fail;
> +} dep[] = {
>  	/* from SA22-7832-11 4-98 facility indications */
>  	{   4,   3 },
>  	{   5,   3 },
>  	{   5,   4 },
>  	{  19,  18 },
> -	{  37,  42 },
> +	{  37,  42, true },  /* TCG does not have DFP and won't get it soon */
>  	{  43,  42 },
>  	{  73,  49 },
>  	{ 134, 129 },
> @@ -46,11 +51,13 @@ int main(void)
>  
>  	report_prefix_push("dependency");
>  	for (i = 0; i < ARRAY_SIZE(dep); i++) {
> -		if (test_facility(dep[i][0])) {
> -			report(test_facility(dep[i][1]), "%d implies %d",
> -				dep[i][0], dep[i][1]);
> +		if (test_facility(dep[i].facility)) {
> +			report_xfail(dep[i].expected_tcg_fail && vm_is_tcg(),
> +				     test_facility(dep[i].implied),
> +				     "%d implies %d",
> +				     dep[i].facility, dep[i].implied);
>  		} else {
> -			report_skip("facility %d not present", dep[i][0]);
> +			report_skip("facility %d not present", dep[i].facility);
>  		}
>  	}
>  	report_prefix_pop();
> 

Acked-by: David Hildenbrand <david@redhat.com>

Thanks!

-- 
Thanks,

David / dhildenb

