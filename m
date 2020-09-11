Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54506266322
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 18:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgIKQKu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 12:10:50 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50822 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726158AbgIKPk1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Sep 2020 11:40:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599838825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dk+Kgm/gjjYqWQcgUSFQ2I08B4Y+XRe0xG6joXjPX98=;
        b=gtF3yEhInX8u72BoVwAebbMvjmaDOaT8uXW5ozZoodmWyWDGdiRPobMo+rDb4RGM3oqt5x
        sndLNFpD3Isz7Q/sfW/50OIEau6Fbn1XnQvnH9Cr2UNYdS3VSlu+rsZfcsN9vrnl9wzhqe
        eFXyl4RdY3Aei3d9sTFyAC03eNswsZg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-8NFyQUtHMECNS_8Uq1jHkw-1; Fri, 11 Sep 2020 11:40:24 -0400
X-MC-Unique: 8NFyQUtHMECNS_8Uq1jHkw-1
Received: by mail-wm1-f71.google.com with SMTP id 189so1511211wme.5
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 08:40:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dk+Kgm/gjjYqWQcgUSFQ2I08B4Y+XRe0xG6joXjPX98=;
        b=ZZTAe4LJTwLEs0ztOQwM0bIvT0gIFyol8Xh1P1vjBDZeAA1s83kOo9FlMRojAv2XZV
         cehzvqUAKT30q+C3kfIDVHufbE2KOGKLzFKNT+LxZEbnoALUypDvOT0KO0nku/VW51mx
         9O0T/aIFre+FP607sGqeEMWeOXl3LhWWptWnd9O9h2eMyEgRKtnFE5c62GdnXK6j++9r
         bFChsYJppXtDDKGrXbZnUL1hK5+Zt/Wuh6XOSpBU0tBtn7CGj5jYmDK1ixG2rBD/ogB3
         rZ8HR3i65NZMD2xkgla+qrv72/BYDBlCLrKTh/dtSJTK9ZhNGAd6xng+bHteqMxYrNVF
         nHBg==
X-Gm-Message-State: AOAM532r8rCXOOgE5FcfqZ3Pm5YJV1K97fgWfVlwANwHKXxIdl/vkEi6
        EMi7upLo8zgTnmoslS804bivk/O8xfEcH4UNCNRzF+VWiFNvE+tdyLGO3AC7O2ONX6U4oPM0s0l
        idoE499ESlC+Q
X-Received: by 2002:adf:fe42:: with SMTP id m2mr2569547wrs.367.1599838822707;
        Fri, 11 Sep 2020 08:40:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzB61Hh6R6J7ydHYImNz+B1xFLNiwsBAcXzLMvmMs62Z6hd/ni77KrrH/mVvM0CXjaeUJFWTQ==
X-Received: by 2002:adf:fe42:: with SMTP id m2mr2569521wrs.367.1599838822491;
        Fri, 11 Sep 2020 08:40:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5568:7f99:4893:a5b6? ([2001:b07:6468:f312:5568:7f99:4893:a5b6])
        by smtp.gmail.com with ESMTPSA id 9sm5060186wmf.7.2020.09.11.08.40.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 08:40:22 -0700 (PDT)
Subject: Re: [PATCH] nSVM: Add a test for the P (present) bit in NPT entry
To:     Jim Mattson <jmattson@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>
References: <20200829005720.5325-1-krish.sadhukhan@oracle.com>
 <CALMp9eSiB=NkuZJV+m-j-KcxqVzkqTf5fUS7r9vBSaY8TyK_Rg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4f128dbf-e1bb-76b9-dff7-61bc26b91cf9@redhat.com>
Date:   Fri, 11 Sep 2020 17:40:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eSiB=NkuZJV+m-j-KcxqVzkqTf5fUS7r9vBSaY8TyK_Rg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/08/20 23:55, Jim Mattson wrote:
> On Fri, Aug 28, 2020 at 5:57 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>>
>> If the P (present) bit in an NPT entry is cleared, VMRUN will fail and the
>> guest will exit to the host with an exit code of 0x400 (#NPF). The following
>> bits of importance in EXITINFO1 will be set/cleared to indicate the failure:
>>
>>         bit# 0: cleared
>>         bit# 32: set
> 
> This seems like a terrible commit description. First, the P bit can be
> cleared in a plethora of NPT entries without having any effect on
> guest execution. It's only if the guest tries to access a GPA whose
> translation uses the non-present NPT entry that there is an issue.
> Second, the VMRUN does not fail. If the VM-exit code is anything other
> than -1, the VMRUN has succeeded. Third, the bits in EXITINFO that get
> set/cleared depend very much on the actual access. Yes, if the nested
> page walk terminates due to a non-present page, bit 0 will be cleared.
> However, bit 32 will only be set if the non-present page was
> encountered while translating the final guest physical address (not
> the guest physical address of a page table page encountered during the
>  walk). Moreover, older AMD hardware never sets bits 32 or 33 at all.
> Bit 1 will be set if the access was a write (or a page table walk).
> Bit 2 will be set for a user access. Bit 4 will be set for a code read
> (while translating the final guest physical address).
> 

Queued, with an adjusted commit message.

I am currently on leave so I am going through the patches and queuing
them, but I will only push kvm/next and kvm/queue next week.  kvm/master
patches will be sent to Linus for the next -rc though.

Thanks,

Paolo

