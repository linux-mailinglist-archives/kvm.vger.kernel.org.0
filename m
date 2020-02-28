Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2A791735F2
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 12:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgB1LTM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 06:19:12 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27892 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725536AbgB1LTM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Feb 2020 06:19:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582888751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2LF4vxrQoNc+qf/xWDRbrWWv5/eEgIg6jIqS42FyThg=;
        b=hM3dzSgvQDchhCKvlsytZwaSZtQ/krRKGDxguqT0JJBzw4oGf1NL08zd9+1XCkT8YYd39w
        oJrz8OLAKy/LrOBVhOvbrRh/W/nXRGAIth5QhczR5e1tHrgoDol6yjkOpg9LzYqnicZymO
        vg75PjP/72ENpcnMe74X819peFC/CMc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-OBaxcVpqNneOBEy5j2tGbg-1; Fri, 28 Feb 2020 06:19:08 -0500
X-MC-Unique: OBaxcVpqNneOBEy5j2tGbg-1
Received: by mail-wm1-f70.google.com with SMTP id p2so575467wmi.8
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 03:19:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2LF4vxrQoNc+qf/xWDRbrWWv5/eEgIg6jIqS42FyThg=;
        b=jV3NqlYKp1jBcToXZGkvkOP9q0WB8lBvypMZKcSTHWPj156pgxSsZRZn07/kjBmIZ9
         lcb+1/ZPhbmDigbjgIJvXOrHLdI/AVq0wkcFvIrf9/cev6F5wcLq1qQYyu14iQxkC/VD
         Hp4EhE1ho5ArcrBojjohHqyansw635m8WKs3CxW/CxXoECXmoDaWjeoVRB9cwHH0NJIR
         77fIx4GLMMp6r0URc2FuMcXkIJ5JapYsenumvb20lqS3mCruKGdWrgjD6AtCxQDKb/U/
         ggND8in7c8ylNHg7G1Tgl8EuyEMvCtPwgXVxgha2SPuqh45dYdv8Yvq37hNhvRoCQCzU
         SBGw==
X-Gm-Message-State: APjAAAWLefiUIQzECPn6YYXdyoc845QOaLg5qtZnfjmfgHrwxqMIQ+v0
        Wyywc7NRxX1afeWjB8Q0K/Sk+IqkfBCi230mRyNyPaeLYorDC5xfpJ2woTG1jxUXGJTVai+D2s4
        u+fUrph74E6Nt
X-Received: by 2002:a05:600c:149:: with SMTP id w9mr4171672wmm.132.1582888747385;
        Fri, 28 Feb 2020 03:19:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqyNwAs7pkv3DkkKQ6tnmOPKj906dE5yehxSZVKxwLON8A6HswN4SQ4sv53S6NKieRqdYN23AQ==
X-Received: by 2002:a05:600c:149:: with SMTP id w9mr4171644wmm.132.1582888747026;
        Fri, 28 Feb 2020 03:19:07 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:d0d9:ea10:9775:f33f? ([2001:b07:6468:f312:d0d9:ea10:9775:f33f])
        by smtp.gmail.com with ESMTPSA id v17sm11280846wrt.91.2020.02.28.03.19.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 03:19:06 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2 0/7] Fixes for clang builds
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org
Cc:     oupton@google.com, drjones@redhat.com
References: <20200226074427.169684-1-morbo@google.com>
 <20200226094433.210968-1-morbo@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5836cc23-2631-8f8e-4eee-0560ac9e5362@redhat.com>
Date:   Fri, 28 Feb 2020 12:19:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200226094433.210968-1-morbo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/02/20 10:44, Bill Wendling wrote:
> Changes to "pci: cast masks to uint32_t for unsigned long values" to
> cast the masks instead of changing the values in the header.

Applied 1-3-4 and a tweaked version of 2 and 7.

For 5, let's use -fwrapv instead.

For 6, clang people should stop implementing GCC extensions in half and
declaring themselves compatible.  It's just a sanity check, you can wrap
it all with #ifndef __clang__.

Paolo

