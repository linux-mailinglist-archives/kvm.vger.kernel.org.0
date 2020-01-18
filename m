Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32343141999
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2020 21:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgARUVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jan 2020 15:21:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37667 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726846AbgARUVC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jan 2020 15:21:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579378861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PYMIkvuFYw73JDwZBFXdSk4gcxIk/SRP6bU+Led51J4=;
        b=bnlCNhgX4hSpYh/NQAyDQiaXNmNWG4Otr5aVVTCSWEFItPoy/FQvOShR8GQja3O2umE/tj
        xlmOcZKzojMTcguT9zlTpxOUSNyANJuXAOhQezsgT26hQWxPa/oMJa16Lpruw5KfbZxLLi
        RJC3CJLIYVK1wE3fIpKtjsMug7He2Bk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-rfHwNUAPPo2BUywbEUlrWA-1; Sat, 18 Jan 2020 15:20:59 -0500
X-MC-Unique: rfHwNUAPPo2BUywbEUlrWA-1
Received: by mail-wr1-f69.google.com with SMTP id v17so12024521wrm.17
        for <kvm@vger.kernel.org>; Sat, 18 Jan 2020 12:20:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PYMIkvuFYw73JDwZBFXdSk4gcxIk/SRP6bU+Led51J4=;
        b=sRS/lwGRVkrFBTr8c97ij9IYNJW/a2vr15IIYhamvawsl9zrgB+5Nt/56j6kHuuuLq
         0gGQ3xIU+dVjq8lRWrLDgSGIQ1eZVOjSaW5GW8O9qwwc2cG9PMUS76gUaSHabA4DcIGI
         5wgY8jh0cP9QzM1Sk0CYayypvTjRk+TLAnX7FjBRHGosLdkHzAYkHBEM475KsaxvUIoE
         e27YjpftLu4nR/1j+EQf+fnRixPmKJ8UyRmoZi94ZOv0klOSZSwPLg2+5PWVjEoXyFVs
         I4EBztMwdh+CIjRR5oAMYGmdvhjmv7jRSVSrYvopG55KduDHM7Lqwsfav+Kmx3PXFvIO
         lwcA==
X-Gm-Message-State: APjAAAUgSXDppNdlRX2z4KM3rUtVNhNwF+UlXGS+MOvZtNaYRMJQEN4V
        kUXofufZpJrK6iWF39Obf7fGiNakKSP7tsKLMW2mGgQX2YfY/aKam0qmCFZ3GutzydvL4TEdMOA
        jwAX8iYgcxboT
X-Received: by 2002:a7b:c4cc:: with SMTP id g12mr11768459wmk.68.1579378858608;
        Sat, 18 Jan 2020 12:20:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqzNrbnt9nKdi4T5eDcf9M1wDQ/oIDYeDdu9M5Ylw1Z7XAXb68J1OnsDW1xLJ0AIHpOcgJD5rw==
X-Received: by 2002:a7b:c4cc:: with SMTP id g12mr11768451wmk.68.1579378858404;
        Sat, 18 Jan 2020 12:20:58 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e0d6:d2cd:810b:30a9? ([2001:b07:6468:f312:e0d6:d2cd:810b:30a9])
        by smtp.gmail.com with ESMTPSA id 16sm14892565wmi.0.2020.01.18.12.20.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 12:20:57 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] add .editorconfig definition
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org
References: <20200110151727.7920-1-alex.bennee@linaro.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <93c4937e-706a-66fb-cbb6-5903869a660f@redhat.com>
Date:   Sat, 18 Jan 2020 21:20:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200110151727.7920-1-alex.bennee@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/01/20 16:17, Alex Bennée wrote:
> This is a editor agnostic configuration file to specify the
> indentation style for the project. It is supported by both Emacs and
> Vim as well as some other inconsequential editors.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  .editorconfig | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>  create mode 100644 .editorconfig
> 
> diff --git a/.editorconfig b/.editorconfig
> new file mode 100644
> index 0000000..46d4ac6
> --- /dev/null
> +++ b/.editorconfig
> @@ -0,0 +1,15 @@
> +# EditorConfig is a file format and collection of text editor plugins
> +# for maintaining consistent coding styles between different editors
> +# and IDEs. Most popular editors support this either natively or via
> +# plugin.
> +#
> +# Check https://editorconfig.org for details.
> +
> +root = true
> +
> +[*]
> +end_of_line = lf
> +insert_final_newline = true
> +charset = utf-8
> +indent_style = tab
> +indent_size = 8
> 

Queued, thanks.

Paolo

