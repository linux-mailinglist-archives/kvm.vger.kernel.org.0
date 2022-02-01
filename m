Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000F74A5BEF
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 13:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237820AbiBAMLz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 07:11:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33738 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236377AbiBAMLz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Feb 2022 07:11:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643717514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lsdysZ548rZ3tzqzcEGKcgNZBJ//Jtgmjh673Jd5TCs=;
        b=SrYLiDZJqHeQXpbTptZjOGawuIEbLcV5GSbhtAafidj0lM+pDecsUZy4ZW5T5xhOYEq10m
        Pio7chq9FNDFxqiqwT5U6wVbUdPU7uCH77dMqNJJNuRy9JFY0HQvElSUkJ3vgVvE1wj523
        N56TgKiagpytXdteoKxiQKf8TqOlvag=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-65-uJ_AQdo-MVahBCjIcGORkg-1; Tue, 01 Feb 2022 07:11:53 -0500
X-MC-Unique: uJ_AQdo-MVahBCjIcGORkg-1
Received: by mail-ej1-f70.google.com with SMTP id m4-20020a170906160400b006be3f85906eso555332ejd.23
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 04:11:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lsdysZ548rZ3tzqzcEGKcgNZBJ//Jtgmjh673Jd5TCs=;
        b=OmGHxF23NWrCGyt7S42aE8H/EasoVpMMwB2Z8iGSQIM/zHlcPVfh10lhf406a5OVBp
         LcMvKviJ/wn000Ho5TQF8HT6ieYScPSUiDnErjRs3fXGmvWq3hQgijl9ezCACpfToGmW
         Rc8CHVsDwDv+uihRIUiOLN5ICfXtUfJ397YZnSZK/1gNmGDZ/Mj8GfLfYOgAlzdR1Lxv
         n7G49rBx6+2StZGufn85OiNt4JYM+GWsTPP6zp4CifYG8fw0N9Cb/Kv0s8J9+t2qe+vp
         PrtmYDUdoSAP90cuDWMQ5DUrgazS1kLg4fdIAdwdPTpl6JNdMZe7SbG9RnZZP3/yNZse
         zlJQ==
X-Gm-Message-State: AOAM533loCvS/PnDDXstJbQMQvlqk5eWSFSKRBfCIkltGaugHxgCcCdY
        kqJWGc/Pzm+gwVw8BRW6giUzw8p1H6zku6xa6OnGFsUtqn82ElptB2rmPjffISdKQosfp/QvWe1
        uaolbn5EOWyGK
X-Received: by 2002:a05:6402:344d:: with SMTP id l13mr3567077edc.448.1643717512402;
        Tue, 01 Feb 2022 04:11:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz0KghrMv3/uj5R2TJQ7Eav9ORWV+tDOc9zzVirCQrQPDIm1zadhl+F3wCRz4HFr1kek9V8fA==
X-Received: by 2002:a05:6402:344d:: with SMTP id l13mr3567059edc.448.1643717512215;
        Tue, 01 Feb 2022 04:11:52 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id q12sm1188934edv.99.2022.02.01.04.11.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 04:11:51 -0800 (PST)
Message-ID: <ae828eca-40bd-60f3-263f-5b3de637a9aa@redhat.com>
Date:   Tue, 1 Feb 2022 13:11:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH RESEND v2] KVM: LAPIC: Enable timer posted-interrupt when
 mwait/hlt is advertised
Content-Language: en-US
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Aili Yao <yaoaili@kingsoft.com>
References: <1643112538-36743-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1643112538-36743-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/25/22 13:08, Wanpeng Li wrote:
> As commit 0c5f81dad46 (KVM: LAPIC: Inject timer interrupt via posted interrupt)
> mentioned that the host admin should well tune the guest setup, so that vCPUs
> are placed on isolated pCPUs, and with several pCPUs surplus for*busy*  housekeeping.
> It is better to disable mwait/hlt/pause vmexits to keep the vCPUs in non-root
> mode. However, we may isolate pCPUs for other purpose like DPDK or we can make
> some guests isolated and others not, we may lose vmx preemption timer/timer fastpath
> due to not well tuned setup, and the checking in kvm_can_post_timer_interrupt()
> is not enough. Let's guarantee mwait/hlt is advertised before enabling posted-interrupt
> interrupt. vmx preemption timer/timer fastpath can continue to work if both of them
> are not advertised.

Is this the same thing that you meant?

--------
As commit 0c5f81dad46 ("KVM: LAPIC: Inject timer interrupt via posted interrupt")
mentioned that the host admin should well tune the guest setup, so that vCPUs
are placed on isolated pCPUs, and with several pCPUs surplus for *busy* housekeeping.
In this setup, it is preferrable to disable mwait/hlt/pause vmexits to
keep the vCPUs in non-root mode.

However, if only some guests isolated and others not, they would not have
any benefit from posted timer interrupts, and at the same time lose
VMX preemption timer fast paths because kvm_can_post_timer_interrupt()
returns true and therefore forces kvm_can_use_hv_timer() to false.

By guaranteeing that posted-interrupt timer is only used if MWAIT or HLT
are done without vmexit, KVM can make a better choice and use the
VMX preemption timer and the corresponding fast paths.
--------

Thanks,

Paolo

