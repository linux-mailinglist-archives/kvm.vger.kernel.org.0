Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73B1D5E6D85
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 23:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiIVVCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 17:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiIVVCH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 17:02:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7236DCCF7
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 14:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663880526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NrC2ybEc8JLdF17QEo6DYU80wCTIo9mOjzD9ZgdBMrA=;
        b=ao0yWztxEoZCbEfnFQkUm+L+SdrR35A3fQZkMHQvsWOamo3OvmgsLu7OxFxJHCjKqgQFAY
        aPjSimw5UERp8NJbEx8EHCxBzB6XtRwbKsj6Xik8bKpAbdYpxe/u4us2HqC7XeNU693Wri
        UJ+1ua84ArzdwVYPILj4Q6ZmpcLpdDk=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-660-DR6uAEKfPCaOdEGnCv9C5A-1; Thu, 22 Sep 2022 17:02:03 -0400
X-MC-Unique: DR6uAEKfPCaOdEGnCv9C5A-1
Received: by mail-qt1-f197.google.com with SMTP id d20-20020a05622a05d400b00344997f0537so7258925qtb.0
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 14:02:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=NrC2ybEc8JLdF17QEo6DYU80wCTIo9mOjzD9ZgdBMrA=;
        b=kakqCbRcBVL0IbBKLGUK7W49djsETnRHRI3MOTuXclBGStnsneQW5HgcpaDOwMUtJk
         0mxxbhVhekTuBGanM9Dqphw+8jFP3G2t3KECcNCc6OWh52oic+YxHv5odFEUA05LmFnZ
         03afhgT+V5/20wWsAm68k3qTIyoccRPlPitPY3VN6MCd2wiwwHs51OL7Tb4vGPBy32he
         1KevYQDOqAq2f+jty5TmBEZ3sco/nyi+ENPTm6ZN61ELaS5MUZXIUFgEkh/nxaUw1CUg
         XlX+dzupvW6/IEHAFDDcPt5OhlzG7W2fP5q1AeFDaqVaXGfvCyJqPcC6NlmGZeLKCKyS
         BZ4A==
X-Gm-Message-State: ACrzQf2U35phksqqq3UyhsBnkpPp6gnspxoLPnY/MvgwiVrXeVu77b1R
        nkDbm0cNbzoboR05JOkwAKR2pzzFhvpB6Y7Tb8wbZZjni70YffBotmQKEx0ZmjYILUkA1SQ0umf
        k97v2Bax37zedf2tB7MLc6gB4Fr3l
X-Received: by 2002:a05:622a:1a02:b0:35b:bb29:fb86 with SMTP id f2-20020a05622a1a0200b0035bbb29fb86mr4456046qtb.456.1663880522923;
        Thu, 22 Sep 2022 14:02:02 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5+1iThcdKlBWRMN91eVYVdq5u8pl0QboZdJPJJcUB5kQOeMbl+s3pRZ+jdrGDTGMyG59r4Mby7gltxhspCalI=
X-Received: by 2002:a05:622a:1a02:b0:35b:bb29:fb86 with SMTP id
 f2-20020a05622a1a0200b0035bbb29fb86mr4456007qtb.456.1663880522662; Thu, 22
 Sep 2022 14:02:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220919171843.2605597-1-maz@kernel.org>
In-Reply-To: <20220919171843.2605597-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 22 Sep 2022 23:01:51 +0200
Message-ID: <CABgObfYgUSQNa-4i6iP1Ai7Bs7YiBBsEni3vxQ1=r-okeNfkNQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.0, take #2
To:     Marc Zyngier <maz@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pulled, thanks.

Paolo

On Mon, Sep 19, 2022 at 7:19 PM Marc Zyngier <maz@kernel.org> wrote:
>
> Paolo,
>
> Here's the last KVM/arm64 pull request for this cycle, with
> a small fix for pKVM and kmemleak.
>
> Please pull,
>
>         M.
>
> The following changes since commit 1c23f9e627a7b412978b4e852793c5e3c3efc555:
>
>   Linux 6.0-rc2 (2022-08-21 17:32:54 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.0-2
>
> for you to fetch changes up to 522c9a64c7049f50c7b1299741c13fac3f231cd4:
>
>   KVM: arm64: Use kmemleak_free_part_phys() to unregister hyp_mem_base (2022-09-19 17:59:48 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.0, take #2
>
> - Fix kmemleak usage in Protected KVM (again)
>
> ----------------------------------------------------------------
> Zenghui Yu (1):
>       KVM: arm64: Use kmemleak_free_part_phys() to unregister hyp_mem_base
>
>  arch/arm64/kvm/arm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

