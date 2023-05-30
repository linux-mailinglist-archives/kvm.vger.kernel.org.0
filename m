Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED3F716B3B
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 19:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbjE3Rhg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 13:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbjE3Rhf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 13:37:35 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB2FC5
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 10:37:32 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba83a9779f3so9170793276.1
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 10:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685468252; x=1688060252;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OcR9cOf4iNxvcptr0XhjKDmCn9YVouEV8X1B4pLhZos=;
        b=2owOn5ofEJH8z5xQXF3wRlLfqsfnpAbD5656tieTF+k6aazPFTGqzXWX1Ncw9pSWgm
         6Uu41j315BtDBiMeWlumYZxrhS8WCCRhp5X9R/qvzzYrU7cOt+rb1JL+mxaNnbaE78gT
         +7DT07mObBuGXuFs3NhAYXxpD3qXK2w8XajhKwAwzzLOlYSzkglQYnqQvJ1HuNlCCavK
         NhGN98NvCRLgRj32sjfZDdlklM8FhLeyOKaCMHppgqfjbngTlLf/U2XhbzdXt2bVAtf7
         Lb6sYyk0Sj0ESb3zLwRDTN6ox5HCp2LnSy7c254529yo2FaYwLBtNeylQWfqfEYrM5kY
         DjEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685468252; x=1688060252;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OcR9cOf4iNxvcptr0XhjKDmCn9YVouEV8X1B4pLhZos=;
        b=SqHV9ekqA3qKeiUvP635TRnb9wfJH1EDvDBnsqTUb7B6UVEKUVhXqfQHqwns7G+Wjc
         Spn6FwziHUEXgi+anpqxg7BCHa2n9pCfHvuSDn9UyXonWYwY3JOrt0TzMNtM2RDMdaiD
         v2McIfWcTFJ6NfTEt+4hIs8lpfDEq8Hrkdw1pDob9p/XaewsgPVtfiOPbhAPi1Rq2mA9
         Zz/ks9CYYiP3iKeia4ngkPaWcCjnsiA7erGV1GohrZ0q/x3W0YnF+cK1Ayx+CupVbOa4
         7rOwH7rhAMj+PK47nydrT0K57pE/X+FhsIKES/do321BUw6VkLym30QOwsGwaGfh7z9w
         eUkw==
X-Gm-Message-State: AC+VfDxRWzS7dFU+z0yVzQksZf2MIvV3aSFcjbHqjG17ki4pcPze1v+7
        fTuL7WXitwWTZScY8P7MKggLW1qHkiA=
X-Google-Smtp-Source: ACHHUZ6omR/+/JpyHNAJjPOrIi/nvTDl7T8hNgfgqut+pVpe10qa7llxGDnkDcyui6PYSWMEIkjFkAJuWXY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:4ea:b0:ba8:337a:d8a3 with SMTP id
 w10-20020a05690204ea00b00ba8337ad8a3mr1790878ybs.11.1685468251848; Tue, 30
 May 2023 10:37:31 -0700 (PDT)
Date:   Tue, 30 May 2023 10:37:30 -0700
In-Reply-To: <CADpTngWiXNh1wAFM_EYGm-Coa8nv61Tu=3TG+Z2dVCojp2K1yg@mail.gmail.com>
Mime-Version: 1.0
References: <CADpTngX9LESCdHVu_2mQkNGena_Ng2CphWNwsRGSMxzDsTjU2A@mail.gmail.com>
 <ZHNMsmpo2LWjnw1A@debian.me> <CADpTngWiXNh1wAFM_EYGm-Coa8nv61Tu=3TG+Z2dVCojp2K1yg@mail.gmail.com>
Message-ID: <ZHY0WkNlui91Mxoj@google.com>
Subject: Re: WARNING trace at kvm_nx_huge_page_recovery_worker on 6.3.4
From:   Sean Christopherson <seanjc@google.com>
To:     Fabio Coatti <fabio.coatti@gmail.com>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>, stable@vger.kernel.org,
        regressions@lists.linux.dev, kvm@vger.kernel.org,
        Junaid Shahid <junaids@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 30, 2023, Fabio Coatti wrote:
> Il giorno dom 28 mag 2023 alle ore 14:44 Bagas Sanjaya
> <bagasdotme@gmail.com> ha scritto:
> > #regzbot ^introduced: v6.3.1..v6.3.2
> > #regzbot title: WARNING trace at kvm_nx_huge_page_recovery_worker when opening a new tab in Chrome
> 
> Out of curiosity, I recompiled 6.3.4 after reverting the following
> commit mentioned in 6.3.2 changelog:
> 
> commit 2ec1fe292d6edb3bd112f900692d9ef292b1fa8b
> Author: Sean Christopherson <seanjc@google.com>
> Date:   Wed Apr 26 15:03:23 2023 -0700
> KVM: x86: Preserve TDP MMU roots until they are explicitly invalidated
> commit edbdb43fc96b11b3bfa531be306a1993d9fe89ec upstream.
> 
> And the WARN message no longer appears on my host kernel logs, at
> least so far :)

Hmm, more than likely an NX shadow page is outliving a memslot update.  I'll take
another look at those flows to see if I can spot a race or leak.

> > Fabio, can you also check the mainline (on guest)?
> 
> Not sure to understand, you mean 6.4-rcX? I can do that, sure, but why
> on guest?

Misunderstanding probably?  Please do test with 6.4-rcX on the host.  I expect
the WARN to reproduce there as well, but if it doesn't then we'll have a very
useful datapoint.
