Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124AA420751
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 10:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhJDI3j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 04:29:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22661 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230448AbhJDI3i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 04:29:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633336069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wK7iVG3X5Nkn6FIFB80ZzMQZFdwyjX+qi6LS3TDFA2s=;
        b=WjO76lsW3Px/4Qp8sNq8ZBrRIe+dAwPttP82JODcqovUz/Jb5s6AM0jVb/jN2CtVrgXDLH
        terjFbAMFkW9pW0Rp/MpBlqyQrWNZxY/ktxexJYs3f+ui/1besowzdAEGaTBfYrGQoS3hK
        QRtvO1lKN82FFIK0oIkHJ4tjAGzuiFA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-x_JbRKOgNhWvCp0F1xewug-1; Mon, 04 Oct 2021 04:27:46 -0400
X-MC-Unique: x_JbRKOgNhWvCp0F1xewug-1
Received: by mail-ed1-f70.google.com with SMTP id w8-20020a50c448000000b003dae8d38037so3350349edf.8
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 01:27:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wK7iVG3X5Nkn6FIFB80ZzMQZFdwyjX+qi6LS3TDFA2s=;
        b=579eh0WG0MGlbuDIv9X9cS9Vn6sic7+8rvtx3q6dyg/kLsdIH0aY2QBndW1RZlMIbW
         ZSCaN3OnApM0idcP7aL1apbHUDqtmG43H44T7Gkzqm0aN+nIbqKkNDvDADDz7qRVkIkQ
         zrPxn8WzPsSvc37ewUiz/S4FJf/6yeKRLhNYMcTF6FjP6/Wdlxo8RVcZ5Xgmp+EdyTWF
         qOV6snvdolRtxj9ngOV6KJ/oc2NG3RQi6WsPlFUh7W8FWzi4LMFzDMsszPdXCxoOFU3u
         mp7r8SPk2eEaiigvoz0E/6dn45uikVCGL7LRMUtYzBO88evgaTkM8w5wFycz3Vvs8nzJ
         8C+w==
X-Gm-Message-State: AOAM531MA08I71YzTOlc+88RchRToxrcW3zlEpnuY+aXZinfCdTnphbT
        FzcqUgYFVjZdZpj8SkJ4Ian+nZj3Zvk7tkOF62GHiLM0jRbJo90gQn8UiVZogMSlqUxMTgKlYG4
        RwbpwidIdFg+F
X-Received: by 2002:aa7:d2c7:: with SMTP id k7mr1317907edr.184.1633336065234;
        Mon, 04 Oct 2021 01:27:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwY02lVJBnKorGLl2PWBGTR1dEDE4AxRdfvtnJ4jf+oajyjVLgkM26STSJKrSxd7qx0g45HnA==
X-Received: by 2002:aa7:d2c7:: with SMTP id k7mr1317888edr.184.1633336065018;
        Mon, 04 Oct 2021 01:27:45 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i6sm6128749ejd.57.2021.10.04.01.27.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 01:27:44 -0700 (PDT)
Message-ID: <420639d4-7608-acbe-4a7f-db164ec2f7a5@redhat.com>
Date:   Mon, 4 Oct 2021 10:27:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 00/22] target/i386/sev: Housekeeping SEV + measured
 Linux SEV guest
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        Sergio Lopez <slp@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211002125317.3418648-1-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/21 14:52, Philippe Mathieu-Daudé wrote:
> Hi,
> 
> While testing James & Dov patch:
> https://www.mail-archive.com/qemu-devel@nongnu.org/msg810571.html
> I wasted some time trying to figure out how OVMF was supposed to
> behave until realizing the binary I was using was built without SEV
> support... Then wrote this series to help other developers to not
> hit the same problem.
> 
> Since v2:
> - Rebased on top of SGX
> - Addressed review comments from Markus / David
> - Included/rebased 'Measured Linux SEV guest' from Dov [1]
> - Added orphean MAINTAINERS section

I have queued Dov's patches already, but apart from that the changes 
from v3 to v4 should be minimal.

Thanks for this work!

Paolo

> [1] https://lore.kernel.org/qemu-devel/20210825073538.959525-1-dovmurik@linux.ibm.com/
> 
> Supersedes: <20210616204328.2611406-1-philmd@redhat.com>
> 
> Dov Murik (2):
>    sev/i386: Introduce sev_add_kernel_loader_hashes for measured linux
>      boot
>    x86/sev: generate SEV kernel loader hashes in x86_load_linux
> 
> Dr. David Alan Gilbert (1):
>    target/i386/sev: sev_get_attestation_report use g_autofree
> 
> Philippe Mathieu-Daudé (19):
>    qapi/misc-target: Wrap long 'SEV Attestation Report' long lines
>    qapi/misc-target: Group SEV QAPI definitions
>    target/i386/kvm: Introduce i386_softmmu_kvm Meson source set
>    target/i386/kvm: Restrict SEV stubs to x86 architecture
>    target/i386/monitor: Return QMP error when SEV is disabled in build
>    target/i386/cpu: Add missing 'qapi/error.h' header
>    target/i386/sev_i386.h: Remove unused headers
>    target/i386/sev: Remove sev_get_me_mask()
>    target/i386/sev: Mark unreachable code with g_assert_not_reached()
>    target/i386/sev: Restrict SEV to system emulation
>    target/i386/sev: Declare system-specific functions in 'sev_i386.h'
>    target/i386/sev: Remove stubs by using code elision
>    target/i386/sev: Move qmp_query_sev_attestation_report() to sev.c
>    target/i386/sev: Move qmp_sev_inject_launch_secret() to sev.c
>    target/i386/sev: Move qmp_query_sev_capabilities() to sev.c
>    target/i386/sev: Move qmp_query_sev_launch_measure() to sev.c
>    target/i386/sev: Move qmp_query_sev() & hmp_info_sev() to sev.c
>    monitor: Restrict 'info sev' to x86 targets
>    MAINTAINERS: Cover AMD SEV files
> 
>   qapi/misc-target.json                 |  77 ++++----
>   include/monitor/hmp-target.h          |   1 +
>   include/monitor/hmp.h                 |   1 -
>   include/sysemu/sev.h                  |  20 +-
>   target/i386/sev_i386.h                |  32 +--
>   hw/i386/pc_sysfw.c                    |   2 +-
>   hw/i386/x86.c                         |  25 ++-
>   target/i386/cpu.c                     |  17 +-
>   {accel => target/i386}/kvm/sev-stub.c |   0
>   target/i386/monitor.c                 |  92 +--------
>   target/i386/sev-stub.c                |  83 --------
>   target/i386/sev-sysemu-stub.c         |  70 +++++++
>   target/i386/sev.c                     | 268 +++++++++++++++++++++++---
>   MAINTAINERS                           |   7 +
>   accel/kvm/meson.build                 |   1 -
>   target/i386/kvm/meson.build           |   8 +-
>   target/i386/meson.build               |   4 +-
>   17 files changed, 438 insertions(+), 270 deletions(-)
>   rename {accel => target/i386}/kvm/sev-stub.c (100%)
>   delete mode 100644 target/i386/sev-stub.c
>   create mode 100644 target/i386/sev-sysemu-stub.c
> 

