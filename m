Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9CC771F7D8
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 03:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbjFBB0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 21:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233560AbjFBB0E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 21:26:04 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BEBD1A2
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 18:26:02 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-babb78a3daaso2202998276.1
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 18:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685669161; x=1688261161;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o2zvpikRFiidESnQoAb98e8aAicesYNJvb+G2l2BF/g=;
        b=LvLPgItUC1m2vG1zxwx8NcsugPhNkwqF6g1OaGTDaBGVxNMYClwnw6ELriaAeSjc9l
         iAU0GiMGlyM1DVQG3Cd0fxvR1Z4QDT0F2gQJnYDHEgsywzn6nEkCEAngEQtTCoqZUqCk
         fC2zFOefXnryglqLYXoSEx6TL7ez2tPIS1PIDDcrquuXgYbHpcO0RoTC6U2wNxnV2ykQ
         SnQOUaZMKE88C3fOmHxiethmrur/HDVkFcYPbtRkl1s39TUqjQ+m9yy/qHi2+5iCgCRj
         qemwqWlbDMSjP7FCoDvbkQ8MJSccf22197V/QF09PdmRDeOKn8LUiF/T2TYFk914dIXg
         V+ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685669161; x=1688261161;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o2zvpikRFiidESnQoAb98e8aAicesYNJvb+G2l2BF/g=;
        b=XXgG7iXRW2QS4dNdf9xpdetzX+DyPw+Oi6mj3WPXMUgoqA9LiJ61KS0MREn8UKCJWC
         p1yHFKdOTY4lcQbC7HZjkneT66wUV1z0Fq+YCGSro1PAO8nYMd4fSsrFFbGBLqgbsSZg
         WJHgPqUZbu0h3e1QfaelXidApVgAUOFcCjm4/o0pugJ5hL0WxNXL4iCkSRiTUsc4ep1z
         VKDpDP/0xqIRGH9SKGGHfiYSzB9ukqIEA4/UaMU3Fl5ZDLIR0wpJHMknLTnEr01xFlKt
         4fmCXFYprND6hnHAjz6+49jx4tnhBjvCSCMYPiGymtXmtEqsdeQtVQAHvE/ea/kAgUJZ
         Z8ZA==
X-Gm-Message-State: AC+VfDzPAV+rpXxZAgyNag1/Tnr5gxFyVaKh0MN11f8CnaraeSM/xqv5
        3wdE/4s/hPYq+mRsN8n8zn2dK7bwkaw=
X-Google-Smtp-Source: ACHHUZ7oRbIPG3pUuj3V13bZVGq/Q586X18lNtgJ8unT4k40YoOzluIGin6GSh2bZV+7HssODgwNOSB52lQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:b208:0:b0:ba7:1499:e202 with SMTP id
 i8-20020a25b208000000b00ba71499e202mr1073903ybj.7.1685669161265; Thu, 01 Jun
 2023 18:26:01 -0700 (PDT)
Date:   Thu,  1 Jun 2023 18:25:45 -0700
In-Reply-To: <20230531155821.80590-1-jon@nutanix.com>
Mime-Version: 1.0
References: <20230531155821.80590-1-jon@nutanix.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <168565441637.671278.11380888112695790771.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: restore vmx_vmexit alignment
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jon Kohler <jon@nutanix.com>
Cc:     Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 31 May 2023 11:58:21 -0400, Jon Kohler wrote:
> Commit 8bd200d23ec4 ("KVM: VMX: Flatten __vmx_vcpu_run()") changed
> vmx_vmexit from SYM_FUNC_START to SYM_INNER_LABEL, accidentally
> removing 16 byte alignment as SYM_FUNC_START uses SYM_A_ALIGN and
> SYM_INNER_LABEL does not. Josh mentioned [1] this was unintentional.
> 
> Fix by changing to SYM_INNER_LABEL_ALIGN instead.
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: VMX: restore vmx_vmexit alignment
      https://github.com/kvm-x86/linux/commit/331f22976816

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
