Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0157D7B1FD0
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 16:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjI1OhX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 10:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjI1OhW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 10:37:22 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCE2136
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 07:37:20 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c73fb50da6so1882485ad.0
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 07:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695911839; x=1696516639; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1QxaDNo/28khXZb4Aj1sVc9pIXz3hTbsT3xVR2UV8m8=;
        b=rknJhIbokgH0zbGE2DpHc7rvxjhI0qDOwPETMBTKXBj5ZrWZctMUe3PYldU/Uz4eMY
         piDcpdEf5e45m6PRCXYf3IZmVIsnbcMzOTYHw60xa75cxCwc4irYb0ngABf1pPhQ2nt6
         cpFYxiEqwu35c8EzPQQ4+oMEH1M4boShG6855KHXGH9K1Cx0zhyG+RVVBEfv/dENM/gH
         nbP4odRaqR6cWmGp7xQJrKdbl4Ns3EhyvwFV+l8UFmEGnhKA1t9s62/TiAqZMBVa4eKS
         BlwFoLwbpAx5lFCZPIXGbVNF49VzPN13od7Sr0IWxpkVYOjA1scNIe1L7LugvIxapZm1
         A6tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695911839; x=1696516639;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1QxaDNo/28khXZb4Aj1sVc9pIXz3hTbsT3xVR2UV8m8=;
        b=xMjlkBOmW2HGGo1tdp3qObLb+Ow8jr8BSrh1C1QYOJHhof/HWj9hO58zuvb+RBOE+b
         grZ40+CVo0ao6jSl1l+JR+tHKkbXgHNasiJseDkMxhEls0YIyLoozbTGg1NCpjxU9puc
         1/qWwHKfk84iWiL2Rigro1OBWjMO6mkCc/TF47WQnpnlk5RXXofl0WmoQamGZLAwxhjF
         lp/FACU2ZBYPGuB4gxf9sKlCM6VpJdZpYgwwOYALSWxdMawhu89WEV+559HEHf8eC5aB
         FbFGkGcskPH6qZbjFqwn8YviPCzfiRa8HavsKHIsMBY2SuiSvWoNi/3KDCI+HuJ+UF8L
         Mctg==
X-Gm-Message-State: AOJu0Yw1CIaiacWXV3PCukIB+w/HK4M0ZMRUPhLFyFTu1+kvbRCHRaHt
        ABDfV8VpWgECXJM3i23cbi5toXcDpp0=
X-Google-Smtp-Source: AGHT+IFjf4/4kxY62aGAWySYok0JrBMvXVo3onhQW53llL5R1mbFzYHYE6agELo+DEZDG1+PprgDhHr6p74=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f543:b0:1c7:2763:9ed7 with SMTP id
 h3-20020a170902f54300b001c727639ed7mr23179plf.9.1695911839637; Thu, 28 Sep
 2023 07:37:19 -0700 (PDT)
Date:   Thu, 28 Sep 2023 07:37:17 -0700
In-Reply-To: <e2a0d2cb-bc93-4d36-bf42-6963095b207f@rbox.co>
Mime-Version: 1.0
References: <20230814222358.707877-1-mhal@rbox.co> <20230814222358.707877-4-mhal@rbox.co>
 <13480bef-2646-4c01-ba81-3020a2ef2ce1@rbox.co> <ZRSMGdxk2X-cXr6z@google.com> <e2a0d2cb-bc93-4d36-bf42-6963095b207f@rbox.co>
Message-ID: <ZRWPbAW29aGePPNA@google.com>
Subject: Re: [PATCH 3/3] KVM: Correct kvm_vcpu_event(s) typo in KVM API documentation
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, corbet@lwn.net, kvm@vger.kernel.org
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

On Thu, Sep 28, 2023, Michal Luczaj wrote:
> On 9/27/23 22:10, Sean Christopherson wrote:
> > On Tue, Aug 15, 2023, Michal Luczaj wrote:
> >> On 8/15/23 00:08, Michal Luczaj wrote:
> >>> I understand that typo fixes are not always welcomed, but this
> >>> kvm_vcpu_event(s) did actually bit me, causing minor irritation.
> >>                                  ^^^
> > 
> > FWIW, my bar for fixing typos is if the typo causes any amount of confusion or
> > wasted time.  If it causes one person pain, odds are good it'll cause others pain
> > in the future.
> 
> OK, do you want me to resend just the kvm_vcpu_event(s) fix?
> (and, empathetically, introduce a typo in the changelog proper :P)

Oh, no, sorry.  I'll take this as-is.  Opportunistically fixing misspellings like
you did it totally fine, especially since this is documentation.

What I was trying to say is that if a patch fixes a real issue for someone, I'll
definitely take the time to get it applied.  I didn't mean to say I wouldn't take
other typo fixes (though I am inclined to leave code/comments alone if a typo is
benign, in order to reduce the churn in git history).
