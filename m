Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2314D2327DE
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 01:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgG2XIR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 19:08:17 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38862 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726876AbgG2XIR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Jul 2020 19:08:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596064095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cIiXcFyvXpes1TnL1+wTHGXIVVbSubmFJ3ChguRJtb0=;
        b=ABtJD8JkbZVy4x3JZjxi8OnUTzaX0utRtEDySgXDKNox3v+EwPzcDJ6Ogvv3/6hJOrzg/x
        vTI/z8hi7cbcGWBLaJOSozgKNv3kuMNfpwLHYw2oh+sM9T0Pn7xqKjHnZNr1fQbgiusi5Z
        MLLMzdf/MmpdOzRcdSnCq6qpgzO3p18=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-3mL-CSQHMIa7aIFjneAmAw-1; Wed, 29 Jul 2020 19:08:13 -0400
X-MC-Unique: 3mL-CSQHMIa7aIFjneAmAw-1
Received: by mail-wm1-f72.google.com with SMTP id l5so1556415wml.7
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 16:08:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cIiXcFyvXpes1TnL1+wTHGXIVVbSubmFJ3ChguRJtb0=;
        b=rT2wHJT+6ag6+CUEwt3GOe97+5tL1+jHzYUq6A4yCh8E8s5Z0x7i+nCwbG/dHJ5WiY
         foF8p9VJJvIDI8+8pVfIIDIKlmC0qZsSodP/SunfE6rtul31+obg3dz5Q9lwdBUL+8bq
         z1d0+Qs0qJmGu7vZFBaEcFxzqPSsV+GMlXRsd8kMwPFYDnXpXBvYyMLCSHWi7aGd39uz
         Tcj20/sc2pXwP/Uw9pJYZf+VQjhvT2M0bzsjmCE+QzOq85NL+5imDXDw30KN+Vb3fmJL
         f3kGvAGANUDb2ReJeFjCa0NhwCgaYYq5hoVCOzIgulhSbykBa+XtWmpi5ZozywPoqEuB
         vFSQ==
X-Gm-Message-State: AOAM533hwe/bv7Y1XqBTtt6SqLpOBmh9ql4V555a+BmX7Oy1nMY7Lvck
        xoUoz+6zQMfP85941aFDo8FcYj5bOrlOusSt/RzPOu+aTSmpGZJZCtqCC5hxduz3w3tDff+cC9K
        eeHw5epdM2pRA
X-Received: by 2002:adf:bb14:: with SMTP id r20mr17776wrg.366.1596064092189;
        Wed, 29 Jul 2020 16:08:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz23ETCraz9nu5BZ3LgJYRp/3yYB2g1A0+QLPdg/44/6iAl4RguA3HO5UuXK/5dOCTgtIIlCA==
X-Received: by 2002:adf:bb14:: with SMTP id r20mr17756wrg.366.1596064091926;
        Wed, 29 Jul 2020 16:08:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:101f:6e7:e073:454c? ([2001:b07:6468:f312:101f:6e7:e073:454c])
        by smtp.gmail.com with ESMTPSA id b63sm6682694wme.41.2020.07.29.16.08.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2020 16:08:11 -0700 (PDT)
Subject: Re: [PATCH v3 02/11] KVM: SVM: Change intercept_cr to generic
 intercepts
To:     Babu Moger <babu.moger@amd.com>, Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
 <159597948045.12744.16141020747986494741.stgit@bmoger-ubuntu>
 <CALMp9eTDKX7L0ntOo-hsirk2dET1ZG4tofgvQ4SX9kdwEQoPtw@mail.gmail.com>
 <d11694cd-7c75-9dbb-0ccd-9b1927fa2da1@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <67dad5ee-1c70-b892-918a-8e7126aa4a5f@redhat.com>
Date:   Thu, 30 Jul 2020 01:08:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <d11694cd-7c75-9dbb-0ccd-9b1927fa2da1@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/20 18:08, Babu Moger wrote:
>>>
>>>         if (g->int_ctl & V_INTR_MASKING_MASK) {
>>>                 /* We only want the cr8 intercept bits of L1 */
>>> -               c->intercept_cr &= ~(1U << INTERCEPT_CR8_READ);
>>> -               c->intercept_cr &= ~(1U << INTERCEPT_CR8_WRITE);
>>> +               __clr_intercept(&c->intercepts, INTERCEPT_CR8_READ);
>>> +               __clr_intercept(&c->intercepts, INTERCEPT_CR8_WRITE);
>> Why the direct calls to the __clr_intercept worker function? Can't these be calls
>> to clr_cr_intercept()?
>> Likewise throughout.
> This code uses the address to clear the bits.  So called __clr_intercept
> directly. The call clr_cr_intercept() passes the structure vcpu_svm and
> then uses get_host_vmcb to get the address.

Yes, this is correct.

Paolo

