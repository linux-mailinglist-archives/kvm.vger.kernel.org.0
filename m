Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185B674A417
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 21:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbjGFTEs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 15:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbjGFTEq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 15:04:46 -0400
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436B11AE
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 12:04:45 -0700 (PDT)
Received: by mail-vk1-xa2e.google.com with SMTP id 71dfb90a1353d-47e3026ca12so353951e0c.3
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 12:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688670284; x=1691262284;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ejQxY0gWH3zIY/UVUkHiDbx8Hs4+1qvPA8odOTbAhUs=;
        b=7XZ7FazyxzXXGNwmDQ66lbyJBkc7F7mTRjSFc4ql0j0u4dofBp4+Knh44SKAdeQK+O
         HE4YEWzI+XUsCL0lymnfhsm8WC9LOF38rldSlHwAHh8H2WlCPcV3uqJf505L30Vzk3AS
         BzwsCmodLH2V2pNq3y7y5elIWWWd1EpLyOxOGaWvSjmmKUMfpuXCoCquCy0jh5DInA5O
         8ct2eaxAR4WE9e5LmGST0io7yUaQrSn696n8KRnA7DU/WvjopJC1NvjrJL++O5VsqlQR
         ag7xZUUkQ7gPT062iaU07dlVrqmZgAvDDxqBjEATJgae55R/txRC1HvjJqZVG8yyZCfE
         IWlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688670284; x=1691262284;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ejQxY0gWH3zIY/UVUkHiDbx8Hs4+1qvPA8odOTbAhUs=;
        b=WTJQ0F4g7DAg5tweb8kUC6eFIssBYBu/i/o5wJxIOlQ8WrdKw3N9VgH5BOCbhr8c4x
         I8+xXdoFsKIlZUy4WTtVkxhGHlD7VDG/joi8YtNq2E+j5T+jpkqg5ABRaijstnXmhvWS
         Rb4VCyJbYO/vHTkOtcPG/ifED6t6Evmc7XYWcYexBNEimkyC7bjaTZKOqdpqpJqW4kPM
         keTTjZsRV4vdvSm+q1/+Hpqn9/3ul9R+hfIDm/Gx92lgxtUBVwdux+VyXzStX56LXdpx
         BcfHE7ZgLG9lZWDoGBSnFAsDJI6gkrc0L8ZgNnVumoAH/RicgufpB03YPV5gJLou/+NY
         pryQ==
X-Gm-Message-State: ABy/qLZGEz0UwmtHNSyTI9cU9NDeLylXYgmLD//dkRayl+J/zv7yXCeb
        bDekfBQRngYww0RQfhWzzIU4Zg68YyeCRzxKVfF/wg==
X-Google-Smtp-Source: APBJJlE1uw1F7+lvu3Gx3wT/tlHa7wgJQDuaTcAPq6lhudst+4AdTOHOlOjHF4NxQYpl1/xX4JloeueaBAkjNe8iwLQ=
X-Received: by 2002:a1f:3d11:0:b0:471:875d:598e with SMTP id
 k17-20020a1f3d11000000b00471875d598emr1867792vka.14.1688670284274; Thu, 06
 Jul 2023 12:04:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-10-amoorthy@google.com>
 <ZIoe3o7JtultNWqR@google.com>
In-Reply-To: <ZIoe3o7JtultNWqR@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Thu, 6 Jul 2023 12:04:08 -0700
Message-ID: <CAF7b7mprEauG_P5KL3_-N3Bu58h0gdp3ZXSEU0EKyLmO+4N5xw@mail.gmail.com>
Subject: Re: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without implementation
To:     Sean Christopherson <seanjc@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
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

> Rather than force architectures to add the extension, probably better to use a
>
>         config HAVE_KVM_NOWAIT_ON_FAULT
>                bool
>
> and select that from arch Kconfigs.  That way the enumeration can be done in
> common code, and then this can be computed at compile time doesn't need to do a
> rather weird invocation of kvm_dev_ioctl() with KVM_CHECK_EXTENSION.

Done. If I'm reading this correctly you also want me to move the logic
for checking the cap out of the arch-specific
kvm_vm_ioctl_check_extension() and into
kvm_vm_ioctl_check_extension_generic(), which I've done too.
