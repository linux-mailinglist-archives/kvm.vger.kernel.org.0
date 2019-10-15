Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D684D7051
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 09:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfJOHlb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 03:41:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59202 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbfJOHla (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 03:41:30 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F24A7307D871;
        Tue, 15 Oct 2019 07:41:29 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-117-75.ams2.redhat.com [10.36.117.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD62F19C68;
        Tue, 15 Oct 2019 07:41:27 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 1/1] x86: use pointer for end of exception
 table
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, alexandru.elisei@arm.com
Cc:     jmattson@google.com
References: <20191012074454.208377-2-morbo@google.com>
 <20191013071824.222946-1-morbo@google.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=thuth@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat
Message-ID: <6656e70c-4866-55e8-108b-9bbb2c6fd081@redhat.com>
Date:   Tue, 15 Oct 2019 09:41:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191013071824.222946-1-morbo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 15 Oct 2019 07:41:30 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/2019 09.18, Bill Wendling wrote:
> Two global objects can't have the same address in C. Clang uses this
> fact to omit the check on the first iteration of the loop in
> check_exception_table.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  lib/x86/desc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/x86/desc.c b/lib/x86/desc.c
> index 451f504..cfc449f 100644
> --- a/lib/x86/desc.c
> +++ b/lib/x86/desc.c
> @@ -41,7 +41,7 @@ struct ex_record {
>      unsigned long handler;
>  };
>  
> -extern struct ex_record exception_table_start, exception_table_end;
> +extern struct ex_record exception_table_start, *exception_table_end;
>  
>  static const char* exception_mnemonic(int vector)
>  {
> @@ -113,7 +113,7 @@ static void check_exception_table(struct ex_regs *regs)
>  		(((regs->rflags >> 16) & 1) << 8);
>      asm("mov %0, %%gs:4" : : "r"(ex_val));
>  
> -    for (ex = &exception_table_start; ex != &exception_table_end; ++ex) {
> +    for (ex = &exception_table_start; ex != (void*)&exception_table_end; ++ex) {
>          if (ex->rip == regs->rip) {
>              regs->rip = ex->handler;
>              return;
> 

That looks like quite an ugly hack to me - and if clang gets a little
bit smarter, I'm pretty sure it will optimize this away, too.

Could you please check if something like this works, too:

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 451f504..0e9779b 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -41,7 +41,8 @@ struct ex_record {
     unsigned long handler;
 };

-extern struct ex_record exception_table_start, exception_table_end;
+extern struct ex_record exception_table_start;
+extern long exception_table_size;

 static const char* exception_mnemonic(int vector)
 {
@@ -108,12 +109,13 @@ static void check_exception_table(struct ex_regs
*regs)
 {
     struct ex_record *ex;
     unsigned ex_val;
+    int cnt = exception_table_size / sizeof(struct ex_record);

     ex_val = regs->vector | (regs->error_code << 16) |
                (((regs->rflags >> 16) & 1) << 8);
     asm("mov %0, %%gs:4" : : "r"(ex_val));

-    for (ex = &exception_table_start; ex != &exception_table_end; ++ex) {
+    for (ex = &exception_table_start; cnt-- > 0; ++ex) {
         if (ex->rip == regs->rip) {
             regs->rip = ex->handler;
             return;
diff --git a/x86/flat.lds b/x86/flat.lds
index a278b56..108fad5 100644
--- a/x86/flat.lds
+++ b/x86/flat.lds
@@ -9,6 +9,7 @@ SECTIONS
           exception_table_start = .;
           *(.data.ex)
          exception_table_end = .;
+          exception_table_size = exception_table_end -
exception_table_start;
          }
     . = ALIGN(16);
     .rodata : { *(.rodata) }

 Thomas
