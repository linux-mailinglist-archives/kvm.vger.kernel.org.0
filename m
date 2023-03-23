Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6DAD6C7334
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 23:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjCWWks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 18:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCWWkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 18:40:47 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FDC2A994
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:40:45 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id m12-20020a6562cc000000b0050bdfabc8e2so41388pgv.9
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679611245;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8XoTZrf94ZBsnWSyZ+lkp+CIoXfUT01p6Wf9xa/ROag=;
        b=jCi8FWu8GLdThcksFWY2lfxOhMGbvyCfPyYPBYzIwEJFqL1P6fyTg+Yt37rm4WPUau
         yFW2QKZgvz+GS1U8i4QpyqC3IQUmxoUGogdGRkwgSKie3okaCYVoCzEGlJ1GWddRnhU3
         FZc4O/qYEd8Wc2gmkMlMmZHRscKtxN4FPCqEAHcBlMZ4ihZDP7LXYPDUKUkZkgz+VVmJ
         mDyFyZ+MD4vldIJd75MNsnq8gsIMzykHnwjtXnDjtA7OWIOIaXISJDfcyvyb+WfEENKS
         hlBAHhcC33eNmbNHUJosqqR/UAPPwhSDmNQ1FuWQaQbkkSNhYMq5J6ojLOGdwLRlGml/
         XfnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679611245;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8XoTZrf94ZBsnWSyZ+lkp+CIoXfUT01p6Wf9xa/ROag=;
        b=cEp+/AAap6yXa6meOUo3H2WmpIp8NoGhhd+JgWEdcBjjEX4x3RXsYCO02DOsWoyIhV
         uwTO53PeffvTqPGOf5Le3lfTfVR113uJW9+sRazo6U49iuxfJgFGEqj78mSOV3wUYHu7
         GOfT/viRTQvJfU/e2CLUWb04qHzld2eTstOn+4hAda70K4z5MdgccCC9d1WPmleu0r4k
         jdpopuaN5PMTZxex1QKc43k6O+fU4fznbprGwBVhGYz+nIThtzAJ6oM8UgMLpbut7ia0
         1hNkAC23nIiXB2xlpEJ3XxR2O2z2TEdXIcsazcpg6Ioq3Y30bqj42Zg4Hai2h9KVU7EN
         3Yww==
X-Gm-Message-State: AAQBX9fPQKFgL5BhLV7f6s7oOLmwpHirDFoE6Cbohk+lRHcSCXq7Qpij
        LYyN40TqIBgHCigbqQyh+HqkCJcQoAs=
X-Google-Smtp-Source: AKy350Y8hlJZNpF8D6tl2r1QvQdDlk9R9g2mFJsvhoy7FdTUPuqStlMOE9EpkEc/f7iNNshNz+vnpVNNI3c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2e9f:b0:628:1e57:afd7 with SMTP id
 fd31-20020a056a002e9f00b006281e57afd7mr579049pfb.0.1679611245013; Thu, 23 Mar
 2023 15:40:45 -0700 (PDT)
Date:   Thu, 23 Mar 2023 15:40:43 -0700
In-Reply-To: <48616deee4861976f7960f60caf59cbe37a85f1e.camel@intel.com>
Mime-Version: 1.0
References: <1679555884-32544-1-git-send-email-lirongqing@baidu.com>
 <ZBxf+ewCimtHY2XO@google.com> <48616deee4861976f7960f60caf59cbe37a85f1e.camel@intel.com>
Message-ID: <ZBzU6pa7eOgVf0Kf@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create kvm-nx-lpage-re kthread if not itlb_multihit
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Rongqing Li <lirongqing@baidu.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23, 2023, Huang, Kai wrote:
> On Thu, 2023-03-23 at 07:20 -0700, Sean Christopherson wrote:
> > On Thu, Mar 23, 2023, lirongqing@baidu.com wrote:
> > > From: Li RongQing <lirongqing@baidu.com>
> > >=20
> > > if CPU has not X86_BUG_ITLB_MULTIHIT bug, kvm-nx-lpage-re kthread
> > > is not needed to create
> >=20
> > Unless userspace forces the mitigation to be enabled, which can be done=
 while KVM
> > is running. =EF=BF=BD
> >=20
>=20
> Wondering why does userspace want to force the mitigation to be enabled i=
f CPU
> doesn't have such bug?

It's definitely useful for testing, but the real motivation is so that the
mitgation can be enabled without a kernel reboot (or reloading KVM), i.e. w=
ithout
having to drain VMs off the host, if it turns out that the host CPU actuall=
y is
vulnerable.  I.e. to guard against "Nope, not vulnerable!  Oh, wait, just k=
idding!".
