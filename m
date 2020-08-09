Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B6023FF2B
	for <lists+kvm@lfdr.de>; Sun,  9 Aug 2020 18:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgHIQNf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Aug 2020 12:13:35 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53287 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726175AbgHIQNQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 9 Aug 2020 12:13:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596989594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mg/sYUoBZz1byLWR2WieaEgLigz8B2nOGaHe6iDN1Yo=;
        b=S70c/ofMbOcM/tviHBXg8TuFmE8zmGAYpUxcdgwjc04MPUVF49/UG5c9d3x3J2wHmttRwl
        cHutnWZmJ1+ak4O5arPnBVxDhGxvWv/DwxVwknF/6cQd3d6TBCrVlj4wyWZSXW3x8FXaIz
        VYPQ/kMJHMg/VUkcivgC2BCLQI3bMVM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-pPX_3Ts9MB-s1YDxsNBAVA-1; Sun, 09 Aug 2020 12:13:11 -0400
X-MC-Unique: pPX_3Ts9MB-s1YDxsNBAVA-1
Received: by mail-wr1-f70.google.com with SMTP id t12so3246545wrp.0
        for <kvm@vger.kernel.org>; Sun, 09 Aug 2020 09:13:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mg/sYUoBZz1byLWR2WieaEgLigz8B2nOGaHe6iDN1Yo=;
        b=kmlx27FktWGlSmmjjztMyMxG9vHgWcXpdi6khp6D792HgTTx+HlUEjGvoiCoBzrB9n
         Hh0fZXFi2DQBw0VuBFVfVLjKOPrY665+BJ0Iq+dlDwkqnP6lp093P0AnIreiSJXBhIhe
         BFVvIna8iisovaG7g/K80gd62+t0HaotSf5QIv/nf04kN3+SW9Ddz7atEHBXRAkk8MRf
         L3553mBwc590c4FLEHuhnVVnN7Tyj7S81RiG1G0vmVAwaBL8q5vI4WBlj16RiQ3CSvWX
         /MPMwUpfpU1nhGbRehFTUxltIwLMd5MbaoHqr9q4p2QivYa79oRM5yEPDeQ3vxobnfb/
         3XEw==
X-Gm-Message-State: AOAM530UtY7f3QBKJZnq/PHjQw/yHnQZEphsI7Sia26X6AQTm2naMVUq
        8TQqi+2CqqzqAuQRB/UP6UX5Us2l2YrhlYx4+BlrlHmmMXZFun4ZAQRZTsMDNdKgAMKzy23Ot4b
        qvo3mEpBEUD8d
X-Received: by 2002:a7b:cb19:: with SMTP id u25mr20628922wmj.113.1596989590718;
        Sun, 09 Aug 2020 09:13:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzoaRt4v6dETBL0JGQT56R5w6T3hYkaDa6PIHuw8DyoGUmzXuvVwqp9ViRh/pLxUaOaLGmzkA==
X-Received: by 2002:a7b:cb19:: with SMTP id u25mr20628892wmj.113.1596989590465;
        Sun, 09 Aug 2020 09:13:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8deb:6d34:4b78:b801? ([2001:b07:6468:f312:8deb:6d34:4b78:b801])
        by smtp.gmail.com with ESMTPSA id y84sm18313519wmg.38.2020.08.09.09.13.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2020 09:13:09 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm64 updates for 5.9
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexander Graf <graf@amazon.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peng Hao <richard.peng@oppo.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
References: <20200805175700.62775-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cb8e16e4-ed3c-6cf8-4f21-57d2e6184fb8@redhat.com>
Date:   Sun, 9 Aug 2020 18:13:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/08/20 19:56, Marc Zyngier wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-5.9

Pulled, thanks.

Paolo

