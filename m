Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F2E41EFCB
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 16:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbhJAOnX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 10:43:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23392 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231840AbhJAOnW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 Oct 2021 10:43:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633099297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XkkeMCPL2Vp7JorOEy5gw2lNiI4B4lS4i/E97mBslbc=;
        b=CnYxq89RKdbG0tm6sJ5O933RmGmynw9lpNuRdFXPWHkn54vsjoy6QmoYh8Pat428PoZo+S
        tmdccellJqdcZcNoVj+BV+gBixL4OwSEfyJ/fP1yXXqKqG6A8nu1bqk7uycBhO0PeysmRP
        2v895stSBz55zbaYQ+OKUmQ7pX/fcwY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-jy6TLqy5OUSR4a2UFbUxUw-1; Fri, 01 Oct 2021 10:41:36 -0400
X-MC-Unique: jy6TLqy5OUSR4a2UFbUxUw-1
Received: by mail-ed1-f72.google.com with SMTP id m20-20020aa7c2d4000000b003d1add00b8aso10675299edp.0
        for <kvm@vger.kernel.org>; Fri, 01 Oct 2021 07:41:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=XkkeMCPL2Vp7JorOEy5gw2lNiI4B4lS4i/E97mBslbc=;
        b=GYCbETpJrYbJtBi0brTFki4rkteFDgAmCZD5ttRr4voekhIo3/TGXWeX+0ZebQWE3c
         3/qyxB1C4hk99QpDR3s2GRjNtccYpF72haT1GDxM/BnRlHQMB+iPne/VjwDLEqQMcQa9
         qI3Qj4uZtut9ScePKuMq0eEfoW5gdlInYEgMAPyxncMxzuZYoBZBSru0c3GMaM4ekRIZ
         2tnShqcqKJe1fygkzWRpr4j9a9YWlvvstQqz8dCVirS+zLk1gqFZhj+6nWTar5rG8TBv
         GMHoXf4DR49UEzzYYhYq4O2dyPL8BjogmO6i/FJTKPTLJwOstcbQjicBnOEqZY1pJ+b0
         cBPw==
X-Gm-Message-State: AOAM53068f+4I2OxAcWHA0y9GQ4cdgD/uR9BqwnpJMxOX4v5fZpCGpAX
        PbEKEuayfPj5OgV7qI0ZCHIEpd7E0zUIyL55VFCKdntFTWuf8FxEc28Ykgkc/U5acr2t1XJfMwp
        cPu0x6GkMISoM
X-Received: by 2002:a05:6402:1d9c:: with SMTP id dk28mr9728528edb.241.1633099295531;
        Fri, 01 Oct 2021 07:41:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIscIfxGLMs/yfLoygqBiGNTRk5EVkFolzj6ew78/IWPq8S7bQHiwT65Cmf2dESwTn0KKxSQ==
X-Received: by 2002:a05:6402:1d9c:: with SMTP id dk28mr9728502edb.241.1633099295343;
        Fri, 01 Oct 2021 07:41:35 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id jl12sm2938613ejc.120.2021.10.01.07.41.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 07:41:34 -0700 (PDT)
Message-ID: <746cfc82-ee7c-eba2-4443-7faf53baf083@redhat.com>
Date:   Fri, 1 Oct 2021 16:41:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v8 4/7] KVM: x86: Report host tsc and realtime values in
 KVM_GET_CLOCK
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-5-oupton@google.com>
 <d88dae38-6e03-9d93-95fc-8c064e6fbb98@redhat.com>
In-Reply-To: <d88dae38-6e03-9d93-95fc-8c064e6fbb98@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/10/21 16:39, Paolo Bonzini wrote:
> On 16/09/21 20:15, Oliver Upton wrote:
>> +    if (data.flags & ~KVM_CLOCK_REALTIME)
>>           return -EINVAL;
> 
> Let's accept KVM_CLOCK_HOST_TSC here even though it's not used; there 
> may be programs that expect to send back to KVM_SET_CLOCK whatever they 
> got from KVM_GET_CLOCK.

Nevermind, KVM_SET_CLOCK is already rejecting KVM_CLOCK_TSC_STABLE so no 
need to do that!

Paolo

