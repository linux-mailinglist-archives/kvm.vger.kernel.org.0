Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F921AB57C
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 03:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730973AbgDPB1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 21:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730752AbgDPB1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 21:27:25 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB79C061A0C
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 18:27:24 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id m16so743012pls.4
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 18:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=19sNrjtwUCDd/A01D/K/znp/2WHCGFixXS5o/L36eLc=;
        b=mYjNdxbe4jc1QQg5TZVmo7VoZispskCNF/eNGXEG/n/T+mN+ryPwWdxdoIy44OsNhR
         8PX0E7vEFYduQAUEX8mG0xz5x4fhxMKzvn7ZZOAxBLdWx1qMAlNjtsphiE6fSArvgk4P
         tSlYmUzWRYszfAG7LTMx56oq3OIMxZlqZfW0F2tZUtAkFfIC/qmVVSYI3VUL2qc9dpKE
         Yb63QqjJk4i/t+1Hh+ZQDTUmkA4qqS3SSf+Tf57OYcrWRa3kEqXO76HnQJcM5/nuSKkf
         pR4O/frTIwIIa2W3HAW/Mc573eqaUrDN5SigkNYjQM6mXFr6HgRU3+1RI/0LFPUf9Ro2
         TxoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=19sNrjtwUCDd/A01D/K/znp/2WHCGFixXS5o/L36eLc=;
        b=QNq5PspQ0f9X8fl5ICZrjWXA/A1b9aigkF4aQAuhKb29zEHhbNOlVBidqHVZsohTd8
         lqKgh/g9SjePcMthFjQIZZHnQKAQqbYT5XnvxzUxfevhoUt3cFk4PtIDstu31uBMsGGY
         gSdK3QAR3NKurEzCossRffKsVpUA7JoGRWjHpL4l8fSCqhXphixUHcKUwfqKflnO6Nb5
         1epJhZ7zSt7IDGdKEGq8jRCImVgL+zacjSX550sf8l9pFQDUnWXt2OPRtcD2Hby0HEL0
         XmDC0rls9E+3UdlaU2ekKkMoCtQyVtj+UWxmIsRmEMxjwx3cIpiX8VmD/nQVZ4+uErWT
         14oQ==
X-Gm-Message-State: AGi0PuZABkXs0rLaadjRCpn7wAPX+FTRTR5Wi7PdIKjSRHzTbTu5waex
        O9sFxTCe1mnwpCxP2yMDuzIwd0hI3Rg=
X-Google-Smtp-Source: APiQypI82XkTAv/ONqCVa/5PRcuxrE6sAj82YUvQw/jOI4xpQmqhwKwQeTKw1YOsNOkCFJDriV6WSw==
X-Received: by 2002:a17:902:9042:: with SMTP id w2mr7704116plz.127.1587000443451;
        Wed, 15 Apr 2020 18:27:23 -0700 (PDT)
Received: from [192.168.10.94] (124-171-87-207.dyn.iinet.net.au. [124.171.87.207])
        by smtp.gmail.com with ESMTPSA id a17sm329660pfn.211.2020.04.15.18.27.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 18:27:22 -0700 (PDT)
Subject: Re: [PATCH kernel v2 0/7] powerpc/powenv/ioda: Allow huge DMA window
 at 4GB
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        Alistair Popple <alistair@popple.id.au>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Oliver <oohall@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>
References: <20200323075354.93825-1-aik@ozlabs.ru>
 <b512ac5e-dca5-4c08-8ea1-a636b887c0d0@ozlabs.ru>
Autocrypt: addr=aik@ozlabs.ru; keydata=
 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
Message-ID: <d5cac37a-8b32-cabf-e247-10e64f0110ab@ozlabs.ru>
Date:   Thu, 16 Apr 2020 11:27:17 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <b512ac5e-dca5-4c08-8ea1-a636b887c0d0@ozlabs.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Anyone? Is it totally useless or wrong approach? Thanks,


On 08/04/2020 19:43, Alexey Kardashevskiy wrote:
> 
> 
> On 23/03/2020 18:53, Alexey Kardashevskiy wrote:
>> Here is an attempt to support bigger DMA space for devices
>> supporting DMA masks less than 59 bits (GPUs come into mind
>> first). POWER9 PHBs have an option to map 2 windows at 0
>> and select a windows based on DMA address being below or above
>> 4GB.
>>
>> This adds the "iommu=iommu_bypass" kernel parameter and
>> supports VFIO+pseries machine - current this requires telling
>> upstream+unmodified QEMU about this via
>> -global spapr-pci-host-bridge.dma64_win_addr=0x100000000
>> or per-phb property. 4/4 advertises the new option but
>> there is no automation around it in QEMU (should it be?).
>>
>> For now it is either 1<<59 or 4GB mode; dynamic switching is
>> not supported (could be via sysfs).
>>
>> This is a rebased version of
>> https://lore.kernel.org/kvm/20191202015953.127902-1-aik@ozlabs.ru/
>>
>> The main change since v1 is that now it is 7 patches with
>> clearer separation of steps.
>>
>>
>> This is based on 6c90b86a745a "Merge tag 'mmc-v5.6-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/ulfh/mmc"
>>
>> Please comment. Thanks.
> 
> Ping?
> 
> 
>>
>>
>>
>> Alexey Kardashevskiy (7):
>>   powerpc/powernv/ioda: Move TCE bypass base to PE
>>   powerpc/powernv/ioda: Rework for huge DMA window at 4GB
>>   powerpc/powernv/ioda: Allow smaller TCE table levels
>>   powerpc/powernv/phb4: Use IOMMU instead of bypassing
>>   powerpc/iommu: Add a window number to
>>     iommu_table_group_ops::get_table_size
>>   powerpc/powernv/phb4: Add 4GB IOMMU bypass mode
>>   vfio/spapr_tce: Advertise and allow a huge DMA windows at 4GB
>>
>>  arch/powerpc/include/asm/iommu.h              |   3 +
>>  arch/powerpc/include/asm/opal-api.h           |   9 +-
>>  arch/powerpc/include/asm/opal.h               |   2 +
>>  arch/powerpc/platforms/powernv/pci.h          |   4 +-
>>  include/uapi/linux/vfio.h                     |   2 +
>>  arch/powerpc/platforms/powernv/npu-dma.c      |   1 +
>>  arch/powerpc/platforms/powernv/opal-call.c    |   2 +
>>  arch/powerpc/platforms/powernv/pci-ioda-tce.c |   4 +-
>>  arch/powerpc/platforms/powernv/pci-ioda.c     | 234 ++++++++++++++----
>>  drivers/vfio/vfio_iommu_spapr_tce.c           |  17 +-
>>  10 files changed, 213 insertions(+), 65 deletions(-)
>>
> 

-- 
Alexey
