Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5972D977D
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 12:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405341AbgLNLhw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 06:37:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46609 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407277AbgLNLhd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 06:37:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607945765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t9wz3YiKOXMMp/r+Wo0hz3x1+xMatpyPFXdpkKPjUXM=;
        b=RAcrU8J7VOlowiyfvki8h8VZ6OpC7OrJjGzZfVon+D/5Y6594EEprMiVrqjI7kGCyPSbCM
        uu8NQ1WCO/P1nSXCr3m+AVXr9gr9by13JbCwwI9VkG9IXl6JC5vdJHqn0w0M3N3ZUMhr+1
        tdeX88UG4aZYPmQqBCHWx3YE/d6OyKI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-bpTtJ95VPlqOAGgWYgs67g-1; Mon, 14 Dec 2020 06:36:04 -0500
X-MC-Unique: bpTtJ95VPlqOAGgWYgs67g-1
Received: by mail-ed1-f69.google.com with SMTP id e12so8113128eds.19
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 03:36:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t9wz3YiKOXMMp/r+Wo0hz3x1+xMatpyPFXdpkKPjUXM=;
        b=cuqOTpezMXSky7PXmjQfm/I8vNm4UBqyViTX330MT14Cb/cRp8vyc6eYypslq/ZeP6
         ejetSgq9NKGc5b5UxfHi+myYbyLhRvh1tScF6zUY99qgXoDnXB2lPytrlPTJMtmonUzM
         P9IuwqBEUlchzplO/ER5NCHFycLJgp3BrUojHCt0JLP0G9sTiws8j0M7QubcfYoWgpZq
         Hd41FIhPXF+G9dazPbZKNM6ev+P+0CwciudyRsnNle4MLEgtfRyoyRMwU7YgeNK/MeFf
         9SpJ4L8aEkvbmtA1e9RpbjkM4v0Cizdb8rbvagAUBvxmmU0SdMON4gxb2Ww4n4nsVmOT
         ELow==
X-Gm-Message-State: AOAM531FWYsBaAr+s43uUneH2o1sfB00amZgwf+Kjy1AAmd2Ope+G9eY
        ShWxWo/Zom96n28zBMDcOosf/pkyKI9/273n7aHwwKukb+lFIsfHJjNWvk3vudAzwyoqhZ2N3FY
        NhQNsaI0IxQP4
X-Received: by 2002:a17:906:7a46:: with SMTP id i6mr21318905ejo.257.1607945762613;
        Mon, 14 Dec 2020 03:36:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwzOAjOfMz0gO0tv1SgMZjq/o4qOUwyfrF8DeJA6aqd2BYmwYLdDbp05xP/qI9reG6LCuJTog==
X-Received: by 2002:a17:906:7a46:: with SMTP id i6mr21318895ejo.257.1607945762415;
        Mon, 14 Dec 2020 03:36:02 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id x6sm16321683edl.67.2020.12.14.03.36.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 03:36:01 -0800 (PST)
Subject: Re: [PATCH] KVM/VMX/SVM: Move kvm_machine_check function to x86.h
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
References: <20201029135600.122392-1-ubizjak@gmail.com>
 <CAFULd4YaRJ+9CN5XZSKXTJzO8CCAOGCeooxoj5=OwjLucnJiDw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c80110f4-2c34-ec7b-64f2-3940cb1b09e7@redhat.com>
Date:   Mon, 14 Dec 2020 12:36:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAFULd4YaRJ+9CN5XZSKXTJzO8CCAOGCeooxoj5=OwjLucnJiDw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/12/20 17:27, Uros Bizjak wrote:
> Move kvm_machine_check to x86.h to avoid two exact copies

Queued, thanks for your patience.

Paolo

