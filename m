Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0A91CF36D
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 13:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729558AbgELLfd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 07:35:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53599 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729540AbgELLfd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 07:35:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589283331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+BiTuuhaiRCRuygJo/UfgMumeWw31HiTY05kAioh0sw=;
        b=aI5hNrAW8dWtsg8iX64oeJ+bBnCen+LPzVDJpI6j/48p3MTV4viLvyDnxCGXfnx7f0Zjch
        zf7sMIqGfqZ8EtSUZUWV8QEsREW8lVsbo8vpLJftZ/ytxRA9V6/wC3gG/0l7SyUlFjBNly
        x52UXqYwkSth8uoPvc55swUzjzPNlls=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-sxi_k_52PAyfMKYSauzZjQ-1; Tue, 12 May 2020 07:35:29 -0400
X-MC-Unique: sxi_k_52PAyfMKYSauzZjQ-1
Received: by mail-wr1-f70.google.com with SMTP id 90so6733692wrg.23
        for <kvm@vger.kernel.org>; Tue, 12 May 2020 04:35:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+BiTuuhaiRCRuygJo/UfgMumeWw31HiTY05kAioh0sw=;
        b=GDeymUqjl7hQdNpXeM+R5LEuuCxq2d2pwecNcGm6Rmwh9jC5TCEDy2fg1zPzSIAcXg
         G+/aNtGeqcebhDBDtDmo/h/BPOieujMbYTPpgZG7yt1yHwEuHtEWDAlbsJwpx+FyckvB
         Eb5iObUhWzTe6T9KCnLtkr3aRdXWpig7wMV9afweODiFlrPWvJSAx01taaIptwZFtFCn
         crHOn7jtRXC+ILy6HYom8FeTKexYvylsUyZUP2ElbQsAY59u+GRYr611voHO0Q8BIJ9a
         YKjjsL04Ot+hFtOmnISrCCzNAdqpjAoabrroNB3CKV1r/OkyaKh/eZiladHRJ2I95Uqa
         8JMg==
X-Gm-Message-State: AGi0Puagybv6TFsYDqyqPBrYliJn0BxmRh/wysGIkQ4KKhwM05w80he+
        L/lND3FIw86O95XjVQFVoeWEdedXNL+ICgG7d1pppspHR0ZUQtGFPHpl1VAIYLgT2QwxG8W0pIi
        tyvEWCVSUoY3C
X-Received: by 2002:a7b:c5d4:: with SMTP id n20mr38375014wmk.92.1589283328765;
        Tue, 12 May 2020 04:35:28 -0700 (PDT)
X-Google-Smtp-Source: APiQypIZBWCP2oEj/S8LiXheSW7eg8C7utjhj4b5hLWz7aH6Dpnc1ic28b7BJX+0qQj2+ajALvIbPA==
X-Received: by 2002:a7b:c5d4:: with SMTP id n20mr38374993wmk.92.1589283328508;
        Tue, 12 May 2020 04:35:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4c95:a679:8cf7:9fb6? ([2001:b07:6468:f312:4c95:a679:8cf7:9fb6])
        by smtp.gmail.com with ESMTPSA id g184sm16877850wmg.1.2020.05.12.04.35.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 04:35:27 -0700 (PDT)
Subject: Re: [PATCH v4 4/6] scripts/kvm/vmxcap: Use Python 3 interpreter and
 add pseudo-main()
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Markus Armbruster <armbru@redhat.com>,
        John Snow <jsnow@redhat.com>, qemu-block@nongnu.org,
        qemu-trivial@nongnu.org, Cleber Rosa <crosa@redhat.com>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Fam Zheng <fam@euphon.net>
References: <20200512103238.7078-1-philmd@redhat.com>
 <20200512103238.7078-5-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2c1a9a41-6e94-c20b-fdbd-445e260507ec@redhat.com>
Date:   Tue, 12 May 2020 13:35:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200512103238.7078-5-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/05/20 12:32, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  scripts/kvm/vmxcap | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/kvm/vmxcap b/scripts/kvm/vmxcap
> index 971ed0e721..6fe66d5f57 100755
> --- a/scripts/kvm/vmxcap
> +++ b/scripts/kvm/vmxcap
> @@ -1,4 +1,4 @@
> -#!/usr/bin/python
> +#!/usr/bin/env python3
>  #
>  # tool for querying VMX capabilities
>  #
> @@ -275,5 +275,6 @@ controls = [
>          ),
>      ]
>  
> -for c in controls:
> -    c.show()
> +if __name__ == '__main__':
> +    for c in controls:
> +        c.show()
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

