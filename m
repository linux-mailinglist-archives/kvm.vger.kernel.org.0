Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1B9423B3D
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 12:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237884AbhJFKJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 06:09:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46290 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237836AbhJFKJn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 06:09:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633514871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yj+1mrM82BCTz7uj5sLU3T9p8kSl41YyFNyCTwKFhxk=;
        b=VSp1A35uImG32Itgm5IjpIFPsnGn3HYnDpc2+fP8H/JZ2YEh+99DkEgEHKeLD+hN2IlJCm
        kBfT3wVhNpOWAvNpfTZNPgPC0kxbZ4U+XIhVmsADUP0yu5S8UcAj/grY28u6NUmOuaMgqz
        rqgnO0P+yGmMOpHOJ1o6gGD3ZdpoYzw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-NAmpp8PvMzy6wQewk5XN5A-1; Wed, 06 Oct 2021 06:07:50 -0400
X-MC-Unique: NAmpp8PvMzy6wQewk5XN5A-1
Received: by mail-ed1-f71.google.com with SMTP id bo2-20020a0564020b2200b003db3540f206so1936603edb.23
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 03:07:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yj+1mrM82BCTz7uj5sLU3T9p8kSl41YyFNyCTwKFhxk=;
        b=WV92OfxwR0M30B5mkZh3uTB7iai74atdstnK9AQL7ibWwSPGi7qguZkf+rHyCk3AZx
         QoyZp9ncSx8fShRgkTOowzw9MQpp5W2O8svDtM3QFWX55wM2D/6LZh8YvaM+UyuQii69
         K5j1JCFqai+8HMB7M83+bKB6WkFa32B8ubtge3oguA1j+el8rIaQD6AYOcwIZ5ZxI+Tf
         SclBg6iibjNkA/cp9wRlC8gUCkN4bJieMRlKg8XPXnElatsoOMEydgnAAYlnKtbE4CRx
         TX7IM2mWBtyVMO2BV6bDh5NvPWCKHyb21ne2oqzZrEqaMbcwi5rIMYgAqqBOpJ7z1IZY
         39tA==
X-Gm-Message-State: AOAM530PUesvZJvFs71FDmkKNNF7HzXVfqAyHfLGfNugqra7o0xnhWGc
        P3IPYWPoWdSUu4HovgoeGhGjB/fl4bIxSqXkHcICloTkEV+Ogf1p/eO0Us7zUkvyD6Y4mfdEPBw
        kRU8YCFWocdP6
X-Received: by 2002:a50:d511:: with SMTP id u17mr31603368edi.105.1633514869401;
        Wed, 06 Oct 2021 03:07:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVmH7htpm8XyEWwBpvpkOQHw+beXuhBecIj3zIjideTBPR95+pQCNRZBlwYFeSmOAe5zzIbg==
X-Received: by 2002:a50:d511:: with SMTP id u17mr31603347edi.105.1633514869251;
        Wed, 06 Oct 2021 03:07:49 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id e7sm8111509edv.39.2021.10.06.03.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 03:07:49 -0700 (PDT)
Date:   Wed, 6 Oct 2021 12:07:47 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        eric.auger@redhat.com, alexandru.elisei@arm.com,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH v4 09/11] KVM: arm64: selftests: Add tests for GIC
 redist/cpuif partially above IPA range
Message-ID: <20211006100747.vlyrxk6s2j73blpl@gator.home>
References: <20211005011921.437353-1-ricarkol@google.com>
 <20211005011921.437353-10-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005011921.437353-10-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021 at 06:19:19PM -0700, Ricardo Koller wrote:
> Add tests for checking that KVM returns the right error when trying to
> set GICv2 CPU interfaces or GICv3 Redistributors partially above the
> addressable IPA range. Also tighten the IPA range by replacing
> KVM_CAP_ARM_VM_IPA_SIZE with the IPA range currently configured for the
> guest (i.e., the default).

This tightening can even be considered a fix for the original tests,
since it looks like the objective of them was to check the boundary.

> 
> The check for the GICv3 redistributor created using the REDIST legacy
> API is not sufficient as this new test only checks the check done using
> vcpus already created when setting the base. The next commit will add
> the missing test which verifies that the KVM check is done at first vcpu
> run.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 38 +++++++++++++------
>  1 file changed, 26 insertions(+), 12 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

