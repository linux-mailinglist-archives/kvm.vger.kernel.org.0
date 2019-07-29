Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBBE879548
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 21:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389217AbfG2Tks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 15:40:48 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42790 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389210AbfG2Tkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 15:40:46 -0400
Received: by mail-wr1-f67.google.com with SMTP id x1so13217975wrr.9
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2019 12:40:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZgugjlZTeEEE0y6ZY8Fe7n+SwxVvrWXZp+43yEbz1Lw=;
        b=GXELcH+CpZdeKwFlhU5IDSFMoJDV8z28f+5gC623DpMkNkvIr5Iw1Xr9INtyXIZHmX
         2dL5vwb8U2aVC4cbhehU3MH8oH6dxzU9f0nH7BKPYtmGsWvFXc1qbLLWu8do3qcN45q2
         RdfB8tXAuHVy9yq4n/75LQo4WgOC7wxidi28xGoML01AHUmvHos30qQVHB7VBdDwdvX8
         YrGdAS9eI95/O1K6RzvxG737hmHcIYZ6bct4iTJlrQtHjAlV8pfdN5mssT9wrw+zaFjS
         JVSFJ5Qiwq4o8wu1+kqd7m91aW6cozp5gybfyai64eeqjh025AMzDZtvq4E+fkgP+Ct9
         0BeA==
X-Gm-Message-State: APjAAAVzboc8BhLc1m39FJOzpFHUJWqj1T88+eNSgaeTFxj4wRTj7KOO
        /FSp9t/IOvM1QdjkBoMPrvxB7A==
X-Google-Smtp-Source: APXvYqztxhuL0SbDbz8vPIEpjg5swquwVED7MQQUtvXwCf8LmsIfLWHOThEiOBoLm/Omt/wkMP0pWw==
X-Received: by 2002:adf:ce82:: with SMTP id r2mr44441848wrn.223.1564429244726;
        Mon, 29 Jul 2019 12:40:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:29d3:6123:6d5f:2c04? ([2001:b07:6468:f312:29d3:6123:6d5f:2c04])
        by smtp.gmail.com with ESMTPSA id v16sm46139077wrn.28.2019.07.29.12.40.43
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 12:40:43 -0700 (PDT)
Subject: Re: [RFC PATCH 15/16] RISC-V: KVM: Add SBI v0.1 support
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
 <20190729115544.17895-16-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b461c82f-960a-306e-b76b-f2c329cabf21@redhat.com>
Date:   Mon, 29 Jul 2019 21:40:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190729115544.17895-16-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/19 13:57, Anup Patel wrote:
> +	csr_write(CSR_HSTATUS, vcpu->arch.guest_context.hstatus | HSTATUS_SPRV);
> +	csr_write(CSR_SSTATUS, vcpu->arch.guest_context.sstatus);
> +	val = *addr;

What happens if this load faults?

Paolo
