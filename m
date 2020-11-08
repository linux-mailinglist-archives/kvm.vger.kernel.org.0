Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC032AAA3A
	for <lists+kvm@lfdr.de>; Sun,  8 Nov 2020 10:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgKHJQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 04:16:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52860 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726099AbgKHJQJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 8 Nov 2020 04:16:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604826967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SS3cBUczOiZ0kxVvdSs3nbCa4DdNThWqGly4Rc/m4Ac=;
        b=fF9uVxXHnLok2txoMh62BHCnElvg1cOCbisWgTZPEheCWZKa+CqBhTtYKEcseLpktLGoRj
        IdiDPImpX/+9gjtToZ632PwiLEbIu3VU2Gg1GR+vY56JFBYXP/MetaXm6caJLpXYvL0IIy
        R97E5l8ornQOlntdpJUoAO81Y0P9Xqw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-YNVB7eDIO3utW-ZFuZKh-w-1; Sun, 08 Nov 2020 04:16:05 -0500
X-MC-Unique: YNVB7eDIO3utW-ZFuZKh-w-1
Received: by mail-wr1-f70.google.com with SMTP id p16so123909wrx.4
        for <kvm@vger.kernel.org>; Sun, 08 Nov 2020 01:16:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SS3cBUczOiZ0kxVvdSs3nbCa4DdNThWqGly4Rc/m4Ac=;
        b=NcZbP3Fa4RtDtw9LmPFGD/6r/mxgYjCFXSWw29Y2MD7sN0UUTTmBP/sixHbz8k1iHt
         VU5s9HlTYFiU8as7fyLcGHI6RYK7x3FctNH6ExFGbNiBaQV9T3hDe8rGKdFEvqClwLLe
         /HOfh4aJEXNMJmjcWz620uivqUrXeOUynUl7yASPEJaGzbrrlsNIkXJ3kVlG+UujPSgC
         Ih1jHbuLt12hDsLsZV3m6yx2+wzeoCZlBV8/Aup6vpdyHsHtMy8P6lBdKcEdDuDAAvWE
         IFSWEWG+5TyLot3mkMYoq5vjW+vuVwFCsFi06lVPvm+rpZTYNIOiUOtM+yUlkVc4YGhH
         uQtQ==
X-Gm-Message-State: AOAM533F2UjyKOP0L9FMu0pFAhUKd28jRBqnx//VGUm1hHoT+maFHy12
        5A926rM84lIskZrsXtmdJKKAikX+PyQqQdW8WAhhK6Wl/tcIPQeOfhWs7J8uOjUDW7D8OH6uKi/
        neWToMd47fWl8
X-Received: by 2002:a1c:46c5:: with SMTP id t188mr1930931wma.68.1604826964677;
        Sun, 08 Nov 2020 01:16:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyJtVpw0lItyk5nAqwy53PgMbIuyxbDRi61GlvxwAVi7fIQ1ppjWqQ19XUasxBrInYsiNjlCA==
X-Received: by 2002:a1c:46c5:: with SMTP id t188mr1930905wma.68.1604826964432;
        Sun, 08 Nov 2020 01:16:04 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id x81sm9483907wmg.5.2020.11.08.01.16.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Nov 2020 01:16:03 -0800 (PST)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.10, take #2
To:     Marc Zyngier <maz@kernel.org>
Cc:     Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        =?UTF-8?B?5byg5Lic5pet?= <xu910121@sina.com>,
        dave.martin@arm.com, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20201106164416.326787-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b4771aac-7ef6-06b9-0d2d-19927c787ed3@redhat.com>
Date:   Sun, 8 Nov 2020 10:15:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201106164416.326787-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/11/20 17:44, Marc Zyngier wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.10-2

Pulled, thanks.

Paolo

