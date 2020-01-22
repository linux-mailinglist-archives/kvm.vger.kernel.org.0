Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B47C1459FD
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 17:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgAVQjb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 11:39:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21647 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725836AbgAVQjb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 11:39:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579711170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=obKMnllOTeVNCbIlpV+M2BPU1gZPbnF90Mtc2utjq7Q=;
        b=Kt0nvMDBQq/OKTtH1ZzeSRBJZExHfBgl05URvpGjE7SOOngabXyou5vDNl1pidXLqKgCBt
        TBHkS6YVce5+DbPHEHCeEeOXBp+o6HTC8mlXk4TdKfpTQCkzABbnXt56omRv2LqCtKrPVL
        Mm2NLGIghalDfT1rpWmJ7UgCu94yjwo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-2m-KnUbwMCGpWKNtgycPiA-1; Wed, 22 Jan 2020 11:39:28 -0500
X-MC-Unique: 2m-KnUbwMCGpWKNtgycPiA-1
Received: by mail-wr1-f69.google.com with SMTP id d8so75230wrq.12
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 08:39:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=obKMnllOTeVNCbIlpV+M2BPU1gZPbnF90Mtc2utjq7Q=;
        b=cyo8ZF1kt1edIxYoSy/YlwLFjpbk/xipPgdIuN1Y5ctIcYBVoo2+DhK1UvkfF8BWuW
         XnUdthnIbEg3aq/ygYbaLVj6kG/DdBrx55Pvi4RMoWry7sImWisQE3YsZxG+sB/zCLb0
         r03Rsy2kurV/v4ns337GduhgTV+aJwdS1N2TtDgl1yCOHtgRZFpxBscqDx/RDYl4OfLk
         yoLw1ROgnLZ4wgVjzz9PTCSeCTH9N0xn9tXdDblADEIOnXN/ANP0Md3SU7pyQ+rlgqg1
         pz0GCJBxCwvuVbWP/e3xOigxLzfoCb0GJpvtoyd/OmHEnyRpJQNke6L+5g/bitUNyLsg
         YuvQ==
X-Gm-Message-State: APjAAAX/9JaCHW0VZMxugZMZEmPbE/tv2b+450iEI5bsNmsxXcBF6Y8V
        QMuY7r5xZBkLzyHsbHxzLS9rZ8tN6yzqwoF7WdwJ++w+Es6pRGxEkXCA66krO8EZyWj/rIEYCyv
        Uq0ZhX8zcpWTq
X-Received: by 2002:a1c:151:: with SMTP id 78mr3655904wmb.182.1579711167093;
        Wed, 22 Jan 2020 08:39:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqxKnxLY/OdJ5TzPFEsLazViCypSLttAjaiiLTf1Ele9UbQ3mhpXTWpIVHQUqS3d3LhK1NpYVQ==
X-Received: by 2002:a1c:151:: with SMTP id 78mr3655890wmb.182.1579711166909;
        Wed, 22 Jan 2020 08:39:26 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f17sm4792984wmc.8.2020.01.22.08.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 08:39:26 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Drew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] Fixes for the umip test
In-Reply-To: <20200122160944.29750-1-thuth@redhat.com>
References: <20200122160944.29750-1-thuth@redhat.com>
Date:   Wed, 22 Jan 2020 17:39:25 +0100
Message-ID: <878slzsawy.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thomas Huth <thuth@redhat.com> writes:

> When compiling umip.c with -O2 instead of -O1, there are currently
> two problems. First, the compiler complains:
>
>  x86/umip.c: In function ‘do_ring3’:
>  x86/umip.c:162:37: error: array subscript 4096 is above array bounds of
>     ‘unsigned char[4096]’ [-Werror=array-bounds]
>        [user_stack_top]"m"(user_stack[sizeof user_stack]),
>                            ~~~~~~~~~~^~~~~~~~~~~~~~~~~~~
>
> This can be fixed by initializing the stack to point to one of the last
> bytes of the array instead.
>
> The second problem is that some tests are failing - and this is due
> to the fact that the GP_ASM macro uses inline asm without the "volatile"
> keyword - so that the compiler reorders this code in certain cases
> where it should not. Fix it by adding "volatile" here.
>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  x86/umip.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/x86/umip.c b/x86/umip.c
> index 7eee294..834668c 100644
> --- a/x86/umip.c
> +++ b/x86/umip.c
> @@ -22,7 +22,8 @@ static void gp_handler(struct ex_regs *regs)
>  
>  
>  #define GP_ASM(stmt, in, clobber)                  \
> -     asm ("mov" W " $1f, %[expected_rip]\n\t"      \
> +    asm volatile (                                 \
> +          "mov" W " $1f, %[expected_rip]\n\t"      \
>            "movl $2f-1f, %[skip_count]\n\t"         \
>            "1: " stmt "\n\t"                        \
>            "2: "                                    \
> @@ -159,7 +160,7 @@ static int do_ring3(void (*fn)(const char *), const char *arg)
>  		  : [ret] "=&a" (ret)
>  		  : [user_ds] "i" (USER_DS),
>  		    [user_cs] "i" (USER_CS),
> -		    [user_stack_top]"m"(user_stack[sizeof user_stack]),
> +		    [user_stack_top]"m"(user_stack[sizeof user_stack -  2]),

My eyes would definitely appreciate the missing parentheses and the
absense of the redundant space:

  sizeof(user_stack) - 2

>  		    [fn]"r"(fn),
>  		    [arg]"D"(arg),
>  		    [kernel_ds]"i"(KERNEL_DS),

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

