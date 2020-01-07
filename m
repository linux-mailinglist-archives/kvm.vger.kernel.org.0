Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0EE0132C59
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 17:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgAGQ64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 11:58:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27156 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728235AbgAGQ6z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 11:58:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578416335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5zj9aVDyJrU+2uajBZnxUthD7+2pw4B72BHNwhWinsc=;
        b=V6/0ua3nmXc79THfoKz48X/mdjTrB77+Tl4wsRngoeOXOJxvrsOeSHAuxuVD8bxMKsaVsn
        civgBajMIaTPsl+66uLNOv71ThgocS/jV9hkS7qJoTg1A+1IxegFX5NCR8Yyar4VupUtIQ
        Xgr8yJ5DCgN4wOP94SXq2JUEipYOtPk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-RDSbBvHMMMm_4nZP2ZHKMQ-1; Tue, 07 Jan 2020 11:58:53 -0500
X-MC-Unique: RDSbBvHMMMm_4nZP2ZHKMQ-1
Received: by mail-wr1-f71.google.com with SMTP id d8so192104wrq.12
        for <kvm@vger.kernel.org>; Tue, 07 Jan 2020 08:58:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5zj9aVDyJrU+2uajBZnxUthD7+2pw4B72BHNwhWinsc=;
        b=ioXKhtjGNPxRCwGhix7GDuP/lQY7bJg07BcK3rIr/+ZOuM/8dTLj4Z7YJhgIexfVD/
         YHI0Z109+vy7ujhI0JuL/GEJnIuFdjd8fjuWuLDrmaNkIl+zQkHcA4cEpJvQR4IQI+D/
         VMquJxZMXJBzL9KBh0JLpLBJ2jKSRlT0M9bcq2k5ekAsgG6zTnYCcYCRBlTy0h0eu5Vr
         Q9zwxXXhvSuffMucCG7lyRAwTO5pmjWJ60pqYCfnFJ24hxdFz5qpQi0V2XDTkIQ0uGKC
         rrQU+ceoKvKhDIAt0YMciJT1TkdluhRDrqJMJPyoc18w09/6HqmEdyzjo8Ikf46U2gdH
         jcyQ==
X-Gm-Message-State: APjAAAXeKLCaNrIcbjzuvxYPV2d3jTZSZarg0bV+vu6dnU0qXfYccphI
        VY90aboJ/tykYrv/QxEytzu9ESTAWPChugb6w+teM9/C2xX+1kRO1LayOnwAcvJg8htEXYvf89Y
        8nRy9ndrO0BI+
X-Received: by 2002:a05:600c:2488:: with SMTP id 8mr18670wms.152.1578416332695;
        Tue, 07 Jan 2020 08:58:52 -0800 (PST)
X-Google-Smtp-Source: APXvYqz3uJQ3NHb1tVXAc5mjqhSrKn/KIp8Rr4coNewRdGnc/160g7T2qn0lms+eSffm7la/f59Nbg==
X-Received: by 2002:a05:600c:2488:: with SMTP id 8mr18656wms.152.1578416332439;
        Tue, 07 Jan 2020 08:58:52 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c6d:4079:b74c:e329? ([2001:b07:6468:f312:c6d:4079:b74c:e329])
        by smtp.gmail.com with ESMTPSA id x10sm566388wrp.58.2020.01.07.08.58.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 08:58:51 -0800 (PST)
Subject: Re: [Newbie question] Why usage of CPU inside VM and outside VM is
 different
To:     Gregory Esnaud <Gregory.ESNAUD@exfo.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <8254fdfcfb7c4a82a5fc7a309152528e@exfo.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a8fb7ace-f52e-3a36-1c53-1db9468404e6@redhat.com>
Date:   Tue, 7 Jan 2020 17:58:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <8254fdfcfb7c4a82a5fc7a309152528e@exfo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/01/20 16:57, Gregory Esnaud wrote:
> 
> From an hypervisor (via top command) point of view our VM is
> consuming 9 CPU (900%). This was reported by our platform provider. 
> From a VM point of view we are consuming only 2 CPU (200%), with a
> top also.
> 
> Our provider claim us to explain why we are consuming so much CPU.
> But we cannot troubleshoot the infra as it's not our responsibility.
> From our point of view, everything is ok.

Are you using only 2 CPUs at 100%, or are you using 9 CPUs at a total of
200%?  If the former, it is possible that you are using something like
idle=poll, so the machine _is_ idle but still consuming 100% host CPU.
This is something that you should know, however.

If the latter, the host is probably doing a little bit of busy waiting
to improve your performance.  The provider can disable it using the
kvm.halt_poll_ns=0 module parameter and there is nothing that you can do
about it.  But it is unlikely that it causes the utilization to jump so
much.

Paolo

