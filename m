Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B723E78F1E4
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 19:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238292AbjHaR1p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 13:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235154AbjHaR1o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 13:27:44 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73DBCC5
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 10:27:39 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58e4d2b7d16so13856287b3.0
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 10:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693502859; x=1694107659; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IGpYSMSGMaMzVYXbXpIcBRTqVDSQW/Rx6E1NVn3C2WI=;
        b=D2LvzS5dZiZ9/CK/5zTOt29VtHM3TidntcLTu9rBgty3Ip1WQOB2Pncaeh81DelHiu
         qv2zsU8zwc2TR1kfkrsKa3I9GUmmIbTAVHx1b1cII05lZjRlQxk9LYXVNhJxIhWGEkch
         lzaYSy8N7uoNqEL6DBOZgSDI765n3B7AYzD/5+UGJKOFBQ592DsX9Zwuyo/NIOvobr60
         qKXj9AsgoLf+sTuc/qOhb+BK9aCcggX3KUc7GWAoo33R3hcjtX2LzOcPWRfK9yxpTrVq
         BRfadbG7DVT+JCzInnxekjgMtJYZq2MIuXG/Mx8Lr9WSo+AsOmdXs87Espn/T2I9PF61
         kVZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693502859; x=1694107659;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IGpYSMSGMaMzVYXbXpIcBRTqVDSQW/Rx6E1NVn3C2WI=;
        b=OoCPpXrpPCtyd94pmDVsef4hqfutOVJLEaIygzYzxcaMvjYfMl2iin/xPhMcHFmKm7
         lv+gninfugWAcK5jHgrNNO3GkcW+Lt5zT7HCX7ltSz97v9+qwJ8GqKc91a4MdDlEekcS
         FeveUAqn4HvuZ6LnPhN0Fp/XtVgtSXolE38QHHqS4oWvLmHo3qya3w9zGc2XbgdwDKCX
         TJ6uAITO2UyhqXsFQZx9kgMrnwPu4rt0/iKYHpXtq7afvDuNxYdl+F8XYMaKX/iF/LgH
         fckGmzounkklOjYj/FVdEIho2Vn4g6AzZcLnE7E8OPgP/G1q772k3RNYH72rHymM75IP
         fCdg==
X-Gm-Message-State: AOJu0YyVGnb9VvfhnXoWpJ4olGIgISl9vrxQtwlsC7qNGFZx3r0ND69s
        WElAtn4mYi1/XDbCPjTsawpdXBujgqw=
X-Google-Smtp-Source: AGHT+IHM52+LHk+bvLLVf508Bnog5bhIewQ3dWNXxgaPeqnmLFShqhUA5zjqg8Ns0fvK1Y9OaOvKBSAvIJc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1828:b0:d09:6ba9:69ec with SMTP id
 cf40-20020a056902182800b00d096ba969ecmr9641ybb.4.1693502859202; Thu, 31 Aug
 2023 10:27:39 -0700 (PDT)
Date:   Thu, 31 Aug 2023 10:27:37 -0700
In-Reply-To: <20230830000633.3158416-4-seanjc@google.com>
Mime-Version: 1.0
References: <20230830000633.3158416-1-seanjc@google.com> <20230830000633.3158416-4-seanjc@google.com>
Message-ID: <ZPDNielH+HOYV89u@google.com>
Subject: Re: [GIT PULL] KVM: x86: MMU changes for 6.6
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Like

On Tue, Aug 29, 2023, Sean Christopherson wrote:
> Please pull MMU changes for 6.6, with a healthy dose of KVMGT cleanups mixed in.
> The other highlight is finally purging the old MMU_DEBUG code and replacing it
> with CONFIG_KVM_PROVE_MMU.
> 
> All KVMGT patches have been reviewed/acked and tested by KVMGT folks.  A *huge*
> thanks to them for all the reviews and testing, and to Yan in particular.

FYI, Like found a brown paper bag bug[*] that causes selftests that move memory
regions to fail when compiled with CONFIG_KVM_EXTERNAL_WRITE_TRACKING=y.  I'm
redoing testing today with that forced on, but barring more falling, the fix is:

diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index b5af8249eb09..cfd0b8092d06 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -306,5 +306,5 @@ void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
 
 bool kvm_page_track_has_external_user(struct kvm *kvm)
 {
-       return hlist_empty(&kvm->arch.track_notifier_head.track_notifier_list);
+       return !hlist_empty(&kvm->arch.track_notifier_head.track_notifier_list);
 }


[*] https://lkml.kernel.org/r/7a6488f2-fef4-6709-6a95-168b0c034ff4%40gmail.com
