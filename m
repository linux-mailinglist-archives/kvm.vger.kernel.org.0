Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D21485215
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 12:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbiAELy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 06:54:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:25613 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235593AbiAELy6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 06:54:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641383697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aAoXt55k6bjaDtUUwkzXgKzyGKHY2KEKPJyhFtkoMeg=;
        b=JPWNZ7A9Sc4iTD0KLjHkFi/0dd2QP9B5OKkBplXjpgnZRiZqkfVVJu9Dt1MWpj5xySMtfN
        qB7coaHHLw06azMY/5EjgUpoFzEEDOYUUNMLsquGueW7NtBABcr2vjFafaijhPh09PkWYS
        pWAMqdc+HmbvO358nw5Qxmy0dQL7fvk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-3-RkRDd71LMVK8VPOdhJIcxw-1; Wed, 05 Jan 2022 06:54:56 -0500
X-MC-Unique: RkRDd71LMVK8VPOdhJIcxw-1
Received: by mail-ed1-f71.google.com with SMTP id ch27-20020a0564021bdb00b003f8389236f8so27525917edb.19
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 03:54:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aAoXt55k6bjaDtUUwkzXgKzyGKHY2KEKPJyhFtkoMeg=;
        b=UzwXb5ZNqQ7KyrtQ3JbZq9ig4rZ11JsJv4VewDde2temp/bgyhgtIU/d2iTCBgQjdO
         6qi9Wz7aEW35kRZSngmQyGSpJqficOEDoXYOusKJ5u/troA3XRrPGpnd2vdKGVRjOmty
         Q3k609mpIaMzpd9eLANebeOLqL+rCUGzQ36HE4eMOSqO//As8Tey4oyvxohzDONyGEF9
         wbEkEmuynZHRz1N+1Ri0sGxQZrITQCEOfYA0iGtqLZhlGY6mE6rC/gC0xY2YR8299LUE
         QbCxn0fqDs8fTA4XDF8B0+1f2j/JvYWAfGrB5qrbhnRG6pLQqwlaP/SjkGf+91pwxc6p
         YgnQ==
X-Gm-Message-State: AOAM533xE0gkZ08mL51S3JEWjmIyjivZM0JGA5JsGTHWBudgCMWeZgl/
        /prD4HhcyRGBvasYhOpFws4rFs2bDq+pgJ8ZuhMlbClYWho1S6UdcqOM5SKby1+ZudRxbACvsAP
        wg0lpqi/ry7+n
X-Received: by 2002:a05:6402:ca6:: with SMTP id cn6mr31077582edb.134.1641383695519;
        Wed, 05 Jan 2022 03:54:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyLThERT6lJIyl3ORC8aXUxR59uN40IfnEPIcXx69NdeTRY4dRecmfZ19cwhwWx4EdNIOKePw==
X-Received: by 2002:a05:6402:ca6:: with SMTP id cn6mr31077566edb.134.1641383695299;
        Wed, 05 Jan 2022 03:54:55 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id h18sm15738239edw.55.2022.01.05.03.54.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 03:54:54 -0800 (PST)
Message-ID: <ee5811a7-55a8-158a-7454-7166c045dbc3@redhat.com>
Date:   Wed, 5 Jan 2022 12:54:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 3/5] KVM: SVM: fix race between interrupt delivery and
 AVIC inhibition
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>
References: <20211213104634.199141-1-mlevitsk@redhat.com>
 <20211213104634.199141-4-mlevitsk@redhat.com> <YdTPvdY6ysjXMpAU@google.com>
 <628ac6d9b16c6b3a2573f717df0d2417df7caddb.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <628ac6d9b16c6b3a2573f717df0d2417df7caddb.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/5/22 12:03, Maxim Levitsky wrote:
>> Hmm, my preference would be to keep the "return -1" even though apicv_active must
>> be rechecked.  That would help highlight that returning "failure" after this point
>> is not an option as it would result in kvm_lapic_set_irr() being called twice.
> I don't mind either - this will fix the tracepoint I recently added to report the
> number of interrupts that were delivered by AVIC/APICv - with this patch,
> all of them count as such.

Perhaps we can move the tracepoints in the delivery functions.  This 
also makes them more precise in the rare case where apicv_active changes 
in the middle of the function.

Paolo

