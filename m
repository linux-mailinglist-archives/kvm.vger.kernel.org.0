Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E3552956D
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347208AbiEPXm1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238034AbiEPXm0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:42:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F7B11EADA
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652744544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r/asMrDbeoO2NLnEbV+HtGOMDOiUS8niBVvixVcIiFo=;
        b=FtERmgGKvP3teWua87SfZBpr20PyWFh0fDwk0wXLnCovac8pg8ru4A2iyrMecXSPWyJb0e
        Vh759Qkabcol50B3fW0rl+zMrcihFryq+70tjzLyqw8JdCNWuOGcKIUAf83YDMofc81+1d
        yLJVAHC3BqCaGB9Yi7YlsqXNzvxd6II=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-512-mC4I5ljzMTGi6keZ8YmKlA-1; Mon, 16 May 2022 19:42:22 -0400
X-MC-Unique: mC4I5ljzMTGi6keZ8YmKlA-1
Received: by mail-il1-f197.google.com with SMTP id r5-20020a924405000000b002cf9a5b9080so8516888ila.16
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:42:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r/asMrDbeoO2NLnEbV+HtGOMDOiUS8niBVvixVcIiFo=;
        b=KDqKiX4/SVyhUQwgvL8r7nlST9tJgDUjnVTNtaubygM5Os+DrQfn76uOZNo0gW4eqM
         meHV3WOjALjsjRpekYllEK4wAGvU4Ij1r2gfaKsw2cSUR0TY62J9sUCRNEcl8eSpFjOW
         YraRe9F3PXfYx/+T38VBpP9h04Mi9acRllF0TYVlBh/BwGXIBX2e/2I3lHrKK9/KuBJp
         oE1zdBb6lCZ6omPSimG39mvQ0XVfWULUKAIz149dQ6xLGR9/pMUT6hDt3m+CvhtRTwmj
         6ZXzjeI1rte6wgp7XL/WvLOGYGZu1ppLd7m793uhUlg4MTzYihntocFv4qvv4//vInR2
         yQWQ==
X-Gm-Message-State: AOAM532OosD3QFe0Bcb+wwEtFjaQPtPy1Ttbx4mp/GhgYrniRl7JvsqL
        CnMxfMlKuXhxi+PIfp0sWtSaGOCSNUBuuvYQIzWuVbzELGl1vhcK1+DbxGlUh7OF2lL1hNqyWCV
        OsLEbNLv2AcU/
X-Received: by 2002:a05:6602:2b0b:b0:64f:acc1:52c3 with SMTP id p11-20020a0566022b0b00b0064facc152c3mr8920728iov.38.1652744541735;
        Mon, 16 May 2022 16:42:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxXY5VaSY0QsUhy52b9WUCTY9pKyklPW3HFSbpEejxUz2jN/zK8gWIrjPMV2/zSEtSI3/qtw==
X-Received: by 2002:a05:6602:2b0b:b0:64f:acc1:52c3 with SMTP id p11-20020a0566022b0b00b0064facc152c3mr8920709iov.38.1652744541105;
        Mon, 16 May 2022 16:42:21 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id u136-20020a02238e000000b0032b3a7817a4sm3144281jau.104.2022.05.16.16.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 16:42:20 -0700 (PDT)
Date:   Mon, 16 May 2022 19:42:19 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Subject: Re: [PATCH 9/9] KVM: selftests: Add option to run
 dirty_log_perf_test vCPUs in L2
Message-ID: <YoLhW0DoAzqpAqu2@xz-m1.local>
References: <20220429183935.1094599-1-dmatlack@google.com>
 <20220429183935.1094599-10-dmatlack@google.com>
 <YoLNcd1SQMSNdSMb@xz-m1.local>
 <CALzav=dwEJx=HrPDBxVyTJU-JkjX3c0hx-4JvJ2bY+BW7FL5dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALzav=dwEJx=HrPDBxVyTJU-JkjX3c0hx-4JvJ2bY+BW7FL5dQ@mail.gmail.com>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 16, 2022 at 03:34:28PM -0700, David Matlack wrote:
> On Mon, May 16, 2022 at 3:17 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Fri, Apr 29, 2022 at 06:39:35PM +0000, David Matlack wrote:
> > > +static void perf_test_l1_guest_code(struct vmx_pages *vmx, uint64_t vcpu_id)
> > > +{
> > > +#define L2_GUEST_STACK_SIZE 64
> > > +     unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
> > > +     unsigned long *rsp;
> > > +
> > > +     GUEST_ASSERT(vmx->vmcs_gpa);
> > > +     GUEST_ASSERT(prepare_for_vmx_operation(vmx));
> > > +     GUEST_ASSERT(load_vmcs(vmx));
> > > +     GUEST_ASSERT(ept_1g_pages_supported());
> > > +
> > > +     rsp = &l2_guest_stack[L2_GUEST_STACK_SIZE - 1];
> > > +     *rsp = vcpu_id;
> > > +     prepare_vmcs(vmx, perf_test_l2_guest_entry, rsp);
> >
> > Just to purely ask: is this setting the same stack pointer to all the
> > vcpus?
> 
> No, but I understand the confusion since typically selftests use
> symbols like "l2_guest_code" that are global. But "l2_guest_stack" is
> actually a local variable so it will be allocated on the stack. Each
> vCPU runs on a separate stack, so they will each run with their own
> "l2_guest_stack".

Ahh that's correct!

> 
> >
> > > +
> > > +     GUEST_ASSERT(!vmlaunch());
> > > +     GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
> > > +     GUEST_DONE();
> > > +}
> >
> > [...]
> >
> > > +/* Identity map the entire guest physical address space with 1GiB Pages. */
> > > +void nested_map_all_1g(struct vmx_pages *vmx, struct kvm_vm *vm)
> > > +{
> > > +     __nested_map(vmx, vm, 0, 0, vm->max_gfn << vm->page_shift, PG_LEVEL_1G);
> > > +}
> >
> > Could max_gfn be large?  Could it consumes a bunch of pages even if mapping
> > 1G only?
> 
> Since the selftests only support 4-level EPT, this will use at most
> 513 pages. If we add support for 5-level EPT we may need to revisit
> this approach.

It's just that AFAICT vm_alloc_page_table() is fetching from slot 0 for all
kinds of pgtables including EPT.  I'm not sure whether there can be some
failures conditionally with this because when creating the vm we're not
aware of this consumption, so maybe we'd reserve the pages somehow so that
we'll be sure to have those pages at least?

-- 
Peter Xu

