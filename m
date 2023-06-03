Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2147720CCE
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 03:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237017AbjFCBHu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 21:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236128AbjFCBHs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 21:07:48 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAFAE48
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 18:07:47 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba8338f20bdso3844884276.0
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 18:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685754466; x=1688346466;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FLmhMV9XyKKiYsG3/7lQvDrFcS37TrSgO5kVnY8wmfU=;
        b=QWRuhagCLE/Tq56L7GKOFndovl7SmADq5bx8vX2d9wjMIiG1pLdM8q1caB2LrAqejB
         jX01JEAPdRkkQWqMZF3YKsKvZOMnS4SJjHlrELoLV/jeFxMSJsSKUOnuOgjk17v0Conr
         p8OsbCcG78PpMIrcILc4BVhAWW9TePFjXNQ3S2It65uxWNjSdEnMx/m5s6uR1UonyNT4
         +UOkC4clwURUoMb34HeQEXoBDwkZLK7t4GFBPdemscWMMZwQTbSdC6YluSz8Lb1VbvYP
         QE6qhORivpJ89wcdeyMuLGYthxwu+r4gf12HOKXapYl1vzjv/Sp10oHvKUyP1KDBHiAC
         Pl3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685754466; x=1688346466;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FLmhMV9XyKKiYsG3/7lQvDrFcS37TrSgO5kVnY8wmfU=;
        b=CYb3nypYKMKO275yQ4s+EBStkEPjVAngZHG0vt35YfT25N+NCfDnb9EW6Dunz8DopF
         RziJHhh/IU/MNhIceTgf+WO8z8efMcCX5+CCtsT1X0L1KBFi6TXhmMHOHhq27FhPk7ER
         wroVMiX6yjATiCWlK+6U/hp/+z+Aocl+SPuO5gMqdAoHfGiFC1ShegADmauM1jTgJIte
         GHCpiKBKUiWn9IDY1JLNDlH8z58ihgO5TgVRkmmiumjmom+e7gVMkvwKZiAZGpVl9UrE
         blw3Yk+ljqCDrMzrW3v5Xd6ntF1D90MW3UKT6ZRvfLgKbpdwpBLrdqut2oc+t32m7CvF
         VuIA==
X-Gm-Message-State: AC+VfDweaB6NkGAgPeWWIkNOm0pTG/QbDHfCAc//MkGF9vRmUBi3tmZv
        IyD9PcX/hP8s/h/RePqKuvR1/2jeKq8=
X-Google-Smtp-Source: ACHHUZ7Z1bFovuXnK1rJp6WzZr5U8tmJNDQrbukR97I2kVZw99w7qCw4MTune9Xvec+/orZpSb//4fpc3WQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1206:b0:bac:f608:7113 with SMTP id
 s6-20020a056902120600b00bacf6087113mr2948690ybu.4.1685754466754; Fri, 02 Jun
 2023 18:07:46 -0700 (PDT)
Date:   Fri, 2 Jun 2023 18:07:45 -0700
In-Reply-To: <20230525153204.27960-1-rdunlap@infradead.org>
Mime-Version: 1.0
References: <20230525153204.27960-1-rdunlap@infradead.org>
Message-ID: <ZHqSYbYscprsU2qT@google.com>
Subject: Re: [PATCH v2] KVM: MAINTAINERS: note that linux-kvm.org isn't current
From:   Sean Christopherson <seanjc@google.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 25, 2023, Randy Dunlap wrote:
> www.linux-kvm.org is not kept current. It contains antiquated
> and historical information. Don't send people to it for current
> information on KVM.

It's definitely stale, though unless Red Hat (presumed hoster) plans on decomissioning
the site, I'd prefer to keep the reference and instead improve the site.  We (Google)
are planning on committing resources to update KVM documentation that doesn't belong
in the kernel itself, and updating www.linux-kvm.org instead of creating something new
seems like a no-brainer.  I can't promise an updates will happen super quickly, but I
will do what I can to make 'em happen sooner than later.

Paolo?
