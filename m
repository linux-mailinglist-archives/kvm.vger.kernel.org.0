Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE650696B63
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 18:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbjBNRYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 12:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbjBNRYh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 12:24:37 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C8D2312E
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 09:24:29 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id d13-20020a17090ad3cd00b0023127b2d602so16093661pjw.2
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 09:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K3rJmmxER8Kegw8UROXilPnl76lOFWCMz2/TCfvPwNE=;
        b=PPPJDva1Cm+L2OTjSqS4bvcheGtxqIFDQa7EkVMZ73Wx4F/3dyyHkJR+pyVITO8qt2
         BdsqOwRvy8M8EBgi34XjxnvIKNGVr5G+dORSiZIWjBDCz4Tp8Gx3oDt+/XgMxO3baA/k
         BKSLuo/k36M83kYZB4uRGNURwXkry9vA7JNtXjXgtjTE5J4spoPpPcw/DSLoewXZCkhA
         N20KqKlAAAImHAyYLaNJPr388S0ITgyN/1nIPKYFtmLd7lhU2wpdVe1tFREatXitVDum
         QX8aB+oMef1slp16b0rruu7+RcFlYQt/xm/QfaIoVIzc/wNtxxmMbuqPwUqji+DduzFE
         IqHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K3rJmmxER8Kegw8UROXilPnl76lOFWCMz2/TCfvPwNE=;
        b=HeevnSUH8Hq8nRWx0fccJ3jGlTM1mAqhkJ1noGmYnO1wnslpimfLFEqCoUAlMNvmDL
         MnTurRSAJoah+NInP6Ifb4dUO7phW9SlEG0JvalvBYX1bF6Y46bdSNdjvP1r4IAiIP5t
         mcUHcfIRObfIX0c6rAyIjh8FulikgOf+js6IRUCey4rg9kOU233alFYAbhU+NXh1WhIl
         CW3mUEXlOvb+hQLZJg5UXsVx6obTzFKJOoLgrSs9/YsTQ2yVoALndAHiE6GFjts3s8YA
         qPtY2dpvsWmjHKUpV3fkBs89BFimDzcVbeR3yqjalQ6dtg4wkB87S15OiXWENKdy6Y+e
         ryLw==
X-Gm-Message-State: AO0yUKWQVHQl/bo2MpwfezRqAKJ2oyuAt01NHM1vhC799MnyMsBsgrvr
        uH10ElkpMIdbW0mWmOoDftn1Iw==
X-Google-Smtp-Source: AK7set/e9e6INXRM8UZSttrpCCUWQNukafGMuRBR8M97UGEQ6RAhBU8kgbj2HiXIHnEsnJ/EZ/+0pg==
X-Received: by 2002:a17:90a:19c:b0:22c:1217:b0d9 with SMTP id 28-20020a17090a019c00b0022c1217b0d9mr3442271pjc.15.1676395468942;
        Tue, 14 Feb 2023 09:24:28 -0800 (PST)
Received: from [192.168.50.116] (c-24-4-73-83.hsd1.ca.comcast.net. [24.4.73.83])
        by smtp.gmail.com with ESMTPSA id bt14-20020a17090af00e00b002341ae23ad7sm1869693pjb.1.2023.02.14.09.24.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 09:24:28 -0800 (PST)
Message-ID: <5e440cfa-27c5-f216-5529-350ac19c07ff@rivosinc.com>
Date:   Tue, 14 Feb 2023 09:24:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH -next v13 10/19] riscv: Allocate user's vector context in
 the first-use trap
Content-Language: en-US
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        linux-kernel@vger.kernel.org
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-11-andy.chiu@sifive.com>
 <875ycdy22c.fsf@all.your.base.are.belong.to.us>
 <82551518-7b7e-8ac9-7325-5d99d3be0406@rivosinc.com>
 <87sff8ags6.fsf@all.your.base.are.belong.to.us>
 <CABgGipXSsqgtTx9bCy-gt7CTBkXN--t1wHgLfCxA3=vs6y+qUw@mail.gmail.com>
 <873578faxg.fsf@all.your.base.are.belong.to.us>
From:   Vineet Gupta <vineetg@rivosinc.com>
In-Reply-To: <873578faxg.fsf@all.your.base.are.belong.to.us>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/14/23 08:50, Björn Töpel wrote:
> Andy Chiu <andy.chiu@sifive.com> writes:
>
>> Hey Björn,
>>
>> On Tue, Feb 14, 2023 at 2:43 PM Björn Töpel <bjorn@kernel.org> wrote:
>>> So, two changes:
>>>
>>> 1. Disallow V-enablement if the existing altstack does not fit a V-sized
>>>     frame.
>> This could potentially break old programs (non-V) that load new system
>> libraries (with V), If the program sets a small alt stack and takes
>> the fault in some libraries that use V. However, existing
>> implementation will also kill the process when the signal arrives,
>> finding insufficient stack frame in such cases. I'd choose the second
>> one if we only have these two options, because there is a chance that
>> the signal handler may not even run.
> I think we might have different views here. A process has a pre-V, a and
> post-V state. Is allowing a process to enter V without the correct
> preconditions a good idea? Allow to run with V turned on, but not able
> to correctly handle a signal (the stack is too small)?

The requirement is sane, but the issue is user experience: User trying 
to bring up some V code has no clue that deep in some startup code some 
alt stack had been setup and causing his process to be terminated on 
first V code.

>
> This was the same argument that the Intel folks had when enabling
> AMX. Sure, AMX requires *explicit* enablement, but same rules should
> apply, no?
>
>>> 2. Sanitize altstack changes when V is enabled.
>> Yes, I'd like to have this. But it may be tricky when it comes to
>> deciding whether V is enabled, due to the first-use trap. If V is
>> commonly used in system libraries then it is likely that V will be
>> enabled before an user set an altstack. Sanitizing this case would be
>> easy and straightforward.

Good. Lets have this in v14 as it seems reasonably easy to implement.

>> But what if the user sets an altstack before
>> enabling V in the first-use trap? This could happen on a statically
>> program that has hand-written V routines. This takes us to the 1st
>> question above, should we fail the user program immediately if the
>> altstack is set too small?

Please lets not cross threads. We discussed this already at top. While 
ideally required, seems tricky so lets start with post-V alt stack check.

> For me it's obvious to fail (always) "if the altstack is too small to
> enable V", because it allows to execute V without proper preconditions.
>
> Personally, I prefer a stricter model. Only enter V if you can, and
> after entering it disallow changing the altstack.
>
> Then again, this is *my* opinion and concern. What do other people
> think? I don't want to stall the series.

I concur that the alt stack checking requirements are sensible in the 
long run. We can add the obvious check for post-V case and see if there 
is a sane way to flag pre-V case to.


>
>>> Other than the altstack handling, I think the series is a good state! It
>>> would great if we could see a v14 land in -next...
>> Thanks. I am reforming the v14 patch and hoping the same to happen soon too!
> Thank you for your hard work! It would be awesome to *finally* have
> vector support in the kernel!

Indeed we've come a long way, lets push the gear so we can use the 
coming cycle to flesh out any changes for a possible 6.4 inclusion.

Thx,
-Vineet
