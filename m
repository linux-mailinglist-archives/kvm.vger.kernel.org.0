Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065506C3C92
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 22:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjCUVVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 17:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjCUVV2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 17:21:28 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774BF498AF
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 14:21:27 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id p9-20020a170902e74900b001a1c7b2e7afso4821130plf.0
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 14:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679433687;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b8xazSPFBreaTPvX2LxkUqMerX9ehkqQaqTTGvhOdbk=;
        b=WjXCu3ldKzqxRcIef3tLaIdf3wHhdouBc3crHTXHsK4bH5BZTVxQWab34ocAB/cIw7
         rC3zsqPSThwPgt7CPqdYypLDquOQMY/MZ5MvOR44dRJSA9pUA966UaHYhcmPZzYgjrmI
         i1AEm36tP8k/ansOfgEJzvq5QOnq8rQqnzEudyGeeIpVpWu2PxZI1eQm1DiDbunvmLez
         Xjk56Zp7d48gGIKUn98s3TD9uQR1IVt6zbDBOtlF097wY0LaWLJ0547+uKrkBUdzow0P
         Lz6p+B19A/LNyvf0eEhLC2trZ9yqtNsN1HqV0BbUVHzMVE+Z+yAkstK6kn6XGKwL0HSJ
         mduw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679433687;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=b8xazSPFBreaTPvX2LxkUqMerX9ehkqQaqTTGvhOdbk=;
        b=vCW1kvVOZuUWOyxDkKtzXhMc1Fm7FG8lzc3HJlfeJZvCsKOB/h0/ywUC5OfMtKqYUW
         fQOOkE+F47vAQLYvsbSvDwwv2sgrW5btj9pamIqdZsG2EXzjBuwvFciN8yobePCXKYql
         yGn7NhcB6wHZRTGYEu30F8+AnKg2RLS1j+C8X6xOIvpAg6lr/osuPQ2LUI5lr6w5kRTM
         qIMw1CdcuGkz4PcUsoVMuV//ZZwWQzMb06MxnN2sy3V949kY5FI/NIpT47XVrDnYvUPc
         j+4Q10Pq92xMIhYCtOuOg786RMf3//0dIyX6lTgnQF/MwE2NFRSPTr0DgpvlT2Jk1hxz
         OC1w==
X-Gm-Message-State: AO0yUKUmIIxJ5R6ux76Zvtq+IpBNFNJE34Q3qJgbb/LwlAO/0TekJGu+
        XVRspuof17l33GdmLUMBBT1T3gACQ3g=
X-Google-Smtp-Source: AK7set/wbYqwR7nGL/Fw3iPPQ6yW6+W1ThJ8mvAZRaF4HN8g0LlKHzXDpUJUX0TLfUlt14zWyvP1BrOiXf8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c404:b0:19f:29cf:3ed2 with SMTP id
 k4-20020a170902c40400b0019f29cf3ed2mr244902plk.3.1679433687049; Tue, 21 Mar
 2023 14:21:27 -0700 (PDT)
Date:   Tue, 21 Mar 2023 14:21:25 -0700
In-Reply-To: <gsntedphdip9.fsf@coltonlewis-kvm.c.googlers.com>
Mime-Version: 1.0
References: <CAHVum0edWWs0cw6pTMFA_qnU++4qP=J88gyL6eSSYaLL-W9kxw@mail.gmail.com>
 <gsntedphdip9.fsf@coltonlewis-kvm.c.googlers.com>
Message-ID: <ZBof1SkJuo3wv3HW@google.com>
Subject: Re: [PATCH v2 2/2] KVM: selftests: Print summary stats of memory
 latency distribution
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     Vipin Sharma <vipinsh@google.com>, pbonzini@redhat.com,
        shuah@kernel.org, dmatlack@google.com, andrew.jones@linux.dev,
        maz@kernel.org, bgardon@google.com, ricarkol@google.com,
        oliver.upton@linux.dev, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023, Colton Lewis wrote:
> Vipin Sharma <vipinsh@google.com> writes:
>=20
> > On Thu, Mar 16, 2023 at 3:29=E2=80=AFPM Colton Lewis <coltonlewis@googl=
e.com>
> > wrote:
> > > +       pr_info("Latency distribution (ns) =3D min:%6.0lf,
> > > 50th:%6.0lf, 90th:%6.0lf, 99th:%6.0lf, max:%6.0lf\n",
> > > +               cycles_to_ns(vcpus[0], (double)host_latency_samples[0=
]),
>=20
> > I am not much aware of how tsc is set up and used. Will all vCPUs have
> > the same tsc value? Can this change if vCPU gets scheduled to
> > different pCPU on the host?

FWIW, if this test were run on older CPUs, there would be potential diverge=
nce
across pCPUs that would then bleed into vCPUs to some extent.  Older CPUs t=
ied
the TSC frequency to the core frequency, e.g. would change frequency depend=
ing
on the power/turbo state, and the TSC would even stop counting altogether a=
t
certain C-states.  KVM does its best to adjust the guest's perception of th=
e TSC,
but it can't be hidden completely.

But for what this test is trying to do, IMO there's zero reason to worry ab=
out
that.
=20
> All vCPUs *in one VM* should have the same frequency. The alternative is
> probably possible but so weird I can't imagine a reason for doing it.

Somewhat related to Vipin's question, "host_latency_samples" is a confusing=
 name.
It's easy to miss that "host_latency_samples" are actually samples collecte=
d in
the guest, and thus to think that this code will depend on which pCPU it ru=
ns on.

I don't see any reason for such a verbose name, e.g. can't it just be "samp=
les"?
