Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A52B14797D
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 09:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbgAXIiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 03:38:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30507 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725821AbgAXIiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jan 2020 03:38:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579855100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=zuxoiB89F7iHmYYDwyKPYXsYZnkYEDIqPpOF7XcBnXc=;
        b=SbpZy8EsNwx8gxaS+ShxdHCW8YAkYJoYImBxyX2pSLRkpBRH6mOvd2nIdAqh7ENcazk6UY
        PB2UAbNR2XueJYLtNZY2/JLvY3iDfpzQrEGFpeBwC75SjI12rG5vYRY4DaW9SqUK8XstPs
        0p+XKgMtKO+TepPSRAou6DjSgscRAV8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-3wjOihLnOuO2opsNeyU95Q-1; Fri, 24 Jan 2020 03:38:19 -0500
X-MC-Unique: 3wjOihLnOuO2opsNeyU95Q-1
Received: by mail-wr1-f69.google.com with SMTP id f17so813661wrt.19
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2020 00:38:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=zuxoiB89F7iHmYYDwyKPYXsYZnkYEDIqPpOF7XcBnXc=;
        b=N/HLbxF/DUp+V7edKFBgdT6qQ3+gSG81vanHgsEoG1ubd1ZSbpJ2Ka1EimzVna5b1Z
         Rn8Z2l9a/TiTNiAr/VZgqiogSoaQg6XlOz4udfeThkZTjL3JeE6wvgINEQyF7kDQE9cP
         28xnp5ZjnL7KvNaLXdEKGHzY8XDZHoh7YMCSBK9bedzc1sk8iHgUSMa5AYUykBKn9TJi
         yLtRio/ifGO8hWiBrePSwlUaPLhrLAsVssaEWSwU3ekYTIPYxZ14+iKbwcHjTKgDt94j
         TRfHr5Lz+zkM5l/j7o1vwJgKGHlBdvO+PQi40jtvRZ01JvEYR0rDe53gD9ebUrtqitB5
         G2RQ==
X-Gm-Message-State: APjAAAV3dKAu1T8pb+VN1F/c8wTsqInAuZAZkohZyB2tRE4Ow4+DpE1W
        bhZBqHeH49UkKVx3w7HFQQIqCyywF3qbm6fHlD3ea83EIzzaluUz/u+8ypY/+2kJydTIS1M81Ma
        3jTKHzp/HU6jk
X-Received: by 2002:a5d:44cd:: with SMTP id z13mr2997993wrr.104.1579855097745;
        Fri, 24 Jan 2020 00:38:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqxbo2SJcpmWhbW1dujaUSsFzqmTYzf3WTvglH9Huj/Wofx6Qvt/1Kc0Cm3aMBZlgTo8iDRQRQ==
X-Received: by 2002:a5d:44cd:: with SMTP id z13mr2997970wrr.104.1579855097468;
        Fri, 24 Jan 2020 00:38:17 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id b17sm6596026wrx.15.2020.01.24.00.38.16
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 00:38:16 -0800 (PST)
X-Mozilla-News-Host: news://lore.kernel.org:119
To:     KVM list <kvm@vger.kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: force push to kvm/next coming
Message-ID: <8f43bd04-9f4e-5c06-8d1d-cb84bba40278@redhat.com>
Date:   Fri, 24 Jan 2020 09:38:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linux-next merge reported some bad mistakes on my part, so I'm
force-pushing kvm/next.  Since it was pushed only yesterday and the code
is the same except for two changed lines, it shouldn't be a big deal.

Paolo

