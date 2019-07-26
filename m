Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD76F76007
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2019 09:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfGZHoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jul 2019 03:44:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54682 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbfGZHoJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jul 2019 03:44:09 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7840E20260;
        Fri, 26 Jul 2019 07:44:08 +0000 (UTC)
Received: from thuth.remote.csb (reserved-198-198.str.redhat.com [10.33.198.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1EE2B51;
        Fri, 26 Jul 2019 07:44:04 +0000 (UTC)
Subject: Re: [ v3 1/1] kvm-unit-tests: s390: add cpu model checks
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
References: <20190726065412.175785-1-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=thuth@redhat.com; keydata=
 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
Organization: Red Hat
Message-ID: <bc90f803-7e23-7410-2c42-ec3945380f7e@redhat.com>
Date:   Fri, 26 Jul 2019 09:44:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190726065412.175785-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 26 Jul 2019 07:44:08 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Could you check your settings in your local git repo? Normally, there
should be something like:

[format]
	subjectprefix = kvm-unit-tests PATCH

so that the patches are created with the correct prefix. In your mails,
the prefix seems to be missing completely.

On 26/07/2019 08.54, Christian Borntraeger wrote:
> This adds a check for documented stfle dependencies.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
> V2->V3:
> 	- add 135,129
> 	- add spaces between number and curly braces
> 	- simplify check
>  s390x/Makefile      |  1 +
>  s390x/cpumodel.c    | 58 +++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |  3 +++
>  3 files changed, 62 insertions(+)
>  create mode 100644 s390x/cpumodel.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 1f21ddb9c943..574a9a20824d 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -11,6 +11,7 @@ tests += $(TEST_DIR)/cmm.elf
>  tests += $(TEST_DIR)/vector.elf
>  tests += $(TEST_DIR)/gs.elf
>  tests += $(TEST_DIR)/iep.elf
> +tests += $(TEST_DIR)/cpumodel.elf
>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>  
>  all: directories test_cases test_cases_binary
> diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
> new file mode 100644
> index 000000000000..1e4cc39026b9
> --- /dev/null
> +++ b/s390x/cpumodel.c
> @@ -0,0 +1,58 @@
> +/*
> + * Test the known dependencies for facilities
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
> +static int dep[][2] = {
> +	/* from SA22-7832-11 4-98 facility indications */
> +	{   4,   3 },
> +	{   5,   3 },
> +	{   5,   4 },
> +	{  19,  18 },
> +	{  37,  42 },
> +	{  43,  42 },
> +	{  73,  49 },
> +	{ 134, 129 },
> +	{ 135, 129 },
> +	{ 139,  25 },
> +	{ 139,  28 },
> +	{ 146,  76 },
> +	/* indirectly documented in description */
> +	{  78,   8 },  /* EDAT */
> +	/* new dependencies from gen15 */
> +	{  61,  45 },
> +	{ 148, 129 },
> +	{ 148, 135 },
> +	{ 152, 129 },
> +	{ 152, 134 },
> +	{ 155,  76 },
> +	{ 155,  77 },
> +};
> +
> +int main(void)
> +{
> +	int i;
> +
> +	report_prefix_push("cpumodel");
> +
> +	report_prefix_push("dependency");
> +	for (i = 0; i < ARRAY_SIZE(dep); i++) {
> +		if (test_facility(dep[i][0])) {
> +			report("%d implies %d", test_facility(dep[i][1]),
> +				dep[i][0], dep[i][1]);
> +		} else {
> +			report_skip("facility %d not present", dep[i][0]);
> +		}
> +	}
> +	report_prefix_pop();

It would be nice to have another report_prefix_pop() for the "cpumodel",
but since we're done here anyway, I guess it's also ok without it.

> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 546b1f281f8f..db58bad5a038 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -61,3 +61,6 @@ file = gs.elf
>  
>  [iep]
>  file = iep.elf
> +
> +[cpumodel]
> +file = cpumodel.elf
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>
