Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28F1218F27B
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 11:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgCWKMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 06:12:21 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:43731 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727806AbgCWKMV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 06:12:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584958341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TxuFp59aynkY5mxOrn96iiDmn4crzUyoQQNn6ZyYiG0=;
        b=FreiQFdPnpIno4YEN/ySzztIwPAwRJLuy1J3IX/wlm3gdIvCK2cPyeW9ueZMOXxisY226j
        ceRGlq/YwBTlMbDdoD2btP5ZTcCCqB2QivK5jevNO1VoOQgYEGfGyVCV8aLrj39f6UE2CH
        S6iv/+Vl8m1XP0e/B85xaWE0i/NUBRI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-XIACcpyBNdGrhJj-QrTcrA-1; Mon, 23 Mar 2020 06:12:19 -0400
X-MC-Unique: XIACcpyBNdGrhJj-QrTcrA-1
Received: by mail-wr1-f70.google.com with SMTP id d17so7133385wrw.19
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 03:12:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TxuFp59aynkY5mxOrn96iiDmn4crzUyoQQNn6ZyYiG0=;
        b=p7+apDdTvOKhdiPl9H9gynt45WClh95uuIGQRZKNkuZ2rhQLKXXvPaxPcGpgJ1++d0
         1e66vaSyUC/hCANb/R2c4xC2cEzgu9AbVx503/0ssGlGrnb7YSezK+KuT3cCOuKH2mg5
         PTqwYqdUv6qCVjcwcTiaywNxyBmYhdc+E2ZXQ1q1+xMKn/61ySW5IfSD9emqX3RfrYt0
         J4FAGCoACr3uqPGFnBh5nTpAaOIA8GXe+Oq45oeEwQV+pWzo1mSKdANEb0O7vOTIRane
         AkX6V3S/WDQGmZR7RVX7b9rk+n94BcXhN7p6wMSaQ2cKCgxiCIQ/5xiudD2LwMMOZw9o
         2l1w==
X-Gm-Message-State: ANhLgQ0u6ahHwkOXYg3vxbSGiACN9IpFV5tuKE02BYrPvFmzjZ1if4hr
        rtEZI697i0xjGJbuIoLycQjuJEcuE+17YOe+tUJ6Y/zbhtt8FU6lnO7TGBaLgU9TcXQrk1uWXHr
        EU3rVHNc3OwoT
X-Received: by 2002:a5d:518b:: with SMTP id k11mr8666203wrv.256.1584958337846;
        Mon, 23 Mar 2020 03:12:17 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsWY7kTSYdao9UzPknKaoOw6ew0KEGGO46+8S+1sdvt0JggdEHlSxuQCiY9s2K75/1atkQooQ==
X-Received: by 2002:a5d:518b:: with SMTP id k11mr8666176wrv.256.1584958337582;
        Mon, 23 Mar 2020 03:12:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7848:99b4:482a:e888? ([2001:b07:6468:f312:7848:99b4:482a:e888])
        by smtp.gmail.com with ESMTPSA id z6sm21652291wrp.95.2020.03.23.03.12.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2020 03:12:17 -0700 (PDT)
Subject: Re: [PATCH 0/7] tools/kvm_stat: add logfile support
To:     Stefan Raspl <raspl@linux.ibm.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com
References: <20200306114250.57585-1-raspl@linux.ibm.com>
 <7f396df1-9589-6dd0-0adf-af4376aa8314@redhat.com>
 <d893c37d-705c-b9a1-cf98-db997edf3bce@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5c350f55-64be-43fc-237d-7f71b4e9afdc@redhat.com>
Date:   Mon, 23 Mar 2020 11:12:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <d893c37d-705c-b9a1-cf98-db997edf3bce@linux.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/03/20 10:58, Stefan Raspl wrote:
> Thx!
> As for SIGHUP: The problem that I see with logrotate and likewise approaches is
> how the heading is being handled: If it is reprinted every x lines (like the
> original logging format in kvmstat does), then it messes up any chance of
> loading the output in external tools for further processing.
> If the heading is printed once only, then it will get pushed out of the log
> files at some time - which is fatal, since '-f <fields>' allows to specify
> custom fields, so one cannot reconstruct what the fields were.

For CSV output, can't you print the heading immediately after SIGHUP
reopens the files?  (Maybe I am missing something and this is a stupid
suggestion, I don't know).

Paolo

> That's why I did things as I did - which works great for .csv output.
> I'd really like to preserve the use-case where a user has a chance to
> post-process the output, especially .csv, in other tools. So how how about we do
> both, add support for SIGHUP for users who want to use logrotate (I imagine this
> would be used with the original logging format only), and keep the suggested
> support for 'native' log-rotation for .csv users?

