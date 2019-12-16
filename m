Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0C1B120A10
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 16:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbfLPPsm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 10:48:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43646 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728421AbfLPPsl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 10:48:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576511321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NK24jcfG9UBuY8rN//ofB2n49byardjTFM1RJjyjWnM=;
        b=iafF5h0bdQQH3rx3VZL5EU6/YOBWx61aG85Z32pgkJ93q/SVveI4kdUXDvEAS98CPubS5x
        vp+bCgsjFVkDWs9tQ+SmAQpSC4BU5LW6DLrFHRhCV1x0GJkz3w5oGLVaADnziqU4/CGz7P
        Jso3nIhBlVHM0uBGScvQWWHtmM+QX8E=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-rjjdNHtWN5Cl-s8hl6h9vA-1; Mon, 16 Dec 2019 10:48:39 -0500
X-MC-Unique: rjjdNHtWN5Cl-s8hl6h9vA-1
Received: by mail-wr1-f70.google.com with SMTP id l20so3931545wrc.13
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 07:48:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NK24jcfG9UBuY8rN//ofB2n49byardjTFM1RJjyjWnM=;
        b=DWTRN/SjVmPlhffQOHThasfnZfs1EQPEM6EdwnXXKfsDArqQF3VtEQ7nRY0ToMd+81
         +gYnaAcJRXSpoFFjb5lE+XywMcnnMjgnZmI4aPkwwTm5O5kcY1Wy95A5s3qoGMEFhaN/
         HVlr23GR0QYUr2rN3hHRmZrkTHA05BMQqprGZq3otMruf45esXpd4CJtsihDz6Okr2u1
         qgNyfDXKuFN5TOjwZCXJBlKLDunWx4g6Pdam/uIy9uaVnCpXdkESgHmDldmCXEyhI0I8
         x29aKJKFfAuhISbisP0tcP+I89PGXcR6JAtUMZVRR4FnIm85B8xWj5gM15FocwbjG0mS
         sepA==
X-Gm-Message-State: APjAAAX2udOmm2Qd/g8M0L383FdelVw7qPZA7VhGZCsqTKVxYJ9ImFYi
        zNIT0bNX4+Y6i+ctv/C/N20aen2UnHQjhvOve4eLFwtKhPamWfE/bIOnSMgFaQGPF0Z0/MT+8d7
        ONIn9s8+nE3yB
X-Received: by 2002:a05:600c:1003:: with SMTP id c3mr30651555wmc.120.1576511317838;
        Mon, 16 Dec 2019 07:48:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqw91mpCMXRzNUnMlilO04dgXju+Jt835qTjzpZhengzNi+a5MHx1NtPbwEpwmIXe3771MmoCQ==
X-Received: by 2002:a05:600c:1003:: with SMTP id c3mr30651518wmc.120.1576511317615;
        Mon, 16 Dec 2019 07:48:37 -0800 (PST)
Received: from [192.168.1.35] (34.red-83-42-66.dynamicip.rima-tde.net. [83.42.66.34])
        by smtp.gmail.com with ESMTPSA id 4sm21037599wmg.22.2019.12.16.07.48.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 07:48:36 -0800 (PST)
Subject: Re: [PATCH 12/12] hw/i386/pc: Move PC-machine specific declarations
 to 'pc_internal.h'
To:     Paolo Bonzini <pbonzini@redhat.com>,
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
 <90d54a3b-ae96-43ac-0f8e-268c1257f7d0@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <76162c3a-1b66-dd49-901e-7435efc21873@redhat.com>
Date:   Mon, 16 Dec 2019 16:48:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <90d54a3b-ae96-43ac-0f8e-268c1257f7d0@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/16/19 4:41 PM, Paolo Bonzini wrote:
> On 16/12/19 16:37, Philippe Mathieu-Daudé wrote:
>> On 12/15/19 10:58 AM, Michael S. Tsirkin wrote:
>>> On Fri, Dec 13, 2019 at 05:47:28PM +0100, Philippe Mathieu-Daudé wrote:
>>>> On 12/13/19 5:17 PM, Philippe Mathieu-Daudé wrote:
>>>>> Historically, QEMU started with only one X86 machine: the PC.
>>>>> The 'hw/i386/pc.h' header was used to store all X86 and PC
>>>>> declarations. Since we have now multiple machines based on the
>>>>> X86 architecture, move the PC-specific declarations in a new
>>>>> header.
>>>>> We use 'internal' in the name to explicit this header is restricted
>>>>> to the X86 architecture. Other architecture can not access it.
>>>>>
>>>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>>>>> ---
>>>>> Maybe name it 'pc_machine.h'?
>>>>
>>>> I forgot to describe here (and in the cover), what's follow after this
>>>> patch.
>>>>
>>>> Patch #13 moves PCMachineClass to
>>>>
>>>> If you ignore PCMachineState, "hw/i386/pc.h" now only contains 76
>>>> lines, and
>>>> it is easier to see what is PC machine specific, what is X86
>>>> specific, and
>>>> what is device generic (not X86 related at all):
>>>>
>>>> - GSI is common to X86 (Paolo sent [3], [6])
>>>> - IOAPIC is common to X86
>>>> - i8259 is multiarch (Paolo [2])
>>>> - PCI_HOST definitions and pc_pci_hole64_start() are X86
>>>> - pc_machine_is_smm_enabled() is X86 (Paolo sent [5])
>>>> - hpet
>>>> - tsc (Paolo sent [3])
>>>> - 3 more functions
>>>>
>>>> So we can move half of this file to "pc_internal.h" and the other to
>>>>
>>>> One problem is the Q35 MCH north bridge which directly sets the PCI
>>>> PCMachineState->bus in q35_host_realize(). This seems a QOM violation
>>>> and is
>>>> probably easily fixable.
>>>>
>>>> Maybe I can apply Paolo's patches instead of this #12, move X86-generic
>>>> declarations to "hw/i386/x86.h", and directly git-move what's left of
>>>> "hw/i386/pc.h" to "pc_internal.h".
>>>
>>> Yea that sounds a bit better.
>>
>> OK, I'll wait for Paolo's next pull get in, then continue based on that,
>> including Paolo's "x86: allow building without PC machine types" series.
>>
>> (Thanks Paolo for picking most of this series!)
> 
> FWIW I don't think kvm_i8259_init should be in sysemu/kvm.h, since it's
> x86-specific and that would be something like the same mistake already
> done with hw/i386/pc.h.

Hmm OK.
So to follow your reasoning, 
kvm_pc_gsi_handler/kvm_pc_setup_irq_routing() are x86-specific and could 
be moved out.
I'll figure that out when I rework the last patches.

