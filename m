Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B050C4C3BC8
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 03:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236808AbiBYCjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 21:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbiBYCjx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 21:39:53 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A106D2692C0;
        Thu, 24 Feb 2022 18:39:22 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id e140so3175796ybh.9;
        Thu, 24 Feb 2022 18:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pTsZzg/pNKFr2hWFG//CQ6XxTfh3dzcK2BO2A3lElRQ=;
        b=JgOnSbHGt0kQc1UcIqIYKjijojNyQkZyiW+34pqpymX7OU/AtdWxDYGi177M3P0fKY
         tweTXwTO0D/8V+RGtA9+aycnbH5HK2fGAcUeBl2q3k8dk5iBKBSwq4DMZsqieWkUOK+6
         vJnwdEZD9ubQ9LmbTgMtXM4AisfgWoRmMnVMBTrWwlpMkernKaMOv1wPovvaQ9DPwGmY
         tgbWSka3cn8i2W7TZ/5TASxPwLewR18+XbUo71S0fKyIUSRH9HbNV1/RKSD4gLl7DvPX
         qzZsNbffxVr9zFmMopgSs3CetR004dihJm0SD9YsW36jVJLIONjaM4zMvznmCEwHQuhe
         sJ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pTsZzg/pNKFr2hWFG//CQ6XxTfh3dzcK2BO2A3lElRQ=;
        b=QbfFP1jkgmuOCihCriIpJwcYJft9mmGl69tL2pXZzwo9XOLpS+2W3R9icvYMiUF8N8
         Cs+b4XjwHdMyYtOM+q/BiGc/0LB5f3d0tENR0m4M+OyRisEHnY33j1dpM+vtTTLK8eZJ
         PKpPpx1PFoxh2RJ5iygdJ+eJhA6EyYq0+yL2hC9/05o0eQ0zAtZ2AVNvJpBWEU8Dlv7H
         ee78Fy7bagLvQNB4KbBBNBcALnhApDFw41ZJyfNGkqYMylj4ynQ+JB+DASiwC8u5S80G
         W1isyh1CIR5ITZAyj0BW5BtGH2RT/smm33DcrERjJVmUZsx6q24UEI1EzbgUxSaj95yD
         gDGw==
X-Gm-Message-State: AOAM532qzkClDzrTpYN1Dw9MawyNnMAdDSnk7uCHPpPUNMHFVYW2LGjf
        vQvJ1cJDNWqiKn1l6xOEKyGE5DHroCAtmRO0VEA=
X-Google-Smtp-Source: ABdhPJznfxnX04mYPXKxPyVeCeJWetHiXCRuUka3SsSUmL+Ed1dfmYatcs5R6ha0lbq/sneDrKtrFK4iF32XzwqV2dY=
X-Received: by 2002:a25:8886:0:b0:624:50e0:3428 with SMTP id
 d6-20020a258886000000b0062450e03428mr5315065ybl.552.1645756761966; Thu, 24
 Feb 2022 18:39:21 -0800 (PST)
MIME-Version: 1.0
References: <20220224191917.3508476-1-seanjc@google.com> <20220224191917.3508476-3-seanjc@google.com>
In-Reply-To: <20220224191917.3508476-3-seanjc@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Fri, 25 Feb 2022 10:39:10 +0800
Message-ID: <CAJhGHyDNpAKnaAQCyU6RmdrMs9JVURuABXVBVykbU7BH_Cuizg@mail.gmail.com>
Subject: Re: [PATCH 2/2] Revert "KVM: VMX: Save HOST_CR3 in vmx_prepare_switch_to_guest()"
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022 at 5:07 AM Sean Christopherson <seanjc@google.com> wrote:

>    switch_mm_irqs_off+0x1cb/0x460
>    __text_poke+0x308/0x3e0
>    text_poke_bp_batch+0x168/0x220
>    text_poke_finish+0x1b/0x30
>    arch_jump_label_transform_apply+0x18/0x30
>    static_key_slow_inc_cpuslocked+0x7c/0x90
>    static_key_slow_inc+0x16/0x20
>    kvm_lapic_set_base+0x116/0x190


Acked-by: Lai Jiangshan <jiangshanlai@gmail.com>
