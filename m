Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C13FDD890D
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 09:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729231AbfJPHKl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 03:10:41 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45064 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726338AbfJPHKl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Oct 2019 03:10:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571209839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=atkKBE+OhbQ4pOII4N38Iv93WpWN9YTy8W/dwEibJvo=;
        b=elQEcT/099l2pbtkjoF60EiwgFqew3f+R41jufuODxwgDcSDQ7uRR0W+hTNUzM0LoUbSrP
        0EjZC74txkHOHgDqskmVQe8prlets7sCgYg4m/a6WCCrr7SkNp6IRPtzZ0+xLkxjn1kRDj
        Z+D119RXW8nQb9XWiay9xj6nvRSSBys=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-dPlCwkYFNaSPRzUTlEkwXg-1; Wed, 16 Oct 2019 03:10:38 -0400
Received: by mail-wm1-f71.google.com with SMTP id 190so758312wme.4
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 00:10:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4KmZ9tmpXlk46xmJUogDKwLZzCFViFGNnmxsywrkhr4=;
        b=O6VsUcHq1NqVOGL3nBQ0FZNIQnAzylDhQUe+NQnZinoxRSry655Lr0dZO+YbJgFXte
         3kMJkiCUlBEtgWKRGyFLJPf2H54f4QlhaSmwKuecFDklVgINeZp98jsnDucXfmBzTf5g
         7AQ9EjMDF/2pf/6obWC2DPBWTL//YUh+BmXDb22O1sJXeaVuwUA+5DXKGiKY/8j/pFgs
         359EbJGEF6r8Fk3DlXXwEh8kn6OfUQqzdCkk6NRKUlmW5gjUvhWa+airjtohYulogKhS
         OF8trsBWPyUQaWoLYzWP2UDrz+ZKGeqFANIhe7sl79OsqyqSox8Mn9M39ZF3ypk2VCfP
         6moQ==
X-Gm-Message-State: APjAAAUboVlTrt6vyhFL7ZJLo36pSSZsO2Gip05hVirVHmnYZx5f2gs+
        IxqRl7FcHXD24akHMgAZuSl97n8ZisexPItbKslQn34j95gKjdj1XKcDwDvIM6JKhH/Dv9RBii/
        xLp0HvnxYKhpb
X-Received: by 2002:adf:cc8e:: with SMTP id p14mr1344884wrj.301.1571209837021;
        Wed, 16 Oct 2019 00:10:37 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyMkepD45un/zag7gKTc+lFp9N0/XMwW6mC1kmyUCBXgrwtYogoeP8y+AmUc8Y9iVF713Y8IQ==
X-Received: by 2002:adf:cc8e:: with SMTP id p14mr1344860wrj.301.1571209836713;
        Wed, 16 Oct 2019 00:10:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e? ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
        by smtp.gmail.com with ESMTPSA id z189sm2973051wmc.25.2019.10.16.00.10.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 00:10:36 -0700 (PDT)
Subject: Re: [PATCH v5 5/6] ptp: arm64: Enable ptp_kvm for arm64
To:     "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>,
        nd <nd@arm.com>
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-6-jianyong.wu@arm.com>
 <da62c327-9402-9a5c-d694-c1a4378822e0@redhat.com>
 <HE1PR0801MB167654440A67AF072E28FFFDF4920@HE1PR0801MB1676.eurprd08.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6e9bfd40-4715-74b3-b5d4-fc49329bed24@redhat.com>
Date:   Wed, 16 Oct 2019 09:10:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <HE1PR0801MB167654440A67AF072E28FFFDF4920@HE1PR0801MB1676.eurprd08.prod.outlook.com>
Content-Language: en-US
X-MC-Unique: dPlCwkYFNaSPRzUTlEkwXg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/19 05:52, Jianyong Wu (Arm Technology China) wrote:
> This func used only by kvm_arch_ptp_get_clock and nothing to do with
> kvm_arch_ptp_get_clock_fn. Also it can be merged into
> kvm_arch_ptp_get_clock.
>=20

Your patches also have no user for kvm_arch_ptp_get_clock, so you can
remove it.

Paolo

