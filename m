Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A887572A791
	for <lists+kvm@lfdr.de>; Sat, 10 Jun 2023 03:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbjFJBkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 21:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjFJBkB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 21:40:01 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288DAE46;
        Fri,  9 Jun 2023 18:40:00 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 98e67ed59e1d1-256cda5c1c1so952760a91.1;
        Fri, 09 Jun 2023 18:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686361199; x=1688953199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ilYlb2adszjrCfZbp1GJc8mPc6w5JCghOVHqrO8o/h4=;
        b=RBjvFWTHApfdQov2X/c3QLEY084FGbar8zfS02I93bYnC158D+Ip7clwMw7Q/MO4r/
         HP3REa9MgeEA1rl0dyldzmK7wEMCeBSC7hMSjXTG+deCgH9hGEZd6w5ppWTBpFSzOj0i
         +KIige/Cso2qINKwNt6tx1nXK38RG192MwPzytFzwZkJHGN1zcR1GJmuD1857wf3+pjz
         g5eeKJ52l71UFKTDrUFjjPx0HLHLMk6yJVM9Z5byjX1tjOEHNeSgGkzRN8uX3WgaKQjZ
         sveL7H9NsYExURsrdynaeuuW5qWOnz3sjSkB158JYautOSvQz4qoNXEwHjHkzoje00rF
         ATvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686361199; x=1688953199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ilYlb2adszjrCfZbp1GJc8mPc6w5JCghOVHqrO8o/h4=;
        b=Y4I0WWMpvv12KX/kX0zATfZy6pKvO2ebLY3BaqpmuND6k8rQ9w8xH73IxS5F7vqRTy
         CCCPpaz39bnxc8cCy0/S/FsydunTUVupMdZ6FqC8kgJXOLY9KLRZgjaVPrGENBK9vPhl
         QJI5K6vOiXwCcBIhp9dEsmulkkl8XWXfEwGsWhQPzRX/W/JpEccblARMn9IHzF7XDgU3
         AiPCWfoS4LWPe3JAaCmW70/iDAhLSxjpfABxMbyligfu2F9QzzdTdMkRuRJcv0Mg1KsX
         oyKF5WOk7DlairVaYAe6hffom5YtfH9Hzal8FpO5BgoeqNAX0M77nt8oWqoJgNAXRWrA
         exOg==
X-Gm-Message-State: AC+VfDywe2z9nXNQ5F0Y+X97GCm9pHDbrjDRVBS0k0nBnaWIHub07qTw
        grj2vEluxz7yZYaz59VeLRmZNaauz3/TREiGiG8ZgIko+y4=
X-Google-Smtp-Source: ACHHUZ7INTCboDgVuF7P5x88qVN9qFFNzPldzh4k7rPJ9MfdaiyaByfTOjR0AmXqcxHKn97c7V0g5Ol1dqw4qFEvjLA=
X-Received: by 2002:a17:90b:38ca:b0:24d:ff56:f8c1 with SMTP id
 nn10-20020a17090b38ca00b0024dff56f8c1mr2301690pjb.13.1686361199544; Fri, 09
 Jun 2023 18:39:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230605064848.12319-1-jpn@linux.vnet.ibm.com>
 <20230605064848.12319-7-jpn@linux.vnet.ibm.com> <ZIAXpMpjb3V852rB@li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com>
In-Reply-To: <ZIAXpMpjb3V852rB@li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com>
From:   Jordan Niethe <jniethe5@gmail.com>
Date:   Sat, 10 Jun 2023 11:39:47 +1000
Message-ID: <CACzsE9qbRC1JoDFRozspGjxR=nLgJCSE6ygNz-sDfFSDoAjqzw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 6/6] docs: powerpc: Document nested KVM on POWER
To:     Gautam Menghani <gautam@linux.ibm.com>
Cc:     Jordan Niethe <jpn@linux.vnet.ibm.com>, mikey@neuling.org,
        kautuk.consul.1980@gmail.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, npiggin@gmail.com, sbhat@linux.ibm.com,
        vaibhav@linux.ibm.com, linuxppc-dev@lists.ozlabs.org
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

On Wed, Jun 7, 2023 at 3:38=E2=80=AFPM Gautam Menghani <gautam@linux.ibm.co=
m> wrote:
>
> On Mon, Jun 05, 2023 at 04:48:48PM +1000, Jordan Niethe wrote:
> > From: Michael Neuling <mikey@neuling.org>
>
> Hi,
> There are some minor typos in the documentation pointed out below

Thank you, will correct in the next revision.

Jordan
>
>
> > +H_GUEST_GET_STATE()
> > +-------------------
> > +
> > +This is called to get state associated with an L2 (Guest-wide or vCPU =
specific).
> > +This info is passed via the Guest State Buffer (GSB), a standard forma=
t as
> > +explained later in this doc, necessary details below:
> > +
> > +This can set either L2 wide or vcpu specific information. Examples of
>
> We are getting the info about vcpu here : s/set/get
>
> > +H_GUEST_RUN_VCPU()
> > +------------------
> > +
> > +This is called to run an L2 vCPU. The L2 and vCPU IDs are passed in as
> > +parameters. The vCPU run with the state set previously using
>
> Minor nit : s/run/runs
>
> > +H_GUEST_SET_STATE(). When the L2 exits, the L1 will resume from this
> > +hcall.
> > +
> > +This hcall also has associated input and output GSBs. Unlike
> > +H_GUEST_{S,G}ET_STATE(), these GSB pointers are not passed in as
> > +parameters to the hcall (This was done in the interest of
> > +performance). The locations of these GSBs must be preregistered using
> > +the H_GUEST_SET_STATE() call with ID 0x0c00 and 0x0c01 (see table
> > +below).
> > +
> >
> > --
> > 2.31.1
> >
>
