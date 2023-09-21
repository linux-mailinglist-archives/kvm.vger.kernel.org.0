Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEFFD7A9668
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 19:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjIURG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 13:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjIURGU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 13:06:20 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F18719BA
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:03:42 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id e9e14a558f8ab-34fc965c70bso6694115ab.2
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695315739; x=1695920539; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VFujV55InQpfIcmwhWIdcFo9LOSK6bP3ULKilR3pEPA=;
        b=c+ocjZ+p3SRKVG3FA+6t9yrbdZXKUcHRMdV0Og6puHb56LV4m0/rL+TrxxQF1YUe69
         noENgRxCGdsPaD7hEfRmCS0FwjVXB60FAY+vEXZCy64t2/p2OB3KSjTN+tfVqYnONq3d
         q9BlVLRtb1FzJzFmCrFxLmcuTGk8LxOgBEhhxK5BpIdav4+9qhcW/V+6g2x0jb+Vs88L
         XdvYAaGzufIRGw3rByN2eT5PB13wMVQ2OeVvDFTkK6MY1pr9Rml+b+oGBKclu6kppTrG
         Am76ZRcOqEyU8iEIc12jfeAeC4T7PuJ4aUo94UIYvbgq1qIEKYPsqDgh5ZfLcydUCTqB
         Q2FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695315739; x=1695920539;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VFujV55InQpfIcmwhWIdcFo9LOSK6bP3ULKilR3pEPA=;
        b=m8JMOBISPK7OOdJDMxWhsiZ4SH75foFxmlcKgHohyf+UcWDS1fBLxey6+LMBcH52/+
         PQdYIrDUlQCsm8F3Q4+AQDw7mnx2Agk4XEltL8Koo6d2ER4lkcH6eWFlHpT4I4arYkIv
         oFALRSF02Hh733yVHgTzxMSiAtWl0+7coe9n8yrVjcg1Nn0vOv5S5sgfkI6oAKvIyI29
         KOsJzBFtmxqG3CnYyKcVwU33NzhfhI3nF6WO/lezdpobwrZdd+FMCKspbY3XlW+n/MVP
         S9MaEvNw6p2o8yXIsm0SxTS6u2gVpGWPVnKj4JTcZkt5j/Cnqa6Kbuf3+g6trSbx2t0n
         wt6g==
X-Gm-Message-State: AOJu0Yyf2/eJiqp+OJG/8kM5nGdZ4QTO4jrYJmhZsfg+SRX6XstWGOH7
        Nbdm79P+xcC9oCwYw0SieBonurocvYo=
X-Google-Smtp-Source: AGHT+IGn6bxt0aytyfRrQvdNGXaSXeT8sIcIptWMB2qfEas65NY2TcrLdWuDyigFBOjNZ28AUG3erUeC33s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ce86:b0:1c3:c127:558 with SMTP id
 f6-20020a170902ce8600b001c3c1270558mr71199plg.0.1695306271120; Thu, 21 Sep
 2023 07:24:31 -0700 (PDT)
Date:   Thu, 21 Sep 2023 07:24:29 -0700
In-Reply-To: <ZQus1v3AvEZjuat9@yilunxu-OptiPlex-7050>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-3-seanjc@google.com>
 <ZQqMBEL61p739dpF@yilunxu-OptiPlex-7050> <ZQr5uXhV6Cnx4DYT@google.com> <ZQus1v3AvEZjuat9@yilunxu-OptiPlex-7050>
Message-ID: <ZQxSHXIGdWXy+zDU@google.com>
Subject: Re: [RFC PATCH v12 02/33] KVM: Use gfn instead of hva for mmu_notifier_retry
From:   Sean Christopherson <seanjc@google.com>
To:     Xu Yilun <yilun.xu@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
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
        Anish Moorthy <amoorthy@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023, Xu Yilun wrote:
> When the invalidation acrosses multiple slots, I'm not sure if the
> contiguous HVA range must correspond to contiguous GFN range. If not,
> are we producing a larger range than required?

Multiple invalidations are all but guaranteed to yield a range that covers addresses
that aren't actually being invalidated.  This is true today.

> And when the invalidation acrosses multiple address space, I'm almost
> sure it is wrong to merge GFN ranges from different address spaces. 

It's not "wrong" in the sense that false positives do not cause functional
problems, at worst a false positive can unnecessarily stall a vCPU until the
unrelated invalidations complete.

Multiple concurrent invalidations are not common, and if they do happen, they are
likely related and will have spacial locality in both host virtual address space
and guest physical address space.  Given that, we chose for the simple (and fast!)
approach of maintaining a single all-encompassing range.
