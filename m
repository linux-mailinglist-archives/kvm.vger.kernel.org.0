Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44317D79F8
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 03:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbjJZBKR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 21:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjJZBKQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 21:10:16 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BA9A4
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 18:10:14 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d81e9981ff4so289553276.3
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 18:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698282614; x=1698887414; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DyTK0dPzGluAcQuuHIU80+KHFmV8NJJH2jk5jCqZTKI=;
        b=minly+N+qkV7I0IFo1WfqDNN0b12/zoxtsjCi3i6hlmXXkujg4SMjup3ho6bYrIAH6
         cSsoKJER8wdF2FjpNJfokvS3eIc130UoyLxd1lUlvChfvU2Hwhn6Y5uauUQXxoDZYfbU
         9eXxB38+PtUIjZRnZFehDwv5CCHShAw2VB1SOfr0cdUCxJkE2uYAvl9BBwVErKhvuLET
         8cHANFe08OCTpJT0Bw8GsdmG4P9toEFRkEDm6wekUziD4VqadzT5YCT9ILIqU22VJRS0
         wGmzJSigCI7nyraH7GRd9GrYdZS+Dwn7qB21zhiVdj7CO5MdVaCZ18L5E319Jm0DbXef
         TTnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698282614; x=1698887414;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DyTK0dPzGluAcQuuHIU80+KHFmV8NJJH2jk5jCqZTKI=;
        b=BoGQjS6UrCy0+uO8p404pPJihP7IVmzG5Ne4QSzs3+SXDARAVx9tFBFsqKlBMrlKPj
         tBtzfmBTh5vzOVf3/11/UwpP30VJYKMa6dq0g4C77QStxPQr8V/m5kb58FhPpCYH/Bh0
         mbInHUyCWDXCZuLYKX90MQ9j7Ieoc4En1M4VlWHksE56bQAo7QHRQOGvbeFvXIKSfYZV
         y18wib8ScTsELlJVSMVQDD0lcygBfIEPgSA7JRkuuKTNtJszNMtr8TSsBJXQ6DSjrjuw
         WplNBqdeT2DnFASe2J0yFHUEUiKIuQtDPumDIQSF1Q+GK8vMJkijdSRKUoF47TWbSAic
         QGJg==
X-Gm-Message-State: AOJu0Yzn2pynLkzAGilFAYmLEnoUAp0RaOlUFPgq4BXbD0KT4D2L/Or7
        XAR/6wXCXKqNc4zvhhMpgBYOsfY0UeA=
X-Google-Smtp-Source: AGHT+IG5b53M3tonsPzhhr9QutLMpCc9iv9km4Y7t/iM37E2mRMI/XCdaH6nUGaGZ+FXpuIcoFrorwwmlCI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1083:b0:d9a:6007:223a with SMTP id
 v3-20020a056902108300b00d9a6007223amr473790ybu.8.1698282613921; Wed, 25 Oct
 2023 18:10:13 -0700 (PDT)
Date:   Wed, 25 Oct 2023 18:10:12 -0700
In-Reply-To: <ZTklnN2I3gYjGxVv@google.com>
Mime-Version: 1.0
References: <20231007064019.17472-1-likexu@tencent.com> <e4d6c6a5030f49f44febf99ba4c7040938c3c483.camel@redhat.com>
 <53d7caba-8b00-42ab-849a-d8c8d94aea37@gmail.com> <ZTklnN2I3gYjGxVv@google.com>
Message-ID: <ZTm8dH1GQ3vQtQua@google.com>
Subject: Re: [PATCH] KVM: x86/xsave: Remove 'return void' expression for 'void function'
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 25, 2023, Sean Christopherson wrote:
> On Wed, Oct 25, 2023, Like Xu wrote:
> > Emm, did we miss this little fix ?
> 
> No, I have it earmarked, it's just not a priority because it doesn't truly fix
> anything.  Though I suppose it probably makes to apply it for 6.8, waiting one
> more day to send PULL requests to Paolo isn't a problem.

Heh, when I tried to apply this I got reminded of why I held it for later.  I
want to apply it to kvm-x86/misc, but that's based on ~6.6-rc2 (plus a few KVM
patches), i.e. doesn't have the "buggy" commit.  I don't want to rebase "misc",
nor do I want to create a branch and PULL request for a single trivial commit.

So for logistical reasons, I'm not going apply this right away, but I will make
sure it gets into v6.7.
