Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7ACC1998D2
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 16:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730366AbgCaOpQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 10:45:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23156 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726595AbgCaOpQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 10:45:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585665915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XkVeG+wiUd998qeT4qan+1QjPL9epNOUfW2FxCj8pH4=;
        b=dKsiSLbhrR8hOWdx+nPu0KzBrE9VMBnXegpo5TwPQKYbQFvm1OjtJ2FuBGDHezWycr/gDP
        sZe2Nu6Q0lVxNt9ScvehHUy81+kg6gPqAXXVxgu1OSH86HEIAKsc3fUiEnCX1/SERTrlJI
        UBFdbP433NBztT3PD7pLhGGbYGg1KFs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-6x0c5wXyOLG2s2NlAZ4ecA-1; Tue, 31 Mar 2020 10:45:11 -0400
X-MC-Unique: 6x0c5wXyOLG2s2NlAZ4ecA-1
Received: by mail-wm1-f69.google.com with SMTP id w8so1156394wmk.5
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 07:45:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XkVeG+wiUd998qeT4qan+1QjPL9epNOUfW2FxCj8pH4=;
        b=jKt13K0JZ8VHKDXZQ48EcxLJ9s4xCj2iOREYoWAAMvFX0f1J/vCKemB/5g/Odz+olk
         6ZLbY4Cj7mcQ7HbC80lw2ymvBSt6rWi9ZSBLx5lEW2/4PeMw4vh0zZGRohIIFT3kX2J/
         9w59pyY4VAjD8HHV21lh/d8iIe3u8BwK6LBRs3lFXbW6N6oMZYFLEYnAxy8Wo1KG5C4a
         rXtjskfvvJDxdf5DenE70KsXhl1XbyZHeCrSkWaS2aVDUxyxkfleMBO2I8SsXFIV4D3n
         +v0JkBOqQfQTq/x97yLdLDnN70aEWaR0bqPaeiU7JWQfSzlPRTSYY7q6nOv2/9ojiIf3
         gmKQ==
X-Gm-Message-State: ANhLgQ3TOXNM5NbgBba3xOBGnm/IOxdLaWXc2ZoBsM251whWEkW9w9ig
        adcEIvtFF0jceodZ9XU+C1IObfSsUJXRCB4/MS6silf4bC7jMdhO14c224Fo4psR7zEbfgFxkc7
        Bskmhzv1df2L9
X-Received: by 2002:a1c:4054:: with SMTP id n81mr3643224wma.114.1585665910098;
        Tue, 31 Mar 2020 07:45:10 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvRBGuELyCrlyg1lc7SNVVMP1SITAsNZT3BZtrLyIlYKUQ2VKqqSdXcjj6kZdCsf1nf2xKUeg==
X-Received: by 2002:a1c:4054:: with SMTP id n81mr3643204wma.114.1585665909844;
        Tue, 31 Mar 2020 07:45:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b55d:5ed2:8a41:41ea? ([2001:b07:6468:f312:b55d:5ed2:8a41:41ea])
        by smtp.gmail.com with ESMTPSA id i1sm25851518wrq.89.2020.03.31.07.45.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 07:45:09 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm updates for Linux 5.7
To:     Marc Zyngier <maz@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
References: <20200331121645.388250-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cb49ff66-e943-f8fe-65bc-2e52ae36e47e@redhat.com>
Date:   Tue, 31 Mar 2020 16:45:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200331121645.388250-1-maz@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/03/20 14:16, Marc Zyngier wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git kvmarm-5.7

Pulled, thanks.

Paolo

