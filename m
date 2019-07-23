Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3022C71C98
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2019 18:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbfGWQN7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jul 2019 12:13:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58448 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbfGWQN6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jul 2019 12:13:58 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1CDF223E6E7;
        Tue, 23 Jul 2019 16:13:58 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-99.ams2.redhat.com [10.36.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 50E1D5D6A9;
        Tue, 23 Jul 2019 16:13:52 +0000 (UTC)
Subject: Re: [1/1] kvm-unit-tests: s390: test for gen15a/b cpu model
 dependencies
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
References: <20190723115419.153590-1-borntraeger@de.ibm.com>
 <20190723115419.153590-2-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=thuth@redhat.com; keydata=
 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
Organization: Red Hat
Message-ID: <651adab6-1564-cd62-c71f-562a99d91ec0@redhat.com>
Date:   Tue, 23 Jul 2019 18:13:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190723115419.153590-2-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 23 Jul 2019 16:13:58 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/07/2019 13.54, Christian Borntraeger wrote:
> This adds a test for the cpu model gen15a/b. The test check for
> dependencies and proper subfunctions.

I can't say much about the contents here since I don't have the PoP for
gen15 yet, so just some cosmetical comments below...

> +++ b/s390x/gen15.c
> @@ -0,0 +1,191 @@
> +/*
> + * Test the facilities and subfunctions of the new gen15 cpu model
> + * Unless fully implemented this will only work with kvm as we check
> + * for all subfunctions
> + *
> + * Copyright 2019 IBM Corp.
> + *
> + * Authors:
> + *    Christian Borntraeger <borntraeger@de.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU Library General Public License version 2.
> + */
> +
> +#include <asm/facility.h>
> +
> +static void test_minste3(void)
> +{
> +

Please remove the empty line.

> +	report_prefix_push("minste");
> +
> +	/* Dependency */
> +	report("facility 45 available", test_facility(45));
> +
> +	report_prefix_pop();
> +}
> +
> +static void test_vxeh2(void)
> +{
> +

dito

> +	report_prefix_push("vxeh2");
> +
> +	/* Dependencies */
> +	report("facility 129 available", test_facility(129));
> +	report("facility 135 available", test_facility(135));
> +
> +	report_prefix_pop();
> +}
> +
> +static void query_opcode(unsigned int opcode, unsigned long query[4])
> +{
> +        register unsigned long r0 asm("0") = 0; /* query function */
> +        register unsigned long r1 asm("1") = (unsigned long) query;
> +
> +        asm volatile(
> +                /* Parameter regs are ignored */
> +                "       .insn   rrf,%[opc] << 16,2,4,6,0\n"
> +                : "=m" (*query)
> +                : "d" (r0), "a" (r1), [opc] "i" (opcode)
> +                : "cc");
> +}

Could you add a comment in front of the query_opcode() function,
describing what it is doing?

> +
> +static void query_cpuid(struct cpuid *id)
> +{
> +	asm volatile ("stidp %0\n" : "+Q"(*id));
> +}
> +
> +/* Big Endian BIT macro that uses the bit value within a 64bit value */
> +#define BIT(a) (1UL << (63-(a % 64)))
> +#define DEFLTCC_GEN15 (BIT(0)  | BIT(1)  | BIT(2)  | BIT(4))
> +#define DEFLTCC_GEN15_F (BIT(0))
> +static void test_deflate(void)
> +{
> +	unsigned long query[4];
> +	struct cpuid id = {};
> +
> +	report_prefix_push("deflate");
> +
> +	query_opcode(0xb939, query);

Any chance that you could add already a comment with the mnemonic here?

 Thomas
