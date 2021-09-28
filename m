Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECB741B414
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 18:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241895AbhI1QnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 12:43:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46817 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241858AbhI1QnS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 12:43:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632847298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PRr6yH8iE3kvIOaBo9Egrh5B+ijwJWy0w0Y5bYRa2to=;
        b=bDHatWLndFSqyDABLI1m5MSePoz/4ZoClCYo5EWPYDX9uMuFn5Dn01L991r6FMDP2uwo4r
        gobob3qAyRrS0Fj4rSX4ZpzFLXYLvJOSbEfpRGDNcbLqcfbhJvewnG/gN9WIH16Thbn0vK
        btlvbX/TTVeFjl3xuieRL/RfvjmfjhA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-moyZcq3HPEWbzKr09kWSsg-1; Tue, 28 Sep 2021 12:41:36 -0400
X-MC-Unique: moyZcq3HPEWbzKr09kWSsg-1
Received: by mail-ed1-f72.google.com with SMTP id a6-20020a50c306000000b003da30a380e1so17743389edb.23
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 09:41:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PRr6yH8iE3kvIOaBo9Egrh5B+ijwJWy0w0Y5bYRa2to=;
        b=dWUpWvU1y8hC8yodCrjArUa2WgtNwjdnppTr5dajW45IGxDz8L9I/y53zgt3Gw3lvh
         w/5bwOM0wgNfXY0r/jMi+csyk81BVZYZAI7M542yxt2gxrail2A2CRU3LH1h1lL+hMSC
         wnnIYdRI0uFLb1/feB8IR/8+xdjDxPzdAg8Ak89d6mFWM8YEZPetIfDohup2lCNqVgVW
         jiGDlcTDOog9sqB8tKkZNEy6L69/HHxWkus+fGh6z77MCHoDl+N0aQSRWLxr3ML5RyCm
         4+F2FUt98ao3IJ7jSN2Okb7sC4QU49vXX2rI6BFXdoZefUrnRtVZw5ZfvKaplU/A90Ig
         wTSw==
X-Gm-Message-State: AOAM531Aq42lxjFGhptTs8Sipplg8xcdaWCiZVW1bjZMgzx4GNt3TBjR
        DKBPDuXA2BqASR/3XNXvOGXD1fXf10C8cx4XnmxoUyHjTh/4aQgRla36txBL6GkYX0qt/xDH1nd
        zlWiXO3grRZsO
X-Received: by 2002:a17:906:cc4a:: with SMTP id mm10mr1284269ejb.384.1632847294510;
        Tue, 28 Sep 2021 09:41:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0B70PGd40+l8AVXMAvDDSQoARkmaV5PDGrsf3ott4UI1ydNflKd+KB9jJ04ZN4YwImVYzAg==
X-Received: by 2002:a17:906:cc4a:: with SMTP id mm10mr1284232ejb.384.1632847294341;
        Tue, 28 Sep 2021 09:41:34 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d3sm13456533edv.87.2021.09.28.09.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 09:41:33 -0700 (PDT)
Message-ID: <452d73b2-2d39-e80d-021d-f24550eaea82@redhat.com>
Date:   Tue, 28 Sep 2021 18:41:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 2/6] x86/kvm: add boot parameter for adding vcpu-id
 bits
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     maz@kernel.org, ehabkost@redhat.com,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20210903130808.30142-1-jgross@suse.com>
 <20210903130808.30142-3-jgross@suse.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210903130808.30142-3-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/09/21 15:08, Juergen Gross wrote:
> +	if (vcpu_id_add_bits >= 0) {
> +		n_bits += vcpu_id_add_bits;
> +	} else {
> +		n_bits++;		/* One additional bit for core level. */
> +		if (topology_max_die_per_package() > 1)
> +			n_bits++;	/* One additional bit for die level. */

This needs to be unconditional since it is always possible to emulate a 
multiple-die-per-package topology for a guest, even if the host has just 
one.

Paolo


> +	}
> +
> +	if (!n_bits)

