Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 084139EC5D
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 17:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbfH0PXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 11:23:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51736 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727064AbfH0PXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 11:23:07 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CE99710C6969;
        Tue, 27 Aug 2019 15:23:06 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-79.ams2.redhat.com [10.36.116.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDD2C5D6B0;
        Tue, 27 Aug 2019 15:23:04 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 1/3] s390x: Move pfmf to lib and make
 address void
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <20190827134936.1705-1-frankja@linux.ibm.com>
 <20190827134936.1705-2-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=thuth@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat
Message-ID: <e722fde9-d00a-ca65-91a3-9c7801c2352a@redhat.com>
Date:   Tue, 27 Aug 2019 17:23:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190827134936.1705-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Tue, 27 Aug 2019 15:23:06 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/2019 15.49, Janosch Frank wrote:
> It's needed by other tests soon.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm/mem.h | 31 ++++++++++++++++++++++
>  s390x/pfmf.c        | 63 ++++++++++++++-------------------------------
>  2 files changed, 50 insertions(+), 44 deletions(-)
[...]
> @@ -80,15 +49,18 @@ static void test_1m_key(void)
>  {
>  	int i;
>  	bool rp = true;
> -	union r1 r1;
> +	union pfmf_r1 r1;
>  	union skey skey;
> +	void *addr = pagebuf;
>  
>  	report_prefix_push("1M");
>  	r1.val = 0;
>  	r1.reg.sk = 1;
> -	r1.reg.fsc = FSC_1M;
> +	r1.reg.fsc = PFMF_FSC_1M;
>  	r1.reg.key = 0x30;
> -	pfmf(r1.val, (unsigned long) pagebuf);
> +	while (addr != pagebuf + 256 * PAGE_SIZE) {
> +	       addr = pfmf(r1.val, addr);
> +	}

Why this change? If PFMF gets interrupted, the PSW should still point to
the PFMF instruction, so no need to loop here ... or do I miss something?

(See PoP, chapter "Execution of Interruptible Instructions")

>  	for (i = 0; i < 256; i++) {
>  		skey.val = get_storage_key((unsigned long) pagebuf + i * PAGE_SIZE);
>  		skey.val &= SKEY_ACC | SKEY_FP;
> @@ -103,15 +75,15 @@ static void test_1m_key(void)
>  
>  static void test_4k_clear(void)
>  {
> -	union r1 r1;
> +	union pfmf_r1 r1;
>  
>  	r1.val = 0;
>  	r1.reg.cf = 1;
> -	r1.reg.fsc = FSC_4K;
> +	r1.reg.fsc = PFMF_FSC_4K;
>  
>  	report_prefix_push("4K");
>  	memset(pagebuf, 42, PAGE_SIZE);
> -	pfmf(r1.val, (unsigned long) pagebuf);
> +	pfmf(r1.val, pagebuf);
>  	report("clear memory", !memcmp(pagebuf, pagebuf + PAGE_SIZE, PAGE_SIZE));
>  	report_prefix_pop();
>  }
> @@ -119,16 +91,19 @@ static void test_4k_clear(void)
>  static void test_1m_clear(void)
>  {
>  	int i;
> -	union r1 r1;
> +	union pfmf_r1 r1;
>  	unsigned long sum = 0;
> +	void *addr = pagebuf;
>  
>  	r1.val = 0;
>  	r1.reg.cf = 1;
> -	r1.reg.fsc = FSC_1M;
> +	r1.reg.fsc = PFMF_FSC_1M;
>  
>  	report_prefix_push("1M");
>  	memset(pagebuf, 42, PAGE_SIZE * 256);
> -	pfmf(r1.val, (unsigned long) pagebuf);
> +	while (addr != pagebuf + 256 * PAGE_SIZE) {
> +	       addr = pfmf(r1.val, addr);
> +	}

dito.

 Thomas

