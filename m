Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9443430D480
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 09:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbhBCIAQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 03:00:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26566 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231704AbhBCIAQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 03:00:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612339128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Le4iuV0fc/jRHPu6t79f0QWPTHoOpEryhOXjwy8BhTY=;
        b=L00SfHNIiHrT9tw0Z5SEkeyQNgTHVprBzmVGjrWv7heMjRb+fQdiWdaQdpUy+fakDz0z1i
        y6gcI5nB2BaK7+k1uptwf5vnNEssCjRV1FJmDY38VAvszANAgM59pP0g0Z3GYzoDDwXkgI
        asUtwHVpdf6hKtvsBdg2K3exg6nZ5mY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-QqafcvoAN3eKzpQYJggRQA-1; Wed, 03 Feb 2021 02:58:46 -0500
X-MC-Unique: QqafcvoAN3eKzpQYJggRQA-1
Received: by mail-ed1-f71.google.com with SMTP id u19so10990201edr.1
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 23:58:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Le4iuV0fc/jRHPu6t79f0QWPTHoOpEryhOXjwy8BhTY=;
        b=Juq7yLWERobfAJchaaD3W5X0RCv1lroh2qLWf+XDyotKZUBAB+mfVQfho3+RLEL/QQ
         2xz/ql+steUrP+kmPi9yH8U3sD9C5TYwY/8VNNAcyJEzlsX94rlWhtfgNqjsxICdCLrD
         lZvKUk8qrQSzeHxgxm12fuHAzE2ai/E9tVKgdAp3fwcyrWwj+1cLpzonjYrLqHpEqUnI
         PwD6/gK9VSKrSkPftUOuyg039plI2NUefcCQXFV43dMeycFNw3uXb0mdXRXWXJ3emERt
         amVkeIbmTtKIFWRdi7wCj0Fw0BgDpQAjll3QmUqlMrFf6vAVTO1aKpUkTAQxGKjGP5ll
         KGFw==
X-Gm-Message-State: AOAM532tuAw6OWjaquT+NxX2iDo7a/q+Sic4OMHGUilYzJwVUnm7NrEX
        KxEwA2DSBlPPGUagDTCeLYhYbA+WL2BYwveHFiIpIekFpMqu/TCvP5J3YB0bmSCa/rOeN/u0aPu
        pjbY3Y7Tob41T
X-Received: by 2002:a50:85c4:: with SMTP id q4mr1758707edh.7.1612339125181;
        Tue, 02 Feb 2021 23:58:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxqSe/aIV6dIfbUVUz74HMqp55I3lNhi5OrNIWNtt8xEda6IAGvtGzrH+zwwcWXss16JTlDw==
X-Received: by 2002:a50:85c4:: with SMTP id q4mr1758695edh.7.1612339124995;
        Tue, 02 Feb 2021 23:58:44 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k3sm601608ejv.121.2021.02.02.23.58.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 23:58:44 -0800 (PST)
Subject: Re: Optimized clocksource with AMD AVIC enabled for Windows guest
To:     Kechen Lu <kechenl@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-discuss@nongnu.org" <qemu-discuss@nongnu.org>
Cc:     "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Somdutta Roy <somduttar@nvidia.com>
References: <DM6PR12MB3500B7D1EDC5B5B26B6E96FBCAB49@DM6PR12MB3500.namprd12.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5688445c-b9c8-dbd6-e9ee-ed40df84f8ca@redhat.com>
Date:   Wed, 3 Feb 2021 08:58:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <DM6PR12MB3500B7D1EDC5B5B26B6E96FBCAB49@DM6PR12MB3500.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/21 07:40, Kechen Lu wrote:
> From the above observations, trying to see if there's a way for
> enabling AVIC while also having the most optimized clock source for
> windows guest.
> 

You would have to change KVM, so that AVIC is only disabled if Auto-EOI 
interrupts are used.

Paolo

