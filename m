Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5CA548EF27
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 18:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243800AbiANRRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 12:17:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:21843 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229761AbiANRRj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 12:17:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642180658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dRPOOzyCcvupVETwSyqy/92tlLZWLI8PTGCHYZ+8sSE=;
        b=LgMPV57pIBOm/u92lWrmk3HGWNB8/b7JfGtKzMvJlUwlRFErrQLe92tmTIC5VhaDZSL1LA
        GyVTAkuHbjm3o5+wxdyMpafIkE9fHxU7quHiO7QRNKXJFr6b5d/z1Dj9gLmcvfFp5gUBe0
        TuwVxzMyYc9Z1zPbLkfoE8Efae5kWhE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-eQcoEJq1NeOS1PFX-NpRUw-1; Fri, 14 Jan 2022 12:17:38 -0500
X-MC-Unique: eQcoEJq1NeOS1PFX-NpRUw-1
Received: by mail-wm1-f71.google.com with SMTP id l20-20020a05600c1d1400b003458e02cea0so8390871wms.7
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 09:17:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dRPOOzyCcvupVETwSyqy/92tlLZWLI8PTGCHYZ+8sSE=;
        b=HekyoXrnwN3R/JToPxc255cdfIUFHazkOtV+9S4jH74I3K8AAVsbPpZZYkAgdxOONj
         vyjQq35AhZKl1aVBuPLv8dm8H5c507YIO9MeU6EF+8MxNQseZDbJVvvGYsQyW6aF/UR4
         n+m1+ruXltTo5QkKqUlA/B6HZW+q8OtUefgAv6Qze725rnoKrUMuDRCSwiU8E6yBoOTV
         dGoDP5jwHXEiQ/vpbX+7V90xqdpZa4iPG5X9DGQbzMaUrsjHXGHxTY81TkXL4GLt8+vE
         GlDT4QJK3NOygdKAGtrC0rPRtNmjuyvFlfcjCDUyibhh5cckISs/XS+jAp2i6FB/6ZnF
         Zijg==
X-Gm-Message-State: AOAM530Bf3wTZkCeCilZRTXWthwkHw2DizD9/UDIUvISPUUD2DKMyGzd
        1I3ISNKNZOR2kiewvKKUok8B6hbmFNni2Bz0P83s0fhPjVLk3HihWyoSFq5pe3gtOckhcKyVm2t
        Z6U1OnWz8H6TS
X-Received: by 2002:a05:6000:18cd:: with SMTP id w13mr9360388wrq.199.1642180654776;
        Fri, 14 Jan 2022 09:17:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwloAAnBK2k6mYX9AQvpZBAqle9NYH87R8xZbZBsF3FZ6xDHjK1gKeMXIUbt7BuWSzGHKErIw==
X-Received: by 2002:a05:6000:18cd:: with SMTP id w13mr9360372wrq.199.1642180654568;
        Fri, 14 Jan 2022 09:17:34 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id bd21sm10783121wmb.8.2022.01.14.09.17.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 09:17:33 -0800 (PST)
Message-ID: <078665cd-978f-8f5b-7fcc-d895f9ba5504@redhat.com>
Date:   Fri, 14 Jan 2022 18:17:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re:
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Li RongQing <lirongqing@baidu.com>, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de,
        bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org, joro@8bytes.org,
        peterz@infradead.org
References: <1642157664-18105-1-git-send-email-lirongqing@baidu.com>
 <ee11b876-3042-f7c4-791e-2740130b93d4@redhat.com>
 <YeGvILDCvt70CrlU@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YeGvILDCvt70CrlU@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/14/22 18:13, Sean Christopherson wrote:
> If the assumptiong about KVM_VCPU_PREEMPTED being '1' is a sticking point, what
> about combining the two to make everyone happy?
> 
> 	andl	$" __stringify(KVM_VCPU_PREEMPTED) ", %eax
> 	setnz	%al

Sure, that's indeed a nice solution (I appreciate the attention to 
detail in setne->setnz, too :)).

Paolo

