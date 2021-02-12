Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5483C319CDE
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 11:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbhBLKwm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 05:52:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50328 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230399AbhBLKwj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 05:52:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613127073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J90exmfwr8uvT2pxkEllk1b4JYI35g7P87yhEwH1vw4=;
        b=OxF9S1nJpFKIAKyLOa5snw3iZSlLpQzwEYFTvms67lkY4LNZqmNB8RODf45qxSRVqhcjuM
        DAl8Vg+gEZ/4wXnlXnQGO6BZcLiq087/TcztgwjEQ7tfNFstZwX8JVGR7ji900FjrNQrkq
        J9c6WzDVRzfCRzgKSzWH32tWZudplL0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-cBWo43EqMSe1vbkesNXh3g-1; Fri, 12 Feb 2021 05:51:10 -0500
X-MC-Unique: cBWo43EqMSe1vbkesNXh3g-1
Received: by mail-ed1-f70.google.com with SMTP id o21so6433665edq.1
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 02:51:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J90exmfwr8uvT2pxkEllk1b4JYI35g7P87yhEwH1vw4=;
        b=AjV/WA5zl/IYdkF9cJ7T4TiIXoe+bZD4U2boEvnqf/7hwwx+KfNUrkqdEEe9U2kOGt
         BMu0HyGEUVtfrMxea92VMj0YB+NRv3kwM1b11/rp5206z2gSo2cnxcD/LixLnfmcvW7y
         v5BXytuo6K+V9jedfe9E4uqjHGBFWmIgWtby77CJYXaKX9ePLzxZ5igORkzI8cc/VHzb
         JSiZdXV4QDQS2ljiB/qBdBAWvL4GOEUkzT+QY53wWnsh5T5lFv24rN7GVA0T+JdM7t0M
         5niWSJaOS6mx0y+9RTV8nkRVo6RygV0xMSquC1tpPoYek7uDbbz2QpgbEg+CyerpGQ9f
         7jZA==
X-Gm-Message-State: AOAM531TLL19peL4gvvr7Ghy1bX2QInyBamQHA7vcb9OPj3ct12gAquN
        HgNW0Y5ED5HuydQNDCGcKEANnubYMcH1s5C2/0krYODrsr0zWBxENxwEal4yVLNj/6p11mpnBtv
        VjpPh0sKeEQYC
X-Received: by 2002:a17:906:c34d:: with SMTP id ci13mr2362907ejb.333.1613127069630;
        Fri, 12 Feb 2021 02:51:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxr7pk8xbUkM5+9rxZkFGRN3DZ+T9KdU7ZAHcik3HYskGIRC9vqlOiq64IlLZCvE/CaHuhS0A==
X-Received: by 2002:a17:906:c34d:: with SMTP id ci13mr2362898ejb.333.1613127069485;
        Fri, 12 Feb 2021 02:51:09 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g20sm587842ejz.54.2021.02.12.02.51.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 02:51:08 -0800 (PST)
Subject: Re: [PATCH 0/3] AMD invpcid exception fix
To:     Bandan Das <bsd@redhat.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, wei.huang2@amd.com, babu.moger@amd.com
References: <20210211212241.3958897-1-bsd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ac52c9b9-1561-21cd-6c8c-dad21e9356c6@redhat.com>
Date:   Fri, 12 Feb 2021 11:51:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210211212241.3958897-1-bsd@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/02/21 22:22, Bandan Das wrote:
> The pcid-disabled test from kvm-unit-tests fails on a Milan host because the
> processor injects a #GP while the test expects #UD. While setting the intercept
> when the guest has it disabled seemed like the obvious thing to do, Babu Moger (AMD)
> pointed me to an earlier discussion here - https://lkml.org/lkml/2020/6/11/949
> 
> Jim points out there that  #GP has precedence over the intercept bit when invpcid is
> called with CPL > 0 and so even if we intercept invpcid, the guest would end up with getting
> and "incorrect" exception. To inject the right exception, I created an entry for the instruction
> in the emulator to decode it successfully and then inject a UD instead of a GP when
> the guest has it disabled.
> 
> Bandan Das (3):
>    KVM: Add a stub for invpcid in the emulator table
>    KVM: SVM: Handle invpcid during gp interception
>    KVM: SVM:  check if we need to track GP intercept for invpcid
> 
>   arch/x86/kvm/emulate.c |  3 ++-
>   arch/x86/kvm/svm/svm.c | 22 +++++++++++++++++++++-
>   2 files changed, 23 insertions(+), 2 deletions(-)
> 

Isn't this the same thing that "[PATCH 1/3] KVM: SVM: Intercept INVPCID 
when it's disabled to inject #UD" also does?

Paolo

