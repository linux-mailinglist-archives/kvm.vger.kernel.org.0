Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7700F2822F6
	for <lists+kvm@lfdr.de>; Sat,  3 Oct 2020 11:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgJCJPW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 05:15:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51838 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725730AbgJCJPV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 3 Oct 2020 05:15:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601716520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aqKUOGkrbnr63pzYqTB3ZzHYKIeURmurnEarIe7Rvvs=;
        b=MMjF4IRQzRG46yFAg3mnwN5Lbl7yuZ6ZzQedpre4OIDviCXuaQz9Pfuazcv9Z3GO/4AUs4
        9rj+v2sMEETHM3USamLQXOzF3gLYoKdpp22Kxv6Xh94qHXofFbGHmGAoaN5K1bnIEz8TaL
        gNOXpV2iixEky6byTAYLIjoFBZwizYU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-R4DD3aeJNCW7DrBqdjmfhw-1; Sat, 03 Oct 2020 05:15:18 -0400
X-MC-Unique: R4DD3aeJNCW7DrBqdjmfhw-1
Received: by mail-wr1-f69.google.com with SMTP id r16so1597507wrm.18
        for <kvm@vger.kernel.org>; Sat, 03 Oct 2020 02:15:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aqKUOGkrbnr63pzYqTB3ZzHYKIeURmurnEarIe7Rvvs=;
        b=B++e3a4DDNTPb6FmPi3XZdswRoSesTV3LwhdzO4S6L39rQ9SP3rRw7AiLlaOXgfpNL
         Py+NJIDe7n8wkkngBdHTuJhUgiJhAxJ/j2Xx+/ouKkM9JDjKu0o5kfBZK5Nufsv8+7Wa
         voI84rFem2qhK5jZFFaZEtrZ45y2QP8+0nSdTwbwncJxYYFXidh4pIgXMZsNSbn0g5P+
         iw8/Yk4phAqDFPdbWmuDp3XOQWoZ0mY7Zn+nKPMeSKhZ4ysWyC6QSEWozLgr5AEIJ9p2
         gOF3GxX/fHhpB3DUmZI9leoHUE0A4ttDO0T0iwcLeyg+gusvsMS8WuZkJMtdFuFszqge
         9DKg==
X-Gm-Message-State: AOAM533n74p3fRRp5hjC4Jwd0+A5Qebi1omWEYcOsNR8Yv4A4D8TKA0z
        5/P/jNyjHlwLKDFZw61kncbMHWPG9mJ0LyhX/vYKsBExtJpn1x870IAGJqMtrv0bRuwJJAe5CFJ
        OSXbMTi2nBC5g
X-Received: by 2002:a05:600c:2283:: with SMTP id 3mr6672790wmf.37.1601716517508;
        Sat, 03 Oct 2020 02:15:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwuZsAFYWY9R1UvmHiZnykHjHdsZDTkQDQNxn0/9jGcI0CxopfrV7re4bXbSYQ1Toe2oTw9CQ==
X-Received: by 2002:a05:600c:2283:: with SMTP id 3mr6672777wmf.37.1601716517335;
        Sat, 03 Oct 2020 02:15:17 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id n10sm4714605wmk.7.2020.10.03.02.15.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2020 02:15:16 -0700 (PDT)
Subject: Re: [PATCH v4 02/12] meson: Allow optional target/${ARCH}/Kconfig
To:     Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>, Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>,
        Claudio Fontana <cfontana@suse.de>
References: <20200929224355.1224017-1-philmd@redhat.com>
 <20200929224355.1224017-3-philmd@redhat.com>
 <31a173bf-6aa3-1ce8-7d14-5e8f11e2a279@linaro.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0303fe78-5ae1-2115-247c-71807ce74e12@redhat.com>
Date:   Sat, 3 Oct 2020 11:15:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <31a173bf-6aa3-1ce8-7d14-5e8f11e2a279@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/10/20 11:13, Richard Henderson wrote:
>> +    target_kconfig = 'target' / config_target['TARGET_BASE_ARCH'] / 'Kconfig'
>> +    minikconf_input = ['default-configs' / target + '.mak', 'Kconfig']
>> +    if fs.is_file(target_kconfig)
> Missing a meson.current_source_dir()?
> Leastwise that was a comment that Paolo had for me.

Not sure, but it was the only way I thought the BSD build could fail;
unless the capstone submodule really was not present in Peter's checkout
and submodule update was disabled.

Paolo

