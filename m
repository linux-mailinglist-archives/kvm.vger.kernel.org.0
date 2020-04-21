Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5DB1B320D
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 23:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgDUVqq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 17:46:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23265 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726055AbgDUVqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 17:46:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587505604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r6wLjzLOuj6c5+cLaZodMgIgcvGXF3pN8d/Rer3Rx78=;
        b=Bk+SEIM/vgFqTBikjTQB1nB0xVqJXmXoJE+4bqSbUsLyVEqQI6UJCiBKOPJpSfzayfgxob
        m/pWzg+zQnnlbvM2kmmHcfHLMq6wXTFJsZm2MSQ7ZmXmzvWYn1p3+ovp6C5EblLXzV98yE
        N9hIBYCrgUG9ZUEQfYgwA25Jhs1yw10=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-LEM7nvuyNK2TfAYVLZQ4Og-1; Tue, 21 Apr 2020 17:46:42 -0400
X-MC-Unique: LEM7nvuyNK2TfAYVLZQ4Og-1
Received: by mail-wm1-f69.google.com with SMTP id j5so20192wmi.4
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 14:46:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r6wLjzLOuj6c5+cLaZodMgIgcvGXF3pN8d/Rer3Rx78=;
        b=PkiZhFw1qMoTrNoazqH4Scf7n+EHKNnoizBK1AleR113yHRkWNFsHgIbKYvt+wfY13
         rFFV2cvfi08Lk2VzJWX9rCeMjfvHH0e6oGMa4woh+pkEoKg/g6Z8W6AhmUTnZFh+fkua
         WMeCqMmsBzKn1mDmHAKz+nY01ST4z7CBzgRv8Vy1FCXBrxN+tnbfOzX1NI0dW98sriiJ
         XV3JP4rsm79QQxxkJjMJxv593m8XNggmMozyUD7gC8+G1em4zPTdoPuFdI1gGdazyBFK
         BPcvzCOoFLYe7PpmeyB6JskZUCirfIYccCeg6ZP0hUnegZ0YvjY//jMYa1bSOw2BKxoS
         x1Aw==
X-Gm-Message-State: AGi0PuakvlAi1mH1qjucfpbDNRaPMjYOZDdWwukQEOUh4LpBAzytEveW
        b6w2zCIPEcd7oI4vReLuQPQPOPNJh5C8y7tbwj+VZmQJfrx1NGkFRU6Bmn0XNlEoNjr0jRwHzmn
        e7NQi9S3Lr6O3
X-Received: by 2002:a5d:49c7:: with SMTP id t7mr24817052wrs.22.1587505601034;
        Tue, 21 Apr 2020 14:46:41 -0700 (PDT)
X-Google-Smtp-Source: APiQypJuj94xnF2FaQAuHLXoLoDejHCjWzP12FOd9j0iSkP/LXHBmTsnLGv5NL3YplxjISyisn1r+g==
X-Received: by 2002:a5d:49c7:: with SMTP id t7mr24817028wrs.22.1587505600785;
        Tue, 21 Apr 2020 14:46:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id v1sm5314818wrv.19.2020.04.21.14.46.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 14:46:40 -0700 (PDT)
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
To:     Andra Paraschiv <andraprs@amazon.com>, linux-kernel@vger.kernel.org
Cc:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>, Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
References: <20200421184150.68011-1-andraprs@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
Date:   Tue, 21 Apr 2020 23:46:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200421184150.68011-1-andraprs@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/04/20 20:41, Andra Paraschiv wrote:
> An enclave communicates with the primary VM via a local communication channel,
> using virtio-vsock [2]. An enclave does not have a disk or a network device
> attached.

Is it possible to have a sample of this in the samples/ directory?

I am interested especially in:

- the initial CPU state: CPL0 vs. CPL3, initial program counter, etc.

- the communication channel; does the enclave see the usual local APIC
and IOAPIC interfaces in order to get interrupts from virtio-vsock, and
where is the virtio-vsock device (virtio-mmio I suppose) placed in memory?

- what the enclave is allowed to do: can it change privilege levels,
what happens if the enclave performs an access to nonexistent memory, etc.

- whether there are special hypercall interfaces for the enclave

> The proposed solution is following the KVM model and uses the KVM API to be able
> to create and set resources for enclaves. An additional ioctl command, besides
> the ones provided by KVM, is used to start an enclave and setup the addressing
> for the communication channel and an enclave unique id.

Reusing some KVM ioctls is definitely a good idea, but I wouldn't really
say it's the KVM API since the VCPU file descriptor is basically non
functional (without KVM_RUN and mmap it's not really the KVM API).

Paolo

