Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF3E392F7B
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 15:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236306AbhE0N0a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 09:26:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53546 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236413AbhE0N0Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 09:26:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622121891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=onocq9toJsJ3anY/i2nAmWaCyfsOMUV30kjs3HuzEGw=;
        b=f6XxH9vku9rsMA8x62gFax9ajbHT8sjZ0APnx7gMl9+711wIK9yh0yZdIc8ADkobzhtsNp
        QlKm2aJ2uPA+846W/tAHqA5/mtY9g+uGs74cYIUi9tbW+L9+cGF5M0rZgTDY0DTQ4t2NAN
        sgiFbvujf5uAocl/AL8IOi3203rlHS0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-_GGr2TifOyOmPcJ22HmtJA-1; Thu, 27 May 2021 09:24:50 -0400
X-MC-Unique: _GGr2TifOyOmPcJ22HmtJA-1
Received: by mail-ed1-f69.google.com with SMTP id cn20-20020a0564020cb4b029038d0b0e183fso288167edb.22
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 06:24:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=onocq9toJsJ3anY/i2nAmWaCyfsOMUV30kjs3HuzEGw=;
        b=LukIgkTdo/NoVtQD4MS4DhP/ehDWsOEsY52NPeD0bcbI/ddDwhlO3rWWG0gjUPcGJt
         IEv6Ga5nUYW+qtGd1sx6xOfj4cr2jM8DmgMrxh+EYfID367Psb0wYZXY4qlzWMkOiqRL
         CqxBGazNMn1y/eKpJ7Ph1BLMyLebdjDRonJxR6uIzHs5+JybcXLnS7C4P26p/Y5+FZDX
         o9aQbGZ8b1EvjZkPhaD/xMI8k2XVEzhAojWiUat+xdNrTAS5C0lXJtL5NSpwKVzyn/Jm
         qPTIY3fk0UajiAV8ws+VhiT4txzrSEqMKJAZqmJWxDbAJlL7Qc0L71HzodtnM43PvKVR
         h6KQ==
X-Gm-Message-State: AOAM533klnAm2y99Q76G1fYSpZwB1xH/pTBAmhF0CUY6DHb/dVlf96LU
        Yea5Z+Q9VVU3aKKQ1GLfpUxvExLhbqoXC2ilpccOgGWQxtmeXw9lPzLalzNfgxKwo6gCDHvd1ht
        XiJTVzc2IiM2j
X-Received: by 2002:a17:906:bcf9:: with SMTP id op25mr3861500ejb.453.1622121889007;
        Thu, 27 May 2021 06:24:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxhsiOXi652bfEl8+DPc/2hFhsuQTRK8by65rd6hN6BD3Rv9F7gDIXGUDuyJKcmwK9w3AljGg==
X-Received: by 2002:a17:906:bcf9:: with SMTP id op25mr3861479ejb.453.1622121888860;
        Thu, 27 May 2021 06:24:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id lf5sm986833ejc.112.2021.05.27.06.24.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 06:24:48 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.13, take #2
To:     Marc Zyngier <maz@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Steven Price <steven.price@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
References: <20210527104131.65624-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d1a9f961-15f9-f65b-c485-e942ad7a7694@redhat.com>
Date:   Thu, 27 May 2021 15:24:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210527104131.65624-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/05/21 12:41, Marc Zyngier wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.13-2

Pulled, thanks.

Paolo

