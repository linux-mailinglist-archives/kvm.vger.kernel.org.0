Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80FA2723272
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 23:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbjFEVo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 17:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233191AbjFEVoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 17:44:55 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90882F9
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 14:44:54 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-2566b668cc5so3328075a91.0
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 14:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686001494; x=1688593494;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SNgSlo5ni9QJNP2sIzy0ySCwY89ehiU/Eubjg1DeNdo=;
        b=it/QlLDU1iOa7KbAi6EJFOaJU015SOdez6gVsx2k1LE9QXjHzPUmePdB+aNaDr5PcU
         nlbZcQJey6+zB0WADY2SxVeRr9wFWwl/BPiRNZ/pgyN89Vycu+o2/8UyTTc8+KAlvNkw
         4wZ5OfR8JnDtXkvhM6pF0dR6rKTV3iLFYL8ggzMwVRfa02zBX1gIFyrWXQFj0wKV7Up5
         hwINys1rwWJc+mgCa6gfZOGYoW7vaBU09rWPWHdUKsLTDV0a108xi2i524R+mdKF0HrS
         1M4DZHPaPuDpEKudd1DSEol6IM3VWyOYSSI9htRG0f1IPfUcHCsw2enYS9i/tR+9gs6F
         rm9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686001494; x=1688593494;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SNgSlo5ni9QJNP2sIzy0ySCwY89ehiU/Eubjg1DeNdo=;
        b=OvIWPuZCM8Xe3TqxRuiOeC30Z5gWICfMz+Sq9RX2LqbGpq0yYpeKpuAadtRco3wsXm
         NXiYQd25vYZ+vS7Ov9lnHib8bUshPinoztqOpEjyNQGEXPVBz2wz2pZcqdczOVwr6BJB
         EvyWBMLiiAogvfWxXRLkbX0k9+Ga5gTXkV7rIG7OLjcnTAu/NdlLYU1cCR6VqlQ0f0+c
         Bc679juIKjkzccsPIUeC8YA5cSP89f66pvbxOQJFI4WvVqcPITMNv58AkYedvW0eqo5c
         cYGhYMK+N/nLDTiUny95PInyWyQIq9l2HbqZqbNCBoMUb4Iipc17aaOG8ud6pNqZr3sn
         8niw==
X-Gm-Message-State: AC+VfDzR5fLy8RjySAju7Kt/9hs5xwCL0MRPxTTjTBtcuRgIyhaqBQC5
        1Y7hzQde4wEcQhC/n6vM+2Ga+M8cDf0=
X-Google-Smtp-Source: ACHHUZ75I1xsJecW1dA6nxmzHWRRn3Qmfoi9MUZ8oD/mIrRyKLJX0eU5RevHFP4aACoupVIfQXtaWhu/79U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:55ce:b0:253:32b1:e567 with SMTP id
 o14-20020a17090a55ce00b0025332b1e567mr2070514pjm.2.1686001494009; Mon, 05 Jun
 2023 14:44:54 -0700 (PDT)
Date:   Mon, 5 Jun 2023 14:44:52 -0700
In-Reply-To: <20230424225854.4023978-5-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230424225854.4023978-1-aaronlewis@google.com> <20230424225854.4023978-5-aaronlewis@google.com>
Message-ID: <ZH5XVOIb2GtwAKNC@google.com>
Subject: Re: [PATCH v2 4/6] KVM: selftests: Add string formatting options to ucall
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 24, 2023, Aaron Lewis wrote:
> Add more flexibility to guest debugging and testing by adding
> GUEST_PRINTF() and GUEST_ASSERT_FMT() to the ucall framework.
> 
> A buffer to hold the formatted string was added to the ucall struct.
> That allows the guest/host to avoid the problem of passing an
> arbitrary number of parameters between themselves when resolving the
> string.  Instead, the string is resolved in the guest then passed
> back to the host to be logged.
> 
> The formatted buffer is set to 1024 bytes which increases the size
> of the ucall struct.  As a result, this will increase the number of
> pages requested for the guest.
> 
> The buffer size was chosen to accommodate most use cases, and based on
> similar usage.  E.g. printf() uses the same size buffer in
> arch/x86/boot/printf.c.

...
>  #define UCALL_MAX_ARGS 7
> +#define UCALL_BUFFER_LEN 1024
>  
>  struct ucall {
>  	uint64_t cmd;
>  	uint64_t args[UCALL_MAX_ARGS];
> +	char buffer[UCALL_BUFFER_LEN];

...

> diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
> index 77ada362273d..c09e57c8ef77 100644
> --- a/tools/testing/selftests/kvm/lib/ucall_common.c
> +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> @@ -55,6 +55,7 @@ static struct ucall *ucall_alloc(void)
>  		if (!test_and_set_bit(i, ucall_pool->in_use)) {
>  			uc = &ucall_pool->ucalls[i];
>  			memset(uc->args, 0, sizeof(uc->args));
> +			memset(uc->buffer, 0, sizeof(uc->buffer));

The use in boot/printf.c isn't a great reference point.  That "allocation" is
on-stack and effectively free, whereas the use here "requires" zeroing the buffer
during allocation.  I usually tell people to not worry about selftests performance,
but zeroing 1KiB on every ucall seems a bit excessive.

However, that's more of an argument to not zero than it is to try and squeak by
with a smaller size.  The guest really should explicitly tell the host how much
of the buffer.  And with that, there should be no need to zero the buffer because
the host isn't relying on the memory being zeroed.

On a somehwat related topic, this patch should also introduce a macro/helper to
retrieve and print the buffer on the backend.  Partly to reduce copy+paste, partly
to make it easier to review (i.e. show the end-to-end), and partly so that the
ucall code can craft a more explicit contract.
