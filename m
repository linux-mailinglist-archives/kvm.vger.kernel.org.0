Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2692F7D24
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 14:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732907AbhAONuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 08:50:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729498AbhAONuc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 08:50:32 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A0FC0613D3
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 05:49:51 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id v15so5688179wrx.4
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 05:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MwCX+/EyTCSrIqzhCqb0Nu6BiuSsXwge34YVzpiECe0=;
        b=VjcRitv3CMagFa+Y7oRVGMasNu01QTKQOEf0nTvP/3Gf7ptnuYGCzLsSwd4RgU49js
         Hbayh4yJok2iWQK0tnOUUxD1sCExux557Y6uSOFgciPZT2WdibqllBlaw5Ozc/Gux4RY
         0zK1YMhvvRHRuG7I5gh/9rOF5S1jL2u3SzCt9Guvcn4cNGRmKLLcp5y03BqiLej5joDJ
         csyWpzfB2gbMbiSmuQy+tSiqIshEK2RoKzOKo6Qrl/n5bVn+GyOgPtDQvJqaRG3TI+ZA
         RYGWC8y0itpOLoOLuBRTTo47SoYe2e3Vkg53qQHpN93jQM5SUom5gl/w0C3X+mvityFc
         3row==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MwCX+/EyTCSrIqzhCqb0Nu6BiuSsXwge34YVzpiECe0=;
        b=pMt6I911lSw47rjWo3c/0E9tFTcJd9zP/aNQgItu0aZKSedX2M43sEa9GQsXOQVICv
         oO82dYFOH7VHJY+TC3TD3rSrGoPAS1V9rT5wDsDNod32ojTPDX27AqUD5UZN2tW2aFeE
         OaZKOt47mNivDQuwUbn6960S3Cfjjps1+5evnl4zDpKh2/ntmXN/QPBFmY211+MNkUsg
         BFRSDEicn7gd96W+b7Tnsp/qoVDJcasRkrIxVrTvz2DD5sfCi85Dpw3vc5a3azDZQhYD
         matFnCS+YytMKZAFQdl0Gvt37uyXX2Xkyclm2jiwPzsiv7YjgJQQeWDCVSvaEl0s5oax
         SnVg==
X-Gm-Message-State: AOAM531f/wuEB8hxa2iYYEWVkzLhEzl36MtbdgPQ9jdLwyZfDZ1p9m6P
        UwDrYfLDQIbu4Iy5EkcdWIek9vQ2QDiSA96D
X-Google-Smtp-Source: ABdhPJx47DQQ53eBz7+PoVimJvsC9mL4EpotLvljQhU4GRwnkF9psc1KK7JJxJzzrvfpgYnJnct4xQ==
X-Received: by 2002:adf:f707:: with SMTP id r7mr13767163wrp.113.1610718590179;
        Fri, 15 Jan 2021 05:49:50 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com. [35.233.69.230])
        by smtp.gmail.com with ESMTPSA id g192sm12929770wme.48.2021.01.15.05.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 05:49:49 -0800 (PST)
Date:   Fri, 15 Jan 2021 13:49:46 +0000
From:   Quentin Perret <qperret@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     android-kvm@google.com, kernel-team@android.com
Subject: Re: [PATCH] KVM: Documentation: Fix spec for KVM_CAP_ENABLE_CAP_VM
Message-ID: <YAGdek8Ns9nRU478@google.com>
References: <20210108165349.747359-1-qperret@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108165349.747359-1-qperret@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Friday 08 Jan 2021 at 16:53:49 (+0000), Quentin Perret wrote:
> The documentation classifies KVM_ENABLE_CAP with KVM_CAP_ENABLE_CAP_VM
> as a vcpu ioctl, which is incorrect. Fix it by specifying it as a VM
> ioctl.

Anything I should do on this one?

Thanks,
Quentin
