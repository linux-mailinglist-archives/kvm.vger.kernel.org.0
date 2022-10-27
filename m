Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA3460FFB6
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 20:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236040AbiJ0SBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 14:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236189AbiJ0SBA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 14:01:00 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526981DF1B
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 10:59:46 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id l6so2346628pjj.0
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 10:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k9IjDL5JWPlrnxsJJxEdunDpxxIPr2PnubjnaqSEwb4=;
        b=fAXRGsXO9T0rVErFQRaqRc9PON2BHW/sPR0NJalJ9Jad8TFOi63lfrXx+Qr4g1y/rt
         8Um/s2hFWMnq0ZYlnODum3Ka6hps+k8EUMiUNDK8VeFZO5W1onzj6pn7P1r6f4KkvvyR
         JKfdeir7oAydSoXS4iEfaZRC4CqREkrS8n1lTV5J9r3z/QG228gGvrc2BfpSvqCrF4tN
         fwS5PoHK6fUA96ivKQVZgK5MLvEIAXEQTFhn0HN+iYL18SI0aX3N7j4YS4mtBuC3fp3R
         iElh2Fo36Oj0islcASQPO2huArN8fvJJH4gkYDnV+GSF+D0gP+D4WRWkyxfWUnqfgQFL
         6LyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9IjDL5JWPlrnxsJJxEdunDpxxIPr2PnubjnaqSEwb4=;
        b=6nISd+w+V8OTPMYOAX84izqiLMeDf+1qSIQ8HgXvp71R0lV1qZFzSMp9YbJfAqaNto
         0lPLcS8ERePxl3lu/y6dPid9zJf/W1mLQq+wSzE2PIXPqDLnpLW67p7EC3qPBOQTuQwr
         EZZwaZ18lEODCN+2/L1BpJpJU0iC5ExUhIGoiWCIORukowD317IlfFKg5BqpUmqMpqjn
         +wRmgxZK9t8wU6F81CIVnHVlMv+g+1WBci0AgZ72L29AUokSRkYZxURDs8q1Jx+dU0Aw
         +WcziuSBGuPJ7ETR1X5Lb19p5ZDov2VrQG44hmL2443sJ/3xO2ZPn5YUFSrsziqbd/8o
         GS1w==
X-Gm-Message-State: ACrzQf0AtFRSeU13/q5aMl/Sofc6GxSMNkzPXtKRpYNT3O3DRs87o0Z4
        zXgykvv8myIKvhqc3r3Ylv5QPA==
X-Google-Smtp-Source: AMsMyM51ndGRH8GQDhjsXKGE6fXDuBR48obKHClQus7mENGt9nZN2K6NGCLN9rN699E6OeBjC+xpQg==
X-Received: by 2002:a17:90b:384a:b0:213:2907:a528 with SMTP id nl10-20020a17090b384a00b002132907a528mr11393920pjb.183.1666893586206;
        Thu, 27 Oct 2022 10:59:46 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n5-20020a170902e54500b00186f0f59c85sm1116689plf.235.2022.10.27.10.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 10:59:45 -0700 (PDT)
Date:   Thu, 27 Oct 2022 17:59:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev
Subject: Re: [V4 6/8] KVM: selftests: add library for creating/interacting
 with SEV guests
Message-ID: <Y1rHDlDskvSacLNp@google.com>
References: <20220829171021.701198-1-pgonda@google.com>
 <20220829171021.701198-7-pgonda@google.com>
 <Yz8dpB5+RFjEhA3n@google.com>
 <CAMkAt6oZQc4jqF7FOXOKkpbP3c4NXxPumVVjX9gXwPCh-zbtYg@mail.gmail.com>
 <Y02ZLFcDQbX6lP9z@google.com>
 <CAMkAt6q0g5Ua=PwLXa2oA4zCQUaHuEQ3pTXycD61HU6-dtQ5Gg@mail.gmail.com>
 <Y028WrU3pmEQqWDq@google.com>
 <CAMkAt6pvT15teuYWjz7r1vmUP5McDp76qjxQ26_oeg5mTnv5NA@mail.gmail.com>
 <Y1AnHwVtOFShRxQD@google.com>
 <CAMkAt6rP7KbgUqmK+aiooSLfvRrMsRmp99cL0YWKBwpOJZc82A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMkAt6rP7KbgUqmK+aiooSLfvRrMsRmp99cL0YWKBwpOJZc82A@mail.gmail.com>
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

On Thu, Oct 27, 2022, Peter Gonda wrote:
> On Wed, Oct 19, 2022 at 10:34 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Oct 18, 2022, Peter Gonda wrote:
> > > On Mon, Oct 17, 2022 at 2:34 PM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Mon, Oct 17, 2022, Peter Gonda wrote:
> > > > > I think this means we don't need to add VM_MODE_PXXV48_4K_SEV since we
> > > > > can set up the c-bit from inside of vm_sev_create_*(), thoughts?
> > > >
> > > > Configuring the C-bit inside vm_sev_create_*() won't work (at least not well).
> > > > The C-bit needs to be known before kvm_vm_elf_load(), i.e. can't be handled after
> > > > __vm_create(), and needs to be tracked inside the VM, i.e. can't be handled before
> > > > __vm_create().
> > > >
> > > > The proposed kvm_init_vm_address_properties() seems like the best fit since the
> > > > C-bit (and TDX's S-bit) is stolen from GPA space, i.e. directly affects the other
> > > > values computed in that path.
> > > >
> > > > As for the kvm_vm_arch allocation ugliness, when we talked off-list I didn't
> > > > consider the need to allocate in kvm_init_vm_address_properties().  That's quite
> > > > gross, especially since the pointer will be larger than the thing being allocated.
> > > >
> > > > With that in mind, adding .../include/<arch>/kvm_util.h so that "struct kvm_vm_arch"
> > > > can be defined and referenced directly doesn't seem so bad.  Having to stub in the
> > > > struct for the other architectures is annoying, but not the end of the world.
> > >
> > > I'll make "struct kvm_vm_arch" a non pointer member, so adding
> > > /include/<arch>/kvm_util.h files.
> > >
> > > But I think we do not need VM_MODE_PXXV48_4K_SEV, see:
> >
> > I really don't want to open code __vm_create() with a slight tweak.  E.g. the
> > below code will be broken by Ricardo's series to add memslot0 is moved out of
> > ____vm_create()[1], and kinda sorta be broken again by Vishal's series to add an
> > arch hook to __vm_create()[2].
> >
> > AFAICT, there is no requirement that KVM_SEV_INIT be called before computing the
> > C-Bit, the only requirement is that KVM_SEV_INIT is called before adding vCPUs.
> >
> > [1] https://lore.kernel.org/all/20221017195834.2295901-8-ricarkol@google.com
> > [2] https://lore.kernel.org/all/YzsC4ibDqGh5qaP9@google.com
> 
> Oh I misunderstood your suggestion above.
> 
> I should make KVM_SEV_INIT happen from kvm_arch_vm_post_create().  Add
> VM_MODE_PXXV48_4K_SEV for c-bit setting inside of
> kvm_init_vm_address_properties().
> 
> Inside of vm_sev_create_with_one_vcpu() I use
> __vm_create_with_vcpus(), then call KVM_SEV_LAUNCH_FINISH.
> 
> Is that correct?

Yep, I'm pretty sure that was what I was thinking.
