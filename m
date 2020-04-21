Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC111B31D7
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 23:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgDUVWq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 17:22:46 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43943 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726116AbgDUVWq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Apr 2020 17:22:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587504164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j0OOdK3DXtQCBZ/bSdHvigSbjQLSkz9kPwFTn49a0go=;
        b=esvL0VK4p6EZsuZbv1Bs8TwcAmCjOuCtYQarhOZJCs2cTaSLT4Q4qkdD8cYUJ9RJntumNb
        ZcRBoEfZ7VWyY2Hqnu9ZOR9fsRvXRvpMn9Y+dlHM6/m+2R6IIZZIeQWfd1e1Ye3pEXgST+
        O2U+6v+btJed+OO959b5TH7wc6wS4/4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-2XU58S-OOU2wg2EnZtsieQ-1; Tue, 21 Apr 2020 17:22:43 -0400
X-MC-Unique: 2XU58S-OOU2wg2EnZtsieQ-1
Received: by mail-wr1-f70.google.com with SMTP id i10so8380153wrq.8
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 14:22:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j0OOdK3DXtQCBZ/bSdHvigSbjQLSkz9kPwFTn49a0go=;
        b=Uf0RUWG0ozLhuJrMOdpo6ZfFzOrasg92YpZVitNBQ9ItMP8JE31e1FnR5ws5DjBfq9
         H1TldV0ChzrtjmGvb03M35+LQqeHApG4mQphIBX0lX6c5FHKEnxEgpToCtRfuFb0xq1j
         lLD6xeB68Mg88FFlm5UCmDKU/oHrFYizHWHp1rqB90jKcdQci2Pc5FP12KuAAw7qww7D
         +81B+1eqzl4tujO6P4xs7G0aXfVJOdeKlX7ro09Pk7at0l3j0jcjN6gUL8oujcSVfJhE
         31FRPsl5EniDRPPDFthRpr6p3vsresIt/9OiMioG3uSAZZyC9qEn/ewboSIbGn2IagE/
         iGkA==
X-Gm-Message-State: AGi0Puai9cxhEr3vAhggurjXWtsFcZWBmROL+DvPdwmapPuLS/fsLCg/
        XXe5fv8HNHpft8n7LTDC6phxG5qyoOpMOrBkobm4fV3zXBuYlVfNSu5ySGwAYEi7PiiAycQMocf
        P6nr8Y0PfN5Um
X-Received: by 2002:a5d:640a:: with SMTP id z10mr20415571wru.280.1587504161805;
        Tue, 21 Apr 2020 14:22:41 -0700 (PDT)
X-Google-Smtp-Source: APiQypLa18an1RGVvp0uK77fZIPNzLDq2b9ZzWAAvpEnVucWFgXqg3uFCUbnfzEYCy33am1kmErblA==
X-Received: by 2002:a5d:640a:: with SMTP id z10mr20415539wru.280.1587504161481;
        Tue, 21 Apr 2020 14:22:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id p7sm5559855wrf.31.2020.04.21.14.22.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 14:22:40 -0700 (PDT)
Subject: Re: [PATCH v1 02/15] nitro_enclaves: Define the PCI device interface
To:     Andra Paraschiv <andraprs@amazon.com>, linux-kernel@vger.kernel.org
Cc:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>, Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
References: <20200421184150.68011-1-andraprs@amazon.com>
 <20200421184150.68011-3-andraprs@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bfbb7242-b818-337d-4cff-fc48b7bb1cc0@redhat.com>
Date:   Tue, 21 Apr 2020 23:22:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200421184150.68011-3-andraprs@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/04/20 20:41, Andra Paraschiv wrote:
> The Nitro Enclaves (NE) driver communicates with a new PCI device, that
> is exposed to a virtual machine (VM) and handles commands meant for
> handling enclaves lifetime e.g. creation, termination, setting memory
> regions. The communication with the PCI device is handled using a MMIO
> space and MSI-X interrupts.
> 
> This device communicates with the hypervisor on the host, where the VM
> that spawned the enclave itself run, e.g. to launch a VM that is used
> for the enclave.
> 
> Define the MMIO space of the PCI device, the commands that are
> provided by this device. Add an internal data structure used as private
> data for the PCI device driver and the functions for the PCI device init
> / uninit and command requests handling.
> 
> Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
> Signed-off-by: Alexandru Ciobotaru <alcioa@amazon.com>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
>  .../virt/amazon/nitro_enclaves/ne_pci_dev.h   | 266 ++++++++++++++++++
>  1 file changed, 266 insertions(+)
>  create mode 100644 drivers/virt/amazon/nitro_enclaves/ne_pci_dev.h

Can this be placed just in drivers/virt/nitro_enclaves, or
drivers/virt/enclave/nitro?  It's not unlikely that this device be
implemented outside EC2 sooner or later, and there's nothing
Amazon-specific as far as I can see from the UAPI.

Paolo

