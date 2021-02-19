Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0276731F971
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 13:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhBSMf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 07:35:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:54172 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230180AbhBSMf0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Feb 2021 07:35:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 15495ACBF;
        Fri, 19 Feb 2021 12:34:45 +0000 (UTC)
Subject: Re: [PATCH 0/7] hw/kvm: Exit gracefully when KVM is not supported
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Radoslaw Biernacki <rad@semihalf.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Thomas Huth <thuth@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        Leif Lindholm <leif@nuviainc.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Richard Henderson <richard.henderson@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-s390x@nongnu.org,
        qemu-arm@nongnu.org, David Gibson <david@gibson.dropbear.id.au>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20210219114428.1936109-1-philmd@redhat.com>
From:   Claudio Fontana <cfontana@suse.de>
Message-ID: <89bb6db0-0411-e219-3df8-8300664b54f3@suse.de>
Date:   Fri, 19 Feb 2021 13:34:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210219114428.1936109-1-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/19/21 12:44 PM, Philippe Mathieu-Daudé wrote:
> Hi,
> 
> This series aims to improve user experience by providing
> a better error message when the user tries to enable KVM
> on machines not supporting it.
> 
> Regards,
> 
> Phil.

Hi Philippe, not sure if it fits in this series,

but also the experience of a user running on a machine with cortex-a72,
choosing that very same cpu with -cpu and then getting:

qemu-system-aarch64: kvm_init_vcpu: kvm_arch_init_vcpu failed (0): Invalid argument

is not super-friendly. Maybe some suggestion to use -cpu host with KVM could be good?

Thanks,

Claudio

> 
> Philippe Mathieu-Daudé (7):
>   accel/kvm: Check MachineClass kvm_type() return value
>   hw/boards: Introduce 'kvm_supported' field to MachineClass
>   hw/arm: Set kvm_supported for KVM-compatible machines
>   hw/mips: Set kvm_supported for KVM-compatible machines
>   hw/ppc: Set kvm_supported for KVM-compatible machines
>   hw/s390x: Set kvm_supported to s390-ccw-virtio machines
>   accel/kvm: Exit gracefully when KVM is not supported
> 
>  include/hw/boards.h        |  6 +++++-
>  accel/kvm/kvm-all.c        | 12 ++++++++++++
>  hw/arm/sbsa-ref.c          |  1 +
>  hw/arm/virt.c              |  1 +
>  hw/arm/xlnx-versal-virt.c  |  1 +
>  hw/mips/loongson3_virt.c   |  1 +
>  hw/mips/malta.c            |  1 +
>  hw/ppc/e500plat.c          |  1 +
>  hw/ppc/mac_newworld.c      |  1 +
>  hw/ppc/mac_oldworld.c      |  1 +
>  hw/ppc/mpc8544ds.c         |  1 +
>  hw/ppc/ppc440_bamboo.c     |  1 +
>  hw/ppc/prep.c              |  1 +
>  hw/ppc/sam460ex.c          |  1 +
>  hw/ppc/spapr.c             |  1 +
>  hw/s390x/s390-virtio-ccw.c |  1 +
>  16 files changed, 31 insertions(+), 1 deletion(-)
> 

