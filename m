Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD566E67B7
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 17:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjDRPEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 11:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbjDRPD6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 11:03:58 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F5097
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 08:03:55 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v200-20020a252fd1000000b00b8f548a72bbso13874441ybv.9
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 08:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681830235; x=1684422235;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Qad5maOJ0rw9gu7mdUjv1+42NXRe2LlNaVdY4yQn7E=;
        b=o756dZ5lG6yGQSHizfNDkP1PUhUfClczrMYjsuX+qytyQfw/Wn5qTU0MAbiHLLsZZz
         9j0USew+RvaU0CQM2PV5tkAsVLlo+NzUAmWMRFa1N3Li2QmaEb07DExDYtqb7sqJYBU9
         weRY/eSOKZ4PLdcZ6n/kYHUs/06AHHKgwrIhmI10snpvu06FA+A4vrvnrsny7Nd0huo3
         KBW8rosR3fvSurNP2VB1YN/RZLlsF0tSms1CVi70EqIUNYNo8cetebVWAnyDiradiPlY
         IeC25xccSeEYJ6t75UruWVKIlfpbpBIKfPsM07cK4jt9Hqqu6aj95tnELmJGbTEfi5dj
         yrnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681830235; x=1684422235;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Qad5maOJ0rw9gu7mdUjv1+42NXRe2LlNaVdY4yQn7E=;
        b=OoeHtHLgaHwE90gCHWX1MfpbO9lbGsl1hSu7tkVO4Z/zuNTWgZve7jLkbGJd4e+J59
         hjwpShAoM0vbbCfPxYIMIlEDPphn5RnIepNOs1xxg5e0H2tZ1t7kSSwToWhKP+GToKj+
         xj6aMwPgwEgL45+vDSdVVvE78K+bowS09yrjw5SzvO/yNjKdVWYudS7aK1j4nV+OpeGm
         frJWWWgenKHLnQW6tgipFI8EMG6mMtaYRrAb0aw6oPTnQnZ6fdQbSYUDhOdfKwAQd/jv
         JflIGdYXUzfI8MDslGTX8e0cRPwfP/AOoNGf+RJ/9lQDuou61o3rPxd8fCl/dMm+lSiO
         I7+w==
X-Gm-Message-State: AAQBX9fo/zOoEp83xkC3RXSpL2k0XwXymcGGk4rGz1/VG6qkyp5iqKGa
        DmeUCb4me65ANvH4/GeTCqlMnxY9nIo=
X-Google-Smtp-Source: AKy350Z0uZSIUfrUL0wx4Vkhx/vtFvP0FTLD0S6ZuC0WmcPqiWjJrmO+94S1E5JK0z1ebS8fBspJgEXcH24=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:bc12:0:b0:54f:b56a:cd0f with SMTP id
 a18-20020a81bc12000000b0054fb56acd0fmr92552ywi.3.1681830234941; Tue, 18 Apr
 2023 08:03:54 -0700 (PDT)
Date:   Tue, 18 Apr 2023 08:03:53 -0700
In-Reply-To: <ZD1sx+G2oWchaleW@google.com>
Mime-Version: 1.0
References: <20230301053425.3880773-1-aaronlewis@google.com>
 <20230301053425.3880773-5-aaronlewis@google.com> <ZBzM6M/Bm69KIGQQ@google.com>
 <ZD1sx+G2oWchaleW@google.com>
Message-ID: <ZD6xWYI7Uin01fA7@google.com>
Subject: Re: [PATCH 4/8] KVM: selftests: Copy printf.c to KVM selftests
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
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

On Mon, Apr 17, 2023, Aaron Lewis wrote:
> On Thu, Mar 23, 2023, Sean Christopherson wrote:
> > > +static char *number(char *str, long num, int base, int size, int precision,
> > > +		    int type)
> > 
> > Do we actually need a custom number()?  I.e. can we sub in a libc equivalent?
> > That would reduce the craziness of this file by more than a few degrees.
> 
> Yeah, I think we need it.  One of the biggest problems I'm trying to avoid
> here is the use of LIBC in a guest.  Using it always seems to end poorly
> because guests generally don't set up AVX-512 or a TLS segmet, nor should
> they have to.  Calling into LIBC seems to require both of them too often,
> so it seems like it's better to just avoid it.

True, we'd probably end up in a world of hurt.

I was going to suggest copy+pasting from a different source, e.g. musl, in the
hopes of reducing the crazy by a degree, but after looking at the musl source,
that's a terrible idea :-)

And copying from the kernel has the advantage of keeping any bugs/quirks that
users may be expecting and/or relying on.
