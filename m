Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44ED572A81C
	for <lists+kvm@lfdr.de>; Sat, 10 Jun 2023 04:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjFJCJ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 22:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjFJCJ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 22:09:28 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2E23AB0;
        Fri,  9 Jun 2023 19:09:25 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-256766a1c43so972222a91.1;
        Fri, 09 Jun 2023 19:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686362965; x=1688954965;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bzxRcpw4+ZEWXPEqFdyS15H0sI/WzpxpiRc3HFoUV2k=;
        b=GQ6TrDJEbBI/uniZZnThSxIk6jHYB/GZmht92m1Ojph+wU7l8vfKX338ygpjsPHiHt
         o6TAD8tkUX562GMmn6EPUuFNb1TvqzCle4GCbqbvfYTEBu8FXRDb7NzJeySe6Py2QTrl
         GySaXwuGblckPybdVZU8gX9S5FGG7fw+NpARFkCfMhDs3AnDZxkIYxF5W7nW7gqCqtJu
         Tdp227yEWLGdVA6G18lyLUwpu6yj2D8zWNXTh/forWmnjk47NQxdRt5O4UrXVrPQ4MQs
         TtYiftVq5t/cLd/tsoC0fpnrM+hRG8XsnxrGxU386aMXzjLDGyN4xKUEzNSwkP78WOaz
         +Sow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686362965; x=1688954965;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bzxRcpw4+ZEWXPEqFdyS15H0sI/WzpxpiRc3HFoUV2k=;
        b=G9U5/oISsq9z3YgfbMYSY+wr0XUJlx/C1fWl1qukcWHQAK7koCoPtGMy0KHAcGmyDa
         K3TdpWNrnwt6nxFOLW2lBRIV5c4jukOlLnTArIAVk7YZCeBH75/8VoPqpBOnR/vLytqw
         WuH64BxCBFyHMFMNcFrenmhAY6PD3ZvR/ENCo0iK4StsWz9VQB7e7B3cLhA9DEet9lxg
         rMOuhcIJZaQ0qdqXrI4y64JtOkN9Mz/jnRClvCSMzaVqBVncm56am0xOOHpoBQf+Hzaj
         VRmRVOk1JtpjW5MeY5ZkGY0P0ruJaYDdeC2E2B2mxiw4pcReX0QX/MWuebJia1NbD9dZ
         SjZQ==
X-Gm-Message-State: AC+VfDzUy+IoUunD/NQ1YXxuDdkR8ubzUC/npt24Z1Nu4FNgDoccQJoV
        1oatdcDcECBP/nm39g8BhcR3XibXukePLf/2oZs=
X-Google-Smtp-Source: ACHHUZ6WczddxpBZd3UvJalFm+pPiTsKjJD1hroOFr70G8i4dQ+j9gDf+010cjamWgmFZZBYFpSt/7S0xtRxJ65pqU8=
X-Received: by 2002:a17:90a:c58b:b0:24d:ec16:6f8c with SMTP id
 l11-20020a17090ac58b00b0024dec166f8cmr2355468pjt.20.1686362965252; Fri, 09
 Jun 2023 19:09:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230605064848.12319-1-jpn@linux.vnet.ibm.com>
 <20230605064848.12319-5-jpn@linux.vnet.ibm.com> <CT69X8Q3NVVO.GXEUNFGVDL08@wheely>
In-Reply-To: <CT69X8Q3NVVO.GXEUNFGVDL08@wheely>
From:   Jordan Niethe <jniethe5@gmail.com>
Date:   Sat, 10 Jun 2023 12:09:13 +1000
Message-ID: <CACzsE9o5a-hMoLO_DeqvCNQh5b=hWLd28hbTwZDY7621PrVTGg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/6] KVM: PPC: Add helper library for Guest State Buffers
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Jordan Niethe <jpn@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, mikey@neuling.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, sbhat@linux.ibm.com,
        vaibhav@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 7, 2023 at 6:27=E2=80=AFPM Nicholas Piggin <npiggin@gmail.com> =
wrote:
[snip]
>
> This is a tour de force in one of these things, so I hate to be
> the "me smash with club" guy, but what if you allocated buffers
> with enough room for all the state (or 99% of cases, in which
> case an overflow would make an hcall)?
>
> What's actually a fast-path that we don't get from the interrupt
> return buffer? Getting and setting a few regs for MMIO emulation?

As it is a vcpu uses four buffers:

- One for registering it's input and output buffers
   This is allocated just large enough for GSID_RUN_OUTPUT_MIN_SIZE,
   GSID_RUN_INPUT and GSID_RUN_OUTPUT.
   Freed once the buffers are registered.
   I suppose we could just make a buffer big enough to be used for the
vcpu run input buffer then have it register its own address.

- One for process and partition table entries
   Because kvmhv_set_ptbl_entry() isn't associated with a vcpu.
   kvmhv_papr_set_ptbl_entry() allocates and frees a minimal sized
buffer on demand.

- The run vcpu input buffer
   Persists over the lifetime of the vcpu after creation. Large enough
to hold all VCPU-wide elements. The same buffer is also reused for:

     * GET state hcalls
     * SET guest wide state hcalls (guest wide can not be passed into
the vcpu run buffer)

- The run vcpu output buffer
   Persists over the lifetime of the vcpu after creation. This is
sized to be GSID_RUN_OUTPUT_MIN_SIZE as returned by the L0.
   It's unlikely that it would be larger than the run vcpu buffer
size, so I guess you could make it that size too. Probably you could
even use the run vcpu input buffer as the vcpu output buffer.

The buffers could all be that max size and could combine the
configuration buffer, input and output buffers, but I feel it's more
understandable like this.

[snip]

>
> The namespaces are a little abbreviated. KVM_PAPR_ might be nice if
> you're calling the API that.

Will we go with KVM_NESTED_V2_ ?

>
> > +
> > +#define GSID_HOST_STATE_SIZE         0x0001 /* Size of Hypervisor Inte=
rnal Format VCPU state */
> > +#define GSID_RUN_OUTPUT_MIN_SIZE     0x0002 /* Minimum size of the Run=
 VCPU output buffer */
> > +#define GSID_LOGICAL_PVR             0x0003 /* Logical PVR */
> > +#define GSID_TB_OFFSET                       0x0004 /* Timebase Offset=
 */
> > +#define GSID_PARTITION_TABLE         0x0005 /* Partition Scoped Page T=
able */
> > +#define GSID_PROCESS_TABLE           0x0006 /* Process Table */
>
> > +
> > +#define GSID_RUN_INPUT                       0x0C00 /* Run VCPU Input =
Buffer */
> > +#define GSID_RUN_OUTPUT                      0x0C01 /* Run VCPU Out Bu=
ffer */
> > +#define GSID_VPA                     0x0C02 /* HRA to Guest VCPU VPA *=
/
> > +
> > +#define GSID_GPR(x)                  (0x1000 + (x))
> > +#define GSID_HDEC_EXPIRY_TB          0x1020
> > +#define GSID_NIA                     0x1021
> > +#define GSID_MSR                     0x1022
> > +#define GSID_LR                              0x1023
> > +#define GSID_XER                     0x1024
> > +#define GSID_CTR                     0x1025
> > +#define GSID_CFAR                    0x1026
> > +#define GSID_SRR0                    0x1027
> > +#define GSID_SRR1                    0x1028
> > +#define GSID_DAR                     0x1029
>
> It's a shame you have to rip up all your wrapper functions now to
> shoehorn these in.
>
> If you included names analogous to the reg field names in the kvm
> structures, the wrappers could do macro expansions that get them.
>
> #define __GSID_WRAPPER_dar              GSID_DAR
>
> Or similar.

Before I had something pretty hacky, in the macro accessors I had
along the lines of

     gsid_table[offsetof(vcpu, reg)]

to get the GSID for the register.

We can do the wrapper idea, I just worry if it is getting too magic.

>
> And since of course you have to explicitly enumerate all these, I
> wouldn't mind defining the types and lengths up-front rather than
> down in the type function. You'd like to be able to go through the
> spec and eyeball type, number, size.

Something like
#define KVM_NESTED_V2_GS_NIA (KVM_NESTED_V2_GSID_NIA | VCPU_WIDE |
READ_WRITE | DOUBLE_WORD)
etc
?

>
> [snip]
>
> > +/**
> > + * gsb_paddress() - the physical address of buffer
> > + * @gsb: guest state buffer
> > + *
> > + * Returns the physical address of the buffer.
> > + */
> > +static inline u64 gsb_paddress(struct gs_buff *gsb)
> > +{
> > +     return __pa(gsb_header(gsb));
> > +}
>
> > +/**
> > + * __gse_put_reg() - add a register type guest state element to a buff=
er
> > + * @gsb: guest state buffer to add element to
> > + * @iden: guest state ID
> > + * @val: host endian value
> > + *
> > + * Adds a register type guest state element. Uses the guest state ID f=
or
> > + * determining the length of the guest element. If the guest state ID =
has
> > + * bits that can not be set they will be cleared.
> > + */
> > +static inline int __gse_put_reg(struct gs_buff *gsb, u16 iden, u64 val=
)
> > +{
> > +     val &=3D gsid_mask(iden);
> > +     if (gsid_size(iden) =3D=3D sizeof(u64))
> > +             return gse_put_u64(gsb, iden, val);
> > +
> > +     if (gsid_size(iden) =3D=3D sizeof(u32)) {
> > +             u32 tmp;
> > +
> > +             tmp =3D (u32)val;
> > +             if (tmp !=3D val)
> > +                     return -EINVAL;
> > +
> > +             return gse_put_u32(gsb, iden, tmp);
> > +     }
> > +     return -EINVAL;
> > +}
>
> There is a clever accessor that derives the length from the type, but
> then you fall back to this.

It's basically just to massage where we have a kvm representation and
guest state buffer representation mismatch:

Like: unsigned long ccr; being 8 bytes and having 4 byte CR in the spec.

>
> > +/**
> > + * gse_put - add a guest state element to a buffer
> > + * @gsb: guest state buffer to add to
> > + * @iden: guest state identity
> > + * @v: generic value
> > + */
> > +#define gse_put(gsb, iden, v)                                        \
> > +     (_Generic((v),                                          \
> > +               u64 : __gse_put_reg,                          \
> > +               long unsigned int : __gse_put_reg,            \
> > +               u32 : __gse_put_reg,                          \
> > +               struct gs_buff_info : gse_put_buff_info,      \
> > +               struct gs_proc_table : gse_put_proc_table,    \
> > +               struct gs_part_table : gse_put_part_table,    \
> > +               vector128 : gse_put_vector128)(gsb, iden, v))
> > +
> > +/**
> > + * gse_get - return the data of a guest state element
> > + * @gsb: guest state element to add to
> > + * @v: generic value pointer to return in
> > + */
> > +#define gse_get(gse, v)                                              \
> > +     (*v =3D (_Generic((v),                                    \
> > +                     u64 * : __gse_get_reg,                  \
> > +                     unsigned long * : __gse_get_reg,        \
> > +                     u32 * : __gse_get_reg,                  \
> > +                     vector128 * : gse_get_vector128)(gse)))
>
> I don't see the benefit of this. Caller always knows the type doesn't
> it? It seems like the right function could be called directly. It
> makes the calling convention a bit clunky too. I know there's similar
> precedent for uaccess functions, but not sure I like it for this.

The compiler also knows so I just thought I'd save some typing.
I agree it's kind of ugly, happy to drop it.

[snip]
>
> Should all be GPL exports.
>
> Needs more namespace too, I reckon (not just exports but any kernel-wide
> name this short and non-descriptive needs a kvmppc or kvm_papr or
> something).

Will do.

Thanks,
Jordan

>
> Thanks,
> Nick
>
