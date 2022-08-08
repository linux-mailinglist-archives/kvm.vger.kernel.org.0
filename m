Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFCA58CF4F
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 22:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244140AbiHHUpR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 16:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238453AbiHHUpN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 16:45:13 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939CC2F2;
        Mon,  8 Aug 2022 13:45:12 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y141so9072574pfb.7;
        Mon, 08 Aug 2022 13:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KepD7Q0J8euFo9zGKpR9SOM/n17ClxLuzrWQpYIlsQo=;
        b=pMnmdqUHALnzoNIhHE2RfZGfHxFb+pS8a/Czg868vZmp/wBPqGvjCTco4x5W29+2xN
         8z7fu9X9irkQ+fqKNVAbPgC7D7pT1P/G9RZ7k2w9CpgFROkRI8TjD8m+WkKFm3YfURYH
         Fmf4I4nScwM0hAj5+zZX5nYFc+KFaYDJ5JjBVZOzUWhlorw2gbXmJrvEBn2dmtC7MkeW
         Kx/7Ug9a8zQOAcJ3yUdjM1+QOAIOIU6m0W60gLHryrxB0Ptb5uGlPJmwdxrcYDGR7K9d
         HbJad/w7t2uV0rhX9ZtoHL6gWMtmqdEj/Qp3P/jPzh6udlCiu+/U5YJGsPJ95EyVUiX4
         GAzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KepD7Q0J8euFo9zGKpR9SOM/n17ClxLuzrWQpYIlsQo=;
        b=P2buZ5eVqr211zVwlQGkqp8PlcfXz3G0jylnW9Hv0lgT9GPJ0Qiad0HBiKOL+D68An
         D5RgZNjX8hSmfErS3PMaykuepU9IlM1iIAvw+MIZu/Sf6Rg2m8TVAawODD3tuM6Yyz+T
         2YAlbQYquj0gngbotmSvvMxxR6bGU5cnbjJfynDPIyD1JGyIFVKxrRVmoIiGyJ6pr1E2
         d6byrD0XqL4MZOhaP/GhWEr2E8M68WoGSyVQDp8bZCZR5NDm+tYU+F5kKWzBsp5+Pq7t
         ZSrd4aE97yWYGViyfkvI6mOkBy5b06gwERA2P3rzqPrTnv1Jbmt5kwpZYTz+c/+yCb7V
         vr4g==
X-Gm-Message-State: ACgBeo0yP3mnTAfRDwFvVQANDviRRg3ZHpbsf6jvJNLrFJmCRbh9V7OH
        t7Lx111iDroehDiL5hge3df68Ge8MtU=
X-Google-Smtp-Source: AA6agR48fTEgwEAw+Ewm1dyRZpbkIEhdsr6Zl6orcnUSDPY2m8reBDv4DRu3D1NecbIHacOwopZaiw==
X-Received: by 2002:a17:902:d50a:b0:16e:e1c1:dfa7 with SMTP id b10-20020a170902d50a00b0016ee1c1dfa7mr19932407plg.160.1659991501052;
        Mon, 08 Aug 2022 13:45:01 -0700 (PDT)
Received: from localhost ([192.55.54.49])
        by smtp.gmail.com with ESMTPSA id q10-20020aa7960a000000b0051be585ab1dsm8968980pfg.200.2022.08.08.13.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 13:45:00 -0700 (PDT)
Date:   Mon, 8 Aug 2022 13:44:58 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v8 000/103] KVM TDX basic feature support
Message-ID: <20220808204458.GA504743@ls.amr.corp.intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <YvCHRuq8B69UMSuq@debian.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YvCHRuq8B69UMSuq@debian.me>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 08, 2022 at 10:47:18AM +0700,
Bagas Sanjaya <bagasdotme@gmail.com> wrote:

> On Sun, Aug 07, 2022 at 03:00:45PM -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > KVM TDX basic feature support
> > 
> > Hello.  This is v8 the patch series vof KVM TDX support.
> > This is based on v5.19-rc8 + kvm/queue branch + TDX HOST patch series.
> > The tree can be found at https://github.com/intel/tdx/tree/kvm-upstream
> > How to run/test: It's describe at https://github.com/intel/tdx/wiki/TDX-KVM
> > 
> > Major changes from v7:
> > - Use xarray to track whether GFN is private or shared. Drop SPTE_SHARED_MASK.
> >   The complex state machine with SPTE_SHARED_MASK was ditched.
> > - Large page support is implemented. But will be posted as independent RFC patch.
> > - fd-based private page v7 is integrated. This is mostly same to Chao's patches.
> >   It's in github.
> > 
> > Thanks,
> > Isaku Yamahata
> > 
> 
> Hi, thanks for the series.
> 
> When building htmldocs, I found new warnings:
> 
> Documentation/x86/tdx.rst:69: WARNING: Unexpected indentation.
> Documentation/x86/tdx.rst:70: WARNING: Block quote ends without a blank line; unexpected unindent.
> Documentation/virt/kvm/tdx-tdp-mmu.rst: WARNING: document isn't included in any toctree
> 
> I have applied the fixup (also with line blocks to code blocks conversion):

Thanks. I'll apply them.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
