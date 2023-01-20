Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80539675A52
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 17:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjATQnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 11:43:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjATQnj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 11:43:39 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD36521E2
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 08:43:38 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id j17so8966391lfr.3
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 08:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=b6H597y2E+4hceJFrRzSWlML9fGyxT4WBWw6ghvW/jA=;
        b=mYIUZjbtO0wjv7KBwnk0KYKGEGAK9qC/Eki9/693B9qzVLFql9ZUtecc5PW9ZzLegQ
         0Db6hRG/UL+OJExbQ3BhjUdcoPIz+TsmJ3RfD2/SeW5Nz8UUHFZFD5EINevvdscG/9Tv
         2RePNFFJuEKUtd6GpyAA6KReh9IUuSrAO/EP1yOTjUhActjXlUaavd57bbiQHj+v/KsH
         jKf8X3jHwz74YW/wUia2QN9RWTHShpso3JRY6nMiwLjaRSuY6we2cbPfEaP7DFdJ853Q
         WUa0QuVBfcb+UxC3o9cCdEcSZ/UEiSRUgf5r2yCAHnI3BoVWEsdAHrrXZts2nV/fycq4
         7BMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b6H597y2E+4hceJFrRzSWlML9fGyxT4WBWw6ghvW/jA=;
        b=kNfFRroq8V1z/lRbJjJwi8bYcR3bvYHFlIyEOm7XxXyP0Fi/u5N3MVpKRiSxSHWReR
         /jXNytBaHnAKJeAv2RIsk2BaBbMa5Ii26bhlTlMZLy2gdKIAszxrWCoMJASaiIi1LWC9
         nMZm6tzA2WDOv8gPkPTXpQwZ0cNvVLsIY6LKCym4mH3Lp8WVmGM0tdt/kljSOQvwDIAP
         0G4A0+JRLWBpVqp/VYGSpSIXmMeY69tEY9aJNtao4iE74DYTWVcGMilrYA28PA94ht5a
         Y5JbVvkwIMr6tCf0RN6wdvKcuesZTIVWNK64aI/rBVW6tkd6ETf585KiXYrw5Vk8Xzz4
         QIEA==
X-Gm-Message-State: AFqh2krmovWMZO1UOdrxU997j+TT0QCs8oS9YgbvACpkg9IoJa0urqIx
        80sj+BicjNYVMFDY0ERrgqD9ib+uVf2e5fDlLmSg7A==
X-Google-Smtp-Source: AMrXdXvDITSCPWsk74t3D3a55+fR6m9KyaMjuz7CdMfnmR2NK/rEJ7wIyVqg+UPH9Eqa7wn6+Vs1RigIAmq5ZxU/+mw=
X-Received: by 2002:a05:6512:2821:b0:4d5:6e31:cc03 with SMTP id
 cf33-20020a056512282100b004d56e31cc03mr1460490lfb.558.1674233016674; Fri, 20
 Jan 2023 08:43:36 -0800 (PST)
MIME-Version: 1.0
References: <20230110175057.715453-1-pgonda@google.com> <Y8hblFklBZSS+tS/@google.com>
In-Reply-To: <Y8hblFklBZSS+tS/@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 20 Jan 2023 09:43:25 -0700
Message-ID: <CAMkAt6qGOWMA-AmQJMja187Y9k8bAC2KnPCGwV9CaBATz86hmQ@mail.gmail.com>
Subject: Re: [PATCH V6 0/7] KVM: selftests: Add simple SEV test
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, pbonzini@redhat.com, andrew.jones@linux.dev,
        vannapurve@google.com, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 18, 2023 at 1:50 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jan 10, 2023, Peter Gonda wrote:
> > This patch series continues the work Michael Roth has done in supporting
> > SEV guests in selftests. It continues on top of the work Sean
> > Christopherson has sent to support ucalls from SEV guests. Along with a
> > very simple version of the SEV selftests Michael originally proposed.
>
> I got two copies of this series.  AFAICT, the only difference is that LKML is
> Cc'd on the second send.  When resending an _identical_ series, e.g. because you
> forgot to Cc' someone or because mails got lost in transit, add RESEND in between
> the square braces in the subject of all patches so as not to confuse folks that
> get both (or multiple) copies.

Will do. My mistake, sorry.
