Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E594546DF2F
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 01:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241319AbhLIAIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 19:08:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233328AbhLIAIS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 19:08:18 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4BAC061746
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 16:04:45 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so3430530pjb.5
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 16:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MjUeHzzA4V17niQyufwkdrBEp0f65mLMF1fq0crIpW0=;
        b=b+3DMK2d5mC+XSKmwavtEEUhdxeN1Sx6VF8/i5xEOkF77+HhxFlS7HOatJxHNY6/nb
         PJfVeM/FZc53xg2Gm0RZKK3pjNka3g8c/tYglsPigPaiobRgBBAPlGbUvxoHlsHCHiUc
         YehYKmEOkc5137JM/L8YYXEfZTttkn66sk9+26uVrXO6Efykk+1T5nWhC7z4ZoGxT5zY
         qfP3qKjUB45LJk3MFpQvmhN2An5vk5coeZt786iJr9cey0YWSe2SZw3NC+Tjk7qc+S/P
         nBgfKZ2T3uD1CJW9x1r5EhNEYNtGIDrpOIuLhWfyb8yBYCpN0gd+nvxAsJloYZ9tf3QQ
         ZGiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MjUeHzzA4V17niQyufwkdrBEp0f65mLMF1fq0crIpW0=;
        b=voP5a+IzMBx1M9CGfvWuICiTOtu4Cz25l47Ky2ZbmAVWZEsA2SiyPkcxgLsMgMhoI2
         V2Do3RqkZcbB2ui3VLezMQ9uf49dhW60wXKZ35H+HTHTIjFBgsyHY345eDroddv2dhsp
         xrTdrCTpTkMGV5Bn4ByVZlgucG1G86vsSVkhZ6eg+IYf5ZepSzDA3sByVPVwiyT9Mvj7
         +/sCKxY/IVlNE+FKHDvaLuLh6h4V5On4YmdDaPwRj+mTA/5Ik1VGVtPhtvE1ZOc0+0ON
         Vowlua0fX5D6z3tLYaT6btWNS1kRUALWva8TlK3zFX7F/tFlIgCRfunPlLI9cBVJ0xM8
         Du6Q==
X-Gm-Message-State: AOAM530afw2SyzcM/uPzRMBvwAY/vRg1KHmMmAvu5UO8AAISPxwxJWq2
        EzXe7vfKhgBodZfHh66exrbn6Q==
X-Google-Smtp-Source: ABdhPJyiv63F9ZJKJny3hjVwxro5UZyYEhLuM/dB7Sc4H0wX9hjkGjpGw/qXP8w5pVdLRhJLyjjXmQ==
X-Received: by 2002:a17:90b:1b0a:: with SMTP id nu10mr11290342pjb.35.1639008285121;
        Wed, 08 Dec 2021 16:04:45 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z4sm4946183pfh.15.2021.12.08.16.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 16:04:44 -0800 (PST)
Date:   Thu, 9 Dec 2021 00:04:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/26] KVM: x86: Halt and APICv overhaul
Message-ID: <YbFIGSeukbquyoQ5@google.com>
References: <20211208015236.1616697-1-seanjc@google.com>
 <39c885fc6455dd0aa2f8643e725422851430f9ec.camel@redhat.com>
 <8c6c38f3cc201e42629c3b8e5cf8cdb251c9ea8d.camel@redhat.com>
 <6f0dc26c78c151814317d95d4918ffddabdd2df1.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f0dc26c78c151814317d95d4918ffddabdd2df1.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 09, 2021, Maxim Levitsky wrote:
> Host crash while running 32 bit VM and another 32 bit VM nested in it:
> 
> [  751.182290] BUG: kernel NULL pointer dereference, address: 0000000000000025
> [  751.198234] #PF: supervisor read access in kernel mode
> [  751.209982] #PF: error_code(0x0000) - not-present page
> [  751.221733] PGD 3720f9067 P4D 3720f9067 PUD 3720f8067 PMD 0 
> [  751.234682] Oops: 0000 [#1] SMP
> [  751.241857] CPU: 8 PID: 54050 Comm: CPU 8/KVM Tainted: G           O      5.16.0-rc4.unstable #6
> [  751.261960] Hardware name: LENOVO 20UF001CUS/20UF001CUS, BIOS R1CET65W(1.34 ) 06/17/2021
> [  751.280475] RIP: 0010:is_page_fault_stale.isra.0+0x2a/0xa0 [kvm]

...

> Oh well, not related to the patch series but just that I don't forget.
> I need to do some throughfull testing on all the VMs I use.

This is my goof, I'll post a fix shortly.
