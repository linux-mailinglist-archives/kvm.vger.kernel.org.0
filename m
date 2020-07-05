Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB97214A74
	for <lists+kvm@lfdr.de>; Sun,  5 Jul 2020 07:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbgGEFpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jul 2020 01:45:03 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:40388 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725873AbgGEFpD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 5 Jul 2020 01:45:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593927901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rU7+c2LbORU78XDpd0ElhyGB/g0DfHC3gDhe0qSgrLM=;
        b=Sux7snWkipaVj5e1CjnE0QFd97eTTR3P36d/pr66AsDdDhCbz7xi1+CgAB0wro2Gz+8Fa7
        rZbNwKZfnaVw9kjdbYmmYKeCqwAgzsYCwPiPNfZ/FRgSLcyl0/YpViPd6VVi/TJjRqYLvV
        N/pX+JHD9b5RfPuIgIsHpw/TtyStEao=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-ZPS8tZ9QNzqtXxMengc9Mg-1; Sun, 05 Jul 2020 01:44:59 -0400
X-MC-Unique: ZPS8tZ9QNzqtXxMengc9Mg-1
Received: by mail-wr1-f69.google.com with SMTP id y18so18089463wrq.4
        for <kvm@vger.kernel.org>; Sat, 04 Jul 2020 22:44:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rU7+c2LbORU78XDpd0ElhyGB/g0DfHC3gDhe0qSgrLM=;
        b=i0riAPMNig/cEoRGH/k5ySeiz+fxVE/rHsBAJJqD0uPLwT1sbyBNm8a1lT8lMk+4nF
         +CtyPYGx5KrNupvB0IgDimQ4R9oBfgEuqu6A7TL8zuN/NLB6+SmUsZ7cPX9wtrK7mAcb
         LdLDKIrhB/dRhRZj83ZBE8h5cSjhdfU1yd9PpGdzlTzTy8yQxKzzfgE8NzRym4jW1sn2
         D5kMBJPNw+S0uDA2w7vnKzjzqrtAm1Mm2ci8JodvUgij99AuhmVpIr+s+2yId85XYUbx
         KoONS/8WyAQU8VdZeUput+xLq07qVom2cJ1TWUVb7xk+tOnRe0nJcomWgvwaNGNJ3yZ1
         NGNg==
X-Gm-Message-State: AOAM530aO1fVYprAdfUxtypdlqFO25vIMuJExi3CKUmWYfKlbv5uFVLK
        GOX8FSWadu0XXdOhZr1Ix9DQqpzJJlMj5lYbCmwqmgLH9m7pwPhouvnhdvR9jJXnN4O4aARFrIQ
        nnwQZTeK0IgI2
X-Received: by 2002:adf:f083:: with SMTP id n3mr43446866wro.297.1593927898618;
        Sat, 04 Jul 2020 22:44:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrOv6H8wqyhW0KbDMY0+O/hcyo6UkG/ZTteYU5A9BINoZgjLbaFRPvN5X/SNOAJKe0/g1kag==
X-Received: by 2002:adf:f083:: with SMTP id n3mr43446854wro.297.1593927898367;
        Sat, 04 Jul 2020 22:44:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:adf2:29a0:7689:d40c? ([2001:b07:6468:f312:adf2:29a0:7689:d40c])
        by smtp.gmail.com with ESMTPSA id 207sm20038992wme.13.2020.07.04.22.44.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jul 2020 22:44:57 -0700 (PDT)
Subject: Re: KVM/VFIO passthrough not working when TRIM_UNUSED_KSYMS is
 enabled
To:     Gunnar Eggen <geggen54@gmail.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org, jeyu@kernel.org
References: <13e90f87-9062-a7e4-99c0-5c6f5c16cad2@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a43675ef-197d-2bd5-9505-200ac439df6c@redhat.com>
Date:   Sun, 5 Jul 2020 07:44:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <13e90f87-9062-a7e4-99c0-5c6f5c16cad2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/07/20 23:03, Gunnar Eggen wrote:
> Hi,
> 
> It's a bit unclear what subsystem is to blame for this problem, so I'm
> sending this to both KVM, VFIO and Module support.
> 
> The problem is that trimming unused symbols in the kernel breaks VFIO
> passthrough on x86/amd64 at least. If the option TRIM_UNUSED_KSYMS is
> enabled you will see the following error when trying to start a VM in
> QEmu with any pcie device passed via VFIO:
> 
> qemu-system-x86_64: -device vfio-pci,host=04:00.0: Failed to add group
> 25 to KVM VFIO device: Invalid argument
> 
> The error will not stop the VM from launching, but it will break things
> in mysterious ways when e.g. installing graphics drivers.
> No external modules is involved in this, so I would guess that there is
> some dependency that the trimming is missing in some way.
> 
> With the introduction of UNUSED_KSYMS_WHITELIST in the latest kernels,
> and some talk about making trimming symbols the default in the future,
> it would be great if we could get this fixed or at least identify the
> problematic symbols so that they could be whitelisted if needed.

They are:
- vfio_group_get_external_user
- vfio_external_group_match_file
- vfio_group_put_external_user
- vfio_group_set_kvm
- vfio_external_check_extension
- vfio_external_user_iommu_id

and also (unrelated but breaking other stuff):
- mdev_get_iommu_device
- mdev_bus_type

However, UNUSED_KSYMS_WHITELIST seems the wrong tool for this.  We would
need to have something that says: "if KVM && VFIO, then include these
symbols", for example a macro "IMPORT_SYMBOL" that would be processed by
cmd_undef_syms.

Paolo

> Steps to reproduce:
> 
> 1 - Have a kernel where TRIM_UNUSED_KSYMS is enabled
> 2 - Start a VM in QEmu/KVM with a pcie device passed through via vfio-pci
> 
> This is a common issue that keeps popping up on user forums related to
> vfio passthrough, so it should be fairly simple to reproduce.
> 
> Let me know if you want more details or perhaps my kernel config or
> trimmed system map to test with.
> 
> Best regards,
> Gunnar
> 

