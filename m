Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9318E436301
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 15:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbhJUNdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 09:33:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44392 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230119AbhJUNdj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 09:33:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634823080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f2NJd+VbfNniK2jTy0/N1Ob9cVJCijbx4W6nW6eHYl0=;
        b=RwYQl+nX/HkvCoIxCbWirYO20IOZSc7DEk7NaGSuReqaRt/u3ugq+7XT+VTZ3UkALDXjX8
        Tzd3E+DjoyC55QVgrYY300BD0G1b8CrmLGN0mVC+R3p+9r5PlU7iEw9VYI29NIFV8e1uj1
        779DwFVuwckmI60k+EGDfz91oRhzE2A=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-Gsfh1ldhONqPfKS7LTCPOQ-1; Thu, 21 Oct 2021 09:31:18 -0400
X-MC-Unique: Gsfh1ldhONqPfKS7LTCPOQ-1
Received: by mail-ed1-f69.google.com with SMTP id d11-20020a50cd4b000000b003da63711a8aso294489edj.20
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 06:31:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=f2NJd+VbfNniK2jTy0/N1Ob9cVJCijbx4W6nW6eHYl0=;
        b=tyVI+sw5WBxIcMGAeclmB9GBvubOkDll/uVi1ax5sGWcBOqEgOMedI8HRRbmtTQSAE
         J+/ygo2M+RTD3r+r+UhDdir2WQVOKRGEPo3WCAmnxaiI/DPsgwn+xEB1Rtm6yeGsc3MG
         jyoPCOfkkRfh83ZLOFEdmaiAe5fcOvKNuxoAcP4QwCpZ/aBZ/PFO5KHkTPtzXgQhEi0w
         7qcTm59QDwXUaDsBV6JwYNFjrHs+umkv+WRZrSRyupRkqICOTVEHLN5b25vu18JHqQ3B
         t7pVeoNVdK+ERzUj2N20Xs1AWocqZecW8pYSyCspMpQOn/v9cPTTuSRPE7E/EJ7PBu8R
         tbxw==
X-Gm-Message-State: AOAM530C5kifNl91BOTQtOvGeif2r1adE1Sg9H+A1z6ai6Wt9HAUK+iR
        M1VFF5bfwbPL5bqTTuqRXaX5fXztlduRFzuJa6Q1286+fuBkKgMnr/TeFoLB7fTQNcJw7J+JUnN
        O3lvt9rZWbJNX
X-Received: by 2002:a17:906:2850:: with SMTP id s16mr2861028ejc.399.1634823074317;
        Thu, 21 Oct 2021 06:31:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGPaNYzE3ltsmkVlvR4uwPvLPaMRdAndcrtbvh2WOqyaXdRj4escjcdMVRKIUNrZu0HDUnSQ==
X-Received: by 2002:a17:906:2850:: with SMTP id s16mr2861005ejc.399.1634823074121;
        Thu, 21 Oct 2021 06:31:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id m18sm2547921ejn.62.2021.10.21.06.31.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 06:31:13 -0700 (PDT)
Message-ID: <9bf5e6b9-6436-5a3c-6ed7-cbbc59b0fa2d@redhat.com>
Date:   Thu, 21 Oct 2021 15:31:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH v3 12/17] x86 AMD SEV: Initial support
Content-Language: en-US
To:     Zixuan Wang <zxwang42@gmail.com>, kvm@vger.kernel.org,
        drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
References: <20211004204931.1537823-1-zxwang42@gmail.com>
 <20211004204931.1537823-13-zxwang42@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211004204931.1537823-13-zxwang42@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/10/21 22:49, Zixuan Wang wrote:
> From: Zixuan Wang <zixuanwang@google.com>
> 
> AMD Secure Encrypted Virtualization (SEV) is a hardware accelerated
> memory encryption feature that protects guest VMs from host attacks.
> 
> This commit provides set up code and a test case for AMD SEV. The set up
> code checks if SEV is supported and enabled, and then sets SEV c-bit for
> each page table entry.
> 
> Co-developed-by: Hyunwook (Wooky) Baek <baekhw@google.com>
> Signed-off-by: Hyunwook (Wooky) Baek <baekhw@google.com>
> Signed-off-by: Zixuan Wang <zixuanwang@google.com>

Whee, it works!

qemu/qemu/build/qemu-system-x86_64 \
   -object sev-guest,id=sev0,cbitpos=47,reduced-phys-bits=1,policy=0x7 \
   -machine q35,memory-encryption=sev0 --no-reboot -nodefaults \
   -device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4 \
   -vnc none -serial stdio -device pci-testdev -machine accel=kvm \
   -drive file=/usr/share/edk2/ovmf/OVMF_CODE.cc.fd,format=raw,if=pflash \
   -drive file.dir=efi-tests/amd_sev/,file.driver=vvfat,file.rw=on,format=raw,if=virtio \
   -net none -nographic -smp 1 -m 256 --cpu EPYC-Rome

So the "magic" flags are

	-object sev-guest,id=sev0,cbitpos=47,reduced-phys-bits=1,policy=0x3
	-machine memory-encryption=sev0

Paolo

