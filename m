Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B843771300B
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 00:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243227AbjEZW1R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 18:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244353AbjEZW1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 18:27:13 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F454E47
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 15:27:10 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1ae79528ad4so8392175ad.3
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 15:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685140030; x=1687732030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E+kn5jvpzlh+utylQKrm+3JtysqFVAJXSZK4V7SHQK0=;
        b=LrJysw0bLgoRVpiuVdvbFTCyaw8iGCc0NyWU0iWouBiAQAUjsUqN9jJKiP2cGCreDB
         xemsueFR1JoUwQWpWwGZYcovVd0LmB1H0Yhs6GGvd0FkszbezXMrn6vD6vzXA5qQiznj
         GfJK4YjHrB+ux5NJgQgTyySjkF+q2vuLpy5wjXJl5hssH3TxR47HkR+FH0sX+BDztWe5
         NC+/tXE5f3x4HoBYeDqKg6mo4rOTDoTddjxSWSsTKzT4HjqN92DbhS9IPPfoJ+EIJD9K
         d54R4zERsnCD+ho9k9iHNMtpfIMmwB3dxvaXVIom5hnkiJrfw5109lTawwiGZsc9R01C
         YZ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685140030; x=1687732030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E+kn5jvpzlh+utylQKrm+3JtysqFVAJXSZK4V7SHQK0=;
        b=R9VcRYxSFEjvBFl6okOV+Da9ejpy+vSjPRNFMmRozCcFQAB9n0ltvmDiI3pfxrolqf
         ozb64VMilExhJk10iN2EBs9Rs7O42EIYOU3JIjVITQCVCRBBL6nBFJXOTsFYlGzyMwwz
         bTMh2ojv3FMaqJFltzPAe/A9XTsT9Yx36X3jPunznMIftYqh6daL4XZolyBazWEJ/ovH
         L1yChhCSkIzfV/lrW5wvchJTpx0hlBZBL2DQnlJnZtNWHkRJ2sn9516S+kAUvvhBIzXz
         fN8qkIw+MgB85y3L3aN+S+TeuJ3gGYYzd7oiy5NQmOfCWU7xa+w1sNCYpOmSVmsbf28f
         rLPw==
X-Gm-Message-State: AC+VfDz8qsgUcaFEg3MB/N6tPvBQw4Y89oExTb/BH+KZ9JWW2ngv34xQ
        rhfuWg92i+OzV34AroCfm/QG/PmN8yo=
X-Google-Smtp-Source: ACHHUZ4TYWcASHRXWe6Fi6LR2A+91ZBssr+QyfpjfRxDwnOBSS6XeqCRVPHw234WOwLCb5HXnjkb5CaOL4A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:788d:b0:1ae:549f:af6e with SMTP id
 q13-20020a170902788d00b001ae549faf6emr920128pll.7.1685140030058; Fri, 26 May
 2023 15:27:10 -0700 (PDT)
Date:   Fri, 26 May 2023 15:27:08 -0700
In-Reply-To: <f4c2108d-b5a0-bdee-f354-28ed7e5d4bd5@rbox.co>
Mime-Version: 1.0
References: <20230525183347.2562472-1-mhal@rbox.co> <20230525183347.2562472-2-mhal@rbox.co>
 <ZG/4UN2VpZ1a6ek1@google.com> <016686aa-fedc-08bf-df42-9451bba9f82e@rbox.co>
 <ZHDbos7Kf2aX/zyg@google.com> <f4c2108d-b5a0-bdee-f354-28ed7e5d4bd5@rbox.co>
Message-ID: <ZHEyPDlw67VOQFs/@google.com>
Subject: Re: [PATCH 1/3] KVM: x86: Fix out-of-bounds access in kvm_recalculate_phys_map()
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org
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

On Fri, May 26, 2023, Michal Luczaj wrote:
> On 5/26/23 18:17, Sean Christopherson wrote:
> > On Fri, May 26, 2023, Michal Luczaj wrote:
> >> Maybe it's not important, but what about moving xapic_id_mismatch
> >> (re)initialization after "retry:"?
> > 
> > Oof, good catch.  I think it makes sense to move max_id (re)initialization too,
> > even though I can't imagine it would matter in practice.
> 
> Right, I forgot that max APIC ID can decrease along the way.

Actually, we don't want to reset max_id.  That would allow userspace or the guest
to put KVM into an infinite loop, e.g. by toggling the APIC of the vCPU with the
highest x2APIC ID between enabled and disabled.  The downside of not shrinking the
size is quite negligible.
