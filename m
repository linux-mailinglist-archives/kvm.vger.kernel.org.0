Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59F0471030
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 03:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345660AbhLKCFV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 21:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345651AbhLKCFR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 21:05:17 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617A9C061714
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 18:01:41 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id o20so35639570eds.10
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 18:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=WVnthdosmpjipB7yPiuiakE7SLVcGK7sNUXZDswD+4M=;
        b=kQFKmYe8vDRaDP+negb5PLELc9BJbZqSB20zP66OmJ4DISuLRKQeUOWN0WTAMMG87s
         9FR3vm5EDGMubGz7FXvlm/tkKTqXMe2x1jCuf9HhosfBfap/ddxexuHFif1OVuoFvwMP
         t0kAIavp4Nre414NXeWBdPHiV+0RMYOAntwWjHoaGvKrKvrSihSIZgEtMH8WK4XljH3e
         LxNO0jVvGFp28I0POJULSIBFgUOIcfuwyNxVq3KT/5wym9cgnDY8CSw2Z6rDS2htngKF
         M9tLH2JyZiLIKo/sohWQRd7iQibxRny42mFBYER64Vcbxi+IuNWKtzzX2ueQYqpi4hBp
         lx1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=WVnthdosmpjipB7yPiuiakE7SLVcGK7sNUXZDswD+4M=;
        b=7/YtdKywjl1jafKOtuJKyDUGbYCSpo8bozCMr90gNYoGt0+NLJhiVgbjiiSq7vaywH
         G+JyHKWLnKr9nm6bjjx21IK86vjdi/RZNrr5zia2/wdz6nH9AQsGn0BbmOMHmokuoBpc
         AaIVYLK+0rsfqf3p1c5l3DdaNDIZccdGaaFPjZMiLbXcYfY3T1a3nobhBQvCBOTuGdnu
         PWHaGh7Z45sgyzqbiQwZzqAw23Oe6tdwBsmJhn9FbwZ1bQbSdZc+ZTTg1ivG9pPwDZwd
         imwy2FM9zLOTbZzO8E7TSOeg58aToOtYn2aNe2GbjPzkN66V/0pwYNMx+wSb5pIQZEEa
         heKw==
X-Gm-Message-State: AOAM531CsanwPHDqzX5lCGD8sbqITGr1a6UWDcpQ6UJ2DwNQa1kDP4pi
        9oyOGeAdknXhgj3CzlgtCNM=
X-Google-Smtp-Source: ABdhPJwuCk+9i0aAWbHqJkxsihJ5L+D+Uxw2EkI1hrxobh1krzSeyM0qOpRFcC8PXwGC3RCyPRtEPg==
X-Received: by 2002:a17:906:fcd9:: with SMTP id qx25mr29027622ejb.326.1639188099977;
        Fri, 10 Dec 2021 18:01:39 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe? ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
        by smtp.googlemail.com with ESMTPSA id el20sm2235522ejc.40.2021.12.10.18.01.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 18:01:39 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <76d5e958-af0b-68fb-e6fa-ecdab8d79eeb@redhat.com>
Date:   Sat, 11 Dec 2021 03:01:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: VM_BUG_ON in vmx_prepare_switch_to_guest->__get_current_cr3_fast
 at kvm/queue
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        Lai Jiangshan <jiangshanlai@gmail.com>
References: <YbOVBDCcpuwtXD/7@google.com>
 <d22eb5e1-0e9d-707d-8482-c63857e87b0d@redhat.com>
In-Reply-To: <d22eb5e1-0e9d-707d-8482-c63857e87b0d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/11/21 01:11, Paolo Bonzini wrote:
> Yeah, vmx_prepare_switch_to_guest() doesn't update HOST_CR3 if no 
> preemption happens from one call of vcpu_enter_guest() to the next 
> (preemption would cause a call to kvm_arch_vcpu_put and from there to 
> vmx_prepare_switch_to_host, which clears vmx->guest_state_loaded).
> 
> During that time an MM switch is bumping the PCID; I would have expected 
> any such flush to require a preemption (in order to reach e.g. 
> switch_mm_irqs_off), but that must be wrong.  In the splat below in fact 
> you can see that the values are 0x60674f2005 (RAX) and 0x60674f2006 (RCX 
> and CR3).

As Jiangshan said, the PCID is bumped while L2 runs, and is stale when 
switching back to the vmcs01.  That indeed is compatible with a 
preemption.  There should definitely be a comment in 
vmx_prepare_switch_to_guest() that points to vmx_sync_vmcs_host_state().

Paolo
