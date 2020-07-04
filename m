Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03D52148CD
	for <lists+kvm@lfdr.de>; Sat,  4 Jul 2020 23:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgGDVEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Jul 2020 17:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbgGDVEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Jul 2020 17:04:01 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93AE8C061794
        for <kvm@vger.kernel.org>; Sat,  4 Jul 2020 14:04:01 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id u25so20470658lfm.1
        for <kvm@vger.kernel.org>; Sat, 04 Jul 2020 14:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=tS0/KvgERWPgo/ZAOXzeYZWTt3sAuY++7Ugk00AieWY=;
        b=MkdaQdr+PD78uFEQ6l/ViMELxuiZwghAaJUlYwnsZwIN5ksOlC5OPY04SAYE9jH3RL
         1zGRMgAaezn8yOHJVlAbRx6GQurcsz2KOSc4DagzYj6tiB+1hYJbJSUFj4prrpevfQ1M
         dB1NOmn3oExc9GIMwRk3qiSbcVrkFvAWaRKQaBL8yCY7wkveFwaRALTNeNIGiArvqTaf
         9tQxd8gz3PDLX7w8Pr2yZ9Mp4F2GjDkTQbEp+AjHnpDcc/qCzAFR8vokSUVSFPPtdIr2
         noWHiGx0U0roXTZW5pkW17HoziVDq0LxOBZ2Y6HBt2Wds4SEJOeAAyeKrXG8bGZnswl9
         jyzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=tS0/KvgERWPgo/ZAOXzeYZWTt3sAuY++7Ugk00AieWY=;
        b=jd0mMpcOxcyobWLFtzZOH2JgSW6nN1Xjp/lYpyD0Ug3ufPiYHuz9uUd6B64exODdr3
         bjoZZumuQ4NCGc1spkreVRr3vlH1krOurD36VMGppmF12hg3aqVjXb0uf5sfxSfWUuVb
         YtSROfP5msrRJd7uh8HbmcluruLek6EAl1Yi/BfBBljllwvKFcbk7lpfjJdU9gMD1q/E
         J2ms6Gn6h731Oc0Z2l9wEnwRTNzK0uhggiCgZvm0oII6nky9U5p86gyA1zbDfcG++3dW
         o7w1j7AD5vw2KuFU03YkWoRGNDP+IlWvVQ6RvpUYUSTYdYv0UMB6J0ag1XXJpy3+UfoA
         EFZg==
X-Gm-Message-State: AOAM5337DHyMnNoa5O1mpigk3WPxlMe89DLNfxyNjgdsurIloTlDr/Cp
        2JbVkvVnRgXjXHgm4wcxVzc=
X-Google-Smtp-Source: ABdhPJxD82MXjC8BOUGOduJVJygwzOqUJ5oJa4yT/er02x0HQX39/CrgKcwlR0aLxZnsemUvvq5IsA==
X-Received: by 2002:a19:6c6:: with SMTP id 189mr25418733lfg.94.1593896639073;
        Sat, 04 Jul 2020 14:03:59 -0700 (PDT)
Received: from [192.168.0.201] ([78.156.12.4])
        by smtp.gmail.com with ESMTPSA id d2sm6941031lfq.79.2020.07.04.14.03.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jul 2020 14:03:58 -0700 (PDT)
To:     alex.williamson@redhat.com, kvm@vger.kernel.org,
        pbonzini@redhat.com, jeyu@kernel.org
From:   Gunnar Eggen <geggen54@gmail.com>
Subject: KVM/VFIO passthrough not working when TRIM_UNUSED_KSYMS is enabled
Message-ID: <13e90f87-9062-a7e4-99c0-5c6f5c16cad2@gmail.com>
Date:   Sat, 4 Jul 2020 23:03:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: nb-NO
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

It's a bit unclear what subsystem is to blame for this problem, so I'm 
sending this to both KVM, VFIO and Module support.

The problem is that trimming unused symbols in the kernel breaks VFIO 
passthrough on x86/amd64 at least. If the option TRIM_UNUSED_KSYMS is 
enabled you will see the following error when trying to start a VM in 
QEmu with any pcie device passed via VFIO:

qemu-system-x86_64: -device vfio-pci,host=04:00.0: Failed to add group 
25 to KVM VFIO device: Invalid argument

The error will not stop the VM from launching, but it will break things 
in mysterious ways when e.g. installing graphics drivers.
No external modules is involved in this, so I would guess that there is 
some dependency that the trimming is missing in some way.

With the introduction of UNUSED_KSYMS_WHITELIST in the latest kernels, 
and some talk about making trimming symbols the default in the future, 
it would be great if we could get this fixed or at least identify the 
problematic symbols so that they could be whitelisted if needed.

Steps to reproduce:

1 - Have a kernel where TRIM_UNUSED_KSYMS is enabled
2 - Start a VM in QEmu/KVM with a pcie device passed through via vfio-pci

This is a common issue that keeps popping up on user forums related to 
vfio passthrough, so it should be fairly simple to reproduce.

Let me know if you want more details or perhaps my kernel config or 
trimmed system map to test with.

Best regards,
Gunnar

