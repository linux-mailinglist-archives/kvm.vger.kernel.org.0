Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B79AC7B97DC
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 00:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbjJDWWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 18:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbjJDWWR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 18:22:17 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D89F2
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 15:22:12 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59bdb9fe821so4222757b3.0
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 15:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696458131; x=1697062931; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R08SF2RO3rNTWYRv9a92dKc/I3NYQqIaV0o1mrm6R9k=;
        b=gykyqtWvqdv0O8pu6srkaIbelFGIgFotaYNQj92tFlFadwReU04AttkBCW/zYC9TTF
         46UN5mzzZ80jQ1rezy9BS4nRypBVhjO+TwYgVvqvTjWZwa6735X+uT4tHIqX0DCrmYo5
         DVZlVARHmnfd6FGj1Ck/r9YYBb2C46ln+Y/5UrLdFsC2xs9Mivy3oDPJ7XdvgPSbePWF
         Gu1XnUusRha1HqQqu+N2PQ0BfeE2EcXSzvjRmEwAWS8esNGsb8/JILRcYFsEHPM6Vvc0
         wsQ1gXqQ4FNOKLEV6Z459dNvhyzqBATN2D+LVLtsiFz7Uryk5zNaUrxa/+JKHCAhxxpN
         6BOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696458131; x=1697062931;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R08SF2RO3rNTWYRv9a92dKc/I3NYQqIaV0o1mrm6R9k=;
        b=nHLv9rv0EtzhAHrmeCci9tmHmMD7o9wyoQNQjGIkHNxOSPsfmhms9FpsZbZvFtYquI
         xfivJKBsi5MbcbUs0bn0VEEZsw7ztxxeakUuSKVtZoeF2tXFxWwudOZAm7r2og5R+Wwo
         JuiixmY4YVO3P6+VjO21RCeKX/LGQZLZ4oaep1nbJdvOhfQPit8y73+fuRFdORSc4ZBg
         JErf+msCQeWjIziOCgWIF6pX+/fMJ8dgb9pfZI3GaqT0Kx++YV2kZl3b+17GsEdKhA0I
         V7sZXznAD2oIIm5gVdIOxcm7hyCjWZddAXuBDlvjM6kzaBflKgoWYBqzWQ/pxvaI/yiD
         XwqQ==
X-Gm-Message-State: AOJu0YyaXqRl6+Snqke2BBdBM6LiANgTdnJXMvepTyEmcZF2GKqXOfQ5
        d+ihU0VPiQm33dOPQvnYuEAITSP01nU=
X-Google-Smtp-Source: AGHT+IHGCerst7w645uv/tqOd9oAFXpupAandqJ94FBVwiVup2vQixOLt5zCWO0kyCS4Xdw5MsMiUvemaiw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:bd0d:0:b0:595:5cf0:a9b0 with SMTP id
 b13-20020a81bd0d000000b005955cf0a9b0mr68443ywi.9.1696458131783; Wed, 04 Oct
 2023 15:22:11 -0700 (PDT)
Date:   Wed, 4 Oct 2023 15:22:10 -0700
In-Reply-To: <CAPm50aK-aODN8gbaxazqsNXwEciU1WdRom33h3zOnQLTBEKu1Q@mail.gmail.com>
Mime-Version: 1.0
References: <CAPm50aK-aODN8gbaxazqsNXwEciU1WdRom33h3zOnQLTBEKu1Q@mail.gmail.com>
Message-ID: <ZR3lkt9dNgsnieuH@google.com>
Subject: Re: [PATCH v2] KVM: x86: Use octal for file permission
From:   Sean Christopherson <seanjc@google.com>
To:     Hao Peng <flyingpenghao@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Thu, Sep 21, 2023, Hao Peng wrote:
> From: Peng Hao <flyingpeng@tencent.com>
> 
> Improve code readability and checkpatch warnings:
>   WARNING: Symbolic permissions 'S_IRUGO' are not preferred. Consider
> using octal permissions '0444'.

This is whitespace damaged.  Please fix and resend.
