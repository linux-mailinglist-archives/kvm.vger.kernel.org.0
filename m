Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAAD53ED8C3
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 16:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbhHPOQY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 10:16:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46435 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232164AbhHPOQX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 10:16:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629123351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wOn24gv5e1xoPCk04ah2Ne2U0/ni1ZgUlD/hdOrggBQ=;
        b=EgU4rPoXkN4n/HmSorsVjzonM19tUy0PTnimiPbBlnPxZaPGMgQQPQ0Fjx99IRnUmJH490
        tb8Ihwe+u+RMPb9/ChQCuoHO5624gy5oio+n0qzOOiOQPmb0D6+uH3HYwgVooG6qcwUkUE
        s2ZVcTX3D5T+21tgS7Vbsh0Tw6XY1hg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-42FixmG4P4aSqBYDo9h6-A-1; Mon, 16 Aug 2021 10:15:50 -0400
X-MC-Unique: 42FixmG4P4aSqBYDo9h6-A-1
Received: by mail-ed1-f69.google.com with SMTP id e3-20020a50ec830000b02903be5be2fc73so8862550edr.16
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 07:15:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wOn24gv5e1xoPCk04ah2Ne2U0/ni1ZgUlD/hdOrggBQ=;
        b=KSx7/3luDrNv5RaqUOsXBBY0H1mjtv3+EFZUrOhrWeg3gqbFdZNr4AULdvgSLgKAaD
         5iiojSr2ix4vTaRnbInfXNBfeIgoQRmSISBGzWrbPoGEpiJXoksLH/m6YX/YyBPyiUsC
         Fp6xIKgfczi3tjsWnFcieqjU+9/RpokcxjvZqGwnCDYoTy+7yCxEj3EUQonnFMT+BkMQ
         6LKriGohvcxiozgm5GkiScwqjwKZ+k1Xv/UpdPxg2Kwz3oFjQ+XuOiJYP3IZbQL4YEDw
         EfVgJISbfIbltfhOPDAIL6HFT1N9qwT+BjiM6UlVyo50WWTH6GN6ZAW7CFvDKPhMKRNU
         bwFg==
X-Gm-Message-State: AOAM530Br+Bw+dRiZDTDoCJsgU4TgUbVq49oI4mGOMtkYey0nfEhITOv
        LAvVHJn24amKPwymU6D5LTnHiREY7P5Rl7ya0pqFMBQBQhBIfQSDaG9Fv1wHFpR0uXGdryjnJ05
        Oq7+VXudAB/DxsFbbQfWUJCuSdqdtH8c7mVEwb1RJYiBQhmz3uujQMOzUdbGCWSXd
X-Received: by 2002:a17:906:3bc3:: with SMTP id v3mr16169614ejf.482.1629123348795;
        Mon, 16 Aug 2021 07:15:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxb5EmaR+mgEUjRJGcJI5nwJ5mNoC0z4vG5b/1TWnbaRlUpnXPhmAfE4J4X07o1IJpivTwMkw==
X-Received: by 2002:a17:906:3bc3:: with SMTP id v3mr16169582ejf.482.1629123348545;
        Mon, 16 Aug 2021 07:15:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id ay3sm3760956ejb.0.2021.08.16.07.15.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 07:15:48 -0700 (PDT)
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
To:     Ashish Kalra <Ashish.Kalra@amd.com>, qemu-devel@nongnu.org
Cc:     thomas.lendacky@amd.com, brijesh.singh@amd.com,
        ehabkost@redhat.com, mst@redhat.com, richard.henderson@linaro.org,
        jejb@linux.ibm.com, tobin@ibm.com, dovmurik@linux.vnet.ibm.com,
        frankeh@us.ibm.com, dgilbert@redhat.com, kvm@vger.kernel.org
References: <cover.1629118207.git.ashish.kalra@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fb737cf0-3d96-173f-333b-876dfd59d32b@redhat.com>
Date:   Mon, 16 Aug 2021 16:15:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cover.1629118207.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/08/21 15:25, Ashish Kalra wrote:
> From: Ashish Kalra<ashish.kalra@amd.com>
> 
> This is an RFC series for Mirror VM support that are
> essentially secondary VMs sharing the encryption context
> (ASID) with a primary VM. The patch-set creates a new
> VM and shares the primary VM's encryption context
> with it using the KVM_CAP_VM_COPY_ENC_CONTEXT_FROM capability.
> The mirror VM uses a separate pair of VM + vCPU file
> descriptors and also uses a simplified KVM run loop,
> for example, it does not support any interrupt vmexit's. etc.
> Currently the mirror VM shares the address space of the
> primary VM.
> 
> The mirror VM can be used for running an in-guest migration
> helper (MH). It also might have future uses for other in-guest
> operations.

Hi,

first of all, thanks for posting this work and starting the discussion.

However, I am not sure if the in-guest migration helper vCPUs should use 
the existing KVM support code.  For example, they probably can just 
always work with host CPUID (copied directly from 
KVM_GET_SUPPORTED_CPUID), and they do not need to interface with QEMU's 
MMIO logic.  They would just sit on a "HLT" instruction and communicate 
with the main migration loop using some kind of standardized ring buffer 
protocol; the migration loop then executes KVM_RUN in order to start the 
processing of pages, and expects a KVM_EXIT_HLT when the VM has nothing 
to do or requires processing on the host.

The migration helper can then also use its own address space, for 
example operating directly on ram_addr_t values with the helper running 
at very high virtual addresses.  Migration code can use a 
RAMBlockNotifier to invoke KVM_SET_USER_MEMORY_REGION on the mirror VM 
(and never enable dirty memory logging on the mirror VM, too, which has 
better performance).

With this implementation, the number of mirror vCPUs does not even have 
to be indicated on the command line.  The VM and its vCPUs can simply be 
created when migration starts.  In the SEV-ES case, the guest can even 
provide the VMSA that starts the migration helper.

The disadvantage is that, as you point out, in the future some of the 
infrastructure you introduce might be useful for VMPL0 operation on 
SEV-SNP.  My proposal above might require some code duplication. 
However, it might even be that VMPL0 operation works best with a model 
more similar to my sketch of the migration helper; it's really too early 
to say.

Paolo

