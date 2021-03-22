Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479A33450A9
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 21:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhCVUWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 16:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbhCVUWI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 16:22:08 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA300C061574;
        Mon, 22 Mar 2021 13:22:07 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id y5so10469537qkl.9;
        Mon, 22 Mar 2021 13:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=4yeDve+gQFzbZs6MDoPWM7myPNYhHOJQJ4p72qgVrAg=;
        b=dftT2BIXpUPulHTCx8+3mVr0yDRQeJazs1z40LyOb6rPBMzAcxGjNQ/p3uVtZhq02e
         XdK4D27eSoN5bCL5K+C1Q1q8uQ4RizSwwxe3s2/w2sa5Uy1wYeUTVJ8QaDjjrerwXvS1
         KGY7AvoQXyeVqmUHZPuQ0KjwrMCjoI9bGyZ15oEfTa43XMvNeDq7AHQaQ5E6hxVsQDcP
         YuzYIroYBgUg3+5ZzfvJNtav5QkLwa+IaFUJhe/iexs+eMTv2Q56tMxofR7o1PZ/dGzl
         yaksTxvRQvDe6yjK412m/zr313/akcY9WsX62pxr0sarkjhUEn2L3MWc+mr4X8s+4hoB
         EabQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=4yeDve+gQFzbZs6MDoPWM7myPNYhHOJQJ4p72qgVrAg=;
        b=tO/NAMX8Smf3fyXVAdGeq3bHJbTt5T1vlc0tmc24gwHjc4fnvSca90wS5GrJDaHIsr
         0iNHfDVP14Rc0ELQhlemdoBPvI3Wf0cISot8vxcxpLmTXYmZmoyTmRIfdkTPy/6WjlMN
         a8ecspzLJbmwozTC2Y1T9IBAdWSsodJJozNaE9oGZ5Xg7ZGDr7rUbEADKmFW23Iu4mPn
         4EUoapmRrWYuXm6lsu+SH+9+lj6eC7z+Ce/nu6UMoQJvBbg2+cGZCSnghPFMMz0jtefw
         33BQpUk4RuGcwTGHCYRCyb493CNhYYcxAJtP10UChe7ZWoFtp2niUKbWTdI1f+rpmdcr
         UKjw==
X-Gm-Message-State: AOAM533ITYRwQpdOn4J8O+RuitA8qhlwbFxFxiqmcXb+OavjX+nXVa8/
        qU68ZoVapqFBUqZn0jiNvJM=
X-Google-Smtp-Source: ABdhPJysOViSl2lqVbBGwbUm+XNbiZlr8CVBPAtDtEfniCdNp7tRUR2jtQCc4rt/odcTr4pV/5Pf2Q==
X-Received: by 2002:a05:620a:714:: with SMTP id 20mr1978217qkc.192.1616444527018;
        Mon, 22 Mar 2021 13:22:07 -0700 (PDT)
Received: from ArchLinux ([138.199.10.68])
        by smtp.gmail.com with ESMTPSA id d3sm12094041qke.27.2021.03.22.13.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 13:22:05 -0700 (PDT)
Date:   Tue, 23 Mar 2021 01:51:52 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Ingo Molnar <mingo@kernel.org>
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org
Subject: Re: [PATCH V2] KVM: x86: A typo fix
Message-ID: <YFj8YAz56Nh3KWMY@ArchLinux>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org
References: <20210322060409.2605006-1-unixbhaskar@gmail.com>
 <20210322201644.GA1955593@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HA1BCpxOM6TPiEt/"
Content-Disposition: inline
In-Reply-To: <20210322201644.GA1955593@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--HA1BCpxOM6TPiEt/
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 21:16 Mon 22 Mar 2021, Ingo Molnar wrote:
>
>* Bhaskar Chowdhury <unixbhaskar@gmail.com> wrote:
>
>> s/resued/reused/
>>
>>
>> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
>> ---
>>  Changes from V1:
>>  As Ingo found the correct word for replacement, so incorporating.
>>
>>  arch/x86/include/asm/kvm_host.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 3768819693e5..e37c2ebc02e5 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1488,7 +1488,7 @@ extern u64 kvm_mce_cap_supported;
>>  /*
>>   * EMULTYPE_NO_DECODE - Set when re-emulating an instruction (after completing
>>   *			userspace I/O) to indicate that the emulation context
>> - *			should be resued as is, i.e. skip initialization of
>> + *			should be reused as is, i.e. skip initialization of
>>   *			emulation context, instruction fetch and decode.
>>   *
>>   * EMULTYPE_TRAP_UD - Set when emulating an intercepted #UD from hardware.
>
>I already fixed this typo - and another 185 typos, in this
>comprehensive cleanup of arch/x86/ typos in tip:x86/cleanups:
>
>  d9f6e12fb0b7: ("x86: Fix various typos in comments")
>  163b099146b8: ("x86: Fix various typos in comments, take #2")
>
>Please check future typo fixes against tip:master.
>
  Thank you!!

>Thanks,
>
>	Ingo

--HA1BCpxOM6TPiEt/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAmBY/F0ACgkQsjqdtxFL
KRXwlQf/RklpbO0YkPqfrRp1ihoeED8a74XgbJxJqpAyjWMI1gJQQURDTrJW51M/
euAHluwYPcjt1EmunlFeypfDW+dGUdPcSKokWJ9m/3v1C6HYpOd4/rwd2VINbUfH
nCjjLyGt8gXq6NtwAzCvClPo6cmZfzwJkbSHKi9s1kL/J+cr0so9XDdUERN/ag2e
S0LsRSNn3pPmN3IDb6TpwLixtTJSRrb2swxH1EEaQLN510c0mOL3aA6LXfXI4uBi
Yvt/AkPFCezfI7U5Py/WXMjRRFVL0t7HmtbwPPoaTAEIKr/vABLqYKJcBgb9iA92
CUL5mEKEF6ZyR6Faq5iKQG0JavkV7Q==
=NziD
-----END PGP SIGNATURE-----

--HA1BCpxOM6TPiEt/--
