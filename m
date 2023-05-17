Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD36707431
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 23:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjEQV0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 17:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjEQV0w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 17:26:52 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E931732
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 14:26:51 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-517bad1b8c5so1176526a12.0
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 14:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684358811; x=1686950811;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7aLwMNNZ7THbUm/ibMfTeaBcnWfdNE0xdsaZCsKooo8=;
        b=eLvvouwa/T3SIA/wCbtkDO3ClC96pQ+4JcdvmLbPMhUiemc9qbYtVUic73gYWQ5qLx
         QRSTwjb8LJmedqG4R2QNl5VSXsZ5pj0DzTYFeGKwh+onT0jFF0rYI1VGE9LTfAZbjj9b
         VJOIIY1WjIOK8niCCoeE355dACVc4KJtSYhLOy+J74QrufcN0A0NK2yNAHKOxnvBIuuL
         W691zzSKMcgYqWFKZkvIhqk1fOkhdKAEy2VmwdUFkxMCaR3DrZOh67dM1IiW0NaPtE83
         B4BVqgyhzzqMd765k6Glt+80KOdeah7nW2FrcjbLpesxsiOZ31h76aQ/tsa3IFji6VE2
         0Pxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684358811; x=1686950811;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7aLwMNNZ7THbUm/ibMfTeaBcnWfdNE0xdsaZCsKooo8=;
        b=BFzom1WbOuyEsVmNabpHYkdNaPf3t6dBEc2Eh3l33tEpLG5FyEehJUBo6+mCLShiBa
         qXdWnEq95KJMIm+Kzkm3K64yIPmJbShenbJCk4623xXLY0aKxKxMl55KUfsYfSeA9DKY
         O64o+YKjf4tDECd3XjbOPN0mXmVq5HmlHJKUsyb3hvqqjSxOp264dbf1uJ/1CKxc6i+L
         TRdECqTbSonVPyiv8lHMsD9PlSbjJC81Eil0S/AqrBtVfpy9qSYoBRtn0gpxlNV1xKWz
         8CBR3H+ZijIMQvXE8JjLF9bi55z3H+XdCU4SPyxOqsycBGNsfHsvPqIiiA4buqnCXmg+
         +Iew==
X-Gm-Message-State: AC+VfDy4Ip6yBuz/mWNB3MXu16vCL/Pxfetrnxp+YVTuy2+cRlHoTIR2
        gTZzHy3ydgcDuGX6WXEl8ANMf65MdrA=
X-Google-Smtp-Source: ACHHUZ6MWd33Mlnt+4OxhzKnqu6BxRsTK3Re1/4i71IPViyqQy95aDKNTvq5sgtGEAmyyNA1QA0KIZEZJjQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:792:0:b0:51b:fa5:7bce with SMTP id
 140-20020a630792000000b0051b0fa57bcemr60801pgh.1.1684358811032; Wed, 17 May
 2023 14:26:51 -0700 (PDT)
Date:   Wed, 17 May 2023 14:26:42 -0700
In-Reply-To: <20230423101112.13803-2-binbin.wu@linux.intel.com>
Mime-Version: 1.0
References: <20230423101112.13803-1-binbin.wu@linux.intel.com> <20230423101112.13803-2-binbin.wu@linux.intel.com>
Message-ID: <ZGVGkpvWQqLX2BrV@google.com>
Subject: Re: [PATCH 1/2] KVM: Fix comments for KVM_ENABLE_CAP
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 23, 2023, Binbin Wu wrote:

Please write a changelog, I'm not willing to trudge through KVM's capability mess
to determine whether or not this is correct without some effort on your part to
point me in the right direction.

> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
>  include/uapi/linux/kvm.h       | 2 +-
>  tools/include/uapi/linux/kvm.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 4003a166328c..1a5cc4c6b59b 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1605,7 +1605,7 @@ struct kvm_s390_ucas_mapping {
>  #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
>  #define KVM_SET_DEBUGREGS         _IOW(KVMIO,  0xa2, struct kvm_debugregs)
>  /*
> - * vcpu version available with KVM_ENABLE_CAP
> + * vcpu version available with KVM_CAP_ENABLE_CAP
>   * vm version available with KVM_CAP_ENABLE_CAP_VM
>   */
>  #define KVM_ENABLE_CAP            _IOW(KVMIO,  0xa3, struct kvm_enable_cap)
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index 4003a166328c..1a5cc4c6b59b 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h

Unless someone objects, please drop the tools/ change and let the perf folks deal
with their mess.

https://lore.kernel.org/all/Y8bZ%2FJ98V5i3wG%2Fv@google.com
