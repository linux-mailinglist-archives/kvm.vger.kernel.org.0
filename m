Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A34B69896F
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 01:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjBPAow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 19:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjBPAov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 19:44:51 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7FE43452
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 16:44:50 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id e9-20020a62ee09000000b0058db55a8d7aso310051pfi.21
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 16:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZM7ju0VjQF3J50sLLcomSfTcS7CeBYR38K6pjJsaLjo=;
        b=T8RUVh8+VlHbJP9GsXCKVf1vGnw4nf8t1ZNa75jmJHr5wRtCdDM0yhlxX1wJ5VSv++
         11xSSwqJhcOuJi9bvr48dUgTH74JhkxVgEY94vr29Ac/nnl3IbvDRAWmf/vJy35shxnz
         C2r19DLqFTBR456IVao/gTSBzBMIi2/lUEyJgShq7PYL7kdwUmrgm0jQMswESIwoz5YK
         0ZcsVW6F7/MlV7DqM2pM9XSP+PIZ9985s1cPDEYHLQAoGyxW0eauxd2hYPlkAtt3I8nP
         4LfOfQsTwL0WkN6cu4l/rMG4PcLEV2fn53xL3CYleqzHI991SvziFVgrZJiG0ybHRhAb
         8c2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZM7ju0VjQF3J50sLLcomSfTcS7CeBYR38K6pjJsaLjo=;
        b=1pw3qHMTvSLuImHqhmPltH8LnLLA//6SNbsuhCBJGzgObnxKUMyz3B33Jrv9BQJaQ9
         W9XVlBQrdi9OcZMIgAzO0DJDmLgukUBggBcLjwIA3yZbV9AZirh1I9nfH4o+U9oMj40u
         CQ3CTibEV8Xnp1pK53SvXqJHQaJUeuRqW8Dw4C3Fqz6gtm80w7wSXiULlm+yuSth56t0
         An212rHHtImUd9kHf7JcTr+T+hQjlN5vElpILI7SfQzDjkTXnxnv4X/9dd7ryD/Wm4G4
         HLuXV5OT9v2La0xUiBWrxKmueLtJ5ooiwV96vT9vvy9DD1o1BdTI65AQwyzAQL3/EWiD
         DBnw==
X-Gm-Message-State: AO0yUKU/+3qSdI2rL6zOn7oSzLrPA0VxG+mv2XI+mkMVtFa8TQgLm8QU
        IR6hL0Yt7dpnS6fp06S0GJoeTqPwAHc=
X-Google-Smtp-Source: AK7set98QXC0zu/QHL8Wb7z8yoQQQX/TS7mY6Tx5/VWS+odlknQ4qKiL2IEirrFoh8BeaPGqq2VxwAxG1Kc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3d8c:0:b0:4fb:3790:120 with SMTP id
 k134-20020a633d8c000000b004fb37900120mr639100pga.6.1676508289356; Wed, 15 Feb
 2023 16:44:49 -0800 (PST)
Date:   Wed, 15 Feb 2023 16:44:47 -0800
In-Reply-To: <20230213212844.3062733-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20230213212844.3062733-1-dmatlack@google.com>
Message-ID: <Y+18f7go7J98XbzR@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Make @tdp_mmu_allowed static
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        kernel test robot <lkp@intel.com>
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

On Mon, Feb 13, 2023, David Matlack wrote:
> Make @tdp_mmu_allowed static since it is only ever used within

Doesn't "@" usually refer to function parameters?

> arch/x86/kvm/mmu/mmu.c.
> 
> Link: https://lore.kernel.org/kvm/202302072055.odjDVd5V-lkp@intel.com/
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Fixes: 3af15ff47c4d ("KVM: x86/mmu: Change tdp_mmu to a read-only parameter")
Reviewed-by: Sean Christopherson <seanjc@google.com>

Paolo, want to grab this one directly for 6.3?
