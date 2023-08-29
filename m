Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF4078C8CC
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 17:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237328AbjH2PmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 11:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237324AbjH2PmJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 11:42:09 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098B0B7
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 08:42:07 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d7b72288d44so629613276.2
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 08:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693323726; x=1693928526;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FM+v7KoHt1GJYjQWDGW6MffrxjUsrAprZHeC2dCdMpA=;
        b=ShfSUJQoiSUYFGv57zbNASG0wbJofUBgLzVihwXDm89k44TiHISL1V+sTpJmJnWCr8
         FXmDpfqXNl7VeVOxdhf/fQdLgSWP+86QKBcgC73AnU7/HXox1Eg3J/L0jSTCx7gN03rn
         JykHkfTZo91+5DQrf4aKOEWN/iEhtgmY1gY+mFr+Pz0fmWABWNXXJQT/Qeb3BESMX4Kk
         iJGzAf+gm3PpCLQxdBNwiltWVVE5f1F4kQIB+j2uhm4HwfLM+7/sEwi6PauxOhyG8pL/
         lp7sZb7DXyp+P3owRCEc1iFuB9hWoolFA+hvoI4B5WUz2fY+fno+uvi2qC524ygwm0aG
         LCEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693323726; x=1693928526;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FM+v7KoHt1GJYjQWDGW6MffrxjUsrAprZHeC2dCdMpA=;
        b=COJD3kKmDaF4QZu2jvL6SvGoHT7mYS9BkztC1kOpRRc19h7/d0Tht9IfsA9rLB7IrC
         MPIhd0GEeSQI3aISLnSQg3OR6WpxzYq5Rcp38T79FqGhvupESzPZh8d38D6eljAossH9
         v4uakysFhidoeWS+ONML7iSMs9JbWWsZnSWAJVW/fDGsxbjk9PXqeXI13SrEkWGxE6ZY
         B4dtUaHmykoR0/ntzt+bPIXUPMch2MMbey4o1dajFw9ZyR8vHKs/x5ZHSJ6E/6KdcJ9S
         JbaHTFCGjB522Yaa4j0dKQZRtarmYKRRsJJCUrb+jKoqn31uE1yY6C7ieCXX3C34BWJj
         CZfA==
X-Gm-Message-State: AOJu0Yw3KhUl2sDj/geM9E1dk86PdjcsGIzkiX933nCRgEKMdzU2gPv4
        W06P5DHFp/UCE2RKmQeFnoSDmguoA6A=
X-Google-Smtp-Source: AGHT+IF6CUFPwOOuauhBgYXgbvrbrbPqnplg1MCTn9RK+HDLQlkTN18njH15rUkTdOyKD0fPsv/RBXuxAx4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:68e:0:b0:d77:cd42:913a with SMTP id
 j14-20020a5b068e000000b00d77cd42913amr769568ybq.9.1693323726307; Tue, 29 Aug
 2023 08:42:06 -0700 (PDT)
Date:   Tue, 29 Aug 2023 08:42:04 -0700
In-Reply-To: <ZO4JCfnzRRL1RIZt@torres.zugschlus.de>
Mime-Version: 1.0
References: <ZO2RlYCDl8kmNHnN@torres.zugschlus.de> <ZO2piz5n1MiKR-3-@debian.me>
 <ZO3sA2GuDbEuQoyj@torres.zugschlus.de> <ZO4GeazfcA09SfKw@google.com> <ZO4JCfnzRRL1RIZt@torres.zugschlus.de>
Message-ID: <ZO4RzCr/Ugwi70bZ@google.com>
Subject: Re: Linux 6.5 speed regression, boot VERY slow with anything systemd related
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Haber <mh+linux-kernel@zugschlus.de>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>, linux-kernel@vger.kernel.org,
        Linux Regressions <regressions@lists.linux.dev>,
        Linux KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 29, 2023, Marc Haber wrote:
> On Tue, Aug 29, 2023 at 07:53:45AM -0700, Sean Christopherson wrote:
> > What is different between the bad host(s) and the good host(s)?  E.g. kernel, QEMU,
> 
> The bad host is an APU ("AMD GX-412TC SOC") with 4 GB of RAM, one of the
> good hosts is a "Xeon(R) CPU E3-1246 v3" with 32 GB of RAM.

I don't expect it to help, but can you try booting the bad host with
"spec_rstack_overflow=off"?

> system configuration is from the same ansible playbook, but of course there
> are differences.

Can you capture the QEMU command lines for the good and bad hosts?  KVM doesn't
get directly involved in serial port emulation; if the blamed commit in 6.5 is
triggering unexpected behavior then QEMU is a better starting point than KVM.
