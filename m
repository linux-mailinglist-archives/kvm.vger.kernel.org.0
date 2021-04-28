Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEABF36D600
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 12:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239637AbhD1K4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 06:56:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57410 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238863AbhD1K4Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Apr 2021 06:56:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619607331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zvc3vNNxz45rt/LCFpFY8oVLaPcFw8dZ49me47+TJac=;
        b=W7oeGQVsliRMpYnvBKO7FLsJrNl5YyE65QRwah6bNho+IOfq7zgcPf4O1reu1a4uYwU/ff
        v5oQ4OU34oPhS7SJ/Qxu+3pZ3Vv3WtmDjjRzcfrdP0URETbFreGrAq608PgXS1Sf5Mki/Y
        4xHk6Kqqy5/L/tATKcuPRvuCwGmzI4k=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-MskaxAavMoGAymlMnbvVpQ-1; Wed, 28 Apr 2021 06:55:30 -0400
X-MC-Unique: MskaxAavMoGAymlMnbvVpQ-1
Received: by mail-ej1-f71.google.com with SMTP id x21-20020a1709064bd5b029037c44cb861cso12197107ejv.4
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 03:55:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zvc3vNNxz45rt/LCFpFY8oVLaPcFw8dZ49me47+TJac=;
        b=lnof7IEdCJDJi/bK2vKOkRJOzMtK+EeIkybZ2dv24qiobOPZTR8QFSC4NqnnDazfJH
         NkPmHuLF+mnuE27ZPCzCCBygciGcqepIsT7ohw0wgfRSIInZuclKwMYy4zunzLgSnx+M
         9H9o8WUFE3HE/4uzI5yzAa5k5Q+5jPIOaKGVOPvJM7Fqr9er80nwu5+Vg/oGTh08L6Au
         paTnZvmQ9faOpgeBDbzf1OkOHtjrpuxKn2XJ3GM5ZCk6t5jOPI8vslpwAgCTyFuWkp++
         HczjcbMuqDFTPgVU0rRl0p/X4VuLTK+OubZ+I6q34D/s4W+LpIDJHRn+kv9rV6YVO0Nh
         0trA==
X-Gm-Message-State: AOAM533PtCOX531Na+1o9V5xwhkekH+/bMOvUHuJvaKCgxWKX82t1nzy
        iJ+8gb3CPvPAEeAuLiA4LeuYbgJjp508EYuw7lnteoY3KuSjcMl4vk/7qo0oEEXGdonh1X2oIQv
        LJ68gEGxIU/oquyY4INRNWs37YL5Wyf9/WGA3c5ZsvH9UHrrm0B5GbRokm5S4cue0
X-Received: by 2002:a17:906:28d4:: with SMTP id p20mr28615893ejd.552.1619607328324;
        Wed, 28 Apr 2021 03:55:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYn7xonP1V7TNDer5HGzhc8B7Rjp3DtgnbvYRlOWZD2AOyvF3yrtc96WiL6D6v/Fl0D8tS6Q==
X-Received: by 2002:a17:906:28d4:: with SMTP id p20mr28615866ejd.552.1619607328048;
        Wed, 28 Apr 2021 03:55:28 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id k12sm4596828edo.50.2021.04.28.03.55.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 03:55:27 -0700 (PDT)
Subject: Re: [PATCH 3/3] x86/msr: Rename MSR_K8_SYSCFG to MSR_AMD64_SYSCFG
To:     Borislav Petkov <bp@alien8.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, tglx@linutronix.de, jroedel@suse.de,
        thomas.lendacky@amd.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210427111636.1207-1-brijesh.singh@amd.com>
 <20210427111636.1207-4-brijesh.singh@amd.com> <YIk8c+/Vwf30Fh6G@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9e687194-5b68-9b4c-bf7f-0914e656d08f@redhat.com>
Date:   Wed, 28 Apr 2021 12:55:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YIk8c+/Vwf30Fh6G@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/04/21 12:44, Borislav Petkov wrote:
> On Tue, Apr 27, 2021 at 06:16:36AM -0500, Brijesh Singh wrote:
>> The SYSCFG MSR continued being updated beyond the K8 family; drop the K8
>> name from it.
>>
>> Suggested-by: Borislav Petkov <bp@alien8.de>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
> 
> Thanks, looks good.
> 
>>   Documentation/virt/kvm/amd-memory-encryption.rst | 2 +-
>>   Documentation/x86/amd-memory-encryption.rst      | 6 +++---
>>   arch/x86/include/asm/msr-index.h                 | 6 +++---
>>   arch/x86/kernel/cpu/amd.c                        | 4 ++--
>>   arch/x86/kernel/cpu/mtrr/cleanup.c               | 2 +-
>>   arch/x86/kernel/cpu/mtrr/generic.c               | 4 ++--
>>   arch/x86/kernel/mmconf-fam10h_64.c               | 2 +-
>>   arch/x86/kvm/svm/svm.c                           | 4 ++--
>>   arch/x86/kvm/x86.c                               | 2 +-
> 
> The kvm side needs sync with Paolo on how to handle so that merge
> conflicts are minimized.
> 
> Paolo, thoughts?

There shouldn't be any conflicts right now, but perhaps it's easiest to 
merge the whole series for -rc2.

In any case,

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

