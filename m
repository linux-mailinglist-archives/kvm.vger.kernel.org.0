Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8EC13AE947
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 14:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhFUMnn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 08:43:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35728 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229651AbhFUMnm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Jun 2021 08:43:42 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15LCXNFW116775;
        Mon, 21 Jun 2021 08:41:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kNn9LSu+IL4dWx6plPrQHyI2GIW7KAdJG4lp9CfSry0=;
 b=ellTD3fvfRyei0RG2CPLTN5pPoa9NSLhK0C3ecINSZW6sfaJXWCvX6Gxvk2qcGNsIzC0
 BP0l3TL/y3c5Xpnwcn8YMxOpPP1igGFJOAc9zey2eILr/umYIeFh1EYGz2LQxbkY2o7T
 Ag/s44ASMCtyoiWtn0gHifbSldmS7xRqnORNOf4OOPjX117TJFA0ATtoEnVnwakhqUfi
 Yx+nFxuaK5hwGEi4KuC3ttlfD9//21m7F2iKv13E6KkhqMSG4MaIUh9wuBn+Tvjt599q
 d1VSP13fuIPQWvjlvsZnGWqdN7UEyw0qJbMw6CDNR9P4o47jHtbR96JRcZsMOIC8FZF3 tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39ass4agc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 08:41:28 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15LCXNnM116787;
        Mon, 21 Jun 2021 08:41:27 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39ass4agbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 08:41:27 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15LCdCD5029243;
        Mon, 21 Jun 2021 12:41:26 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3998788ft8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 12:41:25 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15LCe5qK32375274
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jun 2021 12:40:05 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69C0E4204B;
        Mon, 21 Jun 2021 12:41:23 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F64142041;
        Mon, 21 Jun 2021 12:41:23 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.195])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Jun 2021 12:41:22 +0000 (GMT)
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210520094730.55759-1-frankja@linux.ibm.com>
 <20210520094730.55759-3-frankja@linux.ibm.com>
 <35c30a30-e245-e1e2-facc-4685455da575@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests RFC 2/2] s390x: mvpg: Add SIE mvpg test
Message-ID: <53bfb17a-cd3d-6c39-cd06-f31d910d6232@linux.ibm.com>
Date:   Mon, 21 Jun 2021 14:41:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <35c30a30-e245-e1e2-facc-4685455da575@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: utIWG0WOyGqVyFeSQXSG6O1ZbiCBw-rE
X-Proofpoint-GUID: xSbGBthwvN_kgEQzBkgx6WnYRChIU0KR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-21_06:2021-06-21,2021-06-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999
 mlxscore=0 phishscore=0 clxscore=1015 adultscore=0 spamscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106210072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/21/21 12:23 PM, Thomas Huth wrote:
> On 20/05/2021 11.47, Janosch Frank wrote:
>> Let's also check the PEI values to make sure our VSIE implementation
>> is correct.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   s390x/Makefile                  |   3 +-
>>   s390x/mvpg-sie.c                | 139 ++++++++++++++++++++++++++++++++
>>   s390x/snippets/c/mvpg-snippet.c |  33 ++++++++
>>   s390x/unittests.cfg             |   3 +
>>   4 files changed, 177 insertions(+), 1 deletion(-)
>>   create mode 100644 s390x/mvpg-sie.c
>>   create mode 100644 s390x/snippets/c/mvpg-snippet.c
>>
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index fe267011..6692cf73 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -22,6 +22,7 @@ tests += $(TEST_DIR)/uv-guest.elf
>>   tests += $(TEST_DIR)/sie.elf
>>   tests += $(TEST_DIR)/mvpg.elf
>>   tests += $(TEST_DIR)/uv-host.elf
>> +tests += $(TEST_DIR)/mvpg-sie.elf
>>   
>>   tests_binary = $(patsubst %.elf,%.bin,$(tests))
>>   ifneq ($(HOST_KEY_DOCUMENT),)
>> @@ -79,7 +80,7 @@ FLATLIBS = $(libcflat)
>>   SNIPPET_DIR = $(TEST_DIR)/snippets
>>   report_abort
>>   # C snippets that need to be linked
>> -snippets-c =
>> +snippets-c = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
>>   
>>   # ASM snippets that are directly compiled and converted to a *.gbin
>>   snippets-a =
>> diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
>> new file mode 100644
>> index 00000000..a617704b
>> --- /dev/nullreport_abort
>> +++ b/s390x/mvpg-sie.c
>> @@ -0,0 +1,139 @@
>> +#include <libcflat.h>
>> +#include <asm/asm-offsets.h>
>> +#include <asm-generic/barrier.h>
>> +#include <asm/interrupt.h>
>> +#include <asm/pgtable.h>
>> +#include <mmu.h>
>> +#include <asm/page.h>
>> +#include <asm/facility.h>
>> +#include <asm/mem.h>
>> +#include <asm/sigp.h>
>> +#include <smp.h>
>> +#include <alloc_page.h>
>> +#include <bitops.h>
>> +#include <vm.h>
>> +#include <sclp.h>
>> +#include <sie.h>
>> +
>> +static u8 *guest;
>> +static u8 *guest_instr;
>> +static struct vm vm;
>> +
>> +static uint8_t *src;
>> +static uint8_t *dst;
>> +
>> +extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_start[];
>> +extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_end[];
>> +int binary_size;
>> +
>> +static void handle_validity(struct vm *vm)
>> +{
>> +	report(0, "VALIDITY: %x", vm->sblk->ipb >> 16);
>> +}
> 
> Maybe rather use report_abort() in that case? Or does it make sense to 
> continue running the other tests afterwards?
> 
>   Thomas
> 

Hmm, right this is not yet in the SIE lib.
