Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885706BE9CA
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 14:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjCQNDH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 09:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCQNDF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 09:03:05 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1B61ACC2;
        Fri, 17 Mar 2023 06:03:04 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id y19so2826012pgk.5;
        Fri, 17 Mar 2023 06:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679058184;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ywu7g+5i4JW2WWe/jt88w5+leiQxgW3upihw/iKd5+U=;
        b=qMOpeC0sL+5hYR2dxRV2qcHEE3DvWwo2nD3N8Sy12tC0Wkqw2sbU3F+MbSo2qDMTiz
         yLnFbehLR0RSzSR8NK2Lu5Su4iU9DILMD5P46ZI+eggWNetcT2gh08iJqlvu9saclf9w
         FAvbdEBzmP2avkR3WybqKd85KQjmrG0rX6Pzl/R8j0tAkLE5b00sBJGTn7kHHcCDnr20
         XiB7CMveJo6nyzNoytB165W5FwTA+/1tS+9wJCeyO61QUYmXRVJB7VDsU5y8hqIGwVzc
         CPLTbSGbVvmru4eWEFhDuQ6Lkts37tueqsLXxsVbcqxGRIZZoKa/p5o7dF9IaXWZfhpG
         zCHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679058184;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ywu7g+5i4JW2WWe/jt88w5+leiQxgW3upihw/iKd5+U=;
        b=hKKPttKUe1z+T3AlJjjQQEh5qTpODnz+nHCm15jPUcdtehDnikfMLaYdE46WfqkRxd
         HFd8JbrH92kCPKH1af9SNvMtBi6YPs63KOV9pHYhtqESKYkEb0XliM9B6NNu1ix5F8zk
         4ViDriVO9g0l+ws7o9CWZcEyYtaGJEnieGg2yHUxvTF1ekcQo+R3FG1qJGN3lsyu4c1w
         UVNMr+KcMyAKtl9yyRhSe23EN7nrshw4ATz26o7NQSCiY+LcwI3Rc4ItS8qNuuRUS93p
         9tdk/LtGLCGyMg96Q5tyQavFU4qqwpX1wcbKRcp8J3YZFEjS9VCP+JwndXrHAFlonjNl
         HLiA==
X-Gm-Message-State: AO0yUKWGuKnHEblJp7DJsidcvQWiPISGXI+2xzCh8ACkdUtxXWw4xhqX
        gUYcgJmNP/WjVO9oDA1/PQfCyRwyXSljbvn2aEk=
X-Google-Smtp-Source: AK7set8X1CgjoJPH6S6fX/XGqxGKXoIkxKViJd8c+UIHcRiSX069x+YtTbQzanP2Dyy1soSxpoAGGkuJEruB+XZv7/U=
X-Received: by 2002:a65:4349:0:b0:502:fd71:d58c with SMTP id
 k9-20020a654349000000b00502fd71d58cmr1914625pgq.9.1679058184302; Fri, 17 Mar
 2023 06:03:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230307023946.14516-1-xin3.li@intel.com> <20230307023946.14516-29-xin3.li@intel.com>
 <CAJhGHyC6LgCwdDTkiy2TaQ8wzBQQfrx8ni7fY8vH-bUT2kR8pg@mail.gmail.com> <ed318bd6-25b2-efcf-0cc4-c57699f6654a@citrix.com>
In-Reply-To: <ed318bd6-25b2-efcf-0cc4-c57699f6654a@citrix.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Fri, 17 Mar 2023 21:02:52 +0800
Message-ID: <CAJhGHyAdyqWp_W3yHMn0euYG9TMctpSmNnqr_e+=FR3rN5UzpA@mail.gmail.com>
Subject: Re: [PATCH v5 28/34] x86/fred: fixup fault on ERETU by jumping to fred_entrypoint_user
To:     andrew.cooper3@citrix.com
Cc:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
        pbonzini@redhat.com, ravi.v.shankar@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023 at 5:56=E2=80=AFPM <andrew.cooper3@citrix.com> wrote:
>
> On 17/03/2023 9:39 am, Lai Jiangshan wrote:
> >> +#ifdef CONFIG_X86_FRED
> >> +static bool ex_handler_eretu(const struct exception_table_entry *fixu=
p,
> >> +                            struct pt_regs *regs, unsigned long error=
_code)
> >> +{
> >> +       struct pt_regs *uregs =3D (struct pt_regs *)(regs->sp - offset=
of(struct pt_regs, ip));
> >> +       unsigned short ss =3D uregs->ss;
> >> +       unsigned short cs =3D uregs->cs;
> >> +
> >> +       fred_info(uregs)->edata =3D fred_event_data(regs);
> >> +       uregs->ssx =3D regs->ssx;
> >> +       uregs->ss =3D ss;
> >> +       uregs->csx =3D regs->csx;
> >> +       uregs->current_stack_level =3D 0;
> >> +       uregs->cs =3D cs;
> > Hello
> >
> > If the ERETU instruction had tried to return from NMI to ring3 and just=
 faulted,
> > is NMI still blocked?
> >
> > We know that IRET unconditionally enables NMI, but I can't find any clu=
e in the
> > FRED's manual.
> >
> > In the pseudocode of ERETU in the manual, it seems that NMI is only ena=
bled when
> > ERETU succeeds with bit28 in csx set.  If so, this code will fail to re=
enable
> > NMI if bit28 is not explicitly re-set in csx.
>
> IRET clearing NMI blocking is the source of an immense amount of grief,
> and ultimately the reason why Linux and others can't use supervisor
> shadow stacks at the moment.
>
> Changing this property, so NMIs only get unblocked on successful
> execution of an ERET{S,U}, was a key demand of the FRED spec.
>
> i.e. until you have successfully ERET*'d, you're still logically in the
> NMI handler and NMIs need to remain blocked even when handling the #GP
> from a bad ERET.
>

Handling of the #GP for a bad ERETU can be rescheduled. It is not
OK to reschedule with NMI blocked.

I think "regs->nmi =3D 1;" (not uregs->nmi) can fix the problem.
