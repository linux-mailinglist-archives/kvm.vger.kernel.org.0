Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4E2F10ADC1
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 11:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbfK0KcP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 05:32:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45538 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726149AbfK0KcP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 05:32:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574850734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6aiwak0PbIzTB+zHKPtnq4CtpU3MF9tHi+zF698vDNk=;
        b=iY2oDacxujl79a/DlUCfRO4YlBUECPdZKiqCx46K7VZiRp4z4oJG8hEBRCzQSMChqL+/jw
        +3WpvdappTgiJOl+yzgK9+bwz6Idk5L/5Lz8CWIl+J8E02BnU7n7/tGVstd2Za0bYr9Aqa
        YUl8ecefZJb4cPAG1l4H5whF6V/H+qo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-AEMWe9e4Maulpy6QPoIyRw-1; Wed, 27 Nov 2019 05:32:13 -0500
Received: by mail-wm1-f70.google.com with SMTP id y14so2204361wmj.9
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2019 02:32:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6aiwak0PbIzTB+zHKPtnq4CtpU3MF9tHi+zF698vDNk=;
        b=bXHqTzzYoxI6n7DXqmP3S+cMcOYnLIZfCe9qz3LVgm/TP3XucqQpI10dsIdMo6P0WE
         ZzevOZYfxop8ZumyJY4R0og2ELk0YUUKezf1H9nx5btSLufeNZtpMyFbq2bxtBB2MNm6
         5mLUqo7ob6WxO3ObUSBypSx8+tGQgCJ1mH9xWjun9neO4/Yv99dZR0GF8L2yLNwgLRRR
         34U+ER0JQz+NyBqYHXnQ7E3Z849XvZkRMcrrtaeWrvbhIbttVPcVE657zs3ZuohXjaIy
         J3AwOirxg6YYK4AWEwGG+3qhgFLbRK5tkb6Ncwi9wq445wwMeY2ovNgefQovZ6zck26h
         Oh4w==
X-Gm-Message-State: APjAAAU/b5KbziMhL7uUIaWGQfypG9UH2ti1c+jqQTrde4zXMtVK6yJO
        01r4PxriCK2sxFLfLOW04U0ZP11byAm6LmDbUW+wReq84bZQ5Yy/ldmf/eO0EDNrtOATkq1UtqN
        ul++n+Mjs99E5
X-Received: by 2002:a7b:cb89:: with SMTP id m9mr3547005wmi.66.1574850731349;
        Wed, 27 Nov 2019 02:32:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqwDbOCws3iGC2hIXwq1LVZrEBZG3m5lsiYM81dKGQHaLfjo5Odar3fOQtMmemvcaASlOhrKww==
X-Received: by 2002:a7b:cb89:: with SMTP id m9mr3546975wmi.66.1574850731068;
        Wed, 27 Nov 2019 02:32:11 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:14d1:f071:7005:15b2? ([2001:b07:6468:f312:14d1:f071:7005:15b2])
        by smtp.gmail.com with ESMTPSA id m3sm19611401wrb.67.2019.11.27.02.32.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2019 02:32:10 -0800 (PST)
Subject: Re: [PATCH kvm-unit-tests] runtime: set MAX_SMP to number of online
 cpus
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
References: <20191120141928.6849-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2bd99a58-962e-cb6e-8ca5-890df2f86f98@redhat.com>
Date:   Wed, 27 Nov 2019 11:32:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191120141928.6849-1-drjones@redhat.com>
Content-Language: en-US
X-MC-Unique: AEMWe9e4Maulpy6QPoIyRw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/11/19 15:19, Andrew Jones wrote:
> We can only use online cpus, so make sure we check specifically for
> those.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  scripts/runtime.bash | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 200d5b67290c..fbad0bd05fc5 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -1,5 +1,5 @@
>  : "${RUNTIME_arch_run?}"
> -: ${MAX_SMP:=$(getconf _NPROCESSORS_CONF)}
> +: ${MAX_SMP:=$(getconf _NPROCESSORS_ONLN)}
>  : ${TIMEOUT:=90s}
>  
>  PASS() { echo -ne "\e[32mPASS\e[0m"; }
> 

Applied, thanks.

Paolo

