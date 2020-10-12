Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8348728B071
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 10:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgJLIjs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 04:39:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47231 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727393AbgJLIjp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Oct 2020 04:39:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602491983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y3RMpkzwbs4gYYxerAWpVUyUaKh3PAp9tJ4OZPN0XNc=;
        b=eg4JahuxAuhqw99WMV4fa9clgrz5GObv5LT0jOwcndNtSFA+fSjedYzu3Gafex1efwqGbP
        KbTlZN3K5rboAJowy0VhLfoLp9IOQgNOp/rRSepgEYZrvdmGRrJvxASIW90RDP7aeVmPdj
        n6DzqqczP+gJPrMr65FjVmrGakKaAQw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-iDm2fP_ZPMGQvwidmEByhg-1; Mon, 12 Oct 2020 04:39:41 -0400
X-MC-Unique: iDm2fP_ZPMGQvwidmEByhg-1
Received: by mail-ed1-f70.google.com with SMTP id dc23so6368356edb.13
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 01:39:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=y3RMpkzwbs4gYYxerAWpVUyUaKh3PAp9tJ4OZPN0XNc=;
        b=QJJHEqMtq9hWoaPEzGSPdBYw3fT1CoItatGWN+5G/g42SN4sc41DMdKpsmEmqTBwIq
         /7L+bkw/bS1aRD6kfsuks26VzeABysU+4ngG7QdUOvrQI9ov19y9KfoX5p8Lz93Ezoxb
         7khBrlVTtQJxVogDQyq4p4N6xc3/eiyKinoA8toryacxyDhaxp10SHMlyCa9Jkb8Dtl/
         Y3v132R8SUrGp5mUnH2oBdsg28rJ3l5yh5ew3wW7O0u4OQ2UuxsMTxu2ZxAxJttwzf43
         C29CwDSaDbm7KWH1m/726WBXJTlbAcyepu7w23Fsv5AthcNPynIc7PAg72b5yTmnVcAJ
         fmoA==
X-Gm-Message-State: AOAM530UwWCetIlsx4eRRfzog2q3WBQRaEFTn/AdkuLKxHYNc8JExE/N
        Xk4wQYKZNI7qGe82Ppv4dnqkO9q0X5HZR0Z/p2vqGsydpj83fxRrEdXOqpmIXA8zv9bvK5M5Tus
        oIgfc4B5IGem7
X-Received: by 2002:aa7:d7ce:: with SMTP id e14mr13553944eds.258.1602491979763;
        Mon, 12 Oct 2020 01:39:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUy1ps24iRo7L+BxM/joct4u9wwg9Ic4AXkut+5FgbTiF6Rd5bXkh7IAxHsgcdzotsN3VScA==
X-Received: by 2002:aa7:d7ce:: with SMTP id e14mr13553926eds.258.1602491979523;
        Mon, 12 Oct 2020 01:39:39 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u2sm9893889edr.70.2020.10.12.01.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 01:39:38 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] KVM: x86: hyper-v: make KVM_GET_SUPPORTED_HV_CPUID more useful
In-Reply-To: <20200929150944.1235688-1-vkuznets@redhat.com>
References: <20200929150944.1235688-1-vkuznets@redhat.com>
Date:   Mon, 12 Oct 2020 10:39:38 +0200
Message-ID: <871ri37s8l.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Changes since v2:
> - Keep vCPU version of the ioctl intact but make it 'deprecated' in
>   api.rst [Paolo Bonzini]
> - First two patches of v2 series already made it to kvm/queue
>
> QEMU series using the feature:
> https://lists.gnu.org/archive/html/qemu-devel/2020-09/msg02017.html
>
> Original description:
>
> KVM_GET_SUPPORTED_HV_CPUID was initially implemented as a vCPU ioctl but
> this is not very useful when VMM is just trying to query which Hyper-V
> features are supported by the host prior to creating VM/vCPUs. The data
> in KVM_GET_SUPPORTED_HV_CPUID is mostly static with a few exceptions but
> it seems we can change this. Add support for KVM_GET_SUPPORTED_HV_CPUID as
> a system ioctl as well.
>
> QEMU specific description:
> In some cases QEMU needs to collect the information about which Hyper-V
> features are supported by KVM and pass it up the stack. For non-hyper-v
> features this is done with system-wide KVM_GET_SUPPORTED_CPUID/
> KVM_GET_MSRS ioctls but Hyper-V specific features don't get in the output
> (as Hyper-V CPUIDs intersect with KVM's). In QEMU, CPU feature expansion
> happens before any KVM vcpus are created so KVM_GET_SUPPORTED_HV_CPUID
> can't be used in its current shape.
>
> Vitaly Kuznetsov (2):
>   KVM: x86: hyper-v: allow KVM_GET_SUPPORTED_HV_CPUID as a system ioctl
>   KVM: selftests: test KVM_GET_SUPPORTED_HV_CPUID as a system ioctl
>
>  Documentation/virt/kvm/api.rst                | 16 ++--
>  arch/x86/kvm/hyperv.c                         |  6 +-
>  arch/x86/kvm/hyperv.h                         |  4 +-
>  arch/x86/kvm/vmx/evmcs.c                      |  3 +-
>  arch/x86/kvm/x86.c                            | 45 ++++++----
>  include/uapi/linux/kvm.h                      |  3 +-
>  .../testing/selftests/kvm/include/kvm_util.h  |  2 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 26 ++++++
>  .../selftests/kvm/x86_64/hyperv_cpuid.c       | 87 +++++++++++--------
>  9 files changed, 123 insertions(+), 69 deletions(-)

Ping)

Still hoping this can be picked up for 5.10.

the latest QEMU patchset was posted last Friday:
https://lists.gnu.org/archive/html/qemu-devel/2020-10/msg02443.html

-- 
Vitaly

