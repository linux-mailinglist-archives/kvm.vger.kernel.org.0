Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019C272EFEF
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 01:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbjFMXVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 19:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjFMXV2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 19:21:28 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171AE199E
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 16:21:28 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bc5281cc3f6so155418276.2
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 16:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686698487; x=1689290487;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rRUrHSH26yxUf3XX5IEKdtAXMoDIfZWbd9EcIvkDdPI=;
        b=irIrDPhY4Yh0GCQbiA9tXZ0RPofQNHB5T+EkrG7gnWzOenAwAFZZ1pUe5STvq4lr5P
         zoXNH03n1AShpdEsyQfQ25VEl6eKrycstNX6T09Eq72ub2NlyzWJ44LTsF4Sz5UjqNz3
         r79b4JM7ykeXtYkyLhgws1+GtQIMMVG2uV92gSibhrfpH6lnk4hV5f+wujMg9p2Vo5dM
         oQF0FYS3dzDakWVYqJk131zojZrJ8TvGOn3naovsTRkQ7Qg9Pc0pPG0hvrHipG3u9Dlx
         gLx626dLnZWQQQS+p8Cg+R+VI5kV9uj4oY4BgPxuiTK0RlbgLWTmhlALvdGSQin0WQPf
         VDUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686698487; x=1689290487;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rRUrHSH26yxUf3XX5IEKdtAXMoDIfZWbd9EcIvkDdPI=;
        b=NmCxKjZ6tw4YQ9A3g6ephKvnaCqyOqLrKNmB5XP0Oo1vFeFiksSlLxTR7782Gaa0yl
         KissScXFj8N+IsJvaF24S90Z3zJliQA1vxDb7zmIuGg6GphjqlLTb223FSEJI/J4mRRV
         qUKWSdTeAvtr0hifUx4NR1IOjuYK2mWmmFMIiRNUEM5Rkl2bVn2d8frJfpxtdjbqilaI
         ZcRZye5PnVts5BsOv2RFMcFM9FBuccsUVvP86VdqSQjo4ZUiNq4IxCSMJvViIxrWkvs7
         XLAgRyRyJWJ2ezPyzMZVpb6BFa5idcGe6MD63umBHIf2mlT8T/SDPiafV82d5S0X2jeO
         zzPg==
X-Gm-Message-State: AC+VfDwTTw8x0yRYyZdUTqjlsDsu0WuqoK32QLVOQ8QzzXNlUUxg0MKF
        SdiZqqHEeepYC2ZHJCGdg4ew18gsT0Q=
X-Google-Smtp-Source: ACHHUZ6mnfQkahdam/AKGI8fNsF7WiKo+hHNPJISK2mYa0Nx8ra9+plMOKzkoNW5ToeYgkHovLOasJH7uRc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e7d1:0:b0:bad:99d:f087 with SMTP id
 e200-20020a25e7d1000000b00bad099df087mr275938ybh.6.1686698487369; Tue, 13 Jun
 2023 16:21:27 -0700 (PDT)
Date:   Tue, 13 Jun 2023 16:21:20 -0700
In-Reply-To: <20230207123713.3905-1-wei.w.wang@intel.com>
Mime-Version: 1.0
References: <20230207123713.3905-1-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <168669156216.1981817.754694297087439405.b4-ty@google.com>
Subject: Re: [PATCH v2 0/2] kvm_io_bus_unregister_dev cleanup
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        mhal@rbox.co, Wei Wang <wei.w.wang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 07 Feb 2023 20:37:11 +0800, Wei Wang wrote:
> This patchset moves kvm io_device destruction into
> kvm_io_bus_unregister_dev. This reduces LOCs a bit for users and can
> avoid the leakage of destructing the device explicitly.
> Accordingly, below cleanups are included:
> - remove the exposure of kvm_iodevice_destructor and the invocation in
>   the users as kvm_iodevice_destructor is now invoked in
>   kvm_io_bus_unregister_dev;
> - Change kvm_deassign_ioeventfd_idx to use list_for_each_entry as the
>   loop ends at the entry that's founded and deleted.
> 
> [...]

Applied to kvm-x86 generic, thanks!

[1/2] KVM: destruct kvm_io_device while unregistering it from kvm_io_bus
      https://github.com/kvm-x86/linux/commit/5ea5ca3c2b4b
[2/2] kvm/eventfd: use list_for_each_entry when deassign ioeventfd
      https://github.com/kvm-x86/linux/commit/cc77b95acf3c

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
