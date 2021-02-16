Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E77531CB55
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 14:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhBPNlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 08:41:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbhBPNlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 08:41:21 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9A0C061574;
        Tue, 16 Feb 2021 05:40:39 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id t63so9389783qkc.1;
        Tue, 16 Feb 2021 05:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=3JewOjQw0FtJtNgCeApdgGf7kQbjOdx2qp+PtYPRynk=;
        b=SO+jkcapCDtBxWnZFrxewnr06ShtzsemKW6mDn+qTmYv7WV1qM4payyLSQFd3Wssbi
         4ebKGzqCvnQWJVL7dAQY4wFscsQFWFz2VoP7XLfwbRxOcOd1+jmEu5fdcMTkwlunyR03
         L0u22YzPQFbp37xmNwPWMWLmE0h2XdQsevJkCCB47up75o/uxfA/J/MlDquWYrEOF4GO
         dK8kbUGrDTJX6r1UtqXVfofmSiwD9vw6vBiac/Mzk2AQSrvg9B8wCOtLLA9FZxkSqror
         j8NqS5K7MpJJ6qxjIbBvEsNCZZGy0cbC3oXrJvHGe/54U+tJrA9pgH41+4y4+crnoY5f
         Qkjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=3JewOjQw0FtJtNgCeApdgGf7kQbjOdx2qp+PtYPRynk=;
        b=Uw4N8iO2XyAoT3IWlmrbtoXLiMJUMDvVBKV2j3IQXdDEpSF1DySoIdTynvTggJycDo
         fzk/GinnDSRP5PDW5NgZmpJ8Yfs3ifCUhTs2x/o7Lud9p07Ts0Zc6atn8g2IPbx4SAGm
         T+Y37bDZd4KCGvvptqFkNfFAHlGukvak7edVOVpMDM3wra5nPBqx4zI193fdpB9DPe/H
         CYstgggG1OFIJeMzrWRoWB4kUgXQOPg/RjET142+1AYhrua3XOnDljfcDkpGTrrPzpnY
         pvs8z3zeBkRXiG93ylhA15T2J3/QyYS3egzePyhBwqrTH4sBBhOEh10+NNJ1l5ITTSXJ
         MyAQ==
X-Gm-Message-State: AOAM533wH+GY5SVUwmkLTofLnFitOYUQVqWWDWSggUl+/tQ6MW5tCJ13
        q143f/zQOC0A4Gyx0UCfNWA=
X-Google-Smtp-Source: ABdhPJwgyn6Rx0Ml7fck+ccdshjky57XCc1KnkwdqZuhTTpZLK4lPXduVr5+NncQH2D++f5vBPhpQw==
X-Received: by 2002:a37:468e:: with SMTP id t136mr19220977qka.440.1613482838936;
        Tue, 16 Feb 2021 05:40:38 -0800 (PST)
Received: from OpenSuse ([143.244.44.229])
        by smtp.gmail.com with ESMTPSA id c7sm13343484qtm.60.2021.02.16.05.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 05:40:37 -0800 (PST)
Date:   Tue, 16 Feb 2021 19:10:29 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     borntraeger@de.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH] arch: s390: kvm: Fix oustanding to outstanding in the
 file kvm-s390.c
Message-ID: <YCvLTSjlChLHvygM@OpenSuse>
Mail-Followup-To: Janosch Frank <frankja@linux.ibm.com>,
        borntraeger@de.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
References: <20210213153227.1640682-1-unixbhaskar@gmail.com>
 <f90e91a5-7bc0-2489-51d4-6004eef9db7a@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MM1/o3wLr7SJP/Ol"
Content-Disposition: inline
In-Reply-To: <f90e91a5-7bc0-2489-51d4-6004eef9db7a@linux.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--MM1/o3wLr7SJP/Ol
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 10:08 Mon 15 Feb 2021, Janosch Frank wrote:
>On 2/13/21 4:32 PM, Bhaskar Chowdhury wrote:
>>
>> s/oustanding/outstanding/
>
>Hey Bhaskar,
>
>while I do encourage anyone to send in changes I'm not a big fan of
>comment fixes if they are only a couple of characters and when the
>meaning is still intact despite the spelling mistake.
>
>You're creating more work for me than you had writing this patch and the
>improvement is close to zero.
>
>Be warned that I might not pick up such patches in the future.
>
>
>If you're ok with it I'll fix up the subject to this and pick up the patch:
>"kvm: s390: Fix comment spelling in kvm_s390_vcpu_start()"
>
Pls do.

>Cheers,
>Janosch
>
>>
>> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
>> ---
>>  arch/s390/kvm/kvm-s390.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index dbafd057ca6a..1d01afaca9fe 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -4545,7 +4545,7 @@ int kvm_s390_vcpu_start(struct kvm_vcpu *vcpu)
>>  		/*
>>  		 * As we are starting a second VCPU, we have to disable
>>  		 * the IBS facility on all VCPUs to remove potentially
>> -		 * oustanding ENABLE requests.
>> +		 * outstanding ENABLE requests.
>>  		 */
>>  		__disable_ibs_on_all_vcpus(vcpu->kvm);
>>  	}
>> --
>> 2.30.1
>>
>
>




--MM1/o3wLr7SJP/Ol
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAmAry0kACgkQsjqdtxFL
KRXHdwf/fQnnFjWrAG1FY7B2hDZDpGIwgQTiJwMamKsugT/y73/WNDIamMqIn0W+
27G6ohO5mjH94Br/2o6IhEfydhyN/buFh/oyklvvlcikfHkC+UoxEHaYCnSx77S3
C/1Uc126wgQR7YEZ5Bzua9lNbc9+gp1DgHCtL9uBCJFvH2PvQ+aR8XyRZWW52Tuc
oDFQY4AdmLX92v30pKWiIVEUvCNFXJoeCyVPJ7la9SzDfJE9em642FztEo+vP3CX
D6Q5y8C6CKWmvxPcPgDOh+DM5FD8C1qCDNtHOPJfBFDbiPwyCidJrLlPDx+gLYpY
liXmDequghHB/ZqvHHBJPR16CIA7yA==
=RGPJ
-----END PGP SIGNATURE-----

--MM1/o3wLr7SJP/Ol--
