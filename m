Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F46577C3A7
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 00:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbjHNWww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 18:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233382AbjHNWwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 18:52:22 -0400
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEDB11D
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 15:52:19 -0700 (PDT)
Received: by mail-vk1-xa32.google.com with SMTP id 71dfb90a1353d-48719771d3fso3747214e0c.0
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 15:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692053539; x=1692658339;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jUxtb4YcEahALEPzkewfUVlfVRSRxTtCx1V6b30IuOk=;
        b=M2gZPj3hUNjjGTYRuuz+l20p4fc6MnM6kZ2Abp8ZLMXqfIeWjk2eowsijdKzm1RvJ0
         W+XJG2Bh9oveiyhYPVXgGAP6SlN7hqyNW24dCy4CcITleCNYaL5gpaNLn1GY4NumXHYB
         M6j95HfVYuGuFB8wo+cAeunyax1nHyuFevnBSZ/RCLoNaWA8dV9nlRB+LHLr6f8mR98A
         oXazUil6qim5dY1/Pjwe9/8UY40LVunC7/KwGDdF0DHs0GRIa4xNEE3zX+wBPMrh+HET
         7NLvAK3YieZgbq3UZkwHxaZ2jDYjIrNpxcxlvkt7BimiXe+DclF8hZkBUcAbFCu/JsTk
         4K/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692053539; x=1692658339;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jUxtb4YcEahALEPzkewfUVlfVRSRxTtCx1V6b30IuOk=;
        b=jn4Ro5kLvkzr6+HRC+rQvAAXvQXE8KVqKAkTL99ncpuw45iaMpwe1Wk1IQjl5F/Ryr
         LVbcQZ8vEPxh2wL3afvyidpn2uR5kL3v+wUPi4ujFuQLkF5osAlO9zCeeFNQKvBDN3sp
         6uQSUakCQ2TPeRyndU9bD2wqBSOAfiggKjBHNvpTFn0gKv+pfQHDGxu8S2GGEgGYQNlU
         cdu/7fs3YB/RBMTIIR1goVxgSwtggqj6JMZ85n2ARefCBNODziRkme/XFNfGeN6Np7Ma
         IBYat6mUcJOXEFJNeNV6GzpmCQRo89QfNMqFv7cptEF7v7YHLbJBU3lQo1cY0Bvz/Azx
         z98Q==
X-Gm-Message-State: AOJu0YwnETG3E1CakYJ/j31JR6seRvAQxBjTfGcObDo9x3UzrlIsaRtd
        8k6Y5HVPL0cAoxtp7PkWaIU+CNTALIB/UA1JfuGOGw==
X-Google-Smtp-Source: AGHT+IEBlezrcdJgN+kx2LoFv3RPdtEDtUnoizkwRg6/nCDXUKk/DIw1owQilkE6tQ8UuBt9YzqGXi+WEg47isn22Rg=
X-Received: by 2002:a05:6122:d02:b0:487:e3da:f096 with SMTP id
 az2-20020a0561220d0200b00487e3daf096mr378821vkb.0.1692053539010; Mon, 14 Aug
 2023 15:52:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-5-amoorthy@google.com>
 <d5ebb72d-393d-f61b-6a6f-760c6a5d7469@gmail.com>
In-Reply-To: <d5ebb72d-393d-f61b-6a6f-760c6a5d7469@gmail.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Mon, 14 Aug 2023 15:51:42 -0700
Message-ID: <CAF7b7mrOc+kxJsGE-M0EnbJfUD+xx9vohspZ+cZzzG5mzv6L6w@mail.gmail.com>
Subject: Re: [PATCH v4 04/16] KVM: Add docstrings to __kvm_write_guest_page()
 and __kvm_read_guest_page()
To:     Robert Hoo <robert.hoo.linux@gmail.com>
Cc:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        jthoughton@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 14, 2023 at 7:41=E2=80=AFPM Robert Hoo <robert.hoo.linux@gmail.=
com> wrote:
>
> Agree, and how about one step further, i.e. adjust the param's sequence.
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2c276d4d0821..db2bc5d3e2c2 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2992,7 +2992,7 @@ static int next_segment(unsigned long len, int offs=
et)
>    */
>   static int __kvm_read_guest_page(struct kvm_memory_slot *slot,
>                                   struct kvm_vcpu *vcpu,
> -                                gfn_t gfn, void *data, int offset, int l=
en)
> +                                gfn_t gfn, int offset, void *data, int l=
en)

There are a lot of functions/callsites in kvm_main.c which use the
"offset, data, len" convention. I'd prefer to switch them all at the
same time for consistency, but I think that's too large of a change to
splice in here: so I'll leave it as is for now.
