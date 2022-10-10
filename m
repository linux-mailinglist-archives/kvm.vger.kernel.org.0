Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F725FA8AB
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 01:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiJJXih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 19:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiJJXi3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 19:38:29 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6001A7EFF0
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 16:38:18 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id n7so11700173plp.1
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 16:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x0W6QhXtRh3CHxjVaRdpl3qzyAXx273xSoYzsP2HqV8=;
        b=rV15JOFYurHNf0/oSVGYtnq9m2a4+sBT7zkzJ9xo2HfKzLQaKEKJ06vCz/LANioJwL
         Ix2eb24akT+v8GRizKoOkqqdfkWUBQ9FofL6HvT77tRPdoM+TT6epJaI9EfsV7XwXO17
         qzHjXR8uCJbHqcbI7mbZTVLK4OczI/bTLhqYPUffKCXPkdxaghtj5gQnKZyom2dOrqwA
         aNL6d9dqvPNaZKhShjXVYTpnHjPHuIczROpB5mS/vKgX4AeuGk0mpNhDss6DMuOAWJ0d
         /+a99GXxFPyNCLQg4b4GIfc3Uzm9zwfZZBQf7EQJHI3TSAgUWo0S3tFQ8jKrxnG3nVj1
         MLoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x0W6QhXtRh3CHxjVaRdpl3qzyAXx273xSoYzsP2HqV8=;
        b=hZRLeHsic3az2D9JSpt1RrQ7RmMN2wbcz9Wz38hoK4ZITEr9RqntLSBwq4p33BlqE4
         I4ZimMhe2bXOCOmTseQQk6g98EMuWl151eKUVF+8e9auEUPghTc351dB1m6Xc9ZxWouT
         CK/F1lifPOtjDOyeA57lc4iZ2LLoAuJsF9DGRifhlsJWR17FluHk9U41Bx8BRklJfXpY
         gmhXoakvfZNLcZANz3vhGXDKh3h5YbeFwRA4/VPqgyimArlv0ycA1L45dTJUclvZCRvl
         qTkNADus+THDqRGSYgY7nGHAMbox9ROqAZbSt7WrZdZzzaKsZML55SvsgX2SE47LamWR
         hMGw==
X-Gm-Message-State: ACrzQf24DugHz5X6KvZkx7dIT76F9W4IP5SY7NQi5h0GeadYhbNf6S0c
        v/pkzKYd3QSVH4i/I5NC++g2Ov8XvsvSYg==
X-Google-Smtp-Source: AMsMyM6gmjzPXaWB3fY1uzhn/DibEK1XsXo7AzOm2BQ6ezNquX/5mxiiyuA84B4P09YTgF2nbRdQ1w==
X-Received: by 2002:a17:90a:1617:b0:200:9da5:d0ed with SMTP id n23-20020a17090a161700b002009da5d0edmr22811226pja.90.1665445097793;
        Mon, 10 Oct 2022 16:38:17 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id qe3-20020a17090b4f8300b001f22647cb56sm9660554pjb.27.2022.10.10.16.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 16:38:17 -0700 (PDT)
Date:   Mon, 10 Oct 2022 23:38:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 1/8] KVM: x86: Add initializer for gfn_to_pfn_cache
Message-ID: <Y0Ss5lJGB2LBtb/L@google.com>
References: <YySujDJN2Wm3ivi/@google.com>
 <20220921020140.3240092-1-mhal@rbox.co>
 <20220921020140.3240092-2-mhal@rbox.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921020140.3240092-2-mhal@rbox.co>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022, Michal Luczaj wrote:
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f4519d3689e1..9fd67026d91a 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1241,8 +1241,17 @@ int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
>  void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
>  
>  /**
> - * kvm_gfn_to_pfn_cache_init - prepare a cached kernel mapping and HPA for a
> - *                             given guest physical address.
> + * kvm_gpc_init - initialize gfn_to_pfn_cache.
> + *
> + * @gpc:	   struct gfn_to_pfn_cache object.
> + *
> + * This sets up a gfn_to_pfn_cache by initializing locks.

I think it makes sense to add a blurb calling out that the cache needs to be
zeroed before init, i.e. needs to be zero-allocated.  I'll add it in v2.
