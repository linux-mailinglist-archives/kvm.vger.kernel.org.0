Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29ED71E78F8
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 11:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgE2JDw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 05:03:52 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47186 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725790AbgE2JDw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 05:03:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590743030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=naQYmC0gxQ8OHJgIbB7LClKCK1MMSYkhwGitHp7AcpI=;
        b=f6yFqG071E4j3qDWZKqz4EjX50tIqlwAfEn24PS2AX5mKDdr7mgBF7PYDu5Gwd0wDwYwbb
        IJpHKijTaBDFVGdaBp2lpvVuO0Ym4rCBSrl8RB1EN12elMcz64PHEJ9JKXmqkYztKTg4oN
        eXozfcJ83a6P6NWJKdE39Soug3sBv6w=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-un6fyTi5M2yZAB6k_uLOcA-1; Fri, 29 May 2020 05:03:48 -0400
X-MC-Unique: un6fyTi5M2yZAB6k_uLOcA-1
Received: by mail-wr1-f72.google.com with SMTP id 3so777993wrs.10
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 02:03:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=naQYmC0gxQ8OHJgIbB7LClKCK1MMSYkhwGitHp7AcpI=;
        b=iloDfugU9nNif2SFx3kJPWrg2Q3VNqbPC7DuwuBVap7cV/p95/U6D7zcziA89rPci0
         NEAaj2ZwY6XAXeQYStJyZFhQ6Z4ZcoAf8Z30LZ18AZq+tkFlaouFy2uqWpoDm3rb3cyk
         /LMhG0jpQRai8S7PWyMVqbsv+DoXKaHXcZbfGXTPIJ7dFmHH0v/LMbWfMGYVpOdTyVV+
         aYY5LY1H/QE4wcdtl/0Ax4s7Ty2e0TjWXzzqVer6mv+cisMg/JFX22Z8bST0/LNGqnmK
         FBhZ0F/5hEl3xFskO9MEvnZ3nEFWoXv8V180goRL4E3kJVD7+sBNMUjdJ53R8XtfPHcg
         aOEQ==
X-Gm-Message-State: AOAM530W/drXdlVQrKw5o9R/5pLor6Pc6ldPsTfMF4df6foy9TeKug0M
        layvAcqnAzgFBjKSytrtcELNxMJfeHcyiP6/D2VZOmhZxdEZO3Xlu8UXL/2GcvH+IwaOTGxcpGR
        eCmLMyGvshGK0
X-Received: by 2002:a5d:4008:: with SMTP id n8mr7492690wrp.82.1590743027321;
        Fri, 29 May 2020 02:03:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4/zoE02cbZMsJJWKYfDHXKSXsqs52R/ZdT34PIKamzk+2Jwo0OhPmf2WgXA9EvKx9PpA9Qg==
X-Received: by 2002:a5d:4008:: with SMTP id n8mr7492676wrp.82.1590743027119;
        Fri, 29 May 2020 02:03:47 -0700 (PDT)
Received: from [192.168.1.34] (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id d17sm8606539wrg.75.2020.05.29.02.03.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 02:03:46 -0700 (PDT)
Subject: Re: [RFC v2 02/18] target/i386: sev: Move local structure definitions
 into .c file
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-3-david@gibson.dropbear.id.au>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Autocrypt: addr=philmd@redhat.com; keydata=
 mQINBDXML8YBEADXCtUkDBKQvNsQA7sDpw6YLE/1tKHwm24A1au9Hfy/OFmkpzo+MD+dYc+7
 bvnqWAeGweq2SDq8zbzFZ1gJBd6+e5v1a/UrTxvwBk51yEkadrpRbi+r2bDpTJwXc/uEtYAB
 GvsTZMtiQVA4kRID1KCdgLa3zztPLCj5H1VZhqZsiGvXa/nMIlhvacRXdbgllPPJ72cLUkXf
 z1Zu4AkEKpccZaJspmLWGSzGu6UTZ7UfVeR2Hcc2KI9oZB1qthmZ1+PZyGZ/Dy+z+zklC0xl
 XIpQPmnfy9+/1hj1LzJ+pe3HzEodtlVA+rdttSvA6nmHKIt8Ul6b/h1DFTmUT1lN1WbAGxmg
 CH1O26cz5nTrzdjoqC/b8PpZiT0kO5MKKgiu5S4PRIxW2+RA4H9nq7nztNZ1Y39bDpzwE5Sp
 bDHzd5owmLxMLZAINtCtQuRbSOcMjZlg4zohA9TQP9krGIk+qTR+H4CV22sWldSkVtsoTaA2
 qNeSJhfHQY0TyQvFbqRsSNIe2gTDzzEQ8itsmdHHE/yzhcCVvlUzXhAT6pIN0OT+cdsTTfif
 MIcDboys92auTuJ7U+4jWF1+WUaJ8gDL69ThAsu7mGDBbm80P3vvUZ4fQM14NkxOnuGRrJxO
 qjWNJ2ZUxgyHAh5TCxMLKWZoL5hpnvx3dF3Ti9HW2dsUUWICSQARAQABtDJQaGlsaXBwZSBN
 YXRoaWV1LURhdWTDqSAoUGhpbCkgPHBoaWxtZEByZWRoYXQuY29tPokCVQQTAQgAPwIbDwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4AWIQSJweePYB7obIZ0lcuio/1u3q3A3gUCXsfWwAUJ
 KtymWgAKCRCio/1u3q3A3ircD/9Vjh3aFNJ3uF3hddeoFg1H038wZr/xi8/rX27M1Vj2j9VH
 0B8Olp4KUQw/hyO6kUxqkoojmzRpmzvlpZ0cUiZJo2bQIWnvScyHxFCv33kHe+YEIqoJlaQc
 JfKYlbCoubz+02E2A6bFD9+BvCY0LBbEj5POwyKGiDMjHKCGuzSuDRbCn0Mz4kCa7nFMF5Jv
 piC+JemRdiBd6102ThqgIsyGEBXuf1sy0QIVyXgaqr9O2b/0VoXpQId7yY7OJuYYxs7kQoXI
 6WzSMpmuXGkmfxOgbc/L6YbzB0JOriX0iRClxu4dEUg8Bs2pNnr6huY2Ft+qb41RzCJvvMyu
 gS32LfN0bTZ6Qm2A8ayMtUQgnwZDSO23OKgQWZVglGliY3ezHZ6lVwC24Vjkmq/2yBSLakZE
 6DZUjZzCW1nvtRK05ebyK6tofRsx8xB8pL/kcBb9nCuh70aLR+5cmE41X4O+MVJbwfP5s/RW
 9BFSL3qgXuXso/3XuWTQjJJGgKhB6xXjMmb1J4q/h5IuVV4juv1Fem9sfmyrh+Wi5V1IzKI7
 RPJ3KVb937eBgSENk53P0gUorwzUcO+ASEo3Z1cBKkJSPigDbeEjVfXQMzNt0oDRzpQqH2vp
 apo2jHnidWt8BsckuWZpxcZ9+/9obQ55DyVQHGiTN39hkETy3Emdnz1JVHTU0Q==
Message-ID: <45133315-1e1e-e13c-a8df-6a9d972c90a1@redhat.com>
Date:   Fri, 29 May 2020 11:03:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200521034304.340040-3-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/21/20 5:42 AM, David Gibson wrote:
> Neither QSevGuestInfo nor SEVState (not to be confused with SevState) is
> used anywhere outside target/i386/sev.c, so they might as well live in
> there rather than in a (somewhat) exposed header.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  target/i386/sev.c      | 44 ++++++++++++++++++++++++++++++++++++++++++
>  target/i386/sev_i386.h | 44 ------------------------------------------
>  2 files changed, 44 insertions(+), 44 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

