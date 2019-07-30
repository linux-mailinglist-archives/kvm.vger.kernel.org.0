Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57C3D7A345
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 10:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731052AbfG3Inx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 04:43:53 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43888 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfG3Inx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 04:43:53 -0400
Received: by mail-wr1-f66.google.com with SMTP id p13so64767156wru.10
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 01:43:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OKR3QlVurOR6Gm48332ZWWebgWYH2Zh0VKVpzZimroE=;
        b=F8K5bUZknXXDbsIwL+kFemZndE6qgwcL86Yk8SSy/q6gLsVrubxWaOb2iIdyUuboPm
         AU5piMaM1k/0tzarorAg3Ghb5rFtWBDfRxpaqMyXzIc3kZbRKNMOnAtP46DuOjVs2C2s
         geSLAheu1oOnht7vQBv0tj+h0fqQvFt+KjxiMpfqwBt+ztGnGmPTonqYFFFRWp3QLfe9
         H/D6R5jQsE5Gi+MaPkcLPGFlNgsdCvKEzXYc+rdrqDrlc+5bfW2nF+wNcn6JVsbDdIGE
         e/LQEMZivhnT7sQdKVB6uwdTJ/opk5AZvOqYrJRT16TRWMHzv0Bpea9TUGCvYKEgx4aD
         GITw==
X-Gm-Message-State: APjAAAUnws0vVRr47+MiKtsjPFnC7HVvZy9fPu6EvtTfXRdP2cv3OXT1
        UcTqRSpjQg0nuuVTJeY6np5XIQ==
X-Google-Smtp-Source: APXvYqzgTuWikIL4H6O0gthhwCoTiNJf6weUuD0qK1XMCURLTfCQZKU3zgmP7+7VU5FOQIvoP3Pgnw==
X-Received: by 2002:adf:80e6:: with SMTP id 93mr88188887wrl.298.1564476231141;
        Tue, 30 Jul 2019 01:43:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:29d3:6123:6d5f:2c04? ([2001:b07:6468:f312:29d3:6123:6d5f:2c04])
        by smtp.gmail.com with ESMTPSA id d10sm75314371wro.18.2019.07.30.01.43.49
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 01:43:50 -0700 (PDT)
Subject: Re: [RFC PATCH 06/16] RISC-V: KVM: Implement
 KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
To:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190729115544.17895-1-anup.patel@wdc.com>
 <20190729115544.17895-7-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3caa5b31-f5ed-98cd-2bdf-88d8cb837919@redhat.com>
Date:   Tue, 30 Jul 2019 10:43:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190729115544.17895-7-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/19 13:56, Anup Patel wrote:
> The PC register represents program counter whereas the MODE
> register represent VCPU privilege mode (i.e. S/U-mode).
> 

Is there any reason to include this pseudo-register instead of allowing
SSTATUS access directly in this patch (and perhaps also SEPC)?

Paolo
