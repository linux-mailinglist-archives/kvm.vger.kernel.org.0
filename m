Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE375462EA5
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 09:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239664AbhK3Ipb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 03:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234779AbhK3Ipa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 03:45:30 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE88BC061574
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 00:42:11 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id y12so83472443eda.12
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 00:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QLbMQzl1X+oHEzaxcOOqKrksyfgto3xGZeHdEUiRnVs=;
        b=RdbKO6wreiFqS+T4UuJh6APikHHMMDD1xcLpVsI4sagoj9YoK1vqJd+kY/OswfT3Ql
         /eRFNpCI3Me//CGSocy2lAsyhtRk2XeG5H6eTiqgXlhFiFNq1PhVMWjs/1Sa5BuaRSri
         nybMsCzqsMkqXfK7LJdNTOSTT/VL9eqdjSnuMUU2/Cme1o7vvlnytFg5YLAbQQz52l81
         71MxewiYzx+LIkG+qxixKuScGqMz5OY06kHM7YhbjMkSG7mrn1eHdFPoCTN6wlq18+/D
         bY3ExYQ1pT8wa9lrVkEjkyhwWlzYcGfILXpctxwD0HfX8Pf2Qs8T7NpwrOKOt7TylOMs
         HNBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QLbMQzl1X+oHEzaxcOOqKrksyfgto3xGZeHdEUiRnVs=;
        b=1jfCgWAWBp2f3AMb2pyDSmWDF317nYdBoTAMQa3QijazqHwszQwAqAHiTAhDlvLjfJ
         7QAx29JkL1bJdeSlNY7h149bo426DKuciZ7AN2jEy/9YWA/vTThPnOtlNIDOJNtL8doo
         Z2cZYVMGEq5dA8TSKpiHIG0I3v0oB1iTvgyciBKwyQ72G+C+8Nyz0e/TwZQCssV5bgaK
         fQjX6ln6Y8ZUMZYu4i0Fi2EY2pV5fgBpShKPTLFQNT7bBYUQEwu2SZYe7GfBt2TtOswZ
         303kBNWgUckoRxzdd+ZtufaO2jFmdrVMnJ2GGeeGHv8MJx42sHdPvhZWiSIDw4ZFGD2O
         SOFw==
X-Gm-Message-State: AOAM533RxCzYMELDoUbTZvuYUmC4Y6EmtxaaoTrzU8Pyte++g1iAWf7N
        IqKTFxm9izhsLorqvrKdL4g=
X-Google-Smtp-Source: ABdhPJy2SlvJPNwkAeQbv3fpT+6k+hx1j6I2rVfP2tOJ0wt19hzEXcChbO04aKIis7fIx14EfTku6A==
X-Received: by 2002:a17:906:d54d:: with SMTP id cr13mr22216716ejc.409.1638261730235;
        Tue, 30 Nov 2021 00:42:10 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id nc24sm4711525ejc.94.2021.11.30.00.42.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 00:42:09 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <8aaac107-4b90-4eb3-8c73-a5e323462707@redhat.com>
Date:   Tue, 30 Nov 2021 09:42:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v2 0/3] Regression test for L1 LDTR
 persistence bug
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
References: <20211015195530.301237-1-jmattson@google.com>
 <ec57f5d2-f3bb-1fa6-bcdf-9217608756f5@redhat.com>
 <CALzav=c63DpoBYzhkWeU20tiiH7uv1HfsUaM=RFTuAWOZSybMg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALzav=c63DpoBYzhkWeU20tiiH7uv1HfsUaM=RFTuAWOZSybMg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/29/21 23:19, David Matlack wrote:
>> The selftests infrastructure already has save/restore tests at
>> instruction granularity (state_test.c) so you should have more luck that
>> way; these tests are worthwhile anyway.
> There is also (I just discovered) support for guest-triggerable
> migration in the kvm-unit-tests [1]. You could use that to trigger a
> save/restore.

There is, but I don't think it's good.  Save/restore bugs almost 
invariably depend on very specific processor state, and it's hard to 
ensure that in kvm-unit-tests (except probabilistically, but we can do 
better).

Paolo

> [1] Example:https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/blob/master/arm/gic.c#L798
> 

