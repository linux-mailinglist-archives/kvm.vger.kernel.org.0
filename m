Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 315B17D196B
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 00:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjJTW6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 18:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjJTW6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 18:58:13 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2C110C2
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 15:58:12 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-6befc6bbc23so1657333b3a.1
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 15:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697842691; x=1698447491; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SrppkFveU0fvDNdY36XrefeVlH08k8+eMXH9fdF2ahI=;
        b=o1rpwW6U5Omzs2U1BUOTjUuRO27P6kGowYTlDYhpw/00BKK2Ep/COfFhbcf5XKaPTQ
         toWq5v12clc8UeA/w/MKYUXaNFYxWfcWzoF+SZd75cI/gX2kVRD/tSYmAb9CH4IJ8Wvp
         N8tXXjKG0j5Ph9Z9EDs2abM8pEBNOR+ammehGDJjoyyZ3UIc6LzhLVGfVAGcAF526hs8
         snHhlHYO2FvjefgUoJrq43cD96psDS7mOWFiOqPxC8nOOt/9R/t+OhcmQxgiUH8057Mm
         q5gI9cUHodOX1UYir/6nJe6QRwTvst/CXIFBX5M3zPNU8tvSE5Elrx+86Fbgkf2Awm0g
         dmDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697842691; x=1698447491;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SrppkFveU0fvDNdY36XrefeVlH08k8+eMXH9fdF2ahI=;
        b=UqVHxNOYWLrqJtVK4P1GpokwMpPexjR11CqrQm3UHYTBDjoPoRvrCoQwe/iirX5VWC
         0q8glIwm9Ccd9sG2AUw5lP/+ooHCXa94Ess56ES99S+kCzygU/664bZvasdVJVPtMejR
         A9ZoEsSVLaTf6TGPZjVEccdyqJS+Qt5VM6EQsOWM1mnO7Or1iltlT+jugJCTYVSXtwzO
         +sQLMY0YScj3pf5ZIk1gkV9QZYIxQ/45Bak7p6zuXWDIcYeMELvuB8SL0TIesoOGiyjE
         UOpGNQXgEFvKuaN9pYDwdcss55IUyfHWZtZ/hMi5HLWfEa44nk4kFjzBBnf+iDWvC5BH
         XJeQ==
X-Gm-Message-State: AOJu0YyQSurR27WiwsnrEt+KGnthDynJ+LFsDq1UiLZX+4A/WAULHaqZ
        iUrNM2u16aKxr5+fgGjGXVwld0nfPOQ=
X-Google-Smtp-Source: AGHT+IHSVZv9jju1/ELecw1EVpvoQU379lbFaP9R/rbK4eU/20BIUMhAW8Vy3g3gpGIqO/cRuobIeZbk1C8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:be1:b0:690:bc3f:4fe2 with SMTP id
 x33-20020a056a000be100b00690bc3f4fe2mr103940pfu.1.1697842691387; Fri, 20 Oct
 2023 15:58:11 -0700 (PDT)
Date:   Fri, 20 Oct 2023 15:56:27 -0700
In-Reply-To: <20230905182006.2964-1-zeming@nfschina.com>
Mime-Version: 1.0
References: <20230905182006.2964-1-zeming@nfschina.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <169766488985.1913247.10258683336910491113.b4-ty@google.com>
Subject: =?UTF-8?Q?Re=3A_=5Bv2_PATCH=5D_x86=2Fkvm=2Fmmu=3A_Remove_unnecessary_=E2=80=98NU?=
        =?UTF-8?Q?LL=E2=80=99_values_from_sptep?=
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, Li zeming <zeming@nfschina.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 06 Sep 2023 02:20:06 +0800, Li zeming wrote:
> Remove spte and sptep initialization assignments, add sptep assignment
> check and processing.

Applied to kvm-x86 mmu, with a beefed up changelog.  Thanks!

[1/1] x86/kvm/mmu: Remove unnecessary =E2=80=98NULL=E2=80=99 values from sp=
tep
      https://github.com/kvm-x86/linux/commit/1de9992f9de0

--
https://github.com/kvm-x86/linux/tree/next
