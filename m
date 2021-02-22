Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA74321A77
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 15:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhBVOhB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 09:37:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20305 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231213AbhBVOgg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 09:36:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614004506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ROXc4pPESl2hnVPAmTj87jG8Y89YLot+XFk/YVIBdHE=;
        b=a6FzvpREOb71ocXIkgvwd2O0RdCvzc7NjONwc2wjl7AKb3iASPNYLYjWr6wHD3Qf3y/SKY
        FRVYf0LogT38iAbeUaZXk1h1zeiuVdrFjhLxehlgaquV9EmWJDbfqhg7DGt4XDp/TPITG5
        piDuKCsHy01aSH+/vJ5oWU7+fhzyTxc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-xH4wBsufNEeheuIwgbKevw-1; Mon, 22 Feb 2021 09:35:04 -0500
X-MC-Unique: xH4wBsufNEeheuIwgbKevw-1
Received: by mail-ej1-f70.google.com with SMTP id g7so1256057ejd.16
        for <kvm@vger.kernel.org>; Mon, 22 Feb 2021 06:35:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ROXc4pPESl2hnVPAmTj87jG8Y89YLot+XFk/YVIBdHE=;
        b=h46tyZTb/JlgXiF0JDJfKf6NpJRG0Rrr91I/4qUTlrj4R+gHXJ5LeXYIqphOX0FfH6
         aLSa2Qq0+0hAaq50jBzBj0cOF7YSE3AAZYeZw1m4IWg9a1cLkv7HqR/YvD5D/HpgK25K
         ZY56TChwQOwzXHE5yh7SRBcMcCXob6VDHtF/FvHAlujZ/k4G4QFKAaw6U9tb4Jul+/M4
         fwpgJ+M0m5ITP2J+ZdfVkUeLxgTLQse1B21Rur7YE3VuHtawIeamIO4TtnFJECfS9Tvq
         Eczb6+6MFYeQcYgE7MObO79298fkpRV0YrMszQ6D1wS+Xm9xNBBiNsAxsXnn36o5sCUi
         uvkg==
X-Gm-Message-State: AOAM533WwXNrA2QWOC4J5ZCgu3sLfrbR5WGUOwfHt9UVixxAZKfINByS
        piI3uy5ekwEgJFCOYdcaFlEu3yxlkiyV0mixw32nqHvjNnOJn8HJvo2n2Ka841VCJASy7gkX9sl
        Mq5eg07mQHUoT
X-Received: by 2002:a50:9dc9:: with SMTP id l9mr22865678edk.377.1614004503646;
        Mon, 22 Feb 2021 06:35:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyumDD7RCrt3aWNrG+469eebI8wUrsStbqcQO2s6zYWdcqMS9H6mt2qeXwl0MrBf/vG1e+wdw==
X-Received: by 2002:a50:9dc9:: with SMTP id l9mr22865651edk.377.1614004503527;
        Mon, 22 Feb 2021 06:35:03 -0800 (PST)
Received: from [192.168.1.36] (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id s14sm10457606ejf.47.2021.02.22.06.35.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 06:35:02 -0800 (PST)
Subject: Re: [PATCH 0/2] sysemu: Let VMChangeStateHandler take boolean
 'running' argument
To:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>, Greg Kurz <groug@kaod.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-trivial@nongnu.org,
        Amit Shah <amit@kernel.org>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        qemu-arm@nongnu.org, John Snow <jsnow@redhat.com>,
        qemu-s390x@nongnu.org, Paul Durrant <paul@xen.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Halil Pasic <pasic@linux.ibm.com>, Fam Zheng <fam@euphon.net>,
        qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>, qemu-block@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Thomas Huth <thuth@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <20210111152020.1422021-1-philmd@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <84048681-32d3-7217-e94c-461501cf550b@redhat.com>
Date:   Mon, 22 Feb 2021 15:34:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210111152020.1422021-1-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo, this series is fully reviewed, can it go via your
misc tree?

On 1/11/21 4:20 PM, Philippe Mathieu-Daudé wrote:
> Trivial prototype change to clarify the use of the 'running'
> argument of VMChangeStateHandler.
> 
> Green CI:
> https://gitlab.com/philmd/qemu/-/pipelines/239497352
> 
> Philippe Mathieu-Daudé (2):
>   sysemu/runstate: Let runstate_is_running() return bool
>   sysemu: Let VMChangeStateHandler take boolean 'running' argument
> 
>  include/sysemu/runstate.h   | 12 +++++++++---
>  target/arm/kvm_arm.h        |  2 +-
>  target/ppc/cpu-qom.h        |  2 +-
>  accel/xen/xen-all.c         |  2 +-
>  audio/audio.c               |  2 +-
>  block/block-backend.c       |  2 +-
>  gdbstub.c                   |  2 +-
>  hw/block/pflash_cfi01.c     |  2 +-
>  hw/block/virtio-blk.c       |  2 +-
>  hw/display/qxl.c            |  2 +-
>  hw/i386/kvm/clock.c         |  2 +-
>  hw/i386/kvm/i8254.c         |  2 +-
>  hw/i386/kvmvapic.c          |  2 +-
>  hw/i386/xen/xen-hvm.c       |  2 +-
>  hw/ide/core.c               |  2 +-
>  hw/intc/arm_gicv3_its_kvm.c |  2 +-
>  hw/intc/arm_gicv3_kvm.c     |  2 +-
>  hw/intc/spapr_xive_kvm.c    |  2 +-
>  hw/misc/mac_via.c           |  2 +-
>  hw/net/e1000e_core.c        |  2 +-
>  hw/nvram/spapr_nvram.c      |  2 +-
>  hw/ppc/ppc.c                |  2 +-
>  hw/ppc/ppc_booke.c          |  2 +-
>  hw/s390x/tod-kvm.c          |  2 +-
>  hw/scsi/scsi-bus.c          |  2 +-
>  hw/usb/hcd-ehci.c           |  2 +-
>  hw/usb/host-libusb.c        |  2 +-
>  hw/usb/redirect.c           |  2 +-
>  hw/vfio/migration.c         |  2 +-
>  hw/virtio/virtio-rng.c      |  2 +-
>  hw/virtio/virtio.c          |  2 +-
>  net/net.c                   |  2 +-
>  softmmu/memory.c            |  2 +-
>  softmmu/runstate.c          |  4 ++--
>  target/arm/kvm.c            |  2 +-
>  target/i386/kvm/kvm.c       |  2 +-
>  target/i386/sev.c           |  2 +-
>  target/i386/whpx/whpx-all.c |  2 +-
>  target/mips/kvm.c           |  4 ++--
>  ui/gtk.c                    |  2 +-
>  ui/spice-core.c             |  2 +-
>  41 files changed, 51 insertions(+), 45 deletions(-)
> 

