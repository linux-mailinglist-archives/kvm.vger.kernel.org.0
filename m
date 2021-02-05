Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC9A31068C
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 09:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhBEIVi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 03:21:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28921 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231563AbhBEIVf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Feb 2021 03:21:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612513209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Uv+kUPnBdvnVYh3bEPMtMV4L9Cn+q9TAxrYe42PIQs=;
        b=chp6LRzcWiT1u3vQwwWxi4DJZIGoGll0CIb59qkgi9RgTlzYRRmulaaphDT4EPxQkJ0in+
        TvEvZmda+WZJKbpDZkqG/GrincxAomE8+Y4USMkatibbweqf0yS5gRKRsVb3n5FWqHwLAx
        xnnMOflDkfY5ithlo7EjvIDok3WvSIc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-fm7vYtsyOdC6wIOYFQOnZw-1; Fri, 05 Feb 2021 03:20:07 -0500
X-MC-Unique: fm7vYtsyOdC6wIOYFQOnZw-1
Received: by mail-ed1-f72.google.com with SMTP id w23so6336383edr.15
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 00:20:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Uv+kUPnBdvnVYh3bEPMtMV4L9Cn+q9TAxrYe42PIQs=;
        b=jXM/vFLJGZjp+H8lzuL0KPBSIVemThqC41yC2vuan4aLxN7w/Y3QUIgQLv77YXJ1hO
         ZD3R79wfZUGuuf48fKBWX5XeP8JTkrTqArzx7SekTQOE6a1WNFWsIt1wnYgItId13/IL
         NwMPRi/v0LYBQ5VBLIXlRLmkPVIwA7zXqpr2YlKFKi14ClpNILyopAooEnJa2EPuSLn1
         Y1leIPhOHC0+mxe6yT4S4AxNWsRt2kLDMMrbfe//rziYppQT+6oYUA4hNsxbvagX8tgq
         8u0OAuG9sOu9wv4xnrL1WepVSvkzD1cdV6nNXXz2zDP77ySKYOJ8OOrwNjV1cvmYLKDd
         jAiw==
X-Gm-Message-State: AOAM533CzbDwhcM++QzzNTsDMP7H3ltp1QttPdaUn5HSWS0VGQzf/q7i
        bpeANjvKDZCYUSx32isPHFOEltK2Taxv2SMXoBk1XQYQhwhXrXmxEPvw62Hjo8MqlfG7pzLMP3n
        TPMCDk+0KMNrK
X-Received: by 2002:a17:906:f0d0:: with SMTP id dk16mr2939183ejb.533.1612513206296;
        Fri, 05 Feb 2021 00:20:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwMVVf1obQXHw/e9a7PJpU5nRu5b+AplJxWzLRKwZr5NAsLfILIeAEFVEcgHGFzDYLhTaq6Mw==
X-Received: by 2002:a17:906:f0d0:: with SMTP id dk16mr2939165ejb.533.1612513206159;
        Fri, 05 Feb 2021 00:20:06 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a10sm3642992ejk.75.2021.02.05.00.20.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 00:20:05 -0800 (PST)
Subject: Re: [PATCH 0/9] KVM: x86: Move common exit handlers to x86.c
To:     Sean Christopherson <seanjc@google.com>,
        Jiri Kosina <trivial@kernel.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210205005750.3841462-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a4eef9d7-a510-048e-df3d-f2f87ac77c3b@redhat.com>
Date:   Fri, 5 Feb 2021 09:20:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210205005750.3841462-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/02/21 01:57, Sean Christopherson wrote:
> Paolo, I based this on kvm/queue under the assumption it can all wait until
> 5.13.  I don't think there's anything urgent here, and the conflicts with
> the stuff in kvm/nested-svm are annoying.  Let me know if you want me to
> rebase anything/all to get something into 5.12, I know 5.12 is a little
> light on x86 changes :-D.

Yes, we can make it wait for 5.13.

I'm thinking also of taking the occasion to split x86.c further.  But I 
think it's better to move the ioctl interfaces out of x86.c, so for the 
purpose of this series it is okay to add more stuff to that file.

Paolo

