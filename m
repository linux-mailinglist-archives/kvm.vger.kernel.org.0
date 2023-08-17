Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE6177F97C
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 16:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352156AbjHQOof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 10:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbjHQOoD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 10:44:03 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4033494
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 07:44:02 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d66c957e1b2so5225233276.0
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 07:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692283441; x=1692888241;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CwKLIzNsGmYCYeaNQUPMnVVG/1S9ppv6MLlHe19WHG4=;
        b=Yq6K71ySskdb/tA4/PSATW7eIevJr6C57vlvQaGJsyi7zYQpQLny2ZWSlwPC81SDVS
         fxo273V6Mpn7jcsDEQp/aV8u6inkXtiOhWnUD1QxMkueUA24IMCo+wj9F5d3L8Tz2ql0
         +poRT+MjE7PxMG8oRKcWUTxqVBwqLjmKsD4TGrVXAdh/VVNtJ8Q28UFWtMFdAClD26A2
         CZX95XiKdWZ7+JN+DNXEWSnP/Xia9HanDeTxzVqe5me/8Je8Q91fX+32xZZAaKpSMgCo
         S/jo0gxpm5ol6rprqhRbhH5vRgWS/D9M6M7JQ6QoFRPhINPOYqf5UaPRRwHK2whqDFQ/
         Mm+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692283441; x=1692888241;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CwKLIzNsGmYCYeaNQUPMnVVG/1S9ppv6MLlHe19WHG4=;
        b=Z0lDb13b+Hq62Tw0QDkoVK7eyjl8CpSzUli1Xi2vmArWqTgC7OdrLkmVaO0dh7hOZJ
         WAjvSyJu4jgdscYEaUef3mOfvV/p76fzUGxkmIeE3jwRmoBE4LkUEDsLnZrAARIRktkB
         /xGvfTyQ91CsKN/O3VldnVgGAfYCkSf40fZ7i5udTgV7tbXq33pRH+6jsmZtDMpfzfDH
         vQdIjLzPYhsbwV4y1izQFbOwW7xZyoJIhyl6qd2MY6iTdWBeY4ZRW1gFRJUjTgDV2XIv
         1+zKty1u2v87N4qFl8aGEa6GZdhMpJdG4pVAB/U6w05N/WLdEloCWuAMIsKvyrhP0Hbe
         SIiQ==
X-Gm-Message-State: AOJu0Yx/QZw/xfIzoaHXo3VtxGJTa4BPv6aII+q3QT05g9qtDGFW7xQ5
        gL712MkjA3sFl1ONw8cD9Zx30vvRAOM=
X-Google-Smtp-Source: AGHT+IGv5kmA4V7HWvPwBi4qunmu9s0AbysyOBFEBOslQx0QvDCPTarwc6SoIn5+CXlKxKgkEkAEgBMxSk4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ab08:0:b0:c61:7151:6727 with SMTP id
 u8-20020a25ab08000000b00c6171516727mr60903ybi.10.1692283441519; Thu, 17 Aug
 2023 07:44:01 -0700 (PDT)
Date:   Thu, 17 Aug 2023 07:44:00 -0700
In-Reply-To: <e4785596-f55c-edfb-89db-9d3ec12c4429@linux.intel.com>
Mime-Version: 1.0
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
 <20230719144131.29052-8-binbin.wu@linux.intel.com> <ZN1HT61WM0Pmxqmr@google.com>
 <e4785596-f55c-edfb-89db-9d3ec12c4429@linux.intel.com>
Message-ID: <ZN4yMMdB3oGnliqa@google.com>
Subject: Re: [PATCH v10 7/9] KVM: VMX: Implement and wire get_untagged_addr()
 for LAM
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com,
        guang.zeng@intel.com
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

On Thu, Aug 17, 2023, Binbin Wu wrote:
>=20
>=20
> On 8/17/2023 6:01 AM, Sean Christopherson wrote:
> > On Wed, Jul 19, 2023, Binbin Wu wrote:
> > > +	return (sign_extend64(gva, lam_bit) & ~BIT_ULL(63)) | (gva & BIT_UL=
L(63));
> > Almost forgot.  Please add a comment explaning how LAM untags the addre=
ss,
> > specifically the whole bit 63 preservation.  The logic is actually stra=
ightforward,
> > but the above looks way more complex than it actually is.  This?
> >=20
> > 	/*
> > 	 * Untag the address by sign-extending the LAM bit, but NOT to bit 63.
> > 	 * Bit 63 is retained from the raw virtual address so that untagging
> > 	 * doesn't change a user access to a supervisor access, and vice versa=
.
> > 	 */
> OK.
>=20
> Besides it, I find I forgot adding the comments for the function. I will =
add
> it back if you don't object.
>=20
> +/*
> + * Only called in 64-bit mode.

This is no longer true.

> + *
> + * LAM has a modified canonical check when applicable:
> + * LAM_S48=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : [ 1 ][ metadata ][ 1 ]
> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 63=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 47
> + * LAM_U48=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : [ 0 ][ metadata ][ 0 ]
> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 63=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 47
> + * LAM_S57=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : [ 1 ][ metadata ][ 1 ]
> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 63=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 56
> + * LAM_U57 + 5-lvl paging : [ 0 ][ metadata ][ 0 ]
> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 63=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 56
> + * LAM_U57 + 4-lvl paging : [ 0 ][ metadata ][ 0...0 ]
> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 63=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 56..47

I vote to not include the table, IMO it does more harm than good, e.g. I on=
ly
understood what the last U57+4-lvl entry is conveying after reading the sam=
e
figure in the ISE.  Again, the concept of masking bits 62:{56,47} is quite
straightforward, and that's what this function handles.  The gory details o=
f
userspace not=20


> + * Note that KVM masks the metadata in addresses, performs the (original=
)
> + * canonicality checking and then walks page table. This is slightly
> + * different from hardware behavior but achieves the same effect.
> + * Specifically, if LAM is enabled, the processor performs a modified
> + * canonicality checking where the metadata are ignored instead of
> + * masked. After the modified canonicality checking, the processor masks
> + * the metadata before passing addresses for paging translation.

Please drop this.  I don't think we can extrapolate exact hardware behavior=
 from
the ISE blurbs that say the masking is applied after the modified canonical=
ity
check.  Hardware/ucode could very well take the exact same approach as KVM,=
 all
that matters is that the behavior is architecturally correct.

If we're concerned about the blurbs saying the masking is performed *after*=
 the
canonicality checks, e.g. this

  After this modified canonicality check is performed, bits 62:48 are maske=
d by
  sign-extending the value of bit 47 (1)

then the comment should focus on whether or not KVM adheres to the architec=
ture
(SDM), e.g.

/*
 * Note, the SDM states that the linear address is masked *after* the modif=
ied
 * canonicality check, whereas KVM masks (untags) the address and then perf=
orms
 * a "normal" canonicality check.  Functionally, the two methods are identi=
cal,
 * and when the masking occurs relative to the canonicality check isn't vis=
ible
 * to software, i.e. KVM's behavior doesn't violate the SDM.
 */
