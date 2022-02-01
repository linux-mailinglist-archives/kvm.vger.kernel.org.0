Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3014A6236
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 18:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241230AbiBARTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 12:19:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57717 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239673AbiBARTe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Feb 2022 12:19:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643735974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KcsFPU0hUyaRVw35zLc4ecfKycgP6KY1g6YUHK3IxEI=;
        b=N3J7I6MrHsb1Ab8AUbJctQGXB8gxqEcdWByx4D9RvqGsoJadMvxEZXhpRjz5EpIeBARfsH
        Nplg4Sk8xVoaWPsCEXhUQB3+ZqTs5UN2utfd6NDkW/OJx6s5bdzJeFxKumKeIQ4EuV4ZFA
        VKr3whfpxpx/thWQ65nHwfGydtI6EVk=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-hNabkTuPMgqvwH6u2tZQnA-1; Tue, 01 Feb 2022 12:19:32 -0500
X-MC-Unique: hNabkTuPMgqvwH6u2tZQnA-1
Received: by mail-ej1-f69.google.com with SMTP id fx12-20020a170906b74c00b006bbeab42f06so3235822ejb.3
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 09:19:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KcsFPU0hUyaRVw35zLc4ecfKycgP6KY1g6YUHK3IxEI=;
        b=topqZzc8w3B9JIOBn/PX9nfjWtCSSq2pFBuCOHGyljiJzH4Uq4jA26WFjcrP8cgp0m
         e5Cd6XBygwclYeUlh6e4s6oiPOFcdO8Gm53g88pzljC9PYlQQbey8xceaioMJ5SytC7K
         J+heHT/HhD8Yy6yHEOtgw31UM61v7JCxgtPkgRPVf4xefS8tFlODXKMXSwTZMtOp9kNZ
         j0mnAwr+ZsFLt1sV8Rwo4Nmxs3xp7/3Ny4oRp6Mi6wfruZSnoLJtMsTr47dKif1B0VVO
         vJqhm8fEE87xHFtRnpUTOePOZofkz/jfmttZRwS3jibdaXKLiBAgXBofrOowAHHwqpxs
         Z30A==
X-Gm-Message-State: AOAM5311L2tGK3FuxUkZVFAodjeVT3cRNirx6eCkrJJIT+XX/49jdbSF
        ZSzxq95j3NRKiCWyN49yq3IOpC1843OlLGWfsJKeYUkO4Pkku4sgbr4Gse2hWjBrgEu2iOZlu6F
        ARffMvhBNaMAc
X-Received: by 2002:a05:6402:1705:: with SMTP id y5mr26171133edu.200.1643735971719;
        Tue, 01 Feb 2022 09:19:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJziuvxK+tKS0kkMRWjqDG2bHnRyq174U3nOlorRasUEDjgAg9WJPr5K9WPoGdm3MeRzYXOF6g==
X-Received: by 2002:a05:6402:1705:: with SMTP id y5mr26171112edu.200.1643735971491;
        Tue, 01 Feb 2022 09:19:31 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id i6sm14964394eja.132.2022.02.01.09.19.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 09:19:30 -0800 (PST)
Message-ID: <75b07c8e-b951-fdde-5429-27c9ef198dcc@redhat.com>
Date:   Tue, 1 Feb 2022 18:19:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH RESEND v2] KVM: LAPIC: Enable timer posted-interrupt when
 mwait/hlt is advertised
Content-Language: en-US
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Aili Yao <yaoaili@kingsoft.com>
References: <1643112538-36743-1-git-send-email-wanpengli@tencent.com>
 <ae828eca-40bd-60f3-263f-5b3de637a9aa@redhat.com>
 <CANRm+CwkYJAsv=VngY6m1uQtCLa+WqOJwSJzx95dO7LRAkbsbg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CANRm+CwkYJAsv=VngY6m1uQtCLa+WqOJwSJzx95dO7LRAkbsbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/1/22 14:57, Wanpeng Li wrote:
> On Tue, 1 Feb 2022 at 20:11, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 1/25/22 13:08, Wanpeng Li wrote:
>>> As commit 0c5f81dad46 (KVM: LAPIC: Inject timer interrupt via posted interrupt)
>>> mentioned that the host admin should well tune the guest setup, so that vCPUs
>>> are placed on isolated pCPUs, and with several pCPUs surplus for*busy*  housekeeping.
>>> It is better to disable mwait/hlt/pause vmexits to keep the vCPUs in non-root
>>> mode. However, we may isolate pCPUs for other purpose like DPDK or we can make
>>> some guests isolated and others not, we may lose vmx preemption timer/timer fastpath
>>> due to not well tuned setup, and the checking in kvm_can_post_timer_interrupt()
>>> is not enough. Let's guarantee mwait/hlt is advertised before enabling posted-interrupt
>>> interrupt. vmx preemption timer/timer fastpath can continue to work if both of them
>>> are not advertised.
>>
>> Is this the same thing that you meant?
>>
>> --------
>> As commit 0c5f81dad46 ("KVM: LAPIC: Inject timer interrupt via posted interrupt")
>> mentioned that the host admin should well tune the guest setup, so that vCPUs
>> are placed on isolated pCPUs, and with several pCPUs surplus for *busy* housekeeping.
>> In this setup, it is preferrable to disable mwait/hlt/pause vmexits to
>> keep the vCPUs in non-root mode.
>>
>> However, if only some guests isolated and others not, they would not have
>> any benefit from posted timer interrupts, and at the same time lose
>> VMX preemption timer fast paths because kvm_can_post_timer_interrupt()
>> returns true and therefore forces kvm_can_use_hv_timer() to false.
>>
>> By guaranteeing that posted-interrupt timer is only used if MWAIT or HLT
>> are done without vmexit, KVM can make a better choice and use the
>> VMX preemption timer and the corresponding fast paths.
>> --------
> 
> Looks better, thanks Paolo! :)

Queued then, thanks!

Paolo

