Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AC97930BD
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 23:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236222AbjIEVJb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 17:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244280AbjIEU6M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 16:58:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D421B4
        for <kvm@vger.kernel.org>; Tue,  5 Sep 2023 13:58:06 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d7b52f36714so2682672276.2
        for <kvm@vger.kernel.org>; Tue, 05 Sep 2023 13:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693947485; x=1694552285; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aD7t+y8x19H6PztCQZwx+di86N55Bv5EtpGCFtvEp88=;
        b=enOkdyESHyk9tSYGfhL0mBDI9Ycisocpo0YOffBUfFu54FThi8MpSG+OI8fumMbpna
         UaBMwh7k/qpIImxDNfDr+ts/Pw/RPArjZYyEXE4YavvL0ZYV9SbT0iV5M3lOrT6aSKp8
         6PXshopWFK376HvmIGnfETIm/ND56m9Lgkp+2Rn5Ujnta/iA4QvbeRfZo9axaGGEyFCe
         sVgAPuj+Azp7AHplkAPV4gIj67oB2Yww6GGUfaZcHVSjQbU8CkR2yeBs8YpvY9Xtq/90
         UTQPNGu1ccsSASru/8H4/LmtI9y7kbqyrE58MIv6DipAWRbhw+0YcP4tAuFJ8Ifd8paw
         gxRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693947485; x=1694552285;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aD7t+y8x19H6PztCQZwx+di86N55Bv5EtpGCFtvEp88=;
        b=O4ATF99UWu0oNDF8I68XB46Ms2t8GkxTXvyKnJajW1hf8+GHqUb8LOe8b5QvP9bbiq
         cZN559hkfwjoY8ugqvmo1vWqEeq1BUl2HdvU46YP4TJfcHOq12O4HNUqrykpr86s0aFp
         uglOAreq5U3Epzmvu+jhxvm08Fq12As9g6tSFn0QHBBscX8KmH0nrsd2C/wotDnB5wql
         j4asQXyIp4FeTTBw3wd6ENYQ0aPuMkftBTNow5/2m8txAhFN85dUoX2Rd5o15HarCc9p
         369s3ztA0yJs+rePqBc6xoJUr3+OTnaI4pnCVXFMCLF2EkWsobhUmHyxxU8nRUzcpFLR
         y/ag==
X-Gm-Message-State: AOJu0Yx+MAy8X6YiTBYwY0BksXEc3FpPB0Er3vS0lloebkNoD/Y1yvjO
        tb7H835ZqrEpXtNUHZwjmDyy3cofosw=
X-Google-Smtp-Source: AGHT+IFX2u113VgxY7mGL7ETLl/8BnbAdcjqqkgLG+sXMxJgGOPrQ9PcI/mFnory99gwuec041MEk6e+KwU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:aaf2:0:b0:d7e:add7:4de6 with SMTP id
 t105-20020a25aaf2000000b00d7eadd74de6mr279581ybi.4.1693947485734; Tue, 05 Sep
 2023 13:58:05 -0700 (PDT)
Date:   Tue, 5 Sep 2023 13:58:04 -0700
In-Reply-To: <20230905161048.3178838-1-pgonda@google.com>
Mime-Version: 1.0
References: <20230905161048.3178838-1-pgonda@google.com>
Message-ID: <ZPeWXNpwYua9S+tV@google.com>
Subject: Re: [PATCH] KVM: SEV: Update SEV-ES shutdown intercepts with more metadata
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 05, 2023, Peter Gonda wrote:
> Currently if an SEV-ES VM shuts down userspace sees KVM_RUN struct with
> only the INVALID_ARGUMENT. This is a very limited amount of information
> to debug the situation. Instead KVM can return a
> KVM_SYSTEM_EVENT_SEV_TERM to alert userspace the VM is shutting down and
> is not usable any further. This latter point can be enforced using the
> kvm_vm_dead() functionality.

Add the kvm_vm_dead() thing in a separate patch.  If we want to actually harden
KVM against consuming a garbage VMSA then we do need to mark the VM dead, but on
the other hand that will block _all_ KVM ioctls(), which will make debug even
harder.

> Signed-off-by: Peter Gonda <pgonda@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
> ---
> 
> I am not sure if this is the right path forward maybe just returning
> KVM_EXIT_SHUTDOWN is better. But the current behavior is very unhelpful.

Ya, KVM_EXIT_SHUTDOWN is better, we should leave KVM_SYSTEM_EVENT_SEV_TERM to
explicit "requests" from the guest.
