Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F2E320BEE
	for <lists+kvm@lfdr.de>; Sun, 21 Feb 2021 18:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhBURI2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Feb 2021 12:08:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55506 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230060AbhBURIW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 21 Feb 2021 12:08:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613927214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qxxxo+Cy9kESrt27fv9A3+kiw9hw+4IOipfKR/JRLTg=;
        b=ZHcAPvLbtv2vSR3Z42IUXNbp0IqbDK6sXFcvvvZpOWayQj4ZzFhZbPhv/O+pER1GGzstMp
        bMLzLl9sEYN5YuSEUNJ96kqkoxyUFnny1VtYu/kqMywAlsTm4jAgrOB64EoYdgagiVSGYk
        tXcMju09W2d1dQEU+MsA9s8T9BYmau0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-adnsskRXOpWJVJ7--jf0EQ-1; Sun, 21 Feb 2021 12:06:52 -0500
X-MC-Unique: adnsskRXOpWJVJ7--jf0EQ-1
Received: by mail-wr1-f71.google.com with SMTP id c9so4992962wrq.18
        for <kvm@vger.kernel.org>; Sun, 21 Feb 2021 09:06:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qxxxo+Cy9kESrt27fv9A3+kiw9hw+4IOipfKR/JRLTg=;
        b=KbQeZ9TSNgcbIaE6GdZhxqa0J5G40wt63/yS6Kv/gmVNBinToN+jr3M18vF04/4WFk
         Ts8Z1FISrKRfAKenK8pfkt3GE0lx+jgL64TUiAMIOtxGF8+t2YdInJ2tV0S4JUwmrr7F
         DaEiOvVdpCBbnvA33S7B3SMA03Vch6EWfm6K3wgYhRj9v/bjtdFarMjwDc9htuQkOEYT
         +RfPNMhGqaywSee8pcQw1bUyb8Km0o0UrxCIs+pIwU2gb/OV0UCr0ZwJTPWUoM7wKF0T
         puww0SsfDoCoNkYKO9uBhuohK0sl91LdGWoxWo2i9odyilEMlCSJdfWBSQjCf8nzwV/+
         NsJw==
X-Gm-Message-State: AOAM533CY/vwIwUaj/Xi3n+la3sTfxu3gxuO/ZVHFOtVVgNRm9Y++7zG
        mrM7k20kq3Wk5KeD5Dpg+EwbLH7oD2XjjNK3Ap6fYjZxpetgRF7taCDm5e+7eNeVSU51S20ubMb
        QX2ZBrr0WQTKF
X-Received: by 2002:a1c:8005:: with SMTP id b5mr17030204wmd.130.1613927211774;
        Sun, 21 Feb 2021 09:06:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx9QIJnst3EfbCAjYi8KyjAPa3Kc30Zq3Ybs1M5PuHEXoNHanyj4BMN/RxaiSIFlVBfAHpERA==
X-Received: by 2002:a1c:8005:: with SMTP id b5mr17030191wmd.130.1613927211611;
        Sun, 21 Feb 2021 09:06:51 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t23sm2298544wmn.13.2021.02.21.09.06.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 09:06:51 -0800 (PST)
To:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, jasowang@redhat.com, mst@redhat.com,
        cohuck@redhat.com, john.levon@nutanix.com
References: <cover.1613828726.git.eafanasova@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC v3 0/5] Introduce MMIO/PIO dispatch file descriptors
 (ioregionfd)
Message-ID: <8fc8eae6-7bea-9333-47cb-e49cf86fa336@redhat.com>
Date:   Sun, 21 Feb 2021 18:06:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <cover.1613828726.git.eafanasova@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/02/21 13:04, Elena Afanasova wrote:
> This patchset introduces a KVM dispatch mechanism which can be used
> for handling MMIO/PIO accesses over file descriptors without returning
> from ioctl(KVM_RUN). This allows device emulation to run in another task
> separate from the vCPU task.
> 
> This is achieved through KVM vm ioctl for registering MMIO/PIO regions and
> a wire protocol that KVM uses to communicate with a task handling an
> MMIO/PIO access.
> 
> TODOs:
> * Implement KVM_EXIT_IOREGIONFD_FAILURE
> * Add non-x86 arch support
> * Add kvm-unittests
> * Flush waiters if ioregion is deleted

Hi ELena,

as a quick thing that jumped at me before starting the review, you 
should add a test for the new API in tools/testing/selftests/kvm, as 
well as documentation.  Ideally, patch 4 would also add a testcase that 
fails before and passes afterwards.

Also, does this work already with io_uring?

Paolo

> v3:
>   - add FAST_MMIO bus support
>   - add KVM_IOREGION_DEASSIGN flag
>   - rename kvm_ioregion read/write file descriptors
>   - split ioregionfd signal handling support into two patches
>   - move ioregion_interrupted flag to ioregion_ctx
>   - reorder ioregion_ctx fields
>   - rework complete_ioregion operations
>   - add signal handling support for crossing a page boundary case
>   - change wire protocol license
>   - fix ioregionfd state machine
>   - remove ioregionfd_cmd info and drop appropriate macros
>   - add comment on ioregionfd cmds/replies serialization
>   - drop kvm_io_bus_finish/prepare()
> 
> Elena Afanasova (5):
>    KVM: add initial support for KVM_SET_IOREGION
>    KVM: x86: add support for ioregionfd signal handling
>    KVM: implement wire protocol
>    KVM: add ioregionfd context
>    KVM: enforce NR_IOBUS_DEVS limit if kmemcg is disabled
> 
>   arch/x86/kvm/Kconfig          |   1 +
>   arch/x86/kvm/Makefile         |   1 +
>   arch/x86/kvm/vmx/vmx.c        |  40 ++-
>   arch/x86/kvm/x86.c            | 273 +++++++++++++++++-
>   include/linux/kvm_host.h      |  28 ++
>   include/uapi/linux/ioregion.h |  30 ++
>   include/uapi/linux/kvm.h      |  25 ++
>   virt/kvm/Kconfig              |   3 +
>   virt/kvm/eventfd.c            |  25 ++
>   virt/kvm/eventfd.h            |  14 +
>   virt/kvm/ioregion.c           | 529 ++++++++++++++++++++++++++++++++++
>   virt/kvm/ioregion.h           |  15 +
>   virt/kvm/kvm_main.c           |  36 ++-
>   13 files changed, 996 insertions(+), 24 deletions(-)
>   create mode 100644 include/uapi/linux/ioregion.h
>   create mode 100644 virt/kvm/eventfd.h
>   create mode 100644 virt/kvm/ioregion.c
>   create mode 100644 virt/kvm/ioregion.h
> 

