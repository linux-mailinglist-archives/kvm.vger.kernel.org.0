Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B020508D63
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 18:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380645AbiDTQgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 12:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380647AbiDTQf7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 12:35:59 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F5845506;
        Wed, 20 Apr 2022 09:33:12 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id y21so1577363wmi.2;
        Wed, 20 Apr 2022 09:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:content-language:to
         :cc:references:from:subject:in-reply-to:content-transfer-encoding;
        bh=kQRK2QB53OrPYi4GZ5EzJuqfwxImTi8JIj/Z9/FRF/Y=;
        b=m5HQcre+cUt8pWnB4ybOcARXBwRU6LHiKi9W1I+/lrOzHx9YjFv6UNYhxOUOJVwBUH
         Clhyq876TD9hylSP7nmN4yUeJwj0okavD11Wn7prN563Besem7owx/oD3wkG/8GOBKgL
         PvXgdcg7WlP0f5GJimXkM3V/PpZDUV2KJ+Qrgp4MgkLYamTpbTdf/srgRzly4qdPFxdc
         FI72rfAzbmdLhY4p8vVZUlZ0ovjzzzeF6R3qU0VozsDJIUkNUy2Er+YXuT9Uq1Bux0gB
         9rbLwCdVB2lBr90fur7UWh1g6RpAeqQrI//11vqVNv6OEuJ/jnKgQF6Xh63To5sg54ki
         osGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=kQRK2QB53OrPYi4GZ5EzJuqfwxImTi8JIj/Z9/FRF/Y=;
        b=Tc5W8gqd2X0yxAhTyicncKHGCw3cZmzzHk6VMSGI4pSWUqyNiaI6ccONnZnr5yhHR+
         SafeZZe0cLEcnIuw+kqBZkfu7QD7uECUBJFS21IyqT4+uGTrCojD69mMjqln0hc1iDLG
         JfeB2tSQAZPXd9Y+1nMkVEtyDBPNw5jhlL5CyqocsuPHNQcjPiFL5/iJXu4TuUZ60yeW
         Dy/ur+k3rqwGJq1vhVKlyR3JyyYlbYUeIadxDJi3roq4pTQnQ9awL1uMEpFRaaeKQtIh
         qU9MmG5tcFFvw+OEe+X7LtbYotZOWXlw31FX3nr9NBx3CSexVR2RBFhQiT39pk1Dscuc
         5vgw==
X-Gm-Message-State: AOAM532ZklJ0jv6ujINUFgQESjERYdgGxqtAxVnnRG3fhF8eS8WCtiR/
        MqoniRJ0Pavn6OQYjy8yboQ=
X-Google-Smtp-Source: ABdhPJxxM5XCJMkhrVDyHY33VjHo6b1F4DJYOp7yq0P6Nifq/wy571PAxg7RtP24M16B1cB9C8T4Ew==
X-Received: by 2002:a05:600c:1908:b0:391:7786:9ba0 with SMTP id j8-20020a05600c190800b0039177869ba0mr4634120wmq.145.1650472390863;
        Wed, 20 Apr 2022 09:33:10 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id t15-20020adfeb8f000000b002060d26c211sm266386wrn.114.2022.04.20.09.33.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 09:33:10 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <41d956ab-3d25-2c2f-8b1a-2c49e03b4df4@redhat.com>
Date:   Wed, 20 Apr 2022 18:33:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220402010903.727604-1-seanjc@google.com>
 <20220402010903.727604-2-seanjc@google.com>
 <112c2108-7548-f5bd-493d-19b944701f1b@maciej.szmigiero.name>
 <YkspIjFMwpMYWV05@google.com>
 <4505b43d-5c33-4199-1259-6d4e8ebac1ec@redhat.com>
 <98fca5c8-ca8e-be1f-857d-3d04041b66d7@maciej.szmigiero.name>
 <YmAxqrbMRx76Ye5a@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/8] KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02
In-Reply-To: <YmAxqrbMRx76Ye5a@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/20/22 18:15, Sean Christopherson wrote:
>>> Let's just require X86_FEATURE_NRIPS, either in general or just to
>>> enable nested virtualiazation
>> 👍
> Hmm, so requiring NRIPS for nested doesn't actually buy us anything.  KVM still
> has to deal with userspace hiding NRIPS from L1, so unless I'm overlooking something,
> the only change would be:
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index bdf8375a718b..7bed4e05aaea 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -686,7 +686,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>           */
>          if (svm->nrips_enabled)
>                  vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
> -       else if (boot_cpu_has(X86_FEATURE_NRIPS))
> +       else
>                  vmcb02->control.next_rip    = vmcb12_rip;
> 
>          if (is_evtinj_soft(vmcb02->control.event_inj)) {
> 
> And sadly, because SVM doesn't provide the instruction length if an exit occurs
> while vectoring a software interrupt/exception, making NRIPS mandatory doesn't buy
> us much either.
> 
> I believe the below diff is the total savings (plus the above nested thing) against
> this series if NRIPS is mandatory (ignoring the setup code, which is a wash).  It
> does eliminate the rewind in svm_complete_soft_interrupt() and the funky logic in
> svm_update_soft_interrupt_rip(), but that's it AFAICT.  The most obnoxious code of
> having to unwind EMULTYPE_SKIP when retrieving the next RIP for software int/except
> injection doesn't go away:-(
> 
> I'm not totally opposed to requiring NRIPS, but I'm not in favor of it either.

Yeah, you're right.  However:

* the rewind might already be worth it;

* if we require NRIPS for nested, we can also assume that the SVM save 
state data has a valid next_rip; even if !svm->nrips_enabled.  There's 
the pesky issue of restoring from an old system that did not have NRIPS, 
but let's assume for now that NRIPS was set on the source as well.

Paolo
