Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A33315D143
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 05:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbgBNE5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 23:57:14 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39927 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728239AbgBNE5N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 23:57:13 -0500
Received: by mail-pf1-f194.google.com with SMTP id 84so4262618pfy.6
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2020 20:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cIzuxZ8H3fSttOIKqxXbQh1izcjEUCB+1ElK2xj9vV8=;
        b=SXjb7zXKBadI5y0ccm/NU2bxDHfK8DcmalP/xcaTzeIJceHXPMNEH7cs97S3myq7WF
         skTwI7s8WeW7yWGdBkJQgGMBgusRvIZgBVYOuz/D8Z5M0J+pvslm0fyN9+mntFOqCuIy
         rCbyU9ZL8tLkLjN9vc4a5wxMGbgfj/CG3pxkjL4doB6VBAbH6oDuc0rKdqToJh2Gqtzc
         aqwt0t8DbUTisbd8jRJiaCGlAeuBwVzAf5T8u5z8tRetvKOgCEfmikQEtKil/hdd//bW
         MzjaOMf7IDUZE/Ltme777ECoobkopDUfp6wDKMt6No8JYcV3CZmkymqU5LUvLQUpQ40o
         8B6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=cIzuxZ8H3fSttOIKqxXbQh1izcjEUCB+1ElK2xj9vV8=;
        b=Bc0D6FmrWeMaKbUV4rsQDhsfZJavgNg0QUbdkdf1ZutUCxFUI5GT46RsVnux3Cb3k8
         w/jOEiahnO3ZaoudKFJmi70ISV54vHZCQc9X/N4Qb9n7YpsA6fZa5PrMaLvhvWOCxcJv
         1frRx/VGYfJDjPhNRVR0CvnoAvXl+nEtmyGjlcDdDKZ4OPjRaXG8yuFV9MTslqSPpU46
         28GPrR+A4RMFDUy0iMJY3pT5syeFL7n3mku/Ol1Zm/LvQ97CGVHUoXU4q1XyI//anr7c
         80jKPnBdeMS8iQcknPcNwB1MF+NPtjhMNQLs+xUwG6Psq5FAcRBXqkUP8t3wLEZ/0HCU
         vI9Q==
X-Gm-Message-State: APjAAAXn7CgZtRvuI4g0R4xGtC3LSIsfdEAF/qExAylmZajjk4ND638+
        XRqOMudWm7+Nk0hSP1ETaq+ppw==
X-Google-Smtp-Source: APXvYqzCZZ9/IPKP6dWYRV+5Yjqawbc9CwEExjLrPccEseurkIAonc045+ZiuZM7bJEabIgfkI4b+A==
X-Received: by 2002:a63:3343:: with SMTP id z64mr1502319pgz.429.1581656232560;
        Thu, 13 Feb 2020 20:57:12 -0800 (PST)
Received: from [10.61.2.175] ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id o19sm11589602pjr.2.2020.02.13.20.57.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 20:57:11 -0800 (PST)
Subject: Re: [PATCH 0/7] vfio/pci: SR-IOV support
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        dev@dpdk.org, mtosatti@redhat.com, thomas@monjalon.net,
        bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, cohuck@redhat.com
References: <158145472604.16827.15751375540102298130.stgit@gimli.home>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
Autocrypt: addr=aik@ozlabs.ru; keydata=
 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
Message-ID: <22153755-598f-d25c-55a2-799c008d8d2b@ozlabs.ru>
Date:   Fri, 14 Feb 2020 15:57:04 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <158145472604.16827.15751375540102298130.stgit@gimli.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/02/2020 10:05, Alex Williamson wrote:
> Given the mostly positive feedback from the RFC[1], here's a new
> non-RFC revision.  Changes since RFC:
> 
>  - vfio_device_ops.match semantics refined
>  - Use helpers for struct pci_dev.physfn to avoid breakage without
>    CONFIG_PCI_IOV
>  - Relax to allow SR-IOV configuration changes while PF is opened.
>    There are potentially interesting use cases here, including
>    perhaps QEMU emulating an SR-IOV capability and calling out
>    to a privileged entity to manipulate sriov_numvfs and corral
>    the resulting devices.
>  - Retest vfio_device_feature.argsz to include uuid length.
>  - Add Connie's R-b on 6/7
> 
> I still wish we had a solution to make it less opaque to the user
> why a VFIO_GROUP_GET_DEVICE_FD() has failed if a VF token is
> required, but this is still the best I've been able to come up with.
> If there are objections or better ideas, please raise them now.
> 
> The synopsis of this series is that we have an ongoing desire to drive
> PCIe SR-IOV PFs from userspace with VFIO.  There's an immediate need
> for this with DPDK drivers and potentially interesting future use
> cases in virtualization.  We've been reluctant to add this support
> previously due to the dependency and trust relationship between the
> VF device and PF driver.  Minimally the PF driver can induce a denial
> of service to the VF, but depending on the specific implementation,
> the PF driver might also be responsible for moving data between VFs
> or have direct access to the state of the VF, including data or state
> otherwise private to the VF or VF driver.
> 
> To help resolve these concerns, we introduce a VF token into the VFIO
> PCI ABI, which acts as a shared secret key between drivers.  The
> userspace PF driver is required to set the VF token to a known value
> and userspace VF drivers are required to provide the token to access
> the VF device.  If a PF driver is restarted with VF drivers in use, it
> must also provide the current token in order to prevent a rogue
> untrusted PF driver from replacing a known driver.  The degree to
> which this new token is considered secret is left to the userspace
> drivers, the kernel intentionally provides no means to retrieve the
> current token.
> 
> Note that the above token is only required for this new model where
> both the PF and VF devices are usable through vfio-pci.  Existing
> models of VFIO drivers where the PF is used without SR-IOV enabled
> or the VF is bound to a userspace driver with an in-kernel, host PF
> driver are unaffected.
> 
> The latter configuration above also highlights a new inverted scenario
> that is now possible, a userspace PF driver with in-kernel VF drivers.
> I believe this is a scenario that should be allowed, but should not be
> enabled by default.  This series includes code to set a default
> driver_override for VFs sourced from a vfio-pci user owned PF, such
> that the VFs are also bound to vfio-pci.  This model is compatible
> with tools like driverctl and allows the system administrator to
> decide if other bindings should be enabled.  The VF token interface
> above exists only between vfio-pci PF and VF drivers, once a VF is
> bound to another driver, the administrator has effectively pronounced
> the device as trusted.  The vfio-pci driver will note alternate
> binding in dmesg for logging and debugging purposes.
> 
> Please review, comment, and test.  The example QEMU implementation
> provided with the RFC[2] is still current for this version.  Thanks,


It is a cool feature. One question - what device have you tested it with?

Does not a PF want to control/manage VFs on a PF driver side? I am
thinking of Mellanox CX5 or similar NIC and it acts as an managed
ethernet switch which might want to do something to VFs and VFs may not
work as expected without PF's native driver doing things to it, or this
is not a concern, is it? Thanks,


> 
> Alex
> 
> [1] https://lore.kernel.org/lkml/158085337582.9445.17682266437583505502.stgit@gimli.home/
> [2] https://lore.kernel.org/lkml/20200204161737.34696b91@w520.home/
> ---
> 
> Alex Williamson (7):
>       vfio: Include optional device match in vfio_device_ops callbacks
>       vfio/pci: Implement match ops
>       vfio/pci: Introduce VF token
>       vfio: Introduce VFIO_DEVICE_FEATURE ioctl and first user
>       vfio/pci: Add sriov_configure support
>       vfio/pci: Remove dev_fmt definition
>       vfio/pci: Cleanup .probe() exit paths
> 
> 
>  drivers/vfio/pci/vfio_pci.c         |  312 ++++++++++++++++++++++++++++++++---
>  drivers/vfio/pci/vfio_pci_private.h |   10 +
>  drivers/vfio/vfio.c                 |   20 ++
>  include/linux/vfio.h                |    4 
>  include/uapi/linux/vfio.h           |   37 ++++
>  5 files changed, 355 insertions(+), 28 deletions(-)
> 

-- 
Alexey
