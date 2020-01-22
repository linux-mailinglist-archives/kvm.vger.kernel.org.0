Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 258291451C9
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 10:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729836AbgAVJ4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 04:56:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30825 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730066AbgAVJ4B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 04:56:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579686960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=Ol12bxLaxjZjjZifWSUGPDedjg9pM6vcBGOAy/CgTjM=;
        b=h1VNze6m1cVuCqV8EiLn5fTVWur6VB6ycjSeo146n8auCj8wnG0w/hPe3t5Vve/b7S1T0p
        34Z0FCRJTHcGBU4PUO9CrN5CvUuuDO96IiFmUQxaBqz+4mnOPxRiNOl6jG5ULvTkFN1qFm
        Tt2LtnBUXivn2cGXnDZq9FlYC9tx/Qg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-U4T8zvTrOiSuk60pSxVzUQ-1; Wed, 22 Jan 2020 04:55:56 -0500
X-MC-Unique: U4T8zvTrOiSuk60pSxVzUQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68706800D53;
        Wed, 22 Jan 2020 09:55:55 +0000 (UTC)
Received: from [10.36.117.205] (ovpn-117-205.ams2.redhat.com [10.36.117.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10EF05C28D;
        Wed, 22 Jan 2020 09:55:53 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v8 0/6] s390x: SCLP Unit test
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
References: <20200120184256.188698-1-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <b47c3b26-398a-1791-802d-8f6f6abf3498@redhat.com>
Date:   Wed, 22 Jan 2020 10:55:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200120184256.188698-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.01.20 19:42, Claudio Imbrenda wrote:
> This patchset contains some minor cleanup, some preparatory work and
> then the SCLP unit test itself.
> 
> The unit test checks the following:
>     
>     * Correctly ignoring instruction bits that should be ignored
>     * Privileged instruction check
>     * Check for addressing exceptions
>     * Specification exceptions:
>       - SCCB size less than 8
>       - SCCB unaligned
>       - SCCB overlaps prefix or lowcore
>       - SCCB address higher than 2GB
>     * Return codes for
>       - Invalid command
>       - SCCB too short (but at least 8)
>       - SCCB page boundary violation
> 
> v7 -> v8
> * fixed existing stfl asm wrapper
> * now using stfl asm wrapper in intercept.c
> * patched the program interrupt handler to clear the sclp_busy bit
> * removed now unnecessary expect_pgm_int from the unit test
> v6 -> v7
> * renamed spx() and stpx() wrappers to set_prefix and get_prefix
> * set_prefix now takes a value and get_prefix now returns a value
> * put back some inline assembly for spx and stpx as a consequence
> * used LC_SIZE instead of 2 * PAGE_SIZE everywhere in the unit test
> v5 -> v6
> * fixed a bug in test_addressing
> * improved comments in test_sccb_prefix
> * replaced all inline assembly usages of spx and stpx with the wrappers
> * added one more wrapper for test_one_sccb for read-only tests
> v4 -> v5
> * updated usage of report()
> * added SPX and STPX wrappers to the library
> * improved readability
> * addressed some more comments
> v3 -> v4
> * export sclp_setup_int instead of copying it
> * add more comments
> * rename some more variables to improve readability
> * improve the prefix test
> * improved the invalid address test
> * addressed further comments received during review
> v2 -> v3
> * generally improved the naming of variables
> * added and fixed comments
> * renamed test_one_run to test_one_simple
> * added some const where needed
> * addresed many more small comments received during review
> v1 -> v2
> * fix many small issues that came up during the first round of reviews
> * add comments to each function
> * use a static buffer for the SCCP template when used
> 
> Claudio Imbrenda (6):
>   s390x: export sclp_setup_int
>   s390x: sclp: add service call instruction wrapper
>   s390x: lib: fix stfl wrapper asm
>   s390x: lib: add SPX and STPX instruction wrapper
>   s390x: lib: fix program interrupt handler if sclp_busy was set
>   s390x: SCLP unit test
> 
>  s390x/Makefile           |   1 +
>  lib/s390x/asm/arch_def.h |  26 +++
>  lib/s390x/asm/facility.h |   2 +-
>  lib/s390x/sclp.h         |   1 +
>  lib/s390x/interrupt.c    |   5 +-
>  lib/s390x/sclp.c         |   9 +-
>  s390x/intercept.c        |  24 +-
>  s390x/sclp.c             | 474 +++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg      |   8 +
>  9 files changed, 526 insertions(+), 24 deletions(-)
>  create mode 100644 s390x/sclp.c
> 

Queued to

https://github.com/davidhildenbrand/qemu.git s390-tcg-next


Thanks!
-- 
Thanks,

David / dhildenb

