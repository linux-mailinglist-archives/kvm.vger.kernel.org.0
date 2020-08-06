Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A3923D861
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 11:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgHFJOy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 05:14:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46650 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726094AbgHFJOw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 05:14:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596705291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PptWRBZ+0zU2m0TTKrUzMYdhKSdC7q+oaIaAdKw+itE=;
        b=Xjth3DIHzEaq81A3sMi38JkT2CEdQAm6fP+h4qjh9+HrbjExBd1Ie1gV+65mNNsupaC4ak
        W7ZMH+BU3+QAxF8dADNzS2Vk3mbP6NYBx/30AzEdtQS93iH09zJcI14VufKT/6XjxqAImf
        dIqocf4qEcAJ1ydylbY4YoUHgOBdNLM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-h1W8OeNqNyi6yv9DppuY8A-1; Thu, 06 Aug 2020 05:14:49 -0400
X-MC-Unique: h1W8OeNqNyi6yv9DppuY8A-1
Received: by mail-ej1-f72.google.com with SMTP id ew2so5475941ejb.8
        for <kvm@vger.kernel.org>; Thu, 06 Aug 2020 02:14:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=PptWRBZ+0zU2m0TTKrUzMYdhKSdC7q+oaIaAdKw+itE=;
        b=MGIZpCJ7W0CCGqP1hdSE1RvfXbzlBthdnnwKZHvDBzjS/9tEvHYtQPRq5+K7MyYr9f
         0X91l0KT8w7SViVHzuCNGfFQkXxj7nP2ORBjwhHluH7W1hS3mVhpxjnW+GVTlHS54Oi2
         GoJBna6nAuFWdyCOMwSW4ZIaoUzG6Jh7JgPHKitec+XONOJPlkdeOXP37/j65PjiRrN5
         NVF4lxp2XT6gXc8f5kNfympBCT+ZETvLF4cCfsJ+AgR0FVxIEqRiEAbfMNyBga/voQPj
         eNcK2MwB9322X7Fn6SqRrPI+BimrpLDx6nJvpWOZuLiXvfO0W1HyRCU4Z4hg8dHWXeU4
         qnUQ==
X-Gm-Message-State: AOAM53263VhxpPecTceXIaofQb5/4CaEeklhwzZArmDFbslT1zLpXM1l
        /VRcdMimCDoDGxMOlAX3y0byvORbtfSU1En5fstfiQ+fJlnMKHbLKNJxBLtNJU8z8mjMAcIchSo
        y+NszmSIJIvXs
X-Received: by 2002:a17:906:9392:: with SMTP id l18mr3298281ejx.357.1596705288184;
        Thu, 06 Aug 2020 02:14:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwI0pHI6XZUb7InmN6q7wFebkW/fuUjhF2ooS5eJKhMI9OIcTZ5cCFPIWQVQwpkr0p5dcw3eg==
X-Received: by 2002:a17:906:9392:: with SMTP id l18mr3298261ejx.357.1596705287973;
        Thu, 06 Aug 2020 02:14:47 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id n11sm3072328edv.39.2020.08.06.02.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 02:14:47 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Peter Xu <peterx@redhat.com>, Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: x86: introduce KVM_MEM_PCI_HOLE memory
In-Reply-To: <CALMp9eSWsvufDXMuTUR3Fmh91O7tHUaqpDbAoavSMc=prpcDzg@mail.gmail.com>
References: <20200728143741.2718593-1-vkuznets@redhat.com> <20200728143741.2718593-3-vkuznets@redhat.com> <CALMp9eSWsvufDXMuTUR3Fmh91O7tHUaqpDbAoavSMc=prpcDzg@mail.gmail.com>
Date:   Thu, 06 Aug 2020 11:14:46 +0200
Message-ID: <875z9wp249.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> On Tue, Jul 28, 2020 at 7:38 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>> PCIe config space can (depending on the configuration) be quite big but
>> usually is sparsely populated. Guest may scan it by accessing individual
>> device's page which, when device is missing, is supposed to have 'pci
>> hole' semantics: reads return '0xff' and writes get discarded. Compared
>> to the already existing KVM_MEM_READONLY, VMM doesn't need to allocate
>> real memory and stuff it with '0xff'.
>
> Note that the bus error semantics described should apply to *any*
> unbacked guest physical addresses, not just addresses in the PCI hole.
> (Typically, this also applies to the standard local APIC page
> (0xfee00xxx) when the local APIC is either disabled or in x2APIC mode,
> which is an area that kvm has had trouble with in the past.)

Yes, we can make KVM return 0xff on all read access to unbacked memory,
not only KVM_MEM_PCI_HOLE slots (and drop them completely). This,
however, takes the control from userspace: with KVM_MEM_PCI_HOLE
memslots we're saying 'accessing this unbacked memory is fine' and we
can still trap accesses to all other places. This should help in
detecting misbehaving guests.

-- 
Vitaly

