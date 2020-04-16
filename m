Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D731ABB49
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 10:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440760AbgDPIb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 04:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502242AbgDPIbY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 04:31:24 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355CAC03C1AB;
        Thu, 16 Apr 2020 01:31:08 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id a81so3813139wmf.5;
        Thu, 16 Apr 2020 01:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jfrt17q5M4S5SAVVkdakw83Rj5cTfkomq3bpc03Lu9E=;
        b=CFbFjllOBhKoFmAVsXkBQzBuRQAfDrmhFAfVIGB11rbD3zAjEQppK74PC9fnxFnMrl
         sp2/EeMkEMZEPkJaKAPezTCzWxvNVCQxytUa+QkC+1t59d7i5I3Ft4/ciYIUyoPgOMmx
         UiPK1SyxvMiF5/fQuHdgpj6dJ/kxBF7pqlJnwenUbEeoXzoXQDDOkD79QMrnqwADC91X
         mAbhAkAD8NXfaYxauQUMXrLjqT8CjpZdwFVOxMjLk33tqqc1vixpmPBfeaEJadSe1cYi
         RAtQlg/x50nnmchxxtr0K+qNEsQkfkEUxgrnt/DkUknFzWr3iZARx7zlhyFNK0Y/EZyB
         KDIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jfrt17q5M4S5SAVVkdakw83Rj5cTfkomq3bpc03Lu9E=;
        b=TMKknxl0MUt8yAzI4Yj7SWsQOBt2760gCbZx3zime8sxteJ7ta+PVKDfFXgC6SSx0A
         ihRY+rw5SrL7dtp7j7oLMhqDE6ZXQGTRExcXpXdBp/Zp6vh4LMZ4GAO3MgIqyVco8EhV
         a0RpMrhAU0oQEzQ5pc/HPT4HXsuBP9sJF+tOWc36jQxyw8NRSfAclqG2IP+IskWyGgNk
         kt+//SgoMkqpo9en2dxKjN35woWRIwRSS3IYx1tMQyYJZ3MzfHch+NYQKWezOCpY53tj
         KKBFlzdH5Br8j4zTKbXH12h0BZQIMD+b+TMebzZB8UIPvJ1wj+CQX3y7GUxG8FS68gRm
         JAIw==
X-Gm-Message-State: AGi0PubsfTdJN36ve3YLYFf9dh7Enk0Sw4z3zitBVPpXHzCYG4+nYyFE
        cdyFgvrKGj8kYeBdlZgw+4o=
X-Google-Smtp-Source: APiQypKSKsq45oAa/3mvfDvpWfY2V+jAcrUeSZODmwOpRthGJy4sv8r2h7IKlE30zB7Jtv03++ti6Q==
X-Received: by 2002:a05:600c:24cf:: with SMTP id 15mr3541839wmu.94.1587025866950;
        Thu, 16 Apr 2020 01:31:06 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id a9sm2611917wmm.38.2020.04.16.01.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 01:31:06 -0700 (PDT)
Date:   Thu, 16 Apr 2020 10:31:04 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 10/33] docs: fix broken references for ReST files that
 moved around
Message-ID: <20200416083104.GA29148@Red>
References: <cover.1586881715.git.mchehab+huawei@kernel.org>
 <64773a12b4410aaf3e3be89e3ec7e34de2484eea.1586881715.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64773a12b4410aaf3e3be89e3ec7e34de2484eea.1586881715.git.mchehab+huawei@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 14, 2020 at 06:48:36PM +0200, Mauro Carvalho Chehab wrote:
> Some broken references happened due to shifting files around
> and ReST renames. Those can't be auto-fixed by the script,
> so let's fix them manually.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  Documentation/doc-guide/maintainer-profile.rst      | 2 +-
>  Documentation/virt/kvm/mmu.rst                      | 2 +-
>  Documentation/virt/kvm/review-checklist.rst         | 2 +-
>  arch/x86/kvm/mmu/mmu.c                              | 2 +-
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 2 +-
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c   | 2 +-
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 2 +-
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c   | 2 +-
>  drivers/media/v4l2-core/v4l2-fwnode.c               | 2 +-
>  include/uapi/linux/kvm.h                            | 4 ++--
>  tools/include/uapi/linux/kvm.h                      | 4 ++--
>  11 files changed, 13 insertions(+), 13 deletions(-)
> 

For sun8i-ce
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Thanks
