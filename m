Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131D749D05F
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 18:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243517AbiAZRFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 12:05:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25290 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236906AbiAZRFn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 12:05:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643216743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v3ZjP6VeZe7Q/860UowGIN2PNeWTZEeU6WyQSGVUMls=;
        b=i2udVVoCiGcHG7U/3F+5CwueIt2r30R2VZEpLHngxXHmCWBpT+FM9kOoCdylCnqSLLDRYs
        F7hepdvuXzYhSIwUuuSJ8RKuUJz6B6QvkPyMuS2X2qFoaFgmE8kZfhAmckcq34SFfO1Svn
        daCfhBDVQF+v/m7/gs8j41ChbcUi4x8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-vATEO-rsMw6F16pQjOg7zw-1; Wed, 26 Jan 2022 12:05:41 -0500
X-MC-Unique: vATEO-rsMw6F16pQjOg7zw-1
Received: by mail-ej1-f72.google.com with SMTP id r18-20020a17090609d200b006a6e943d09eso5175605eje.20
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 09:05:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=v3ZjP6VeZe7Q/860UowGIN2PNeWTZEeU6WyQSGVUMls=;
        b=pxa8h/0nZYnzMwoveaFVM+6wwKy3E69t4oGvHyAWb930dlUEe2zw7otC6nNv2iwlOe
         Dgdea1hheS3farCJN3LvLl2qkQkWo5NdrGh8qL7IgeGFKQxoCAkiR4Th5SXCE+kYdd5O
         vw7tzVjMdqRkPbszo3CwAzHef5X1SzwVolMrK6VAgLL7Z6ZWog9cEWilLwY8DaZAeI/P
         awtsm5MVArXdKcao8tXD1D1To65u18iF1A1v93tmMgjbd5YCWoOGpiRXkvS6LsSPXfJA
         SCObR1DOuQrwPWMtRvTQPI8TIVAOwz867TB2f6jquFQrzljvt+Co1sqccBA6g6VYfv+m
         z5zg==
X-Gm-Message-State: AOAM53259eYRsvzQXz94amIxLk1ecH9AFitavGzSbuB5wdSSPpTHiWmS
        znRDVQf+ods7bDfLv8kTxyEJVIcxASyRaFzc26EeAklrl56nUPQO+iGrPzBOD1n3yPiPi5BPAbA
        Hpz7SfD6YBkg7
X-Received: by 2002:a17:906:589:: with SMTP id 9mr21630212ejn.721.1643216740645;
        Wed, 26 Jan 2022 09:05:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxQll0mEg6+MLnV3bkmv7NaUphAuzY7ys699gfAchb37yFJ8kgpOBpXpBCU/k5yG8HQ0z2M2A==
X-Received: by 2002:a17:906:589:: with SMTP id 9mr21630190ejn.721.1643216740408;
        Wed, 26 Jan 2022 09:05:40 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id s20sm7617207ejc.189.2022.01.26.09.05.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 09:05:39 -0800 (PST)
Message-ID: <a7afb949-4865-f668-b2f3-414c8c4a47b6@redhat.com>
Date:   Wed, 26 Jan 2022 18:05:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: nVMX: WARN on any attempt to allocate shadow VMCS
 for vmcs02
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220125220527.2093146-1-seanjc@google.com>
 <87r18uh4of.fsf@redhat.com> <053bb241-ea71-abf8-262b-7b452dc49d37@redhat.com>
 <YfF1TQx/vsV5OepU@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YfF1TQx/vsV5OepU@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/26/22 17:22, Sean Christopherson wrote:
> I don't like preceeding, because that will likely lead to a crash and/or WARNs if
> KVM call the helper at the right time but with the wrong VMCS loaded, i.e. if
> vmcs01.shadow_vmcs is left NULL, as many paths assumes vmcs01 is allocated if they
> are reached with VMCS shadowing enabled.  At the very least, it will leak memory
> because vmcs02.shadow_vmcs is never freed.
> 
> Maybe this to try and clarify things?  Compile tested only...

Your patch is okay, just with an extra paragraph in the commit message:


The previous code WARNed but continued anyway with the allocation,
presumably in an attempt to avoid NULL pointer dereference.
However, alloc_vmcs (and hence alloc_shadow_vmcs) can fail, and
indeed the sole caller does:

         if (enable_shadow_vmcs && !alloc_shadow_vmcs(vcpu))
                 goto out_shadow_vmcs;

which makes it not a useful attempt.

Paolo

