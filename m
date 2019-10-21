Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27499DE731
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 10:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfJUI4W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 04:56:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45990 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727323AbfJUI4V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 04:56:21 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7A0E785362
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 08:56:21 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id n18so6871401wro.11
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 01:56:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gQn5Li/EcmWGQTJyF2DN7cNoKtM74y39k0g3g/XyNac=;
        b=cEH5A7zGwTq577m72kcSBbGaQZOyJ2Yvzr8UHy59HY7TFZnQY7hMEwCQw+Mmt5DVR9
         REOQ+OOQ92VgFCKByyKON7o+5kuPtYpIpuWSt/1QRo9OCn+AdNgeEaoBwzxLRjX3Kcht
         d/Y4QSG8zRV7Jk/AvkIXInTFBc566th61dPs/4xnVl8BM2AXfMpn2mt6YFg/RSniVktN
         VqJu1/NDmd6tw4qT7/KZTHwY5O+8PbNpiX2a/7p5ekXVr6Ze9hY6XIiyIdl7tPb6h9Qf
         JyKM12aJIPYsN/xJoZyeJNl8r/rQybi36vx7XFDPlvCZDcMqKgAscIDqDccq6iJePcuT
         KCfg==
X-Gm-Message-State: APjAAAWNC3lkMrFg4lCUYL9DIFaywMtP45RuAr55ye1W1a8fZSyzxaGV
        KdFIKeCXbgB4Ge8PowkLcnFo7hWyviM+sVI3ZdJOTMMpUOKVQPjcliRYHziB579mWTe2QFmfNMo
        /GyUBT+ycaE63
X-Received: by 2002:a5d:464f:: with SMTP id j15mr5164420wrs.366.1571648180109;
        Mon, 21 Oct 2019 01:56:20 -0700 (PDT)
X-Google-Smtp-Source: APXvYqysKxDXg0I4Kw8rQkZnFYRtY7gmE/enX8CLo4Y5mT4aGF0Vfe7KNufYviTHlKtqR3lwtPQDew==
X-Received: by 2002:a5d:464f:: with SMTP id j15mr5164400wrs.366.1571648179814;
        Mon, 21 Oct 2019 01:56:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:566:fc24:94f2:2f13? ([2001:b07:6468:f312:566:fc24:94f2:2f13])
        by smtp.gmail.com with ESMTPSA id c8sm720806wml.44.2019.10.21.01.56.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 01:56:19 -0700 (PDT)
Subject: Re: [PATCH] KVM: remove redundant code in kvm_arch_vm_ioctl
To:     Thomas Gleixner <tglx@linutronix.de>,
        Miaohe Lin <linmiaohe@huawei.com>
Cc:     rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1571626376-11357-1-git-send-email-linmiaohe@huawei.com>
 <alpine.DEB.2.21.1910211015260.1904@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <6ad3a479-5015-10c7-3f32-70f3ed1ecf64@redhat.com>
Date:   Mon, 21 Oct 2019 10:56:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1910211015260.1904@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/10/19 10:16, Thomas Gleixner wrote:
> Can you please get rid of that odd jump label completely?
> 
>   		if (irqchip_kernel(kvm))
> 			r = kvm_vm_ioctl_set_irqchip(kvm, chip);

Keeping the label has the advantage of making the get and set cases a
bit more similar (the get case has to do a copy_to_user after
kvm_vm_ioctl_get_irqchip returns).  Unfortunately struct kvm_irqchip is
quite big (520 bytes) so we don't allocate it on the stack.

So I queued Miaohe's patch.

Paolo
