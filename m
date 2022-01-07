Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28CA74879D5
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 16:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348127AbiAGPn3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 10:43:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:25479 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239665AbiAGPn1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 10:43:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641570206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TzpRVERh4CRAMa9TDU7mZpEigQ9ChriGr62E18b9bII=;
        b=iun5KDhy0rPMU8AcJB4PhMigJ7WNXlLyIcP54/g5LNKTQsbI46gYuI0nl81REfQNFGGJ7H
        l1Pcs/xeUa+yDc7wrMYQ1+Ly/wdaxBbKqNJg9cSMPFXeqCbMqB9t7mBOWxe/08PI0RpQQO
        VGZHyAXdSu+Ob4mYbGmjBfbOFtOi+HM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-313-uIJkqDQtPHSlJe2hUztXEQ-1; Fri, 07 Jan 2022 10:43:25 -0500
X-MC-Unique: uIJkqDQtPHSlJe2hUztXEQ-1
Received: by mail-ed1-f69.google.com with SMTP id s7-20020a056402520700b003f841380832so4986375edd.5
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 07:43:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TzpRVERh4CRAMa9TDU7mZpEigQ9ChriGr62E18b9bII=;
        b=J/74g4H0dVt23D8rTFGcdGrqiSbY7wAPMXPEHi94YEDdcA5nQK2Rz3u2m+HwFNae8y
         fB3Fp6ufsLIFaCGFdj2DqDBIJKmiqhAJRJlJeVIENX91/SuJQSBAIqrQpuwnHtEC9dLF
         MVb9t7AADIva3f8RRdvJ2aWUBFMU8UQETnwnYyTzJvn3OpcMtZQc2chJl9dODzzzZdEH
         2udiVxIZwy+QIhIjoytT0sRt1KKQ/2nSqSeRIm+GnXWDZG5ino9AVPmFD/3EbxRSeD4i
         Y1PcJJEJifMLXGIV6vty4r27JGDbVaS0+grjLsS4Y9DOVoMnKpOKqbmTKA+VfWOT1BN0
         +W4g==
X-Gm-Message-State: AOAM532GSTDRWpjb15ln5B8hE5IzzjLEKEWcW02rrSRq+FNIKkvNDTzi
        +a0L2VHuObHBup5zEKrxSMGDpelreWc06v2GfEJOgi77dAYTKwUw3QZVwT7rxM/H02YHxq5mR0u
        tOtj2xlyzhZdu
X-Received: by 2002:a17:907:7ea6:: with SMTP id qb38mr7091878ejc.59.1641570203943;
        Fri, 07 Jan 2022 07:43:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxleSjgznkzD99+meoFB9zsvvczl06qss5ywcdrcu34Oa7shLFaOgetnQXKpsZe6D6Mcp5kA==
X-Received: by 2002:a17:907:7ea6:: with SMTP id qb38mr7091865ejc.59.1641570203730;
        Fri, 07 Jan 2022 07:43:23 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id ga10sm560120ejc.12.2022.01.07.07.43.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jan 2022 07:43:23 -0800 (PST)
Message-ID: <896a998b-17b6-7f50-8f23-b14ff8f44333@redhat.com>
Date:   Fri, 7 Jan 2022 16:43:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [GIT PULL] KVM/arm64 updates for 5.17
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Walbran <qwandor@google.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Mark Brown <broonie@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
References: <20220107114548.4069893-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220107114548.4069893-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/7/22 12:45, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's the bulk of the KVM/arm64 updates for 5.17. No real new feature
> this time around, but a bunch of changes that will make the merging of
> upcoming features easier (pKVM is reaching a point where it will
> finally be usable, and NV isn't too far off... fingers crossed). This
> comes with the usual set of bug fixes and cleanups all over the shop.
> 
> We also have a sizeable chunks of selftest updates which probably
> account for half of the changes.

Pulled, thanks!

Paolo

