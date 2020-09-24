Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45153276ED0
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 12:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgIXKej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 06:34:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27116 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726380AbgIXKej (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 06:34:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600943677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h3ySZ6gLp8GW6g2dh00MqMH7uqPgQZrVSw7ErFill4Q=;
        b=W3mc6uq3Ms9uWOqsw0+qtPIhuRUx5+PTIofBTS8gQmMqonZDNx0xELScBYsiGM+p+7wen7
        Ushe6hloMgGxhYn4nQLyLQ9M6PqujwKiIHnnBy3x8VmNjxMOIexWjx/8xKPq/PTljNRJ4M
        RkeNrV5MDt3IEyyima/4HiwYFUQBKHg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-qgjXisWnPumDPMVJsywG9w-1; Thu, 24 Sep 2020 06:34:32 -0400
X-MC-Unique: qgjXisWnPumDPMVJsywG9w-1
Received: by mail-wm1-f71.google.com with SMTP id u5so1069396wme.3
        for <kvm@vger.kernel.org>; Thu, 24 Sep 2020 03:34:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h3ySZ6gLp8GW6g2dh00MqMH7uqPgQZrVSw7ErFill4Q=;
        b=mU/Nsw3kHjdGIQv6iI46Qv0FSekhyMPnwrEn1wgPfT2RbPSS20AW91ueC2OYqWavIJ
         7LIwL1hogv9m+U++sQ5aOG13rp7Aheewb9V3BYhF2FnsfYVOkDi/JlK2+L5ORLs3fzBT
         L64Fxah2QlEXcd3/9jygAaelv4FY2WI0BOmADoUthUPdweCihDB86PTpG8BeypDL4GW4
         1MP084Mhuqx12JINedSS2wt4KHfMpveyw1siwhgb6gtjy9vDPs3ZvaRQgnQBn+D6jAjX
         Ig/z1bFvFc99pUdHr6riWk2FaaEoaZtTkUTWB5YJpz3qt8kDGKFce/1UIxcSB7nWJ9jc
         sSpw==
X-Gm-Message-State: AOAM533frMjgb0OQRSgmii7TcBQWXpl4utUJmseRaPAHYwBEn7m7m8nb
        pgTERnUofIM7zv1ZpaSxf5QwE6kPfcSS7hp2WluCJ6psn9bjH8fByX+gsmC5+2ZTvvZIU6Yh4IQ
        i4M8yAvni1BJN
X-Received: by 2002:a1c:2042:: with SMTP id g63mr3994842wmg.174.1600943670588;
        Thu, 24 Sep 2020 03:34:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFVLSkEGslM/N1EHAYI5xAxtw5JlRgk6vQSWXb+uQmdLEjFyyIC+x9cR/Phr7JBGIztT//ww==
X-Received: by 2002:a1c:2042:: with SMTP id g63mr3994826wmg.174.1600943670372;
        Thu, 24 Sep 2020 03:34:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d80e:a78:c27b:93ed? ([2001:b07:6468:f312:d80e:a78:c27b:93ed])
        by smtp.gmail.com with ESMTPSA id d6sm3190197wrq.67.2020.09.24.03.34.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 03:34:29 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] README: Reflect missing --getopt in
 configure
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>
References: <20200924100613.71136-1-r.bolshakov@yadro.com>
 <43d1571b-8cf6-3304-b4df-650a65528843@redhat.com>
 <20200924103054.GA69137@SPB-NB-133.local>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7e0b838b-2a6d-b370-e031-8d804c23b822@redhat.com>
Date:   Thu, 24 Sep 2020 12:34:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200924103054.GA69137@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/20 12:30, Roman Bolshakov wrote:
> Yes, keg-only packages do not shadow system utilities (which either come
> from FreeBSD or GNU but have the most recent GPL2 version, i.e. quite
> old), so adding `brew --prefix`/bin to PATH doesn't help much.
> 
> brew link doesn't help either :)
> 
> $ brew link gnu-getopt
> 
> Warning: Refusing to link macOS provided/shadowed software: gnu-getopt
> If you need to have gnu-getopt first in your PATH run:
>   echo 'export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"' >> ~/.zshrc

Oh, that's not what https://docs.brew.sh/FAQ says:

-----
What does “keg-only” mean?

It means the formula is installed only into the Cellar and is not linked
into /usr/local. This means most tools will not find it. You can see why
a formula was installed as keg-only, and instructions to include it in
your PATH, by running brew info <formula>.

You can still link in the formula if you need to with brew link
<formula>, though this can cause unexpected behaviour if you are
shadowing macOS software.
-----

Apparently you need --force.

Paolo

