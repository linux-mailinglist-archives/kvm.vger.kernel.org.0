Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4AB7B72F1
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 22:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbjJCU6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 16:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbjJCU6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 16:58:50 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88300AC
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 13:58:47 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-2773ced5d40so1098057a91.1
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 13:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696366727; x=1696971527; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ofK3yTXudgH3dPOX+NXSBZm32mvv1GbIdTLu5eO4ZUw=;
        b=hsQ+h+zfEPMCI/50kh3uYHFre+0DewKghyeEOScbZURjbzs4Xqgl7eg7ObPDFdJBx6
         GxyYyVlH4Tqqou1ShFGVsxuXenXmxFNcNmwYkG8xVTX5Y9pl8vgcpZ6Abk99wenw/fnK
         S0ELSUpQWfX2bnKeTHUdXbfAWXe/kBSdl8DwlfAn4gAqRp6/01aQkzC6n4gBRdHfRaGp
         7H1bfyIBWWPn61RnqJLCJslnne8tUK4S79LcbdApOR9Zzova18T91gI+i4bG6s9uR4IH
         djNy81a+H1hzWGQ/kDkeQW8fJuaZc8K4WQm66gPzGWwpniShzqn2jIGUM23iyyT3EqIZ
         aTUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696366727; x=1696971527;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ofK3yTXudgH3dPOX+NXSBZm32mvv1GbIdTLu5eO4ZUw=;
        b=UvLzrPYAi2ELncCQtBcQisQeQottTkwdfDrr2/ZHWWfr+90uLWDkf1TgsKHgO61lSJ
         bxzHH/7Dklwu8jvUfkbg6Vraycf4xvY5DeBjPq24H8E/JvpZQZz0Sfkrz3I7OLRdOXOg
         M/oxn8Q26FRi0sUSNqc8sOnrBzcco/L2iFza263OqNRIo5EmSqSLkI0ThTbvmwzQhyy+
         K9Yu+L00CmHVTFU/tbIZhv7H5Zv5NfiPutgBvgSM7th6TaAlUd/gjSDVXID8gKoOT0lX
         tpV1gPRtXj5Du3otf0/LDEb0zNrHbKxxqtVgBhSTOrfkua20om16FpLNueYmSDmCPz6o
         L61Q==
X-Gm-Message-State: AOJu0YwAi6TKZ1h/nXT08Z0vsvYbYPdTnvg9+mJzCNBpZ9Q5SVp2btPK
        skD7oWcI5n7SuKQA3oqqn6f/hTeL/bM=
X-Google-Smtp-Source: AGHT+IEpJRqfisemR4Ma6/26idPCJUHwNJZNRJlSNji243dfZdo+DGHvKt5onPD5NiiwHo9l66/HVhcVsls=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:92:b0:26d:ae3:f6a4 with SMTP id
 bb18-20020a17090b009200b0026d0ae3f6a4mr6815pjb.5.1696366727020; Tue, 03 Oct
 2023 13:58:47 -0700 (PDT)
Date:   Tue, 3 Oct 2023 13:58:45 -0700
In-Reply-To: <fe832be36d46a946431567cbc315766fbdc772b1.camel@redhat.com>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <20230911021637.1941096-6-stevensd@google.com>
 <fe832be36d46a946431567cbc315766fbdc772b1.camel@redhat.com>
Message-ID: <ZRyAhdIvAkQhYJVr@google.com>
Subject: Re: [PATCH v9 5/6] KVM: x86: Migrate to __kvm_follow_pfn
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     David Stevens <stevensd@chromium.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 03, 2023, Maxim Levitsky wrote:
> =D0=A3 =D0=BF=D0=BD, 2023-09-11 =D1=83 11:16 +0900, David Stevens =D0=BF=
=D0=B8=D1=88=D0=B5:
> > From: David Stevens <stevensd@chromium.org>
> > @@ -4283,12 +4290,20 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *v=
cpu, struct kvm_page_fault *fault
> >  			return RET_PF_EMULATE;
> >  	}
> > =20
> > -	async =3D false;
> > -	fault->pfn =3D __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &=
async,
> > -					  fault->write, &fault->map_writable,
> > -					  &fault->hva);
> > -	if (!async)
> > -		return RET_PF_CONTINUE; /* *pfn has correct page already */
> > +	foll.flags |=3D FOLL_NOWAIT;
> > +	fault->pfn =3D __kvm_follow_pfn(&foll);
> > +
> > +	if (!is_error_noslot_pfn(fault->pfn))
> > +		goto success;
> Unrelated but I can't say I like the 'is_error_noslot_pfn()' name,=20
> I wish it was called something like is_valid_pfn().

I don't love the name either, but is_valid_pfn() would be extremely confusi=
ng
because the kernel already provides pfn_valid() to identify pfns/pages that=
 are
managed by the kernel.  Trying to shove "guest" somewhere in the name also =
gets
confusing because it's a host pfn, not a guest pfn.
