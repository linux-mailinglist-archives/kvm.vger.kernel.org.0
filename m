Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1C171F723
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 02:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbjFBAf0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 20:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjFBAfY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 20:35:24 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD11E2
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 17:35:23 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-256a43693e7so622541a91.2
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 17:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685666123; x=1688258123;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tTnTxLfkvH/gJ5kA9fsR++JqlCYcfT8oB/4PY04nvMI=;
        b=uXEDUxikT9tErjoPam1H1MfJxrs3mlCVZ/1igIn11ir1+yBdsgyuxPbIXZ3OlfEfao
         uX2/DiGp8jeXfwcL4vD34Q0814tRMVZ7Ynb96VFwcFEFk0NUwsFYjt5il+eWy1XVb5GT
         QJ4DcsmsdMzlDOpCZsfjhXe5XZWrMgR2vNM+/4f4qfCJgABZiLx3UBG7etNVIoDxJn4L
         MEEwFdT4aYcDJ1nlb3ABPRcRIEnywSllc6a4h0KGnpYQ8pOETCxOLCs4eF4fx2VgglR5
         np/C36i47s1BHItEf43+R7rRzAc6kvRT6fcvZPsYeOT3/yA8GLVFDvjW1cJ5xNnxSBbE
         Y5Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685666123; x=1688258123;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tTnTxLfkvH/gJ5kA9fsR++JqlCYcfT8oB/4PY04nvMI=;
        b=fUHrg6CKKwzLj5n3+H+/arOG/zWhRDdeXqv4RvTAxzl2UKvkyM6GTrjmjF8qc4mAWn
         NyaaMwpdY1zl99YCxKDNtJZKBU5MWjc5J2y2aGYjc7IJogMqwin5rBrca2aYhwwmfXza
         o+BcLWwfDVRxXAqoIkGAVFaxx5iVhxOFgYVOT9zR08XzfxicmPnCH20n4DSaws0imcQn
         34qKrbxbuNckAmkPTcNlJeYAREzOYFwx6UUcLcjp8aXroEjrUCoxUqftrTV7zJaGDYPL
         lmNLaOFxe3xn0s1CiCmVjUc3RWXq+Vi07zdL+ieOxWczWoFB4JJVWvMBPjKqYAdLFDOj
         BFMQ==
X-Gm-Message-State: AC+VfDzw3oL2NT/831DlN8q3orPT+D8oSPGtkh1PFGGLkfHoI1vIntEj
        VaYrL2WhQIas8CsUgJixl6o5R0evDPA=
X-Google-Smtp-Source: ACHHUZ7KVY71AzRLObpOpEWUNlbUmZYU1696FqjQwmZZ8/LYnx7syxkxmRRoLEOqeZhm9BWKJ1gVa9PU3Qw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:854c:b0:256:8fd6:1280 with SMTP id
 a12-20020a17090a854c00b002568fd61280mr216074pjw.0.1685666123281; Thu, 01 Jun
 2023 17:35:23 -0700 (PDT)
Date:   Thu, 1 Jun 2023 17:35:21 -0700
In-Reply-To: <20230601142309.6307-1-guang.zeng@intel.com>
Mime-Version: 1.0
References: <20230601142309.6307-1-guang.zeng@intel.com>
Message-ID: <ZHk5SRi6bFcHRyxV@google.com>
Subject: Re: [PATCH v1 0/6] LASS KVM virtualization support
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 01, 2023, Zeng Guang wrote:
> v0->v1

Heh, the kernel process is a bit of a heathen and starts counting patch versions
at '1', not '0'.  I.e. this should be v2, not v1.  No need to resend, just an FYI
for the future.
