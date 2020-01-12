Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5430B1386AE
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2020 14:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732922AbgALNpR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Jan 2020 08:45:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57490 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732915AbgALNpR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Jan 2020 08:45:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578836714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JFL2PZFkYCUq9EBkZ1f9ZZgtG4mRI3t6MhkcDGaPmQA=;
        b=YM6skxc6rKUqoDm45mFzoeLNFFTPcYTOBndf4+gjBTcMsv4QvwJ9eI4sCBbvzyThK3w8Tw
        uGWEu0jJuqJDq853XG7mXsLL5hF9hXsQ5LfS52OaFaAQ+A/mK8AiLEHuGdlzt9DFC+moQ+
        /TLr/5g+qU1QBX/UQ+b8dRv7TJ+dl6o=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-CCJ1efMPMbi2qFdL2uPspg-1; Sun, 12 Jan 2020 08:45:12 -0500
X-MC-Unique: CCJ1efMPMbi2qFdL2uPspg-1
Received: by mail-wr1-f71.google.com with SMTP id f15so3692975wrr.2
        for <kvm@vger.kernel.org>; Sun, 12 Jan 2020 05:45:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JFL2PZFkYCUq9EBkZ1f9ZZgtG4mRI3t6MhkcDGaPmQA=;
        b=sdZUhf836ms9ZSaINFH5OJ/1rFLRTsDOMkBrRK/BFI70ZVhTQuoLs5Fg9KNoZGPNGJ
         Q7psGgDkW6nIKQT0RPrdfjMGbkoFArV/yuE4bIw+ZMwSgYXP/Yectzipo4fCutadiiOd
         IzB8vPHpfNQTCSMx75r/7iD2aFCT3utJLcqP5z/l+IPbSk/6bB17xCjSbu5TR93bQicW
         gh9gWPqnLsjS5/sUIASQBAjJoHPwW+aT2RYRp8uHc9IXBanRSwK7VA+gfbvtninufLDv
         gJWO19THNw6J2xHEN2FT7SufKtmsVKYDNxArjNjyzeHQfT08vg5LchX7brM7/q+QrycU
         4jqg==
X-Gm-Message-State: APjAAAW7DJwqBCa8eaa1kSFqT4e6vWVnbqb74J7FIC4YZzVQ/NNpCwxS
        i3otV2xv0il0SFy6Sk6JfKPw+OML4vc0x2EE39sK0OHMceARxpsjhkkG2UM5SWd5odWxQEzOS4p
        llwm75L4fYOAc
X-Received: by 2002:adf:e3cd:: with SMTP id k13mr13027056wrm.338.1578836711149;
        Sun, 12 Jan 2020 05:45:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqyksaEmElv2UTCB/l/18UFqbEAYTSoV5f6uKSxAKpAnVb6fo0pyYB/gKSnmWVoZ/sTqC2KwVw==
X-Received: by 2002:adf:e3cd:: with SMTP id k13mr13027042wrm.338.1578836710928;
        Sun, 12 Jan 2020 05:45:10 -0800 (PST)
Received: from ?IPv6:2a01:cb1d:8a0a:f500:48c1:8eab:256a:caf9? ([2a01:cb1d:8a0a:f500:48c1:8eab:256a:caf9])
        by smtp.gmail.com with ESMTPSA id q6sm11096257wrx.72.2020.01.12.05.45.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jan 2020 05:45:10 -0800 (PST)
Subject: Re: [PATCH 10/15] memory: Replace current_machine by
 qdev_get_machine()
To:     Alistair Francis <alistair23@gmail.com>
Cc:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "open list:Overall" <kvm@vger.kernel.org>,
        Juan Quintela <quintela@redhat.com>,
        "open list:New World" <qemu-ppc@nongnu.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        qemu-arm <qemu-arm@nongnu.org>,
        Alistair Francis <alistair.francis@wdc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <rth@twiddle.net>
References: <20200109152133.23649-1-philmd@redhat.com>
 <20200109152133.23649-11-philmd@redhat.com>
 <CAKmqyKNrgTbiipNK1wrwCMqk_=7cJmc4rBwO1zxjFiVV+TRSgQ@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <f7e3539a-4506-0df1-ee66-f3d8a6aa8fce@redhat.com>
Date:   Sun, 12 Jan 2020 14:45:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAKmqyKNrgTbiipNK1wrwCMqk_=7cJmc4rBwO1zxjFiVV+TRSgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/12/20 10:48 AM, Alistair Francis wrote:
> On Thu, Jan 9, 2020 at 11:29 PM Philippe Mathieu-Daudé
> <philmd@redhat.com> wrote:
>>
>> As we want to remove the global current_machine,
>> replace 'current_machine' by MACHINE(qdev_get_machine()).
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>   memory.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/memory.c b/memory.c
>> index d7b9bb6951..57e38b1f50 100644
>> --- a/memory.c
>> +++ b/memory.c
>> @@ -3004,6 +3004,7 @@ static void mtree_print_flatview(gpointer key, gpointer value,
>>       int n = view->nr;
>>       int i;
>>       AddressSpace *as;
>> +    MachineState *ms;
>>
>>       qemu_printf("FlatView #%d\n", fvi->counter);
>>       ++fvi->counter;
>> @@ -3026,6 +3027,7 @@ static void mtree_print_flatview(gpointer key, gpointer value,
>>           return;
>>       }
>>
>> +    ms = MACHINE(qdev_get_machine());
> 
> Why not set this at the top?

Calling qdev_get_machine() is not free as it does some introspection 
checks. Since we can return earlier if there are no rendered FlatView, I 
placed the machinestate initialization just before it we need to access it.

> Alistair
> 
>>       while (n--) {
>>           mr = range->mr;
>>           if (range->offset_in_region) {
>> @@ -3057,7 +3059,7 @@ static void mtree_print_flatview(gpointer key, gpointer value,
>>           if (fvi->ac) {
>>               for (i = 0; i < fv_address_spaces->len; ++i) {
>>                   as = g_array_index(fv_address_spaces, AddressSpace*, i);
>> -                if (fvi->ac->has_memory(current_machine, as,
>> +                if (fvi->ac->has_memory(ms, as,
>>                                           int128_get64(range->addr.start),
>>                                           MR_SIZE(range->addr.size) + 1)) {
>>                       qemu_printf(" %s", fvi->ac->name);
>> --
>> 2.21.1
>>
>>
> 

