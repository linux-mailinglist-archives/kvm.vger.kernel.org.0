Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16CF0BC9AE
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 16:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392003AbfIXOEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 10:04:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60214 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725855AbfIXOEA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 10:04:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569333839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W3DPaxgx9km+cZHa9K8a/UNxJGmQdDCXfRT8kRyqF2g=;
        b=BifBHqMw4eoWhkovWnTjZxuotjEkg6Biqsi3jk5pblxf+iytZ0TGNAeoEnbS7g6kBQfb0V
        r05Hhiq0BVk6ahZ6CSLWsMekkxAjfHCvdD38UDE6ifmG+0WMUlBmoD9vk9f7BDvRexuNik
        V09dGrxb47vzhmaovQI1Oi6RDP03VKg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-j5CrfpR7PZGvDzcSppIoPQ-1; Tue, 24 Sep 2019 10:03:58 -0400
Received: by mail-wr1-f72.google.com with SMTP id a15so621782wrq.4
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 07:03:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/wQ7P/ld8KDzlSg+3P3mHqXgD4e/a0VVMFo4TtvUIhI=;
        b=WmTmY0cWfC7jSrgJ1kx54gCgtPvGGNtNSfCwqenkHS4vkXBJLtJ+rCu9s41+G1a5cg
         N+wSWo7QigLu2zorezhwuQEvvO7jM4hz5S5G9V1QlAGxOkAviUWCbUIctP69HaFYrG+1
         NhMoJ1QFTDh4dAuj+ZOtv0SL/MxtLncSfDduBtNl/qey1G6ktMtrFk3t9iie/YIKYEqW
         i47K1jCzTHobGT8R6uVBrK5KkCbp6SF9Jy6sI74vT10vfAnO45V3RokkntgkgSLPnS64
         +bTXLQ71P6AhYyXt3vJU7ytezKVHDss+Uti5ZyBps21NU301luDgMT9/KLGNruWdHBq8
         HzFg==
X-Gm-Message-State: APjAAAVBx88j7mSypThVUO3hWhahgJhRPiTWZyJEDzjF/5jlJTjn1W3d
        FyeM1ItIf5E5gtJN48O8uzkUi4orNpQuJfQdF0nU1o0uJl56a1V0vz2nh5uOErNTlYsKWiMmE2p
        Tu2PYdQeM6PIn
X-Received: by 2002:a05:600c:2412:: with SMTP id 18mr184539wmp.128.1569333836824;
        Tue, 24 Sep 2019 07:03:56 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy7g6lIit2UNQp3j9lNUGNcDFUQHiEh0hNmSUjLomSRSAp8vAIx4Vp1GGsPAgtwdF6Bps5DFw==
X-Received: by 2002:a05:600c:2412:: with SMTP id 18mr184517wmp.128.1569333836569;
        Tue, 24 Sep 2019 07:03:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id h125sm116651wmf.31.2019.09.24.07.03.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2019 07:03:55 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: setjmp: check expected value of "i"
 to give better feedback
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com
References: <20190911023142.85970-1-morbo@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1f29ab35-c4f8-80c7-6565-91361051fa8d@redhat.com>
Date:   Tue, 24 Sep 2019 16:03:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190911023142.85970-1-morbo@google.com>
Content-Language: en-US
X-MC-Unique: j5CrfpR7PZGvDzcSppIoPQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/09/19 04:31, Bill Wendling wrote:
> Use a list of expected values instead of printing out numbers, which
> aren't very meaningful. This prints only if the expected and actual
> values differ.
>=20
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  x86/setjmp.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
>=20
> diff --git a/x86/setjmp.c b/x86/setjmp.c
> index 976a632..c0b25ec 100644
> --- a/x86/setjmp.c
> +++ b/x86/setjmp.c
> @@ -1,19 +1,30 @@
>  #include "libcflat.h"
>  #include "setjmp.h"
> =20
> +int expected[] =3D {
> +=090, 1, 2, 3, 4, 5, 6, 7, 8, 9
> +};
> +
> +#define NUM_EXPECTED (sizeof(expected) / sizeof(int))
> +
>  int main(void)
>  {
> -    volatile int i;
> +    volatile int i =3D -1, index =3D 0;
> +    volatile bool had_errors =3D false;
>      jmp_buf j;
> =20
>      if (setjmp(j) =3D=3D 0) {
>  =09    i =3D 0;
>      }
> -    printf("%d\n", i);
> -    if (++i < 10) {
> +    if (expected[index++] !=3D i) {
> +=09    printf("FAIL: actual %d / expected %d\n", i, expected[index]);
> +            had_errors =3D true;
> +    }
> +    if (index < NUM_EXPECTED) {
> +=09    i++;
>  =09    longjmp(j, 1);
>      }
> =20
> -    printf("done\n");
> +    printf("Test %s\n", had_errors ? "FAILED" : "PASSED");
>      return 0;
>  }
>=20

Queued, thanks.

Paolo

