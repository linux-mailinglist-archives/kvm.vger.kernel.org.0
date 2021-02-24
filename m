Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5860B323933
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 10:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhBXJJG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 04:09:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46754 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234349AbhBXJGt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Feb 2021 04:06:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614157516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QqFm1NSygbJXw0rWa68aFsGxKE3C5g6IlhiIzb/mOPY=;
        b=P9im5AN/uNSCrpyn3E7l/QvzEUCgB8w+0VQ6794A8pMtbixa0RoK/nVE1bfN9c7RnJj/H3
        yFboQ9QXh3ihyIxAvhjv0m9xYU2f+RoNfeCC4yo62GyRGLdoThNWnf0rrhdvDcZQFIj5yN
        ka8DUTO2h3JynGOJTunEvo7Z2/GrMSw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-D1pB1se0NyeLtx9dBYLLeQ-1; Wed, 24 Feb 2021 04:05:13 -0500
X-MC-Unique: D1pB1se0NyeLtx9dBYLLeQ-1
Received: by mail-ed1-f71.google.com with SMTP id w9so547694edi.15
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 01:05:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=QqFm1NSygbJXw0rWa68aFsGxKE3C5g6IlhiIzb/mOPY=;
        b=iP0NxgTP6TYbDrgzK9uocEuVmLs8MnBDXWr9bODG9dDyhqlxwPwpkLoWskCscx4OCU
         ANuOETNxtC1LeQFZrlPh61dCVOWC5hC3TEr6n3MxBCHh06g/JDXDZlrzleQN3dwNdjpI
         y5PSyeNNU2Bjjh8Z+fSdYtNpHrPPz+I5Uur+y+74/tZed74jaeKIG3V4RRMsqZew5T3K
         3CS99mvkquwoj3uhmnpQVCU6tdko1IoFHElDn0YuLGfeJ2pU6/7v1EP4aOlX5ifyRmHI
         O3layIjLI8lLvjfyC2/9Z17ahkI6d5lo7wQk77Kt3ltiVdy/N8BMStxol3mFNJNFzTBp
         jOvA==
X-Gm-Message-State: AOAM532j/t9gizCVrAVA5AeHfKws61wSdYW29i1ncJ93gX/k2rGWgfHe
        8Sr+PkqpPoxDeyjJKXHH/C2OcxFoPzWjtxkRib+PnjW7LjgA3rSdaUNmzk7gtDsiLEf0OHA8aCY
        1KIeGmMm4FMIo
X-Received: by 2002:a17:906:27cc:: with SMTP id k12mr30689084ejc.8.1614157512118;
        Wed, 24 Feb 2021 01:05:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwB+2pkCXGcB7fc6xM7Z1RAg7wAhQFJTErDSVFXdqZyiyFbzB3jPIgR1cW6VaLQuWhn+I2l+w==
X-Received: by 2002:a17:906:27cc:: with SMTP id k12mr30689054ejc.8.1614157511871;
        Wed, 24 Feb 2021 01:05:11 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id t8sm818884ejr.71.2021.02.24.01.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 01:05:10 -0800 (PST)
Date:   Wed, 24 Feb 2021 04:05:05 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Adrian Catangiu <acatan@amazon.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, gregkh@linuxfoundation.org,
        graf@amazon.com, rdunlap@infradead.org, arnd@arndb.de,
        ebiederm@xmission.com, rppt@kernel.org, 0x7f454c46@gmail.com,
        borntraeger@de.ibm.com, Jason@zx2c4.com, jannh@google.com,
        w@1wt.eu, colmmacc@amazon.com, luto@kernel.org, tytso@mit.edu,
        ebiggers@kernel.org, dwmw@amazon.co.uk, bonzini@gnu.org,
        sblbir@amazon.com, raduweis@amazon.com, corbet@lwn.net,
        mhocko@kernel.org, rafael@kernel.org, pavel@ucw.cz,
        mpe@ellerman.id.au, areber@redhat.com, ovzxemul@gmail.com,
        avagin@gmail.com, ptikhomirov@virtuozzo.com, gil@azul.com,
        asmehra@redhat.com, dgunigun@redhat.com, vijaysun@ca.ibm.com,
        oridgar@gmail.com, ghammer@redhat.com
Subject: Re: [PATCH v7 0/2] System Generation ID driver and VMGENID backend
Message-ID: <20210224040034-mutt-send-email-mst@kernel.org>
References: <1614156452-17311-1-git-send-email-acatan@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1614156452-17311-1-git-send-email-acatan@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 24, 2021 at 10:47:30AM +0200, Adrian Catangiu wrote:
> This feature is aimed at virtualized or containerized environments
> where VM or container snapshotting duplicates memory state, which is a
> challenge for applications that want to generate unique data such as
> request IDs, UUIDs, and cryptographic nonces.
> 
> The patch set introduces a mechanism that provides a userspace
> interface for applications and libraries to be made aware of uniqueness
> breaking events such as VM or container snapshotting, and allow them to
> react and adapt to such events.
> 
> Solving the uniqueness problem strongly enough for cryptographic
> purposes requires a mechanism which can deterministically reseed
> userspace PRNGs with new entropy at restore time. This mechanism must
> also support the high-throughput and low-latency use-cases that led
> programmers to pick a userspace PRNG in the first place; be usable by
> both application code and libraries; allow transparent retrofitting
> behind existing popular PRNG interfaces without changing application
> code; it must be efficient, especially on snapshot restore; and be
> simple enough for wide adoption.
> 
> The first patch in the set implements a device driver which exposes a
> the /dev/sysgenid char device to userspace. Its associated filesystem
> operations operations can be used to build a system level safe workflow
> that guest software can follow to protect itself from negative system
> snapshot effects.
> 
> The second patch in the set adds a VmGenId driver which makes use of
> the ACPI vmgenid device to drive SysGenId and to reseed kernel entropy
> following VM snapshots.
> 
> **Please note**, SysGenID alone does not guarantee complete snapshot
> safety to applications using it. A certain workflow needs to be
> followed at the system level, in order to make the system
> snapshot-resilient. Please see the "Snapshot Safety Prerequisites"
> section in the included SysGenID documentation.
> 
> ---
> 
> v6 -> v7:
>   - remove sysgenid uevent

How about we drop mmap too?

There's simply no way I can see to make it safe, and
no implementation is worse than a racy one imho.

Yea there's some decumentation explaining how it is not
supposed to be used but it will *seem* to work for people
and we will be stuck trying to maintain it.

Let's see if userspace using this often enough to make the
system call 



> v5 -> v6:
> 
>   - sysgenid: watcher tracking disabled by default
>   - sysgenid: add SYSGENID_SET_WATCHER_TRACKING ioctl to allow each
>     file descriptor to set whether they should be tracked as watchers
>   - rename SYSGENID_FORCE_GEN_UPDATE -> SYSGENID_TRIGGER_GEN_UPDATE
>   - rework all documentation to clearly capture all prerequisites for
>     achieving snapshot safety when using the provided mechanism
>   - sysgenid documentation: replace individual filesystem operations
>     examples with a higher level example showcasing system-level
>     snapshot-safe workflow
> 
> v4 -> v5:
> 
>   - sysgenid: generation changes are also exported through uevents
>   - remove SYSGENID_GET_OUTDATED_WATCHERS ioctl
>   - document sysgenid ioctl major/minor numbers
> 
> v3 -> v4:
> 
>   - split functionality in two separate kernel modules: 
>     1. drivers/misc/sysgenid.c which provides the generic userspace
>        interface and mechanisms
>     2. drivers/virt/vmgenid.c as VMGENID acpi device driver that seeds
>        kernel entropy and acts as a driving backend for the generic
>        sysgenid
>   - rename /dev/vmgenid -> /dev/sysgenid
>   - rename uapi header file vmgenid.h -> sysgenid.h
>   - rename ioctls VMGENID_* -> SYSGENID_*
>   - add ‘min_gen’ parameter to SYSGENID_FORCE_GEN_UPDATE ioctl
>   - fix races in documentation examples
> 
> v2 -> v3:
> 
>   - separate the core driver logic and interface, from the ACPI device.
>     The ACPI vmgenid device is now one possible backend
>   - fix issue when timeout=0 in VMGENID_WAIT_WATCHERS
>   - add locking to avoid races between fs ops handlers and hw irq
>     driven generation updates
>   - change VMGENID_WAIT_WATCHERS ioctl so if the current caller is
>     outdated or a generation change happens while waiting (thus making
>     current caller outdated), the ioctl returns -EINTR to signal the
>     user to handle event and retry. Fixes blocking on oneself
>   - add VMGENID_FORCE_GEN_UPDATE ioctl conditioned by
>     CAP_CHECKPOINT_RESTORE capability, through which software can force
>     generation bump
> 
> v1 -> v2:
> 
>   - expose to userspace a monotonically increasing u32 Vm Gen Counter
>     instead of the hw VmGen UUID
>   - since the hw/hypervisor-provided 128-bit UUID is not public
>     anymore, add it to the kernel RNG as device randomness
>   - insert driver page containing Vm Gen Counter in the user vma in
>     the driver's mmap handler instead of using a fault handler
>   - turn driver into a misc device driver to auto-create /dev/vmgenid
>   - change ioctl arg to avoid leaking kernel structs to userspace
>   - update documentation
> 
> Adrian Catangiu (2):
>   drivers/misc: sysgenid: add system generation id driver
>   drivers/virt: vmgenid: add vm generation id driver
> 
>  Documentation/misc-devices/sysgenid.rst            | 229 +++++++++++++++
>  Documentation/userspace-api/ioctl/ioctl-number.rst |   1 +
>  Documentation/virt/vmgenid.rst                     |  36 +++
>  MAINTAINERS                                        |  15 +
>  drivers/misc/Kconfig                               |  15 +
>  drivers/misc/Makefile                              |   1 +
>  drivers/misc/sysgenid.c                            | 322 +++++++++++++++++++++
>  drivers/virt/Kconfig                               |  13 +
>  drivers/virt/Makefile                              |   1 +
>  drivers/virt/vmgenid.c                             | 153 ++++++++++
>  include/uapi/linux/sysgenid.h                      |  18 ++
>  11 files changed, 804 insertions(+)
>  create mode 100644 Documentation/misc-devices/sysgenid.rst
>  create mode 100644 Documentation/virt/vmgenid.rst
>  create mode 100644 drivers/misc/sysgenid.c
>  create mode 100644 drivers/virt/vmgenid.c
>  create mode 100644 include/uapi/linux/sysgenid.h
> 
> -- 
> 2.7.4
> 
> 
> 
> 
> Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

