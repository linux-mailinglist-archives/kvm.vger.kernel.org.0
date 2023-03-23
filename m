Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8C06C72A7
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 22:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbjCWV7H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 17:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjCWV7F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 17:59:05 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF17E18AB1
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 14:59:04 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id p9-20020a170902e74900b001a1c7b2e7afso113598plf.0
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 14:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679608744;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NQELBOKyx381WNpEG3OjtoIBL9QlyTey0Kc97InrJs4=;
        b=kdSd4ZQQhrmc9Zcu1CqGGrdPcA9QdaBgvk4eew5zKZbwvsb71amUA1bVv+JaofnEXj
         yZvwWfxz3tjK9gTTWkf9yTCCBFuz8KvsRxC4bircqnER0p+24p9JAfCd3phhMVvC81gZ
         zl40dZJ9v6T1HnhmMBAiRwyxv2D1oVGc0WIYMT1Sojyqv3YFowgpvwv/xFd3EgmrP/im
         xiIWgXJqWVzYT/12VZZC7XK1YjIwrzHA8Jhu22AoAOHeIdgYQfHnoweKbd8+pULJlaII
         DoSXBu0MNE15Lz+y9rO5eXsBhSI+kSrbofsOKps++BmwEBRWIOVDBID1C0Bvizx1mDaE
         5D1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679608744;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NQELBOKyx381WNpEG3OjtoIBL9QlyTey0Kc97InrJs4=;
        b=6aTnjA3vF1OTg4CyRCLiytX7k3kbgsLtPKgsrVni85JDtBvSZnZ2FM0ucV7w3xNxPP
         9mf1GRdGN4CAYWfOWs6bzsjaxIxxyF3Sfogtmpor1vs3jqUJIruDZWTMLX3ROHet0ctY
         M+QrapVHRCM8fzYgDv2xwhE7qWWKfUMDgw/eU2FLfY46ccvRpupHDim28QuVMrS3bNMb
         vXovMjJTKoQ+Dih/GWC2qcD3Lq9GEw06QAW1h0K+iSEOaXc+7P4Kie6h/+7lzvbuspvM
         Cd3LWjmgf/tYGaUWAnR0Vua72lz6c+98yN5DbAggBM0CFl1HHxZnqHNsFCSoV1YrB83J
         VvsA==
X-Gm-Message-State: AO0yUKWqWkGKse1hqw/Zw5HJh5189N5HyRvAom1GrqYrnFqhRML03rg2
        ntenFtZftFqp7mJdbZWENIy3qemeYIs=
X-Google-Smtp-Source: AKy350YHyyZJQdvlnoEBlChbiJUXRWBuvV1hFtauYD2vhCujfIsM783nezMTwLA8MqHHuhI9q+EGrF0FvC8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:848:b0:626:2343:76b0 with SMTP id
 q8-20020a056a00084800b00626234376b0mr543808pfk.6.1679608744415; Thu, 23 Mar
 2023 14:59:04 -0700 (PDT)
Date:   Thu, 23 Mar 2023 14:59:02 -0700
In-Reply-To: <20230301053425.3880773-6-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230301053425.3880773-1-aaronlewis@google.com> <20230301053425.3880773-6-aaronlewis@google.com>
Message-ID: <ZBzLpk/FXjhTJssQ@google.com>
Subject: Re: [PATCH 5/8] KVM: selftests: Add vsprintf() to KVM selftests
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
> Add string formatting support to the guest by adding a local version
> of vsprintf with no dependencies on LIBC.

Heh, this confused me for a second.  Just squash this with the previous patch,
copying an entire file only to yank parts out is unnecessary and confusing.

> There were some minor fix-ups needed to get it compiling in selftests:
>  - isdigit() was added as a local helper.
>  - boot.h was switch for test_util.h.
>  - printf and sprintf were removed.  Support for printing will go
>    through the ucall framework.

As usual, just state what the patch does, not what you did in the past.

>  #endif /* SELFTEST_KVM_TEST_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/lib/printf.c b/tools/testing/selftests/kvm/lib/printf.c
> index 1237beeb9540..d356e55cbc28 100644
> --- a/tools/testing/selftests/kvm/lib/printf.c
> +++ b/tools/testing/selftests/kvm/lib/printf.c
> @@ -13,7 +13,12 @@
>   *
>   */
>  
> -#include "boot.h"
> +#include "test_util.h"
> +
> +int isdigit(int ch)

static?

> +{
> +	return (ch >= '0') && (ch <= '9');
> +}
