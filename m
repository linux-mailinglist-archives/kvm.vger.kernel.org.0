Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DADC37CB364
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 21:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbjJPTio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 15:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjJPTio (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 15:38:44 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B5E9F
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 12:38:42 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5a31f85e361so2432822a12.0
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 12:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697485122; x=1698089922; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T+tprJ5evQ3yc1gWAh51A0ljnbQXoQ61VMKRaZ+HB8c=;
        b=QBbDHiM6AEpW8+WBD9r9TCQAtZaK5YpbAxNJZxxNCZwkrPGDZz9C9M3nm8tLBpj3Yi
         yPuCO3vxHESZYdqt5iWXoJi7nnvuWFU4XOiNAL2Uq5E0VSCJiL8kLyTwJyCkqJPgbzHE
         sFKQY9/48r9WmAKSANJO69b7so4zqlEZyZsV9/EGP2i7EXFZU4xaQOxZ8H5qDa1Y5Z4x
         GxGthaOXf15YEnLyqLADWafo4LXSv9EBH9Lv0mxwaJlZ2qi/OBrt6BtrmmKVO57FLP04
         zGovnZWzEoO2BtrV22k3vtDaSuVXIi9KRdqwA0HLIBfJ8BJCEBQwes09a+4MQ5aN+U+X
         07IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697485122; x=1698089922;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T+tprJ5evQ3yc1gWAh51A0ljnbQXoQ61VMKRaZ+HB8c=;
        b=OJICe5FKV0JnoMFmM0c51kpm0ewEiIraDjgxUPEgt2EqjbR3fdvO7UiA6QeCtgER1Y
         FHVUytNp0jHj7lTsdYzg7HSx+1VzKcm5ZDxAVYzzMcs9+ouFOuSlhC/0Xd/0RVrqpl5i
         yyXHEjdIosOpAYdj9hbwuIKa30/j00n8o75TU/BaMLweURSGUt0YZ4pb/6OcmVFTntpe
         NO9LnU3aTDsUNk2KPpHuEmL+o59GVEkMslUadMgPV4m8pGPRvzKN6MaPcD1iA5Lw+LSK
         vzA38hB2biOC4fS3A4n9YZARAoyMyjSuDrbsuwfu9SykmBM6MjIx/LmC43Jc/kEW0X9+
         tfrQ==
X-Gm-Message-State: AOJu0YyB4V9+zzwRLeALvCHAKSyNMR6MYqHcjQ3opB7zS5jtAdHh8r3q
        0omePswL+s9ZVvwHjVpsx5sXP2h9eEM=
X-Google-Smtp-Source: AGHT+IEs4kjKHl7kcZuhpmuuS8c2ZTy+FQzFfwSx2kiHvv6VatlGeS27RXZFvvd3dQXcNCum9uf28/BPac4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:23c7:b0:1ca:7a4c:834d with SMTP id
 o7-20020a17090323c700b001ca7a4c834dmr4834plh.13.1697485121706; Mon, 16 Oct
 2023 12:38:41 -0700 (PDT)
Date:   Mon, 16 Oct 2023 12:38:39 -0700
In-Reply-To: <CAF7b7mrt-iWduEQusKHhP3TLiWwL1gQjGj0HB=u1R2Vd5yEP0A@mail.gmail.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-10-amoorthy@google.com>
 <CALzav=f8YDdqxVXNRASNWxuM2WzgBwj=hErj1Yc5da552ecG5Q@mail.gmail.com> <CAF7b7mrt-iWduEQusKHhP3TLiWwL1gQjGj0HB=u1R2Vd5yEP0A@mail.gmail.com>
Message-ID: <ZS2RPy-N1l5wTOLg@google.com>
Subject: Re: [PATCH v5 09/17] KVM: Introduce KVM_CAP_USERFAULT_ON_MISSING
 without implementation
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     David Matlack <dmatlack@google.com>, oliver.upton@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
        maz@kernel.org, robert.hoo.linux@gmail.com, jthoughton@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        nadav.amit@gmail.com, isaku.yamahata@gmail.com,
        kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023, Anish Moorthy wrote:
> > Bike Shedding! Maybe KVM_MEM_EXIT_ON_MISSING? "Exiting" has concrete
> > meaning in the KVM UAPI whereas "userfault" doesn't and could suggest
> > going through userfaultfd, which is the opposite of what this
> > capability is doing.
> 
> You know, in the three or four names this thing has had, I'm not sure
> if "exit" has ever appeared :D
> 
> It is accurate, which is a definite plus. But since the exit in
> question is special due to accompanying EFAULT, I think we've been
> trying to reflect that in the nomenclature ("memory faults" or
> "userfault")- maybe that's not worth doing though.

Heh, KVM's uAPI surface is so large that there's almost always both an example
and a counter-example.  E.g. KVM_CAP_EXIT_ON_EMULATION_FAILURE forces emulation
failures to exit to userspace, whereas KVM_CAP_X86_DISABLE_EXITS disables exits
from guest=>KVM.  The latter is why I've shied away from "EXIT", but I think that
I'm looking at the name too much through the lens of a KVM developer, and not
considering how it will be read by KVM users.

So yeah, I agree that KVM_MEM_EXIT_ON_MISSING and KVM_CAP_EXIT_ON_MISSING are
better.  Let's go with that.
