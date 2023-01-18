Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9526727BF
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 20:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjARTCr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 14:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbjARTCP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 14:02:15 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14085D907
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 11:01:29 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id jl3so2790754plb.8
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 11:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QtExxK4ADgw6ZE718YwmO/t71md0krpwXYndr6NxVnU=;
        b=M3aQFUP1lcJH0765ybpm4yrsrb4oQT9zJO/GI1m1G9KLxaYRSw5DrgLL3kBPHZQ3Hi
         W1r9lxyHx8noTxW8/7YLzhOcLjkAOq6lQYKn0M3ZWz9O4sbofS/SY0Rnx+LS8crO+fol
         oOT5EQ66gFg/lCxy6nAceOpEdypLi5t5EGkaMrnTkL5HfY1vkGsrcrnFT7XtAnj/OBvK
         kNtJfLtMrQ9AkMBUjldpKcOJzfVqV6y3AK+rvRq8wPTKUnqdbMd9zS8MyHZxgDFSLK+H
         YY/9Z0PRsbOap4FVqNdA2/XQFtyvj93rnTWGGEeVudLJKP/EJCXxMXA/Aoz2zEZJaxzO
         OYkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QtExxK4ADgw6ZE718YwmO/t71md0krpwXYndr6NxVnU=;
        b=A1ibsu3Jq4lfb3Mn2wz60P7IGj1q40KI91gC+Vpc4PooKcAlu1PYSAbYbVZjJqJfLQ
         6XVzPUskWMqrNHbWn1eP9duUmzdnoMh7PjncY2Wbs2YoaNXzFNuV5k42SiwUxp7V5dj5
         pKkGELxfuYOEgT4BloQ0dQdhu43lNKFRhriYcy0cQazlqwWQhWyduyFBS04TwjDJV3Mp
         L0rViKitev+IUUC7KYKBAuavs7tM8NOe6YZb0sieOysxke/yYiXF+WK255nCByo5n0I+
         5glIKWAO17oXJEjvdazy06lUYB6Rn6Y/IEyCLozoQEG+CQZpghgJsS8C+b6iYi8LbX4E
         uZkQ==
X-Gm-Message-State: AFqh2kp/Ig6tBiTPqFMeZKA+qhr9fckzhNCq/dXilC+DT290ONnKfzYu
        iz7nTohjSVVTcYyAbmrwDMjk4w==
X-Google-Smtp-Source: AMrXdXsGwGNSb93sj72HwHJ/6wD+/hvMFaY7dl3Lb88Tl3bA0ZlUfIhwcC3Rw9YHYADmS+BT3FZK9g==
X-Received: by 2002:a17:902:ebc6:b0:192:8a1e:9bc7 with SMTP id p6-20020a170902ebc600b001928a1e9bc7mr3530092plg.0.1674068489027;
        Wed, 18 Jan 2023 11:01:29 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e3-20020a17090301c300b00172cb8b97a8sm9725897plh.5.2023.01.18.11.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 11:01:28 -0800 (PST)
Date:   Wed, 18 Jan 2023 19:01:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ackerley Tng <ackerleytng@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        David Matlack <dmatlack@google.com>,
        Wei Wang <wei.w.wang@intel.com>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: selftests: Reuse kvm_setup_gdt in
 vcpu_init_descriptor_tables
Message-ID: <Y8hCBOndYMD9zsDL@google.com>
References: <20230114161557.499685-1-ackerleytng@google.com>
 <20230114161557.499685-3-ackerleytng@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230114161557.499685-3-ackerleytng@google.com>
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

On Sat, Jan 14, 2023, Ackerley Tng wrote:
> Refactor vcpu_init_descriptor_tables to use kvm_setup_gdt
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  tools/testing/selftests/kvm/lib/x86_64/processor.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 33ca7f5232a4..8d544e9237aa 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -1119,8 +1119,7 @@ void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
>  	vcpu_sregs_get(vcpu, &sregs);
>  	sregs.idt.base = vm->idt;
>  	sregs.idt.limit = NUM_INTERRUPTS * sizeof(struct idt_entry) - 1;
> -	sregs.gdt.base = vm->gdt;
> -	sregs.gdt.limit = getpagesize() - 1;
> +	kvm_setup_gdt(vcpu->vm, &sregs.gdt);

*sigh*

The selftests infrastructure is so misguided.  Forcing tests to opt-in to
installing an IDT just to avoid allocating two pages is such an awful tradeoff.

Now that we have kvm_arch_vm_post_create(), I think we should always allocate
the GDT, IDT, and handlers, and then vCPU setup/creation can simply grab the
already-allocated values and stuff them into KVM.  That would then eliminate
kvm_setup_gdt() entirely.

And much of the setup code is also backwards and unnecessarily thread-unsafe, e.g.
vCPU initialization shouldn't need to fill GDT entries.

So, while I agree that using kvm_setup_gdt() is a good change on its own, I'd
rather go the more aggressive route and clean up the underlying mess.

I'll send patches sometime this week, unfortunately typing up what I have in mind
is harder than just reworking the code :-/
