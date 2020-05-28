Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3EB11E5D8E
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 13:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388036AbgE1LAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 07:00:19 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39566 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387926AbgE1LAA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 May 2020 07:00:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590663598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uAtwMEwAU7e6Ig2GLlYlZ1/unoKvCe+FnGy9o9JuaP0=;
        b=Gp0MFqPU91XOVS2wg9TIRFRuYerZaYh1dK3HoSfkGYEtOx7S15pocwE8P2PvG6TiZPxMTT
        ClRl02dwLXb/BnJSut5RS32gYC8rg8ZBBBQA8PQ8TeyBBHLrsflzEPegJ30z3a/T6/pyrh
        QCLTaR/Ee8BcpomewBCPpOxPolW2vN8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-8JlPWn5OPfuDcinIZWN00g-1; Thu, 28 May 2020 06:59:57 -0400
X-MC-Unique: 8JlPWn5OPfuDcinIZWN00g-1
Received: by mail-ed1-f70.google.com with SMTP id c10so11318499edw.17
        for <kvm@vger.kernel.org>; Thu, 28 May 2020 03:59:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uAtwMEwAU7e6Ig2GLlYlZ1/unoKvCe+FnGy9o9JuaP0=;
        b=sam/3Zbm4EnJRJoNiLazcKLnZI93/rVOO91LZn6PyMua4ixlHx90E0qXaxxghjE4k0
         WyAj+0Kw/VO/+vdlZK5az7SUEiEEGRZOh9zTdsa5/F0wPzPwJQAtqN2WHEk//iSoPGj2
         TClDmCXo+z4mcXMGpZZvq5nftIZDhdygheP43WzgmoofYTwh/hVsmN4w94xKj9Njt6eH
         kC/3MOPQ5ugRPEIQdop2AxgLjph8DE3F2gcwpisnJuI0Ydror3UD35IzvVregIFWJMaf
         Qi8SZxeIPpZss6PMNrUR44lzspoVwkM8HhVGR6FLPhv97Kyt+aBVE1YYKQf0OVQUaEZX
         v/dg==
X-Gm-Message-State: AOAM531uyDM14frH2+HXxd0ZjJ3SWHZsQfQh/hq4ikLuQvGSloj26zly
        3p1bu9e/fMomxCMjmMMJe4JyTmYnHi3ziRdN1id+8OnPX54PbLuQwJsHtjXLjlNg1FEclUqEGpJ
        EBTR/prsg8RJS
X-Received: by 2002:a50:f094:: with SMTP id v20mr2402340edl.77.1590663596053;
        Thu, 28 May 2020 03:59:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxuw/10cekC7U8aATGy+RMKlI6bOWDOv3kRPSG7W4XKxOfRR1rTW+uD9WoHNzoYlJLSNsD8Qg==
X-Received: by 2002:a50:f094:: with SMTP id v20mr2402321edl.77.1590663595667;
        Thu, 28 May 2020 03:59:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id lw27sm5064998ejb.80.2020.05.28.03.59.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 03:59:55 -0700 (PDT)
Subject: Re: [PATCH v2 02/10] KVM: x86: extend struct kvm_vcpu_pv_apf_data
 with token info
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
References: <20200525144125.143875-1-vkuznets@redhat.com>
 <20200525144125.143875-3-vkuznets@redhat.com>
 <20200526182745.GA114395@redhat.com> <875zcg4fi9.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fb07dcc4-141a-6fea-51f9-86527c454638@redhat.com>
Date:   Thu, 28 May 2020 12:59:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <875zcg4fi9.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/05/20 10:42, Vitaly Kuznetsov wrote:
> How does it work with the patchset: 'page not present' case remains the
> same. 'page ready' case now goes through interrupts so it may not get
> handled immediately. External interrupts will be handled by L0 in host
> mode (when L2 is not running). For the 'page ready' case L1 hypervisor
> doesn't need any special handling, kvm_async_pf_intr() irq handler will
> work correctly.
> 
> I've smoke tested this with VMX and nothing immediately blew up.

Indeed.

It would be an issue in the remote (read: nonexistent) case of a
hypervisor that handles async page faults and does not VMEXIT on
interrupts.  In this case it would not be able to enable page ready as
interrupt, and it would have to get rid of async page fault support.

Paolo

