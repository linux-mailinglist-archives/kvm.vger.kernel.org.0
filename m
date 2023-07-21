Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A0C75D0E0
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 19:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjGURuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 13:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjGURuN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 13:50:13 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB8B30F5
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 10:50:08 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d00a63fcdefso1479674276.3
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 10:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689961807; x=1690566607;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cGq520d0DqyrCnCF7s5Hdb0rD6NYwtkYzvVScy9HYVY=;
        b=lZQ3ytVABaMbgeRDyRyj2Y4aroG9rwZE4tos1KIi9+yVur8kHjUJfNDjBsWbA5klWv
         TLcM88saeccS8fNt+F3rMDPeeLUphdScBaSRyrIwijc1R9havyOwlUNE/IQcuJNK+B8L
         fg4nRh9mVWUewpR8WoS4y2UShReGqGQI/p2sPXI0/xi9S/4bLyRSoR+wjHm8ngFldPX/
         svRbdc4YBfOK5kZ24vC9n3F8L7Li2/2X6A5zsHfs5DeCFBQGgpDd6R/Lv+3ONLhdKh+D
         zucg4UeBA4sEAN2XLHlR2RolIKqE8NS9aws4SoQANyJbQckavpkDoby1VzLjItanYN4z
         z0Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689961807; x=1690566607;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cGq520d0DqyrCnCF7s5Hdb0rD6NYwtkYzvVScy9HYVY=;
        b=eg2lcTF9US4oYTh4e78om4nWQza7j0MdbxkOggoXtdto4TzaX4fehUbM2G74Eo6p39
         UlTjQMMKM0y3IwVrpkpW/L3Pf9l2AzwEBEJYkSeAwdquvhSne71irZWfoiLtGIalnysY
         d5qQIB6BTLFnhaTEChI2q2u9vPfZSzPNB8updHBzRfEDglFWqvCRP84WE6OuO6llPzRE
         v4uB84PLuvdWxUE7Vna769t2yThN0UP8B5rssV6EoFBM9rASGLXK+t27aEzuTep0V+cg
         kM9rgNDgJtJMpdwoDeRkoutekIJrUdvFhbUiqLUe0h+1UyJvTM1RC7BXyeYEqozW2Cc9
         G9hw==
X-Gm-Message-State: ABy/qLadQOjL1rS+4RLcenQdnaU68IQ4VIB5EksVkp9NJZre6mVkTNWM
        IrdGJsF3af0MOp0tX9Yn8OXoHVCQKxo=
X-Google-Smtp-Source: APBJJlGQVjm5RzrpH36bdluvnqR1OmovIF/Mv2HtKZQ0PUD+Zj6xyTxIa85gQ91Vm5Bag6YHDA7hXUEb4so=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10cd:b0:c1c:df23:44ee with SMTP id
 w13-20020a05690210cd00b00c1cdf2344eemr19769ybu.0.1689961807734; Fri, 21 Jul
 2023 10:50:07 -0700 (PDT)
Date:   Fri, 21 Jul 2023 10:50:06 -0700
In-Reply-To: <8ad7a846-64e9-a3f1-4bf1-731a994d62cb@redhat.com>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com> <20230718234512.1690985-13-seanjc@google.com>
 <8ad7a846-64e9-a3f1-4bf1-731a994d62cb@redhat.com>
Message-ID: <ZLrFTq2f1NXtlJWd@google.com>
Subject: Re: [RFC PATCH v11 12/29] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 21, 2023, Paolo Bonzini wrote:
> On 7/19/23 01:44, Sean Christopherson wrote:
> > +	inode = alloc_anon_inode(mnt->mnt_sb);
> > +	if (IS_ERR(inode))
> > +		return PTR_ERR(inode);
> > +
> > +	err = security_inode_init_security_anon(inode, &qname, NULL);
> > +	if (err)
> > +		goto err_inode;
> > +
> 
> I don't understand the need to have a separate filesystem.  If it is to
> fully setup the inode before it's given a struct file, why not just export
> anon_inode_make_secure_inode instead of security_inode_init_security_anon?

Ugh, this is why comments are important, I can't remember either.

I suspect I implemented a dedicated filesystem to kinda sorta show that we could
allow userspace to provide the mount point with e.g. NUMA hints[*].  But my
preference would be to not support a userspace provided mount and instead implement
fbind() to let userspace control NUMA and whatnot.

[*] https://lore.kernel.org/all/ef48935e5e6f947f6f0c6d748232b14ef5d5ad70.1681176340.git.ackerleytng@google.com
