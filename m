Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0277F17A8F3
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 16:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgCEPgF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 10:36:05 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44535 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725990AbgCEPgF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Mar 2020 10:36:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583422564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QDqdPfPRCfBfra2y+XwHanTcUwRD10NZ8XiVS29LNZI=;
        b=TogOhy88bINfj8HyFZjhEL327VC1yP8sqAMs1Fsh1KakwXVkbHdOWvIBzasOpNheY7GnTT
        8lEadRlEBliSbK7NlgbEc5hT71MHe5oqs+g0hnMwfwGZg4VDYYOIcn629hw3qMnnFrrWGG
        4CpYmgzC3NGT15RY+KJHNrDDDd6qaZA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-6XJt1A_jPPqf0QrEnHTIVw-1; Thu, 05 Mar 2020 10:36:02 -0500
X-MC-Unique: 6XJt1A_jPPqf0QrEnHTIVw-1
Received: by mail-wm1-f72.google.com with SMTP id t2so1730952wmj.2
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 07:36:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QDqdPfPRCfBfra2y+XwHanTcUwRD10NZ8XiVS29LNZI=;
        b=h8LBgiZg+xMdUfaSetHoQjduIFnY5zyAeSSb/YWfnx1F/t7JBpfAXSn7J7xRDKV4hk
         D45XnFF4k5r0yg2Nyl8OvEG+LT8uYlcUZgNM+pRdOWBWVUHu1SJSVWVyM2RkjWwGGr5f
         mNFs8wG+WK+vr1N4AJqWJixa38Gw1fFhZTkZEK03f9BBe1wXkTkHXBoz2KhyX4z1kvEs
         Ui1w2p7PyE6+bPbZAKaxGvT7bC+scdJgXZJBW7zsZXicofOLj7D4noSLt1e8Prlhy4Nt
         2Na+Ho0XhFdRdLJd8EMH8LVm26AhtlTt7fAiR6o8ZDt63dVgky6YF4zcfmJENHRiOMrT
         lNYg==
X-Gm-Message-State: ANhLgQ2DM1Wpyt1kAmY7cHUEFF/K3oE7O0x2K/4GVlyGfUoiCN9OU1nB
        /yw/Np8GJQTvDw+rJueMk1HvDhaHfIAgW1iffDF1U5Sm5K9k9A7msBBeN0m2sl0v0Fr7XSVy/Hz
        b8sLqTni0TpoT
X-Received: by 2002:a5d:630a:: with SMTP id i10mr10530191wru.273.1583422561500;
        Thu, 05 Mar 2020 07:36:01 -0800 (PST)
X-Google-Smtp-Source: ADFU+vt+ijOsDEICsXiS9lUdy1zIsxfPXi4SqcI64HXJP+9IoYrSTpWafkXBLCoJkPwermHrm8OcQg==
X-Received: by 2002:a5d:630a:: with SMTP id i10mr10530176wru.273.1583422561273;
        Thu, 05 Mar 2020 07:36:01 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:9def:34a0:b68d:9993? ([2001:b07:6468:f312:9def:34a0:b68d:9993])
        by smtp.gmail.com with ESMTPSA id t124sm10410764wmg.13.2020.03.05.07.35.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 07:35:59 -0800 (PST)
Subject: Re: [PATCH 0/2] KVM: x86: VMX: cleanup VMXON region allocation
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200305100123.1013667-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7a4d3988-3ce8-673c-5128-2ef41f8f327d@redhat.com>
Date:   Thu, 5 Mar 2020 16:35:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200305100123.1013667-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/03/20 11:01, Vitaly Kuznetsov wrote:
> Minor cleanup with no functional change (intended):
> - Rename 'kvm_area' to 'vmxon_region'
> - Simplify setting revision_id for VMXON region when eVMCS is in use
> 
> Vitaly Kuznetsov (2):
>   KVM: x86: VMX: rename 'kvm_area' to 'vmxon_region'
>   KVM: x86: VMX: untangle VMXON revision_id setting when using eVMCS
> 
>  arch/x86/kvm/vmx/vmx.c | 41 ++++++++++++++++++-----------------------
>  arch/x86/kvm/vmx/vmx.h | 12 +++++++++---
>  2 files changed, 27 insertions(+), 26 deletions(-)
> 

Queued, thanks.

Paolo

