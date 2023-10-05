Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8E27B99EF
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 04:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233830AbjJEC2a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 22:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233736AbjJEC23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 22:28:29 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F31BF
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 19:28:25 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-27911ce6206so432051a91.0
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 19:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696472904; x=1697077704; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EG0WvU14z5YfOYafQHRXFgYfVojqPWSPhH10Jz++Ogk=;
        b=OgsN0YxzOTffl9jNr31rlZO34VTAhg+JApbBk0rsZF3a9Y4KqJDiZ3KJx1ld3a1Hn5
         97TLVQlakUz0Qs10GvHexm5BGwAoMTxCsATRHjCHVY7OJr033i4QhY8Ky1HVDV0WfuNh
         L8n4V8DlDionXLvCMonhgdu5smqZV7h0hlcedGDG9HL76Nl8SvA/H/oIP+iQpEf1LY+F
         V8wfwbAbTWawxnxLxDwFZz6cNYdz1U+Epnn3uA3cbuLcMzqpMNoW4jRbOBqrx9lG4tF1
         fmnqcKRZGqIeqJVHUtnqU8lrEVaHyE58G2AT1epp6/KwaU4m4p1tWgt7YOe2TLzoseSQ
         wXkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696472904; x=1697077704;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EG0WvU14z5YfOYafQHRXFgYfVojqPWSPhH10Jz++Ogk=;
        b=mp/72v+LDKpHhHcslpW9h3NQkhzEs3ewjFOqCfyklzppD8k1+rm0O3bY+DAUsDBFK1
         f5qdX8G45554sCj7MDYnOZpJV0tJGDrd/mHuSPcAkaxcJj2cfd7wyexRTyZWDZXm7NPq
         +opDBaCJ5uq7TODj1oqygv9gTtckQQQ/zCuZQzwuOY+kyVIN9DFRPzQqCrhD/nZ6b2oT
         6Z4ZJw/IsB0bKnnc4mi4ogFZpMzmg3rUDo+CdIMkAC1CMtBueELpefCI8tNlWSa6r+LO
         POtIYXl7NsnvVU+dOXZhic91QuT+pFGqnDTrUDRv3oeskYZubqHCDPuhvFLzi2Ka57kW
         RAfg==
X-Gm-Message-State: AOJu0YyaYNsBvyzurlCDg3h7oof4W95r7pD5cHcF6uUyICkTY/raXa30
        6IRoGM0u8SphD5S95FmXdOu106JgHc0=
X-Google-Smtp-Source: AGHT+IH/I3A8Y47Ln57a0JGbKLXvQd00askybajzdxc41tTI7yQGhR8p5gjM4/x6YVEG3hJREP9fmWuW5zo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d396:b0:273:dfcd:bdbf with SMTP id
 q22-20020a17090ad39600b00273dfcdbdbfmr64288pju.8.1696472904569; Wed, 04 Oct
 2023 19:28:24 -0700 (PDT)
Date:   Wed, 4 Oct 2023 19:28:23 -0700
In-Reply-To: <f29d86b433c4cbcbae89e57ac7870067357f1973.camel@intel.com>
Mime-Version: 1.0
References: <20230714064656.20147-1-yan.y.zhao@intel.com> <169644820856.2740703.143177409737251106.b4-ty@google.com>
 <f29d86b433c4cbcbae89e57ac7870067357f1973.camel@intel.com>
Message-ID: <ZR4fR7H_do2Obzoi@google.com>
Subject: Re: [PATCH v4 00/12] KVM: x86/mmu: refine memtype related mmu zap
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yan Y Zhao <yan.y.zhao@intel.com>,
        "robert.hoo.linux@gmail.com" <robert.hoo.linux@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Chao Gao <chao.gao@intel.com>,
        "yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 05, 2023, Kai Huang wrote:
> On Wed, 2023-10-04 at 18:29 -0700, Sean Christopherson wrote:
> > [4/5] KVM: x86/mmu: Xap KVM TDP when noncoherent DMA assignment starts/=
stops
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 https://github.com/kvm-x86/linux/commit/=
3c4955c04b95
>=20
> Xap -> Zap? :-)

Dagnabbit, I tried to capitalize z =3D> Z and hit the wrong key.  I'll fixu=
p.

Thanks Kai!
