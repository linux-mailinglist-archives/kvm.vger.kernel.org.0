Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F007684BD
	for <lists+kvm@lfdr.de>; Sun, 30 Jul 2023 12:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjG3KGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Jul 2023 06:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjG3KGT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Jul 2023 06:06:19 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED29E1987
        for <kvm@vger.kernel.org>; Sun, 30 Jul 2023 03:06:18 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1bb8a89b975so20538665ad.1
        for <kvm@vger.kernel.org>; Sun, 30 Jul 2023 03:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690711578; x=1691316378;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kOTRiCNx74E8PfW7MxXDFRHI4nOKjyCJS19BozBWkjc=;
        b=hXVJKwjS2uMpF+j/jtlhmem0NQlDNf0p0WCVTvwjjws1Kt5fK+LeQaePEgeiQ6KlOQ
         kX/Zwsee8C+n2t435k3gUGWidGoDyH/3cfYRh1RJu7mOlE/qwcnZyWPPPyeKybusX7J0
         x2cwYUQvg069eie+rOVQI90MB5OO5OzgOPDl87jTGXxALboklmDMu7wF43k3fAI9LsX4
         cDoEHx9RuFrneIdCGANsjQXnFemlHKoL7s7JZ1YHEwVS58e/5grK7jlwaeQdougDsUGc
         581je0QGy55zl9ejdHMQ055DHXi3XeC5Sx0DtFp1GtJPiHkt70uJuaIrTkxihH+TLXZ5
         0U/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690711578; x=1691316378;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kOTRiCNx74E8PfW7MxXDFRHI4nOKjyCJS19BozBWkjc=;
        b=H8kqgsF8p9TGh98YvmvYbUgLLNNrgFbPyK6W3ZRe1slD5C/iHVspnd7AEj2RDp3+x2
         KJkDZ1Z1r6BI9ckOLNdFvZ5WlkzfoP9eNtE2XtE6IMedvCXvsGjOk77/IKkcWjpJTGfD
         alDFeeyLdObi19FZXuz0+4e4Sa6VmLZWkOsSEOBh1ajnUe2bkZKjrsV551UwNIa1c9ok
         vzZYD/ES8Z2uH13VQylWA3xXdIYTJHhvpQxtV/GWPK6g7z+/yp7x+wZZa6hPllE0lxfN
         17zy+nx6EwSi9ArpAyaSN/BLbAvLmdhlmnjdG9adQnqVWi35Cx+VEv6Ivxai3jbRDBfc
         zgvA==
X-Gm-Message-State: ABy/qLaoq+aJBMYzjhXHcDYDmFAyLWinRODtIn5gO+EeY3erLxoZIr2i
        N+LREIZnHqSz1zTuvXrkV4LFT+4n3eI=
X-Google-Smtp-Source: APBJJlHXM9MVouQoc2mKW63ss8OToA17Zj3PlaHSfGsuIyhABuKXc72pHutXORbuxkVQNp7bGjV5ig==
X-Received: by 2002:a17:902:e88f:b0:1b8:b433:7fa with SMTP id w15-20020a170902e88f00b001b8b43307famr7427027plg.13.1690711578390;
        Sun, 30 Jul 2023 03:06:18 -0700 (PDT)
Received: from localhost (110-174-143-94.tpgi.com.au. [110.174.143.94])
        by smtp.gmail.com with ESMTPSA id p9-20020a170902a40900b001bbaf09ce15sm6384075plq.152.2023.07.30.03.06.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Jul 2023 03:06:18 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 30 Jul 2023 20:06:13 +1000
Message-Id: <CUFF8EFNM4SV.AMHSXOE0DB04@wheely>
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     "Shaoqin Huang" <shahuang@redhat.com>, <kvm@vger.kernel.org>
Cc:     "Paolo Bonzini" <pbonzini@redhat.com>,
        "Thomas Huth" <thuth@redhat.com>, "Nico Boehr" <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 0/3] migration: fixes and multiple
 migration
X-Mailer: aerc 0.15.2
References: <20230725033937.277156-1-npiggin@gmail.com>
 <c7469514-145b-2a90-9352-6d83c254afcc@redhat.com>
In-Reply-To: <c7469514-145b-2a90-9352-6d83c254afcc@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri Jul 28, 2023 at 6:44 PM AEST, Shaoqin Huang wrote:
> Hi Nicholas,
>
> With the patch3 arch-run: Support multiple migrations.
>
> The run_test.sh will fail on the migration test on arm64 platform. But=20
> the patch1 and patch2 looks good, only apply these two patches the=20
> migration test works good.
>
> I haven't had time to investigate it. But first let you know that.

Hey, thanks for testing. I noticed some problem with it too. Let's
leave patch 3 out for now, I'll post an update with some users
added and hopefully bugs fixed.

Thanks,
Nick
