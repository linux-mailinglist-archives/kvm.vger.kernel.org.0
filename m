Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E54B7A3F3
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 11:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbfG3JXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 05:23:44 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53485 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfG3JXo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 05:23:44 -0400
Received: by mail-wm1-f66.google.com with SMTP id x15so56438926wmj.3
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 02:23:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mWMZh3wUcWsqPn07oFt7cBOH5RBu0IlIBiCukBD3l9o=;
        b=M3a/smUaIRUnUdyROGxk6MZ8E7BSx34Rcf/8dNc892qkruNP2SLXTKCSvSPlm5hdFw
         JvHkG14gHZ+8/b3iImoXOmkWyc2dGvOq0TP+3Q1t6ErFJ5KUl3nIjAhkk3nrZX04uzkq
         alIhmNASZtEVKhJ8zy3eu+5aubTulLpJe94G1zWWRC+81y28NpQfRywTdeT31evfJQov
         MSfIEx+2BdpkVscBM5eLcLQyPHl3+SUhXF5JSycce1gH8McjeTuI9w8xEsU69PSQ8FQP
         srtWQpdje3SFmKjKv1JfTNRvixjpkmW8LAF8uW1596Lf5nBLmzknWAscoh0B6tzrYjAX
         dzGA==
X-Gm-Message-State: APjAAAUtIypjlj4GQ4VP0L2/6ojuNWC8MmKgMrgyEpF6F6wDFQy2oj9c
        iULv/65fS6MN5WPHrjZcpA+dvA==
X-Google-Smtp-Source: APXvYqyjkTFE8K19/Ax2T+TuTtN5zUHOBpO/LA8yzScwVqCfBWpuwT+J9Qb8/NNoeIAkuB0HbwVZzQ==
X-Received: by 2002:a7b:cc04:: with SMTP id f4mr40005383wmh.125.1564478622449;
        Tue, 30 Jul 2019 02:23:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:29d3:6123:6d5f:2c04? ([2001:b07:6468:f312:29d3:6123:6d5f:2c04])
        by smtp.gmail.com with ESMTPSA id s10sm48654942wrt.49.2019.07.30.02.23.40
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 02:23:41 -0700 (PDT)
Subject: Re: [RFC PATCH 03/16] RISC-V: Add initial skeletal KVM support
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
 <20190729115544.17895-4-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <309b9fb3-9909-48d6-eabf-88356df4bb3b@redhat.com>
Date:   Tue, 30 Jul 2019 11:23:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190729115544.17895-4-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/19 13:56, Anup Patel wrote:
> +	case KVM_CAP_DEVICE_CTRL:
> +	case KVM_CAP_USER_MEMORY:
> +	case KVM_CAP_SYNC_MMU:

Technically KVM_CAP_SYNC_MMU should only be added after you add MMU
notifiers.

Paolo

> +	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
> +	case KVM_CAP_ONE_REG:
> +	case KVM_CAP_READONLY_MEM:
> +	case KVM_CAP_MP_STATE:
> +	case KVM_CAP_IMMEDIATE_EXIT:
> +		r = 1;
> +		break;

