Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7D54B5B60
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 21:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiBNUqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 15:46:06 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiBNUps (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 15:45:48 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF67F244C02
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 12:43:45 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id i21so29791779pfd.13
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 12:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1d4G3ltacawLzlsweBJouqYDICtB6/Cf7SnoFyAV6b0=;
        b=ThCgTlzeYkVo8V4+htWP3OIXG6UeFVavSGIK/3BIik8Uz2wVU1rEqaLWRA3Lfz9Z+1
         TXgqdf4BrMZ5UpEI/Ere/mZEu8ZV4/GBYpVYNY/i+Rt+rbKLt8wvKCYZ4MXNv6G6A6Ow
         GJshDzZv8NrBjDBGy7d8VMiFeL/JjHr6viGYOeQxRiWI3Qt4x3jBdTdbOpszYeCO9BMc
         0OCxt/klexnVqQAG4DL6yDyNjDzAIzBiBO0WWHh1u6iZyqrKE2/0R76HugNf8iGWQjsN
         LB680ik500n7ko1Drqv+apJQ6Pd9kon4cuHgIY7EtNm6BVtkGqv/gIUQzIf19VZ0mrEP
         o7Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1d4G3ltacawLzlsweBJouqYDICtB6/Cf7SnoFyAV6b0=;
        b=3yIiTKsHENifpT68JJupSEPTse5EdQvi8kLUVpKy2+hWxD/ZDczB9mi7hcMlmoWl12
         EJIdWpDIM9qn0+y7pzeUJj885aovuA18zoB06aIl1hkTV/isnswF0niY/XcSJKMA0wt7
         ouHBCRpqUYu2HERqyd/XKBs8yaeKN354GxowB2zXC6GpsBbUamfcTGHxonN7+U/T+NVH
         kZ+PTl9BdC3vnjNfCob+R2cV0GprdhrfFGN6rUYLBX75U7D1InyQeN4FifsY3F/Cp+Fb
         6NAi3h0qymR4pkia7AwgJGyX4CmuH/8pUZMnfDXBxpsOcls6cCXy4jynVaMGxX8r5/4+
         aCyQ==
X-Gm-Message-State: AOAM5308ho+7byyuWHHzAPVQ1o+cqFO/FZdlD+tj2nKVABLay8lz+tYo
        5P8nKdQgNLAKB3unDD08H1IB+59HcrIMwQ==
X-Google-Smtp-Source: ABdhPJyqMv5AoXUSZYH/3diz6Ivnv8bZlX4Xh7iBZPxGExucJBTW36MNBhspp1/3yYbfp4QnvfEJ3g==
X-Received: by 2002:a17:903:2309:: with SMTP id d9mr549600plh.74.1644869222243;
        Mon, 14 Feb 2022 12:07:02 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mg24sm14494069pjb.4.2022.02.14.12.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 12:07:01 -0800 (PST)
Date:   Mon, 14 Feb 2022 20:06:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Dunn <daviddunn@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, like.xu.linux@gmail.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 2/3] KVM: selftests: Allow creation of selftest VM
 without vcpus
Message-ID: <Ygq2YWwS5XcDGD2j@google.com>
References: <20220209172945.1495014-1-daviddunn@google.com>
 <20220209172945.1495014-3-daviddunn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209172945.1495014-3-daviddunn@google.com>
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

Shortlog and new function name are a bit confusing.  The framework already supports
creating VMs without vCPUs, what it doesn't provide is a helper to load the guest
code and do the other "default" stuff.

That said, the framework is such an absolute mess that I'm fine going with
vm_create_without_vcpus() for now, carving out a more appropriate name will be an
exercise in futility without a large-scale renaming and refactoring of the other
crud.

So just a different shortlog I supposed, though even that seems doomed to be
contradictory.  Maybe something like this?

  KVM: selftests: Carve out helper to create "default" VM without vCPUs

Default in quotes because the selftests already have a goofy interpretation of
"default".

On Wed, Feb 09, 2022, David Dunn wrote:
> Break out portion of vm_create_with_vcpus so that selftests can modify
> the VM prior to creating vcpus.
> 
> Signed-off-by: David Dunn <daviddunn@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  3 ++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 35 +++++++++++++++----
>  2 files changed, 32 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 4ed6aa049a91..2bdf96f520aa 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -336,6 +336,9 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
>  				    uint32_t num_percpu_pages, void *guest_code,
>  				    uint32_t vcpuids[]);
>  
> +/* First phase of vm_create_with_vcpus, allows customization before vcpu add */

Eh, drop the comment, the association is obvious from the code, and it's just one
more thing that needs to be updated when this stuff finally gets cleaned up.

> +struct kvm_vm *vm_create_without_vcpus(enum vm_guest_mode mode, uint64_t pages);
> +
>  /*
>   * Adds a vCPU with reasonable defaults (e.g. a stack)
>   *
