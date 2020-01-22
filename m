Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C49B61458CD
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 16:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgAVPaT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 10:30:19 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58413 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725802AbgAVPaS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jan 2020 10:30:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579707018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1UVBEJ1VJGV7+G5bJo3qFJqdJAAcstwqsGmx9rL2PHU=;
        b=J6v8yuR1nKrA1QFN8GWlLDgawyVx6kdIL5OwwS61did0i81qshVsMODfjUn9aGDSB0AHlK
        uXSxfs2dQW1iK+c0lnKlDr+IfT7SQx4JZ0eRzIIFCybQxDa6N9uzkTjcnhm40T5aRt3cdX
        GWCEV00CqHHmgEWr5hlyO3dyAzWCAQo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-gH-5nm7JOB2gSujE_Ty3WA-1; Wed, 22 Jan 2020 10:30:16 -0500
X-MC-Unique: gH-5nm7JOB2gSujE_Ty3WA-1
Received: by mail-wr1-f72.google.com with SMTP id j4so3227077wrs.13
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 07:30:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1UVBEJ1VJGV7+G5bJo3qFJqdJAAcstwqsGmx9rL2PHU=;
        b=ZzRFXJJKhqehXw7fWEJkqoScHxtgsEVm0hFje8ifXreBsBI6bBohFX7UfCg1IACucP
         WO+pBJ46+UX0RHaDaAQf1NwxEje/lKDxdq+hjdcFymHIEuHmzrOQ5CBKt52rDoerEuvg
         uApOsWVxHnDTg+yK624RgS5pCBohTTX5DN29Pby51HliBbdzgTHmeUlZ9KvRUIAKqfhe
         foccjKP3n/RD9CFH5vBGDpPABT6HPGmgXT3uyRlxSAo5c6TozGOsMQHWl2xf7zWjfyu0
         oOhDCoD1gaL36oYW2OExGa24DSSrbL0HiJ3B508w4ejeRE187MnFloXS0eCtkYkx1l4z
         jW1A==
X-Gm-Message-State: APjAAAU0wbJglv6Ecee9m0LWZAuoaL8tlwy9/HaXUF9Xh5h/bCtF+n9p
        0Dc7+00Fh/nMT16QemHnMrnasdOYoq6vQqQGekKyU2uHXv+QlD4ieOBqo40nCV/MuqSvXKvDZSE
        sZruoMJiHaTWl
X-Received: by 2002:a7b:c19a:: with SMTP id y26mr3769645wmi.152.1579707015300;
        Wed, 22 Jan 2020 07:30:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqxg6NIvBS0lP8f2Cz1w1biYwcACnY6S1TFMOJzRlMrQlsVI9AXGC4VoM4LQupkUDK2enB946Q==
X-Received: by 2002:a7b:c19a:: with SMTP id y26mr3769613wmi.152.1579707015014;
        Wed, 22 Jan 2020 07:30:15 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id o1sm57373734wrn.84.2020.01.22.07.30.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 07:30:14 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] Makefile: Compile the kvm-unit-tests with
 -fno-strict-aliasing
To:     David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Drew Jones <drjones@redhat.com>
References: <20200122152331.14062-1-thuth@redhat.com>
 <85c9760f-51eb-3fd4-57b3-52bffad98505@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0a6afd93-acbb-a2fa-5348-577878757149@redhat.com>
Date:   Wed, 22 Jan 2020 16:30:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <85c9760f-51eb-3fd4-57b3-52bffad98505@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/01/20 16:28, David Hildenbrand wrote:
> Acked-by: David Hildenbrand <david@redhat.com>

I think you meat Reviewed :)  Applied, thanks.

Paolo

