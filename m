Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86D731F91D
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 13:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhBSMK7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 07:10:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45579 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230241AbhBSMKv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 07:10:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613736559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H0j06Q/EpAZvGEReV+kqCVRCNZpaO1eYalr07yFsh78=;
        b=cq7ft99J0WAmsQ+/sZheDmYdqHNvx1bMp1KD6ItbRE4DVM7YJl7hKOiYfVJuH0QNpvn7WZ
        vTOSoCsey/DMyvvd1TEhMuyx4W6d+k8FAQJdAhzW9zrqEyBxLTttNndjZNVpQlQUb8NJRT
        ogJVXR1F/3kcZSo6HtQFD48jG6QU900=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-VmaPh9eDOoGcai2XI86w2A-1; Fri, 19 Feb 2021 07:09:17 -0500
X-MC-Unique: VmaPh9eDOoGcai2XI86w2A-1
Received: by mail-wr1-f72.google.com with SMTP id l3so724538wrx.15
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 04:09:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H0j06Q/EpAZvGEReV+kqCVRCNZpaO1eYalr07yFsh78=;
        b=DPggsGQroS1IsuCyj0ZBJtR9MIX9XsLrIyBiXToAXoX1X60AAa512RxxRSlXer6dVz
         SJt3YsZFswoxm1XI83jXcpVXne9+tvV5Y8MkKvLFlNllr1IgxfhvChcZlJfJU9NkIlwh
         t1lui8LYPw6UgYxjAi+nZgfR9v83cqHe3hw/OTaM1c4C5KxNUHK3HtgKmzsKb/OsiEpJ
         RHxO/WLZlza+BHS9bVzPFcKNiRe+CrrM1TJ9rahUubHYhC6JzeEG51OZloKV1SE/N966
         7/eV0pfKijXy/JtG7NEs0vc+AN1+1oFGFhDQKCGxdSEK4PWnU/5zKLF643zs0ILc7LFB
         30Yg==
X-Gm-Message-State: AOAM531qHAzyCuuC1kFENbuLOlAoWgN3lyxFgwsmumIzEiI85IyG7xIc
        DO2BPv7QehOgeYK3A4yuJQX5OVUg/6RBkvGT1roKgikTbydCJZXBAZXMxlo6fj8ZoYj7m3ghm1a
        Z0t2aagf2+lsB8oIRTX4g2NwPkdiFVWxLUnTdI877jfEH5qu+FOFtJ/iTM+3FxQ==
X-Received: by 2002:adf:dc83:: with SMTP id r3mr9028697wrj.53.1613736555950;
        Fri, 19 Feb 2021 04:09:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxw/T3ZfMjUCs4n5WYSN6vBdrm/b7SQb17yJe6mqRiyTZfFmy9E3rQEwsMtWD3AILPt2bfV/g==
X-Received: by 2002:adf:dc83:: with SMTP id r3mr9028654wrj.53.1613736555703;
        Fri, 19 Feb 2021 04:09:15 -0800 (PST)
Received: from [192.168.1.36] (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id o129sm11997743wme.21.2021.02.19.04.09.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 04:09:15 -0800 (PST)
Subject: Re: [PATCH 0/7] hw/kvm: Exit gracefully when KVM is not supported
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        qemu-s390x <qemu-s390x@nongnu.org>, Greg Kurz <groug@kaod.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-arm <qemu-arm@nongnu.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Leif Lindholm <leif@nuviainc.com>,
        Alistair Francis <alistair@alistair23.me>,
        Thomas Huth <thuth@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        qemu-ppc <qemu-ppc@nongnu.org>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        kvm-devel <kvm@vger.kernel.org>
References: <20210219114428.1936109-1-philmd@redhat.com>
 <CAFEAcA_66DuWfrftpaodqBZwBhS-VOD9uH=KwvGYC_VcksVFAA@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <f0677f28-9b1a-eac6-c160-a8db13606216@redhat.com>
Date:   Fri, 19 Feb 2021 13:09:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA_66DuWfrftpaodqBZwBhS-VOD9uH=KwvGYC_VcksVFAA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/19/21 12:55 PM, Peter Maydell wrote:
> On Fri, 19 Feb 2021 at 11:44, Philippe Mathieu-Daudé <philmd@redhat.com> wrote:
>> This series aims to improve user experience by providing
>> a better error message when the user tries to enable KVM
>> on machines not supporting it.
> 
> Thanks for having a look at this; fixing the ugly assertion
> failure if you try to enable KVM for the raspi boards has
> been vaguely on my todo list but never made it up to the top...

The other one annoying was the xlnx-zcu102 when creating
the Cortex-R cores.

>> Philippe Mathieu-Daudé (7):
>>   accel/kvm: Check MachineClass kvm_type() return value
>>   hw/boards: Introduce 'kvm_supported' field to MachineClass
>>   hw/arm: Set kvm_supported for KVM-compatible machines
>>   hw/mips: Set kvm_supported for KVM-compatible machines
>>   hw/ppc: Set kvm_supported for KVM-compatible machines
>>   hw/s390x: Set kvm_supported to s390-ccw-virtio machines
>>   accel/kvm: Exit gracefully when KVM is not supported
> 
> Don't we also need to set kvm_supported for the relevant
> machine types in hw/i386 ?

Lol, clearly a parapraxis =)

I'll send it as 8/7 until I get more review comments for a
v2 (in particular on the PPC patch):

-- >8 --
diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 6329f90ef90..da895aa051d 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -1218,6 +1218,7 @@ static void x86_machine_class_init(ObjectClass
*oc, void *data)
     mc->cpu_index_to_instance_props = x86_cpu_index_to_props;
     mc->get_default_cpu_node_id = x86_get_default_cpu_node_id;
     mc->possible_cpu_arch_ids = x86_possible_cpu_arch_ids;
+    mc->kvm_supported = true;
     x86mc->compat_apic_id_mode = false;
     x86mc->save_tsc_khz = true;
     nc->nmi_monitor_handler = x86_nmi;
---

Regards,

Phil.

