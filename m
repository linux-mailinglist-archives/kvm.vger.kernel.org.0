Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38ECB1D5560
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 18:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgEOP7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 11:59:50 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50576 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726293AbgEOP7u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 11:59:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589558388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iGZXFwumSbdNNYAeiggV8U4re8SO4/3betnreXnOP68=;
        b=Yp2WmewfAw9QVLo5XbPRAbeoiAw66yszHg5nywd18NHEUpk4cAW5opYG16VZPqOxTOSqTM
        bmuqt0v0y1GMna3N2hUmJKZlBchSEqjYYM/XXc7PST8ZKz1YTylVSVkUutbSromJdHzSF+
        WJty/5CbViq/YvhSFyNysdpbZZmF33s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-h4b4876HOuO9aCqCiKqesA-1; Fri, 15 May 2020 11:59:46 -0400
X-MC-Unique: h4b4876HOuO9aCqCiKqesA-1
Received: by mail-wm1-f71.google.com with SMTP id g10so1391125wme.0
        for <kvm@vger.kernel.org>; Fri, 15 May 2020 08:59:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iGZXFwumSbdNNYAeiggV8U4re8SO4/3betnreXnOP68=;
        b=BmwzswEmH4C9hToQDXN1CJgqmQUmFjSf0kdRjld/9pgleo/7uVIMTmGJKEfi5cemmj
         eMMRLRWqmBQTCQ5q2F9rA7OP5ChX8qsdDoQbKZL1fLdEUq10i8/ys9T1Dckf9+CQwJrg
         EBBnccfo+STxVDgG1U9tdzGADBmwHXGCVFwzDXsiopK0DRq7kn5elYuydGjepCS5p4qj
         xrY0igtGGiGQHNXrNr/W/jfntQkbLF9hFrkiCQgGfCUjnCyGKN7NgWAnEJauvAGkBjJ1
         UbVI51RkPOlSYzTq6Tr4OP3Tj/qeO6Ss1RWmDRnNmEUjbh2sB+BEULVXUuE5pjG8N0ff
         TA/A==
X-Gm-Message-State: AOAM530nULaoK31h41LiESQm+vt8StZPrrniLUg5soRSWe9/YC9Pt54d
        MbZ6s36ZOWOiJFYOmFDU46P/9aSQR8g1zJ8GXf1gHnsedTIHW3IWeccsYqjwzJh5acCeGIVq+MD
        vTeKKoKB8EZUL
X-Received: by 2002:adf:d841:: with SMTP id k1mr4873037wrl.129.1589558385457;
        Fri, 15 May 2020 08:59:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSnUkPKjiUFYzyVHnxEbwzqPOvyHVqk4g3owBqQZqHtbskp7Ls7B+c3JLBHhLBGtvBBxcDeQ==
X-Received: by 2002:adf:d841:: with SMTP id k1mr4873013wrl.129.1589558385172;
        Fri, 15 May 2020 08:59:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:60bb:f5bd:83ff:ec47? ([2001:b07:6468:f312:60bb:f5bd:83ff:ec47])
        by smtp.gmail.com with ESMTPSA id w12sm4196501wmk.12.2020.05.15.08.59.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 08:59:44 -0700 (PDT)
Subject: Re: [PATCH 2/8] KVM: x86: extend struct kvm_vcpu_pv_apf_data with
 token info
To:     Vivek Goyal <vgoyal@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
References: <20200511164752.2158645-1-vkuznets@redhat.com>
 <20200511164752.2158645-3-vkuznets@redhat.com>
 <20200512152709.GB138129@redhat.com> <87o8qtmaat.fsf@vitty.brq.redhat.com>
 <20200512155339.GD138129@redhat.com> <20200512175017.GC12100@linux.intel.com>
 <20200513125241.GA173965@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0733213c-9514-4b04-6356-cf1087edd9cf@redhat.com>
Date:   Fri, 15 May 2020 17:59:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200513125241.GA173965@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/05/20 14:52, Vivek Goyal wrote:
>>> Also, type of event should not necessarily be tied to delivery method.
>>> For example if we end up introducing say, "KVM_PV_REASON_PAGE_ERROR", then
>>> I would think that event can be injected both using exception (#PF or #VE)
>>> as well as interrupt (depending on state of system).
>> Why bother preserving backwards compatibility?
> New machanism does not have to support old guests but old mechanism
> should probably continue to work and deprecated slowly, IMHO. Otherwise
> guests which were receiving async page faults will suddenly stop getting
> it over hypervisor upgrade and possibly see drop in performance.

Unfortunately, the old mechanism was broken enough, and in enough
different ways, that it's better to just drop it.

The new one using #VE is not coming very soon (we need to emulate it for
<Broadwell and AMD processors, so it's not entirely trivial) so we are
going to keep "page not ready" delivery using #PF for some time or even
forever.  However, page ready notification as #PF is going away for good.

That said, type1/type2 is quite bad. :)  Let's change that to page not
present / page ready.

Thanks,

Paolo

