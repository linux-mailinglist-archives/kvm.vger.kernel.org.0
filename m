Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64CA2A9BA9
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 19:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbgKFSPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 13:15:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26484 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726999AbgKFSPh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 13:15:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604686536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=njXTiXf5+NVxfZwZ7si6Kzqa4dEa5pfbQK7/u8nZLAA=;
        b=aPez2jbPvzF/2AftliCGeAPwkRdHT72ectVOJ+3+ABrpdOK+Xq+MBUP+k5jaReqtVp+NxZ
        deo1+VO0DZoZ6iilx39DavV6y0BssorfQf/IZMAtajq5YUMajhR8Quv7yHhrSD6jE4c7QP
        UaV48SSJ/Ufx0mn/ioENIR97TA/zHOE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-sWlKhvadMTCsuVG6hSi1uA-1; Fri, 06 Nov 2020 13:15:35 -0500
X-MC-Unique: sWlKhvadMTCsuVG6hSi1uA-1
Received: by mail-wr1-f69.google.com with SMTP id v5so773359wrr.0
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 10:15:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=njXTiXf5+NVxfZwZ7si6Kzqa4dEa5pfbQK7/u8nZLAA=;
        b=Vl9K2NxXnHxjMfLLtmby7zukw0JOsw6UDrWONIkD13hmceEwZ2yAVDhd6bweov8xXm
         lNUFv51kX5fedQNeTUTEJbn6V4FyeT40ZslXrA3j5TZ2AWAu0B91MSKYUzJJsNxv3zE/
         +8WNzqqYa7H70Rc0bDYFbMSBSM3cBtzfkCXBqEW5Q9D0ay0EpiBQjTr+K10JxG76T1gJ
         juTjX6brFxzUQ398FPL9gdCfPb0rP9kIWJqaLmf4E4QpEfVjMAvj1n7I/HFNOa21XszR
         zORvWFI5jC3o/Nrmf2XWyVTEDipjU9Huho/Tohz7ohXb4y2YGFoMJbYIWs7MsEsfFFhk
         f6tw==
X-Gm-Message-State: AOAM532BYOLjzecm9umn7lwVFGekw3bJRONvzs1jwTTBTZlnwaeP9V8b
        BFHrZU1g5sLAJw6JjwcFFwsHdVZaIvoWHn3HDUUAAdyfvpjtjGkLWSBJGZ5Vu2vm4dvoGEg3iFu
        /9Tu3n72W8/Vp
X-Received: by 2002:a1c:b746:: with SMTP id h67mr839100wmf.43.1604686534003;
        Fri, 06 Nov 2020 10:15:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJydW3XZS8v51uQtbtqv7TiJ/HZfs4GAgZWRHDAbg152wQgVp/+3LEpV6UAhQtYmHyBErzbFGQ==
X-Received: by 2002:a1c:b746:: with SMTP id h67mr839087wmf.43.1604686533852;
        Fri, 06 Nov 2020 10:15:33 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c8sm3300512wrv.26.2020.11.06.10.15.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 10:15:33 -0800 (PST)
Subject: Re: [PATCH v13 13/14] KVM: selftests: Let dirty_log_test async for
 dirty ring test
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>
References: <20201001012044.5151-1-peterx@redhat.com>
 <20201001012239.6159-1-peterx@redhat.com>
 <6d5eb99e-e068-e5a6-522f-07ef9c33127f@redhat.com>
 <20201106180610.GC138364@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dc32ce97-cbd2-07da-b8ca-30ea67c2d4e3@redhat.com>
Date:   Fri, 6 Nov 2020 19:15:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201106180610.GC138364@xz-x1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/11/20 19:06, Peter Xu wrote:
>> +	pthread_sigmask(0, NULL, sigset);
> Not extremely important, but still better with SIG_BLOCK imho, since it seems
> not all archs defined SIG_BLOCK as zero.
> 

If the second argument is NULL, the first is unused.

Paolo

