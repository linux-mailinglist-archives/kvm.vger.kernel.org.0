Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587CB2ADC22
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 17:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbgKJQ0Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 11:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgKJQ0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 11:26:25 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2A3C0613CF;
        Tue, 10 Nov 2020 08:26:24 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id o20so13393439eds.3;
        Tue, 10 Nov 2020 08:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2NcAsVTPsYA/NoTEYktfl6/AwcvS1dbUOsrpH4IcvMo=;
        b=m4+3CV7fPBedSyDJNc3NrHQ+qEZyL//4m+o1MBQ1SyAd3as1QYsZ0A+sxlrZs+uIBn
         yXNI4cZL68ADq/I0ZyxXYVCK2gb0McEZkv4gKqsjCydl8dU+mlJMWRyABu/nd9KTCdBZ
         MUJt5PGaJYpyiCWdjnuVMpGp7qDIAF0RZrA2F6eKU+V1OeeEIYStcp3tyWmrRKr85gdk
         4eOEFGPkX9HCdfDO/lKXjvgNb+rVCYlwxq5GL7cXg6/gANObk+NZkUbEiTZcAFAfd0aT
         L5myAHFx41BljRl6tWYRQiiiACg9WQWHFlN/yHaxOStPSDwV/KZzcIUQM6MzVt0Tc+SR
         RXKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2NcAsVTPsYA/NoTEYktfl6/AwcvS1dbUOsrpH4IcvMo=;
        b=se4zvmiXDtaJ3UVuPRWqnW4Nx15o4wN3QmuZjWGpKNf2SBAQ3DX8aCfcUJ2BxkWvIY
         4fipuCJyjCzrnhqC+2Y2PJVTgvJv/uBOByN2eEyYsxs+u5IKQRdvMca2kEdXgKoLNTZJ
         HU1rHPdDnUL6wIOZZ200dGgz0tCO6yoP0gyLSotStgbi+rKtHU7PiKUpAb58ZwnOlI1e
         MtaAyRIFfX+bolN1DsUrcrR9dkcBZMTObXForN7zW7f917JuN+RUHTFaVDuLqkk7h9X0
         I6DjjRyO0zEjIKLY1XVe9Lzd8kcjvTEBz4lxBXM8GmUZhjqRQQYFjYYIrC9bhYLYUg+p
         ZhyA==
X-Gm-Message-State: AOAM531cF+3uD6n5pBbc1inp825Ufyl561Ow2y0h+It8C16nAo8AT+CA
        CatwoG0wWnGtXSCNw7255O6O8dWOUy8=
X-Google-Smtp-Source: ABdhPJwuSP6VnkfK3b2egRw4V5auLe2FLUmM5/5ZMiBr4Avs7VrFlqlnVw0CmhEpsMDOWn3cUuiyhw==
X-Received: by 2002:aa7:c704:: with SMTP id i4mr93729edq.51.1605025583211;
        Tue, 10 Nov 2020 08:26:23 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id q15sm11048192edt.95.2020.11.10.08.26.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 08:26:22 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Subject: Re: [PATCH v3 19/35] x86/io_apic: Cleanup trigger/polarity helpers
To:     David Woodhouse <dwmw2@infradead.org>, Qian Cai <cai@redhat.com>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Tom Murphy <murphyt7@tcd.ie>
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <e6601ff691afb3266e365a91e8b221179daf22c2.camel@infradead.org>
 <20201024213535.443185-1-dwmw2@infradead.org>
 <20201024213535.443185-20-dwmw2@infradead.org>
 <085029af45f045dcf5b7fb2173d560421b00b44d.camel@redhat.com>
 <23e0a29faad5a9cc43582ba7d40a3073f2fb8c87.camel@infradead.org>
From:   Paolo Bonzini <bonzini@gnu.org>
Message-ID: <e213d85f-b29b-e663-29db-10d987feb8d7@gnu.org>
Date:   Tue, 10 Nov 2020 17:26:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <23e0a29faad5a9cc43582ba7d40a3073f2fb8c87.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/11/20 09:59, David Woodhouse wrote:
> Hm, attempting to reproduce this shows something else. Ever since
> commit be62dbf554c5 ("iommu/amd: Convert AMD iommu driver to the dma-
> iommu api") in 5.5 the following stops working for me:
> 
> $ qemu-system-x86_64 -serial mon:stdio -kernel bzImage  -machine q35,accel=kvm,kernel-irqchip=split -m 2G -device amd-iommu,intremap=off -append "console=ttyS0 apic=verbose debug" -display none
> 
> It hasn't got a hard drive but I can watch the SATA interrupts fail as
> it probes the CD-ROM:
> 
> [    7.403327] ata3.00: qc timeout (cmd 0xa1)
> [    7.405980] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> 
> Adding 'iommu=off' to the kernel command line makes it work again, in
> that it correctly panics at the lack of a root file system, quickly.

That might well be a QEMU bug though, AMD emulation is kinda experimental.

Paolo
