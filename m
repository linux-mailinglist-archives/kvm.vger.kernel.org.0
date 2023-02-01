Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E72687111
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 23:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbjBAWjj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 17:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbjBAWjg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 17:39:36 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7BF20D36
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 14:39:35 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id t12-20020a170902b20c00b00192e3d10c5bso6470plr.4
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 14:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=amcATFasBpSs8MNI2KZjvtTtDn1HGc2e896fYt2Kp/8=;
        b=fVkLjhI/esXpbr02/JFz7657iuPwZG4MSprxP6l5IuHndZRem6MmzG057TF7jg0QRr
         avSuRmiXhX/a/Ol7wmMrrAQiEBRm+z2BzZx4DV28cq43XKZKmq7RzNqWGHwRPZCmr7p6
         ielRxk3KfClrtPfQdCIqOp7hZB9APb5BTdiNZvC6HovuBe0PR0MYbUCPqJLuteku0oka
         PtA2LezI9Mzc76mhc2ICYpfa0Yd5TlPiVluZAECJWOkP3ZBAkqTxxyVG/KgMplgkW4cY
         6lj3QA1s9BjogDLlBbV3ZIBWUvzl4XFTfxwTNNa+dwSM8AyjiTIwmHEukY4M4i97GPtG
         K18A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=amcATFasBpSs8MNI2KZjvtTtDn1HGc2e896fYt2Kp/8=;
        b=tOAszovU5I9kYnr92VHFWkIMrlTjqKy1/5hv45FMn8UpwWYYPcb/JRTkZYFDRmCfbk
         eg8MkfqeMFtMxKldbfQl6kXskHqX50pw+AD9YXE23NtzgPkOdbcXXDWpyvEvPJbx/PfQ
         thpdiOoZa+2VEaUvmY8hRnbl2Sq6Z/jVPx2eutyKFZnAGv9OTvrU/t5tvyHHGx2thn3l
         kIaexqbfRMmcmJT8K5fJsIj6zk+ZZgylSpTygJ9zOy9HdGrtUMCqCZ6G3HsF3sUtmaN2
         9yiot4+GaKhJY7kUEEOaRLuJ6alOCFghUdccvy9uLYKnietHeJF9VRim+XHhrgk1T704
         EA+w==
X-Gm-Message-State: AO0yUKU5YxQG+ANAQGw5KVRPn734p2VXkqLdJwX10pgeMs52TWhuSExS
        1IIKGa7Kg5WVbgndCIkDV2zQwUAS84c=
X-Google-Smtp-Source: AK7set9oSzf5kH5BczSyIXnDBULTTnuRaODOR0+mACIG6kdtSGJuCRV/EhejZUcj/DTIz5dsC3aFsrMw5lQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:33c4:0:b0:592:ecb5:f51f with SMTP id
 z187-20020a6233c4000000b00592ecb5f51fmr846308pfz.34.1675291174649; Wed, 01
 Feb 2023 14:39:34 -0800 (PST)
Date:   Wed,  1 Feb 2023 22:39:19 +0000
In-Reply-To: <20221212183720.4062037-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221212183720.4062037-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <167528978572.826771.13904811225670358495.b4-ty@google.com>
Subject: Re: (subset) [Patch v4 00/13] Add Hyper-v extended hypercall support
 in KVM
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, dmatlack@google.com,
        Vipin Sharma <vipinsh@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 12 Dec 2022 10:37:07 -0800, Vipin Sharma wrote:
> There are two patch series combined in this one because I have rebased
> my patch series (patches 8 to 13) on top of Vitaly's "Hyper-V invariant TSC control
> feature" (patches 1 to 7).
> https://lore.kernel.org/kvm/87o7szouyr.fsf@ovpn-194-185.brq.redhat.com/
> 
> Vitaly's series had some small merge conflicts on the KVM queue branch I
> have fixed them in this series, no code changes.
> 
> [...]

Applied 8-11 and 13 to kvm-x86 misc.  1-7 were already merged, and I don't
want to carry the sweeping TEST_ASSERT_KVM_EXIT_REASON() change, at least
not in "misc", and I definitely don't want to grab it without Cc'ing the
other arch maintainers.  I'll follow up in that patch.

[08/13] KVM: x86: hyper-v: Use common code for hypercall userspace exit
        https://github.com/kvm-x86/linux/commit/1a9df3262a63
[09/13] KVM: x86: hyper-v: Add extended hypercall support in Hyper-v
        https://github.com/kvm-x86/linux/commit/db9cf24cea69
[10/13] KVM: selftests: Test Hyper-V extended hypercall enablement
        https://github.com/kvm-x86/linux/commit/c4a46627e5a8
[11/13] KVM: selftests: Replace hardcoded Linux OS id with HYPERV_LINUX_OS_ID
        https://github.com/kvm-x86/linux/commit/f65092015a83
[13/13] KVM: selftests: Test Hyper-V extended hypercall exit to userspace
        https://github.com/kvm-x86/linux/commit/60325261235a

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
