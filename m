Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074D1526B37
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 22:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376943AbiEMU1j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 16:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239872AbiEMU1i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 16:27:38 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED7AF47
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:27:37 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id m25so11495489oih.2
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=99/RQ/TEDrl/cI0bVmdjzMtZB4uNUmEzljOvC28iEz8=;
        b=bZVS/9dhIQBdgxOQIoWwLltNrxEIHGDAhZIDN3/6OIjPwFdpBvz0iopKN7ya6UOdi5
         981dYqD4MjZmXZWtlYUYnovgp19XgUSRR6jeR7FqqzmLelkgcKCNd00rVNfF8VD0c0cd
         nb3hXRs6ATTiffpfG2R/iSJRhZAHBvI3ALIRE+G5oRoBk0lvRjXvFxR8Qv+10AKq/TD9
         0r2rSrT/PxSlrqYAfX52ZZtoZh22LZzRuNzoOkgwWdl4RKWsVz+iEJuLYn+N2akSv6tB
         4A5YgWcfF1Gd9SJc48V/3qz4pYZ5XMHRStI9LaOoecPrT8XTr4VHt7J5mR72djfj/sE2
         lBfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=99/RQ/TEDrl/cI0bVmdjzMtZB4uNUmEzljOvC28iEz8=;
        b=5gmfKS8E02pVUe7wClm5Yyi7Ik+uFcG/VhxRPqO2yK9VhtyhqVsL/HEL7sEeLc4XKb
         GFae7pLeV8cFPOK1qIKCPY428GG+qw6LFV/6H+B9W2nXOn+to/3Oe6FD0cEOA9wD8y5T
         i/vwJsgXJd8EpJfsLOH8pdqwFX5UNZ/4fRNAzsPKFmUJMpNUztOhZSwYBA+PLzvGyslP
         NuTom0i6RPljpAoEGsKPhjbiz4NroUMIoC7AWgtmRZqJ4a+Ll3v8asM0paoy0swK97vR
         9L6LjtovYgXThhhcUTgy2aLc3K1ep9XPHRwzf1SupTlQWC15pTdJUc+dMP75dwYgZAEQ
         PujQ==
X-Gm-Message-State: AOAM531XJ1VcrgCknSqCE270qMpvzV63RzBfgDILt3KL/hMREA0FyiFt
        8sJSq6ZgipZzwevK0cC4cThr5csfMx8JX96xRP6FUQ==
X-Google-Smtp-Source: ABdhPJzjkjfXXwZJSABHc+7d9SbZttIFfFJyNa10z9JjsNyAbpCHZoW5BfjYx/hT0G28JwsC7f+aJcbiOHjbFiBKBOg=
X-Received: by 2002:a05:6808:c2:b0:325:eb71:7266 with SMTP id
 t2-20020a05680800c200b00325eb717266mr8793970oic.269.1652473656784; Fri, 13
 May 2022 13:27:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220513195000.99371-1-seanjc@google.com> <20220513195000.99371-3-seanjc@google.com>
In-Reply-To: <20220513195000.99371-3-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 13 May 2022 13:27:25 -0700
Message-ID: <CALMp9eQn+QaK630apzOz-L-btHxGQuXcbEiovO8FLOtMmQp_CQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Comment FNAME(sync_page) to document
 TLB flushing logic
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
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

On Fri, May 13, 2022 at 12:50 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Add a comment to FNAME(sync_page) to explain why the TLB flushing logic
> conspiculously doesn't handle the scenario of guest protections being
> reduced.  Specifically, if synchronizing a SPTE drops execute protections,
> KVM will not emit a TLB flush, whereas dropping writable or clearing A/D
> bits does trigger a flush via mmu_spte_update().  Architecturally, until
> the GPTE is implicitly or explicitly flushed from the guest's perspective,
> KVM is not required to flush any old, stale translations.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
Reviewed-by: Jim Mattson <jmattson@google.com>
