Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4D141F24D
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 18:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355018AbhJAQoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 12:44:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38922 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232126AbhJAQoR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 Oct 2021 12:44:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633106552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bKf6HNVdrrxE0cl0he0ADvO2+hNrL9mNvfSRy2hS5xg=;
        b=XNQcUOUQwkd9kYug96eWywL3cQbEcellH1Se9/jbSjcUKbQQ0O7jt954GKsPVhj5jQd2z/
        dt8M+GmimphyXmuriYclUh4sL9sY3lmihDyUJEg9Lm+t5UMsGpRrpRtJ8IKTcKYilVR7a5
        eAG/FoPc/OQ6QfgvzI63JgG9HkZ0wkM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-tks3jzoZNn-W7VMV4gflag-1; Fri, 01 Oct 2021 12:42:28 -0400
X-MC-Unique: tks3jzoZNn-W7VMV4gflag-1
Received: by mail-ed1-f71.google.com with SMTP id m20-20020aa7c2d4000000b003d1add00b8aso11029535edp.0
        for <kvm@vger.kernel.org>; Fri, 01 Oct 2021 09:42:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bKf6HNVdrrxE0cl0he0ADvO2+hNrL9mNvfSRy2hS5xg=;
        b=qdT2zF1KtRkfztQgwgh2SX+Tt9P4WK8uah66ZgHKgVq+k3UERwW28wBjLYnhCwfYbD
         isuNm4PP3KO49s0yxvJK0m/RrbsHcF25iC0z6ACREilKxdA5YdvwsDlWYgV3rEYxM0Tw
         7R2SpGSgHahTn3jk4IVlsbg3lFRVQYy14GLFpORddlm7BUsnTfTsjtou3etulmC352cR
         z+75x1Lepjw2853tr6pZCDNUiUak2oj0wNLEXAW+iDYpXpex0jA/ByrXLNyO/BAbmgRm
         YS3rfc7mDNRegUYEahgdxJ3xSVAs2BXPhDFoGoDku324mxrv96TsOZQiuaXoeKP4o7Rp
         XyKQ==
X-Gm-Message-State: AOAM530pDX9OilL6+Lu9FotAdWX0w7Wvz09DfuLZL7iuqy7ATP5Sf+DO
        UxNsbbcIbKt7lepqx00InNmsUp+lsf0DKc8aiI+IpM0q0cvkeTBJFrKmQ7E7T6Ske4zH0Khw2Re
        xsAtuJmvRf2gv
X-Received: by 2002:a17:906:369a:: with SMTP id a26mr7157431ejc.539.1633106547739;
        Fri, 01 Oct 2021 09:42:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxG7u5UEQd6wXYgj1iX7w961eI5iTHKv9Fm/E4iQVqpTwU2cNSgXa2csZS0bC0Jul9BytmVuQ==
X-Received: by 2002:a17:906:369a:: with SMTP id a26mr7157408ejc.539.1633106547580;
        Fri, 01 Oct 2021 09:42:27 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id n22sm3171833eju.50.2021.10.01.09.42.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 09:42:26 -0700 (PDT)
Message-ID: <eaf9b9ed-47b7-20a9-7d8b-14ab85fc5bcc@redhat.com>
Date:   Fri, 1 Oct 2021 18:42:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v8 4/7] KVM: x86: Report host tsc and realtime values in
 KVM_GET_CLOCK
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-5-oupton@google.com>
 <d88dae38-6e03-9d93-95fc-8c064e6fbb98@redhat.com>
 <746cfc82-ee7c-eba2-4443-7faf53baf083@redhat.com>
 <CAOQ_QsgmpsjKD7SVzX4ftOUkDtMF+egorOyNwG8wpYqw2h44pw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAOQ_QsgmpsjKD7SVzX4ftOUkDtMF+egorOyNwG8wpYqw2h44pw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/10/21 17:39, Oliver Upton wrote:
>> Nevermind, KVM_SET_CLOCK is already rejecting KVM_CLOCK_TSC_STABLE so no
>> need to do that!
>
> Yeah, I don't know the story on the interface but it is really odd
> that userspace needs to blow away flags to successfully write the
> clock structure.

Yeah, let's fix it now and accept all three flags  I would like that, 
even though it cannot be fixed in existing kernels.

Paolo

