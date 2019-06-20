Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 675934CD01
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 13:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731359AbfFTLjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 07:39:03 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:37579 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbfFTLjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 07:39:02 -0400
Received: by mail-wr1-f52.google.com with SMTP id v14so2692393wrr.4
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 04:39:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=trRXLLHyis6AvlgnEySANQEBoGJgqpN6zwf2piWO27o=;
        b=enWasXAGqq+f7gIww9Kpu476cyIBt+LGVUiPY025JPwdbybLLSlnNHvFlUVOZKVwQY
         7BuvUQt7fCTrGrw8Hf7M8ZLs/sYwMtnyMNcg1DMQY1Gu76JcHykBRd46sjp6je0w1kiU
         zEb1rNLRK4b8huFkxbRrxen1xweKFkcyUDweUSpUO+ymsU9D3J6hClnppF/V0+5lGADC
         hQ+XUBNkhoiWF3rL3BX7j2Sr0ZjZG+x8XkCcV1+1sbEeK15w7Ra8AP6iDE76RuNsk/3O
         AqXfQrR/4hhinhyTWaFiI1Z26XyTPvD69wmo5odfh5xl5i+dY3l3v8bLSj+Th8vLsBER
         matQ==
X-Gm-Message-State: APjAAAUJ++A0uaWWh9MwBzXkLw/a+qPMuhVvPoZf+vABU0ZfiIx7fTDg
        8kLyvEA53HlLCNeYTXn42pQtxvNuunk=
X-Google-Smtp-Source: APXvYqxdeCsF4SekbEa5L2K2atxBBUp3jIOusAd4PtSB6TjbQL1gtxx/JbT0Vs9Sc4hlqnTGGz/Tiw==
X-Received: by 2002:adf:cd8c:: with SMTP id q12mr77757892wrj.103.1561030741150;
        Thu, 20 Jun 2019 04:39:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7822:aa18:a9d8:39ab? ([2001:b07:6468:f312:7822:aa18:a9d8:39ab])
        by smtp.gmail.com with ESMTPSA id x8sm4349824wmc.5.2019.06.20.04.38.59
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 04:39:00 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm fixes for 5.2-rc6
To:     Marc Zyngier <marc.zyngier@arm.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20190620112301.138137-1-marc.zyngier@arm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <685d31ae-b854-96f2-4bbe-5a863c291491@redhat.com>
Date:   Thu, 20 Jun 2019 13:38:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190620112301.138137-1-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/06/19 13:22, Marc Zyngier wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-for-5.2-2

Pulled, thanks.

Paolo
