Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 636A87C455D
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 01:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjJJXRM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 19:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjJJXRL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 19:17:11 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23E299
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 16:17:08 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-32615eaa312so5671852f8f.2
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 16:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696979827; x=1697584627; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EIjKveupCC73cR3+NCpTtLF6c9Fas/4Eu5RGdKgMqzY=;
        b=JzQx5rCApRv+wQZZPWysKmuSViQTDu9uBmhUgKihFQajUQceDF6M98YVucfoUfsPJn
         yh0hrNAFbt0tm4Rm9hSLQHo7rosd60NFV2YD14VXSIwntRdEj2Om6NsBmwGMaTd8OEk5
         5DYYcX0TpE076kjTesF4sHkl2sRqrifEyK4Rrgcw0k1mq/ePkaIqJmB9uC/Ts1Rz5E/v
         Um0aLWqV5YIfoMh7t8Q1WRmugT5yCRelqo4DPIXeYpkHkpD2Wxj5dnGswbzy72mpCUPc
         yBMatjZqFqnFjcccXkXSviYQ9cjNUr3tCWS+8QBL6/cjQERYFEXw6KKy267Jd7ssrZf0
         WZ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696979827; x=1697584627;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EIjKveupCC73cR3+NCpTtLF6c9Fas/4Eu5RGdKgMqzY=;
        b=HVFHA5zgx+PreDWAr9YrbRlOP7VwGR/fflbH6IkkhMjiUPpxbwhXm/fn7cd71TWWX7
         18s5kHQRz6/U/LtbuRNoqTPdJEy0PVFvuV0Pa3fsYO0ySj4eqoD3PgqXx5HR7eRVW1mg
         L84iu85v9seYPn/SYGnc2oLXYBcCQN30dbE7ospvlBqoCXNdljaP+7wv6+wcRbBLnXWF
         plEDmB7aAlKSWMyVmK3VXmoUKvVVWnFetWv80TeCH9w/h0BDC+h8tr1w+IMwdoT/krXL
         OdiO27uiItgW/6cVQWi62wMF+cySbVlUtxWyXLvhMr9h58w3Rs/1tqDJ2b6iEVE56cgP
         MjfQ==
X-Gm-Message-State: AOJu0YwTHNHGW5YzaJ3870gCjDiWLoqyesjmzIsnASGlytB8j2vO3xeb
        jV87eTTHjQaNG6NTvhpQQhCFCXZS5Pkv9sihSCrGZA==
X-Google-Smtp-Source: AGHT+IHjix4DDviN0OKHAnA6wMPqxVL734sjSysWmwhkzJGmcQobD9amuMZACosgKD0dy8qkGg+a8jYHMlBO/2KAZjE=
X-Received: by 2002:a5d:5a06:0:b0:32d:23b7:49af with SMTP id
 bq6-20020a5d5a06000000b0032d23b749afmr3115151wrb.36.1696979827335; Tue, 10
 Oct 2023 16:17:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-10-amoorthy@google.com>
In-Reply-To: <20230908222905.1321305-10-amoorthy@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 10 Oct 2023 16:16:40 -0700
Message-ID: <CALzav=f8YDdqxVXNRASNWxuM2WzgBwj=hErj1Yc5da552ecG5Q@mail.gmail.com>
Subject: Re: [PATCH v5 09/17] KVM: Introduce KVM_CAP_USERFAULT_ON_MISSING
 without implementation
To:     Anish Moorthy <amoorthy@google.com>
Cc:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        nadav.amit@gmail.com, isaku.yamahata@gmail.com,
        kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Fri, Sep 8, 2023 at 3:30=E2=80=AFPM Anish Moorthy <amoorthy@google.com> =
wrote:
>
> Add documentation, memslot flags, useful helper functions, and the
> definition of the capability. Implementation is provided in a subsequent
> commit.
>
> Memory fault exits on absent mappings are particularly useful for
> userfaultfd-based postcopy live migration, where contention within uffd
> can lead to slowness When many vCPUs fault on a single uffd/vma.
> Bypassing the uffd entirely by returning information directly to the
> vCPU via an exit avoids contention and can greatly improves the fault
> rate.
>
> Suggested-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 28 +++++++++++++++++++++++++---
>  include/linux/kvm_host.h       |  9 +++++++++
>  include/uapi/linux/kvm.h       |  2 ++
>  tools/include/uapi/linux/kvm.h |  1 +
>  virt/kvm/Kconfig               |  3 +++
>  virt/kvm/kvm_main.c            |  5 +++++
>  6 files changed, 45 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index 92fd3faa6bab..c2eaacb6dc63 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1312,6 +1312,7 @@ yet and must be cleared on entry.
>    /* for kvm_userspace_memory_region::flags */
>    #define KVM_MEM_LOG_DIRTY_PAGES      (1UL << 0)
>    #define KVM_MEM_READONLY     (1UL << 1)
> +  #define KVM_MEM_USERFAULT_ON_MISSING  (1UL << 2)

Bike Shedding! Maybe KVM_MEM_EXIT_ON_MISSING? "Exiting" has concrete
meaning in the KVM UAPI whereas "userfault" doesn't and could suggest
going through userfaultfd, which is the opposite of what this
capability is doing.
