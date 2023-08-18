Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 898E178029D
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 02:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356670AbjHRAOB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 20:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356784AbjHRAN2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 20:13:28 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F79519A1
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 17:13:02 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-589c2516024so4439247b3.3
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 17:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692317576; x=1692922376;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SdorFAXT200uTfIypctecn1Q+g1BsodxhwbGDgK3v7k=;
        b=LfZtErj8S1P+7XpbaKWmC3r8DaN+vmhLNYa76xOXTcDbar5N+pzkPftRL3bV7gpXAW
         KXWXqC9T1cgYhB0klcH3kwPUqgIdh6gTAgY4mHt+Q4VNQ3MbNcBMYI7auLy/rl9mAfjS
         VhgRCYAMCL5nuIYNF0ybTqhCne+WV+R93eqaKEYO6P695V0rjgTYa//VwTQuuVDdWkTo
         NC+4Lk6aR/JGhqudFyh0u+fZ8Nf4Ssty81vgRS0rRMm6Wbhi7oMwKa3PKcRC+LxH3NZO
         ZZ8L4tZuhwpN9szNfIRPAAxXYc73AjeFrEpSaYYM5okLVkgYoowhq/wdHPzBKv9w/rVg
         Fp7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692317576; x=1692922376;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SdorFAXT200uTfIypctecn1Q+g1BsodxhwbGDgK3v7k=;
        b=DVAqAFPtDe7lvdP0UhLfN5V4TAYX8v3XI9HlhTPsckISUOkwWfPh/pAjZByep3RLme
         2TQWOz/j9ezk6CYQ/SLc47wcT00sAl1FtTilWQWvn5xVSkt4XC1vGZ+lC5yX7+hD8H8/
         mddWCudZofL1T5wQ1WKo1uhBweRP3A62tvUnTu/drmoClWDiPLVLWqUpq/MdrOebpRH5
         r74kQsJ9/DIhSc0E2xB82iT5/XVCnOPhRMYPouIKqw0VfafXA/eVWd1Wapf5O8q/P4Nh
         QSlcHlOSXlITX8Q5hzce8ZW91hmUOn5UMUlm5Eu2ok7Y/3LX9MC3ypmPhnujlnmu2zOX
         l7ag==
X-Gm-Message-State: AOJu0Yw+dO8lW3x3a3MulUjo/wZDBYr2ithLuWYWZTMz65KIO+lN4NsE
        ZYFiNQWrn8/YogOq389UptcEaHLh1mc=
X-Google-Smtp-Source: AGHT+IE1Kac8GOkOVcXUHTI1d+YzRnSbtnTY07SwpTtpm8C2HVnJf0LyVvFvGiB3ZUqMUw2wYWDZkXmBdpE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:af64:0:b0:586:896e:58b1 with SMTP id
 x36-20020a81af64000000b00586896e58b1mr12041ywj.0.1692317576500; Thu, 17 Aug
 2023 17:12:56 -0700 (PDT)
Date:   Thu, 17 Aug 2023 17:12:43 -0700
In-Reply-To: <20230717041903.85480-1-manali.shukla@amd.com>
Mime-Version: 1.0
References: <20230717041903.85480-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <169229738869.1240716.18368105665161960843.b4-ty@google.com>
Subject: Re: [PATCH] KVM: SVM: correct the size of spec_ctrl field in VMCB
 save area
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Manali Shukla <manali.shukla@amd.com>
Cc:     pbonzini@redhat.com, thomas.lendacky@amd.com
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

On Mon, 17 Jul 2023 04:19:03 +0000, Manali Shukla wrote:
> Correct the spec_ctrl field in the VMCB save area based on the AMD
> Programmer's manual.
> 
> Originally, the spec_ctrl was listed as u32 with 4 bytes of reserved
> area.  The AMD Programmer's Manual now lists the spec_ctrl as 8 bytes
> in VMCB save area.
> 
> [...]

I changed course and applied this to kvm-x86 svm, i.e. it will land in 6.6
instead of 6.5.  I forgot/neglected to send an earlier pull request for this,
and at this point squeezing this into 6.5 seems unnecessary.

[1/1] KVM: SVM: correct the size of spec_ctrl field in VMCB save area
      https://github.com/kvm-x86/linux/commit/f67063414c0e

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
