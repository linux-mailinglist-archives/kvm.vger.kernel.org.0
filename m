Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCE66EB1D8
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 20:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbjDUSuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 14:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjDUSuV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 14:50:21 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B775919B4
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 11:50:19 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1a6817adde4so27984655ad.0
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 11:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1682103019; x=1684695019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/IIUhUlmRecN66Z6gik+9JylRPrSHv9qYt9esJpbqSI=;
        b=THDL4+u/vOfwLaOnCW6eh/CjgCzPbUBKAHWf1LgoVb5urObrbbDHtE6LnFnJmkcGbJ
         X8sScn53VOwmiufg6b6vh6lFIqrfOMJmRlqDY7muic2fAlWCCsOBcmJbCjOoIvNUxnTw
         CCi7AskMw6mhK+++me+sRjwikLpeFgIwFV0nF0mmjg428f8Rammes3zg4WwGMq8g786W
         u8Qe//FfgFBTmm/8czZ4ckylnzNPDOezoP2aS60VK1m3/oMe/h5ZP8lwmqiqiNZdCveU
         hRoUCo88MTFudnwN/fMDvgNm+b5CVsDTOcg14bYbIUZFekjOGitMEoCJ5+oTpJJu4z/U
         HanA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682103019; x=1684695019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/IIUhUlmRecN66Z6gik+9JylRPrSHv9qYt9esJpbqSI=;
        b=UQTKp/wDX3FNSuToQ/qi0zndvHpGVrvWlx1987v5XW4z9o4yBKsMmAeAprdfIm49o5
         6TdG8FbjvGm0Z3Wn5lv00fvifEoDAMp5C7pOTzpRmGgJeyUuQ83ycIe8NNFBvh8QHO5L
         D+KUBufLSKjszO+j6HMCrS/SRl57xvSjkeUqZspy69NoOHHTAmC7PMRvvmwHYBQi8+Rn
         W2VQ3We1aJiNJQZhYBKUN79+zZqg3a/ao/lDbadtds8HKrusWvfIQ6iA8q2NduJnEGdB
         3C9bMBQJToi5XBAElpfcT2ewPDhkiznkM1IKAcPhFdnAeWQ3OK1/3XmbxMg0Gq+pexF+
         UIdA==
X-Gm-Message-State: AAQBX9eIfZcvei3gVeZmrxQrmckrNFkL9pGkUuYZev4AdJNFIfl4TZmH
        yUg4E4XPNjcUMF67ZuyA6UY89lteEI3Y6HfPKGVXSA==
X-Google-Smtp-Source: AKy350YdSljDnRrQJM9jfWzeZ/GLttvpy4dWrgL7+90Nmaems+z3L9naUfpMZAy9sq8Fz7lbqPOj5hZdKf+W5l/Qavg=
X-Received: by 2002:a17:902:8501:b0:1a1:f95a:24f2 with SMTP id
 bj1-20020a170902850100b001a1f95a24f2mr5252822plb.19.1682103019136; Fri, 21
 Apr 2023 11:50:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230419221716.3603068-1-atishp@rivosinc.com> <20230419221716.3603068-11-atishp@rivosinc.com>
 <ZEFXiXu+0XLSdRkQ@google.com>
In-Reply-To: <ZEFXiXu+0XLSdRkQ@google.com>
From:   Atish Kumar Patra <atishp@rivosinc.com>
Date:   Sat, 22 Apr 2023 00:20:08 +0530
Message-ID: <CAHBxVyGGsvYrRpx1=ahW-5ALskAQJsgjF=9a=BMreuQov0En6Q@mail.gmail.com>
Subject: Re: [RFC 10/48] RISC-V: KVM: Implement static memory region measurement
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Uladzislau Rezki <urezki@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 20, 2023 at 8:47=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Apr 19, 2023, Atish Patra wrote:
> > +int kvm_riscv_cove_vm_measure_pages(struct kvm *kvm, struct kvm_riscv_=
cove_measure_region *mr)
> > +{
> > +     struct kvm_cove_tvm_context *tvmc =3D kvm->arch.tvmc;
> > +     int rc =3D 0, idx, num_pages;
> > +     struct kvm_riscv_cove_mem_region *conf;
> > +     struct page *pinned_page, *conf_page;
> > +     struct kvm_riscv_cove_page *cpage;
> > +
> > +     if (!tvmc)
> > +             return -EFAULT;
> > +
> > +     if (tvmc->finalized_done) {
> > +             kvm_err("measured_mr pages can not be added after finaliz=
e\n");
> > +             return -EINVAL;
> > +     }
> > +
> > +     num_pages =3D bytes_to_pages(mr->size);
> > +     conf =3D &tvmc->confidential_region;
> > +
> > +     if (!IS_ALIGNED(mr->userspace_addr, PAGE_SIZE) ||
> > +         !IS_ALIGNED(mr->gpa, PAGE_SIZE) || !mr->size ||
> > +         !cove_is_within_region(conf->gpa, conf->npages << PAGE_SHIFT,=
 mr->gpa, mr->size))
> > +             return -EINVAL;
> > +
> > +     idx =3D srcu_read_lock(&kvm->srcu);
> > +
> > +     /*TODO: Iterate one page at a time as pinning multiple pages fail=
 with unmapped panic
> > +      * with a virtual address range belonging to vmalloc region for s=
ome reason.
>
> I've no idea what code you had, but I suspect the fact that vmalloc'd mem=
ory isn't
> guaranteed to be physically contiguous is relevant to the panic.
>

Ahh. That makes sense. Thanks.

> > +      */
> > +     while (num_pages) {
> > +             if (signal_pending(current)) {
> > +                     rc =3D -ERESTARTSYS;
> > +                     break;
> > +             }
> > +
> > +             if (need_resched())
> > +                     cond_resched();
> > +
> > +             rc =3D get_user_pages_fast(mr->userspace_addr, 1, 0, &pin=
ned_page);
> > +             if (rc < 0) {
> > +                     kvm_err("Pinning the userpsace addr %lx failed\n"=
, mr->userspace_addr);
> > +                     break;
> > +             }
> > +
> > +             /* Enough pages are not available to be pinned */
> > +             if (rc !=3D 1) {
> > +                     rc =3D -ENOMEM;
> > +                     break;
> > +             }
> > +             conf_page =3D alloc_page(GFP_KERNEL | __GFP_ZERO);
> > +             if (!conf_page) {
> > +                     rc =3D -ENOMEM;
> > +                     break;
> > +             }
> > +
> > +             rc =3D cove_convert_pages(page_to_phys(conf_page), 1, tru=
e);
> > +             if (rc)
> > +                     break;
> > +
> > +             /*TODO: Support other pages sizes */
> > +             rc =3D sbi_covh_add_measured_pages(tvmc->tvm_guest_id, pa=
ge_to_phys(pinned_page),
> > +                                              page_to_phys(conf_page),=
 SBI_COVE_PAGE_4K,
> > +                                              1, mr->gpa);
> > +             if (rc)
> > +                     break;
> > +
> > +             /* Unpin the page now */
> > +             put_page(pinned_page);
> > +
> > +             cpage =3D kmalloc(sizeof(*cpage), GFP_KERNEL_ACCOUNT);
> > +             if (!cpage) {
> > +                     rc =3D -ENOMEM;
> > +                     break;
> > +             }
> > +
> > +             cpage->page =3D conf_page;
> > +             cpage->npages =3D 1;
> > +             cpage->gpa =3D mr->gpa;
> > +             cpage->hva =3D mr->userspace_addr;
>
> Snapshotting the userspace address for the _source_ page can't possibly b=
e useful.
>

Yeah. Currently, the hva in the kvm_riscv_cove_page is not used
anywhere in the code. We can remove it.

> > +             cpage->is_mapped =3D true;
> > +             INIT_LIST_HEAD(&cpage->link);
> > +             list_add(&cpage->link, &tvmc->measured_pages);
> > +
> > +             mr->userspace_addr +=3D PAGE_SIZE;
> > +             mr->gpa +=3D PAGE_SIZE;
> > +             num_pages--;
> > +             conf_page =3D NULL;
> > +
> > +             continue;
> > +     }
> > +     srcu_read_unlock(&kvm->srcu, idx);
> > +
> > +     if (rc < 0) {
> > +             /* We don't to need unpin pages as it is allocated by the=
 hypervisor itself */
>
> This comment makes no sense.  The above code is doing all of the allocati=
on and
> pinning, which strongly suggests that KVM is the hypervisor.  But this co=
mment
> implies that KVM is not the hypervisor.
>

I mean to say here the conf_page is allocated in the kernel using
alloc_page. So no pinning/unpinning is required.
It seems the comment is probably misleading & confusing at best. I
will remove it.

> And "pinned_page" is cleared unpinned in the loop after the page is added=
+measured,
> which looks to be the same model as TDX where "pinned_page" is the source=
 and
> "conf_page" is gifted to the hypervisor.  But on failure, e.g. when alloc=
ating
> "conf_page", that reference is not put.
>

Thanks. Will fix it.

> > +             cove_delete_page_list(kvm, &tvmc->measured_pages, false);
> > +             /* Free the last allocated page for which conversion/meas=
urement failed */
> > +             kfree(conf_page);
>
> Assuming my guesses about how the architecture works are correct, this is=
 broken
> if sbi_covh_add_measured_pages() fails. The page has already been gifted =
to the

Yeah. The last conf_page should be reclaimed as well if measured_pages
fail at any point in the loop.
All other allocated ones would be reclaimed as a part of cove_delete_page_l=
ist.



> TSM by cove_convert_pages(), but there is no call to sbi_covh_tsm_reclaim=
_pages(),
> which I'm guessing is necesary to transition the page back to a state whe=
re it can
> be safely used by the host.
