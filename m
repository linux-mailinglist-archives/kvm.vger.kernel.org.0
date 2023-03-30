Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2E786D0E9A
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 21:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjC3TUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 15:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbjC3TUO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 15:20:14 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153EA1026B
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 12:19:48 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id e5-20020a17090301c500b001a1aa687e4bso11701534plh.17
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 12:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680203984;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vYGFhfsZ2Ecmb8uYV1jrnAq/BaJrhlo0PDBr6xkUILY=;
        b=XaVSLMdUDhaP68fLL/zCZVkjOh80Vb4AO627xMoUUfARffX2UTApO6qUALGmyAM+Zd
         SaqvMsWZ3zk5iSveeF54nMyEGHR53Vu9ZOLQF5Iakql4VnBgEws7AsUvasDG7sDNzRPg
         GvR/nRVWeuoV65WRfiYoJLlLDx4uXtLd4WQTLnk8wxEIeuPYd/0ZoWHIjYVHw4QVnccK
         6i9nnEEsqW3BuBhu7GaY2XnrKu3TpCdD19Wlze5aa1dNCWdK7Vj44dzNvxlrkbJe/iDy
         v9p+yqB3WJdkxIKcQIbMOOVV+uvhd7jJhmC2EeoSyXWhQQCnNAZXOKDJlC28C7DFXwqV
         I+JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680203984;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vYGFhfsZ2Ecmb8uYV1jrnAq/BaJrhlo0PDBr6xkUILY=;
        b=HFO5NK5DoJpM8CaX+88R92zLxF6JOxAGQrF2Yn0SUW2+69a0zcpowP3xw2OhZWSEqw
         VGodL57CgFIaw4js8GV4ZzDTyz8wYja3/yCl7pqgerBxi78oPKyeQ3cwqXI63tt7xIUE
         ktTDEtftB3f8WajLBliyTN238i8P4DKZR6JZmev5nlo4QFkyShqoXG6JacKIBOCJBJHD
         n9h+r06Zj2+Qu/OAuuWlawVZ+ceaDDYTAAUfELDOwHdQ4FkeD3sDQKQjkFzb6xmBhvZ3
         qNP4Qo5QyFFz6+bX1C4NeCXDSEagufVCnCmgHlgClb7c2dYbGQs1JOAW3/mZ6rlpkf40
         GIPQ==
X-Gm-Message-State: AAQBX9e1TTz1gjCx2eYm7mf2MsWuiOiMzXTvMrOOScePSIx+aBpxzOaU
        KqTAYWinzyqqjAZxRtOY3VeLk9/V9oQ=
X-Google-Smtp-Source: AKy350ZMpOiGP0Yy5XAOoTmOXiybfQIh1YhQ0j+A2r6TJsa9PcE5d6Wscyxc2mOhN9nw7hjMxACvsoGDjmY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:6943:b0:236:a1f9:9a9d with SMTP id
 j3-20020a17090a694300b00236a1f99a9dmr2952609pjm.2.1680203984692; Thu, 30 Mar
 2023 12:19:44 -0700 (PDT)
Date:   Thu, 30 Mar 2023 12:19:43 -0700
In-Reply-To: <b1d9bf5a35d545879cb4eca4037b5280@baidu.com>
Mime-Version: 1.0
References: <1679555884-32544-1-git-send-email-lirongqing@baidu.com>
 <ZBxf+ewCimtHY2XO@google.com> <b1d9bf5a35d545879cb4eca4037b5280@baidu.com>
Message-ID: <ZCXgsCYk1AWYvTsP@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create kvm-nx-lpage-re kthread if not itlb_multihit
From:   Sean Christopherson <seanjc@google.com>
To:     Rongqing Li <lirongqing@baidu.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023, Li,Rongqing wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > On Thu, Mar 23, 2023, lirongqing@baidu.com wrote:
> > > From: Li RongQing <lirongqing@baidu.com>
> > >
> > > if CPU has not X86_BUG_ITLB_MULTIHIT bug, kvm-nx-lpage-re kthread is
> > > not needed to create
> > 
> > Unless userspace forces the mitigation to be enabled, which can be done while
> > KVM is running.  I agree that spinning up a kthread that is unlikely to be used is
> > less than ideal, but the ~8KiB or so overhead is per-VM and not really all that
> > notable, e.g. KVM's page tables easily exceed that.
> > 
> 
> A thread will create lots of proc file, and slow the command, like: ps

"ps" doesn't seem like a performance critical operation though.  Again, I'm not
completely against letting the admin opt-out entirely, but I do want sufficient
justification for the extra complexity, both in the code base and in documentation.
