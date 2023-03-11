Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2406B57D7
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 03:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjCKCg7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 21:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCKCg6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 21:36:58 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF9414690B
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 18:36:56 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id q2so2643637qki.3
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 18:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678502215;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F+Vyd6sqY/mpB+lTAh14UdgBDKJBGf7PbsZdXJu95Aw=;
        b=YazwcVXcnTYW3k/lE21CSB5rldKW7BVi5w6NxnLCif5ls0R1rq4aZkIbhgMjbX3adT
         7DgilR74XD1xMMGhjW9l3ZfoI+k5YdwEqGpz6+KfHa1rcHf5IudC4HOq3CDAikWipQYF
         pLlA34E7c9kYYnlmkBTzkTPjNADstuNmFoZ0LBEumTdu1ta8E56DMuvyKGi2lLjksJbc
         8xzlxeuD8buQLrxnkxgMJ1Wc/xmWe99Z5YeFUck/yP0THFY/tizSMC2FzVvtncoU2Vck
         sH+sYwYQ5TUuMHH23YQR1YtqDA2sraWV9LfgxJccoI/rMNRfa9P8u3bipf8L5Pu27+Jh
         ddNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678502215;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F+Vyd6sqY/mpB+lTAh14UdgBDKJBGf7PbsZdXJu95Aw=;
        b=N/Vh7Uv7G/kIDcVuRoNiUWndhckONWfCPuzlTZvTNy+9NllC/gDbFvW2cF09aGqCce
         s1CyXBoQhjwCcIoSZ9E20MpZiCjYOvVjqfG4yenu6mt9XVr8pl0MuPQuT3VRPo3XySOX
         YXhIfSp5Wu2ITf0lR/0Mg5XpeQEIgdYU4rEGcxSTcJfnsHiG1fbB/LuxjF/G1Me17HWo
         yWhy8LXjA64MQCBOkmRzONGAg9JUqe8YttpeN+kvCxoyv1Xevurv2sy4dr1/9OcecXjf
         VDbOaXifjjZeW9t1vizrRSl0krT1+zsFzKkvxVWVSoD3lsqcPenG7Zj/kqaOzbUlwln2
         oGvw==
X-Gm-Message-State: AO0yUKWe50laFnBoYIfjLtBpv0QI9g0DJbxsR4DTW9Yr8mPzMJtu/ajR
        3dVwxB9mTYk4vuH7zwmlNtab+62H/2sRpVPCd+g=
X-Google-Smtp-Source: AK7set/35LxoohXZNLweDrhbby7AsJiM+efmL5NMzCiqYNXW3GzEFx/o7LAFzlJq/yta4O/Aq3Fy37PwA0ER2YQVczk=
X-Received: by 2002:a05:620a:1677:b0:742:7044:97bc with SMTP id
 d23-20020a05620a167700b00742704497bcmr1367563qko.6.1678502215374; Fri, 10 Mar
 2023 18:36:55 -0800 (PST)
MIME-Version: 1.0
References: <20230310125718.1442088-1-robert.hu@intel.com> <20230310125718.1442088-3-robert.hu@intel.com>
 <ZAtW7PF/1yhgBwYP@google.com>
In-Reply-To: <ZAtW7PF/1yhgBwYP@google.com>
From:   Robert Hoo <robert.hoo.linux@gmail.com>
Date:   Sat, 11 Mar 2023 10:36:43 +0800
Message-ID: <CA+wubQAXBFthBhsNqWDtY=Qf4-FtfJ3dojJctXXg=iokXJRbmg@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: VMX: Remove a unnecessary cpu_has_vmx_desc()
 check in vmx_set_cr4()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Robert Hoo <robert.hu@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> =E4=BA=8E2023=E5=B9=B43=E6=9C=8811=
=E6=97=A5=E5=91=A8=E5=85=AD 00:12=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Mar 10, 2023, Robert Hoo wrote:
> > Remove the unnecessary cpu_has_vmx_desc() check for emulating UMIP.
>
> It's not unnecessary.  See commit 64f7a11586ab ("KVM: vmx: update sec exe=
c controls
> for UMIP iff emulating UMIP").  Dropping the check will cause KVM to exec=
ute
>
>         secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_DESC);
>
> on CPUs that don't have SECONDARY_VM_EXEC_CONTROL.

Sorry I don't follow you.
My point is that, given it has passed kvm_is_valid_cr4() (in
kvm_set_cr4()), we can assert
boot_cpu_has(X86_FEATURE_UMIP)  and vmx_umip_emulated() must be at least on=
e
true. Therefore when !boot_cpu_has(X86_FEATURE_UMIP),
vmx_umip_emulated() must be
true, therefore checking it is redundant.

Do you mean other call path other than kvm_set_cr4() --> vmx_set_cr4()? i.e=
.
vmx_set_cr0() --> vmx_set_cr4()?
nested_... --> vmx_set_cr4()?
Emm, they seem don't go through kvm_is_valid_cr4() firstly.
