Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4112F80B0
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 17:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbhAOQZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 11:25:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58127 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725910AbhAOQZV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 11:25:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610727835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pmIcydg61YYDzLXepSIjUfci/DymfOZYHTp/fahk6Ak=;
        b=FPtKWSB3fFqNsQlTBQoMxCBi2kSGc56mhb75sJW09bq2vAwhYRU1yzXV2ZFvD2+POImRFB
        ISGijun2XIXNhEEzbF1sP2YKJDlMOxUunyKyHrcBE/ywuAuS8yRs8651xNj/kGyZNuJnLd
        efk2ce4teN5M5hlMHin/3O9Nt8VLFdE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-DtD3l9T_PZ2rAQc7PS1ELg-1; Fri, 15 Jan 2021 11:23:35 -0500
X-MC-Unique: DtD3l9T_PZ2rAQc7PS1ELg-1
Received: by mail-ej1-f70.google.com with SMTP id ov1so3785662ejb.1
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 08:23:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=pmIcydg61YYDzLXepSIjUfci/DymfOZYHTp/fahk6Ak=;
        b=tDzAfSgXwBVUhg2bJ8Dodm+V0Kk/HkQMcCSIHTSUWa+4juU9N2/Ufjgz9h7dNKQBp7
         big2AV6+J+x/f/TrTVqdpwaLU+TzVxGuZtIuJg19/DWgD7lVPE0yse4pBYdfPSsIpYIb
         gBL6wqvlYv1fxezuNb/64lbMF+0I8KpLIE9R/m4d/sPt3NhrMv07BscVn/iCVRSi0bdq
         PnAubtITE3cG2FmgMZqLEW1O7hSXq1h24F1mbGvabFZHBc+rShHtgXB/kDy50ic7AaOC
         IvEs192g44QaeXGUjmz2izTnp+ySfTI79N0wPJXb+H7G8bN0IBx/4BXLd4iGQIUkNuzo
         3Igg==
X-Gm-Message-State: AOAM531Bx9uZC9xYmdfS3X+UEN4C0vXmJjidLTaxiE1DHPxCzk591/SK
        BEW07lWWMpb4xDQg+x8S4054aYvgzz+v7Rleg9RRzVP6gQjBHXdR0CjB+PRWUtCfD6mVVxn0yBR
        izOhU7KvI7RTI
X-Received: by 2002:a50:d888:: with SMTP id p8mr10375349edj.147.1610727814406;
        Fri, 15 Jan 2021 08:23:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxGQn0HOgWvfesZLc3zxvahgHbVibzwyTUfoPLmdXlwyi1vyCSaZdlC6HVyy1VjE/dqJDn4Wg==
X-Received: by 2002:a50:d888:: with SMTP id p8mr10375329edj.147.1610727814251;
        Fri, 15 Jan 2021 08:23:34 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id bc6sm784609edb.52.2021.01.15.08.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 08:23:33 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RFC 0/4] KVM: x86: Drastically raise KVM_USER_MEM_SLOTS
 limit
In-Reply-To: <YAG8t9ww/dgFaFht@google.com>
References: <20210115131844.468982-1-vkuznets@redhat.com>
 <YAG8t9ww/dgFaFht@google.com>
Date:   Fri, 15 Jan 2021 17:23:32 +0100
Message-ID: <87zh1a5fuj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Jan 15, 2021, Vitaly Kuznetsov wrote:
>> TL;DR: any particular reason why KVM_USER_MEM_SLOTS is so low?
>
> Because memslots were allocated statically up until fairly recently (v5.7), and
> IIRC consumed ~92kb.  Doubling that for every VM would be quite painful. 
>

I should've added 'now' to the question). So the main reason is gone,
thanks for the confirmation!

>> Longer version:
>> 
>> Current KVM_USER_MEM_SLOTS limit (509) can be a limiting factor for some
>> configurations. In particular, when QEMU tries to start a Windows guest
>> with Hyper-V SynIC enabled and e.g. 256 vCPUs the limit is hit as SynIC
>> requires two pages per vCPU and the guest is free to pick any GFN for
>> each of them, this fragments memslots as QEMU wants to have a separate
>> memslot for each of these pages (which are supposed to act as 'overlay'
>> pages).
>
> What exactly does QEMU do on the backend?  I poked around the code a bit, but
> didn't see anything relevant.
>

In QEMU's terms it registers memory sub-regions for these two pages (see
synic_update() in hw/hyperv/hyperv.c). Memory for these page-sized
sub-regions is allocated separately so in KVM terms they become
page-sized slots and previously continuous 'system memory' slot breaks
into several slots.

-- 
Vitaly

