Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFE6214B36
	for <lists+kvm@lfdr.de>; Sun,  5 Jul 2020 10:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgGEI6F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jul 2020 04:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgGEI6F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jul 2020 04:58:05 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1ED8C061794
        for <kvm@vger.kernel.org>; Sun,  5 Jul 2020 01:58:04 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id t25so37235839lji.12
        for <kvm@vger.kernel.org>; Sun, 05 Jul 2020 01:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=/5VEnt82qGjxCfGebdnrEM9NIXS3UlUoqgmZfQArlKE=;
        b=h0IUGyQt7NeulGotxltaoPB/hUkb7edbeFmUJQTS6gaD/GPWz72I03KC+6Qyy7a4tR
         h5440FnZRlj6iWtG+SL4yE8cYlawxkYMKbazofJbKMWW69vQIZaqRbn8P9rCzxH741hc
         8+JXk9UBCYYcmm0s1vw47krb1VHNr9SEnbAwGWHYl2t5IODnZWy0x2V2qJ4TEoiDKmtF
         OCEYOf/DQTPIA439LhZD4fXNHeJS6m1k3n857vAC+8XDSf4DZGdoXmXhDatYS7k6foiG
         iXKGQ9KY2cP8ZyaFM8wOp28c3yKvkJn/b3LrJWl5Y9IO4puNfz4vRXWKtE1gkBDuoc0x
         IgLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/5VEnt82qGjxCfGebdnrEM9NIXS3UlUoqgmZfQArlKE=;
        b=U8zwakBi7fMmWXZbGDR5Cn0vaVZxyHFbj/Y73qTq3OA5B7zcj/2bxWrhRxhtIBq5SF
         KhXzs1ek4BOauKj+pfHWzLnIdGegAM6xvDHlxmBEPe8ZbYAQBAhUgdbTpOr5YxRnsL0R
         ESYzB6fzSyTsWEm8OqjXhl7GzhP1TXsBqhAUynz37tMttbaGvTrRDNYBaJ97V6YedOfA
         oaa6xLbIPLekW/bwcZOunmckf+5WTsjK+hWzi8ZOs6Nz7aKkhPe5MFtA2bvG6jbgM/V0
         5xVO+h+8UlQFyd4ge/PViUc1vyhvq52diM49C/Fr3oVP2PNYX4Z1Dk1TAw8rLHsKKKcv
         TENA==
X-Gm-Message-State: AOAM533vS8IyCPjWuslwdLxkBJnxJd42Vk3RqB+m2Owvg6ilQowqpTRp
        CoYWDj+1biAnEyGE270P2pOhpiXtls4=
X-Google-Smtp-Source: ABdhPJwtltLy2xSWsnv8C23FW/ryO8C2k09ZlCClCM8eJAa13jU5y4m5Q+4qADSqhjTLckq+h9z+TA==
X-Received: by 2002:a2e:3914:: with SMTP id g20mr24094986lja.19.1593939483004;
        Sun, 05 Jul 2020 01:58:03 -0700 (PDT)
Received: from [192.168.0.201] ([78.156.12.4])
        by smtp.gmail.com with ESMTPSA id s1sm6337718ljj.96.2020.07.05.01.58.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 01:58:02 -0700 (PDT)
Subject: Re: KVM/VFIO passthrough not working when TRIM_UNUSED_KSYMS is
 enabled
To:     Paolo Bonzini <pbonzini@redhat.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org, jeyu@kernel.org
References: <13e90f87-9062-a7e4-99c0-5c6f5c16cad2@gmail.com>
 <a43675ef-197d-2bd5-9505-200ac439df6c@redhat.com>
From:   Gunnar Eggen <geggen54@gmail.com>
Message-ID: <9f12270c-9872-a061-3cfe-4986bb3bffc9@gmail.com>
Date:   Sun, 5 Jul 2020 10:58:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <a43675ef-197d-2bd5-9505-200ac439df6c@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: nb-NO
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Great! I can confirm that whitelisting the symbols you listed fixes the 
problem.

I hope we get a permanent solution for this eventually, but in the 
meantime we have a workaround.

Thanks so much!


On 05.07.2020 07:44, Paolo Bonzini wrote:
> On 04/07/20 23:03, Gunnar Eggen wrote:
>> Hi,
>>
>> It's a bit unclear what subsystem is to blame for this problem, so I'm
>> sending this to both KVM, VFIO and Module support.
>>
>> The problem is that trimming unused symbols in the kernel breaks VFIO
>> passthrough on x86/amd64 at least. If the option TRIM_UNUSED_KSYMS is
>> enabled you will see the following error when trying to start a VM in
>> QEmu with any pcie device passed via VFIO:
>>
>> qemu-system-x86_64: -device vfio-pci,host=04:00.0: Failed to add group
>> 25 to KVM VFIO device: Invalid argument
>>
>> The error will not stop the VM from launching, but it will break things
>> in mysterious ways when e.g. installing graphics drivers.
>> No external modules is involved in this, so I would guess that there is
>> some dependency that the trimming is missing in some way.
>>
>> With the introduction of UNUSED_KSYMS_WHITELIST in the latest kernels,
>> and some talk about making trimming symbols the default in the future,
>> it would be great if we could get this fixed or at least identify the
>> problematic symbols so that they could be whitelisted if needed.
> They are:
> - vfio_group_get_external_user
> - vfio_external_group_match_file
> - vfio_group_put_external_user
> - vfio_group_set_kvm
> - vfio_external_check_extension
> - vfio_external_user_iommu_id
>
> and also (unrelated but breaking other stuff):
> - mdev_get_iommu_device
> - mdev_bus_type
>
> However, UNUSED_KSYMS_WHITELIST seems the wrong tool for this.  We would
> need to have something that says: "if KVM && VFIO, then include these
> symbols", for example a macro "IMPORT_SYMBOL" that would be processed by
> cmd_undef_syms.
>
> Paolo
>
>> Steps to reproduce:
>>
>> 1 - Have a kernel where TRIM_UNUSED_KSYMS is enabled
>> 2 - Start a VM in QEmu/KVM with a pcie device passed through via vfio-pci
>>
>> This is a common issue that keeps popping up on user forums related to
>> vfio passthrough, so it should be fairly simple to reproduce.
>>
>> Let me know if you want more details or perhaps my kernel config or
>> trimmed system map to test with.
>>
>> Best regards,
>> Gunnar
>>
