Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2B8E712AD2
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 18:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236628AbjEZQjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 12:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbjEZQjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 12:39:10 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1387AD9
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 09:39:09 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-64d1c53cad8so1286340b3a.3
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 09:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685119148; x=1687711148;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UJLVDfVcn1dj/LbHO26In0hwpTHbWx8n0yVQTbJTXzg=;
        b=uTc7NtyrJIEyihrMxask05V/8VG2zI54ut3YHZH3bNGS8o2g4nwve/x4KAOzLEoS1S
         IXAZ1PG6u3KIHoMgF2pxBeM9CIX51efUEhyvbRBMIjPJHP4gF82/09htMUKnre97au7c
         9/YztOVxQ38bgMzDxrFWa4RSrFDpstbFQmfrmKuoA9Zvv/5CEbOgGmFuNPMRdOc2MgIH
         MPlXg1ZAmV7sMmcpp9+sAjRnWt/Bx8WQvXohGS+YrTxYFDQo0JZRWpWwT2UVpH5tByzH
         rJctbSVbe6+xxofPqBfd1eaEYXTt5bOWaQINBB5t1/Ja2Dn3jOJjFxLwREgwVsntHcvt
         BHQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685119148; x=1687711148;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UJLVDfVcn1dj/LbHO26In0hwpTHbWx8n0yVQTbJTXzg=;
        b=W/wBQgQ+d1XPRDCe8w83ohM9ld7AgWgfs2oxh3NRL4/VxgghaozNkK7rtJeVQUsQ9d
         X1cvIjAE5gYHtF14DZ8o1Zxv5gx9i9uW/IzM30ajNKsTmgOFr3NAlYE3nqzM0btERPKD
         cX/2fPMkc2rB5q9cpOF+z88YkKzTpTq1ylRh19E3Mg7iXDLs5cNRGTGpiKjNJSVy1bmO
         3jMGBh2f8o5oaDtA/Ug/Bbl/DCcKBCsNi66ZHh8fBnK5OdA4ED0EGtk2omqLavqqfinw
         w/mbJEOTa1gUO+ozeh/+16IaJFkrWG3b9BZwA5MrpWrP5EG7HPV1HT3+wD0Enb3PDBdx
         c38g==
X-Gm-Message-State: AC+VfDyuQl+QkU1SwJ+/7EbFRRrKoEomGWaL9xGLnjskMH9+RN2ZKT3w
        GpWTJ0+m1jgUHc7kfV66Wy/whIvQEuU=
X-Google-Smtp-Source: ACHHUZ5QYr0thV6h4ep+7aFHrM+wG92KDcxf5yGJHUgF2QP+dKoaQKUqvtTI2JkrWIJxDvQv6/G6qOf4Kz4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:15d4:b0:643:a029:5b3f with SMTP id
 o20-20020a056a0015d400b00643a0295b3fmr1135381pfu.2.1685119148597; Fri, 26 May
 2023 09:39:08 -0700 (PDT)
Date:   Fri, 26 May 2023 09:39:06 -0700
In-Reply-To: <88db2d9cb42e471692ff1feb0b9ca855906a9d95.camel@amazon.com>
Mime-Version: 1.0
References: <2f19f26e-20e5-8198-294e-27ea665b706f@redhat.com> <88db2d9cb42e471692ff1feb0b9ca855906a9d95.camel@amazon.com>
Message-ID: <ZHDflnVNGw1fN6VD@google.com>
Subject: Re: [ANNOUNCE] KVM Microconference at LPC 2023
From:   Sean Christopherson <seanjc@google.com>
To:     James Gowans <jgowans@amazon.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "maz@kernel.org" <maz@kernel.org>, Alexander Graf <graf@amazon.de>,
        Nicolas Saenz Julienne <nsaenz@amazon.es>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 26, 2023, James Gowans wrote:
> On Tue, 2023-05-09 at 11:55 +0200, Paolo Bonzini wrote:
> > Hi all!
> > 
> > We are planning on submitting a CFP to host a KVM Microconference at
> > Linux Plumbers Conference 2023. To help justify the proposal, we would
> > like to gather a list of folks that would likely attend, and crowdsource
> > a list of topics to include in the proposal.
> 
> Hi Paolo,
> 
> This MC sounds great! There are two topics I'd be keen to discuss, both in
> the KVM + memory-management realm:
> 
> 1. Guest and kernel memory persistence across kexec for live update.
> Specifically focussing on the host IOMMU pgtable persistence for DMA-
> passthrough devices to support kexec while guest-driven DMA is still
> running. There is some discussion happening now about this [1] and
> hopefully the discussion and prototyping will continue in the run up to
> LPC.

I don't think a KVM MC conference would be the right venue for this discussion.
IIUC, KVM does not need to be involved in preserving guest memory or the IOMMU
page tables.

> 2. Supporting more fine-grain memory management and access control APIs
> for the virtualisation case specifically, for use-cases around live
> migration, memory oversubscription, and "side-car" virtual machines. These
> use cases would benefit from kernel support for things like dynamically
> updating IOMMU and MMU permissions independently at fine granularity, all
> without actually modifying the VMAs, to support fine-grain handling. And
> linking this topic to the one above: being able to do these things when
> not backed by struct pages. (There may be some overlap with "KVM guest
> private memory" [2] here...)

Yes, there's overlap with guest private memory.  Though I actually think we should
start viewing it as "guest first" memory (I'm mentally thinking of it as guest_memfd()),
since there are potential benefits and applications beyond CoCo VMs for guest memory
that doesn't *need* to be mapped into host userspace.  If the guest_memfd() idea comes
to fruition, then KVM would *need* a way to specify guest memory protections without
VMAs.  So yes, definitely overlap :-)

If y'all are interested, guest_memfd() is the topic of discussion for the inaugural
KVM upstream call (PUCK)[*].  I would also be more than happy to carve out a PUCK
instance to discuss non-VMA-based MMU protections, i.e. we don't have to wait until
LPC to start hashing out the KVM API(s) and implementation.

[*] https://lore.kernel.org/all/20230525234735.2585977-1-seanjc@google.com
