Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F766C86FB
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 21:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbjCXUns (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 16:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbjCXUnq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 16:43:46 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652CB5B87
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 13:43:45 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l1-20020a170903244100b001a0468b4afcso1802453pls.12
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 13:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679690625;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g9FsH5f+Xb8IXPDsf4Vq2M9YTg13c83UJ3Vl9FncU8A=;
        b=R1CJAKUEiFUCOywhblEqKTuQ5/frQjfKCPjzY4EmGXnG/FZ8Mvl74UQXykJLT4izLW
         AC8Ga8LOADJ9jErvWBObdzLpjfKSPgoezDRFEkJI+4xJ5sSwPLpjJcb7SsFf/JZedd4g
         M44BNIsx8ZTxhshB1B0CI0siKLtgDNfkPvGG7N2Ltv9n6WO9Z8elgJ+MiA3TfoJh/lXb
         JHYrBxc46scu7edRhrqSNAK8P2K7QTVZz49wi6pdGRicPOuhFPDwlgc/Y5+QUUx66s4L
         q6FLJj9urtUdO4i5coFLMS/Q3yDAjLJmSNap9VFNAx4RPAoZXofFgNlMgFXkC48AVw93
         jQhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679690625;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g9FsH5f+Xb8IXPDsf4Vq2M9YTg13c83UJ3Vl9FncU8A=;
        b=74nP26gkPiK+RNwH1HuJCJ50CBvy/0/Dc3tZTs3Rn3vW/50wnQPo3OlAahFZUulFr7
         kIcUaUm6cc+Rj7mi91twnCVnot8QDNMv21v+KkL8c+/b1eqvdJ+4dKYqBsi9Zcd+h22f
         H7gcLlILCxt//JIgVCIH0v2CdF8ZHlT/O0UsGllBo/ww0cFpl52PN+0qxcA/siK9XaDY
         GQrH6xxWB1jmgNuqtih1rtgRcsaUgO/XAQ6EIEvMPfNSJfVj19L+gSIV0xFhC+SBFuxO
         RujfklmJrpMsv0E6RrrXMvJEcLpGlo2XRJa/7KWPiyNOK3BCoeCTtYjfEkJi+/+dAdbu
         yLOQ==
X-Gm-Message-State: AAQBX9dCco9K1/JNzd2LNUkFLC5I06kJq/l1wnjGx3JjE1eYoImMQD/1
        lRM/K39YXPalJMRK8wSWKEB1ufwY32Q=
X-Google-Smtp-Source: AKy350Ymjfg+3M3Dv4LBikspPO3ElnhrQ/Ms1LmMDrfGv3OrehR2cc7M3jW6S4kdjDad2P2FdlyI1gKgqVo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:5141:b0:23d:50d0:4ba4 with SMTP id
 k1-20020a17090a514100b0023d50d04ba4mr1256858pjm.3.1679690624943; Fri, 24 Mar
 2023 13:43:44 -0700 (PDT)
Date:   Fri, 24 Mar 2023 13:43:43 -0700
In-Reply-To: <20230221163655.920289-12-mizhang@google.com>
Mime-Version: 1.0
References: <20230221163655.920289-1-mizhang@google.com> <20230221163655.920289-12-mizhang@google.com>
Message-ID: <ZB4LfyVjDuncOsM7@google.com>
Subject: Re: [PATCH v3 11/13] KVM: selftests: x86: Remove redundant check that
 XSAVE is supported
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 21, 2023, Mingwei Zhang wrote:
> From: Aaron Lewis <aaronlewis@google.com>
> 
> In amx_test, userspace requires that XSAVE is supported before running
> the test, then the guest checks that it is supported after enabling
> AMX.  Remove the redundant check in the guest that XSAVE is supported.

It's a bit paranoid, but I actually don't mind the extra check.  It's not redundant
per se, just useless in its current location.  If the check is moved _before_
CR4 is set, then it actually provides value, e.g. if something does go sideways,
will fire an assert instead of getting a #GP on set_cr4().
