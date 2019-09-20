Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7477B8CA4
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 10:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392601AbfITIYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 04:24:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42566 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390765AbfITIYO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 04:24:14 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E674E10DCC9D;
        Fri, 20 Sep 2019 08:24:13 +0000 (UTC)
Received: from [10.36.116.238] (ovpn-116-238.ams2.redhat.com [10.36.116.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DEE046017E;
        Fri, 20 Sep 2019 08:24:12 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 3/6] s390x: Add linemode buffer to fix
 newline on every print
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com
References: <20190920080356.1948-1-frankja@linux.ibm.com>
 <20190920080356.1948-4-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <43bb9ff6-4233-3f6f-8cdb-3a00d1662d4d@redhat.com>
Date:   Fri, 20 Sep 2019 10:24:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920080356.1948-4-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Fri, 20 Sep 2019 08:24:14 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.09.19 10:03, Janosch Frank wrote:
> Linemode seems to add a newline for each sent message which makes
> reading rather hard. Hence we add a small buffer and only print if
> it's full or a newline is encountered. Except for when the string is
> longer than the buffer, then we flush the buffer and print directly.

I think that last sentence is not correct anymore.

> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> ---
>  lib/s390x/sclp-console.c | 45 ++++++++++++++++++++++++++++++++++++----
>  1 file changed, 41 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
> index 19416b5..e1b9000 100644
> --- a/lib/s390x/sclp-console.c
> +++ b/lib/s390x/sclp-console.c
> @@ -13,6 +13,7 @@
>  #include <asm/page.h>
>  #include <asm/arch_def.h>
>  #include <asm/io.h>
> +#include <asm/spinlock.h>
>  #include "sclp.h"
>  
>  /*
> @@ -87,6 +88,10 @@ static uint8_t _ascebc[256] = {
>       0x90, 0x3F, 0x3F, 0x3F, 0x3F, 0xEA, 0x3F, 0xFF
>  };
>  
> +static char lm_buff[120];
> +static unsigned char lm_buff_off;
> +static struct spinlock lm_buff_lock;
> +
>  static void sclp_print_ascii(const char *str)
>  {
>  	int len = strlen(str);
> @@ -103,10 +108,10 @@ static void sclp_print_ascii(const char *str)
>  	sclp_service_call(SCLP_CMD_WRITE_EVENT_DATA, sccb);
>  }
>  
> -static void sclp_print_lm(const char *str)
> +static void lm_print(const char *buff, int len)
>  {
>  	unsigned char *ptr, *end, ch;
> -	unsigned int count, offset, len;
> +	unsigned int count, offset;
>  	struct WriteEventData *sccb;
>  	struct mdb *mdb;
>  	struct mto *mto;
> @@ -117,11 +122,10 @@ static void sclp_print_lm(const char *str)
>  	end = (unsigned char *) sccb + 4096 - 1;
>  	memset(sccb, 0, sizeof(*sccb));
>  	ptr = (unsigned char *) &sccb->msg.mdb.mto;
> -	len = strlen(str);
>  	offset = 0;
>  	do {
>  		for (count = sizeof(*mto); offset < len; count++) {
> -			ch = str[offset++];
> +			ch = buff[offset++];
>  			if (ch == 0x0a || ptr + count > end)
>  				break;
>  			ptr[count] = _ascebc[ch];
> @@ -148,6 +152,39 @@ static void sclp_print_lm(const char *str)
>  	sclp_service_call(SCLP_CMD_WRITE_EVENT_DATA, sccb);
>  }
>  
> +
> +/*
> + * In contrast to the ascii console, linemode produces a new
> + * line with every write of data. The report() function uses
> + * several printf() calls to generate a line of data which
> + * would all end up on different lines.
> + *
> + * Hence we buffer here until we encounter a \n or the buffer
> + * is full. That means that linemode output can look a bit
> + * different from ascii and that it takes a bit longer for
> + * lines to appear.
> + */
> +static void sclp_print_lm(const char *str)
> +{
> +	int len = strlen(str), i = 0;
> +
> +	spin_lock(&lm_buff_lock);
> +
> +	while (len) {

for (i = 0; i < len; i++)

Then make len const and drop "len--" and "i++" from the body.

> +		lm_buff[lm_buff_off] = str[i];
> +		lm_buff_off++;

lm_buff[lm_buff_off++] = str[i];

if you feel like saving one LOC :)

> +		len--;
> +		/* Buffer full or newline? */
> +		if (str[i] == '\n' || lm_buff_off == (sizeof(lm_buff) - 1)) {

I still prefer ARRAY_SIZE(), but this is also fine.

> +			lm_print(lm_buff, lm_buff_off);
> +			memset(lm_buff, 0 , sizeof(lm_buff));

Is the memset really necessary? (I would have assumed it would only
print until the last "\n" ?)

> +			lm_buff_off = 0;
> +		}
> +		i++;
> +	}

Guess we don't care about performance, so the simple byte-based approach
should be just fine.

> +	spin_unlock(&lm_buff_lock);
> +}
> +
>  /*
>   * SCLP needs to be initialized by setting a send and receive mask,
>   * indicating which messages the control program (we) want(s) to
> 


I wonder if we have to implement some kind of fflush(), so we will flush
the buffer on any abort ... but I assume we will always end printing
with a "\n", so we don't really care.

-- 

Thanks,

David / dhildenb
