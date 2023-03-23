Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 511B06C72B8
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 23:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjCWWE2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 18:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjCWWE1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 18:04:27 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB7D113C3
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:04:26 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54161af1984so132227b3.3
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679609066;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sz8U7qtqg553l7KNIrQROp8Ef+jlVOKn+hX4Je0MwE0=;
        b=a5xnrQUtJS4sf+Ukm7HpvsDZCBjig5LGgG1Cfmr3b8rfXd/VUaU9Z3GnBissIM53sm
         CuX/SYLako4roX5t4v26ivJ5SmrhJxCIejW9nTHRcG6VvNdfHjEiyQtiuY2uijZuuljq
         X2jOlMJdAgfck4FplE0m0V9e+r12QQ0lgWBr0KBQbeRrZMUCNI17KSJVEb/ZsEECrEpO
         /EmPLqspSEZTyAKiDYXDq3CFmiPOEnGrS/W4pzfsVFdeVo1ECzqgQWBr4TBd96FlQ644
         hkIZKYY5X/T02RkU61BbYQDlAHbEF1HgUOfNkxHyXOJPXeh3xTq/rfiozqc1tIpw9HtL
         vtFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679609066;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sz8U7qtqg553l7KNIrQROp8Ef+jlVOKn+hX4Je0MwE0=;
        b=OcWDLZ7wfVwGYXWiL/r8l7CCg+VcgQQwzd2wJlihksZvAM4AiBGO6ALqlMHhdz9I4J
         h1wqq5lROof2za/d97g6k/KbJWsRYJYHnDNoiuChPy0BSkiENjX2+PflRYrtfoZ5jUT8
         L99pkO8HmWjSoQFibx+PAbbHtXJwcZhyId+480d733516OgpbLKUet9TqxK0fszZY8fS
         LCdbkuJupQ+zNIKyFs4uzuxNQdFX6Bjw2xQUjBezNcqfJ26KbnH+I0BrE7nqwhEZH4o5
         g/lAbEIa7kVOl6eDOTlD3PaRUifmXwT7WRcJWBpFDe7rEoKjYwcvJCLsovXIXmcUSOoE
         SYhg==
X-Gm-Message-State: AAQBX9fV86xKh09LblvJySfWwDIFBXTTTw44+1hwVpX4f3QH/2FlIMK5
        40tjuYUAdCJnXfIHUlL/EPyYRcX/1N4=
X-Google-Smtp-Source: AKy350boe+qlrUJa5DYJVDyayl92ZB0NouFwJ9CnV37JqFDMhraiqlpRqE1hcIoUuVpvOXJi6r60HY94vRg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c750:0:b0:b45:e545:7c50 with SMTP id
 w77-20020a25c750000000b00b45e5457c50mr2686281ybe.0.1679609066052; Thu, 23 Mar
 2023 15:04:26 -0700 (PDT)
Date:   Thu, 23 Mar 2023 15:04:24 -0700
In-Reply-To: <20230301053425.3880773-5-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230301053425.3880773-1-aaronlewis@google.com> <20230301053425.3880773-5-aaronlewis@google.com>
Message-ID: <ZBzM6M/Bm69KIGQQ@google.com>
Subject: Re: [PATCH 4/8] KVM: selftests: Copy printf.c to KVM selftests
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
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

On Wed, Mar 01, 2023, Aaron Lewis wrote:
> Add a local version of vsprintf() for the guest to use.
> 
> The file printf.c was lifted from arch/x86/boot/printf.c.

Is there by any shance a version of 
> +/*
> + * Oh, it's a waste of space, but oh-so-yummy for debugging.  This
> + * version of printf() does not include 64-bit support.  "Live with

But selftests are 64-bit only, at least on x86.

> +static char *number(char *str, long num, int base, int size, int precision,
> +		    int type)

Do we actually need a custom number()?  I.e. can we sub in a libc equivalent?
That would reduce the craziness of this file by more than a few degrees.
