Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C807CD1B7
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 03:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344264AbjJRBQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 21:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjJRBQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 21:16:47 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFEA3B0
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 18:16:45 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c9d4e38f79so49705975ad.2
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 18:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697591805; x=1698196605; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LOomJHeHETJbhYEeTaHWBFWjyulaQCOLDgtFR8fNN3o=;
        b=DsXGaDR8uM+s5/cTHJRLFeuwrWQganMQwG7qgGP4Wz2oioZ+xCtKuXZAGT/D8+m+Hi
         UM+iWi2oz2C1r5AT5gqZv0Kj0BEjf6ffSCikMNX55/ax4edSzzMwxGzilrU4rN87AYGA
         LWARYVLyDCLmgTBgkLJAvRq/9UZRJ/CrOStbBwwR08czmm0CZdZVShEWbeRV9+2Rb0sT
         N5xW5O2mJ+JualAblhbGsmb06A6yZ7fwl9iL0wfl9zy+MpZVHg4s/2v4tidFDrr2w6gD
         lDxhKGRwoApbCEtL0AlMKXBDbSUn50pzloCEFAaUkfkzEh4aOl4++aYXjfeTq8OHrtY2
         ieHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697591805; x=1698196605;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LOomJHeHETJbhYEeTaHWBFWjyulaQCOLDgtFR8fNN3o=;
        b=NSKG9NnGUgPqN+6KhawpjYRde5wXb+WsBuZYSa0t7lKdOk5NfGkvTiikl1GV1qXfSm
         T3jRr7plMQ9Onjfb17LvLC98v6RhSqBQDtE5Ac9IrqaFdGVq6IDX9ydDvbCKUsvPHAQh
         gJEnz0KA+M2wzkCqcBtg3Ax8ZN+5Q+BY715Dx2aLPn95Xwi032k3hN4xKbKHsSd5PyV3
         CT8i45wfYOSxzWEUg52ErhtTrzsYUvcEipKJuyuEneMNDnfAhI6CIFWoLVWi2Ue/ebhh
         84zcrhLfwHf4BdZWa+uyXFnV9a2rPt2TQMP7YiCYOg6Pl1o7OgftEgvzKJ9ixQB/pvrg
         JFww==
X-Gm-Message-State: AOJu0YxNwli6NN87fT4QABCIT9+S6Mein69vj/CYrIyy+mKm3q0+Gr1V
        Y6hf+lURAEPQyZDl8MmPMxPXAFIVmm4=
X-Google-Smtp-Source: AGHT+IHpRNmBMBBbiYw+TEd6riZ9fyUh2yBzpl0Yd4F6E/v6RG2cGfSQtq32pCfnT4xIIuJ/NYl5T/gA5SA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:23c7:b0:1ca:7a4c:834d with SMTP id
 o7-20020a17090323c700b001ca7a4c834dmr71295plh.13.1697591805508; Tue, 17 Oct
 2023 18:16:45 -0700 (PDT)
Date:   Tue, 17 Oct 2023 18:16:16 -0700
In-Reply-To: <20231013113020.77523-1-flyingpeng@tencent.com>
Mime-Version: 1.0
References: <20231013113020.77523-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <169759163968.1787364.12600590324409090056.b4-ty@google.com>
Subject: Re: [PATCH v3] KVM: x86: Use octal for file permission
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        flyingpenghao@gmail.com
Cc:     kvm@vger.kernel.org, Peng Hao <flyingpeng@tencent.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Oct 2023 19:30:20 +0800, flyingpenghao@gmail.com wrote:
> Improve code readability and checkpatch warnings:
>   WARNING: Symbolic permissions 'S_IRUGO' are not preferred. Consider using octal permissions '0444'.
> 
> 

Applied to kvm-x86 misc (with a slightly massaged changelog), thanks!

[1/1] KVM: x86: Use octal for file permission
      https://github.com/kvm-x86/linux/commit/26951ec8623e

--
https://github.com/kvm-x86/linux/tree/next
