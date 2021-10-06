Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CC5423866
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 08:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236878AbhJFG6g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 02:58:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41388 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230227AbhJFG6f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 02:58:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633503403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uiC3Hk8XqY2sMj+wVrs/NsuZmiiYNNu/UVBg88+/rP8=;
        b=VaJmNYmjb6L9kSRerdOurlXUNMOeyqlTuZ/7Zk0+LVZyuGQaWq0mm7ZrJ8HdKav9e1oOUK
        K3bwsvPKeck96BimyyFa0cSsttj5Ch+Po8dOmGrsZX9l5lxLwCvTIZIUSJ43AZnFi0muUN
        lIT2ejLQ+8KehBr6BKkvlSszrZ0SwBo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-6teTP-R8NU-DQ-tqCMeBLA-1; Wed, 06 Oct 2021 02:56:42 -0400
X-MC-Unique: 6teTP-R8NU-DQ-tqCMeBLA-1
Received: by mail-ed1-f71.google.com with SMTP id u23-20020a50a417000000b003db23c7e5e2so1697275edb.8
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 23:56:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uiC3Hk8XqY2sMj+wVrs/NsuZmiiYNNu/UVBg88+/rP8=;
        b=TJkPHQJREtU3wlyLWFufHgjAnEKWV6MPzN6ugzLvdQPWryghJgX5M/ASOXgSPMroTI
         8Cbv8QOUOQNGaRvvyaPpuvHpb+Vm2ngVVgG/KLV5xd3mrG7wjVGhQhTonfreCM+AMSBL
         CxaXyPHxIbEdWtwtRMvcNTWrdt4+QoRpLTCqIa0fvxv0ROFh2GEZ0Z2CGCDD6jS9kKLH
         3FgNOyh50U6LvEsB1v1VUNL5EXljIU+StHuGm6c7ci9snCy8z7IDSevyH4/pE8K4qn5G
         Qpq7+fJXvLzNJGTLDThfqTVQQ4wyo9Ub2neR5YvHYxP0J5aJCK3ShFCMAHKowvZ6VGOV
         cXkQ==
X-Gm-Message-State: AOAM530TIlCztdF3i9OjhPhryp5V15jgYHe8kUP1zjwLp+K3CKkrFFSy
        qu8K6XyojsCTewmEx0/ydhK87Au5NR9tP6R91FE14E7YECuGyZkgA+Ax95I2kvQxqrn4weL4trR
        X1EtyvbJW0QGS
X-Received: by 2002:a17:906:eda6:: with SMTP id sa6mr25760758ejb.443.1633503400886;
        Tue, 05 Oct 2021 23:56:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRCEWg6sFWHgAZxAqk+17ELwV6v2RpvEUUC2eCzGOjfWloxHfVfzRRZi2235VjOzwS7iPORw==
X-Received: by 2002:a17:906:eda6:: with SMTP id sa6mr25760739ejb.443.1633503400725;
        Tue, 05 Oct 2021 23:56:40 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id u6sm9591413edt.30.2021.10.05.23.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 23:56:40 -0700 (PDT)
Date:   Wed, 6 Oct 2021 08:56:38 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, will@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com,
        christoffer.dall@arm.com, pbonzini@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH v6 09/12] KVM: arm64: Initialize trap registers for
 protected VMs
Message-ID: <20211006065638.hiroylzs6vo2j6j4@gator.home>
References: <20210922124704.600087-1-tabba@google.com>
 <20210922124704.600087-10-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922124704.600087-10-tabba@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 01:47:01PM +0100, Fuad Tabba wrote:
> Protected VMs have more restricted features that need to be
> trapped. Moreover, the host should not be trusted to set the
> appropriate trapping registers and their values.
> 
> Initialize the trapping registers, i.e., hcr_el2, mdcr_el2, and
> cptr_el2 at EL2 for protected guests, based on the values of the
> guest's feature id registers.
> 
> No functional change intended as trap handlers introduced in the
> previous patch are still not hooked in to the guest exit
> handlers.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h       |   1 +
>  arch/arm64/include/asm/kvm_host.h      |   2 +
>  arch/arm64/kvm/arm.c                   |   8 ++
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  14 ++
>  arch/arm64/kvm/hyp/nvhe/Makefile       |   2 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c     |  10 ++
>  arch/arm64/kvm/hyp/nvhe/pkvm.c         | 186 +++++++++++++++++++++++++
>  7 files changed, 222 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/pkvm.h
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/pkvm.c

Regarding the approach, LGTM

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

