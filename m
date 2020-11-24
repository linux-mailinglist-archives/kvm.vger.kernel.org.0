Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B762C23E9
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 12:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732846AbgKXLJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 06:09:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45031 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731742AbgKXLJw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Nov 2020 06:09:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606216190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dQyYdZ+ap0EfxwOL/l3zGdh80ZLJUtxQwG7cGkgQ45w=;
        b=DPPleBDEnI3hnS6+2tz398h6NreoHcxUIMz0sPx/BTIj0YNLDo5pPlrcOm7l+oa9QyXAzd
        G/F60JNGzbKS6FoqpFEOPQ1H2b/77smGdynFqTS2Cx7jvnEsfrsWQShvbGVV8mfLJyD+zS
        BmDUcF9bFpEmhPi1r9igw9Lr3zAuxSQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-NjSIxNZPMiiXCluLR0_JjQ-1; Tue, 24 Nov 2020 06:09:48 -0500
X-MC-Unique: NjSIxNZPMiiXCluLR0_JjQ-1
Received: by mail-ej1-f71.google.com with SMTP id gr9so6741190ejb.19
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 03:09:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dQyYdZ+ap0EfxwOL/l3zGdh80ZLJUtxQwG7cGkgQ45w=;
        b=YSddRuNYQnmqtsbxrANOWszygeFMLJIlsQ6gDxw6vwhVxZVp5lqMvb3Xk26SVu+2uR
         qmJci4H88iayRrokBJgWvUCQ/bbMaOAvAaBOZt/2U/JideBf2gjyR+OVuh/IDtsx5Ttu
         ORfXo7hXqJwJY7s1E7WwDpecPILQ7g7wsE2/R7vLZbB5W8fZ6PFFVdAUsHi+Ziugxqi6
         qHOUWplg8RU46M+BvajXEXQnp7pgrldnNaGh7DqR6y/bN3UdrGY7fVxFL4dvBzcQfl9P
         3qqd9+AHYgO/5r6izfI6ssKdyn2mcU6WSwwi+wMEChUe43+D9mk7rCiO1flN1kQQFX7m
         g7MA==
X-Gm-Message-State: AOAM531SKx2ndumLfEYZVHse8Q24RZNb4kPan3L9PPIDeqwo2gxTsVw2
        PjCo00qLSsTlub6v4PQIhySPzJR4eSLf1/lTPa4x0nIl+Q5PSrAk8iaRuv9CVFFLFLwK6TvIFYS
        /pHN7yGfplocM
X-Received: by 2002:aa7:c45a:: with SMTP id n26mr3528542edr.112.1606216187763;
        Tue, 24 Nov 2020 03:09:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyIo0tl9TRJPf6nQHiTsCk6PAR/E7dR9B1JBavnpOvAa9M+KtinE6zPlcv24h5riAmV0qQ1kg==
X-Received: by 2002:aa7:c45a:: with SMTP id n26mr3528521edr.112.1606216187579;
        Tue, 24 Nov 2020 03:09:47 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z14sm6626143ejx.58.2020.11.24.03.09.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 03:09:46 -0800 (PST)
To:     Oliver Upton <oupton@google.com>
Cc:     idan.brown@oracle.com, Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>, liam.merwick@oracle.com,
        wanpeng.li@hotmail.com, Sean Christopherson <seanjc@google.com>
References: <95b9b017-ccde-97a0-f407-fd5f35f1157d@redhat.com>
 <20201123192223.3177490-1-oupton@google.com>
 <4788d64f-1831-9eb9-2c78-c5d9934fb47b@redhat.com>
 <CAOQ_QsiUAVob+3hnAURJF-1+GdRF9HMtuxpKWCB-3m-abRGqxw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 11/11] KVM: nVMX: Wake L2 from HLT when nested
 posted-interrupt pending
Message-ID: <7ffaa63e-6e75-cf5f-e0c1-d168016c4eca@redhat.com>
Date:   Tue, 24 Nov 2020 12:09:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAOQ_QsiUAVob+3hnAURJF-1+GdRF9HMtuxpKWCB-3m-abRGqxw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/11/20 01:10, Oliver Upton wrote:
>> but you also have to do the same*in the PINV handler*
>> sysvec_kvm_posted_intr_nested_ipi too, to handle the case where the
>> L2->L0 vmexit races against sending the IPI.
> Indeed, there is a race but are we assured that the target vCPU thread
> is scheduled on the target CPU when that IPI arrives?

This would only happen if the source vCPU saw vcpu->mode == 
IN_GUEST_MODE for the target vCPU.  Thus there are three cases:

1) the vCPU is in non-root mode.  This is easy. :)

2) the vCPU hasn't entered the VM yet.  Then posted interrupt IPIs are 
delayed after guest entry and ensured to result in virtual interrupt 
delivery, just like case 1.

3) the vCPU has left the VM but it hasn't reached

         vcpu->mode = OUTSIDE_GUEST_MODE;
         smp_wmb();

yet.  Then the interrupt will be right after that moment, at.

         kvm_before_interrupt(vcpu);
         local_irq_enable();
         ++vcpu->stat.exits;
         local_irq_disable();
         kvm_after_interrupt(vcpu);

Anything else will cause kvm_vcpu_trigger_posted_interrupt(vcpu, true) 
to return false instead of sending an IPI.

Paolo

