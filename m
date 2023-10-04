Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE3E7B89F4
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 20:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244314AbjJDSap (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 14:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244323AbjJDSal (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 14:30:41 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B38AD
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 11:30:38 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-2777d237229so85743a91.2
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 11:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696444238; x=1697049038; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bLvtp0QMoGYySE9wosYwCfDiMQTfzGa8df2T3UXcExo=;
        b=SeVze/GnEE+ou15Shp91ACh89GI0NGvSy8mM+kRHbKPuQl9dw4jf4EnlUQ9ne9Qz4z
         cD+CcomkKvkuWtKLXG8UwcVx6cKpUdXsnrX6OsNmf8OEFbYgjl0COdCnxHtZjF/s+YWS
         PvA/27jqQ9ELBFNxZ2d+ynUj4+JYkx30Ut/fedvMgt9jcpfWDozkYbNAgUoTF+xMiax/
         5MqSuBDgsjDO8qa7x345jL64m5EM0SPKzbyIe7ukLjeXvLJEOB0jEd0tmq6gAlDrS5ze
         lg23kU3YqbW2U3a0R8Vtqfm/bUachzWUKfwuvApAFaQhkX/lp6QAbD/8CiIPJd6HY/iK
         Okag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696444238; x=1697049038;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bLvtp0QMoGYySE9wosYwCfDiMQTfzGa8df2T3UXcExo=;
        b=AfEhtfzGa52H1dKnAAKykbUsnK2GujQYze5h4qGv3S+J6KKQ+hcQFqJpB+GIU1k1e5
         OOHuMK/z8AIu+qPd2CATNe519lXoYF0u0rcN7wtVF1uaziN3pQ8RCNNDNrZL2Sgaw32Y
         PB7Ahbv0+zx39RxY32V5neNQP1V450NtFbLrWU/yei0wYTrL3RmVGrM6NFZ3Jfkyg/x1
         XVVgba5p90BiIbV5FWCmF5LbxZnKgAJPC1X1tOZ1SSdaayLrXBdZTBWfs93pQFshbwfn
         GlyKmtEDN6PzdImBHHeO2kia4Tem2hPPFqNQWkT+Ooi9MEWB/LOV3feeC1Drev2FTrmu
         FE/g==
X-Gm-Message-State: AOJu0YwCxVe+I6ut929rbV17TpxQsfYHkOQMizUj6pulYBjClvJl2VFN
        1LwHS7LQxUUslKViv081D9TiAGtWquk=
X-Google-Smtp-Source: AGHT+IFb4/zLDHhoTO/L9ADnf3OtDeiNfQcNDUYeMN7UNbw0aWvcWor6OIqqX01+H2Up4syc4w8lYLfMUSU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:fb96:b0:279:c5c:136a with SMTP id
 cp22-20020a17090afb9600b002790c5c136amr49428pjb.9.1696444238014; Wed, 04 Oct
 2023 11:30:38 -0700 (PDT)
Date:   Wed, 4 Oct 2023 11:30:36 -0700
In-Reply-To: <20231004174628.2073263-1-paul@xen.org>
Mime-Version: 1.0
References: <20231004174628.2073263-1-paul@xen.org>
Message-ID: <ZR2vTN618U0UgtIA@google.com>
Subject: Re: [PATCH v2] KVM: x86/xen: ignore the VCPU_SSHOTTMR_future flag
From:   Sean Christopherson <seanjc@google.com>
To:     Paul Durrant <paul@xen.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Durrant <pdurrant@amazon.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 04, 2023, Paul Durrant wrote:
> From: Paul Durrant <pdurrant@amazon.com>
> 
> Upstream Xen now ignores this flag [1], since the only guest kernel ever to
> use it was buggy. By ignoring the flag the guest will always get a callback
> if it sets a negative timeout which upstream Xen has determined not to
> cause problems for any guest setting the flag.
> 
> [1] https://xenbits.xen.org/gitweb/?p=xen.git;a=commitdiff;h=19c6cbd909
> 
> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org

If you're going to manually Cc folks, put the Cc's in the changelog proper so that
there's a record of who was Cc'd on the patch.

Or even better, just use scripts/get_maintainers.pl and only manually Cc people
when necessary.
