Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C76877B396
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 10:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbjHNIMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 04:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233876AbjHNIMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 04:12:25 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C339F10E5;
        Mon, 14 Aug 2023 01:12:14 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-68706b39c4cso2788046b3a.2;
        Mon, 14 Aug 2023 01:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692000734; x=1692605534;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UotDdyQGTC4EoLCNaaGpiOUYo68Nb+c5bWned835Hco=;
        b=e5Qk7OKnnqWrYRCniPWElagFd0f1rj6Qxp5kyXXK+J7ooWeRbaCyWiCzdSvYuSl/9Y
         6KLN0C+GupvzLyOS0mLfSfhkqJR+9T+4QfDauCILtY/WmOk/f7cWakw7MJ28UBrPY2Mm
         5OAQtJT6AmdN2dqZWaQkR6uHvq2Uhhbuu8tFd0IS0jTIOsygempZpxPAnYVlzZ8IAdH0
         WVmKxgbzZjW7LB+u92YfLNu5c15P5Tetmr/IYbYAZlW+FicnxFMv75ZT1dJVjPSqOQoi
         xDImXI82JWvd/nYPhDM4L73OHyGUrROue6J9FBOyQT+q9x6ecfMTEBn3MmAd31RT00+E
         9OPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692000734; x=1692605534;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UotDdyQGTC4EoLCNaaGpiOUYo68Nb+c5bWned835Hco=;
        b=INc9rwDxJ1LKN9zsdwYGNFxLT/P+NHBVEgBAfmG6Ulo3PG5b3pRM/nJpgjn2SHLeWa
         BlxsaixU4Ez1PGMMHDSmFXcfnwdlqY63xkc+r7kVAywjwLSnnvuBXeT5C0F+JLfZL+ZN
         E+DqIvXc0AT75D4X+a71fSFmpANNE+IDGOpHckZDzFE0sFCalAP5HkSbsqTSQrzxEDYN
         etXGHoPt8JmHpLKFbIa1wedrKfxOGG1R8efhViGaR47Z9HTY6dq3lRw2nd7hSo4iFQH2
         DT6/zLI72cqW3bPgaT+9h0c3qv4sB2uOFE7gUFXideVxb8XIKAAHGOyC9PcAtfZ+PwEa
         HlVg==
X-Gm-Message-State: AOJu0YykHMUyEUgUJc4RFf38Qf7W6FoQ6u7AZKJwcj9auIwaXaq+G7hr
        9Oy4Aq4CeH47j2mgDknVNAczKI16pqc=
X-Google-Smtp-Source: AGHT+IFowllIVae+ymsdb38SvbxhHy8lJiRHiio7ZFnqr6A9sNLRAO2Rqy+t8W5i0UhOEg4eMXj+1w==
X-Received: by 2002:a05:6a00:1a50:b0:668:73f5:dce0 with SMTP id h16-20020a056a001a5000b0066873f5dce0mr8770313pfv.29.1692000734120;
        Mon, 14 Aug 2023 01:12:14 -0700 (PDT)
Received: from localhost ([61.68.161.249])
        by smtp.gmail.com with ESMTPSA id j20-20020aa783d4000000b00682c864f35bsm7656159pfn.140.2023.08.14.01.12.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 01:12:13 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 14 Aug 2023 18:12:07 +1000
Message-Id: <CUS477NDPEQI.27SBUCRNYD0XG@wheely>
Cc:     <kvm@vger.kernel.org>, <kvm-ppc@vger.kernel.org>,
        <mikey@neuling.org>, <paulus@ozlabs.org>, <vaibhav@linux.ibm.com>,
        <sbhat@linux.ibm.com>, <gautam@linux.ibm.com>,
        <kconsul@linux.vnet.ibm.com>, <amachhiw@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 4/6] KVM: PPC: Book3s HV: Hold LPIDs in an unsigned
 long
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     "Jordan Niethe" <jniethe5@gmail.com>,
        <linuxppc-dev@lists.ozlabs.org>
X-Mailer: aerc 0.15.2
References: <20230807014553.1168699-1-jniethe5@gmail.com>
 <20230807014553.1168699-5-jniethe5@gmail.com>
In-Reply-To: <20230807014553.1168699-5-jniethe5@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon Aug 7, 2023 at 11:45 AM AEST, Jordan Niethe wrote:
> The LPID register is 32 bits long. The host keeps the lpids for each
> guest in an unsigned word struct kvm_arch. Currently, LPIDs are already
> limited by mmu_lpid_bits and KVM_MAX_NESTED_GUESTS_SHIFT.
>
> The nestedv2 API returns a 64 bit "Guest ID" to be used be the L1 host
> for each L2 guest. This value is used as an lpid, e.g. it is the
> parameter used by H_RPT_INVALIDATE. To minimize needless special casing
> it makes sense to keep this "Guest ID" in struct kvm_arch::lpid.
>
> This means that struct kvm_arch::lpid is too small so prepare for this
> and make it an unsigned long. This is not a problem for the KVM-HV and
> nestedv1 cases as their lpid values are already limited to valid ranges
> so in those contexts the lpid can be used as an unsigned word safely as
> needed.
>
> In the PAPR, the H_RPT_INVALIDATE pid/lpid parameter is already
> specified as an unsigned long so change pseries_rpt_invalidate() to
> match that.  Update the callers of pseries_rpt_invalidate() to also take
> an unsigned long if they take an lpid value.

I don't suppose it would be worth having an lpid_t.

> diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xiv=
e.c
> index 4adff4f1896d..229f0a1ffdd4 100644
> --- a/arch/powerpc/kvm/book3s_xive.c
> +++ b/arch/powerpc/kvm/book3s_xive.c
> @@ -886,10 +886,10 @@ int kvmppc_xive_attach_escalation(struct kvm_vcpu *=
vcpu, u8 prio,
> =20
>  	if (single_escalation)
>  		name =3D kasprintf(GFP_KERNEL, "kvm-%d-%d",
> -				 vcpu->kvm->arch.lpid, xc->server_num);
> +				 (unsigned int)vcpu->kvm->arch.lpid, xc->server_num);
>  	else
>  		name =3D kasprintf(GFP_KERNEL, "kvm-%d-%d-%d",
> -				 vcpu->kvm->arch.lpid, xc->server_num, prio);
> +				 (unsigned int)vcpu->kvm->arch.lpid, xc->server_num, prio);
>  	if (!name) {
>  		pr_err("Failed to allocate escalation irq name for queue %d of VCPU %d=
\n",
>  		       prio, xc->server_num);

I would have thought you'd keep the type and change the format.

Otherwise seems okay too.

Thanks,
Nick
