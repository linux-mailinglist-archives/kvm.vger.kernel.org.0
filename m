Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DECA447EC4
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 12:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239191AbhKHLWs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 06:22:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58597 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239177AbhKHLWq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 06:22:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636370399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OERNggq5Y+xLzf5LS68CDlX9Lh1Q9ESGR/6aoJbmMHc=;
        b=X6gCjsSAnAhdS/qNc1zYFAc1A/cIb+IBTCnoo8yIaU7Q76x+ShNKAQ/OGdnwn/BRMSAymh
        gMA/ElWjz9a4wu3nq5Mul2vVJcKLiQy2oj+OBz0AcdIH9CNhcW6tWWNUmL1Ju03qjkdSjv
        rfswCYcYcCK+7sFCVfDJihew//LRsj0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-DPznZ5lRP5KDxa9jF8KoTQ-1; Mon, 08 Nov 2021 06:19:58 -0500
X-MC-Unique: DPznZ5lRP5KDxa9jF8KoTQ-1
Received: by mail-ed1-f72.google.com with SMTP id f4-20020a50e084000000b003db585bc274so14490346edl.17
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 03:19:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OERNggq5Y+xLzf5LS68CDlX9Lh1Q9ESGR/6aoJbmMHc=;
        b=prReFLYj26tl6K8KK7GZXlTZEHgj5X/DFtpSD3ifsM38exiIc7S0midQzEoxXCpsq/
         cm4f8/q0jOc06k40EyI9Ytp0dutIvXOBrZonRdUpf/zR3fvsFQqPRr4B74A/uxprmgXU
         sTJyDs76WeNDKIqGbd8O6rxawO+ChbcNlCaBkNb1o9I/aPQFDOKhvxnlgx96ZrGIWqQR
         TJ7Z8otSDRS96K6Mg7WANqMs9WfRI1IO7DYWVk6FwECARpE4kjdmQxRt5HGT22uwH5Om
         TxI8igd5BMdo6tBWA9hiappCovsLosuOH7DBYF8peYZuCW3bKOsYw2cu5A+4wSjPo2GF
         gMHg==
X-Gm-Message-State: AOAM531eIynV+GPhAalK8ADL2Fomftci5vGAtJiKRoIFIycPdz86T4Hl
        euph8KPFP2GCphIYQ5+hSpIacyDnOmtsivmBvFCbt1oVci3PwXyjxjk23RUO5aArV8epanMvL4y
        ZVdR79zSx9Ylh
X-Received: by 2002:a17:906:c1c9:: with SMTP id bw9mr96435311ejb.3.1636370397571;
        Mon, 08 Nov 2021 03:19:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwVag4TCcB6qtlnRSSlsZn0Oq5TcZp/IPBjNnOlSvDzrFavistrdtkih9qeWT6MQifI+0sLgg==
X-Received: by 2002:a17:906:c1c9:: with SMTP id bw9mr96435278ejb.3.1636370397365;
        Mon, 08 Nov 2021 03:19:57 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id jt24sm7722928ejb.59.2021.11.08.03.18.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 03:19:06 -0800 (PST)
Message-ID: <c3c84251-44b0-cff1-9607-b3686f1196b0@redhat.com>
Date:   Mon, 8 Nov 2021 12:18:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC] KVM: x86: SVM: don't expose PV_SEND_IPI feature with AVIC
Content-Language: en-US
To:     zhenwei pi <pizhenwei@bytedance.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Kele Huang <huangkele@bytedance.com>
Cc:     chaiwen.cc@bytedance.com, xieyongji@bytedance.com,
        dengliang.1214@bytedance.com, wanpengli@tencent.com,
        seanjc@google.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211108095931.618865-1-huangkele@bytedance.com>
 <a991bbb4-b507-a2f6-ec0f-fce23d4379ce@redhat.com>
 <f93612f54a5cde53fd9342f703ccbaf3c9edbc9c.camel@redhat.com>
 <ad6b3ef5-4928-681c-a0cf-5a1095654566@bytedance.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ad6b3ef5-4928-681c-a0cf-5a1095654566@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/8/21 12:14, zhenwei pi wrote:
> I don't yet know if there is a solution to this which doesn't
> involve some management software decision (e.g libvirt or higher).

If we use a new hint, there's no problems with migration from/to older 
QEMU and libvirt's host-model/host-passthrough would pick up the bit 
automatically.

(I'm not sure if libvirt knows that hints can change across migration, 
though).

Paolo

