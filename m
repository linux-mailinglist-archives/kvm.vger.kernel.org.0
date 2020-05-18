Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1104E1D759D
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 12:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgERKwZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 06:52:25 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50171 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726249AbgERKwZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 06:52:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589799143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6etE4P814prTdAG6YmglpAvqIzxrG1O+ArxaHFuKwGY=;
        b=GWcTjZuROUXguUQmoQWZPaadd/yRWBY/OSUxEQl7r/t9CnZgJrNsBC3+xPQD6PwYXSUBw4
        b8LARs6LEf+b1+ubYPXlK148JGiTs2qX6+1L6y6VA0PvoWnwnnQHqTdAj4k1ba7Op25Rsx
        2eKzk/pS9QWaBp/YJ4Rx5LacOjXUkY0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-3QNxJK-mMsSLQGFbR-RwJg-1; Mon, 18 May 2020 06:52:22 -0400
X-MC-Unique: 3QNxJK-mMsSLQGFbR-RwJg-1
Received: by mail-wr1-f70.google.com with SMTP id r7so5466195wrc.13
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 03:52:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6etE4P814prTdAG6YmglpAvqIzxrG1O+ArxaHFuKwGY=;
        b=Lwcu9u1XiYXULU0zE7qQqF/uKaKGwu5io+TEpMA+hxby8PpsbVsQmfxEp5+THyEYyT
         rPsZTmua4Z2mJVaQTwQY7pJxrr3YuGI6ti9DVjC5J7PB2zbBur5buNYB2RusIW2TVqXI
         X7vdDXujrOV1rgnh6lUzPzaBzVJDretb45pW8gTJJUokrbDM70CfPKqk/EntmSIi+upF
         3AmSIyS2NxTpBnw/PJGAp3RADMq3yWLFv8CbRxt7NAJgDAWtBF8H91/tBnc/3DAquPbL
         EpvPF62yGGb1kiTLiqRlfnWZFeFmBANngE/EKtGics9FXoZwdBaw/hxzTZ1FCo5eRWfk
         Ws/Q==
X-Gm-Message-State: AOAM532464NFza3aKUieVHsRW/Qcflyl5nELjnlDPcAJvS3JUopAyrzS
        Gi8RAcgEGXLE97JXOGITtTCnNAfL04S6HOnJuvcDQmO3UfxAsstgcr9DJsF+52SSMBd2wqbr7bT
        xvdYT8qv8Js7s
X-Received: by 2002:a1c:ed08:: with SMTP id l8mr13772257wmh.169.1589799141177;
        Mon, 18 May 2020 03:52:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytY+OY8SU0qlgwqpmffxW1RD+bJcmh79enNAQOBf29svzbfpZJVco9mYAFQmBpYmuSBeDn5A==
X-Received: by 2002:a1c:ed08:: with SMTP id l8mr13772237wmh.169.1589799140990;
        Mon, 18 May 2020 03:52:20 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.90.67])
        by smtp.gmail.com with ESMTPSA id q14sm16485527wrc.66.2020.05.18.03.52.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 03:52:20 -0700 (PDT)
Subject: Re: [PATCH 0/3] KVM: x86: kvm_init_msr_list() cleanup
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200218234012.7110-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f630dc53-61db-71fb-d868-cb8eb70f504d@redhat.com>
Date:   Mon, 18 May 2020 12:52:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200218234012.7110-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/02/20 00:40, Sean Christopherson wrote:
> Three cleanup patches in kvm_init_msr_list() and related code.
> 
> Note, these were previously posted as the first three patches of larger
> series[*] that mutated into an entirely different beast, which is how they
> have been reviewed by Vitaly despite being v1.
> 
> [*] https://patchwork.kernel.org/cover/11357065/
> 
> Sean Christopherson (3):
>   KVM: x86: Remove superfluous brackets from case statement
>   KVM: x86: Take an unsigned 32-bit int for has_emulated_msr()'s index
>   KVM: x86: Snapshot MSR index in a local variable when processing lists
> 
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/svm.c              |  2 +-
>  arch/x86/kvm/vmx/vmx.c          |  2 +-
>  arch/x86/kvm/x86.c              | 26 +++++++++++++++-----------
>  4 files changed, 18 insertions(+), 14 deletions(-)
> 

Queued (better late than never).

Paolo

