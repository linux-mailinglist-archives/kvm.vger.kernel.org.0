Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33EF276DBED
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 02:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbjHCAEu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 20:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjHCAEs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 20:04:48 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CA62D69
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 17:04:47 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-583c49018c6so3024337b3.0
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 17:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691021086; x=1691625886;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=86rY/ZX4o3sTvcqKmgckScfeu8mwqdbfXr2MG0VjG08=;
        b=HPxE/cdN7rXiTJbxTtQ5G97tr/fBNYEVOt2e0Bi0Zmjpfo2w711w/ZxE8d9vWF6gjA
         LRtlqjZjZwk5fczyrxrnoxNAec0PJgtxTSW9Sh7AZEli9VIpVUaA6MCTGkjSzu7ULCwX
         SjdkhmSaXKj0h9UsB4OBcgWkDM+utrbW+pxxdiZLnabiOyTEnMGaA2pFLUwi3KdFkhZR
         bCclnx+PPg/RMRM+MmdKInwoI4U5uhW3i75nDyuCETn1efc4U60HbujvIUFARC93WsgX
         fgygfOR8u3hJxZCOXuvugoK4Xw71iyZxAv6Y06S7H1rVQFZXacUeaxuacXSw3n4yqxyU
         az3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691021086; x=1691625886;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=86rY/ZX4o3sTvcqKmgckScfeu8mwqdbfXr2MG0VjG08=;
        b=KiINJ33syA7eLFZjCLTQcl3pXhqVpoXEsfi7eMO76FMunpDQrk3Fya1yL29/8M/7ns
         G9/Rdr+yywCRJTAbqxyxXrT5Dbz+TmFqrabSvR3K+AtRYED2ItiZ6lo2gGn49NXjrpPG
         ePi1mlMqFZwRrHrHM5Hc2BoRqvssjei6YYYmFyrBk2uEakC8lsrolrx2J8mYY+NNpx2D
         inqiu7pL7WB+D8QBo+nhk6t1G6j/XZIEJHpUtifp2KQF9JPqFg6iEAYmsx2Ry/1/9G7G
         xIBqxkK8G78QWQTi/LzhUSApDoZw7lr9uQHcV3D2LmMsiOFMBjVwGoAQOny35YHbSo2r
         cugA==
X-Gm-Message-State: ABy/qLaSX+lNZwh62GA1Om/7QZvXi6q5egySdcFH4ePCokKUDH5m1Ol8
        214shsvJT6R2iTsrEIEr+y7gsDTc73U=
X-Google-Smtp-Source: APBJJlEl376xhHGdBm5QK9Z/Qb8WkWjxOW8rvs1TYnJP1fMW+s4WwxN+lNQt+cG4kt4zHWhd6AzUBnMm/ds=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a789:0:b0:586:5388:82ba with SMTP id
 e131-20020a81a789000000b00586538882bamr75718ywh.6.1691021086460; Wed, 02 Aug
 2023 17:04:46 -0700 (PDT)
Date:   Wed,  2 Aug 2023 17:04:18 -0700
In-Reply-To: <20230607004311.1420507-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230607004311.1420507-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <169101955030.1828845.4745877591921561605.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: x86: Snapshot host MSR_IA32_ARCH_CAPABILITIES
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chao Gao <chao.gao@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
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

On Tue, 06 Jun 2023 17:43:08 -0700, Sean Christopherson wrote:
> Snapshot the host's MSR_IA32_ARCH_CAPABILITIES to avoid repeated RDMSRs
> at runtime, and cleanup the pseudo-cache vmx_fb_clear_ctrl_available.
> 
> Sean Christopherson (2):
>   KVM: x86: Snapshot host's MSR_IA32_ARCH_CAPABILITIES
>   KVM: VMX: Drop unnecessary vmx_fb_clear_ctrl_available "cache"
> 
> [...]

Applied to kvm-x86 misc, with a fixup for the ARCH_CAPABILITIES.FB_CLEAR_CTRL vs.
MSR_IA32_MCU_OPT_CTRL.FB_CLEAR_DIS confusion in patch 2's changelog.

Thanks!

[1/2] KVM: x86: Snapshot host's MSR_IA32_ARCH_CAPABILITIES
      https://github.com/kvm-x86/linux/commit/a2fd5d02bad6
[2/2] KVM: VMX: Drop unnecessary vmx_fb_clear_ctrl_available "cache"
      https://github.com/kvm-x86/linux/commit/550ba57faa04

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
