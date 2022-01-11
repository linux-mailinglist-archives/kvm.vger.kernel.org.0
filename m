Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13EC48AACB
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 10:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237181AbiAKJrj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 04:47:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49813 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347369AbiAKJra (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 04:47:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641894448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GrmA+PXG2k8gd1CgfrfPZfbAbd5si0dF+8rL+GfOaoI=;
        b=Bl/dV7Vwee3dWYr2Joyw/EGSuGO4omGDgvWLPTjKkmaYyQBi0AYw6TqpIbKI/tQ5dfh+SO
        vvkE/Fwfd3Bqq4MNSn08NQ15uwmty8j2vPnUwDo9SsDWhna1kHPIjIdDWYnVVKuRmKSc8c
        IovDK6qe7cqdTUcOGp4zMG5mCqwH52A=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-pTaf4SkAPLq-zMSEe9lM0g-1; Tue, 11 Jan 2022 04:47:25 -0500
X-MC-Unique: pTaf4SkAPLq-zMSEe9lM0g-1
Received: by mail-wm1-f69.google.com with SMTP id 7-20020a1c1907000000b003471d9bbe8dso371019wmz.0
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 01:47:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GrmA+PXG2k8gd1CgfrfPZfbAbd5si0dF+8rL+GfOaoI=;
        b=JkQp9bq57pTkPjBF4JoZ3cHmWsUQi8gQV7czwEaN1hciqquAnrifPMQRKm/bcpG05k
         lL8kdfaua/LCF7au3K8y0HFtdqzHOgIJ91a/iuQgvsjN0zHuuOafMrUhSUgUJAruPJv3
         qpeozpnmiAl6KBW9UhMM3eVUp/UmGaaim0lIi3P4a2/3mWB+D5Mut/rv23tWXkOD56cE
         teYgu42xDr3c8JCHRMhLwjQjuOk3pbjv49jcoSLZLeTRhZwOvGpYlqFHGr4r8eXJuQOX
         5o/t5409PFL2E3LTtQnouyUO4VyEw+yWochxMdbjt2byzbIlp3zFf95CqMJkA6QDOFrH
         jEBg==
X-Gm-Message-State: AOAM530+ki1l4cHRCiNhhv28/zSiXHBp6IAz9ADkcjtawkGFFaFTNjSb
        uFok/3SVFW2nVuPpi8NwSHXXCMWLKiGDEgmSuFtuUbSjfziWNlMvRrdp/iNziPrfGL4I3E9RN5G
        oj0rYEdDqXEHy
X-Received: by 2002:a5d:4701:: with SMTP id y1mr3072349wrq.287.1641894444534;
        Tue, 11 Jan 2022 01:47:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzI/cKwPYMwt17iYUFub9wSmgF/47I4e6qGZvUhPa7yc9tJX/yXF+JQnBxGIzDhLRiFJ3ORlg==
X-Received: by 2002:a5d:4701:: with SMTP id y1mr3072339wrq.287.1641894444318;
        Tue, 11 Jan 2022 01:47:24 -0800 (PST)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id u12sm8671751wrf.60.2022.01.11.01.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 01:47:23 -0800 (PST)
Date:   Tue, 11 Jan 2022 10:47:22 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: Introduce vcpu_width_config
Message-ID: <20220111094722.cvj2zjtsh64jjg4i@gator>
References: <20220110054042.1079932-1-reijiw@google.com>
 <20220110054042.1079932-2-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110054042.1079932-2-reijiw@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 09, 2022 at 09:40:42PM -0800, Reiji Watanabe wrote:
> Introduce a test for aarch64 that ensures non-mixed-width vCPUs
> (all 64bit vCPUs or all 32bit vcPUs) can be configured, and
> mixed-width vCPUs cannot be configured.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/aarch64/vcpu_width_config.c | 125 ++++++++++++++++++
>  3 files changed, 127 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
>

 
Reviewed-by: Andrew Jones <drjones@redhat.com>

