Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CEE4624D9
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhK2Wbu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbhK2Wbp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:31:45 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C239C0698E6
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 14:28:27 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id k4so13325074plx.8
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 14:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qb3aXm+BA5Ia7gXPfB86sDSJOCEYidsMA7C1EHNFxFE=;
        b=NOsZWOJOfJXO1Pk9eoMVSVfCfxt3B+3igQuJqyokpPIUVHfg/7HIIdrDgLmRkOLsot
         HJuNDMd6AyuIixsg4fTvZ3VrPRnhz6rWB9JSJHBizWqm78CZYaNd7jLHj/QOzNnLx3y5
         PrnYMI0L539PXaAl/Oml1cKsb7j34Qi6NaLvL/+Okla9Tb0n+1JaNK4jgL9FHH+MuGkX
         cGeovkF/Go7RZMsPzEdcEYsDXL8oIFYZYe49B1L4eefUSPpP9lkC7et/m4T1uf/57Ei8
         sfBQOplfL/CjxVQfOnrCcgZ9SOzQq+e5vKH0loz0M2pohnISIsoW6EfniyZZSbxJrYfa
         YuyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qb3aXm+BA5Ia7gXPfB86sDSJOCEYidsMA7C1EHNFxFE=;
        b=BQQF94xIzMERp7OSoIMXwt2f0AQA6WeynpGwpl7vVG4OXDk4sjoqHcK88FO+ObL48d
         tCJAFj6D4HATHuMAjE+GMtATakBa2cqJ+AOh65LPq9URk2f0wj/i1iCqFQ2stsaxZzjY
         fmsb1EKBOcvKJCxUi1chxZut5edgCSTo1OhYVfykhpb+cZf7FaIHwIkT1t+CpyjMcDEP
         /mva04OwXXIRN+MuduR3K1e69zGBeL8IyCHQUC7p+T3+OAfNI/4Ver24oGabF27m4TmZ
         qTvPXuOYlfCny/RSRmifI6WMD171nsC1ifT1unvrUDanTsT1eyx2fAgBM2qRxMmE+ACv
         6PsQ==
X-Gm-Message-State: AOAM532idM3a9S8w26jK8xiBQez+0ulZ8hKdjNMwTNhDh2U5JdEnD2KF
        WAdYM415Wxd4Apnp0JITotnnpg==
X-Google-Smtp-Source: ABdhPJxvABtMr1ja365UozpBKiWE0/Yp9OkEqo54cSSBleqV2UXwGArNbbe9CYtub7yCgoR5cHgMKg==
X-Received: by 2002:a17:902:aa86:b0:145:90c:f4aa with SMTP id d6-20020a170902aa8600b00145090cf4aamr62802971plr.79.1638224906469;
        Mon, 29 Nov 2021 14:28:26 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f2sm19668270pfe.132.2021.11.29.14.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 14:28:26 -0800 (PST)
Date:   Mon, 29 Nov 2021 22:28:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pgonda@google.com
Subject: Re: [PATCH 03/12] KVM: SEV: expose KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM
 capability
Message-ID: <YaVUBv9ILIkElc/2@google.com>
References: <20211123005036.2954379-1-pbonzini@redhat.com>
 <20211123005036.2954379-4-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123005036.2954379-4-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021, Paolo Bonzini wrote:
> The capability, albeit present, was never exposed via KVM_CHECK_EXTENSION.
> 
> Fixes: b56639318bb2 ("KVM: SEV: Add support for SEV intra host migration")
> Cc: Peter Gonda <pgonda@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
