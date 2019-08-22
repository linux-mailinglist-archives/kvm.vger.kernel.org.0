Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5167E990CD
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 12:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732026AbfHVK2m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 06:28:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40392 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbfHVK2m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 06:28:42 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5DAF3859FB
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2019 10:28:41 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id i4so2985827wri.1
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2019 03:28:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4MfO4wwvQsCCexQFrhxhOuZM/VP4L6uDupwMAnNIvjU=;
        b=iH9NVFgEeacomHrps3YGrR9XLLzzPScB17T0ansiaagua0pKAiCePMlZK+Z4vgzVrZ
         xfnJH/d7AkrtARj7x/qb4BDBDdr/Ef31g83uc4xAWV9eEybpDDKFvvWKZz5RaAQNDY5C
         7MPg4oAuahu6enbxzPdmJbN4pNXl6aGJj68smAEa3kosedCE2ILONwqn5mTc4Q17t86L
         n1/vfN32Lrya7bc2sn4tTaZ4ZXH8guyZX5mxnKGMLMdvYq40GyealJzNmEVfbGray6ft
         OdCTq93/dqXGnFsxoL3OK6wWVJS7ITztZSQREe18YKW5DKSNYsq4F7ZV8zjzHJp0bQIy
         x1xQ==
X-Gm-Message-State: APjAAAVaQtSCfm+60E23tiQ74piW8kDAXEronfJ5tU4ZDbrYqiy+PJVD
        jfqq7aUSyHiOiVRcCfHQrz/d+gUYNE9gFKJUdMDQGYYRI69aX1dGMiIoLxW+G2X/bbFxnaJ7bGG
        A/LmghXe8Ea8O
X-Received: by 2002:adf:fe85:: with SMTP id l5mr43711679wrr.5.1566469719946;
        Thu, 22 Aug 2019 03:28:39 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzcchmnd2d+Q6n3bl7nL/gok1KRpj0qcau6QT0Jbp5sxK2tyfYxaGdUFQWwvZSt7nt5WzCiag==
X-Received: by 2002:adf:fe85:: with SMTP id l5mr43711646wrr.5.1566469719615;
        Thu, 22 Aug 2019 03:28:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:21b9:ff1f:a96c:9fb3? ([2001:b07:6468:f312:21b9:ff1f:a96c:9fb3])
        by smtp.gmail.com with ESMTPSA id o2sm3335221wmh.9.2019.08.22.03.28.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2019 03:28:39 -0700 (PDT)
Subject: Re: [PATCH v4 00/15] hw/i386/pc: Do not restrict the fw_cfg functions
 to the PC machine
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Samuel Ortiz <sameo@linux.intel.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Rob Bradford <robert.bradford@intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Yang Zhong <yang.zhong@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>
References: <20190818225414.22590-1-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9e7a5fa2-2bf7-f3fe-57d9-680498166bf9@redhat.com>
Date:   Thu, 22 Aug 2019 12:28:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190818225414.22590-1-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/08/19 00:53, Philippe Mathieu-Daudé wrote:
> Hi,
> 
> This is my take at salvaging some NEMU good work.
> Samuel worked in adding the fw_cfg device to the x86-virt NEMU machine.
> This series is inspired by NEMU's commit 3cb92d080835 [0] and adapted
> to upstream style. The result makes the upstream codebase more
> modularizable.
> There are very little logical changes, this is mostly a cleanup
> refactor.
> 
> Since v3 [3]:
> - Addressed Christophe suggestion (patch #8)
> - Rebased patch #15 since Eduardo merged Like Xu's work between.
> 
> Since v2 [2]:
> - Addressed MST comments from v2 (only patch #2 modified)
>   - do not use unsigned for enum
>   - do not add unuseful documentation
> 
> Since v1 [1]:
> - Addressed Li and MST comments
> 
> $ git backport-diff -u v3
> Key:
> [----] : patches are identical
> [####] : number of functional differences between upstream/downstream patch
> [down] : patch is downstream-only
> The flags [FC] indicate (F)unctional and (C)ontextual differences, respectively
> 
> 001/15:[----] [--] 'hw/i386/pc: Use e820_get_num_entries() to access e820_entries'
> 002/15:[----] [-C] 'hw/i386/pc: Extract e820 memory layout code'
> 003/15:[----] [--] 'hw/i386/pc: Use address_space_memory in place'
> 004/15:[----] [-C] 'hw/i386/pc: Rename bochs_bios_init as more generic fw_cfg_arch_create'
> 005/15:[----] [--] 'hw/i386/pc: Pass the boot_cpus value by argument'
> 006/15:[----] [--] 'hw/i386/pc: Pass the apic_id_limit value by argument'
> 007/15:[0002] [FC] 'hw/i386/pc: Pass the CPUArchIdList array by argument'
> 008/15:[down] 'hw/i386/pc: Remove unused PCMachineState argument in fw_cfg_arch_create'
> 009/15:[----] [-C] 'hw/i386/pc: Let pc_build_smbios() take a FWCfgState argument'
> 010/15:[----] [-C] 'hw/i386/pc: Let pc_build_smbios() take a generic MachineState argument'
> 011/15:[----] [-C] 'hw/i386/pc: Rename pc_build_smbios() as generic fw_cfg_build_smbios()'
> 012/15:[----] [--] 'hw/i386/pc: Let pc_build_feature_control() take a FWCfgState argument'
> 013/15:[----] [--] 'hw/i386/pc: Let pc_build_feature_control() take a MachineState argument'
> 014/15:[----] [--] 'hw/i386/pc: Rename pc_build_feature_control() as generic fw_cfg_build_*'
> 015/15:[0017] [FC] 'hw/i386/pc: Extract the x86 generic fw_cfg code'
> 
> Regards,
> 
> Phil.
> 
> [0] https://github.com/intel/nemu/commit/3cb92d080835ac8d47c8b713156338afa33cff5c
> [1] https://lists.gnu.org/archive/html/qemu-devel/2019-05/msg05759.html
> [2] https://lists.gnu.org/archive/html/qemu-devel/2019-06/msg02786.html
> [3] https://lists.gnu.org/archive/html/qemu-devel/2019-07/msg00193.html
> 
> Philippe Mathieu-Daudé (15):
>   hw/i386/pc: Use e820_get_num_entries() to access e820_entries
>   hw/i386/pc: Extract e820 memory layout code
>   hw/i386/pc: Use address_space_memory in place
>   hw/i386/pc: Rename bochs_bios_init as more generic fw_cfg_arch_create
>   hw/i386/pc: Pass the boot_cpus value by argument
>   hw/i386/pc: Pass the apic_id_limit value by argument
>   hw/i386/pc: Pass the CPUArchIdList array by argument
>   hw/i386/pc: Remove unused PCMachineState argument in
>     fw_cfg_arch_create
>   hw/i386/pc: Let pc_build_smbios() take a FWCfgState argument
>   hw/i386/pc: Let pc_build_smbios() take a generic MachineState argument
>   hw/i386/pc: Rename pc_build_smbios() as generic fw_cfg_build_smbios()
>   hw/i386/pc: Let pc_build_feature_control() take a FWCfgState argument
>   hw/i386/pc: Let pc_build_feature_control() take a MachineState
>     argument
>   hw/i386/pc: Rename pc_build_feature_control() as generic
>     fw_cfg_build_*
>   hw/i386/pc: Extract the x86 generic fw_cfg code
> 
>  hw/i386/Makefile.objs        |   2 +-
>  hw/i386/e820_memory_layout.c |  59 ++++++++++
>  hw/i386/e820_memory_layout.h |  42 ++++++++
>  hw/i386/fw_cfg.c             | 136 +++++++++++++++++++++++
>  hw/i386/fw_cfg.h             |   7 ++
>  hw/i386/pc.c                 | 202 ++---------------------------------
>  include/hw/i386/pc.h         |  11 --
>  target/i386/kvm.c            |   1 +
>  8 files changed, 254 insertions(+), 206 deletions(-)
>  create mode 100644 hw/i386/e820_memory_layout.c
>  create mode 100644 hw/i386/e820_memory_layout.h
> 

Queued, thanks.

Paolo
