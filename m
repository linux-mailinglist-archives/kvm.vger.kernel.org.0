Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1E98E0250
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 12:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388617AbfJVKvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 06:51:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45568 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388578AbfJVKvF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 06:51:05 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AE8F259449
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 10:51:04 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id a6so6108323wru.1
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 03:51:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vdKl6DDKIlJEFdLjcPMS36s2s1FJIcIbFPms1LIdy0I=;
        b=M7HRzZFChh8TkGAOHm44yFP1Jt3saqIu4N+LCYmt3+qiIhenIcdXdVK6nCB85tB466
         NgRUxkuyGMlatokwdkLs2+0eI90faQAukcXS5zB+zSFCXDERluIIQfVueZN1OIxpcNBu
         hYAto/eIHVBkb7MUqBGui9SM7IO9hWUxTK58MU/P9xzzkGSOtZPjVo/RSiZcSLH4hJdT
         ssfx6wMkhyVwn2MK0D59r+wNh1qdTEHBdxhyboS29D5KF7wbei7SbFYY0EfNd0e+A/NT
         VftfRdvwApVsyD+cTjnJ8XXlddXhsk8Gs2El9U+r3XG2QJSBOpcvVSM8XOMVtjsYhwmB
         QBEg==
X-Gm-Message-State: APjAAAVWYoLqLBfY+HcgHhd0fmFCvJJ3BOh7kDg0vViYqcw06TqIC6ms
        5OR3AckyD26h/8AvlhQcCFfqhR4K4uXgfsZshtoEcZ65ZeKESWzCzklNuQ56fCZdV6ed3Sw0lWo
        1XqCx0XhASxRB
X-Received: by 2002:adf:e446:: with SMTP id t6mr2862403wrm.7.1571741463188;
        Tue, 22 Oct 2019 03:51:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwLRJDFeoklnPCvIdpTLdkWG0AASVA51wAqpaeBkfAXh2wTKGAZAwI2bUd5RCu2qeXwOkem1Q==
X-Received: by 2002:adf:e446:: with SMTP id t6mr2862368wrm.7.1571741462908;
        Tue, 22 Oct 2019 03:51:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:45c:4f58:5841:71b2? ([2001:b07:6468:f312:45c:4f58:5841:71b2])
        by smtp.gmail.com with ESMTPSA id b62sm25553598wmc.13.2019.10.22.03.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2019 03:51:02 -0700 (PDT)
Subject: Re: [PATCH v2 05/16] KVM: VMX: Drop initialization of
 IA32_FEATURE_CONTROL MSR
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
References: <20191021234632.32363-1-sean.j.christopherson@intel.com>
 <20191022000820.1854-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <59cbc79a-fb06-f689-aa24-0ba923783345@redhat.com>
Date:   Tue, 22 Oct 2019 12:51:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191022000820.1854-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/10/19 02:08, Sean Christopherson wrote:
> Remove the code to initialize IA32_FEATURE_CONTROL MSR when KVM is
> loaded now that the MSR is initialized during boot on all CPUs that
> support VMX, i.e. can possibly load kvm_intel.
> 
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 48 +++++++++++++++++-------------------------
>  1 file changed, 19 insertions(+), 29 deletions(-)

I am still not sure about this...  Enabling VMX is adding a possible
attack vector for the kernel, we should not do it unless we plan to do a
VMXON.  Why is it so important to operate with locked
IA32_FEATURE_CONTROL (so that KVM can enable VMX and the kernel can
still enable SGX if desired).

Paolo
