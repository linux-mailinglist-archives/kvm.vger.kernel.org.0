Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115661209CF
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 16:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbfLPPiG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 10:38:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46215 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728234AbfLPPiG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 10:38:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576510685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0QV9lNd6bej2B81hrPU/3K56BtQwJme8N81caAcyeHo=;
        b=UIlCUvy85M8zLDP7CW/jwh84xYqBqIxQPG39nsnxjxNMgRoQ1h8c7m065F/I2FnIAi/+SF
        Z2u0ZI4r64kpCa2SsJXxMdKf2K/agGw3of9vvmg7vu6HLf3qxbITaZZpPfcvkTZ8Qdnx+a
        vPG1LK6u000C8QRW3ExU6gy/qEsa+LY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-hrJ5ZL0gMvuKlAfmRKZqSA-1; Mon, 16 Dec 2019 10:38:03 -0500
X-MC-Unique: hrJ5ZL0gMvuKlAfmRKZqSA-1
Received: by mail-wr1-f71.google.com with SMTP id w6so3887027wrm.16
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 07:38:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0QV9lNd6bej2B81hrPU/3K56BtQwJme8N81caAcyeHo=;
        b=E+1KoH44y2p1IcuQUwziwUBG6NLj7otoiV0scbcMbUpr7aW0UQe5qFPTIwV/mkEb0h
         MD84uYOXOqovlSQTxnb3j6ZDVSDrabs6MRr3wWxpV7N2waap+YWsdgLLWNONTAvIHMA6
         dygjXphMUWjexW+Qy1p95yYdGrxvRV6GLlXcRoprAbFWMS9pAJbW57B6LG6uT27ad9Sn
         FdUeXGYcRfs99j5qKI1akgoloE93jpeqpZtfhlVk0ktsN7HV2Wmuol+lR8jn8vBg9B9q
         jQDWNRxxL+1/9C1Opd6FrulxVijjCIaKga9SQxERLAEZDHDeHL0LlGX37l9bQfg6xZsx
         rU1g==
X-Gm-Message-State: APjAAAWdDyHr4dDkpdVkoXVo6cJrYCaIQO58ws+Tw2rLfh6E0NOybUcz
        rkyTysZNGhOnNGjIY1Olli09mRRSiow16LFt+Jtybg0vb7ZZfx+HGeMtLZvBH83QAOg4iwtpOJV
        K5gnS03bcFP/k
X-Received: by 2002:a5d:4e0a:: with SMTP id p10mr30633308wrt.229.1576510681812;
        Mon, 16 Dec 2019 07:38:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqxVFqYNqlSPAPVs60swdvhy63zZvYx1UQ4uo3h1+kQkDGxRT/1HmtmODXpIzHE45ZzE9ki/sw==
X-Received: by 2002:a5d:4e0a:: with SMTP id p10mr30633290wrt.229.1576510681631;
        Mon, 16 Dec 2019 07:38:01 -0800 (PST)
Received: from [192.168.1.35] (34.red-83-42-66.dynamicip.rima-tde.net. [83.42.66.34])
        by smtp.gmail.com with ESMTPSA id f1sm21818222wro.85.2019.12.16.07.38.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 07:38:00 -0800 (PST)
Subject: Re: [PATCH 12/12] hw/i386/pc: Move PC-machine specific declarations
 to 'pc_internal.h'
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     qemu-devel@nongnu.org, John Snow <jsnow@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-block@nongnu.org, Richard Henderson <rth@twiddle.net>,
        xen-devel@lists.xenproject.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sergio Lopez <slp@redhat.com>
References: <20191213161753.8051-1-philmd@redhat.com>
 <20191213161753.8051-13-philmd@redhat.com>
 <d9792ff4-bada-fbb9-301d-aeb19826235c@redhat.com>
 <20191215045812-mutt-send-email-mst@kernel.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <0d15c735-73b4-7875-ec0f-8c181508f0d4@redhat.com>
Date:   Mon, 16 Dec 2019 16:37:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191215045812-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/19 10:58 AM, Michael S. Tsirkin wrote:
> On Fri, Dec 13, 2019 at 05:47:28PM +0100, Philippe Mathieu-Daudé wrote:
>> On 12/13/19 5:17 PM, Philippe Mathieu-Daudé wrote:
>>> Historically, QEMU started with only one X86 machine: the PC.
>>> The 'hw/i386/pc.h' header was used to store all X86 and PC
>>> declarations. Since we have now multiple machines based on the
>>> X86 architecture, move the PC-specific declarations in a new
>>> header.
>>> We use 'internal' in the name to explicit this header is restricted
>>> to the X86 architecture. Other architecture can not access it.
>>>
>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>>> ---
>>> Maybe name it 'pc_machine.h'?
>>
>> I forgot to describe here (and in the cover), what's follow after this
>> patch.
>>
>> Patch #13 moves PCMachineClass to
>>
>> If you ignore PCMachineState, "hw/i386/pc.h" now only contains 76 lines, and
>> it is easier to see what is PC machine specific, what is X86 specific, and
>> what is device generic (not X86 related at all):
>>
>> - GSI is common to X86 (Paolo sent [3], [6])
>> - IOAPIC is common to X86
>> - i8259 is multiarch (Paolo [2])
>> - PCI_HOST definitions and pc_pci_hole64_start() are X86
>> - pc_machine_is_smm_enabled() is X86 (Paolo sent [5])
>> - hpet
>> - tsc (Paolo sent [3])
>> - 3 more functions
>>
>> So we can move half of this file to "pc_internal.h" and the other to
>>
>> One problem is the Q35 MCH north bridge which directly sets the PCI
>> PCMachineState->bus in q35_host_realize(). This seems a QOM violation and is
>> probably easily fixable.
>>
>> Maybe I can apply Paolo's patches instead of this #12, move X86-generic
>> declarations to "hw/i386/x86.h", and directly git-move what's left of
>> "hw/i386/pc.h" to "pc_internal.h".
> 
> Yea that sounds a bit better.

OK, I'll wait for Paolo's next pull get in, then continue based on that, 
including Paolo's "x86: allow building without PC machine types" series.

(Thanks Paolo for picking most of this series!)

