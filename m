Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7ABD487AD7
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 17:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240182AbiAGQ7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 11:59:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26436 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231523AbiAGQ7z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 11:59:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641574794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+lmUBbsP+HB/oFdKh0UL456mGzPQATQ/BH2hseISnSI=;
        b=QAqgptq5BbuGcvwWQ1wOd2EINww66f+pbCitFiEzWmpG0w6JzMAcY2w+AaNjjSrTNZPSK4
        d1an3vUMgauVFev/ueOCWONewHHSx0Zbbym4FmJnKd8QcB+TjreY8yovYdKMFTcjPTvwt0
        J5/UQReEts43+/eQEOlgBZIBydwTrkw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-330-uwDnwqf-NtWFSRbaUJqqag-1; Fri, 07 Jan 2022 11:59:52 -0500
X-MC-Unique: uwDnwqf-NtWFSRbaUJqqag-1
Received: by mail-ed1-f72.google.com with SMTP id w6-20020a05640234c600b003f916e1b615so5134260edc.17
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 08:59:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+lmUBbsP+HB/oFdKh0UL456mGzPQATQ/BH2hseISnSI=;
        b=kHGEU7ufztG/7AtcvyaMVWpugufZRggae3W8XGP7nGBOpJQstceInKaqpXnxMFwGak
         Gl7INys6kMtSIIoQuQzNTTRl/W2Iz7NbDcX7G3CeurZNmpi6t44M3ZNOFGDikKq1167K
         guEY21qXot+xUNxI+outGj6nPAu20dtU3dgNBl4Bpz98jTCfzj5tfIx9ii4/LuSGLXP4
         B6AjLEH4kDVB1t8kqlLsdcmnI72X8Zv2Xb9S3EZSaFTLqXScC+GwxKpJomcNicEgtmhJ
         AvM7A0BNHZeHwhm8DqaMNQTnzjAgLpP5eryzrmuX20zIMICyrAnkCuYE0UtZfytGV997
         A5uw==
X-Gm-Message-State: AOAM533EQ34SsJWabP+ns7IaYt55Ja+tg7EA+XbxwW3rIwORub25hAW6
        Hkiv6Xa+GU9aEBO6Q8Qrngd7jhp0Tewe6wl4j/ka9rhCQTOX/NBJaf3mFp/m7ETIYYOGjn1eu7b
        UoCPr+Dlb5Kae
X-Received: by 2002:a17:907:728c:: with SMTP id dt12mr6801670ejc.188.1641574791646;
        Fri, 07 Jan 2022 08:59:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxstuz4ig67e43HaTHAZvQGqrXrTiJRix3l13GLpwNya6AHdYZ9BVvZwFAXZ2GF+Ih0NRgT0A==
X-Received: by 2002:a17:907:728c:: with SMTP id dt12mr6801658ejc.188.1641574791469;
        Fri, 07 Jan 2022 08:59:51 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id jg38sm1543421ejc.154.2022.01.07.08.59.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jan 2022 08:59:50 -0800 (PST)
Message-ID: <b57f1785-e61f-20dd-49e1-76dfc1917df8@redhat.com>
Date:   Fri, 7 Jan 2022 17:59:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH RESEND] KVM: x86/pmu: Make top-down.slots event
 unavailable in supported leaf
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220105050711.67280-1-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220105050711.67280-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/5/22 06:07, Like Xu wrote:
> +		/*
> +		 * The 8th Intel pre-defined architectural event (Topdown Slots) will be supported
> +		 * if the 4th fixed counter exists && EAX[31:24] > 7 && EBX[7] = 0.
> +		 *
> +		 * Currently, KVM needs to set EAX[31:24] < 8 or EBX[7] == 1
> +		 * to make this event unavailable in a consistent way.
> +		 */
> +		if (edx.split.num_counters_fixed < 4) {
> +			if (eax.split.mask_length > 7)
> +				eax.split.mask_length--;
> +			if (eax.split.mask_length > 7)
> +				cap.events_mask |= BIT_ULL(7);
> +		}
> +

The first "> 7" is wrong; it should be == 8, shouldn't it?  Something like

if (edx.split.num_counters_fixed < 4 && eax.split.mask_length >= 8) {
	if (eax.split.mask_length == 8)
		eax.split.mask_length--;
	else
		cap.events_mask |= BIT_ULL(7);
}

is what you mean, I think?

Paolo

