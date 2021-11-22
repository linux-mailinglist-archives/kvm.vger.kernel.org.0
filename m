Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58804595C8
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 20:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240020AbhKVTzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 14:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbhKVTzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 14:55:20 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB8EC061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 11:52:13 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id v23so14680633pjr.5
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 11:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R+2NVVaB7HNzmKzz9pvoSqA0OaPLrTBeTq2QxKS1nB4=;
        b=PItd8EYo8Or7WokynjwCq8i4x/kFYinllcqQW39lWPjhQH55Ihfl8074H3A0R5NWdM
         7bwmIv/NVpbT96+rfUIhsSDFQN7pWgdmU/yqB6bJdf9srpYAnFGAbgwyB4Uo2eWh7pRm
         TVx0PLEsVbgfx2vBS0qrsgdS5jeIffJcFJ81iYVAenMiSPmS3GCDmMh6ZzoO4KFD+fPW
         rDqgCbYIk1lE+8oWppClXldsAPfdApQ/aXDXj8RCohAjMA3zkR8ttxqe9zXXeYnLtHSu
         5aBB9sbfBkzu0EQMUkVTgiM8dPa3R3duOims5aLa9QsuCsrUXOUz2gjkGy5bDrNmI8HP
         yLeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R+2NVVaB7HNzmKzz9pvoSqA0OaPLrTBeTq2QxKS1nB4=;
        b=K1nKPjqZqAnPYb6frsZ73sdF9sHsB1VCqtAbQcrmKYcpx1yH4bBNTo2dgfCp4ij46J
         GwO/fTPhunWps7Cvh/zr+3L7TbMz3ZO/eZeU7ODanJYOdCpg76mDpUUs975sRvsSxaC6
         kAWdIjAokFzqXaib1a25J/DOxXOOuqf9MDt2SOFN4Ay+sH+KkftUx7s/5xeCvda4sGFM
         XXNqRARqGRz1INgF5kyJMNS7QgFx0kZAhQ/OsiC/pbAORQjYaRsa+cblHszcG2Pr0s9f
         c3BflbTQbt4gz2TGtHzearV2A4WS4vEtzkE8GnTq8RuxUMie1aqTKo3ydJZ6GujeAeLi
         l7YQ==
X-Gm-Message-State: AOAM533vd3tLFRmw7OM4NJDqqLNUcxiv3Y9N82kyuVTVcoyrLtnGov/T
        iNgJZP1MQuz5ahjlc4rJpV3r/x9c5DBlyQ==
X-Google-Smtp-Source: ABdhPJwjhM1+Fco2+HarM0SN9NtmRjgRYFfu9c3PjJCXM++heqDPF9Z5D+ei4bDwKF7/qqW/WdoXwg==
X-Received: by 2002:a17:903:32c7:b0:141:eb39:30b7 with SMTP id i7-20020a17090332c700b00141eb3930b7mr75323371plr.41.1637610732883;
        Mon, 22 Nov 2021 11:52:12 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o7sm8484620pjf.33.2021.11.22.11.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 11:52:12 -0800 (PST)
Date:   Mon, 22 Nov 2021 19:52:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/4] selftests: sev_migrate_tests: add tests for
 KVM_CAP_VM_COPY_ENC_CONTEXT_FROM
Message-ID: <YZv06IHPynOqozNA@google.com>
References: <20211117163809.1441845-1-pbonzini@redhat.com>
 <20211117163809.1441845-3-pbonzini@redhat.com>
 <CAMkAt6ovkWTxwhcWMG7UT8X68TogG-0L_6rwTisTfgcWVNapSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMkAt6ovkWTxwhcWMG7UT8X68TogG-0L_6rwTisTfgcWVNapSQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 17, 2021, Peter Gonda wrote:
> On Wed, Nov 17, 2021 at 9:38 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > +static void test_sev_mirror(bool es)
> > +{
> > +       struct kvm_vm *src_vm, *dst_vm;
> > +       struct kvm_sev_launch_start start = {
> > +               .policy = es ? SEV_POLICY_ES : 0
> > +       };
> > +       int i;
> > +
> > +       src_vm = sev_vm_create(es);
> > +       dst_vm = aux_vm_create(false);
> > +
> > +       sev_mirror_create(dst_vm->fd, src_vm->fd);
> > +
> > +       /* Check that we can complete creation of the mirror VM.  */
> > +       for (i = 0; i < NR_MIGRATE_TEST_VCPUS; ++i)
> > +               vm_vcpu_add(dst_vm, i);
> 
> Style question. I realized I didn't do this myself but should there
> always be blank line after these conditionals/loops without {}s? Tom
> had me add them to work in ccp driver, unsure if that should be
> maintained everywhere.

Generally speaking, yes.  There will inevitably be exceptions where it's ok to
omit a blank line, e.g. kvm_ioapic_clear_all() is a decent example, as is
kvm_update_dr0123().  But for something like this where the for-loop is a different
"block" than the following code, a blank line is preferred.
