Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9047B99A1
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 03:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244463AbjJEBbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 21:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244383AbjJEBbi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 21:31:38 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA9CE5
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 18:31:29 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-277277fd56aso321263a91.2
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 18:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696469488; x=1697074288; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X2yNleyOtPDwQ3m9T2VxX8YGOt5Oz/4QXsP/SY6YjHs=;
        b=BwS2PeonjlsCKT3SlGjsMAXkJpjFsSvKKfcqGVkg/B8ZT3llA5Qb5Xs2RGny4Fk6Q6
         Q4p78wLb1mqGqQBjWz9+kAo5xDD/qKucx2WODxUihcj90zWrtjATZPzsKxCD79a/tvml
         /hgWdMRtABvfW+ZsNuvnin74wy8GevjO5Y9YpIyvY/WiQl/3CvTK+Y3OW22p/AGIxkwI
         7NKHhPEQMGbETro/66ZPIPuV1tWvN3xI32Lma3cW4Ra4dIVn7wTEmjV66owXi7rvyWx8
         RrQHxI9dVFu9eqlDzSG+BYuiGWjtjcbi8hDfS9lgiIebWL019mKkfhYlWRvJt6Cklfgh
         c8pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696469488; x=1697074288;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X2yNleyOtPDwQ3m9T2VxX8YGOt5Oz/4QXsP/SY6YjHs=;
        b=nHt78r379wwocqTZNu/p7owgUt0Gl+UJWR2Qs5NHZWFJPT3RMj34SwumedzI81ofqX
         W4N+kGd65PDhWo/Gh4BkiLwgLHKAsk17FmvoHRzSm089Oyx7dBoo5MvDGY2TgoTb4h6D
         m2i8IUW+DkDhKPaKPAs+r2qJfuuOFCqVC2ay0vSFcDiu9Q4iCMyREzWQOQ0M+1+ksFrx
         dv5/ko2BL6lylcrNp8uCiPTxwuFwHvHAhlC0mRJTlMlA6Ov6vFtkkFvZA45w1YCvx+Oa
         VCp1VdsVXnzISYItA1V0ST4smtCSZUz0yc2ioNviTKYjTLy5fED2oIFon1MLmXcq/ed7
         l2uA==
X-Gm-Message-State: AOJu0YwNbQJAYwG0hkIx+XZWWy6yazqR7K0sEYFOsZXE2CYJLnLUemPp
        esLZM+FqBImaXlJfcnlTXEtLv56/Qw4=
X-Google-Smtp-Source: AGHT+IG1bkbEM/2JLhRFE0UXYa70a8CLufAfPaJjA7uMFMveOnBqnDremvnmZLUsO3WeVqhqub5Jz24N+rk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:f68d:b0:268:2de3:e6b2 with SMTP id
 cl13-20020a17090af68d00b002682de3e6b2mr64285pjb.5.1696469488525; Wed, 04 Oct
 2023 18:31:28 -0700 (PDT)
Date:   Wed,  4 Oct 2023 18:29:35 -0700
In-Reply-To: <f21ee3bd852761e7808240d4ecaec3013c649dc7.camel@infradead.org>
Mime-Version: 1.0
References: <f21ee3bd852761e7808240d4ecaec3013c649dc7.camel@infradead.org>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <169644816213.2739997.3666121642145456465.b4-ty@google.com>
Subject: Re: [PATCH v3] KVM: x86: Use fast path for Xen timer delivery
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm <kvm@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
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

On Sat, 30 Sep 2023 14:58:35 +0100, David Woodhouse wrote:
> Most of the time there's no need to kick the vCPU and deliver the timer
> event through kvm_xen_inject_timer_irqs(). Use kvm_xen_set_evtchn_fast()
> directly from the timer callback, and only fall back to the slow path
> when it's necessary to do so.
> 
> This gives a significant improvement in timer latency testing (using
> nanosleep() for various periods and then measuring the actual time
> elapsed).
> 
> [...]

Applied to kvm-x86 xen, thanks!

[1/1] KVM: x86: Use fast path for Xen timer delivery
      https://github.com/kvm-x86/linux/commit/77c9b9dea4fb

--
https://github.com/kvm-x86/linux/tree/next
