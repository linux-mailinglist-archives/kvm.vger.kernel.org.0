Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE6E4165E87
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgBTNRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:17:31 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52043 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728042AbgBTNRb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 08:17:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582204650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XvMmChK6SbgG0/2Lm5qNdD29/GRoTprQuuIJ6y74DbY=;
        b=OL4CmIvloyGVcCObFO+rKt31nQeBpfKoQDvKLpdQg8aKswvi7Pc35jR/Vd94SaaHopEf1a
        5j+lk7U5m4POFz9E5AkM8OCLyz/8JvKqP6KD2exbfnc5ngnupYkA/eNVDyjZF+1fnYHcqh
        WUpAg0j9GY3feuBt8Ygng/TEdz9qySU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-V49cwd0iO_Gs-1F3-aOELQ-1; Thu, 20 Feb 2020 08:17:28 -0500
X-MC-Unique: V49cwd0iO_Gs-1F3-aOELQ-1
Received: by mail-wr1-f72.google.com with SMTP id s13so1716943wru.7
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 05:17:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XvMmChK6SbgG0/2Lm5qNdD29/GRoTprQuuIJ6y74DbY=;
        b=e+DzL64LX1WP65DDhEZav5qrhPF5XZSb6fLGuuTXtTUAykKlQ5dbohvut3E3tn1uMP
         P1lMuuZNEJAmxE9ojeiRD+m+C3J9NGDdbPkPEFmc6Gq6RwPneddZizGgKqZHYKPopV+g
         A6kgUSS1A7wvbnqUQf0aU2RloyfM7EjMTY58xdBskvIjekYDWYHKkmkjLUQuG/z7Pt3c
         Odt1/mH0OnFdq7BEQ18E5uIXPCPqln13b127SaojYkXX0RjVptrMZ6SMTG2dsoa9AGwA
         LpbJXofb139YGLenYr1oHvKitaqRngXSgmrTB9Vtlv8yveslNsxg32UW44Lx5s+8b1EC
         35yQ==
X-Gm-Message-State: APjAAAXYKXCAPTrw2iDkvjCA5N3KS1WEA4vLGn0shcbkdVl59RxfZOKv
        jef9akGCOHEXtlwt4Y1AdrEjLAK7i4MYfuP5UsGVm2OoxzZhBzaYw6kQ142ww3RNRv8UOvwYXiO
        CwJQCMEDp4fJW
X-Received: by 2002:a05:6000:1012:: with SMTP id a18mr41811263wrx.113.1582204647567;
        Thu, 20 Feb 2020 05:17:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqz+bMIwb/40ta9G1MJyGw7FTeqK0evbAksgNT4fuWxaQqt0K6KuCAj18GyDem3xjd7ozBfutw==
X-Received: by 2002:a05:6000:1012:: with SMTP id a18mr41811244wrx.113.1582204647347;
        Thu, 20 Feb 2020 05:17:27 -0800 (PST)
Received: from [10.201.49.12] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id x10sm4168085wrv.60.2020.02.20.05.17.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 05:17:26 -0800 (PST)
Subject: Re: [RFC PATCH 0/5] Removing support for 32bit KVM/arm host
To:     Marc Zyngier <maz@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Quentin Perret <qperret@google.com>,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
References: <CGME20200210141344eucas1p25a6da0b0251931ef3659397a6f34c0c3@eucas1p2.samsung.com>
 <20200210141324.21090-1-maz@kernel.org>
 <621a0a92-6432-6c3e-cb69-0b601764fa69@samsung.com>
 <43446bd5e884ae92f243799cbe748871@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <250c6908-266f-0306-9d09-5ecf8dd6b736@redhat.com>
Date:   Thu, 20 Feb 2020 14:17:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <43446bd5e884ae92f243799cbe748871@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/02/20 14:15, Marc Zyngier wrote:
>> That is a bit sad information. Mainline Exynos finally got everything
>> that was needed to run it on the quite popular Samsung Exynos5422-based
>> Odroid XU4/HC1/MC1 boards. According to the Odroid related forums it is
>> being used. We also use it internally at Samsung.
> 
> Something like "too little, too late" springs to mind, but let's be
> constructive. Is anyone using it in a production environment, where
> they rely on the latest mainline kernel having KVM support?

Depends if you consider "production environment" somebody playing at
home with a SBC.  But it's true that, these days, most of those that
support EL2 do support ARM64, even if they are used with a 32-bit userland.

Paolo

