Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F70C25F570
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 10:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgIGIhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 04:37:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57902 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727897AbgIGIhq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 04:37:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599467864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CwemuLnaus88lanH3mTsNYl/Jmg76UyntItU5/P7Zm8=;
        b=A3zxSatOqon85V+3bRoe46eFFTucVg2pVdQIkyM2z+aUHH1peP8/lS5rNXegBLQ/SdOCvY
        43YtGm+5eIe4X6wTAOWe/DvW3NVMtHclNJpQT/DobtsrbzVcgwEP2Qv8GYyZDQN8/RoTH0
        63IAQZ/gK9DcMuoQKYmcAYHVGhYgCzw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368--9LRJxSkPbeH917QLUZ-GA-1; Mon, 07 Sep 2020 04:37:42 -0400
X-MC-Unique: -9LRJxSkPbeH917QLUZ-GA-1
Received: by mail-ed1-f72.google.com with SMTP id n25so4633380edr.13
        for <kvm@vger.kernel.org>; Mon, 07 Sep 2020 01:37:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=CwemuLnaus88lanH3mTsNYl/Jmg76UyntItU5/P7Zm8=;
        b=bNp/EqxGBcrPI2nhIDuVGAqEH+OOcUzNgmef8Gxv/f/Hq3yHX+tjIJN1/KjgZmjTYI
         QK2c75vner0Eqxw/Fohz1daO5H7oCCa7SJyRJ4viI9StVV2MKC2BISxjV7sIhu1cOokM
         /PqPmOLeYgkibi53O36obaEFzfRLjfp2Ry2eH80a9+JK/7YSFTbDqCzcA5jHs63SdDbe
         urdx+lBtl5xSKhZTekHkT1nBJAD/PUuIzPUiC05NAgVg/ZcYnIlEtZvZHPm3ywgsQa4u
         xUeaPqkrFtelZQoxYs/X5rJ+rm7+I6rdSHX0lDjSdZWT/sgdLWWa35gQuLsDz/o5xwLW
         QnTQ==
X-Gm-Message-State: AOAM532MuvjM7v1vaZdTfgL2c+YgTg7hBCDFm60OzQ4w/zuOlzFGkLZN
        MNt7xIUX2ZvKjClWFNRn6GYOWsnGMNKeKfrTFJ2zLruo0BY3vUSRqKJq60Ss7fr6BXVY2LFzTZf
        Dy1xzg+vB8YGk
X-Received: by 2002:a05:6402:1818:: with SMTP id g24mr9960759edy.332.1599467861376;
        Mon, 07 Sep 2020 01:37:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwf6ruoTyKjlZxj1US68c8E+buboCwNMLTONZ/RmwhCPXToown2lFoSSbIybdT0/0V32Hc4hQ==
X-Received: by 2002:a05:6402:1818:: with SMTP id g24mr9960745edy.332.1599467861195;
        Mon, 07 Sep 2020 01:37:41 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id w10sm14914491ejv.44.2020.09.07.01.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 01:37:40 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        linux-kernel@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH v2 0/3] KVM: x86: KVM_MEM_PCI_HOLE memory
In-Reply-To: <20200904160008.GA2206@sjchrist-ice>
References: <20200807141232.402895-1-vkuznets@redhat.com> <20200825212526.GC8235@xz-x1> <87eenlwoaa.fsf@vitty.brq.redhat.com> <20200901200021.GB3053@xz-x1> <877dtcpn9z.fsf@vitty.brq.redhat.com> <20200904061210.GA22435@sjchrist-ice> <20200904072905.vbkiq3h762fyzds6@sirius.home.kraxel.org> <20200904160008.GA2206@sjchrist-ice>
Date:   Mon, 07 Sep 2020 10:37:39 +0200
Message-ID: <874koanfsc.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Fri, Sep 04, 2020 at 09:29:05AM +0200, Gerd Hoffmann wrote:
>>   Hi,
>> 
>> > Unless I'm mistaken, microvm doesn't even support PCI, does it?
>> 
>> Correct, no pci support right now.
>> 
>> We could probably wire up ecam (arm/virt style) for pcie support, once
>> the acpi support for mictovm finally landed (we need acpi for that
>> because otherwise the kernel wouldn't find the pcie bus).
>> 
>> Question is whenever there is a good reason to do so.  Why would someone
>> prefer microvm with pcie support over q35?
>> 
>> > If all of the above is true, this can be handled by adding "pci=lastbus=0"
>> > as a guest kernel param to override its scanning of buses.  And couldn't
>> > that be done by QEMU's microvm_fix_kernel_cmdline() to make it transparent
>> > to the end user?
>> 
>> microvm_fix_kernel_cmdline() is a hack, not a solution.
>> 
>> Beside that I doubt this has much of an effect on microvm because
>> it doesn't support pcie in the first place.
>
> I am so confused.  Vitaly, can you clarify exactly what QEMU VM type this
> series is intended to help?  If this is for microvm, then why is the guest
> doing PCI scanning in the first place?  If it's for q35, why is the
> justification for microvm-like workloads?

I'm not exactly sure about the plans for particular machine types, the
intention was to use this for pcie in QEMU in general so whatever
machine type uses pcie will benefit. 

Now, it seems that we have a more sophisticated landscape. The
optimization will only make sense to speed up boot so all 'traditional'
VM types with 'traditional' firmware are out of
question. 'Container-like' VMs seem to avoid PCI for now, I'm not sure
if it's because they're in early stages of their development, because
they can get away without PCI or, actually, because of slowness at boot
(which we're trying to tackle with this feature). I'd definitely like to
hear more what people think about this.

>
> Either way, I think it makes sense explore other options before throwing
> something into KVM, e.g. modifying guest command line, adding a KVM hint,
> "fixing" QEMU, etc... 
>

Initially, this feature looked like a small and straitforward
(micro-)optimization to me: memory regions with 'PCI hole' semantics do
exist and we can speed up access to them. Ideally, I'd like to find
other 'constant memory' regions requiring fast access and come up with
an interface to create them in KVM but so far nothing interesting came
up...

-- 
Vitaly

