Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3275E456C34
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 10:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbhKSJUX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 04:20:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49133 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234009AbhKSJUU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 04:20:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637313438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ytuHwrdGe/HDbtUb/w4lQIGQKzvjfYcG/U3+CPSTpiY=;
        b=aBTlJalIzRFoDpWO3W4QkMrGcmLnnSMFodgf3yuYBOD/odNuXKiUpY8M5YrkMVEmhptW+3
        yI2sUqQo+c/Ezn8VOO2yKPWf28dXmS9AzXcutmBtc72a0RzHnCQsXDT7fHu4rhFvcaSEVt
        bitS2Y3vudzcXkPIjuqZ695MGxKw0D4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-0qgpWblGP2q3qb01oyOpFw-1; Fri, 19 Nov 2021 04:17:15 -0500
X-MC-Unique: 0qgpWblGP2q3qb01oyOpFw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7379F8799EB;
        Fri, 19 Nov 2021 09:17:14 +0000 (UTC)
Received: from [10.39.194.192] (unknown [10.39.194.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 04CFF5F4EA;
        Fri, 19 Nov 2021 09:17:11 +0000 (UTC)
Message-ID: <3bb56b6f-6547-ec56-accd-93ae7f4f592d@redhat.com>
Date:   Fri, 19 Nov 2021 10:17:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH-for-6.2?] docs: Spell QEMU all caps
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        qemu-block@nongnu.org, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>, Eric Blake <eblake@redhat.com>
References: <20211118143401.4101497-1-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211118143401.4101497-1-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/18/21 15:34, Philippe Mathieu-Daudé wrote:
> Replace Qemu -> QEMU.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>   docs/devel/modules.rst                |  2 +-
>   docs/devel/multi-thread-tcg.rst       |  2 +-
>   docs/devel/style.rst                  |  2 +-
>   docs/devel/ui.rst                     |  4 ++--
>   docs/interop/nbd.txt                  |  6 +++---
>   docs/interop/qcow2.txt                |  8 ++++----
>   docs/multiseat.txt                    |  2 +-
>   docs/system/device-url-syntax.rst.inc |  2 +-
>   docs/system/i386/sgx.rst              | 26 +++++++++++++-------------
>   docs/u2f.txt                          |  2 +-
>   10 files changed, 28 insertions(+), 28 deletions(-)
> 
> diff --git a/docs/devel/modules.rst b/docs/devel/modules.rst
> index 066f347b89b..8e999c4fa48 100644
> --- a/docs/devel/modules.rst
> +++ b/docs/devel/modules.rst
> @@ -1,5 +1,5 @@
>   ============
> -Qemu modules
> +QEMU modules
>   ============
>   
>   .. kernel-doc:: include/qemu/module.h
> diff --git a/docs/devel/multi-thread-tcg.rst b/docs/devel/multi-thread-tcg.rst
> index 5b446ee08b6..c9541a7b20a 100644
> --- a/docs/devel/multi-thread-tcg.rst
> +++ b/docs/devel/multi-thread-tcg.rst
> @@ -228,7 +228,7 @@ Emulated hardware state
>   
>   Currently thanks to KVM work any access to IO memory is automatically
>   protected by the global iothread mutex, also known as the BQL (Big
> -Qemu Lock). Any IO region that doesn't use global mutex is expected to
> +QEMU Lock). Any IO region that doesn't use global mutex is expected to
>   do its own locking.
>   
>   However IO memory isn't the only way emulated hardware state can be
> diff --git a/docs/devel/style.rst b/docs/devel/style.rst
> index 260e3263fa0..e00af62e763 100644
> --- a/docs/devel/style.rst
> +++ b/docs/devel/style.rst
> @@ -686,7 +686,7 @@ Rationale: hex numbers are hard to read in logs when there is no 0x prefix,
>   especially when (occasionally) the representation doesn't contain any letters
>   and especially in one line with other decimal numbers. Number groups are allowed
>   to not use '0x' because for some things notations like %x.%x.%x are used not
> -only in Qemu. Also dumping raw data bytes with '0x' is less readable.
> +only in QEMU. Also dumping raw data bytes with '0x' is less readable.
>   
>   '#' printf flag
>   ---------------
> diff --git a/docs/devel/ui.rst b/docs/devel/ui.rst
> index 06c7d622ce7..17fb667dec4 100644
> --- a/docs/devel/ui.rst
> +++ b/docs/devel/ui.rst
> @@ -1,8 +1,8 @@
>   =================
> -Qemu UI subsystem
> +QEMU UI subsystem
>   =================
>   
> -Qemu Clipboard
> +QEMU Clipboard
>   --------------
>   
>   .. kernel-doc:: include/ui/clipboard.h
> diff --git a/docs/interop/nbd.txt b/docs/interop/nbd.txt
> index 10ce098a29b..bdb0f2a41ac 100644
> --- a/docs/interop/nbd.txt
> +++ b/docs/interop/nbd.txt
> @@ -1,4 +1,4 @@
> -Qemu supports the NBD protocol, and has an internal NBD client (see
> +QEMU supports the NBD protocol, and has an internal NBD client (see
>   block/nbd.c), an internal NBD server (see blockdev-nbd.c), and an
>   external NBD server tool (see qemu-nbd.c). The common code is placed
>   in nbd/*.
> @@ -7,11 +7,11 @@ The NBD protocol is specified here:
>   https://github.com/NetworkBlockDevice/nbd/blob/master/doc/proto.md
>   
>   The following paragraphs describe some specific properties of NBD
> -protocol realization in Qemu.
> +protocol realization in QEMU.
>   
>   = Metadata namespaces =
>   
> -Qemu supports the "base:allocation" metadata context as defined in the
> +QEMU supports the "base:allocation" metadata context as defined in the
>   NBD protocol specification, and also defines an additional metadata
>   namespace "qemu".
>   
> diff --git a/docs/interop/qcow2.txt b/docs/interop/qcow2.txt
> index 0463f761efb..f7dc304ff69 100644
> --- a/docs/interop/qcow2.txt
> +++ b/docs/interop/qcow2.txt
> @@ -313,7 +313,7 @@ The fields of the bitmaps extension are:
>                      The number of bitmaps contained in the image. Must be
>                      greater than or equal to 1.
>   
> -                   Note: Qemu currently only supports up to 65535 bitmaps per
> +                   Note: QEMU currently only supports up to 65535 bitmaps per
>                      image.
>   
>             4 -  7:  Reserved, must be zero.
> @@ -775,7 +775,7 @@ Structure of a bitmap directory entry:
>                         2: extra_data_compatible
>                            This flags is meaningful when the extra data is
>                            unknown to the software (currently any extra data is
> -                         unknown to Qemu).
> +                         unknown to QEMU).
>                            If it is set, the bitmap may be used as expected, extra
>                            data must be left as is.
>                            If it is not set, the bitmap must not be used, but
> @@ -793,7 +793,7 @@ Structure of a bitmap directory entry:
>                17:    granularity_bits
>                       Granularity bits. Valid values: 0 - 63.
>   
> -                    Note: Qemu currently supports only values 9 - 31.
> +                    Note: QEMU currently supports only values 9 - 31.
>   
>                       Granularity is calculated as
>                           granularity = 1 << granularity_bits
> @@ -804,7 +804,7 @@ Structure of a bitmap directory entry:
>           18 - 19:    name_size
>                       Size of the bitmap name. Must be non-zero.
>   
> -                    Note: Qemu currently doesn't support values greater than
> +                    Note: QEMU currently doesn't support values greater than
>                       1023.
>   
>           20 - 23:    extra_data_size
> diff --git a/docs/multiseat.txt b/docs/multiseat.txt
> index 11850c96ff8..2b297e979d6 100644
> --- a/docs/multiseat.txt
> +++ b/docs/multiseat.txt
> @@ -123,7 +123,7 @@ Background info is here:
>   guest side with pci-bridge-seat
>   -------------------------------
>   
> -Qemu version 2.4 and newer has a new pci-bridge-seat device which
> +QEMU version 2.4 and newer has a new pci-bridge-seat device which
>   can be used instead of pci-bridge.  Just swap the device name in the
>   qemu command line above.  The only difference between the two devices
>   is the pci id.  We can match the pci id instead of the device path
> diff --git a/docs/system/device-url-syntax.rst.inc b/docs/system/device-url-syntax.rst.inc
> index d15a0215087..7dbc525fa80 100644
> --- a/docs/system/device-url-syntax.rst.inc
> +++ b/docs/system/device-url-syntax.rst.inc
> @@ -15,7 +15,7 @@ These are specified using a special URL syntax.
>      'iqn.2008-11.org.linux-kvm[:<name>]' but this can also be set from
>      the command line or a configuration file.
>   
> -   Since version Qemu 2.4 it is possible to specify a iSCSI request
> +   Since version QEMU 2.4 it is possible to specify a iSCSI request
>      timeout to detect stalled requests and force a reestablishment of the
>      session. The timeout is specified in seconds. The default is 0 which
>      means no timeout. Libiscsi 1.15.0 or greater is required for this
> diff --git a/docs/system/i386/sgx.rst b/docs/system/i386/sgx.rst
> index 9aa161af1a1..f8fade5ac2d 100644
> --- a/docs/system/i386/sgx.rst
> +++ b/docs/system/i386/sgx.rst
> @@ -20,13 +20,13 @@ report the same CPUID info to guest as on host for most of SGX CPUID. With
>   reporting the same CPUID guest is able to use full capacity of SGX, and KVM
>   doesn't need to emulate those info.
>   
> -The guest's EPC base and size are determined by Qemu, and KVM needs Qemu to
> +The guest's EPC base and size are determined by QEMU, and KVM needs QEMU to
>   notify such info to it before it can initialize SGX for guest.
>   
>   Virtual EPC
>   ~~~~~~~~~~~
>   
> -By default, Qemu does not assign EPC to a VM, i.e. fully enabling SGX in a VM
> +By default, QEMU does not assign EPC to a VM, i.e. fully enabling SGX in a VM
>   requires explicit allocation of EPC to the VM. Similar to other specialized
>   memory types, e.g. hugetlbfs, EPC is exposed as a memory backend.
>   
> @@ -35,12 +35,12 @@ prior to realizing the vCPUs themselves, which occurs long before generic
>   devices are parsed and realized.  This limitation means that EPC does not
>   require -maxmem as EPC is not treated as {cold,hot}plugged memory.
>   
> -Qemu does not artificially restrict the number of EPC sections exposed to a
> -guest, e.g. Qemu will happily allow you to create 64 1M EPC sections. Be aware
> +QEMU does not artificially restrict the number of EPC sections exposed to a
> +guest, e.g. QEMU will happily allow you to create 64 1M EPC sections. Be aware
>   that some kernels may not recognize all EPC sections, e.g. the Linux SGX driver
>   is hardwired to support only 8 EPC sections.
>   
> -The following Qemu snippet creates two EPC sections, with 64M pre-allocated
> +The following QEMU snippet creates two EPC sections, with 64M pre-allocated
>   to the VM and an additional 28M mapped but not allocated::
>   
>    -object memory-backend-epc,id=mem1,size=64M,prealloc=on \
> @@ -54,7 +54,7 @@ to physical EPC. Because physical EPC is protected via range registers,
>   the size of the physical EPC must be a power of two (though software sees
>   a subset of the full EPC, e.g. 92M or 128M) and the EPC must be naturally
>   aligned.  KVM SGX's virtual EPC is purely a software construct and only
> -requires the size and location to be page aligned. Qemu enforces the EPC
> +requires the size and location to be page aligned. QEMU enforces the EPC
>   size is a multiple of 4k and will ensure the base of the EPC is 4k aligned.
>   To simplify the implementation, EPC is always located above 4g in the guest
>   physical address space.
> @@ -62,7 +62,7 @@ physical address space.
>   Migration
>   ~~~~~~~~~
>   
> -Qemu/KVM doesn't prevent live migrating SGX VMs, although from hardware's
> +QEMU/KVM doesn't prevent live migrating SGX VMs, although from hardware's
>   perspective, SGX doesn't support live migration, since both EPC and the SGX
>   key hierarchy are bound to the physical platform. However live migration
>   can be supported in the sense if guest software stack can support recreating
> @@ -76,7 +76,7 @@ CPUID
>   ~~~~~
>   
>   Due to its myriad dependencies, SGX is currently not listed as supported
> -in any of Qemu's built-in CPU configuration. To expose SGX (and SGX Launch
> +in any of QEMU's built-in CPU configuration. To expose SGX (and SGX Launch
>   Control) to a guest, you must either use ``-cpu host`` to pass-through the
>   host CPU model, or explicitly enable SGX when using a built-in CPU model,
>   e.g. via ``-cpu <model>,+sgx`` or ``-cpu <model>,+sgx,+sgxlc``.
> @@ -101,7 +101,7 @@ controlled via -cpu are prefixed with "sgx", e.g.::
>     sgx2
>     sgxlc
>   
> -The following Qemu snippet passes through the host CPU but restricts access to
> +The following QEMU snippet passes through the host CPU but restricts access to
>   the provision and EINIT token keys::
>   
>    -cpu host,-sgx-provisionkey,-sgx-tokenkey
> @@ -112,11 +112,11 @@ in hardware cannot be forced on via '-cpu'.
>   Virtualize SGX Launch Control
>   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   
> -Qemu SGX support for Launch Control (LC) is passive, in the sense that it
> -does not actively change the LC configuration.  Qemu SGX provides the user
> +QEMU SGX support for Launch Control (LC) is passive, in the sense that it
> +does not actively change the LC configuration.  QEMU SGX provides the user
>   the ability to set/clear the CPUID flag (and by extension the associated
>   IA32_FEATURE_CONTROL MSR bit in fw_cfg) and saves/restores the LE Hash MSRs
> -when getting/putting guest state, but Qemu does not add new controls to
> +when getting/putting guest state, but QEMU does not add new controls to
>   directly modify the LC configuration.  Similar to hardware behavior, locking
>   the LC configuration to a non-Intel value is left to guest firmware.  Unlike
>   host bios setting for SGX launch control(LC), there is no special bios setting
> @@ -126,7 +126,7 @@ creating VM with SGX.
>   Feature Control
>   ~~~~~~~~~~~~~~~
>   
> -Qemu SGX updates the ``etc/msr_feature_control`` fw_cfg entry to set the SGX
> +QEMU SGX updates the ``etc/msr_feature_control`` fw_cfg entry to set the SGX
>   (bit 18) and SGX LC (bit 17) flags based on their respective CPUID support,
>   i.e. existing guest firmware will automatically set SGX and SGX LC accordingly,
>   assuming said firmware supports fw_cfg.msr_feature_control.
> diff --git a/docs/u2f.txt b/docs/u2f.txt
> index 8f44994818a..7f5813a0b72 100644
> --- a/docs/u2f.txt
> +++ b/docs/u2f.txt
> @@ -21,7 +21,7 @@ The second factor is materialized by a device implementing the U2F
>   protocol. In case of a USB U2F security key, it is a USB HID device
>   that implements the U2F protocol.
>   
> -In Qemu, the USB U2F key device offers a dedicated support of U2F, allowing
> +In QEMU, the USB U2F key device offers a dedicated support of U2F, allowing
>   guest USB FIDO/U2F security keys operating in two possible modes:
>   pass-through and emulated.
>   
> 

Queued, thanks.

Paolo

