Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555EE343889
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 06:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhCVF3h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 01:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhCVF33 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 01:29:29 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22D3C061574;
        Sun, 21 Mar 2021 22:29:28 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id c3so9429189qkc.5;
        Sun, 21 Mar 2021 22:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=+NandHOUNqJJLy4t3N0mJCzMm5aUJ7mG9Y8NFGBMAxQ=;
        b=OwpzLLvtOhzPSLZTBUC1BpgjANuSHkBU31yGtsqU+J2kMIBiMBNTHPBCHhjTqRqJyE
         P2J+4v1o6ik2mLChqtbyA+btgNlbJ006M9GmjVEDrRQXzirU8j6uvxqj8eAMQSdU3RPj
         U/SWXfMgbd3yOYAw6bzNmtpj7/fkUbmjsCuxyWfvT8b1wjFUA3QkGw+7azSQi7nL7rYz
         BN5cUPkW48F1t3v61isQ2uSE5jXJ8AoxgFAzM604LAW/P4tpFpyxyb3wOtcQstORRtwS
         C7Ihbud7Fqu1ij5ovIvldOTdVQOlQz6wgybEpnayqsQpnfZzC51fJLvTAJFIFHpHtIV6
         1UIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=+NandHOUNqJJLy4t3N0mJCzMm5aUJ7mG9Y8NFGBMAxQ=;
        b=TarCO+GnId2R+sA+vpBwQPzqwLbMUAIHpNwNHjynqgD6dqdbGn23wIH38/+/HTiCOp
         IB9jvD/lWPcPEq+kF0IalQosP0SX5/fWVmnvm2G/7HaxJcBBaPRAAOoT1ddZUebRJSo0
         fylkKXq5NeLsJ5/2I2svGivWn5OtBrHJaEx04S0qE+Vcy7z+TvVr9z40K8hB8Vdz/xst
         sx060i/tPIQx3oSA1ZKB+PuBYlVD6O9Ld22xc8cG2OFpe1PxOO2NyKTweya7Gu6vXuqn
         BJDtC3n9kwMN+il3JuKvIMctTxeTmODVOZ1JxHvjBbR+iLP//RbtLq9e92Ln8MduYJ94
         HQOQ==
X-Gm-Message-State: AOAM531HzXxbRlkWvyVGrn7wX3hZMJZ20j15xBXfEPpe0h9XkH7ZSX7B
        ujV9u99TjPKDNPHb85yAb9E=
X-Google-Smtp-Source: ABdhPJy2/kTOfNVgI15cCI5Gwb2/VQwxZZOtWll/keVq1gPn4jFKr7GwBhOBOmzpbsWYsMMbGDHBxw==
X-Received: by 2002:a37:6244:: with SMTP id w65mr9292357qkb.393.1616390968184;
        Sun, 21 Mar 2021 22:29:28 -0700 (PDT)
Received: from ArchLinux ([156.146.54.190])
        by smtp.gmail.com with ESMTPSA id g14sm10152340qkm.98.2021.03.21.22.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 22:29:27 -0700 (PDT)
Date:   Mon, 22 Mar 2021 10:59:14 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Randy Dunlap <rdunlap@bombadil.infradead.org>, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: A typo fix
Message-ID: <YFgrKpNbWvCRQA4/@ArchLinux>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Randy Dunlap <rdunlap@bombadil.infradead.org>, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210320190425.18743-1-unixbhaskar@gmail.com>
 <f9d4429-d594-8898-935a-e222bb8c247@bombadil.infradead.org>
 <20210321225428.GA1885130@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yYKjLYK+Hby8LEgc"
Content-Disposition: inline
In-Reply-To: <20210321225428.GA1885130@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--yYKjLYK+Hby8LEgc
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 23:54 Sun 21 Mar 2021, Ingo Molnar wrote:
>
>
>These single file typo fixes are a bad idea for another reason as
>well, as they create a lot of unnecessary churn.
>
Huh! I was expecting it from the moment I started doing it ...finally it arrives.

I am not sure about "so called workflowo of others" ..I am gonna do it in my
way as long as it providing good.

I think this is best way to do it.

~Bhaskar


--yYKjLYK+Hby8LEgc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAmBYKyYACgkQsjqdtxFL
KRUAegf+L64kCxotColN3uHDYT9YxhrAh6GXTqprXYYcJCt+SsXePhx9FA5QcpYT
dfDEdWQ3Y1+TtTtjGfxKMWdTRPqxzylZDwV0bgfhTZtC7C8AxIrp56xGHr/FA0qj
dYtkB0QLGd2dyN2qfgK+Z5dYiWAmMlnfjM/CD9fpRAZQbMbi+P0UAeOXKQ/3/JMP
c9uPHW2g3Xa7OBSJfI8LTRs7oe4+dxEA+J9IMZOaIkh7u3tejsT4N6vFOkqE9CnQ
wlS5qj7wV3PC5hKI2qnBrJg6USFMGIRn7wgHKjzlf3xlgyEX3iN6CVxVTu/xV6nH
qCLPOB7S9Ib/Bhn5CwIMFiGPX4n5lQ==
=GEUZ
-----END PGP SIGNATURE-----

--yYKjLYK+Hby8LEgc--
