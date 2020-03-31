Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB47419A119
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 23:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731500AbgCaVpv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 17:45:51 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40007 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731489AbgCaVpq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 17:45:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585691145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4F5YXSwh1/Lv0ZcELvC8Ij3P3YpZjPskLN4eek6MSnk=;
        b=LbtMo2xGtCIRhxTAAAS2cSRUu6C0HW6PEyIDaKS6OKF/ccmlDqftds12VAahF51fnmc9O1
        VeNuBxid5QdFiaAVGsJFA/OGFHYyFKtQ+7ha1L62eRz/YNBnF9UxeOJfuZs/NYBzPQYNxU
        Z+7wajZUJ6qPlQ0hQMz59/B02QSF6M4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-M8IWR5_xMM-6SnX1RHOkxw-1; Tue, 31 Mar 2020 17:45:43 -0400
X-MC-Unique: M8IWR5_xMM-6SnX1RHOkxw-1
Received: by mail-wm1-f71.google.com with SMTP id f9so1157608wme.7
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 14:45:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4F5YXSwh1/Lv0ZcELvC8Ij3P3YpZjPskLN4eek6MSnk=;
        b=gPL9YI3i2uh7eHzsT78lWPY3yZFNMoYSZ598Fjfs0q2uo9aYP97c1ROLyWaG3D9Wx5
         0msD1SqsDpnld1T2qyxnCZ5S6sEeEIzG1zqfaOTwj8bJhnoHJrjVnPib1NTWE0wbOIZW
         k1aMcwoWhyDHHK4ileFtW2Ps3Il4spJevSC35U4TbKTkzaT0oArdXoMYNly1OUxAt2+J
         tcD/KzFZJhRQBksOE/AKADPAJo0NkgA57UVH2WTgsjn8EizqvjGwuyzk7uW/2hWe7ddR
         3JDn7ZRrHWbwn8wbb2JKzK3KqzQMi+SAVHd9eYmrALcAbCVWHSGeugte9p6eJ4isJ2hQ
         1B+g==
X-Gm-Message-State: AGi0PuZ3zJJrm9qoIjrkQSiIyMW0ELYcJOZoyXFosFcD+ybrs5wzUy8k
        PD15vr9lG/WjOYPcwsS/DJ8F94pFHFLvEtU/Ry226zzVMaQdL0QRoF36xWF7SOuZCKj5zN3GhS5
        eg+0/xHEqq6Hc
X-Received: by 2002:a1c:a712:: with SMTP id q18mr866509wme.164.1585691142139;
        Tue, 31 Mar 2020 14:45:42 -0700 (PDT)
X-Google-Smtp-Source: APiQypJY17W/VRBqMWpNX2/BwtbhRM6dMYGVi8pk2VUnZ+ms0pvQrJuQAwcXN80WZl07sWkZ5gzrjw==
X-Received: by 2002:a1c:a712:: with SMTP id q18mr866492wme.164.1585691141849;
        Tue, 31 Mar 2020 14:45:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b55d:5ed2:8a41:41ea? ([2001:b07:6468:f312:b55d:5ed2:8a41:41ea])
        by smtp.gmail.com with ESMTPSA id j68sm81930wrj.32.2020.03.31.14.45.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 14:45:41 -0700 (PDT)
Subject: Re: [PATCH 1/3] tools/kvm_stat: add command line switch '-z' to skip
 zero records
To:     Stefan Raspl <raspl@linux.ibm.com>, kvm@vger.kernel.org
References: <20200331200042.2026-1-raspl@linux.ibm.com>
 <20200331200042.2026-2-raspl@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6edd0cda-993b-3565-8781-d2da786766a2@redhat.com>
Date:   Tue, 31 Mar 2020 23:45:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200331200042.2026-2-raspl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/03/20 22:00, Stefan Raspl wrote:
> @@ -1523,14 +1535,20 @@ def log(stats, opts, frmt, keys):
>      """Prints statistics as reiterating key block, multiple value blocks."""
>      line = 0
>      banner_repeat = 20
> +    banner_printed = False
> +
>      while True:
>          try:
>              time.sleep(opts.set_delay)
> -            if line % banner_repeat == 0:
> +            if line % banner_repeat == 0 and not banner_printed:
>                  print(frmt.get_banner())
> -            print(datetime.now().strftime("%Y-%m-%d %H:%M:%S") +
> -                  frmt.get_statline(keys, stats.get()))
> +                banner_printed = True

Can't skip_zero_records be handled here instead?

    values = stats.get()
    if not opts.skip_zero_records or \
        any((values[k].delta != 0 for k in keys):
       statline = frmt.get_statline(keys, values)
       print(datetime.now().strftime("%Y-%m-%d %H:%M:%S") + statline)

Paolo

> +            print(datetime.now().strftime("%Y-%m-%d %H:%M:%S") + statline)
>              line += 1

