Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA533204B1C
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 09:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731612AbgFWHaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 03:30:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29528 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730830AbgFWHaN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 03:30:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592897412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xG+vPmO09PLIStXFidNP/fWUMuwznoRLPwS1a87G2rU=;
        b=S5XTefc3vA3r7VSOY8DWooJA2Zaw4ImC+U3RtYmsiR0GHuxc7bpKKqFK27bWAaxu5NmATc
        RenhDxu7qaeJmDl2D1lRUlr1qPm1CevGyrfmHou28RCEgDzpzzzPSrmNDHpgDU8qxFddIE
        YEYdLgegCfcNK+Qt5wVRYlLOrtJ1rF8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-aoYgrzCDPjCeOtohvEfYBg-1; Tue, 23 Jun 2020 03:30:10 -0400
X-MC-Unique: aoYgrzCDPjCeOtohvEfYBg-1
Received: by mail-wr1-f70.google.com with SMTP id y13so1213158wrp.13
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 00:30:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xG+vPmO09PLIStXFidNP/fWUMuwznoRLPwS1a87G2rU=;
        b=TCZhYK0j5zeKbyesSdTqp7NJq0rJYAccgOupalsU8uzsU56PuBZCRr0E14tRxDeJwB
         CRHUu43BrHE3wP/4rBgZD8WTYRpinMrYk5Zw81lqNPb7OpKjMcoWkeuiMT1LsP5NAX/B
         GA7XxVvazHLG3p4pEv3Z3U6jNaTA0GI/t9aUMT+kuqBMCZJu8LpzfPomx2JKELCxh37e
         KHxzGpf/Y/d+nBrcKvg4eoNS5QBT41L6M0IriEQ+DA4JbKXoTwRs3rR2AYir1Q77X9WO
         y+xchCqri/yL2vT3/yDqtcPHSDJ+7kB/yKwLT2P01A5JeZ8mHc8s4VynLWpzYYd5y6Mc
         q+Bg==
X-Gm-Message-State: AOAM530XISHOi3s7Y2LuspTwPwdqbFELNTQdxdNbDIRQrOjWJxIA7bIO
        so4g02UqtUPVssh8a80bJaCUr9pfgo+F11ravqLJlySbGQIGTcv+8PcvfXJi/TJkRHCXiSeM3yS
        LBKkHI7zay+3k
X-Received: by 2002:adf:a491:: with SMTP id g17mr24849392wrb.132.1592897409320;
        Tue, 23 Jun 2020 00:30:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyq7ChqOSjzQTjNWD8bKOLf2k0/XEOFe3M1v/CXfxXvnOz5le81vgnjgvqLGIC9Ugzy5sPvFQ==
X-Received: by 2002:adf:a491:: with SMTP id g17mr24849369wrb.132.1592897409099;
        Tue, 23 Jun 2020 00:30:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:24f5:23b:4085:b879? ([2001:b07:6468:f312:24f5:23b:4085:b879])
        by smtp.gmail.com with ESMTPSA id x11sm2334177wmc.26.2020.06.23.00.30.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 00:30:08 -0700 (PDT)
Subject: Re: [kvm-unit-tests PULL 00/12] CI-related fixes and improvements
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
References: <20200616185622.8644-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2948ba50-acad-4c18-33ae-e45a2b876969@redhat.com>
Date:   Tue, 23 Jun 2020 09:30:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200616185622.8644-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/06/20 20:56, Thomas Huth wrote:
>   https://gitlab.com/huth/kvm-unit-tests.git tags/pull-request-2020-06-16

Pulled, thanks.

Paolo

