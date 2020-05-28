Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1AE1E5DD0
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 13:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388045AbgE1LFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 07:05:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51893 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388067AbgE1LFF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 07:05:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590663903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vz/KNQwtqPzPwwJ5/E8xlfolO32T1hV075nXyScUoSE=;
        b=VeH6enC26B3Ko3r6u0TN+QceYnguswzLVPDMHgH6jcpetRfqfZrw3ewEchamBMnH6Zcwb0
        9TdsRmLH2KJvyIjuDtQT6rKBqPkkiK7ZLedomwE1Phf0ZwYv0l2q2E0Wu91Q1P2CaHWbJX
        uzGpYh6YzCkibVgUUDdLVlDzsePyT6M=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-8BGpUDJVN-i0r6joz8Sy4w-1; Thu, 28 May 2020 07:05:00 -0400
X-MC-Unique: 8BGpUDJVN-i0r6joz8Sy4w-1
Received: by mail-ej1-f69.google.com with SMTP id lk22so10092529ejb.15
        for <kvm@vger.kernel.org>; Thu, 28 May 2020 04:05:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vz/KNQwtqPzPwwJ5/E8xlfolO32T1hV075nXyScUoSE=;
        b=QoU876ncQMJf99Q2alKJG1j4ClwmCBQ0q/ufgRUGFcfvA9OC442ioh/7DLB/WfZz3x
         DGe3AEd5adttI+5WgeCK/F+IbQjHCA9lceX5J5PO58L7452RSuToshgMbsCib/s6r+NQ
         k1jnvvYPwoIY0xVk6Nt9U/mVvCPa6ltS+jTV4BmsqTud1pgol/mUHxTZTTbuHiOpIsFh
         FJLPCTtUSYB+4eymsJljCeGav+G+HpMukTyALGEWd0+jT9CX+GgpBeOAApAI8wPivCMx
         zT2rqSz3+EdPszztUd1DSHKyu1wcX46mh92cGWipPsOXfNEOu1XkxzlSSPmnruE2vcti
         pKRg==
X-Gm-Message-State: AOAM532P5gfAWwL9C9cYHrD44TD50G+oJ4dBjTiSh3xBKOCW5WTuQeOD
        Bmvhax66jX53AQFpvobZPmXbdOE5MN0u5dlU8XHQEgmtBBqvbz6lrxdpdaqZFdp6dMk540BzUWd
        m0bOsfJS0MQpb
X-Received: by 2002:a50:b2e1:: with SMTP id p88mr2514350edd.198.1590663899271;
        Thu, 28 May 2020 04:04:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUxazYv/MMjFOoYXGoUSI8TzWHBa76vBlUwJk+N2FMgBjee032aatw377n1MJf50x2veTsRA==
X-Received: by 2002:a50:b2e1:: with SMTP id p88mr2514320edd.198.1590663899011;
        Thu, 28 May 2020 04:04:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id g20sm5181115ejx.85.2020.05.28.04.04.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 04:04:57 -0700 (PDT)
Subject: Re: [PATCH v2 00/10] KVM: x86: Interrupt-based mechanism for async_pf
 'page present' notifications
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Vivek Goyal <vgoyal@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
References: <20200525144125.143875-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3be1df67-2e39-c7b7-b666-66cd4fe61406@redhat.com>
Date:   Thu, 28 May 2020 13:04:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200525144125.143875-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/05/20 16:41, Vitaly Kuznetsov wrote:
> Concerns were expressed around (ab)using #PF for KVM's async_pf mechanism,
> it seems that re-using #PF exception for a PV mechanism wasn't a great
> idea after all. The Grand Plan is to switch to using e.g. #VE for 'page
> not present' events and normal APIC interrupts for 'page ready' events.
> This series does the later.
> 
> Changes since v1:
> - struct kvm_vcpu_pv_apf_data's fields renamed to 'flags' and 'token',
>   comments added [Vivek Goyal]
> - 'type1/2' names for APF events dropped from everywhere [Vivek Goyal]
> - kvm_arch_can_inject_async_page_present() renamed to 
>   kvm_arch_can_dequeue_async_page_present [Vivek Goyal]
> - 'KVM: x86: deprecate KVM_ASYNC_PF_SEND_ALWAYS' patch added.
> 
> v1: https://lore.kernel.org/kvm/20200511164752.2158645-1-vkuznets@redhat.com/
> QEMU patches for testing: https://github.com/vittyvk/qemu.git (async_pf2_v2 branch)

I'll do another round of review and queue patches 1-7; 8-9 will be
queued later and separately due to the conflicts with the interrupt
entry rework, but it's my job and you don't need to do anything else.

Thanks,

Paolo

