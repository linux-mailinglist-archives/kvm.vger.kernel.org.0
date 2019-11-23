Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3935107E11
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2019 11:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfKWKeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Nov 2019 05:34:02 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32821 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726451AbfKWKeB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 23 Nov 2019 05:34:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574505240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=YN+8bXTdlBuEQUJV6OsdYPmAJyhA5I0Z6Pz1c4TArp8=;
        b=M2jkULKmYie/ri8etgeZJ+MBxAWCaFdxHbj1248qCG3YWbS+P2Mx7ex+/lehlDXCD6C53D
        ly2zgoyHWgrAULlUnOtG+JKku1CFuahtuyZtlkwP+24uoY9w0/yPTZlGBWFDERY8ZCJ8UW
        XFJq2OgAeiQjkvD01G0GZJMi/9pN/S4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-byxN0hH0N8WkoRIwGf92LA-1; Sat, 23 Nov 2019 05:33:59 -0500
Received: by mail-wr1-f71.google.com with SMTP id p1so4175704wrw.8
        for <kvm@vger.kernel.org>; Sat, 23 Nov 2019 02:33:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9VSZpK8pNmHbRqrnKqlHvpr3Wn58pNyrhEcQ04Ilj/E=;
        b=bcnCT8xz8Jw/kAxF95FJLhpLdHWhNFKiH81ZZ71UjVgsBJnh6ChCuf+2vN1sJyUrHx
         eV9rAIQ1RS+WUATbOVIjRu9p+NZUhXhc8HDH/eSnj+u8CHwbCE/yYkO/2AowFjSuu7kC
         fOHW57OE+uYpVe9XZrmCCAgojvf8qhw6w+3AHhAZziELwClMbNPA2Chjd5SwWeSmlcmZ
         LNP0zmCLsnfOr/Dre6sjby9hz//o9+APPVQNALztZJD8n4R65PNSAaxjAFSwtutDLl6e
         2I86MHGB3OYUJxgs9Dnv9QlLZktxMZw8dkghxHFPi7NrozNyydBmIZgbkxmK6zuuujbr
         tvmA==
X-Gm-Message-State: APjAAAVl6YWb6xBXwuGF0+lF0iVoEo7fnsAqb3fF+/eNtu/aTuBF0oHw
        fJqgGf9Hvrw5vJ9jdcRKEUoU3jgowTQPrlv+n1rqRv3ht+5scRXpHWXiyKqBSvo33YL3E7f+IQU
        joVACTuD6iRuY
X-Received: by 2002:adf:f343:: with SMTP id e3mr3626535wrp.55.1574505238188;
        Sat, 23 Nov 2019 02:33:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqxCxqaTxZ80R8/8A2uVKPNRL+c0LtTMizco3TZ81dr0M+rcMjyr8vmv+2IwCUotZjyvi22gwQ==
X-Received: by 2002:adf:f343:: with SMTP id e3mr3626519wrp.55.1574505237927;
        Sat, 23 Nov 2019 02:33:57 -0800 (PST)
Received: from [192.168.42.104] (mob-109-112-4-118.net.vodafone.it. [109.112.4.118])
        by smtp.gmail.com with ESMTPSA id s9sm1346749wmj.22.2019.11.23.02.33.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Nov 2019 02:33:57 -0800 (PST)
Subject: Re: [kvm-unit-tests Patch v1 0/2] x86: Test IOAPIC physical and
 logical destination mode
To:     Nitesh Narayan Lal <nitesh@redhat.com>, kvm@vger.kernel.org,
        thuth@redhat.com, mtosatti@redhat.com
References: <1573044429-7390-1-git-send-email-nitesh@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <58ebae99-f268-639f-3003-ec15bac0c58d@redhat.com>
Date:   Sat, 23 Nov 2019 11:33:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1573044429-7390-1-git-send-email-nitesh@redhat.com>
Content-Language: en-US
X-MC-Unique: byxN0hH0N8WkoRIwGf92LA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/11/19 13:47, Nitesh Narayan Lal wrote:
> The first patch adds smp configuration to ioapic unittest and
> the second one adds the support to test both physical and logical destina=
tion
> modes under fixed delivery mode.
>=20
> Nitesh Narayan Lal (2):
>   x86: ioapic: Add the smp configuration to ioapic unittest
>   x86: ioapic: Test physical and logical destination mode
>=20
>  x86/ioapic.c      | 65 +++++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  x86/unittests.cfg |  1 +
>  2 files changed, 66 insertions(+)
>=20

Applied, thanks.

Paolo

