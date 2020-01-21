Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F716143CC2
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 13:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729568AbgAUMZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 07:25:53 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21020 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727173AbgAUMZx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 07:25:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579609551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yIalB9cBALXRgp/uNH08VZa3aNqDipb3jjDmU3WLB8Q=;
        b=B0O05LVdsdN8cl5sfYDyazqdvVuba8uMhZcTJubXc/xw7dL/03hVzrqUdOIZTd/XXsQDya
        MIQ8hGzamLOiTF/uUM/nAsUHc12VSFQMJvqT6b1a76f2q8B6KabTNx5I7KivHPNEasKJmp
        UpI55Le3m8BuS7G+h5QRAny0/yvSSqI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-xvJ50TVgPpmV_em52bUF1g-1; Tue, 21 Jan 2020 07:25:50 -0500
X-MC-Unique: xvJ50TVgPpmV_em52bUF1g-1
Received: by mail-wr1-f69.google.com with SMTP id 90so1239559wrq.6
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 04:25:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yIalB9cBALXRgp/uNH08VZa3aNqDipb3jjDmU3WLB8Q=;
        b=k/UjVBzoHOGHNKsxKbf29KUsTX0N59feEGYlk/Kt9REqLqwtcfAJyO20SggeIo9j1y
         FsLl7zkRg/ZRmjUWtxI1co7rp2GEfGE8dUI4cSvPlMvWvYMYq43lFvKRggSgAf21T7JU
         IQckghGpEI5ub9rNyNLgUjyDAN/A4XLotJaSEpLdxAUeg83X4pyPrlhESp6Cpb3EAH7D
         fOuuxJivrDdn7CCU8LdSZIWmz3OGe3AXNrR03gxIESRVnXJFuVy3oFrHIODarTkRafG1
         UPPT8UuxQGdNt2zMmjTbUpsRP2NPAhZetiFowJ1RwFkQgzHuiX2S94IOn+9LOH/qT//u
         D4sg==
X-Gm-Message-State: APjAAAVvyHCXSpEdCSwI9Vk4rBfLCSm4omtUx8EuVNA9qFppJ0zZkPtO
        Qcnw24egebJkonaba5gUp9AJZSRR6Tgx1NAGhyOEkKme51yedo7ff7tIbO1+AFGm/UhxykFSjSb
        ifaA7n+Xe/m13
X-Received: by 2002:a5d:4e90:: with SMTP id e16mr4900211wru.318.1579609549463;
        Tue, 21 Jan 2020 04:25:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqxDJBpeRnDpwBUTmvjf0/2nvS8A5DXXrLixRiDHN9QnRC30oFmfVLhbmYyQlNVKrDuaKY0sSA==
X-Received: by 2002:a5d:4e90:: with SMTP id e16mr4900192wru.318.1579609549154;
        Tue, 21 Jan 2020 04:25:49 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id j12sm53225490wrt.55.2020.01.21.04.25.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 04:25:48 -0800 (PST)
Subject: Re: [PATCH] kvm/x86: export kvm_vector_hashing_enabled() is
 unnecessary
To:     Peng Hao <richard.peng@oppo.com>, rkrcmar@redhat.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1574814625-29295-1-git-send-email-richard.peng@oppo.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fa69afdb-f140-8891-c73f-ccbe4abbd108@redhat.com>
Date:   Tue, 21 Jan 2020 13:25:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1574814625-29295-1-git-send-email-richard.peng@oppo.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/11/19 01:30, Peng Hao wrote:
> kvm_vector_hashing_enabled() is just called in kvm.ko module.
> 
> Signed-off-by: Peng Hao <richard.peng@oppo.com>
> ---
>  arch/x86/kvm/x86.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5d53052..169cea6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10236,7 +10236,6 @@ bool kvm_vector_hashing_enabled(void)
>  {
>  	return vector_hashing;
>  }
> -EXPORT_SYMBOL_GPL(kvm_vector_hashing_enabled);
>  
>  bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
>  {
> 

Queued, thanks.

Paolo

