Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD81433315D
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 23:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbhCIWI1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 17:08:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58758 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232033AbhCIWIY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 17:08:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615327703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TrRfkpaCyAif10vY2NLzElT8H9hcz96S44UT+WnEyM0=;
        b=FgUnxXZsgjBvrb3220+nGB0Q8THgSq7pMRjoJj9bSnNJqs/394SltmWFUD0Bcs4VUQ2gLl
        HMRt+fKVq1RKElSa4cpJ4VcSvlWtCTvsL+GkHqs8OJMh4v9W+xHztl/YBhC4SjKjRnu5SB
        BnvkgZ45FIzSZx3/cSCaaxFI6s28Ug4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-5AFnCc28NKuL8srHcL-AaA-1; Tue, 09 Mar 2021 17:08:22 -0500
X-MC-Unique: 5AFnCc28NKuL8srHcL-AaA-1
Received: by mail-ed1-f71.google.com with SMTP id w16so7453521edc.22
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 14:08:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TrRfkpaCyAif10vY2NLzElT8H9hcz96S44UT+WnEyM0=;
        b=rIUGkj7VFdAPZz8io4ESe0DXAHdMQ4ovXr5BD061KGVcKCIgyAuaNdWYWXWilLUSEQ
         d1NSeOphOrLKput6KiA2VIWVQk/WDuH99VF3uZ+q28nbtW4Lcoy/k4ybaXiDfMx0AIlS
         HSqT+3eLBmaIwJsQclLr4b4WKe9yeCJUdyGL4rgk+KHEetvxi4GN1uSPnJJRROIoJ8Hp
         ldJPqV6TELw15bDQrcDJKAPElKXpVCPNROailjvG97jVkY0drBl7uQqv/st9q9qhAVvM
         8NRGi/ZDdEkpvGauWfmYbk2vPjqw60SX7BIW5i8Whpeu6cHPe+URmcZuLWLvTPgIS0Hn
         owxg==
X-Gm-Message-State: AOAM532b4vCcxD5raGCw8oYDVgr6mgUCJjDK0dEFH/xwzMXenkOugVAp
        P3KGTpq12VPfBRDYx1xpKzq2sAzB/pyQCbJq9HkyLA853JZbefMkYLlPk7qLtGh4F7YhWmYt+Hk
        qh8NJcMBfVe5o
X-Received: by 2002:a17:907:d15:: with SMTP id gn21mr180984ejc.337.1615327700939;
        Tue, 09 Mar 2021 14:08:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyoPZbz8BsbfZxNq4crDSMnBl/+S3hyEa4IsAMqqCextuO59Wc8A5fWQ9LtkxA8SuHE3e3dRQ==
X-Received: by 2002:a17:907:d15:: with SMTP id gn21mr180947ejc.337.1615327700754;
        Tue, 09 Mar 2021 14:08:20 -0800 (PST)
Received: from [192.168.1.36] (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id u15sm10107092eds.6.2021.03.09.14.08.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 14:08:20 -0800 (PST)
Subject: Re: [PATCH 0/2] sysemu: Let VMChangeStateHandler take boolean
 'running' argument
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        QEMU Trivial <qemu-trivial@nongnu.org>
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
 <84048681-32d3-7217-e94c-461501cf550b@redhat.com>
Message-ID: <3112233d-e227-b0c5-4a97-3ad0127a4d12@redhat.com>
Date:   Tue, 9 Mar 2021 23:08:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <84048681-32d3-7217-e94c-461501cf550b@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ping, qemu-trivial maybe?

On 2/22/21 3:34 PM, Philippe Mathieu-Daudé wrote:
> Paolo, this series is fully reviewed, can it go via your
> misc tree?
> 
> On 1/11/21 4:20 PM, Philippe Mathieu-Daudé wrote:
>> Trivial prototype change to clarify the use of the 'running'
>> argument of VMChangeStateHandler.
>>
>> Green CI:
>> https://gitlab.com/philmd/qemu/-/pipelines/239497352
>>
>> Philippe Mathieu-Daudé (2):
>>   sysemu/runstate: Let runstate_is_running() return bool
>>   sysemu: Let VMChangeStateHandler take boolean 'running' argument
>>
>>  include/sysemu/runstate.h   | 12 +++++++++---
>>  target/arm/kvm_arm.h        |  2 +-
>>  target/ppc/cpu-qom.h        |  2 +-
>>  accel/xen/xen-all.c         |  2 +-
>>  audio/audio.c               |  2 +-
>>  block/block-backend.c       |  2 +-
>>  gdbstub.c                   |  2 +-
>>  hw/block/pflash_cfi01.c     |  2 +-
>>  hw/block/virtio-blk.c       |  2 +-
>>  hw/display/qxl.c            |  2 +-
>>  hw/i386/kvm/clock.c         |  2 +-
>>  hw/i386/kvm/i8254.c         |  2 +-
>>  hw/i386/kvmvapic.c          |  2 +-
>>  hw/i386/xen/xen-hvm.c       |  2 +-
>>  hw/ide/core.c               |  2 +-
>>  hw/intc/arm_gicv3_its_kvm.c |  2 +-
>>  hw/intc/arm_gicv3_kvm.c     |  2 +-
>>  hw/intc/spapr_xive_kvm.c    |  2 +-
>>  hw/misc/mac_via.c           |  2 +-
>>  hw/net/e1000e_core.c        |  2 +-
>>  hw/nvram/spapr_nvram.c      |  2 +-
>>  hw/ppc/ppc.c                |  2 +-
>>  hw/ppc/ppc_booke.c          |  2 +-
>>  hw/s390x/tod-kvm.c          |  2 +-
>>  hw/scsi/scsi-bus.c          |  2 +-
>>  hw/usb/hcd-ehci.c           |  2 +-
>>  hw/usb/host-libusb.c        |  2 +-
>>  hw/usb/redirect.c           |  2 +-
>>  hw/vfio/migration.c         |  2 +-
>>  hw/virtio/virtio-rng.c      |  2 +-
>>  hw/virtio/virtio.c          |  2 +-
>>  net/net.c                   |  2 +-
>>  softmmu/memory.c            |  2 +-
>>  softmmu/runstate.c          |  4 ++--
>>  target/arm/kvm.c            |  2 +-
>>  target/i386/kvm/kvm.c       |  2 +-
>>  target/i386/sev.c           |  2 +-
>>  target/i386/whpx/whpx-all.c |  2 +-
>>  target/mips/kvm.c           |  4 ++--
>>  ui/gtk.c                    |  2 +-
>>  ui/spice-core.c             |  2 +-
>>  41 files changed, 51 insertions(+), 45 deletions(-)
>>
> 

