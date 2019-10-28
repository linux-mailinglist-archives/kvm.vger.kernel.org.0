Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAD5BE6D9B
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2019 08:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733064AbfJ1H4d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Oct 2019 03:56:33 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44418 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731133AbfJ1H4d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Oct 2019 03:56:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572249391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=7eZcqHF8b9Ji9D25pn09VHOG3WM+NKx8xJbvY/2TLqA=;
        b=DbyZ1xQIU/cQOKXqY36GKaDvmznKy9CqnikuRE7wX9jOVLqZhYAi6cbeCSOufpoHqhgVim
        GDPbVRO08mf6aaXlJTNLRfAXJN3U+m6avExz5fyBOd4ZtgOpU9VwYD2gPK2yNzCJNYz5Js
        B+MQQEuR/n8IOTUqbl1jkLAChFJrum0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-7z_j0XJIP7CK3Fr82hueXA-1; Mon, 28 Oct 2019 03:56:29 -0400
Received: by mail-wr1-f70.google.com with SMTP id s17so5872668wrp.17
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2019 00:56:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S5NXpo19hb3uDxW1OhHDcHE5G0aGpOZOkhWsFlEbgJg=;
        b=bsVqfOtkTd0D2NohiQQusnh1FS2B0yYtWSMz2O11tbaAdqxlwnPva2K0b65JyNAb8y
         hO8de2l3yIgpatULtb5mTPjTnr0vbAAy3Pn7H92Ux4saR8oLGKgNlF9I7y5NZ+gM7yma
         I0hKKKBGiHKHfweFek1XuzJ0XttRQEofE+oX+tdUaPtRUYrfahOVUhXDIGvCW35TOsDD
         3JmWzkzLrS7Kee1F+RgF+5Qkipm+iuNT1d1DY3bUyT7/XxHQip8/xNwcKegNItzxbQOe
         3V9C21GbqHAGIuvO6fkO+pwnZsAAWb1jp943iFOmMzZsKVvg6OCZYtd8sv8hvByxW4K8
         Js8Q==
X-Gm-Message-State: APjAAAUp57Jn7XMVGYJSQz1hiapJH+ozBDaEYJR3DCq5ruYvQu9nqLTh
        aj0jjB4LNYRrnso5vLwY073l9i5adoSl87yGjKepLBYnj488hyb32jyFO55ehC4m7zRGa6QY8A/
        kv4mOAxGTRmuj
X-Received: by 2002:a1c:a6c8:: with SMTP id p191mr13488547wme.99.1572249388647;
        Mon, 28 Oct 2019 00:56:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxdujLnbZ/mVVjeXxdogH1Figcm+nBuCvScMbkWCn3k8Tpyjlo4tv3ouf7+I5YMO36ZXlV4Ug==
X-Received: by 2002:a1c:a6c8:: with SMTP id p191mr13488519wme.99.1572249388348;
        Mon, 28 Oct 2019 00:56:28 -0700 (PDT)
Received: from [192.168.42.37] (mob-37-176-198-149.net.vodafone.it. [37.176.198.149])
        by smtp.gmail.com with ESMTPSA id v9sm8889789wro.51.2019.10.28.00.56.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2019 00:56:27 -0700 (PDT)
Subject: Re: [PATCH] KVM: vmx, svm: always run with EFER.NXE=1 when shadow
 paging is active
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
References: <20191027152323.24326-1-pbonzini@redhat.com>
 <20191028065919.AB8C3208C0@mail.kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b08a0103-312e-5441-9ffe-33c9df0a9d57@redhat.com>
Date:   Mon, 28 Oct 2019 08:56:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191028065919.AB8C3208C0@mail.kernel.org>
Content-Language: en-US
X-MC-Unique: 7z_j0XJIP7CK3Fr82hueXA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/10/19 07:59, Sasha Levin wrote:
>=20
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>=20
> The bot has tested the following trees: v5.3.7, v4.19.80, v4.14.150, v4.9=
.197, v4.4.197.
>=20
> v5.3.7: Build OK!
> v4.19.80: Failed to apply! Possible dependencies:
>     Unable to calculate
>=20
> v4.14.150: Failed to apply! Possible dependencies:
>     Unable to calculate
>=20
> v4.9.197: Failed to apply! Possible dependencies:
>     Unable to calculate
>=20
> v4.4.197: Failed to apply! Possible dependencies:
>     Unable to calculate
>=20
>=20
> NOTE: The patch will not be queued to stable trees until it is upstream.
>=20
> How should we proceed with this patch?

It should apply just fine to all branches, just to arch/x86/kvm/vmx.c
instead of arch/x86/kvm/vmx/vmx.c.

Paolo

