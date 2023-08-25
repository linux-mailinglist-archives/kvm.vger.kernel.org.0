Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069B6788F0F
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 21:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjHYTCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 15:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjHYTBi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 15:01:38 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFC02126
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 12:01:37 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59263889eacso18964187b3.3
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 12:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692990096; x=1693594896;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wDjdWhERPFWhM20nCtIpVw+BZW9ucGGxqq2Ih3Ipg7c=;
        b=ey7xFBVCRQ7PlvQlxi4eUdne1zA/2wDjFy4cqmx5T/ghhisPzygq5PpZBpcSHGjJAc
         jjiJHNUHTEKn5No0dYcKYZ0M86AC6pzs95eLyrI3x8YR5t26aLchRDMr+Of7PyIPHrA2
         X1eoDEObRqowjAWmRpBxrfHsjHDTQ9qdRDPNuNLzNHo9dwvpEvlayUAHKmzM2btKhqAP
         gE9VY1S2D1l1C2j8SfwphyxKtEw5SQEfrNC8npqwg2JaOwqa16bRnfYWGzSAIv0ZZW7z
         L7dcDwkRrZPIXNF6Uw7MbhJa9HOLP3vPh2eH4KYrfQh5ZG0XziCCQyibo9/urYUmsc3S
         QfnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692990096; x=1693594896;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wDjdWhERPFWhM20nCtIpVw+BZW9ucGGxqq2Ih3Ipg7c=;
        b=ex7KN1mqCnHw+TLyqCM18qkBtPtdBpXijPhAPBA2lPEJgEKHPoiI3kKqwIwSUWEdOa
         NRp4/IhJZxjCFtX+GExqlo0iC3V0yd6dhoAX4cpi9zJVYfbF25tni6FBqhHAR7PfCuyV
         vUWcjb62F+ijr8O9GJx1IZBtkC7mObwZC8bnm3Kepy3whq9KJhrvoVwOmCSF093fSCZp
         cVzpQioLmXU3CX3m6Z5GCnC9KQKeDxH+kElmeL0q32NiSHOq4m4LJOmbLJDXs4zwdfbU
         YcUuVelft6/MzKG4TIPlaUBhzkkdzOohnE/Zs8/OMBOo82T4pmZmMfjh8q14CfJSWBWB
         HexQ==
X-Gm-Message-State: AOJu0YyvEvhfRhqmzQ4mxRmwl61A7vSZquz0V9MLcZAHvT8VirSb8AIn
        q24uhMQnknGqL2M/vsLmNng4w9P82Ek=
X-Google-Smtp-Source: AGHT+IETQGaWO4DLHWkOawS9jdRF0pC4CCo1ux4016usrq+ucz+kWD80oOGDsJSDr8OkXtfcRlm+4hDUgGw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:12c6:b0:d77:bcce:eb11 with SMTP id
 j6-20020a05690212c600b00d77bcceeb11mr463423ybu.10.1692990096293; Fri, 25 Aug
 2023 12:01:36 -0700 (PDT)
Date:   Fri, 25 Aug 2023 12:01:26 -0700
In-Reply-To: <20230808224059.2492476-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230808224059.2492476-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Message-ID: <169297943227.2871340.9955188529798179185.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Include mmu.h in spte.h
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 08 Aug 2023 15:40:59 -0700, Sean Christopherson wrote:
> Explicitly include mmu.h in spte.h instead of relying on the "parent" to
> include mmu.h.  spte.h references a variety of macros and variables that
> are defined/declared in mmu.h, and so including spte.h before (or instead
> of) mmu.h will result in build errors, e.g.
>=20
>   arch/x86/kvm/mmu/spte.h: In function =E2=80=98is_mmio_spte=E2=80=99:
>   arch/x86/kvm/mmu/spte.h:242:23: error: =E2=80=98enable_mmio_caching=E2=
=80=99 undeclared
>     242 |                likely(enable_mmio_caching);
>         |                       ^~~~~~~~~~~~~~~~~~~
>=20
> [...]

Applied to kvm-x86 mmu, thanks!

[1/1] KVM: x86/mmu: Include mmu.h in spte.h
      https://github.com/kvm-x86/linux/commit/bfd926291c58

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
