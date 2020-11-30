Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6862C8813
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 16:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgK3Pd2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 10:33:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45209 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726063AbgK3Pd1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 10:33:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606750321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KsipwzBDzb60ARfCi+QI1m4LWf3wJygQ0AAsNDCG40s=;
        b=BD1jZf+mQrP1qWOxTADZKpLmWT3winzbzpOSSKIzjmIyD7JVuLKvcTwbw7qvot2rc2YD9G
        0LbTasmcmZ0ibFSASpRTE1lU4Yin9RUFYol0o6OSCbMMLIVWESBmZWULwWNUl8XPIH/FzQ
        MGtDr0xDQHVIDZlN50V1WLEw4LNjMcg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-pPK1LGbBMMe0bncGU5qe7A-1; Mon, 30 Nov 2020 10:31:57 -0500
X-MC-Unique: pPK1LGbBMMe0bncGU5qe7A-1
Received: by mail-ed1-f71.google.com with SMTP id c24so6941107edx.2
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 07:31:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KsipwzBDzb60ARfCi+QI1m4LWf3wJygQ0AAsNDCG40s=;
        b=ftyFd74rnsBa0gA2jq2O8jY9WojHpXLQPedVBY4KKmm36mgpc9XCG/F2dVWDagqLsb
         VY5fPSxlRuIwDTE4bfxiRbNH+pjhP22dA3VUJxzU8bx0TKQHKrWx1p1uhSiVgGbET2KK
         Vs+sm21LFxMUYc4OO0tG1aM8MdVb2xIKnCzectiI5O9xiWY7knyAgNNzulwLFbR74idE
         uZdbRrK3oHXKl24iMreaFo33btAALH5+V90fycKsRMyt/tgKrIS0MF5JTLamwJo/lOpY
         /YWyi0eNAF+6s4Q12b7Ux5u3h284+4843vBO8i7cRoutin/PtAacVGSeUwkbyw3PPGqt
         gXLg==
X-Gm-Message-State: AOAM532ts7HGZI9D6MrC8PDAkib80Xi2KF0/YnIMH2K4Z+9PCTrQgMpZ
        bni8YKrcafQou4MWgNzt/nPAUO7hjI0CrcDAYLXdpv3FAge47H5a+fA/KiFKToDb0lWX+eDu5Zf
        Tkqv4MDTMOkr7
X-Received: by 2002:a17:906:4d8d:: with SMTP id s13mr13795544eju.305.1606750315808;
        Mon, 30 Nov 2020 07:31:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzJAmnB5boOvr5IKy7hOk2umHPy16BXprPN19ur+qcGYoWH+aEvjXuHby4AMDAYp+vPRqAQxw==
X-Received: by 2002:a17:906:4d8d:: with SMTP id s13mr13795389eju.305.1606750313897;
        Mon, 30 Nov 2020 07:31:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s5sm6581838eju.98.2020.11.30.07.31.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 07:31:53 -0800 (PST)
Subject: Re: [RFC PATCH 00/35] SEV-ES hypervisor support
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <20200914225951.GM7192@sjchrist-ice>
 <bee6fdda-d548-8af5-f029-25c22165bf84@amd.com>
 <20200916001925.GL8420@sjchrist-ice>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <60cbddaf-50f3-72ca-f673-ff0b421db3ad@redhat.com>
Date:   Mon, 30 Nov 2020 16:31:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20200916001925.GL8420@sjchrist-ice>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/09/20 02:19, Sean Christopherson wrote:
> 
> TDX also selectively blocks/skips portions of other ioctl()s so that the
> TDX code itself can yell loudly if e.g. .get_cpl() is invoked.  The event
> injection restrictions are due to direct injection not being allowed (except
> for NMIs); all IRQs have to be routed through APICv (posted interrupts) and
> exception injection is completely disallowed.
> 
>    kvm_vcpu_ioctl_x86_get_vcpu_events:
> 	if (!vcpu->kvm->arch.guest_state_protected)
>          	events->interrupt.shadow = kvm_x86_ops.get_interrupt_shadow(vcpu);

Perhaps an alternative implementation can enter the vCPU with immediate 
exit until no events are pending, and then return all zeroes?

Paolo

