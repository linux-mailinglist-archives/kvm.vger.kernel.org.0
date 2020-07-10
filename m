Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C7E21AFE8
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 09:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgGJHPg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 03:15:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30155 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725851AbgGJHPf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 03:15:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594365333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JBLK5CBk2nZNnzlnXGDcyKLYPLiIIdnLjccWhrFJFtQ=;
        b=dF3AbrPJCs+eAxYnsNg4mYA56rUTiQWWiF1M7/5Q24PEvueBejr1mp7jASoGoZNOuhma+r
        Hd6f9QVU/u56iwONR2HPdiWYqGoal2nh70Zn2R6K+sCSb/484a6QRav1V+FgaDEF503doE
        jKsY2VSYrWMTKmxQ0WK3sCI06Fphzpg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-l55-oxKCPCKQTUnmgzVtxg-1; Fri, 10 Jul 2020 03:15:32 -0400
X-MC-Unique: l55-oxKCPCKQTUnmgzVtxg-1
Received: by mail-wr1-f70.google.com with SMTP id z1so4905409wrn.18
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 00:15:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JBLK5CBk2nZNnzlnXGDcyKLYPLiIIdnLjccWhrFJFtQ=;
        b=RlyVFnHJL5u0sLYt34/CGUxQE83TiTbb3nMynYy3uzk0g5PWDsxMHmQV7YWabQ62Fp
         XyMZ4M7WVojTsmQBeaUxKbQDk19G/bQHmkoNA3OPGKJLOvEAM1b3dfjDfUak5wA0uuAs
         StpHLUin5cc9hviBVPL80ROLf+JRxaphaLUR8rhg8JVkX2XPuPg+MbzEOHtOLGvYPjMP
         EjT4rOJbqA0Qlm3bOn3Zp5J7XGWoNJEuqdJzjkM1akLrxkossQrzFb+NbM5oGFPB4h7x
         kHf3lvxlwITleCad7vAEHN21AoZmzrRtIjJ8lDaDu1q894+cWDQg02eRK1v8UT1F/yCg
         S8Aw==
X-Gm-Message-State: AOAM533PQXx9gS9Svlmqa9Uux4hxXLLRlTyKJjOeJgb0mosKMPte0WtI
        sRKRjOhfIg+4WnsYqcKkcKxGE9XXsMFqC+PAV6ZTgTb17fWWBjKc4AE7fQg53d0+cec2o9n5Huv
        svjKIDPTzWwqP
X-Received: by 2002:a1c:9650:: with SMTP id y77mr3688210wmd.101.1594365330843;
        Fri, 10 Jul 2020 00:15:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzLkZi5TShL/4z4VHn340jG1ycyGRH/hNP2ypKvwJnucrUd9Azxl5ktb84UOxWF5Uhkivwtrg==
X-Received: by 2002:a1c:9650:: with SMTP id y77mr3688190wmd.101.1594365330615;
        Fri, 10 Jul 2020 00:15:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id v18sm9533001wrv.49.2020.07.10.00.15.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 00:15:30 -0700 (PDT)
Subject: Re: [RFC PATCH 0/3] MIPS KVM related clean-ups
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>, linux-mips@vger.kernel.org
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Jason Wang <jasowang@redhat.com>,
        Paul Burton <paulburton@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200710063047.154611-1-jiaxun.yang@flygoat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b43cbc19-79d2-756e-b5eb-0a7e16d92e84@redhat.com>
Date:   Fri, 10 Jul 2020 09:15:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200710063047.154611-1-jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/07/20 08:30, Jiaxun Yang wrote:
> Retire some features that never worked in the real world.
> 
> Also I wonder if there are any actual user of TE KVM.
> Will Huacai or Alexsander take care relevant code?

Queued patches 2 and 3, thanks.  One is outside my maintenance area.

Paolo

> Thanks.
> 
> Jiaxun Yang (3):
>   MIPS: Retire kvm paravirt
>   MIPS: KVM: Limit Trap-and-Emulate to MIPS32R2 only
>   MIPS: KVM: Remove outdated README
> 
>  arch/mips/Kbuild.platforms                |   1 -
>  arch/mips/Kconfig                         |  20 +-
>  arch/mips/configs/mips_paravirt_defconfig |  98 ------
>  arch/mips/include/asm/Kbuild              |   1 +
>  arch/mips/include/asm/kvm_para.h          | 115 -------
>  arch/mips/include/uapi/asm/Kbuild         |   2 +
>  arch/mips/include/uapi/asm/kvm_para.h     |   5 -
>  arch/mips/kvm/00README.txt                |  31 --
>  arch/mips/kvm/Kconfig                     |   3 +-
>  arch/mips/paravirt/Kconfig                |   7 -
>  arch/mips/paravirt/Makefile               |  14 -
>  arch/mips/paravirt/Platform               |   7 -
>  arch/mips/paravirt/paravirt-irq.c         | 368 ----------------------
>  arch/mips/paravirt/paravirt-smp.c         | 145 ---------
>  arch/mips/paravirt/serial.c               |  39 ---
>  arch/mips/paravirt/setup.c                |  67 ----
>  arch/mips/pci/Makefile                    |   1 -
>  arch/mips/pci/pci-virtio-guest.c          | 131 --------
>  18 files changed, 6 insertions(+), 1049 deletions(-)
>  delete mode 100644 arch/mips/configs/mips_paravirt_defconfig
>  delete mode 100644 arch/mips/include/asm/kvm_para.h
>  delete mode 100644 arch/mips/include/uapi/asm/kvm_para.h
>  delete mode 100644 arch/mips/kvm/00README.txt
>  delete mode 100644 arch/mips/paravirt/Kconfig
>  delete mode 100644 arch/mips/paravirt/Makefile
>  delete mode 100644 arch/mips/paravirt/Platform
>  delete mode 100644 arch/mips/paravirt/paravirt-irq.c
>  delete mode 100644 arch/mips/paravirt/paravirt-smp.c
>  delete mode 100644 arch/mips/paravirt/serial.c
>  delete mode 100644 arch/mips/paravirt/setup.c
>  delete mode 100644 arch/mips/pci/pci-virtio-guest.c
> 

