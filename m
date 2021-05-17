Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786EF3825EE
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 09:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235435AbhEQH5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 03:57:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30958 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235309AbhEQH5P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 03:57:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621238159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rT3LLQvP6Do94JcumEH0mRdHtxEizTm299DCgSoEINM=;
        b=g0OmcoWDjMgNZypMb7W2WWxoPDzCJkLYPxB9UN4j+cYyQjlGvDPi2ZS7H2F3XeuPW0/BOj
        pJ6NPfgutAEAw9j/O8exr+RAMDD1i3KmMU1+Wm9v6r7R/RyUsOoV5bx0V91sRMzre7fHfn
        3Z9RfCoEU/TC8RVLI5vZ9yhfNjEJRfg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-yUR0_EZlOByuouzpNFj9FA-1; Mon, 17 May 2021 03:55:55 -0400
X-MC-Unique: yUR0_EZlOByuouzpNFj9FA-1
Received: by mail-ed1-f72.google.com with SMTP id d4-20020aa7ce040000b029038d1d0524d0so2681469edv.3
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 00:55:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rT3LLQvP6Do94JcumEH0mRdHtxEizTm299DCgSoEINM=;
        b=jrZA2zx1n7khGWTd3G4+eLoiCxBp4HdtVsBvqMoFjyGCHQpzsZGJrUbJyxuzuV/fBY
         8JHhAgris5N2NZhoHr4vQPHJyFOULgIYVF4h/7/8dbu6sdktoSDfw+CuI2Umy3v9C9rE
         h1C+fhQK9Tld2XzvBK3Nf/GUIckzX9AEbqkbTfRGw9N2PJGZPvsFMHTsGSm63Al1MyDy
         K5KfJwzkM2ND9oPrwDseaXKozguWlsvYt1wJr/h0+GGJ34tVzpp0hLtl2cd4y8alY/XN
         IJ1Dau+P6iMCP3h8JGlaGN5YF8y6bgCAW6ho2yTOm4ORTqNHnAMYPOUq4pIc8VhimGYw
         WnXg==
X-Gm-Message-State: AOAM532Ol3yShBkScV7ZHZpkJS18cv7jdvbJyjsJW6qZJ33ADp8BOrJT
        FnRC/SqnR3194WIZQ6H6AgpUiVjn2PrvJ7Zszg/rTEYCc+U6dsNWcm0bedPjMoq3Pah4Jurct9H
        5KZCwHi+6LDFC
X-Received: by 2002:a17:906:e096:: with SMTP id gh22mr61391555ejb.101.1621238154311;
        Mon, 17 May 2021 00:55:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrz18w9HvZKC7KsjZznrJffVLg+kqHpMzA/+sGg41Ea6KJMAqBZQ42EgiiU411i9jT+XsoKQ==
X-Received: by 2002:a17:906:e096:: with SMTP id gh22mr61391531ejb.101.1621238154122;
        Mon, 17 May 2021 00:55:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id i25sm8271504eje.6.2021.05.17.00.55.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 00:55:53 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.13, take #1
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
References: <20210515095919.6711-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <84cda1d7-5467-f016-078d-0da0256b826b@redhat.com>
Date:   Mon, 17 May 2021 09:55:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210515095919.6711-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/05/21 11:59, Marc Zyngier wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.13-1

Pulled, thanks!

Paolo

