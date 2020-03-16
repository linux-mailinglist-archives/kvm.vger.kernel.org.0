Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBD2B1873AC
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 20:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732457AbgCPTzX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 15:55:23 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46148 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732436AbgCPTzX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 15:55:23 -0400
Received: by mail-pl1-f196.google.com with SMTP id r3so440640pls.13
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 12:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ov5h57WO5/+zhyBMPAFbc1OhO1yQRqCkUshvDOAUP7s=;
        b=r4ux9rXEn528yNo+tnFiuAEEcyAyUcAuWVSrlsR5KXwYPGjy9WVtwJXvMq9iSDTqhX
         GFwsZmtH677CVkv8ibaHzvr+GbTJ6ZT0Gb2++YP906Lg66cc1K5vUdJkbY6smfNteEFp
         U3Fi288zwkXDqzeAuc7Kvj6h5oQUBA/ppcT5f/cSWVpFzPBUkH39YqDmKypUGVVFDPQf
         z2crm4ba6pF/Dvu/mVQfK90ayT/UxGgKMFH7vwkm1IwYM7z+THVntecWhUDTWXc54WTS
         JvbSJMNWQ2jfm7TvUirNuKO0GNrwVbIZVa2ZlQ0Wv83aSTpY/wereBLXWd6TYHDqvT2h
         gKzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ov5h57WO5/+zhyBMPAFbc1OhO1yQRqCkUshvDOAUP7s=;
        b=qBLG+IdE1C18qvQJmounSfpdm98EOMDCcp+B37LAoG/g7gXa6elOkI7pGgljrLFWAW
         HKvwG8pYxkUDWR2JhnDT2xYi4O9pfM2Zkjn1eT1C1EHFNi1j1SVBwX+JQ0OBXHr0vRga
         dBLOJaRyNlJUFNcboMq3JIqOcS6fVd8HixGm1jwv28l7jh2AgzDnd8HHD3nN++88lESH
         7Yimllzcr5QzxBLajbtrUPl17W662BZKsRvvT+4LX8VdLk5kecmbnqfYLVkrivk/fJaT
         e3OyWlrVRoDsONyBztq+oiC1u6ne41Q7pi58lVKk7LGB4dnhMZ7H6IOY/y2C8uG8lDkB
         C2bw==
X-Gm-Message-State: ANhLgQ3xvWGnBbtbCWqLkET+Hw9A/MoBQLEAymH/GOwconF/v7Ycyxtw
        eORoCqlFoF7apnyH+mV42pPSJg==
X-Google-Smtp-Source: ADFU+vvyvrLaxbAe3TneK14pPHxfqzUe+6HvE8zB/G2jcYM7gSkCqhbHZm3HzszRYNwHHWJ/fR3dug==
X-Received: by 2002:a17:90a:f50b:: with SMTP id cs11mr1202297pjb.145.1584388520824;
        Mon, 16 Mar 2020 12:55:20 -0700 (PDT)
Received: from [192.168.1.11] (97-126-123-70.tukw.qwest.net. [97.126.123.70])
        by smtp.gmail.com with ESMTPSA id s98sm533513pjb.46.2020.03.16.12.55.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 12:55:20 -0700 (PDT)
Subject: Re: [PATCH v3 13/19] target/arm: Restrict ARMv7 R-profile cpus to TCG
 accel
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-14-philmd@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <57b35f0e-cf20-14fd-7a05-82242fb84c35@linaro.org>
Date:   Mon, 16 Mar 2020 12:55:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200316160634.3386-14-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/20 9:06 AM, Philippe Mathieu-Daudé wrote:
> +static void arm_v7r_cpu_register_types(void)
> +{
> +    const ARMCPUInfo *info = arm_v7r_cpus;
> +
> +    while (info->name) {
> +        arm_cpu_register(info);
> +        info++;
> +    }
> +}

Likewise wrt ARRAY_SIZE, otherwise,
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
