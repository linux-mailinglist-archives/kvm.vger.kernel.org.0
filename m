Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E254527E94D
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 15:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgI3NRQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 09:17:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26177 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbgI3NRQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 09:17:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601471834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k+T3hp1G/8usQabHu6Z+BeraaB8GJWxJvx9lFv1z4Og=;
        b=Q7TcezTCB1xb2JRAT6Hfo0aRjeW+tcKMnXUgGdMal/VGdrKt55fjCS5G2ukmLCs+LyD1pr
        Iu0wdIgvKR+94kuRjGflOoWCRpIoeCjrLKArsmjjar6DhQrWudmq9lAr/W4Tw7PMUtw13a
        xvGUlbMUXyyDiC/uvTHfCYHZjO+LyAU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-mCM0ed2WN2GVszw8a32W6w-1; Wed, 30 Sep 2020 09:17:09 -0400
X-MC-Unique: mCM0ed2WN2GVszw8a32W6w-1
Received: by mail-wm1-f72.google.com with SMTP id 23so456982wmk.8
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 06:17:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k+T3hp1G/8usQabHu6Z+BeraaB8GJWxJvx9lFv1z4Og=;
        b=bE1ATWv8d55DxxXQtTyuMiLiQCmQtYoRenIs2pkm40dKCPX2Q1Fw09bCJW/Hjv1SK7
         3hI/jLSZNbOO2bGiVBi/7HYL/kELx2UA+xcqsUDeh6hywTbIAg1+RWvRL2tkIJ8W5cYk
         0OvWY/Nl2x82MzFp12O4/gq1OcMu2AWYHgpWp2RpKvoNmwYP6p6BGqJfXdL0e4IprrNI
         H2oApAOfHYDY7kWS2v+SSBsClbnyJTGWNVcHmn5ndXmDfoQkv4Yvel3hzwBMkSM80twM
         7pX2z+3h0/j21k2PBJuOESEdSVj7soF6Gnxhicz5LuBx04ZrearFEp/SN6759NPZZJI1
         Ds/g==
X-Gm-Message-State: AOAM530F5QKhNCctedvhdB3yvBiW8Y0Gh0a6FJAcASp0HB7/bjPF0myv
        DftUV6fcZiKCDqz34DAsxsASSt1UW0P4ynDMswsKEkhDM8UWIa+T9wwBZAjux5Bdnio6DHmFtr6
        qwy99ikk9JCLD
X-Received: by 2002:a5d:570b:: with SMTP id a11mr3221723wrv.139.1601471828200;
        Wed, 30 Sep 2020 06:17:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFWiFaTR4B/SjKzTAPoCC3OoRM1zFV1RHDbm+NroRgIJcx+EUjmdCrnL/ItnriRxkgp0BBAA==
X-Received: by 2002:a5d:570b:: with SMTP id a11mr3221701wrv.139.1601471827982;
        Wed, 30 Sep 2020 06:17:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:75e3:aaa7:77d6:f4e4? ([2001:b07:6468:f312:75e3:aaa7:77d6:f4e4])
        by smtp.gmail.com with ESMTPSA id h3sm3118133wrq.0.2020.09.30.06.17.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 06:17:07 -0700 (PDT)
Subject: Re: [PATCH v4 02/12] meson: Allow optional target/${ARCH}/Kconfig
To:     Claudio Fontana <cfontana@suse.de>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>
References: <20200929224355.1224017-1-philmd@redhat.com>
 <20200929224355.1224017-3-philmd@redhat.com>
 <19b1318a-f9be-5808-760b-ba7748d48267@suse.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <254ee778-e8b6-9acf-d7c7-075eb3a88a65@redhat.com>
Date:   Wed, 30 Sep 2020 15:17:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <19b1318a-f9be-5808-760b-ba7748d48267@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/09/20 14:50, Claudio Fontana wrote:
> On 9/30/20 12:43 AM, Philippe Mathieu-Daudé wrote:
>> Extend the generic Meson script to pass optional target Kconfig
>> file to the minikconf script.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>> We could use fs.exists() but is_file() is more specific
>> (can not be a directory).
>>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Claudio Fontana <cfontana@suse.de>
>> ---
>>  meson.build | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/meson.build b/meson.build
>> index d36dd085b5..9ab5d514d7 100644
>> --- a/meson.build
>> +++ b/meson.build
>> @@ -529,6 +529,7 @@ kconfig_external_symbols = [
>>  ]
>>  ignored = ['TARGET_XML_FILES', 'TARGET_ABI_DIR', 'TARGET_DIRS']
>>  
>> +fs = import('fs')
>>  foreach target : target_dirs
>>    config_target = keyval.load(meson.current_build_dir() / target / 'config-target.mak')
>>  
>> @@ -569,8 +570,13 @@ foreach target : target_dirs
>>      endforeach
>>  
>>      config_devices_mak = target + '-config-devices.mak'
>> +    target_kconfig = 'target' / config_target['TARGET_BASE_ARCH'] / 'Kconfig'
>> +    minikconf_input = ['default-configs' / target + '.mak', 'Kconfig']
>> +    if fs.is_file(target_kconfig)
>> +      minikconf_input += [target_kconfig]
>> +    endif
>>      config_devices_mak = configure_file(
>> -      input: ['default-configs' / target + '.mak', 'Kconfig'],
>> +      input: minikconf_input,
>>        output: config_devices_mak,
>>        depfile: config_devices_mak + '.d',
>>        capture: true,
>>
> 
> I can't say I understand it, but the general idea seems right to me.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

