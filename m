Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4D2874B9
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 11:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406068AbfHIJBB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 05:01:01 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52564 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406032AbfHIJBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 05:01:01 -0400
Received: by mail-wm1-f66.google.com with SMTP id s3so4932574wms.2
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2019 02:01:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wi2BHvM1fl4ETS2j2+rpRDcLcQQawHudgg0yb+P5OTU=;
        b=PhsIamZaM/PeDCNTWZp8nBpw4E0sU/Snmg42i1uXZeU0IO5AE2ZkyV4D1Hs+uLdZrj
         cN5VWwdbDczV57U3TZcRAt+1x7jhIQ82qNQLI92sBZk9T/NzIekPJZ+AZjZEWseYUc8K
         HUrez8JEgLorFVyGf0HYjirDSQC+zkydqC6bsZ7B5YmdHKh5Wpgzcc7IrpS1Sd4oUtjE
         HrfK71ldKBcJ/mS+kq74FodhD1noFEU47Q3Z+uXS4KlRtYHTbjF5oDP40rHnHaHJar5N
         74SxUmjLIfpmjRgqM2uIwNGRXqUPgEV34aPa9FXkLuS2EuqpEWnjzpYr25tbYJqK4jyM
         SPkQ==
X-Gm-Message-State: APjAAAV96U84Ovlhx+s0nXCrqD3HyCXSWNzevBFrIoc3j+/esCqlBf6v
        CfWFTLm2PFDJo3XgxCjkrzh8aQ==
X-Google-Smtp-Source: APXvYqyNMFM488WmLYeAfYIO7lJmFRdi3Vo5BGW5Y1C/q8YX6x7ObiHJh0qxETNqgckUmR7/YulERA==
X-Received: by 2002:a7b:cb8a:: with SMTP id m10mr9779246wmi.154.1565341259261;
        Fri, 09 Aug 2019 02:00:59 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a84sm6937335wmf.29.2019.08.09.02.00.58
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 02:00:58 -0700 (PDT)
Subject: Re: [PATCH v4 00/20] KVM RISC-V Support
To:     Anup Patel <anup@brainfault.org>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190807122726.81544-1-anup.patel@wdc.com>
 <4a991aa3-154a-40b2-a37d-9ee4a4c7a2ca@redhat.com>
 <alpine.DEB.2.21.9999.1908071606560.13971@viisi.sifive.com>
 <df0638d9-e2f4-30f5-5400-9078bf9d1f99@redhat.com>
 <alpine.DEB.2.21.9999.1908081824500.21111@viisi.sifive.com>
 <2ea0c656-bd7e-ae79-1f8e-6b60374ccc6e@redhat.com>
 <CAAhSdy1Hn69CxERttqa39wWr1-EYJtUPSG7TZnavZQqnMOHUqA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <97987944-b42f-4f51-acfb-f318b41875bc@redhat.com>
Date:   Fri, 9 Aug 2019 11:00:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAAhSdy1Hn69CxERttqa39wWr1-EYJtUPSG7TZnavZQqnMOHUqA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/19 10:22, Anup Patel wrote:
>> the L here should be kvm@vger.kernel.org.  arch/riscv/kvm/ files would
>> still match RISC-V ARCHITECTURE and therefore
>> linux-riscv@lists.infradead.org would be CCed.
> In addition to above mentioned lists, we insist of having a separate
> KVM RISC-V list which can be CCed for non-kernel patches for projects
> such as QEMU, KVMTOOL, and Libvirt. This KVM RISC-V list can also
> be used for general queries related to KVM RISCV.

You can use kvm@vger.kernel.org for that, with CCs to the other
appropriate list (qemu-devel, libvir-list, LKML, linux-riscv, etc.).
But if you want to have kvm-riscv, go ahead and ask for it.

In any case, you can send v5 with all R-b and Acked-by and a fixed
MAINTAINERS entry (listing kvm@vger for now), and Paul will apply it.
For 5.5 you can start sending patches to me, either for direct
application to the KVM tree or as pull requests.

Paolo
