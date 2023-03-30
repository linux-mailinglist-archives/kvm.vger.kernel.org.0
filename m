Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4E16CF9A7
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 05:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjC3Doq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 23:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjC3Dol (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 23:44:41 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09AE3526F
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 20:44:41 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l14-20020a170902f68e00b001a1a9a1d326so10433211plg.9
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 20:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680147880;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XtS4ffNy9WGD8mXuYOI9etZtjBQFkCQ/o4N7TvvD7Ws=;
        b=ME0Y6mYPyMaBgZPhSbo9DclSuUZYVMs9VJWrKgrf2ZRB9MHPvUMO3DiK4PIfktqJjz
         AwAcoeJb+dVIO8CIM9umZMJRPIPrqLd8BduACCFdGGA0jibr6hWS5qTxdG47CU6zM6A1
         Nq+KPHbtVPzCtSwLN1Ks5TOkNey1jDCGf6mTcIPQryshEu3egZuJwifmy9BwUovcZq9S
         td9+g5SLdXbk3ZvSahIbfqxzYprOVB86THO7MxVJNrO7CE/J1xy8bifEpqPiggkNeSJY
         hZCPiufeR1yGuRuYQ39AY7EAQ23FGTVvTUfa/g1Kjba6lnE33cvi/OYB/Oj/fss7tXla
         R7Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680147880;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XtS4ffNy9WGD8mXuYOI9etZtjBQFkCQ/o4N7TvvD7Ws=;
        b=EnjW+h35H/IfI0/s1n8HyeT1ICds0DtxiBE8HicZZ4bmMiZQuuslq8nfvMa5kkraCh
         cezlH91N4TAYWVOY2kbdKp7lj79QfUBWvboxsbuCS6e9BrbZG/GEZRf9tesxiol+QLH0
         Oplu/vMkqIA4d2BlOtP47Bhg8S8erSMzLobEIWRpbpE5MXZEuktOFIfuXnwJ1/ed2AQq
         tGvw/8KpdMgynCbACIgMwtJwa1wUCieoONmhO9QYu05pP/wrz5pHMP90jblDBqEU77D4
         8hf1ppYYKHAqllKFYeJ0o98NJVgFm01rH6Cl4gEMy0H3aUkZGbFFoIy5dFCq2PK3/ed+
         vYKg==
X-Gm-Message-State: AAQBX9exSXY1sL1ng+hjKoAbBzLTzua3JauHLCo91K00EsKScxSZSNeC
        zckF5uEqmRXnurf7ZFhK+swDqkmFxtw=
X-Google-Smtp-Source: AKy350Z6WqglPzws8H5b3TR4jjEhE64t3nakeC9suvnjqCIcXMjGmSTc2M8G2MQveafPyMxg9QqmBDXLGNU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1203:b0:240:c387:6089 with SMTP id
 gl3-20020a17090b120300b00240c3876089mr299277pjb.1.1680147880561; Wed, 29 Mar
 2023 20:44:40 -0700 (PDT)
Date:   Wed, 29 Mar 2023 20:44:33 -0700
In-Reply-To: <49dd4ae8-9b7a-b6ce-ee9b-3ba76b12c06e@intel.com>
Mime-Version: 1.0
References: <20230328050231.3008531-1-seanjc@google.com> <20230328050231.3008531-2-seanjc@google.com>
 <620935f7-dd7a-2db6-1ddf-8dae27326f60@intel.com> <ZCMCzpAkGV56+ZbS@google.com>
 <05792cbd-7fdb-6bf2-ebaa-9d13a2c4fddd@intel.com> <ZCRogsvUYMQV6kca@google.com>
 <49dd4ae8-9b7a-b6ce-ee9b-3ba76b12c06e@intel.com>
Message-ID: <ZCUFoeqONfWU1+D1@google.com>
Subject: Re: [kvm-unit-tests PATCH 1/3] x86: Add define for
 MSR_IA32_PRED_CMD's PRED_CMD_IBPB (bit 0)
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
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

On Thu, Mar 30, 2023, Xiaoyao Li wrote:
> On 3/30/2023 12:36 AM, Sean Christopherson wrote:
> > On Wed, Mar 29, 2023, Xiaoyao Li wrote:
> > > On 3/28/2023 11:07 PM, Sean Christopherson wrote:
> > > > On Tue, Mar 28, 2023, Xiaoyao Li wrote:
> > > > > On 3/28/2023 1:02 PM, Sean Christopherson wrote:
> > > > > > Add a define for PRED_CMD_IBPB and use it to replace the open coded '1' in
> > > > > > the nVMX library.
> > > > > What does nVMX mean here?
> > > > Nested VMX.  From KUT's perspective, the testing exists to validate KVM's nested
> > > > VMX implementation.  If it's at all confusing, I'll drop the 'n'  And we've already
> > > > established that KUT can be used on bare metal, even if that's not the primary use
> > > > case.
> > > So vmexit.flat is supposed to be ran in L1 VM?
> > Not all of the tests can be run on bare metal, e.g. I can't imagine the VMware
> > backdoor test works either.
> > 
> 
> Sorry, I think neither I ask clearly nor you got my point.
> 
> You said "the testing exists to validate KVM's nested VMX implementation".
> So I want to know what's the expected usage to run vmexit.flat.
> 
> If for nested, we need to first boot a VM and then inside the VM we run the
> vmexit.flat with QEMU, right?
> 
> That's what confuses me. Isn't vmexit.flat supposed to be directly used on
> the host with QEMU? In this case, nothing to do with nested.

Oof, my bad, I had a literacy problem.  I somehow read "vmx.c" instead of "vmexit.c",
and never picked up on what you were saying.  I'll fix the changelog.
