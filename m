Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E885A0356
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 23:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240365AbiHXVmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 17:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239989AbiHXVmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 17:42:38 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B2B56B94
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 14:42:37 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id bf22so18372803pjb.4
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 14:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=W/oESwJzkId5cxxnppc9XY+5L/VWUpzE+eYwaAqRHzw=;
        b=GH7oJIxWo4EAsFG+8U8nSGhpXVHtVkSPGP2N2U9nst6HAY9FPYQom0s3ew5GLJroMa
         IE17iCcQPnZlL/d3Qyarfymu9iHiYNqDvWXMCThFBAdR4NCi0dX/aacpXPyKRZcAXxS+
         xN5vtK8Zwhqdv+zIP0RQn90ep5+/u7SOWxlSvNAJkF4eU1mD0uj6Z9YGayjXQg75y6sL
         XfOaCcfdcisKjlUQUFgDeHRNgJHiTwurUwWCmQEhV0AJBOAu0I13cmIi/R0UpPunv3GO
         IN4PaYVfS8R3UQ6vKPBDBi45JHDHBonyoo82DAPo6ElfQkuLJNrEqTSxkNek34DnDy9O
         G+7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=W/oESwJzkId5cxxnppc9XY+5L/VWUpzE+eYwaAqRHzw=;
        b=64P+pDn7kPmPzhhi/AGRqzJ7cG1oDB3Eq435QpvH0+QhRptgjRxOgZWhVTpL+Je3ay
         2AIQ4iP+XuOUKozyGryvGo3vXer7GrQAYvBK4aa5DCL1M1Ajhg9SA8PCGsFRe9nmLCac
         YwTGC1IhPZDq5XDTm3cxO6pDSsXwq1ZeXjFp1MbjibG3H0VUxQsBijp55ufN98caHf7v
         2eElO5oeZR2bPwMjW/oGEvCudfXZ2sQvPmqsEHGNNGlAk2d1JvOUdLTviFQp16H2uCom
         WtDvyIilIZCk7UhVl8ezL7TEEn8gDyBNu6c2/1fDsvkevCfgU4wFTIsYjN6lPtcfCkfV
         liow==
X-Gm-Message-State: ACgBeo38DczevBptwYYFdLBNKt/UWqfiWp5vM6P7fYSLW1SGDUlLfb/n
        42FI8rZDVXAFgJDevEbBWqOrWQ==
X-Google-Smtp-Source: AA6agR7U4sjkZeB07DLbJ9PlACGy+FuGcSg6E8tD+B61OBO/jpC0iSa14MA9cko6oFxkb5Ys1EVbWg==
X-Received: by 2002:a17:902:eac3:b0:172:ff31:bb3c with SMTP id p3-20020a170902eac300b00172ff31bb3cmr714684pld.48.1661377356815;
        Wed, 24 Aug 2022 14:42:36 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d17-20020a170902f15100b00172ef499c83sm6438330plb.32.2022.08.24.14.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 14:42:36 -0700 (PDT)
Date:   Wed, 24 Aug 2022 21:42:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, yang.zhong@intel.com
Subject: Re: [RFC PATCH 1/2] KVM: x86: Add a new system attribute for dynamic
 XSTATE component
Message-ID: <YwabSPpC1G9J+aRA@google.com>
References: <20220823231402.7839-1-chang.seok.bae@intel.com>
 <20220823231402.7839-2-chang.seok.bae@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823231402.7839-2-chang.seok.bae@intel.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 23, 2022, Chang S. Bae wrote:
> == Background ==
> 
> A set of architecture-specific prctl() options offer to control dynamic
> XSTATE components in VCPUs. Userspace VMMs may interact with the host using
> ARCH_GET_XCOMP_GUEST_PERM and ARCH_REQ_XCOMP_GUEST_PERM.
> 
> However, they are separated from the KVM API. KVM may select features that
> the host supports and advertise them through the KVM_X86_XCOMP_GUEST_SUPP
> attribute.
> 
> == Problem ==
> 
> QEMU [1] queries the features through the KVM API instead of using the x86
> arch_prctl() option. But it still needs to use arch_prctl() to request the
> permission. Then this step may become fragile because it does not guarantee
> to comply with the KVM policy.

But backdooring through KVM doesn't prevent usersepace from walking in through
the front door (arch_prctl()), i.e. this doesn't protect the kernel in any way.
KVM needs to ensure that _KVM_ doesn't screw up and let userspace use features
that KVM doesn't support.  The kernel's restrictions on using features goes on
top, i.e. KVM must behave correctly irrespective of kernel restrictions.

If QEMU wants to assert that it didn't misconfigure itself, it can assert on the
config in any number of ways, e.g. assert that ARCH_GET_XCOMP_GUEST_PERM is a
subset of KVM_X86_XCOMP_GUEST_SUPP at the end of kvm_request_xsave_components().
