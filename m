Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 191F67A678E
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 17:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbjISPGQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 11:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbjISPGP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 11:06:15 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB105E5
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 08:06:05 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c44a2cbea0so24895075ad.0
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 08:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695135965; x=1695740765; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OY4gwD8K8C7sjWTf2a9MwqVDFc4JR9EZBcKVWZ3nYk8=;
        b=g7KYOo0tttgTEdRcWr2WDzud0GDtSjQ6rm/jizJ4A6CF36jDq77rDodijDy752/jrf
         /PJy1v17t1ci4KlrKzDqNv4V46WNlqLINgac+dMqz3kCg168DLguR7lFpKA7XxRO4+wg
         CxYjqfkfAMg2rkt/mc6+mwyyr/yx7jpBthm1Lu91FN/9ZT4uAZ7MrjL8PMuZ3tnRtU4Y
         nMhrGJr4IcQYQcWVjFLVLDMhbLPBS2wsOzBPjEwDEKnap3t/ubhMJ240woXPoOZeeEGe
         cwytS9+7TWLRaaeHnp/+3IcUohWJo4vyDuQY2kaERq1e9NHal7jTdpnsPcoIsZgXWqYX
         g2uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695135965; x=1695740765;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OY4gwD8K8C7sjWTf2a9MwqVDFc4JR9EZBcKVWZ3nYk8=;
        b=pghnbGFIw+UHQetN86Sj9aol3mu13HA+Jq0KJW53OSR1LHU4TPHFF9XMsLlknePJjZ
         9yX7lAOxloYImrJhana0E3KsrlsAPxPdacLBRoQWxBhIC+bFajUtLw7TaLLA+wlOqqTJ
         5+EWizclCNHr1wQc5sRBvCD+7EV9o6+fVAKuqIU63TtU/J9+IYFHc3l0C1LvbY7Z3A2v
         liTb1JEYExslwhzHEalPT6g/slaYDLXN5ZDEh9aML51nOWvR/D2eLij3l+r8Rzg31eAf
         76iimXyJ4sWTyxMb4rAOxK7NSoN9D2scjg0HqNVru60/HZk1IaPfx4qf+emkoFcojlrr
         20Bg==
X-Gm-Message-State: AOJu0Yw4UWX7EskU7Gz4TS3KNICs479+AifV/1i6Y/uajEK+2f2CkkQy
        8ACalXTZrJr15lEuztfyoIShnTIn69o=
X-Google-Smtp-Source: AGHT+IEELizuG/1J1rCQpMyfr99oNZFw4XTRLkR/Kqn0kP3fpjSk5TekLXW/TEJ7kUiSTlpJHb5M/jz6oQ4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:23c4:b0:1c3:d556:4f9e with SMTP id
 o4-20020a17090323c400b001c3d5564f9emr63017plh.0.1695135965373; Tue, 19 Sep
 2023 08:06:05 -0700 (PDT)
Date:   Tue, 19 Sep 2023 08:06:03 -0700
In-Reply-To: <CAPm50aKVDLhZo_3kkKyC9AUN0BGrYnPTo9hGqRg1M3TsUQQMSw@mail.gmail.com>
Mime-Version: 1.0
References: <CAPm50aKVDLhZo_3kkKyC9AUN0BGrYnPTo9hGqRg1M3TsUQQMSw@mail.gmail.com>
Message-ID: <ZQm425xPc/8wHXup@google.com>
Subject: Re: [PATCH] KVM: X86: Use octal for file permission
From:   Sean Christopherson <seanjc@google.com>
To:     Hao Peng <flyingpenghao@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM: x86: (don't capitalize the 'x')

On Tue, Sep 19, 2023, Hao Peng wrote:
> From: Peng Hao <flyingpeng@tencent.com>
> 
> Improve code readability and checkpatch warnings:
>   WARNING: Symbolic permissions 'S_IRUGO' are not preferred. Consider
> using octal permissions '0444'.
> 
> Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> ---
>  arch/x86/kvm/x86.c | 18 +++++++++---------

If we're going to do this, let's do all of x86/kvm in one patch, i.e. clean up
VMX and SVM too.

I generally don't like checkpatch-initiated cleanups, but I vote to go ahead with
this one.  I look at the params just often enough that not having to parse the
#defines would add real value for me.

Any objections?
