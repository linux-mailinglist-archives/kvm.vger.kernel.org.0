Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823351DC12C
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 23:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgETVP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 17:15:57 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57282 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727897AbgETVP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 17:15:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590009355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nn5uBihfGYPam0z7Bth4Bg/2LeoczkcBonH1Rf5fkTY=;
        b=C+Kat4jSu/ByOMLoiVlwfmz4kYR4LVhM0FEntwGPSV/2zMyoCq5Uj6qE5Vu+z8KBRVyQai
        ltUMDCGPJdlFC9K9d/3fnoSG7CGAN1PdPSwn0SPW7XH2CnNfvclbtkYHuC5oDVulsVvY6S
        vIzTgKS+zFMu2VULivJIQ9qWM8+qk2Y=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-0EwtpRNxMmGLd_Zx5T0Ppg-1; Wed, 20 May 2020 17:15:53 -0400
X-MC-Unique: 0EwtpRNxMmGLd_Zx5T0Ppg-1
Received: by mail-ej1-f69.google.com with SMTP id t26so1866491ejs.19
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 14:15:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nn5uBihfGYPam0z7Bth4Bg/2LeoczkcBonH1Rf5fkTY=;
        b=Xp5DmbWrKb1u2aHHsi3vI3sud/G9wDHhWVbZ2FLs3ckymdhxOqUAxIONa0fuarV2PH
         mhmciwrCGYARa/d3IdbF6Y/tzCn5nB5iqkUIWp6oI5tIaqJPeKBsFUZ90XgGYdDNhT3N
         WtRR7UAesWvPJRhwD/sfywyl6MeEevEWOcFt/Y8gDv8B6JgnxnokWk2wiRe8CkoKZSqf
         mNt0CQsxzQeOTnGag/fPLRYuqW2CBcLEWVpIz3l1B5ZJCqIq0Y0ov3a/HsW8RaA6x4ql
         oqml8vN+XyYYGMrKhJRScyitHWpJsVzcPv23OlEBhjW3jWENMHhOqXpWhCLgKyX3VJzY
         uTkQ==
X-Gm-Message-State: AOAM5318JD5uSGbKmLc5rkp6Dxy4TI5rrhKOsLAIyWhFtGuHMTlS5uEz
        jI6A8Oe6mhcFqM8wM8DN64Lqw6Dd7Qe5WDgQuGch41O2xmX35/uscwgS2BROkfU2EF6nUIdWpNm
        7fzUT/Yr6YZr1
X-Received: by 2002:a17:906:298a:: with SMTP id x10mr893229eje.238.1590009351884;
        Wed, 20 May 2020 14:15:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyP+T4UQY4+ZFFK7rI3puH/bbF9P484sU4hk3mzrt0kP4DghamnJ1GKfP2P9zAY21b+8eR5zA==
X-Received: by 2002:a17:906:298a:: with SMTP id x10mr893215eje.238.1590009351702;
        Wed, 20 May 2020 14:15:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1c48:1dd8:fe63:e3da? ([2001:b07:6468:f312:1c48:1dd8:fe63:e3da])
        by smtp.gmail.com with ESMTPSA id 89sm2898493edr.12.2020.05.20.14.15.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 14:15:51 -0700 (PDT)
Subject: Re: [PATCH 00/24] KVM: nSVM: event fixes and migration support
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
References: <20200520172145.23284-1-pbonzini@redhat.com>
 <6b8674fa647d3b80125477dc344581ba7adfb931.camel@redhat.com>
 <cecf6c64-6828-5a3f-642a-11aac4cefa75@redhat.com>
 <2401913621cc7686d71f491ef55f30f78ebbb2eb.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <81f6d5ce-b412-31f8-e750-67d4a06a5357@redhat.com>
Date:   Wed, 20 May 2020 23:15:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <2401913621cc7686d71f491ef55f30f78ebbb2eb.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/20 23:08, Maxim Levitsky wrote:
>> IIRC you said that the bug appeared with the vintr rework, and then went
>> from hang to #DE and now back to hang?  And the hang is reported by L2,
>> not L1?
> Yes, and now the hang appears to be deterministic.

Ok, that's actually progress.  Also because we can write a testcase.

Paolo

