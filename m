Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACBD1BF08E
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 08:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbgD3Gtq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 02:49:46 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25797 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726489AbgD3Gtq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 02:49:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588229385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6jDhUGC0q9fpb0E7nmomakw81mS0R94uGtBxC+k3irk=;
        b=gELFHrg3xdET64gqDt6YQUrU1f/TtBcFAv9WNqtMNNrChiJfZlgIN2BVNbiHAA/nBjTBrT
        lcLEuQFJO888rb/QPCl7UkXyxPH/VGpn0K7Q22sDh7jAHZaHAoFRqI4KU+paQMJuozTDL7
        4pHlimrTTJy93Vi2hk/fWxA0a8eWLPI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-3IieWjQiP9u-VhsEO-0j_g-1; Thu, 30 Apr 2020 02:49:43 -0400
X-MC-Unique: 3IieWjQiP9u-VhsEO-0j_g-1
Received: by mail-wr1-f69.google.com with SMTP id a3so3388424wro.1
        for <kvm@vger.kernel.org>; Wed, 29 Apr 2020 23:49:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6jDhUGC0q9fpb0E7nmomakw81mS0R94uGtBxC+k3irk=;
        b=qcj9zHnemNpGYZxJPBBgiyfZSg0q2teOP6Mw9Kq84NVtEJQYsNGpH0ikdC1UHipnwM
         K+y3imK5Y7en+NPUccR8R2YE2Jqk3yZCpCHt3Dyi3RxEcbxFmgiSI52lOEekxBBv8FIS
         I9QzcCszAKAiGOfYmB0YZxcbsjN0avXSPRvAZRk/6T5fpoeXHqk+zf54aK71MpI+hkPF
         7ppo2Bq3F3muFHi7yGXaZ1gaY2i7WoNhwaMReVES4CfdqO/kSQ8OKmSLifXnI60qF8RV
         Uy2ObJBNBkzp8T+ZAh+ZyUgAqNWzs6GoFz/HhGXusKDZiyX0EjogsKrJSC5XwS4KZCXd
         zo/g==
X-Gm-Message-State: AGi0PuYpbkkinQGcIdutJ/VLrKUYDC5XJercinXlEWB+2KzRaK584Y2z
        vvULXfET3C79PlUcpjt3dHnrVfKmFK5L3ftdcsi3/ELDEE8H0sadzdjkIvVvUKfCbKJome9amK0
        cN4TF6wMNq92H
X-Received: by 2002:adf:d0ce:: with SMTP id z14mr1006545wrh.179.1588229382512;
        Wed, 29 Apr 2020 23:49:42 -0700 (PDT)
X-Google-Smtp-Source: APiQypJsr6rw4wP2fqMQl3zalW7R42B7drXGchkN9CzcjY2NDZHyXF3Wa5dNOSiiq9a1MPMvoUroSQ==
X-Received: by 2002:adf:d0ce:: with SMTP id z14mr1006517wrh.179.1588229382284;
        Wed, 29 Apr 2020 23:49:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac19:d1fb:3f5f:d54f? ([2001:b07:6468:f312:ac19:d1fb:3f5f:d54f])
        by smtp.gmail.com with ESMTPSA id g74sm11257055wme.44.2020.04.29.23.49.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 23:49:41 -0700 (PDT)
Subject: Re: [PATCH RFC 4/6] KVM: x86: acknowledgment mechanism for async pf
 page ready notifications
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com>
 <20200429093634.1514902-5-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b1297936-cf69-227b-d758-c3f3ca09ae5d@redhat.com>
Date:   Thu, 30 Apr 2020 08:49:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200429093634.1514902-5-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/20 11:36, Vitaly Kuznetsov wrote:
> +	case MSR_KVM_ASYNC_PF_ACK:
> +		if (data & 0x1)
> +			kvm_check_async_pf_completion(vcpu);
> +		break;

Does this work if interrupts are turned off?  I think in that case
kvm_check_async_pf_completion will refuse to make progress.  You need to
make this bit stateful (e.g. 1 = async PF in progress, 0 = not in
progress), and check that for page ready notifications instead of
EFLAGS.IF.  This probably means that;

- it might be simpler to move it to the vector MSR

- it's definitely much simpler to remove the #PF-based mechanism for
injecting page ready notifications.

Thanks,

Paolo

