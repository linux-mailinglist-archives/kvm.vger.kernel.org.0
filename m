Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634A92ECC46
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 10:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbhAGJFh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 04:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbhAGJFg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 04:05:36 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CB8C0612F4
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 01:04:55 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id k10so4511093wmi.3
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 01:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o8yL9n6HozE/Ex7MpyYHQRdFZh6hCZGjqNJdBYi9rxY=;
        b=BZNxmvRE/fhiKHRJzoYgrsU7xE+Z2bPnN3/aRBoRO+rCIWT22vHuFE+OZ4CdNMtGjQ
         7fcjDd3Bp587obk6VDB1lpxjBiKLqIUDR0NyTPYIeKxjQQp7m6uctU301BAgKZp8eNpd
         GAsN97T6YiaQ7CTRg/VfVYmdeQBcM5Jz02kpH7/9ySbWefzlhgMRvYzKbFBxEb9D8CQd
         C3EtR4WKCjfNM4ulu71EwCCRhGRmmvYDELk3IsgWDXiRuKK1OItTHdXV8SMLyT2nbWMG
         jnpbILHhgM+dQw2yI4IPp2QPN5c/zitVxR/zpkxDWfUWeDTVxFdm4mA6pKiDRW5YlyE1
         GlvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o8yL9n6HozE/Ex7MpyYHQRdFZh6hCZGjqNJdBYi9rxY=;
        b=HATeDcUgVcD4qv9IDtjjwFM4UznFsb3hvfUWWza2LXqXSrhJZX35R3opNEjjOEjIKd
         hdFDGKLf4xa2nDOaGjE25ODLOIjNJo0S3d0bbY7YjxKhyRQ6/SfwaDdA1EsvGvNEzvpA
         MY7J4WqWOVY8f4+AOKFv0kue16Jy5LqdpRhTs55glInlu4kvog1C0ou9fd8hDJQ0YZFT
         cZdGkRWvNz0mJdyOpGI5i9GZD1mjyo0zYlZMNchuG+A9hNCxRHDuGjskext3kwUqCGBA
         /pV/gRropRSiqkfloDyshARrxANEri7JHfVEkuqUjSl5dmrDUBoQbpmNQd8TVK4YLYwT
         +rYg==
X-Gm-Message-State: AOAM533mmQ5bkwAUa9zLbigu/IdOBzwiuQy8SDe0jekwkml3SfjJ7mHT
        zFo1DUwdHqh9pXbPMR95nCOaomPnZxU=
X-Google-Smtp-Source: ABdhPJzCvph+Xqy8cmtQC5h/uhi/H8Oq2k9dRPL8gJ47bIyKbE+cmlyESYr4OyYwfxGz9184I/pGUQ==
X-Received: by 2002:a1c:2ed2:: with SMTP id u201mr7067931wmu.79.1610010294442;
        Thu, 07 Jan 2021 01:04:54 -0800 (PST)
Received: from [192.168.1.36] (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id s12sm6530722wmh.29.2021.01.07.01.04.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 01:04:53 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH v2 03/24] target/mips/cpu: Introduce isa_rel6_available()
 helper
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, Aurelien Jarno <aurelien@aurel32.net>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org
References: <20201215225757.764263-1-f4bug@amsat.org>
 <20201215225757.764263-4-f4bug@amsat.org>
 <508441db-8748-1b55-5f39-e6a778c0bdc0@linaro.org>
 <40e8df0f-01ab-6693-785b-257b8d3144bf@amsat.org>
 <af357960-40f2-b9e6-485f-d1cf36a4e95d@flygoat.com>
 <b1e8b44c-ae6f-786c-abe0-9a03eb5d3d63@flygoat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <0a0d8d4d-a0b6-dde5-e32d-17746ef57d53@amsat.org>
Date:   Thu, 7 Jan 2021 10:04:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <b1e8b44c-ae6f-786c-abe0-9a03eb5d3d63@flygoat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/16/20 4:14 AM, Jiaxun Yang wrote:
> 在 2020/12/16 上午10:50, Jiaxun Yang 写道:
>> TBH I do think it doesn't sounds like a good idea to make 32-bit
>> and 64-bit different. In fact ISA_MIPS32R6 is always set for targets
>> with ISA_MIPS64R6.
>>
>> We're treating MIPS64R6 as a superset of MIPS32R6, and ISA_MIPS3
>> is used to tell if a CPU supports 64-bit.
>>
>> FYI:
>> https://commons.wikimedia.org/wiki/File:MIPS_instruction_set_family.svg
> 
> Just add more cents here...
> The current method we handle R6 makes me a little bit annoying.
> 
> Given that MIPS is backward compatible until R5, and R6 reorganized a lot
> of opcodes, I do think decoding procdure of R6 should be dedicated from
> the rest,
> otherwise we may fall into the hell of finding difference between R6 and
> previous
> ISAs, also I've heard some R6 only ASEs is occupying opcodes marked as
> "removed in R6", so it doesn't looks like a wise idea to check removed
> in R6
> in helpers.

I think we are in agreement :) Your comment seems what I addressed
last month as this series:
https://gitlab.com/philmd/qemu/-/commits/mips_decodetree_lsa_r6/
(I'll try to rebase it and post during the week-end.)

> So we may end up having four series of decodetrees for ISA
> Series1: MIPS-II, MIPS32, MIPS32R2, MIPS32R5 (32bit "old" ISAs)
> Series2: MIPS-III, MIPS64, MIPS64R2, MIPS64R5 (64bit "old" ISAs)
> 
> Series3: MIPS32R6 (32bit "new" ISAs)
> Series4: MIPS64R6 (64bit "new" ISAs)
> 
> Thanks
> 
> - Jiaxun
