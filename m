Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7551209F4
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 16:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbfLPPle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 10:41:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55220 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728376AbfLPPle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 10:41:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576510892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oeIc59QSTUoM+WKt9UthuhNY2ejH+cHhDJxHGyG7QBo=;
        b=if4TIjb/1pwmvlWy7qWjGXmj6m1ePgonCir+mNXOOcK9G7MvLKLAZ6HSrJ8z5nmXVhvpJH
        kyXCk2SEXpmhK3++r+9cV+8zXmJlaiHyGeD54NJRUIc848cJbmWd7rIZNiTHJH3y0XDtzW
        dXgEQHgxdgzCo1v/rfU7atJ9WJJmgYQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-EUncpHjPPDaJsBUUSeEt1w-1; Mon, 16 Dec 2019 10:41:31 -0500
X-MC-Unique: EUncpHjPPDaJsBUUSeEt1w-1
Received: by mail-wm1-f69.google.com with SMTP id p5so1180391wmc.4
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 07:41:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oeIc59QSTUoM+WKt9UthuhNY2ejH+cHhDJxHGyG7QBo=;
        b=jgDuLzCywtVVZJxFFEt2DlkNXk3FwdXFe8Z64yMQMERAeXT7u0m6fn5dPYeoYtprPu
         0n71aAxNGbUjDKzSMen34MxCIV0F8EPdK2rONyUGTnKjeQqWHm5nyhb+Dzwi2KHTeSI5
         AkFPEdE7K6Q1d5eMw7yb4IwuSOuNfjcFRvN1ug6tX6vyMCiJzbiXE8SOaorhNED1WlS4
         N2tApehBxNXTnVjpRahSOytLe4Kgs3nB2SS7HIUpjtwwYW8Njve4zAEfVxq44c9VSC5I
         mLRv3N1cwZGWamnunqklLarh0eZdq22IkuIulb48Ab7GEGmgFO/Q7bks+bwy5X/Q4QQ0
         MWkg==
X-Gm-Message-State: APjAAAU11eqMmyWIgj5f30shvDq1m21eaA2b6pj5akTbxCnExJBMa05H
        ChxLza8SzzpNWr2RHg/NUX5dK8ssv97EBfuaK3OU/qA630ZTZvvbAOvrgrREvH5YuL5Br1TmUTu
        VdSYycXEw/CYm
X-Received: by 2002:adf:ea42:: with SMTP id j2mr31125221wrn.270.1576510890029;
        Mon, 16 Dec 2019 07:41:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqypDXszAwMOZCzf4Ez0io31KjZBaZhfECz0yOnY8MQ2T2JBsgh1CjxeGSVWMrX9dHTIjFOC2w==
X-Received: by 2002:adf:ea42:: with SMTP id j2mr31125154wrn.270.1576510889523;
        Mon, 16 Dec 2019 07:41:29 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:cde8:2463:95a9:1d81? ([2001:b07:6468:f312:cde8:2463:95a9:1d81])
        by smtp.gmail.com with ESMTPSA id d10sm21967922wrw.64.2019.12.16.07.41.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 07:41:28 -0800 (PST)
Subject: Re: [PATCH 12/12] hw/i386/pc: Move PC-machine specific declarations
 to 'pc_internal.h'
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     qemu-devel@nongnu.org, John Snow <jsnow@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-block@nongnu.org, Richard Henderson <rth@twiddle.net>,
        xen-devel@lists.xenproject.org, Sergio Lopez <slp@redhat.com>
References: <20191213161753.8051-1-philmd@redhat.com>
 <20191213161753.8051-13-philmd@redhat.com>
 <d9792ff4-bada-fbb9-301d-aeb19826235c@redhat.com>
 <20191215045812-mutt-send-email-mst@kernel.org>
 <0d15c735-73b4-7875-ec0f-8c181508f0d4@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <90d54a3b-ae96-43ac-0f8e-268c1257f7d0@redhat.com>
Date:   Mon, 16 Dec 2019 16:41:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <0d15c735-73b4-7875-ec0f-8c181508f0d4@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/12/19 16:37, Philippe Mathieu-Daudé wrote:
> On 12/15/19 10:58 AM, Michael S. Tsirkin wrote:
>> On Fri, Dec 13, 2019 at 05:47:28PM +0100, Philippe Mathieu-Daudé wrote:
>>> On 12/13/19 5:17 PM, Philippe Mathieu-Daudé wrote:
>>>> Historically, QEMU started with only one X86 machine: the PC.
>>>> The 'hw/i386/pc.h' header was used to store all X86 and PC
>>>> declarations. Since we have now multiple machines based on the
>>>> X86 architecture, move the PC-specific declarations in a new
>>>> header.
>>>> We use 'internal' in the name to explicit this header is restricted
>>>> to the X86 architecture. Other architecture can not access it.
>>>>
>>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>>>> ---
>>>> Maybe name it 'pc_machine.h'?
>>>
>>> I forgot to describe here (and in the cover), what's follow after this
>>> patch.
>>>
>>> Patch #13 moves PCMachineClass to
>>>
>>> If you ignore PCMachineState, "hw/i386/pc.h" now only contains 76
>>> lines, and
>>> it is easier to see what is PC machine specific, what is X86
>>> specific, and
>>> what is device generic (not X86 related at all):
>>>
>>> - GSI is common to X86 (Paolo sent [3], [6])
>>> - IOAPIC is common to X86
>>> - i8259 is multiarch (Paolo [2])
>>> - PCI_HOST definitions and pc_pci_hole64_start() are X86
>>> - pc_machine_is_smm_enabled() is X86 (Paolo sent [5])
>>> - hpet
>>> - tsc (Paolo sent [3])
>>> - 3 more functions
>>>
>>> So we can move half of this file to "pc_internal.h" and the other to
>>>
>>> One problem is the Q35 MCH north bridge which directly sets the PCI
>>> PCMachineState->bus in q35_host_realize(). This seems a QOM violation
>>> and is
>>> probably easily fixable.
>>>
>>> Maybe I can apply Paolo's patches instead of this #12, move X86-generic
>>> declarations to "hw/i386/x86.h", and directly git-move what's left of
>>> "hw/i386/pc.h" to "pc_internal.h".
>>
>> Yea that sounds a bit better.
> 
> OK, I'll wait for Paolo's next pull get in, then continue based on that,
> including Paolo's "x86: allow building without PC machine types" series.
> 
> (Thanks Paolo for picking most of this series!)

FWIW I don't think kvm_i8259_init should be in sysemu/kvm.h, since it's
x86-specific and that would be something like the same mistake already
done with hw/i386/pc.h.

Paolo

