Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 337D6BDF3E
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 15:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406739AbfIYNo5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 09:44:57 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52543 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406644AbfIYNo4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Sep 2019 09:44:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569419095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jhbggcIQBc3PqsSqabpeXS3F+gqW4JfNkw6D7JQWGoY=;
        b=UPPR7734wRPYxoslZ/fGL/C8kYqVbHhTi9O2eptGD5hshfX9S0TGYS9SE1Qalaoo5s7K6R
        dPSe686Gmv4i/dKlUgeBTwgSGGKiB9X7Ic4Yij2pOuUAm2qQVFl3G3xJ+eXdXwyTf/ftpt
        BLOThFkW6MkWxAtv88paUNskRQKRTa4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-Ee96hKw5M9ioQf9UbLb__A-1; Wed, 25 Sep 2019 09:44:51 -0400
Received: by mail-wm1-f70.google.com with SMTP id n3so2215141wmf.3
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 06:44:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G8n65e4xIuXE4z99OGsP4uOi+xh2WtImwH79jDys+yI=;
        b=UoZ7iiCam4w0QkxP28+M7R3mddBFvlBr0AceWFFu/3jgOMsyicYteVA7BISBrF4GwW
         jgHYU59EVOKhHJpLU1wEzafUDVTr6UM0TnKecG5wyvdjD/4hpIOyF+pTaQqevfCBpX1X
         co/pwJ7wkeJfVQA3qiLlr+3HMX84i2KBVT9jWZ1CAhM1Uof59SdLFyyeCIZpjPGV3Jv2
         u0Qc4hd5rBgZdfmsDrz26q/IxKTd73H86yhc8COPvW304oxWP11RKr+40wVOYEnxWbK1
         7gd53qF/hLlIgdLFRPoj3lzRtQBdc/Ddz7dG1l7S2D3h2EeO19kz3mVJNWHkFCO2p7Dy
         KzBA==
X-Gm-Message-State: APjAAAWeicD/PWMvcMe5zBwb5zWWd52QID+bCec/oNPGcRMce+5nafoy
        vD0nWZWjez9G40okxxG7yEf5ppjX6TiwhsN/38YBJ3/dIhiw6QWJpFfUq9fe1fYRJkrPOxuxQC9
        TJys15DT3zbcV
X-Received: by 2002:a7b:c34e:: with SMTP id l14mr4388260wmj.123.1569419090110;
        Wed, 25 Sep 2019 06:44:50 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzjZpJmdwyRO/26eUmOwzFa14qujo5abY3KWAhcX4gd1pHVOdfTKJqekwOPMUsCHez3yqOeqw==
X-Received: by 2002:a7b:c34e:: with SMTP id l14mr4388237wmj.123.1569419089855;
        Wed, 25 Sep 2019 06:44:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id d28sm8921063wrb.95.2019.09.25.06.44.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 06:44:49 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: emulator: use "q" operand modifier
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org
References: <CAGG=3QV-0hPrWx8dFptjqbKMNfne+iTfq2e-KL89ebecO8Ta1w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8abce967-12a5-443f-6397-dec63427acf1@redhat.com>
Date:   Wed, 25 Sep 2019 15:44:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAGG=3QV-0hPrWx8dFptjqbKMNfne+iTfq2e-KL89ebecO8Ta1w@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: Ee96hKw5M9ioQf9UbLb__A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/09/19 23:28, Bill Wendling wrote:
> The extended assembly documentation list only "q" as an operand modifier
> for DImode registers. The "d" seems to be an AMD-ism, which appears to
> be only begrudgingly supported by gcc.
>=20
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  x86/emulator.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/x86/emulator.c b/x86/emulator.c
> index b132b90..621caf9 100644
> --- a/x86/emulator.c
> +++ b/x86/emulator.c
> @@ -799,7 +799,7 @@ static void test_smsw_reg(uint64_t *mem)
>   asm(KVM_FEP "smswl %k0\n\t" : "=3Da" (rax) : "0" (in_rax));
>   report("32-bit smsw reg", rax =3D=3D (u32)cr0);
>=20
> - asm(KVM_FEP "smswq %d0\n\t" : "=3Da" (rax) : "0" (in_rax));
> + asm(KVM_FEP "smswq %q0\n\t" : "=3Da" (rax) : "0" (in_rax));
>   report("64-bit smsw reg", rax =3D=3D cr0);
>  }
>=20

Queued, thanks.

However, note that the patch mangled tabs into spaces.

Paolo

