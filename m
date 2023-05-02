Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA926F4B80
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 22:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjEBUlu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 16:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjEBUlt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 16:41:49 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E839510D9
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 13:41:47 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-64115e69e1eso82514b3a.0
        for <kvm@vger.kernel.org>; Tue, 02 May 2023 13:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683060107; x=1685652107;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W1xT6Cy3XHsLOOGIfij/aWoeXWzYY5kDVhaeCmtEpLI=;
        b=CU9m786t178y6G9yo7NRnuVonUA1T6tCM09qzkEymu2841t5iWyn9Ud3NuErkylfMB
         zOL0ts72Klrj4WlWCV7DHlnjUwbBCelkrgDk6DHOcWMjdsfgt9cRWidRn9nG0719CB9I
         x+8TCWtv8l2UUPWrfwmMApfMpsDwc7Wt5ahbpYaZvZSqKqTTN2yMDPLKmOwkzVFVEw8m
         gbiGNR7hY5xH7ZTCuM7j8+kivyRoZvwyRjVClo3ICe6Mt9WCbl19ASmcXw0QMy38B2/6
         r4Pg/iviE73KarQYUzXev7KozZcfVRrtj2wxISVDVXh8GHka8nwkUSxp+PXDaGy6bVFH
         idtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683060107; x=1685652107;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W1xT6Cy3XHsLOOGIfij/aWoeXWzYY5kDVhaeCmtEpLI=;
        b=TCJhhdeo1bFmLSeox//oIrVZ86iqsVe02qykz/eaGOkrxv10UPRBLJIXCdLYoU+c+x
         BwPIWGhwfc3MAChHo5FkQO+92doBLoXW1Ywi4pvYy2muq5b5d9YnVGoaPi8hIUSV1KtT
         tgJEpWx2X3oqejbhgESawZ/IdTHq6m/poUhK39dpxZJgltIts4IThF2uLhBd8ITQbG5I
         72yL+PI4V2p4bZzFyJbzc6PTzNz2dbu1Dy0UXFbkD5P0Qv15wUeafVKixh19b0e+KD4k
         4kj+/Uyu+SQPRYkEDajkhAyGahTkdsoNcUiDFLaq7Enu/GOvB6et6AQPrQln/bZl6iIA
         Uhnw==
X-Gm-Message-State: AC+VfDyLScEi146MoAS3S2jQqiIRu2eT+pXOJ0m383OdR35VF2BdQvqq
        82bg8LthoM93FVkONlNvQuYb+3ETfqY=
X-Google-Smtp-Source: ACHHUZ7Z2F3qdn8usjq2NWZcWjfwltlLS38Glt0+jjWUNErXARTzv1Y9FNS6hwgz0tmajg5no5fMFCf7UMg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4c15:0:b0:524:fba4:fd51 with SMTP id
 z21-20020a634c15000000b00524fba4fd51mr5673227pga.3.1683060107406; Tue, 02 May
 2023 13:41:47 -0700 (PDT)
Date:   Tue, 2 May 2023 13:41:45 -0700
In-Reply-To: <CAF7b7moqW41QRNowSnz3E-T+VQMrkeJthDVxM2tuNHtJ5TTjjQ@mail.gmail.com>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-5-amoorthy@google.com>
 <CAF7b7mqq3UMeO3M-Fy8SqyL=mjxY4-TyA_PjgGsdVWZrsU2LLQ@mail.gmail.com>
 <ZFFbwOXZ5uI/gdaf@google.com> <CAF7b7moqW41QRNowSnz3E-T+VQMrkeJthDVxM2tuNHtJ5TTjjQ@mail.gmail.com>
Message-ID: <ZFF1ibyPZHKYzEuY@google.com>
Subject: Re: [PATCH v3 04/22] KVM: x86: Set vCPU exit reason to
 KVM_EXIT_UNKNOWN at the start of KVM_RUN
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        jthoughton@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
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

On Tue, May 02, 2023, Anish Moorthy wrote:
> Thanks for nailing this down for me! One more question: should we be
> concerned about any guest memory accesses occurring in the preamble to
> that vcpu_run() call in kvm_arch_vcpu_ioctl_run()?
> 
> I only see two spots from which an EFAULT could make it to userspace,
> those being the sync_regs() and cui() calls. The former looks clean

Ya, sync_regs() is a non-issue, that doesn't touch guest memory unless userspace
is doing something truly bizarre.

> but I'm not sure about the latter. As written it's not an issue per se
> if the cui() call tries a vCPU memory access- the
> kvm_populate_efault_info() helper will just not populate the run
> struct and WARN_ON_ONCE(). But it would be good to know about.

If KVM triggers a WARN_ON_ONCE(), then that's an issue.  Though looking at the
code, the cui() aspect is a moot point.  As I stated in the previous discussion,
the WARN_ON_ONCE() in question needs to be off-by-default.

 : Hmm, one idea would be to have the initial -EFAULT detection fill kvm_run.memory_fault,
 : but set kvm_run.exit_reason to some magic number, e.g. zero it out.  Then KVM could
 : WARN if something tries to overwrite kvm_run.exit_reason.  The WARN would need to
 : be buried by a Kconfig or something since kvm_run can be modified by userspace,
 : but other than that I think it would work.
