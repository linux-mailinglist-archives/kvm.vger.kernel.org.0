Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34BAE6E675F
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 16:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjDROo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 10:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbjDROoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 10:44:54 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F72B44A
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 07:44:53 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-63b79d8043eso6753728b3a.0
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 07:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681829093; x=1684421093;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6ZBk5iJHZKaciPWWzb9SsyCTzokpj1Hk6SOYWHiX4Hk=;
        b=BgoFgFdRU7jPbA/y9HzUwo4+8KsTjIwpeZzvzas6MGohje0HFm86/avCoejYfKjhAD
         zbaGgeTYoILvNl0nDfP/yvrqwht6RL7+vZ3jPU24qHhAN0f9ozVKuoN2mRKVl1QVCiNp
         rrgOkZjkPcJsm0YivifTiV/1n098GY8gheuXhzjXl358jeO8MoruPEyfgtGSmUz6ii3x
         iVuGoZrrYvDn05A3pOKtAbCZtmky1/VhuhFcPq4pqeh9o8ho+M4QMBFho+0UA1RbV8J7
         dr0DboopeKSqrEpjQ+IxB4OeUY7S7I+6dqwn9kGxRvDVG/yVb2UNkMJEpleZR5IXHxCv
         PLcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681829093; x=1684421093;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6ZBk5iJHZKaciPWWzb9SsyCTzokpj1Hk6SOYWHiX4Hk=;
        b=S7RaCMnfnKK2zTyaWcoQlXAQeLE3TR4XJSlwECaBG/sEJ5aKiDTlAP4eDa7K7iWfiv
         oFezmcC5OVPaN6sqVNChNdhGgXlBnl0d81C5OCCHLCUXBFwFkwcHPShh6PbX9YOdREql
         BLNrb/JN7ftEgu4aAUj8plWyTA5i1HEutrDZJ5FKxPk1BIBmB7qiptnsU3p/IdIss51p
         quYGefmeCpmxIVLXfVs7XUZmTuFRYgrqf+beliooBo4lMFQtEBPdb4NSWX1y5Z+xZLsN
         Qg37T81M2+ZP9EwXc/Om4z8qTTHLYaMn19+Nr8USma6LB8cJbEGSnrbOLgLqr2efeLJg
         Yq7w==
X-Gm-Message-State: AAQBX9eTiOfcIKt6pqW8TRzbPeMUO6lmkBhrT1v8Xtvdg65QzF6B3se5
        bVlvUnjJZmZJQKlJjRfOLSD6x0BXqow=
X-Google-Smtp-Source: AKy350bwKzIxbmnN7EDlAStw/uNfwQYEkQ5uPLVYZce047cMB3qPt4Rns2FcbdQ3gxucWh8bwCzSu7C5m+c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:230c:b0:1a1:def4:a030 with SMTP id
 d12-20020a170903230c00b001a1def4a030mr1006615plh.0.1681829092893; Tue, 18 Apr
 2023 07:44:52 -0700 (PDT)
Date:   Tue, 18 Apr 2023 07:44:51 -0700
In-Reply-To: <138f584bd86fe68aa05f20db3de80bae61880e11.camel@infradead.org>
Mime-Version: 1.0
References: <20230417122206.34647-1-metikaya@amazon.co.uk> <20230417122206.34647-2-metikaya@amazon.co.uk>
 <ZD10aFK0heJrs6f2@google.com> <138f584bd86fe68aa05f20db3de80bae61880e11.camel@infradead.org>
Message-ID: <ZD6s4w2NDtoYZSuH@google.com>
Subject: Re: [EXTERNAL][PATCH v2] KVM: x86/xen: Implement hvm_op/HVMOP_flush_tlbs
 hypercall
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Metin Kaya <metikaya@amazon.co.uk>, kvm@vger.kernel.org,
        pbonzini@redhat.com, x86@kernel.org, bp@alien8.de, paul@xen.org,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        joao.m.martins@oracle.com
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 18, 2023, David Woodhouse wrote:
> On Mon, 2023-04-17 at 09:31 -0700, Sean Christopherson wrote:
> > On Mon, Apr 17, 2023, Metin Kaya wrote:
> > > HVMOP_flush_tlbs suboperation of hvm_op hypercall allows a guest to
> > > flush all vCPU TLBs. There is no way for the VMM to flush TLBs from
> > > userspace.
> >=20
> > Ah, took me a minute to connect the dots.=EF=BF=BD Monday morning is de=
finitely partly
> > to blame, but it would be helpful to expand this sentence to be more ex=
plicit as
> > to why userspace's inability to efficiently flush TLBs.
> >=20
> > And strictly speaking, userspace _can_ flush TLBs, just not in a precis=
e, efficient
> > way.
>=20
> Hm, how? We should probably implement that in userspace as a fallback,
> however much it sucks.

Oh, the suckage is high :-)  Use KVM_{G,S}ET_SREGS2 to toggle any CR{0,3,4}=
/EFER
bit and __set_sregs() will reset the MMU context.  Note that without this f=
ix[*]
that I'm going to squeeze into 6.4, the MMU context reset may result in all=
 TDP
MMU roots being freed and reallocated.

[*] https://lore.kernel.org/all/20230413231251.1481410-1-seanjc@google.com

>=20
> > > =EF=BF=BDarch/x86/kvm/xen.c=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD | 31 ++++++++++++++++++++++++++++++
> > > =EF=BF=BDinclude/xen/interface/hvm/hvm_op.h |=EF=BF=BD 3 +++
> >=20
> > Modifications to uapi headers is conspicuously missing.=EF=BF=BD I.e. t=
here likely needs
> > to be a capability so that userspace can query support.
>=20
> Nah, nobody cares. If the kernel "accelerates" this hypercall, so be
> it. Userspace will just never get the KVM_EXIT_XEN for that hypercall
> because it'll be magically handled, like the others.

Ah, that makes sense, I was thinking userspace would complain if it got the
"unexpected" exit.
