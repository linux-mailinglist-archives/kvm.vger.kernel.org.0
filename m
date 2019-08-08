Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE7D85D71
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2019 10:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731226AbfHHIyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Aug 2019 04:54:46 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35548 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfHHIyq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Aug 2019 04:54:46 -0400
Received: by mail-wm1-f67.google.com with SMTP id l2so1596858wmg.0
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2019 01:54:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JAn+ykN3unM/kToCkFC1Tvb8JYP1HBbyyihRZZ3yBqQ=;
        b=uK/1ixOss+B6jlC9QTZ6tBalXH6lHAFQih1uNoQu4koNMprbg0EfYAtMXdKSiV+nSv
         7m1FQPdKjKmv9QDGjle/1yzGD4V1ADgWQa5zPl9rE4Yds0cjbCK1ErbZqhVuKAxawhFz
         Wjzz4oytk23fbrV9VEVdu285wuSMN1RpTm4LospBv/ENRrKy3x0yKbN3rVzrVrDq0riK
         aWAXg1HWS2Ex+HlXW8MKUoR1LmXk2rHvfU4BTK9/EqPfTTOmnyyn+nxAkg2sQvFBdOFf
         BhY/l+azYKp0TJcK5nRc1pvR5D39uclEECpbrYu+3hU4zP6jlyveJPjux2WAA1zBolOq
         ii5Q==
X-Gm-Message-State: APjAAAUayxIGMwtX1c60cuLy495N8+2+aDgUNnoPn6ayuB0i+sx7qcYV
        bHKE6fTA3y86qV5HrejuwH47HA==
X-Google-Smtp-Source: APXvYqy+/8dJb7VrhwMfhRjrQU4n2YvttWFHTmu72C0vK873zAhbFw4cxB+jQKcpkaP1SGPLf1vp5w==
X-Received: by 2002:a1c:2314:: with SMTP id j20mr3050248wmj.152.1565254484135;
        Thu, 08 Aug 2019 01:54:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b42d:b492:69df:ed61? ([2001:b07:6468:f312:b42d:b492:69df:ed61])
        by smtp.gmail.com with ESMTPSA id j9sm105900449wrn.81.2019.08.08.01.54.42
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 01:54:43 -0700 (PDT)
Subject: Re: [PATCH v4 00/20] KVM RISC-V Support
To:     Paul Walmsley <paul.walmsley@sifive.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190807122726.81544-1-anup.patel@wdc.com>
 <4a991aa3-154a-40b2-a37d-9ee4a4c7a2ca@redhat.com>
 <alpine.DEB.2.21.9999.1908071606560.13971@viisi.sifive.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <df0638d9-e2f4-30f5-5400-9078bf9d1f99@redhat.com>
Date:   Thu, 8 Aug 2019 10:54:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.9999.1908071606560.13971@viisi.sifive.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/08/19 01:15, Paul Walmsley wrote:
> On Wed, 7 Aug 2019, Paolo Bonzini wrote:
> 
>> On 07/08/19 14:27, Anup Patel wrote:
>>> This series adds initial KVM RISC-V support. Currently, we are able to boot
>>> RISC-V 64bit Linux Guests with multiple VCPUs.
>>
>> Looks good to me!  Still need an Acked-by from arch/riscv folks if I
>> have to merge it, otherwise they can take care of the initial merge.
> 
> Since almost all of the patches touch arch/riscv files, we'll plan to 
> merge them through the RISC-V tree.  Care to ack patch one, and send tags 
> for any other patches as you think might be appropriate?

Patch 1, 3-20:

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

In your 5.4 pull requests, it's best if you add a note that all RISC-V
KVM patches were acked and reviewed by me.  I'll also include a shoutout
about RISC-V KVM in my own pull request.

However, for Linux releases after 5.4 I would rather get pull requests
for arch/riscv/kvm from Anup and Atish without involving the RISC-V
tree.  Of course, they or I will ask for your ack, or for a topic
branch, on the occasion that something touches files outside their
maintainership area.  This is how things are already being handled for
ARM, POWER and s390 and it allows me to handle conflicts in common KVM
files before they reach Linus; these are more common than conflicts in
arch files.  If you have further questions on git and maintenance
workflows, just ask!

Paolo
