Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3E1DF755D
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 14:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfKKNtn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 08:49:43 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50546 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726879AbfKKNtn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 08:49:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573480182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=EY5+4NqtD637Jq/iOkgRi0CcCRIMuNTpq8KDCNXJJLA=;
        b=NKUMVB+8n8RzeJtYPblppCnQ1AcTTttwLNCIS0OUXbi+vvfiBEwFghLVOqCOlmi4lPYKZO
        1gQNbjSndP/Z04j2hdiI7zjqP0rFpPJJEVM5AanvA+BYJMBBw56+gTlpNPKy85km07XnHk
        ODaqbDWxUNu6LRKwAdPGPVOBGy+vLr4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-y7uWyjZ9M6WyL0nf4keCAA-1; Mon, 11 Nov 2019 08:49:39 -0500
Received: by mail-wr1-f71.google.com with SMTP id 4so9978616wrf.19
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 05:49:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EtDO20YQ4gCjEjWttnh7Y94CePcbnhFksyEQrtJO8cs=;
        b=b0MVmXZQQ9HnEnG06HiRdSYMed3KYxUetNBrH5tzJ3tGHauLHeFvo8ZSPkDg3t+5nN
         lSutPTo/VXBapxzypMElwWEhL7EXSH+/2WWPLDUfOYmtQ+wWyFUJ9/C5eGFxiAYjV1tU
         rRCuQL9niV95KngbqilQGz3U05ZOBYXL4/cCOZBhNwjSIGfV8HutkOVTRYL2jBdkLRC5
         +sUmU1nneFGoI1orEtckZSnBnKdejIdJwnac1PoQFBqHxmd4DQ8bYrPX7Ll6x/JnO0ch
         J6r/h6JMi9/IYG1VUu5utQPUD/HpWHunEilpx/4RSKevT5BkQAqgM6MrZRE5ev5ESuAX
         bOGw==
X-Gm-Message-State: APjAAAWcIsrtCk0uf5Fr4q28nQjmHIieioxQ1sQ7F96M+UvV0q0B2IOA
        GbLl0hPnGgrV4qMa+5RqDFMU0x/hMGORS6r2SfZ8eDxx32XfAZEPqw1xgRs9YKroPp7DvUxYPg0
        YxIMxpdlBWhBS
X-Received: by 2002:adf:c00a:: with SMTP id z10mr10055406wre.81.1573480178213;
        Mon, 11 Nov 2019 05:49:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqwHJZ7aG6D3DbvVErNHEtfXPfD9Yik6GMDJjGqtT+LDE8STop0GLyX9fdTYVK2/+Xc2br2hTg==
X-Received: by 2002:adf:c00a:: with SMTP id z10mr10055388wre.81.1573480177951;
        Mon, 11 Nov 2019 05:49:37 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id a15sm14665669wrw.10.2019.11.11.05.49.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 05:49:37 -0800 (PST)
Subject: Re: [PATCH 2/5] KVM: add a check to ensure grow start value is
 nonzero
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, mtosatti@redhat.com,
        joao.m.martins@oracle.com, rafael.j.wysocki@intel.com,
        rkrcmar@redhat.com
References: <1572060239-17401-1-git-send-email-zhenzhong.duan@oracle.com>
 <1572060239-17401-3-git-send-email-zhenzhong.duan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <391dd11b-ebbb-28ff-5e57-4a795cd16a1b@redhat.com>
Date:   Mon, 11 Nov 2019 14:49:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1572060239-17401-3-git-send-email-zhenzhong.duan@oracle.com>
Content-Language: en-US
X-MC-Unique: y7uWyjZ9M6WyL0nf4keCAA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/10/19 05:23, Zhenzhong Duan wrote:
> vcpu->halt_poll_ns could be zeroed in certain cases (e.g. by
> halt_poll_ns_shrink). If halt_poll_ns_grow_start is zero,
> vcpu->halt_poll_ns will never be larger than zero.
>=20
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> ---
>  virt/kvm/kvm_main.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2ca2979..1b6fe3b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2266,6 +2266,13 @@ static void grow_halt_poll_ns(struct kvm_vcpu *vcp=
u)
>  =09=09goto out;
> =20
>  =09val *=3D grow;
> +
> +=09/*
> +=09 * vcpu->halt_poll_ns needs a nonzero start point to grow if it's zer=
o.
> +=09 */
> +=09if (!grow_start)
> +=09=09grow_start =3D 1;
> +
>  =09if (val < grow_start)
>  =09=09val =3D grow_start;
> =20
>=20

Zeroing grow_start will simply disable halt polling.  Is that a problem?

Paolo

