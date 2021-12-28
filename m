Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4984807E3
	for <lists+kvm@lfdr.de>; Tue, 28 Dec 2021 10:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235980AbhL1Jhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Dec 2021 04:37:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54682 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229617AbhL1Jhh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Dec 2021 04:37:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640684256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B5Dyr2hKJTOOO0TGPVRDDvVVpCPunRt9Jh2tsoosVQg=;
        b=AwYa2fYBgW0yJuResYpAQ1uIgaU+cCmkN99wjiVH3I64K0spnPWRZFUPDMGPayn2eXqP1J
        MsM4n0pOIHz0siAtrPrHZX7U0kz1bDU+FknijAgU/PBczE0MbXvfwNfB0PEZx5/2Lan1GX
        5EB0gzxZVS/a5W4RKXCMtYALeqPcHkY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509-Uvu9svzvPj2vNhmixCGmEw-1; Tue, 28 Dec 2021 04:37:35 -0500
X-MC-Unique: Uvu9svzvPj2vNhmixCGmEw-1
Received: by mail-ed1-f69.google.com with SMTP id g11-20020a056402090b00b003f8fd1ac475so4985751edz.1
        for <kvm@vger.kernel.org>; Tue, 28 Dec 2021 01:37:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B5Dyr2hKJTOOO0TGPVRDDvVVpCPunRt9Jh2tsoosVQg=;
        b=3vCjbWblpkr89emI50zEOqJL20dq+Hz4dSK1PiGqXEvFdikzi8gLgihFqzy2b84z0/
         6ELalVsp3MIWA9WaObuwuqisvW4rXhctHVGghI5WXwMwyv0YF/qlghR9ih/VhemfNdh8
         VCSi6o3n8zEFHll5yRzVVUWGnk69cT84ec4rqi4b/q34ZvmnDDXtTEzRYmUViLsjv8DE
         TsweRkgH6s9Hbg2mScu6RXM0wuPgpiSsfEhW8FLqmI4DRKP5BXGIyB7E8yfqumG2J0pe
         P+CAnZymreyI8HNHPaueVaMjsqKDU6WkDNQPzuaO608HEsVJNiP2fGLEVXF7yU4wjYhd
         nQsA==
X-Gm-Message-State: AOAM533gzJmnz4ktlpm9oNPicRz84i7SzdFFMhk+5R+lKY0dkxtyP+I9
        4Fy+OlLFoiHzsSS2c4PAvzK8DWHAkG5Z6ZqZFbZPp2585laaYymE9KUNmtl1d/659tXKwL/Q3Qr
        +QGkV90/2qsuC
X-Received: by 2002:a05:6402:1d4b:: with SMTP id dz11mr19396958edb.15.1640684254666;
        Tue, 28 Dec 2021 01:37:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzLPd90MR3jT/AajpUn5GE5pdmm4Y7/jXkOi2HCyvBFKr8b65HY2arIgvoCbXPXxkIz2d5uZA==
X-Received: by 2002:a05:6402:1d4b:: with SMTP id dz11mr19396938edb.15.1640684254499;
        Tue, 28 Dec 2021 01:37:34 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id w10sm7148144edt.16.2021.12.28.01.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 01:37:34 -0800 (PST)
Date:   Tue, 28 Dec 2021 10:37:32 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH v2 3/6] KVM: selftests: arm64: Check for supported page
 sizes
Message-ID: <20211228093732.mxludqdyxihgwwzw@gator.home>
References: <20211227124809.1335409-1-maz@kernel.org>
 <20211227124809.1335409-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227124809.1335409-4-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 27, 2021 at 12:48:06PM +0000, Marc Zyngier wrote:
> Just as arm64 implemenations don't necessary support all IPA
> ranges, they don't  all support the same page sizes either. Fun.
> 
> Create a dummy VM to snapshot the page sizes supported by the
> host, and filter the supported modes.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  .../selftests/kvm/include/aarch64/processor.h |  3 ++
>  .../selftests/kvm/lib/aarch64/processor.c     | 36 +++++++++++++++++++
>  tools/testing/selftests/kvm/lib/guest_modes.c | 17 +++++----
>  3 files changed, 50 insertions(+), 6 deletions(-)
>

 
Reviewed-by: Andrew Jones <drjones@redhat.com>

