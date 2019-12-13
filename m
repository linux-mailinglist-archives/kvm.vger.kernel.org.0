Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCA3711E8AA
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 17:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbfLMQre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 11:47:34 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47772 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728102AbfLMQre (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 11:47:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576255653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xx4QpyhPJ7ddFApM5tN1aOYUoAAOoJoWqAv5YuUSmrQ=;
        b=CgVrk7AmKrZ3TesMgXwv4LjjQvZiqygXyJ2LW33tCzXjIPos/htJWlzZr4uP74/g45YF94
        OtD3CjptlZRS+jni6AC/7X284pxl7DYA6sLKMpDHpBQ2EVdn+NIBK3ZHY9X6HFPGzBiGry
        9NAj5fmagyxiOG0rJYizhcrVDpH28VE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-H15Gj9zDMRywur4bMTnjSw-1; Fri, 13 Dec 2019 11:47:32 -0500
X-MC-Unique: H15Gj9zDMRywur4bMTnjSw-1
Received: by mail-wm1-f70.google.com with SMTP id o24so51128wmh.0
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 08:47:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xx4QpyhPJ7ddFApM5tN1aOYUoAAOoJoWqAv5YuUSmrQ=;
        b=jpadeDSw3fT9VpklLcCDK/D/9qArntostvLa31ppjOB7cbZLfDAs784Dqu5KJK0+nf
         AsTFHmWM5HlZrQr5lrBF+r1pinPpJmp5KdTOanPM5lLtldKw621U+XfFLqRi7rU5yJ3i
         kfwhkSbAl6Kzl9WCyR3dKbryDdTapAAPP7sBU2jCm6d3ZQuWzUP8CUx3pW3c1CH8Z6jZ
         IgWqAberO4yH+y00BEGIK/TDVcZXm9zXrdA+FcSDOLkBsRU8WlR1kh7A+KATTYVwXwqF
         C0FAV851E+Moh2ywjOHCHVzxGZO7ME1RJPbxlMiQALUaBm9FUZi+YICSzMtmuR+aTvu+
         8JjA==
X-Gm-Message-State: APjAAAUkggOcegrLFvRuia7LPHLwJhp2E2pnZeNycK3nA1Beo/n3izky
        5gDF3Momq5s4grJSA2AYkg6sjoO/1zKTyXW2NrRCzVAgIhRV/dsPGL0+fM+wjLB3sBBzo+xTZs6
        X586VBwJEEkTr
X-Received: by 2002:a05:600c:224d:: with SMTP id a13mr14931585wmm.57.1576255651300;
        Fri, 13 Dec 2019 08:47:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqzyANQJHgFGh+Kl0t/Tp4kzuWcPKmbHesl5SsB4LGdPrxk9Inysuhlbrs/E4yJYrUC92LmqzA==
X-Received: by 2002:a05:600c:224d:: with SMTP id a13mr14931547wmm.57.1576255651048;
        Fri, 13 Dec 2019 08:47:31 -0800 (PST)
Received: from [192.168.1.35] (34.red-83-42-66.dynamicip.rima-tde.net. [83.42.66.34])
        by smtp.gmail.com with ESMTPSA id p17sm10589868wrx.20.2019.12.13.08.47.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2019 08:47:30 -0800 (PST)
Subject: Re: [PATCH 12/12] hw/i386/pc: Move PC-machine specific declarations
 to 'pc_internal.h'
To:     qemu-devel@nongnu.org
Cc:     John Snow <jsnow@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <d9792ff4-bada-fbb9-301d-aeb19826235c@redhat.com>
Date:   Fri, 13 Dec 2019 17:47:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191213161753.8051-13-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/19 5:17 PM, Philippe Mathieu-Daudé wrote:
> Historically, QEMU started with only one X86 machine: the PC.
> The 'hw/i386/pc.h' header was used to store all X86 and PC
> declarations. Since we have now multiple machines based on the
> X86 architecture, move the PC-specific declarations in a new
> header.
> We use 'internal' in the name to explicit this header is restricted
> to the X86 architecture. Other architecture can not access it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
> Maybe name it 'pc_machine.h'?

I forgot to describe here (and in the cover), what's follow after this 
patch.

Patch #13 moves PCMachineClass to

If you ignore PCMachineState, "hw/i386/pc.h" now only contains 76 lines, 
and it is easier to see what is PC machine specific, what is X86 
specific, and what is device generic (not X86 related at all):

- GSI is common to X86 (Paolo sent [3], [6])
- IOAPIC is common to X86
- i8259 is multiarch (Paolo [2])
- PCI_HOST definitions and pc_pci_hole64_start() are X86
- pc_machine_is_smm_enabled() is X86 (Paolo sent [5])
- hpet
- tsc (Paolo sent [3])
- 3 more functions

So we can move half of this file to "pc_internal.h" and the other to

One problem is the Q35 MCH north bridge which directly sets the PCI 
PCMachineState->bus in q35_host_realize(). This seems a QOM violation 
and is probably easily fixable.

Maybe I can apply Paolo's patches instead of this #12, move X86-generic 
declarations to "hw/i386/x86.h", and directly git-move what's left of 
"hw/i386/pc.h" to "pc_internal.h".

[3] https://www.mail-archive.com/qemu-devel@nongnu.org/msg664627.html
[2] https://www.mail-archive.com/qemu-devel@nongnu.org/msg664765.html
[5] https://www.mail-archive.com/qemu-devel@nongnu.org/msg664754.html
[6] https://www.mail-archive.com/qemu-devel@nongnu.org/msg664766.html

> ---
>   hw/i386/pc_internal.h | 144 ++++++++++++++++++++++++++++++++++++++++++
>   include/hw/i386/pc.h  | 128 -------------------------------------
>   hw/i386/acpi-build.c  |   1 +
>   hw/i386/pc.c          |   1 +
>   hw/i386/pc_piix.c     |   1 +
>   hw/i386/pc_q35.c      |   1 +
>   hw/i386/pc_sysfw.c    |   1 +
>   hw/i386/xen/xen-hvm.c |   1 +
>   8 files changed, 150 insertions(+), 128 deletions(-)
>   create mode 100644 hw/i386/pc_internal.h

