Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D97D5A9D5B
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 18:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbiIAQok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 12:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbiIAQoV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 12:44:21 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A6A97D78
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 09:44:20 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id q9so16899508pgq.6
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 09:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=sLigUFXnpL68paVhV2xG/KPgstIumdEBWJ+bbi/JK9U=;
        b=IavlZx09rIT0V3oanIDgDI77JbuM5dyAmHQ+dQ9+hvFkNiQYaGNsJ2gkWmEkCL2ZRw
         W6QkfYCfnfts78VZdiVt2gv9ENhyWEvqzPjUJ5tR/qanFAgGQ/ttjdeZHLumeU7lZQvi
         spHbT9PhuluyGPfgKYursU6bWUacDZqSCR647JvfAjVUSATWPRwWK1QRgj4/JQh74yHo
         s+wzMrf5x7bKD2ZuDnsMOmgO7vx5koAcmvwHcxMEYHauSXsvYohSAkTDXnnkU4vvD1U4
         ey9FToMsv8LAB6uqazGgXFohoqZpWss7jrOzPzjGe0Hak6dWoiLmwxmQ0NY0pX1vAyXI
         rS2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=sLigUFXnpL68paVhV2xG/KPgstIumdEBWJ+bbi/JK9U=;
        b=0xxM9gvznHodZuKTlr0VTaP3a6ZyKiJ/WyM0zmcrRbnd2Kn3fnUq/85dY8jlaoYdMe
         WTm6Y4FCVsgEI7KfdSoICB8NsNDKGrHGtiBADjD0Rp3xgPJ40whwplWKKhJyir8XvNNP
         a6lMoLK7MXFSRAfy7UB/5iIh6QJBvqw1BY8FXb9aETKl85QRWdf2G93rcd9XtXp271B8
         yfMoZMlluPcGFvlkWq64R8EvP0wZ9X03sjHcTMzbnczHqTT/s0G7VGTU2tjLPnOVAFCc
         Qc50XU+VyxFVQtuyWCbNlzJoPxn2CPJzsvWNTIQJS5fZyfDAHOjnl6SK7oNNRqdq0Zrf
         xtcQ==
X-Gm-Message-State: ACgBeo0wU7URJHgPqSyh7JMXaYXbMxeoO+re1Ad+1SLk3OfhinKtYZPd
        BGlaYA07l5MGtBhzcYi6yetgMrJou6RW5A==
X-Google-Smtp-Source: AA6agR4LuFPano2gBhtFPmHG+QxzLLSGd/RegwaZCeKJgQtbhs79FR/JFao+e6Io+FYx6TfOiYMzwg==
X-Received: by 2002:a65:5688:0:b0:3c2:1015:988e with SMTP id v8-20020a655688000000b003c21015988emr26910233pgs.280.1662050659999;
        Thu, 01 Sep 2022 09:44:19 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w13-20020a6556cd000000b0042ba1a95235sm5509645pgs.86.2022.09.01.09.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 09:44:19 -0700 (PDT)
Date:   Thu, 1 Sep 2022 16:44:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     bugzilla-daemon@kernel.org
Cc:     kvm@vger.kernel.org
Subject: Re: [Bug 216388] On Host, kernel errors in KVM, on guests, it shows
 CPU stalls
Message-ID: <YxDhX7WAFxIlFkCQ@google.com>
References: <bug-216388-28872@https.bugzilla.kernel.org/>
 <bug-216388-28872-L9iQIQTrXh@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-216388-28872-L9iQIQTrXh@https.bugzilla.kernel.org/>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=216388
> 
> --- Comment #6 from Robert Dinse (nanook@eskimo.com) ---
> Installed 5.19.6 on a couple of machines today, still getting CPU stalls but in
> random locations:

...

>      Are these related or should I open a new ticket?  These occurred right
> after boot.

Odds are very good that all of the stalls are due to one bug.  Stall warnings fire
when a task or CPU waiting on an RCU grace period hasn't made forward progress in
a certain amount of time.  In both cases, many times the CPU yelling that it's
stalled is a victim and not the culprit, i.e. a stalled task/CPU often indicates
that something is broken elsewhere in the system that is preventing forward progress
on _this_ task/CPU.

Normally I would suggest bisecting, but given that v5.18 is broken for you that
probably isn't an option.

In the logs, are there any common patterns (beyond running KVM)?  E.g. any functions
that show up in stack traces in all instances?  If nothing obvious jumps out, it
might be worth uploading a pile of (compressed) traces somewhere so that others can
poke through them; maybe someone will find the needle.
