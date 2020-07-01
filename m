Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F92210874
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 11:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729262AbgGAJnL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 05:43:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26223 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726343AbgGAJnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 05:43:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593596587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ntHMqGGzlSHdiWiMet5NwG/fAwiBWyche/+yMJxtBy8=;
        b=F8btWrXp8HXJBZMFlkejuyvBkZ9X0JifpCphaQ4uJbQ9+40ER802Sns4ecp3Amkk0uHwxr
        2Dsc5UOWePx6bDTb+xYGQ1Y2Q5MojEtTDNPukSW5EfWX7doG2i769e/XGqED5pOGAeTY6X
        yFNDaCjghHC1ynCeJGA9r4dErpFlaCI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-yC39GEN2NHi5fOz3lF12vQ-1; Wed, 01 Jul 2020 05:43:05 -0400
X-MC-Unique: yC39GEN2NHi5fOz3lF12vQ-1
Received: by mail-ej1-f69.google.com with SMTP id yh3so7590820ejb.16
        for <kvm@vger.kernel.org>; Wed, 01 Jul 2020 02:43:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ntHMqGGzlSHdiWiMet5NwG/fAwiBWyche/+yMJxtBy8=;
        b=dBe8VNR+xnY1hrgTHOFK8c8s1xX3dUwIIm2GhGG8fpfb6k6jhAFCbTih8c3Q3kN1b8
         rUA2C3cqwPL6hTNXz91HMAhnPKbnpMYRvsYhHjx3iUbiUlCPSRwdm6tjIRZT2AuXrYPV
         YK4kUunA/xn+dEMUICmhWiMj1vborUNICVymtMuBjOYkZP68d9GX28zQ5aKHvMpK879P
         xOBM4i3zY3GS/psVPInVT8cnmCDhoG5OqwZUAvD97DSXyCZWpsfcqxyLJRWGIZRC6r7i
         gFHiIIInoW71n8txe2613U/6OsLyxLGJIQ3+7RBdYQMM/LRrZq6B3vROmyJ5eixK5e17
         f9Kg==
X-Gm-Message-State: AOAM531UUQKua1oYHzjGXyUOOtCLuXHIDtq4jcSag/0KV+EJhSBhl4L4
        R9lbxt/dV5+4pB+NaBtmneDG46HRDP8f9gYysniVflPLi6u/X6yFiRqzfQ0PjPa2aB6SH3oGHCL
        ZvLX82e/k919i
X-Received: by 2002:a50:d9cb:: with SMTP id x11mr26800273edj.93.1593596584768;
        Wed, 01 Jul 2020 02:43:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJysAD6eZS4h835YPzGv1oon872AAd124CBtSWatVPo/tbwN4cCnQFkdj98u0SpTxXTudJ4wtQ==
X-Received: by 2002:a50:d9cb:: with SMTP id x11mr26800253edj.93.1593596584553;
        Wed, 01 Jul 2020 02:43:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1142:70d6:6b9b:3cd1? ([2001:b07:6468:f312:1142:70d6:6b9b:3cd1])
        by smtp.gmail.com with ESMTPSA id aq25sm4346066ejc.11.2020.07.01.02.43.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2020 02:43:03 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] scripts: Fix the check whether testname is
 in the only_tests list
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     Drew Jones <drjones@redhat.com>
References: <20200701083753.31366-1-thuth@redhat.com>
 <11b56d2f-e481-8951-69ea-8400f1cb7939@redhat.com>
 <c7485f32-d3bb-81f2-786a-3716f0a32800@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3b521930-4cec-e7d5-0d30-9d79684c9949@redhat.com>
Date:   Wed, 1 Jul 2020 11:43:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <c7485f32-d3bb-81f2-786a-3716f0a32800@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/07/20 10:57, Thomas Huth wrote:
>>>
>>
>> Simpler: grep -q " $testname " <<< " $only_tests "
> 
> That doesn't work:
> 
> $ ./run_tests.sh ioapic-split
> PASS apic-split (53 tests)
> PASS ioapic-split (19 tests)
> PASS apic (53 tests)
> PASS ioapic (26 tests)
> 
> ... because the $testname comes from unittests.cfg and $only_tests is
> the list that has been given on the command line. It would maybe work if
> the check was the other way round ... but that would require to rewrite
> quite a bit of the script logic...

It works here.  I'll send a patch.

Paolo

> By the way, you can currently also run "./run_test.sh badname" and it
> does *not* complain that "badname" is an illegal test name...

