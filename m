Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5FF06D8ADB
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 01:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbjDEXCf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 19:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjDEXCe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 19:02:34 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F053A8D
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 16:02:29 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id ay18-20020a17090b031200b002448cceda65so118248pjb.4
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 16:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680735749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eLyQcbHl1dgPfgX04HmDEMBn58u/qT78uUf4saC60PY=;
        b=i/WNoIzTe2DHiKgh/gDP9Hg/xZjdX0MlaDBpYS8TPwKSF+ibIcG5CetJxQI+PokmLZ
         mK3g/FvqAt+MvCNAzIivm21hqXBFPe1/dMPKUerNedGJnbsysEgE1sKSKo/94CZmE4Zd
         ZjJGk7fSK9/7wk7qSaFpxfjuIaBdejpsWx0AOB9lJB+oQ7kniXxy9tcpMOosbADYUY0Z
         tIRy3bxKOZbkcLq7OoPp+UoyuSuzJSsEwzzn+Wfth9e8DLMVLmr2eBCYXqzFN7EOMxXe
         GsBwyPVc74Krm/Bn5n1SUPXfOugB2c9GuL1AGO6Cr2uC7azzyMr3IzeNiyU2dXzjRJHG
         UePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680735749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eLyQcbHl1dgPfgX04HmDEMBn58u/qT78uUf4saC60PY=;
        b=pq0QvUnCW+0nd3LV+cRNmmZyGw8QVOBN1Wn5bkpxOvh3g0YGFTidOzR9YnmNm4TLb4
         JSn6kTBb0s+DnHb0UifH6VecuB3iNcZ0lrhAVFA8NBTlLJuOsmX7Z0PKj547ylFLAp5+
         fPHCu1VZRYkTYhqY9/ayeeZq0AOcjPZk2XDIMFeicTGu5Uwb0yOPbu3+wufid6bKdTfp
         T62UXhtyhzP6G+eTuVoosRTd45/TeXbERvUeZslsxR/4ZB60U5atMB6lur7d7BXDIRCz
         f7omowQVWinTj8VWrtQ4JQga4mgt4Vna2BxSHKJAbSOG+n0cInZ5SkpdEFBPfHzMPr0J
         8tzw==
X-Gm-Message-State: AAQBX9eJKlTIRjd8rD/jekLpBpisT6E2k+JUskbA0bW04oSC+9eJ7Vtp
        QTc68criHkVA7kbx94md6DzNzipMnyU=
X-Google-Smtp-Source: AKy350bhSbcb3+k/cNUnY9OQQjt/Kv9KqJzgeK0IM0O0A3pdYe8zokfhPyliiSJiXJ0Wx/j7qxRUQoX6tn0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:23cd:b0:625:5949:6dc0 with SMTP id
 g13-20020a056a0023cd00b0062559496dc0mr4185656pfc.4.1680735749273; Wed, 05 Apr
 2023 16:02:29 -0700 (PDT)
Date:   Wed,  5 Apr 2023 16:00:58 -0700
In-Reply-To: <20230328050231.3008531-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230328050231.3008531-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <168073539916.619396.2022776886010312670.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/3] x86/msr: Add tests for command MSRs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Mar 2023 22:02:28 -0700, Sean Christopherson wrote:
> Add testcases for the write-only MSRs IA32_PRED_CMD and IA32_FLUSH_CMD.
> 
> Note, this depends on the x2APIC MSR series[*].  Unless someone yells,
> I'll include both in a pull request later this week.
> 
> [*] https://lkml.kernel.org/r/20230107011737.577244-1-seanjc%40google.com
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/3] x86: Add define for MSR_IA32_PRED_CMD's PRED_CMD_IBPB (bit 0)
      https://github.com/kvm-x86/kvm-unit-tests/commit/056a56f6e8d0
[2/3] x86/msr: Add testcases for MSR_IA32_PRED_CMD and its IBPB command
      https://github.com/kvm-x86/kvm-unit-tests/commit/835268e75d12
[3/3] x86/msr: Add testcases for MSR_IA32_FLUSH_CMD and its L1D_FLUSH command
      https://github.com/kvm-x86/kvm-unit-tests/commit/408e9eaae1c6

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next
