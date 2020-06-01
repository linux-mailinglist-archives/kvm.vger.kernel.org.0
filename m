Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB2A1EA001
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 10:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgFAI1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 04:27:08 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51156 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725886AbgFAI1I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Jun 2020 04:27:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591000027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E4lu/dxD8ezXYOJnBc6Dn7bo6tW00B3HpYIm/3Tes6k=;
        b=S3SVeapKW/tZrIe2PpmAvftuszwy9Vqz6R3wCJ4aiTUAathTyLKpCb3bYQrvMxZHhNMOR0
        u/Q3j2ukBrd50ip+A/huaO0jv+ND32Lcwdcx1k/6fxdgGHpN7z1EBjJk2Y6mM8wLZIG6NY
        UAqJkEvIvOxJTkThksYch57brJ5wI0Q=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-iK6HLFmSPimkpiTPvZvTGQ-1; Mon, 01 Jun 2020 04:27:05 -0400
X-MC-Unique: iK6HLFmSPimkpiTPvZvTGQ-1
Received: by mail-wm1-f69.google.com with SMTP id 11so2671528wmj.6
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 01:27:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E4lu/dxD8ezXYOJnBc6Dn7bo6tW00B3HpYIm/3Tes6k=;
        b=Mf5iyqXOh+1cqjQsF+4rjNMz5bSNveemGf9q0ekWCV0f0I4SOP6+bAh+DGkx3JVC14
         OvenPcHBbUOT0sdKYlkZ7xqH5uZBKvC/3JOkujjeQ+b5qYoR/8CK9NMJyttacc6Q9Gmh
         U3rZWEeKiT33SMla5HObpCxfE+C9rlwdLXbYTFyTQIlAmtNpaOrHt7QP7BlToW9lD/Ju
         7ntUvLhS9EcJ8KrK1CoaVdAvw4JZkQkjb6JOFBfrOWbQtfYmMgetgPqSuF8+nwxxDzw7
         1wBwnPdH4eiXVAlVCDQ0KjyHrnGb99hRasTmSyyn8S7hCP98B6bMj94pTlQXABn4EXLA
         7ICw==
X-Gm-Message-State: AOAM531ThYh8NJu3c/h6XCVxNzzvxrFc9T4PqMlSa8rbPnFu1dgWAw+7
        Rz+hIJ5mFnC5N+4vIxuPQm89nnpFVbs/7v2xQOpOKfQRE+M+4Gn9B5TXlY/whbtnAqMRWFeFHT/
        VG2iS6ChhMY8f
X-Received: by 2002:a5d:4bcb:: with SMTP id l11mr22357417wrt.363.1591000024453;
        Mon, 01 Jun 2020 01:27:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx32HOgFCCtByd40naAgUYbnAHE2Ln8h8s37CuU7DmFEmUw7hzr40v2F7kG19gUrQdUe0+aLQ==
X-Received: by 2002:a5d:4bcb:: with SMTP id l11mr22357394wrt.363.1591000024205;
        Mon, 01 Jun 2020 01:27:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e044:3d2:1991:920c? ([2001:b07:6468:f312:e044:3d2:1991:920c])
        by smtp.gmail.com with ESMTPSA id h137sm11582353wme.0.2020.06.01.01.27.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 01:27:03 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm64 updates for Linux 5.8
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Fuad Tabba <tabba@google.com>,
        James Morse <james.morse@arm.com>,
        Jiang Yi <giangyi@amazon.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
References: <20200529160121.899083-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <32adb91d-c80c-743e-fe8f-57aee08140c4@redhat.com>
Date:   Mon, 1 Jun 2020 10:27:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200529160121.899083-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/05/20 18:00, Marc Zyngier wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-5.8

Pulled, thanks (to kvm/queue only for now).

Paolo

