Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768716CF4E0
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 22:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjC2U4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 16:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjC2U43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 16:56:29 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A4E10FB
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 13:56:26 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id j18-20020a05600c1c1200b003ee5157346cso12241188wms.1
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 13:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680123385;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gtBdKuDV256k43h2KK50cgoHxH1VCSEKNO2ufgv5r2s=;
        b=ICvBLy4hrp+QYvOJ1ErKmxNmxeTXOgckXBBiNKT3vnVWtanE7C3qVx5sWbdmiib32Q
         ihiDvJTy52AH/W52B9BPoW0YSnxvelQzeHhwKSZeZAjOL7jKnrH/EFkXywHHYORvEZZ7
         arQbKgXPiQikBaXwzw1q0JWBGocZFCIDs8HzV55O/+9CZ2aidafKfSAmjxIjSXvt/xed
         aZRQIym1UEYvJxAzXAAFvtw0s7ZyYSYAhwt19IrObO29otdTotcLoUX8iO0g1DmfjSI+
         u+rHfSTtndm98YXCIQ/LEYwA5KII/qKP8/UPxsTBIBtyKnAEsE5D9H4irlzVmIBbMClf
         ds8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680123385;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gtBdKuDV256k43h2KK50cgoHxH1VCSEKNO2ufgv5r2s=;
        b=CYdWkY6kfEEcqxnJ3YECj65tDjD6+eHQBTmtltD8VcwQ+1sV8k3433DAUJR54FGsae
         yljQYGgeaOoh0pPW2nT47uVUEEpTArM9GmPqNID3/CuoDNztoeOxPvtOoRlNm8tHsgZ+
         WuwjS4AFmlkgQEB5pLL00HnISS1gHeh9bcMlA4bGxbBZvow+QRpqbt6NNUqOvzGE37El
         Ee+S330ujznVub9Vt+fUQNowIL198EnXNySy5EQlgeR7bCi0SllLtgwJoLsF9s4U9gPg
         1wnEinUnqPl8u+GEhHzxslXFA5iofRaWMcZVY4RNWePJWVGFnARBsPlmF4fZRlwxjERh
         QHqw==
X-Gm-Message-State: AAQBX9eVM3voj1Eye+RArW5xT1PZMBRG+5PPHXHNIrLPVDbjPzQwMTb/
        EEnAwOQN2l/3afRsh3ccoDEM2Q==
X-Google-Smtp-Source: AKy350aw+Y3H6dtCnE8Y8sk2DGBKHBWhiLU1gLE4jX1PUgSL8oum1lRW1blLFjPiXpDkZ0DYjZ3MHw==
X-Received: by 2002:a1c:cc1a:0:b0:3ef:622c:26d3 with SMTP id h26-20020a1ccc1a000000b003ef622c26d3mr12421462wmb.35.1680123385227;
        Wed, 29 Mar 2023 13:56:25 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id n2-20020a05600c4f8200b003ef5e5f93f5sm3609213wmq.19.2023.03.29.13.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 13:56:24 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 6879F1FFB7;
        Wed, 29 Mar 2023 21:56:24 +0100 (BST)
References: <20230324160719.1790792-1-alex.bennee@linaro.org>
User-agent: mu4e 1.10.0; emacs 29.0.60
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     qemu-devel@nongnu.org, David Woodhouse <dwmw@amazon.co.uk>,
        Cleber Rosa <crosa@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Beraldo Leal <bleal@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH] tests/avocado: Test Xen guest support under KVM
Date:   Wed, 29 Mar 2023 21:56:04 +0100
In-reply-to: <20230324160719.1790792-1-alex.bennee@linaro.org>
Message-ID: <87y1nfp98n.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Alex Benn=C3=A9e <alex.bennee@linaro.org> writes:

> From: David Woodhouse <dwmw@amazon.co.uk>
>
> Exercise guests with a few different modes for interrupt delivery. In
> particular we want to cover:
>
>  =E2=80=A2 Xen event channel delivery via GSI to the I/O APIC
>  =E2=80=A2 Xen event channel delivery via GSI to the i8259 PIC
>  =E2=80=A2 MSIs routed to PIRQ event channels
>  =E2=80=A2 GSIs routed to PIRQ event channels
>
> As well as some variants of normal non-Xen stuff like MSI to vAPIC and
> PCI INTx going to the I/O APIC and PIC, which ought to still work even
> in Xen mode.
>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>
> ---
> v2 (ajb)
>   - switch to plain QemuSystemTest + LinuxSSHMixIn
>   - switch from fedora to custom kernel and buildroot
>   - removed some unused code
> TODO:
>   - properly probe for host support to skip test

So any idea for the best thing to check for here?

> ---
>  tests/avocado/kvm_xen_guest.py | 160 +++++++++++++++++++++++++++++++++
>  1 file changed, 160 insertions(+)
>  create mode 100644 tests/avocado/kvm_xen_guest.py
>
> diff --git a/tests/avocado/kvm_xen_guest.py b/tests/avocado/kvm_xen_guest=
.py
> new file mode 100644
> index 0000000000..1b4524d31c
> --- /dev/null
> +++ b/tests/avocado/kvm_xen_guest.py
> @@ -0,0 +1,160 @@
> +# KVM Xen guest functional tests
> +#
> +# Copyright =C2=A9 2021 Red Hat, Inc.
> +# Copyright =C2=A9 2023 Amazon.com, Inc. or its affiliates. All Rights R=
eserved.
> +#
> +# Author:
> +#  David Woodhouse <dwmw2@infradead.org>
> +#  Alex Benn=C3=A9e <alex.bennee@linaro.org>
> +#
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +
> +import os
> +
> +from avocado_qemu import LinuxSSHMixIn
> +from avocado_qemu import QemuSystemTest
> +from avocado_qemu import wait_for_console_pattern
> +
> +class KVMXenGuest(QemuSystemTest, LinuxSSHMixIn):
> +    """
> +    :avocado: tags=3Darch:x86_64
> +    :avocado: tags=3Dmachine:q35
> +    :avocado: tags=3Daccel:kvm
> +    :avocado: tags=3Dkvm_xen_guest
> +    """
> +
> +    KERNEL_DEFAULT =3D 'printk.time=3D0 root=3D/dev/xvda console=3DttyS0'
> +
> +    kernel_path =3D None
> +    kernel_params =3D None
> +
> +    # Fetch assets from the kvm-xen-guest subdir of my shared test
> +    # images directory on fileserver.linaro.org where you can find
> +    # build instructions for how they where assembled.
> +    def get_asset(self, name, sha1):
> +        base_url =3D ('https://fileserver.linaro.org/s/'
> +                    'kE4nCFLdQcoBF9t/download?'
> +                    'path=3D%2Fkvm-xen-guest&files=3D' )
> +        url =3D base_url + name
> +        # use explicit name rather than failing to neatly parse the
> +        # URL into a unique one
> +        return self.fetch_asset(name=3Dname, locations=3D(url), asset_ha=
sh=3Dsha1)
> +
> +    def common_vm_setup(self):
> +
> +        # TODO: we also need to check host kernel version/support
> +        self.require_accelerator("kvm")
> +
> +        self.vm.set_console()
> +
> +        self.vm.add_args("-accel", "kvm,xen-version=3D0x4000a,kernel-irq=
chip=3Dsplit")
> +        self.vm.add_args("-smp", "2")
> +
> +        self.kernel_path =3D self.get_asset("bzImage",
> +                                          "367962983d0d32109998a70b45dce=
e4672d0b045")
> +        self.rootfs =3D self.get_asset("rootfs.ext4",
> +                                     "f1478401ea4b3fa2ea196396be44315bab=
2bb5e4")
> +
> +    def run_and_check(self):
> +        self.vm.add_args('-kernel', self.kernel_path,
> +                         '-append', self.kernel_params,
> +                         '-drive',  f"file=3D{self.rootfs},if=3Dnone,id=
=3Ddrv0",
> +                         '-device', 'xen-disk,drive=3Ddrv0,vdev=3Dxvda',
> +                         '-device', 'virtio-net-pci,netdev=3Dunet',
> +                         '-netdev', 'user,id=3Dunet,hostfwd=3D:127.0.0.1=
:0-:22')
> +
> +        self.vm.launch()
> +        self.log.info('VM launched, waiting for sshd')
> +        console_pattern =3D 'Starting dropbear sshd: OK'
> +        wait_for_console_pattern(self, console_pattern, 'Oops')
> +        self.log.info('sshd ready')
> +        self.ssh_connect('root', '', False)
> +
> +        self.ssh_command('cat /proc/cmdline')
> +        self.ssh_command('dmesg | grep -e "Grant table initialized"')
> +
> +    def test_kvm_xen_guest(self):
> +        """
> +        :avocado: tags=3Dkvm_xen_guest
> +        """
> +
> +        self.common_vm_setup()
> +
> +        self.kernel_params =3D (self.KERNEL_DEFAULT +
> +                              ' xen_emul_unplug=3Dide-disks')
> +        self.run_and_check()
> +        self.ssh_command('grep xen-pirq.*msi /proc/interrupts')
> +
> +    def test_kvm_xen_guest_nomsi(self):
> +        """
> +        :avocado: tags=3Dkvm_xen_guest_nomsi
> +        """
> +
> +        self.common_vm_setup()
> +
> +        self.kernel_params =3D (self.KERNEL_DEFAULT +
> +                              ' xen_emul_unplug=3Dide-disks pci=3Dnomsi')
> +        self.run_and_check()
> +        self.ssh_command('grep xen-pirq.* /proc/interrupts')
> +
> +    def test_kvm_xen_guest_noapic_nomsi(self):
> +        """
> +        :avocado: tags=3Dkvm_xen_guest_noapic_nomsi
> +        """
> +
> +        self.common_vm_setup()
> +
> +        self.kernel_params =3D (self.KERNEL_DEFAULT +
> +                              ' xen_emul_unplug=3Dide-disks noapic pci=
=3Dnomsi')
> +        self.run_and_check()
> +        self.ssh_command('grep xen-pirq /proc/interrupts')
> +
> +    def test_kvm_xen_guest_vapic(self):
> +        """
> +        :avocado: tags=3Dkvm_xen_guest_vapic
> +        """
> +
> +        self.common_vm_setup()
> +        self.vm.add_args('-cpu', 'host,+xen-vapic')
> +        self.kernel_params =3D (self.KERNEL_DEFAULT +
> +                              ' xen_emul_unplug=3Dide-disks')
> +        self.run_and_check()
> +        self.ssh_command('grep xen-pirq /proc/interrupts')
> +        self.ssh_command('grep PCI-MSI /proc/interrupts')
> +
> +    def test_kvm_xen_guest_novector(self):
> +        """
> +        :avocado: tags=3Dkvm_xen_guest_novector
> +        """
> +
> +        self.common_vm_setup()
> +        self.kernel_params =3D (self.KERNEL_DEFAULT +
> +                              ' xen_emul_unplug=3Dide-disks' +
> +                              ' xen_no_vector_callback')
> +        self.run_and_check()
> +        self.ssh_command('grep xen-platform-pci /proc/interrupts')
> +
> +    def test_kvm_xen_guest_novector_nomsi(self):
> +        """
> +        :avocado: tags=3Dkvm_xen_guest_novector_nomsi
> +        """
> +
> +        self.common_vm_setup()
> +
> +        self.kernel_params =3D (self.KERNEL_DEFAULT +
> +                              ' xen_emul_unplug=3Dide-disks pci=3Dnomsi'=
 +
> +                              ' xen_no_vector_callback')
> +        self.run_and_check()
> +        self.ssh_command('grep xen-platform-pci /proc/interrupts')
> +
> +    def test_kvm_xen_guest_novector_noapic(self):
> +        """
> +        :avocado: tags=3Dkvm_xen_guest_novector_noapic
> +        """
> +
> +        self.common_vm_setup()
> +        self.kernel_params =3D (self.KERNEL_DEFAULT +
> +                              ' xen_emul_unplug=3Dide-disks' +
> +                              ' xen_no_vector_callback noapic')
> +        self.run_and_check()
> +        self.ssh_command('grep xen-platform-pci /proc/interrupts')


--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
