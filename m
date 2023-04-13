Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98B16E0856
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 09:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjDMHz6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 03:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbjDMHzy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 03:55:54 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A8F902B
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 00:55:53 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id s2so10011454wra.7
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 00:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1681372552; x=1683964552;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rVIZ2dHKMes6RQjegucWZCTQcViizfOvwilHdX7EYhE=;
        b=aOyPkFvZ7OBqRCTNYuAx3L/fw/DipudH8W9n3c1vuSpnG/xSFhvb5wzCzpDN1vffqc
         EpCxobxuOhN40XOoG9orPnP6QqKBgV9N5qQMEbIPV9GW6bV23T7nghHdVlwlTYqA8StS
         gG4OwRmRP6Az+sBaWSGejPosmfevmt1yKlyvmV1v/87DS39AyoEfc0dKQwuJqMwr4Y1R
         gQ163n47W9+GkncWsefoxGg+2KZnByeoIWygqW8BaFQ2HU0M1PAvH+2zfEq7h2xgO/B+
         co8Z1S+iwxGRWFepRM0HKAAATa5pJcNSJyLGc/YzcWk4bsiRvKbhAzWEU5QNsl/p7C13
         ghPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681372552; x=1683964552;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rVIZ2dHKMes6RQjegucWZCTQcViizfOvwilHdX7EYhE=;
        b=Qn6iEgQelIMBnSgBeQtq/zXpM2uXVPr8kN/mmfkWkvsjb6JJU5/smBag9YnZfkaZtO
         3Ai+bQihuH6exV/o9MEH4Qqfchk+EYXVnvsXow8jwXpyVCrW+d0AL7On5pFl+Hv2KdQk
         JT5F/O3zRwBqaLx7TKQUPVb8D966xq+MwVUuvBTxkq8jeI67VLYPGlOXMj/mAdeF93YV
         QX2dLYtAVz2EQagDhMrvPVUy4UvWbBfqeb+Z+Ajngs8zFdDp/GGu54yMuXkQKsp9mr19
         NEe2uSsx93reyAotq7XYC8VTKlAR7/tbsVFiAzxbaSQdM72wMahyDLChCmdYiV8/r0s+
         DmxQ==
X-Gm-Message-State: AAQBX9f/NgyeJB4i5X+A6P2NeSpAfC0j/4FFaxjxbaH5HtcxiK7Jqllf
        2h/L9nvMZ3qC/412tmuqIULZKZqhFKt+wJiGX4c=
X-Google-Smtp-Source: AKy350YerCJOT7kfXtZ1ds3/JW/1UIcd01JOEczhgp5Wf8aI8LTwi4+ki7BQWW1m1UPFqE5SG1NBig==
X-Received: by 2002:adf:ef4d:0:b0:2ef:e73d:605d with SMTP id c13-20020adfef4d000000b002efe73d605dmr3473186wrp.30.1681372551997;
        Thu, 13 Apr 2023 00:55:51 -0700 (PDT)
Received: from ?IPV6:2003:f6:af15:4800:239b:9d01:131a:bb32? (p200300f6af154800239b9d01131abb32.dip0.t-ipconnect.de. [2003:f6:af15:4800:239b:9d01:131a:bb32])
        by smtp.gmail.com with ESMTPSA id q9-20020a1ce909000000b003ee20b4b2dasm1050003wmc.46.2023.04.13.00.55.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 00:55:51 -0700 (PDT)
Message-ID: <b6322bd0-3639-fb2a-7211-974386865bac@grsecurity.net>
Date:   Thu, 13 Apr 2023 09:55:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH] x86/emulator: Test non-canonical memory
 access exceptions
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20230215142344.20200-1-minipli@grsecurity.net>
 <ZC42RavGH2Z82oJd@google.com>
 <f34b3d78-a1c4-90cb-079a-2dc81a5e6e7b@grsecurity.net>
 <ZC72mHH4oU4n7Jjc@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <ZC72mHH4oU4n7Jjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06.04.23 18:43, Sean Christopherson wrote:
> On Thu, Apr 06, 2023, Mathias Krause wrote:
>> On 06.04.23 05:02, Sean Christopherson wrote:
>>> [...]
>>> E.g. I believe this can be something like:
>>>
>>> 	asm_safe_report_ex(GP_VECTOR, "orq $0, (%[noncanonical]), "r" (NONCANONICAL));
>>> 	report(!exception_error_code());
>>>
>>> Or we could even add asm_safe_report_ex_ec(), e.g.
>>>
>>> 	asm_safe_report_ex_ec(GP_VECTOR, 0,
>>> 			      "orq $0, (%[noncanonical]), "r" (NONCANONICAL));
>>
>> Yeah, the latter. Verifying the error code is part of the test, so that
>> should be preserved.
>>
>> The tests as written by me also ensure that an exception actually
>> occurred, exactly one, actually. Maybe that should be accounted for in
>> asm_safe*() as well?
> 
> That's accounted for, the ASM_TRY() machinery treats "0" as no exception (we
> sacrified #DE for the greater good).

I overlooked the GS-relative MOVL in ASM_TRY() first, which, after some
digging, turns out to be zeroing the per-cpu 'exception_data' member.
Sneaky ;)

>                                       Realistically, the only way to have multiple
> exceptions without going into the weeds is if KVM somehow restarted the faulting
> instruction.  That would essentially require very precise memory corruption to
> undo the exception fixup handler's modification of RIP on the stack.  And at that
> point, one could also argue that KVM could also corrupt the exception counter.

I wasn't concerned about memory corruption per se but more of a broken
emulation as in not generating an exception at all. But ASM_TRY()
handles this by resetting the per-cpu exception state. So yeah, looks
like I can make use of the per-cpu helpers for my purpose.

> 
>> PS: Would be nice if the entry barrier for new tests wouldn't require to
>> handle the accumulated technical debt of the file one's touching ;P
> 
> Heh, and if wishes were horses we'd all be eating steak.  Just be glad I didn't
> ask you to rewrite the entire test ;-)
> 
> Joking aside, coercing/extorting contributors into using new/better infrastructure
> is the only feasible way to keep KVM's test infrastructure somewhat manageable.

I understand that, so it's fine with me to enrich my new test case with
some cleanups along the way.

> E.g. I would love to be able to dedicate a substantial portion of my time to
> cleaning up the many warts KUT, but the unfortunate reality is that test infrastructure
> is always going to be lower priority than the product itself.

I feel your pain and in my case the product is something completely
different even, so even less time on my side :/

Thanks,
Mathias
