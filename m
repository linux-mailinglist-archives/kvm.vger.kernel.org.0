Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19B15DB0C4
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 17:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440393AbfJQPIe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 11:08:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56616 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440389AbfJQPIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 11:08:34 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6003E693F3
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2019 15:08:33 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id a15so1118420wrr.0
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2019 08:08:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dnAgdv88fqpkJJVSXS9vM0PplR+Kvi9HfVjwm6f845g=;
        b=Hh1kCjh/xBNF5wKeCEBL4vNPLlIVCRlAotNjsjRUYozXtuBCsHu/p1k7MJc2Orh7Jb
         7+rOrTLZ213pHNtpG6G9ll5rtsqVvsum2PNF3lkG6KtmhHp+FWO+hTNJXhmBGUDL7znX
         r24DFpAcC7m8ibR1mQeuE13gcDepqD2p6Rgbb5sz8zk9T9n2cfMXqsSvA/I3l4s40mcE
         D5Qi8Q7PV3Jc9ASRlI5cgKDsXdqznhLXVoYfe0L8fZQMWPk6WwOCYhQmiVIfJTPw48fE
         KX/dW7cNYPXuOtF8NB7Cjo0o/bgVtZssUPdUjufDE3+Tpqc+zShJrwOClGXD2IHKiinK
         Ok3Q==
X-Gm-Message-State: APjAAAVNSSttioifKGEpI/IOdwfArHaFMSGN4c523R1GOFLhxNgzw2ZC
        d2iHgga7nlfAiqkjkx60H/tuLBEzkYJaz3rL+P0rz0JQfLDMa4gAXTZ8azm848vc6ozZcufXvjz
        sI0/KavPYr2J7
X-Received: by 2002:a5d:4286:: with SMTP id k6mr3362919wrq.192.1571324909954;
        Thu, 17 Oct 2019 08:08:29 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxg9IEqKvkzKtsyM3a9kmP0NDMBLbPPViQWW70uNvm8bLhPKRJHIGoGgBAFy5C9Rn1A0gAHNw==
X-Received: by 2002:a5d:4286:: with SMTP id k6mr3362889wrq.192.1571324909771;
        Thu, 17 Oct 2019 08:08:29 -0700 (PDT)
Received: from [192.168.50.32] (243.red-88-26-246.staticip.rima-tde.net. [88.26.246.243])
        by smtp.gmail.com with ESMTPSA id t6sm3551777wmf.8.2019.10.17.08.08.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Oct 2019 08:08:29 -0700 (PDT)
Subject: Re: [PATCH 02/32] hw/i386/pc: Move kvm_i8259_init() declaration to
 sysemu/kvm.h
To:     Aleksandar Markovic <aleksandar.m.mail@gmail.com>
Cc:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paul Durrant <paul@xen.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Markovic <amarkovic@wavecomp.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Richard Henderson <rth@twiddle.net>
References: <20191015162705.28087-1-philmd@redhat.com>
 <20191015162705.28087-3-philmd@redhat.com>
 <CAL1e-=iC9hR-jqTSu9c6KtgiNWFwftnTMq9W87NWFPb37hjCoA@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <46708b3d-fcef-f65c-d929-73d7c8e3f877@redhat.com>
Date:   Thu, 17 Oct 2019 17:08:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CAL1e-=iC9hR-jqTSu9c6KtgiNWFwftnTMq9W87NWFPb37hjCoA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/17/19 4:57 PM, Aleksandar Markovic wrote:
> 
> 
> On Tuesday, October 15, 2019, Philippe Mathieu-Daudé <philmd@redhat.com 
> <mailto:philmd@redhat.com>> wrote:
> 
>     Move the KVM-related call to "sysemu/kvm.h".

Maybe s/call/function declaration/

> 
>     Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com
>     <mailto:philmd@redhat.com>>
>     ---
>       include/hw/i386/pc.h | 1 -
>       include/sysemu/kvm.h | 1 +
>       2 files changed, 1 insertion(+), 1 deletion(-)
> 
> 
> Is there any other similar case in our code base?

These look appropriate:

include/hw/ppc/openpic_kvm.h:5:int kvm_openpic_connect_vcpu(DeviceState 
*d, CPUState *cs);
include/hw/timer/i8254.h:67:static inline ISADevice *kvm_pit_init(ISABus 
*bus, int base)
hw/intc/vgic_common.h:25: * kvm_arm_gic_set_irq - Send an IRQ to the 
in-kernel vGIC
hw/intc/vgic_common.h:33:void kvm_arm_gic_set_irq(uint32_t num_irq, int 
irq, int level);

although kvm_pit_init() is probably borderline.

> 
> A.
> 
>     diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
>     index 6df4f4b6fb..09e74e7764 100644
>     --- a/include/hw/i386/pc.h
>     +++ b/include/hw/i386/pc.h
>     @@ -158,7 +158,6 @@ typedef struct PCMachineClass {
> 
>       extern DeviceState *isa_pic;
>       qemu_irq *i8259_init(ISABus *bus, qemu_irq parent_irq);
>     -qemu_irq *kvm_i8259_init(ISABus *bus);
>       int pic_read_irq(DeviceState *d);
>       int pic_get_output(DeviceState *d);
> 
>     diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
>     index 9d143282bc..da8aa9f5a8 100644
>     --- a/include/sysemu/kvm.h
>     +++ b/include/sysemu/kvm.h
>     @@ -513,6 +513,7 @@ void kvm_irqchip_set_qemuirq_gsi(KVMState *s,
>     qemu_irq irq, int gsi);
>       void kvm_pc_gsi_handler(void *opaque, int n, int level);
>       void kvm_pc_setup_irq_routing(bool pci_enabled);
>       void kvm_init_irq_routing(KVMState *s);
>     +qemu_irq *kvm_i8259_init(ISABus *bus);
> 
>       /**
>        * kvm_arch_irqchip_create:
>     -- 
>     2.21.0
> 
> 
