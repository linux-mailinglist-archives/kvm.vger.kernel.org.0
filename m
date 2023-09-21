Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 250AE7AA591
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 01:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjIUXYv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 19:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjIUXYu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 19:24:50 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61D0F7
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 16:24:44 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59f2c7a4f24so4588627b3.0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 16:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695338684; x=1695943484; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ozojjeDqt9jaFatqJpOSpW8v9ZUkx8fhl+FoZ/aOyeg=;
        b=YKu+ic6C4aA+MjBP+i5JluClBzt3SVtmfWjbl3RPi4KfqB9/Cflo+525/egPqpvWUc
         9qRnckj8CHy4YBjVc0Wc+vMnPKhUnWiyIzTQwd11z9YE79kdBNBFV/LAWVMResdSScXB
         tN0EgURLE6+t+c1i7WrXmQcLNhKHTse7thMU7dTqNai9qn+ikzDwA7EWjKxBGruX6W6e
         B4OCyI/zogf2S1eNFq3yGcRe2l94QMBfy4NHg4gm4IYVG8fNJVxkJd7sOviUNUQcV5TI
         93DYt/3+vqpvtYAthq6anXYBngc7IS4fnIZfSxiMMn4vP39rE+EgwbX3kiEVzdrRRVOL
         EjFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695338684; x=1695943484;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ozojjeDqt9jaFatqJpOSpW8v9ZUkx8fhl+FoZ/aOyeg=;
        b=II5OrOD1kXBAabGHbmC6eDz3gDkNcB/HD0QB89TRxPkjSBgbzJLqoT7bfvG9gGYtJb
         1SSo68DXwsvN62Oz07NOzGjUzpJzuWA3VDwldD/ItoiDG7Z5q9Ex8mHx0Go2eXEligxE
         FPUk+ww2nhIAXnCXx/6NXVxae5G9uyMtwJ7UYkK5FoRKXC9QiROsiW2n5EX+L87WL5qg
         Cv85mw6g3iVQpXpajkwW0MHXqPxV5/DQxzJOxwwr72gnYV0ODRBffgafzKR6/u1wLxxk
         SaIFWH15USYBdf05mYPjbUsmk372oDoyrzh+M026MyHkud9psVEfx1BsOcHeuWZKx16B
         6cdA==
X-Gm-Message-State: AOJu0Yzs26hR2nN4GhIQWxqSwtUn/eJPs6fFkEta/nEaHtdP/kVnZ5eQ
        u7Ez7Hbp7VPQbjWqWFJxRaTuLp925Js=
X-Google-Smtp-Source: AGHT+IF7yzjwgk5NW8qDUnHyfNzrq08FNgz+/mDFh7qp0go0unUn02BgCRowFMh78V09XOcBBXlgDQB4Wpg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b628:0:b0:59b:e684:3c76 with SMTP id
 u40-20020a81b628000000b0059be6843c76mr104384ywh.2.1695338683860; Thu, 21 Sep
 2023 16:24:43 -0700 (PDT)
Date:   Thu, 21 Sep 2023 16:24:42 -0700
In-Reply-To: <ZQwJtbXrXH/wPxpd@jiechen-ubuntu-dev>
Mime-Version: 1.0
References: <20230919234951.3163581-1-seanjc@google.com> <SA1PR11MB5923CE0CA793FF8B63DFDAEBBFF9A@SA1PR11MB5923.namprd11.prod.outlook.com>
 <ZQrsdOTPtSEhXpFT@google.com> <ZQwJtbXrXH/wPxpd@jiechen-ubuntu-dev>
Message-ID: <ZQzQum0Ulz+b19iu@google.com>
Subject: Re: [ANNOUNCE] PUCK Agenda - 2023.09.20 - No Topic (Office Hours)
From:   Sean Christopherson <seanjc@google.com>
To:     Jason Chen CJ <jason.cj.chen@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023, Jason Chen CJ wrote:
> On Wed, Sep 20, 2023 at 12:59:11PM +0000, Sean Christopherson wrote:
> > On Wed, Sep 20, 2023, Chen, Jason CJ wrote:
> > > Hi, Sean,
> > > 
> > > Do you think we can have a quick sync about the re-assess for pKVM on x86?
> > 
> > Yes, any topic is fair game.
> 
> thanks, Sean! Then if possible, could we do the quick sync next week?

No, as called out in the agenda I am unavailable/OOO the next three weeks.

My apologies for being unresponsive to your pings, I am bogged down with non-upstream
stuff at the moment.  It will likely be several weeks before I can take an in-depth
look, as I need to get going on a few things for v6.7 (vPMU fixes in particular).
