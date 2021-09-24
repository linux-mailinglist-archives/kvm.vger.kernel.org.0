Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE1B416FE1
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 12:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245524AbhIXKF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 06:05:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42822 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245370AbhIXKF5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 06:05:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632477864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5I8+/PBpXab5XEShtr8cIKRG6bCQ0vQu8F83jY5+nd0=;
        b=jHyTVDSRI0qWg5kaEnOqss/k/xhJaZGrpWUtmGjxTbB0BEo6FQ67wqrs2G/9ZUbT0oBp47
        y1KOnJe6Uht+6BS9FTCyd/lfu+Jytd+HaDAx7n3T3JjfZnN7UXOKRvL9RQhbEsarqEeUBW
        qPTJX+VWxh8cg6J18VYOZdsZ6/Bsm4Q=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556--NFPgzoENTWTGHYw5EL4Yg-1; Fri, 24 Sep 2021 06:04:23 -0400
X-MC-Unique: -NFPgzoENTWTGHYw5EL4Yg-1
Received: by mail-ed1-f71.google.com with SMTP id e7-20020aa7d7c7000000b003d3e6df477cso9657636eds.20
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 03:04:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5I8+/PBpXab5XEShtr8cIKRG6bCQ0vQu8F83jY5+nd0=;
        b=K3BxtHqW/ZCRXXP440XKWZFo1i7dchxZVJdu8G1cpaOEXILC0ZGB17e9XDHSHWU8bj
         LdTvt1YgDEB6fTxFoH++2zn0viFUC3pQgYRTYwl90JJRP54L9xNQoWjDu8cyc3t1tN+O
         Zjg+eQa4Dpf8RYap9JpKkrugAZ+JZlkul1yyVmSmGBTSeHnZZqXgXiEqTozVhevV+6Zo
         B5wqNZRP3aaVy9ZZbD3BE9+EC1eLL39rgNBDLcpSIoMHSNAGBVxsMEbAVWwhTHhA0b+j
         xhDB8muovQRZPFWWhrsHesH46GnPcKho0QO1OkDUTUIvvR0f7HYVddoAX15IUwKFB0d3
         YEBQ==
X-Gm-Message-State: AOAM531TllJK+pmhvGB7AbgxsXQx8LD73QSRECRFjK5rtplq9euaJWVW
        DulhMaN8EnteID0nryhp8GQm9kuVDpUs7mnieQOfjFgegk9SepUh4jxWo+SWctKfGnkTEIaI4/8
        w/qZSaO1i9NI9
X-Received: by 2002:a05:6402:1508:: with SMTP id f8mr3986180edw.255.1632477862133;
        Fri, 24 Sep 2021 03:04:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygeZyMT7VCjV6ItZHI7JAJSC8GZk65ZQmI8K8y7NN6G9PnXBLJoj/cYhKBOivcf2S9KwSbeA==
X-Received: by 2002:a05:6402:1508:: with SMTP id f8mr3986156edw.255.1632477861926;
        Fri, 24 Sep 2021 03:04:21 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r2sm5453064edo.59.2021.09.24.03.04.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 03:04:21 -0700 (PDT)
Message-ID: <43cecad3-f144-1f5c-4106-911732b906c7@redhat.com>
Date:   Fri, 24 Sep 2021 12:04:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.15, take #1
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     David Brazdil <dbrazdil@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
References: <20210924083829.2766529-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210924083829.2766529-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/21 10:38, Marc Zyngier wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.15-1

Pulled, thanks.

Paolo

