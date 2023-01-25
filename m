Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1731E67B738
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 17:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbjAYQtP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 11:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235770AbjAYQsl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 11:48:41 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFD53BD91
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 08:48:17 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id x21-20020a056830245500b006865ccca77aso11451807otr.11
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 08:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vq3LFQzKpZKBu49mGyCeTfi9HlhBCQSg5nBGLL0OypI=;
        b=PdtocwtdB8FDvLU7tUXjJ+15U60AZmpxJVdEEWY4mMw+TzW4SDdaRmai8a4Jg4sxLI
         Lwe2olqot8VczzHQsTvNOPHr+qwz9v5SXFz4zQoP4UibuaXU198h+2Emg7l91qhVxtB+
         v1N4joqVqWTVHKVgaxbbPIBgHiingnGOZdJEGO54u6qs9iGFCIh6CUvi/Vn6qwJqJQug
         qoqFiiVmHFRKosHCPjhm2In3muQfZeWloJ6AIR3Hipp5Rm79oHc2kswfbcHNMuIS8PWb
         24ddY5+5jwAeJgf74J3RQ7dgSSguYK1BBjbAdXpaugu+J3hlbVKYovgl1g/n4PfWy5I+
         EFsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vq3LFQzKpZKBu49mGyCeTfi9HlhBCQSg5nBGLL0OypI=;
        b=tWeF31iJDXMtCofzHWpOcEESudwe1kHJ7X6iv0VV0KYCWwIOn4eRYWGobhajk+egPg
         xWRJp61b6bpGR9rn6v56Slk1uDYzpQZLsum3RVqn/4uVPZje5gRkgjfr1unJ8ngmOs9+
         50LkZQiPcuS/UCB+GAArHw8bzB16wyMFlYTYbQX6cDMRd5gTtiQUGNCgZ2hBjtnBTztt
         k9YuM7SJoLtcHgCFGxKuCe9jQctr0FJGXK2Xicc5sQ9mzdoNmjER85g3eLQNriUzMmd+
         WBrDl0kJXhyy/6sn4IvdO9HaFDwEAum6jEpfDyLRN6DKTGtXeeGT2ASIGWyOGaebx7Gc
         Qe9g==
X-Gm-Message-State: AFqh2krVymC7NH3EdZlAi41GQg/fV1wVcjkXdgxALGLXP9lh5A4MrP3Z
        l7v6YNTqG/9WXHOaWZKb75vwIZenes+akwr4NbyfEQ==
X-Google-Smtp-Source: AMrXdXtbgubewTmPxtFwsv2qHy+cXHIkihgATKvfFQzPBDZm7LPVyGSSuCJPV6EntjJunWDoW3ri+a4V+yJTVgdwfR0=
X-Received: by 2002:a9d:3e2:0:b0:684:e1a4:1df9 with SMTP id
 f89-20020a9d03e2000000b00684e1a41df9mr2141435otf.8.1674665290314; Wed, 25 Jan
 2023 08:48:10 -0800 (PST)
MIME-Version: 1.0
References: <20221027092036.2698180-1-pbonzini@redhat.com> <CALMp9eQihPhjpoodw6ojgVh_KtvPqQ9qJ3wKWZQyVtArpGkfHA@mail.gmail.com>
 <3a23db58-3ae1-7457-ed09-bc2e3f6e8dc9@redhat.com>
In-Reply-To: <3a23db58-3ae1-7457-ed09-bc2e3f6e8dc9@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 25 Jan 2023 08:47:59 -0800
Message-ID: <CALMp9eQ3wZ4dkq_8ErcUdQAs2F96Gvr-g=7-iBteJeuN5aX00A@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: Do not return host topology information from KVM_GET_SUPPORTED_CPUID
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Jan 25, 2023 at 6:17 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 1/25/23 00:16, Jim Mattson wrote:
> > This is a userspace ABI change that breaks existing hypervisors.
> > Please don't do this. Userspace ABIs are supposed to be inviolate.
>
> What exactly is broken?

KVM_GET_SUPPORTED_CPUID no longer returns the host topology in leaf 0xB.

> Part of the definition of the API is that you can take
> KVM_GET_SUPPORTED_CPUID and pass it to KVM_SET_CPUID2 for all vCPUs.
> Returning host topology information for a random host vCPU definitely
> violates the contract.

You are attempting to rewrite history. Leaf 0xB was added to
KVM_GET_SUPPORTED_CPUID in commit 0771671749b5 ("KVM: Enhance guest
cpuid management"), and the only documentation of the
KVM_GET_SUPPORTED_CPUID ioctl at that time was in the commit message:

     - KVM_GET_SUPPORTED_CPUID: get all cpuid entries the host (and kvm)
       supports

There is nothing in the commit message or the official documentation
at the time that the ioctl was added that says anything about passing
the result to KVM_SET_CPUID2 for all vCPUs. Operationally, it is quite
clear from the committed code that the intention was to return the
host topology information for the current logical processor.

Any future changes to either the operational behavior or the
documented behavior of the ABI surely demand a version bump.
