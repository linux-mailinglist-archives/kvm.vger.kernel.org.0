Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28160CE01D
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 13:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfJGLV0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 07:21:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50969 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727394AbfJGLV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 07:21:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570447285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=dVOFFii16+FKxB8m6djNWChjtVdgMeBictRVuFZgGgI=;
        b=ZcfWj/fahDCg3ddLAXRtE+IBRAVsAn/oXieoX2EafQwrKnsC8jX0B/6+Xelh+0D9PCsYt9
        mHXXPsQLWLW003cA4fIx/NpJc4gMsPnLVvMShFPOOvaDxccELeFUR8Nr0nmRPRBcXrgvrg
        XhLtcUF6Aedpo/e82D6eeImxCkunxN8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-_L9w8niMPsSXdaUqjkcOag-1; Mon, 07 Oct 2019 07:21:23 -0400
Received: by mail-wr1-f71.google.com with SMTP id n18so7362780wro.11
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2019 04:21:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=96+44HMK3XklFg07Q6v0RITszPMiyLteRIjAJ3p/WAc=;
        b=VsSMBB68db4yYL+AroSOo60S3WLAwnJRWevCfShqYSloes/BQ2pRORjy676IMS9Une
         umtMOm3LVy4fDATx5d4BGKlauFqynSD7AJzbTjN75xbirYZWfl7My9Ych/c3QlAiSMuH
         gedXLeYu5cKTD75l9E8ZOJEMeYOUC8Iag3uyVJeadBJ8YJaxRoj0AvEPAVOCiyRDrzhY
         oWIFGYVVOdINOEuZCAs4JX/e7JW+g3zeuEFhkdQIQdoOtTKoYVtlRVFhBEuiSoEEj/e2
         4UFUr2Dvgmgu55b8+MH9GrL+4pyL/gHMvoVMT0a9/DtwlNoBVE2qzEd13VAz2QaxfLtp
         b68Q==
X-Gm-Message-State: APjAAAUdBtyDs+yx7OIqGxLOMEFaNMZAxAqaeETbFUrARwsEQyTpH15j
        1z1sGz6SOR8ily4HFRgqtA+5S3nxX8hmgbobtK0P/knKBVSx+Y/xl2qb61gIPV2pDQQOhSVx0MK
        FsSym8U/XUmvK
X-Received: by 2002:a05:600c:34e:: with SMTP id u14mr18779944wmd.110.1570447282141;
        Mon, 07 Oct 2019 04:21:22 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy8HxjHVOGgSltVY7+L8OAprTOL9y99MalIIMCzaKFy549sNoa3aNqamqqKkpnE/uM8EtcfcA==
X-Received: by 2002:a05:600c:34e:: with SMTP id u14mr18779925wmd.110.1570447281840;
        Mon, 07 Oct 2019 04:21:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9dd9:ce92:89b5:d1f2? ([2001:b07:6468:f312:9dd9:ce92:89b5:d1f2])
        by smtp.gmail.com with ESMTPSA id s9sm14736620wme.36.2019.10.07.04.21.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 04:21:21 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: VMX: Mask advanced VM-exit info
To:     Nadav Amit <namit@vmware.com>
Cc:     kvm@vger.kernel.org, sean.j.christopherson@intel.com
References: <20191003132618.8485-1-namit@vmware.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7d8f9cd0-c890-018d-49fa-a0f93325b5ee@redhat.com>
Date:   Mon, 7 Oct 2019 13:21:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003132618.8485-1-namit@vmware.com>
Content-Language: en-US
X-MC-Unique: _L9w8niMPsSXdaUqjkcOag-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/10/19 15:26, Nadav Amit wrote:
> Bits [9:11] are undefined in the VM-exit qualification when "advanced
> VM-exit information for EPT violations" is not supported.
>=20
> Mask these bits for now to avoid false failures. If KVM supports this
> feature, the tests would need to be adapted, and the masking would need
> to be removed.
>=20
> Unfortunately, I do not have hardware that supports this feature
> available for my use to make a better fix.
>=20
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  x86/vmx.h       | 2 ++
>  x86/vmx_tests.c | 7 +++++++
>  2 files changed, 9 insertions(+)
>=20
> diff --git a/x86/vmx.h b/x86/vmx.h
> index a8bc847..8496be7 100644
> --- a/x86/vmx.h
> +++ b/x86/vmx.h
> @@ -618,6 +618,8 @@ enum vm_instruction_error_number {
>  #define EPT_VLT_GUEST_USER=09(1ull << 9)
>  #define EPT_VLT_GUEST_RW=09(1ull << 10)
>  #define EPT_VLT_GUEST_EX=09(1ull << 11)
> +#define EPT_VLT_GUEST_MASK=09(EPT_VLT_GUEST_USER | EPT_VLT_GUEST_RW | \
> +=09=09=09=09 EPT_VLT_GUEST_EX)
> =20
>  #define MAGIC_VAL_1=09=090x12345678ul
>  #define MAGIC_VAL_2=09=090x87654321ul
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index f4b348b..6b9dc10 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -1409,6 +1409,13 @@ static int ept_exit_handler_common(bool have_ad)
>  =09=09}
>  =09=09return VMX_TEST_RESUME;
>  =09case VMX_EPT_VIOLATION:
> +=09=09/*
> +=09=09 * Exit-qualifications are masked not to account for advanced
> +=09=09 * VM-exit information. Once KVM supports this feature, this
> +=09=09 * masking should be removed.
> +=09=09 */
> +=09=09exit_qual &=3D ~EPT_VLT_GUEST_MASK;
> +
>  =09=09switch(vmx_get_test_stage()) {
>  =09=09case 3:
>  =09=09=09check_ept_ad(pml4, guest_cr3, (unsigned long)data_page1, 0,
>=20

Queued, thanks.

Paolo

