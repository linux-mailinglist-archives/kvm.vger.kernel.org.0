Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E649CAF023
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 19:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394139AbfIJRJY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 13:09:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44346 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387734AbfIJRJY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 13:09:24 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EF9384E919
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 17:09:23 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id m6so134097wmf.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 10:09:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N6OgVWm3LipI6S2dhNRtI34S9LNNCSkrvYxcJwqfZsI=;
        b=Co5Dq7pzEylIro97yGjwFAQDLMD52GFJhc414wUj3d5CEDuymsY/DhvBcYe9itfKO+
         ilUEV99IlpRfwnKw0XXEk6gg+XEX6cQbBk/Qgl0xYAAe38sAWPYducQOYR3WLrle1cL4
         SX7/J4Cly8YdxmaRsffRteAJDyRW/7oemyrmHnyoqTorH3wO2h0Bb7TWxJl3MTVSJwJY
         EC8L4wltqRJ7m3kqcioKKpdBxRgCMfpNV899j5hDEq5D+tiEpw6N9rv2ZUtT8DuTfql6
         NNChMs7C3fGssZcoM+L1SX6q48Zq2ACy9i1BUjZoBUztrgjsbTDf/gqPKJAQv3gE2T+L
         POAw==
X-Gm-Message-State: APjAAAVl6bSx0MfX3WS+oBV+4QR0bPXms97799mFujjTMxbv/DuOxUs0
        GsVdrN9sEQh/16aIWH8mkKI1ZyyuD1mVFmz9Uk09wMPpBc+m0CPMbVz49JG0186h7m+friRodzp
        iqAvFtz2qQcq/
X-Received: by 2002:a7b:c922:: with SMTP id h2mr436528wml.63.1568135362533;
        Tue, 10 Sep 2019 10:09:22 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxYTqc0EPZJui9RRlRkbko3iJmJuc0qI4AmciigJIrk+NreoBnAJ7W6d/VwZU9kBdxQPOnWqg==
X-Received: by 2002:a7b:c922:: with SMTP id h2mr436510wml.63.1568135362307;
        Tue, 10 Sep 2019 10:09:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1435:25df:c911:3338? ([2001:b07:6468:f312:1435:25df:c911:3338])
        by smtp.gmail.com with ESMTPSA id q25sm383779wmq.27.2019.09.10.10.09.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2019 10:09:21 -0700 (PDT)
Subject: Re: [PATCH 00/17] KVM/arm updates for 5.4
To:     Marc Zyngier <maz@kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
References: <20190909134807.27978-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <3d822288-2517-0667-dfad-45f77a918738@redhat.com>
Date:   Tue, 10 Sep 2019 19:09:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190909134807.27978-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/09/19 15:47, Marc Zyngier wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-5.4

Pulled, thanks.

Paolo
