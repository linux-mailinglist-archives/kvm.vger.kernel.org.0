Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440EB69FB14
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 19:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbjBVSje (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 13:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjBVSjc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 13:39:32 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52422D14D
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 10:39:31 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id q5-20020a170902788500b0019b0c60afa8so5135608pll.12
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 10:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1RX0usnmg54lDWkRfTdJaybq9v0ennM6mLW3m9XCSVk=;
        b=dHlkLbxj7oVZhPWN9VK1XIGSE8j9w1WDljtOSlDVt0y057HlUP4h9F4yHngWwJPkEj
         PQqTGNrD2PFs6kuiihbTD8ypAtiBfXtIYUC8xgr6U18lwjwCnEvxUMlfAePYGGGLI9A8
         1Q9WU0wrrMXDWaDWm2Hvg5VrtzNmd4yZuFidDo8W4BXxwr3hGy/Av0/Nh/wxUMMfwNrx
         zGImFPOF0jQxK93E4SD0QlQXEHMaVl7i5PS0X06BUBNKLKtRsQTmMYdfNwP78VdeVDTH
         bMW0RQCBXgGFEA+L+of+7fo6IYkvZOtkkKi77r8ichXwD9vOQneqon/YxKD/jreYm6Da
         D5XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1RX0usnmg54lDWkRfTdJaybq9v0ennM6mLW3m9XCSVk=;
        b=cL9MnnWqueOxPBVQmPskZvJABEX3h+jaA2Bw6yvtkPCT/C6AGWjNu//tVRQSYz09sI
         ztnZ/TpGemxL6/QXpLymVYd+LTTYc4OW5RGTN+jXCcPNnhSqKhAxdkEQhqizab4xw+4s
         c8MpgGU8qFQvfzbsqU4IhCTyzlq+owOnYiqhrL2lnBdXbIMrKtcFY6vyK3UtZcsqLMmf
         IlQ/bDRuyMdK3w0/CMs4gXiFp85IS7+hYPLcryTelfRapzJWV/5ptIL2ibBBoScUNC84
         IQZQVLXr4D7W8ZPiA3vnBZ5JFVGogyjDg2A92i6PNPwYUAcvM3guah7kE3R8tffZYR0D
         2+Pw==
X-Gm-Message-State: AO0yUKWnLT15RKZ9a+90Y2qIq1ZGigVc1ra/HpHokLShvwSnrAsi8avu
        X07IC20HHjfoa1LYrOee0aVndhd+iyQ=
X-Google-Smtp-Source: AK7set+5dRB8iLmwnKzhs7QvBP57/KrG+2y4uCZ7f6ytg7iZfRgE8z0UbaB0ZlzERRTIoeNciM4bw5J7PfU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3e4f:0:b0:4fc:a80e:e6ec with SMTP id
 l76-20020a633e4f000000b004fca80ee6ecmr1209989pga.5.1677091171417; Wed, 22 Feb
 2023 10:39:31 -0800 (PST)
Date:   Wed, 22 Feb 2023 10:39:30 -0800
In-Reply-To: <20230220084500.938739-1-jun.miao@intel.com>
Mime-Version: 1.0
References: <20230220084500.938739-1-jun.miao@intel.com>
Message-ID: <Y/ZhYiN+oYbx6z5n@google.com>
Subject: Re: [PATCH] KVM: Align the function name of kvm_swap_active_memslots()
From:   Sean Christopherson <seanjc@google.com>
To:     Jun Miao <jun.miao@intel.com>
Cc:     pbonzini@redhat.com, corbet@lwn.net, maciej.szmigiero@oracle.com,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nit, "Align" is a confusing because it's often used to refer to indentation.  Maybe?

   KVM: Fix comments that refer to the non-existent install_new_memslots()

On Mon, Feb 20, 2023, Jun Miao wrote:
> The function of install_new_memslots() is replaced by kvm_swap_active_memslots().
> In order to avoid confusion, align the name in the comments which always be ignored.
> 
> Fixes: a54d806688fe "KVM: Keep memslots in tree-based structures instead of array-based ones")
> Signed-off-by: Jun Miao <jun.miao@intel.com>
> ---
>  Documentation/virt/kvm/locking.rst | 2 +-
>  include/linux/kvm_host.h           | 4 ++--
>  virt/kvm/kvm_main.c                | 4 ++--
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
> index 14c4e9fa501d..ac0e549a3ae7 100644
> --- a/Documentation/virt/kvm/locking.rst
> +++ b/Documentation/virt/kvm/locking.rst
> @@ -21,7 +21,7 @@ The acquisition orders for mutexes are as follows:
>  - kvm->mn_active_invalidate_count ensures that pairs of
>    invalidate_range_start() and invalidate_range_end() callbacks
>    use the same memslots array.  kvm->slots_lock and kvm->slots_arch_lock
> -  are taken on the waiting side in install_new_memslots, so MMU notifiers
> +  are taken on the waiting side in kvm_swap_active_memslots, so MMU notifiers

Can you send a v2 and opportunistically add () to the blurbs that don't have it?
I.e. so these are all "kvm_swap_active_memslots()"?

Thanks!
