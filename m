Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 839F915DAC6
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 16:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbgBNPYC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 10:24:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55945 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729529AbgBNPYC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 10:24:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581693841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wGDqyvkth5i/q2Jh/przk8wZObhMXtryc05G9lXwHdk=;
        b=JqQ5jtJvj8JBBGquCmHHlaskBdmyXYp+DZuNrqd/Dr4qMYTuLoOsOPSpc6lRdNk81bnH83
        IoyVGwbm/WbDX71edfxYkyZP1WJ2PMVBNf/IBxSivA/3zTW5NIGAkDlTs+MLl79cDHx5YQ
        WlzS1ESeNDXGPdJLf+49iyD0xKH1Xqo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-PsGIcqKhPb6N87-ARO335Q-1; Fri, 14 Feb 2020 10:23:59 -0500
X-MC-Unique: PsGIcqKhPb6N87-ARO335Q-1
Received: by mail-wr1-f71.google.com with SMTP id m15so4162499wrs.22
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 07:23:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wGDqyvkth5i/q2Jh/przk8wZObhMXtryc05G9lXwHdk=;
        b=gq8ctdtAqTT4H0f9NcutNNvtMAd1eVkk9qu2JM3v43D2s/ViPnn7BDx1hnwbHkBTvi
         bI0NbK8a+qp2wK+46UQNq6+Xk9qZ3zHVFIYRDLDsKxOKGkh30ll9yz4F03Cn/4YqkwLC
         2wiY316VTORTiY2qwShgYjR5qA6eKpdJ00AVAyAj169zsJxujQMV6dlWL2d1r2dLd0lB
         QhIhIHGMuWRqTHA5V6Ug9JPt+LUNQhWkguJjsR80cA15tD3zNyFHle1dDq5aWpmJYsZb
         ejF0GPsyJZvK2fQ7RU/t5pTcfaLd9YX6CCTDbRf0pyofip3w+c2t1umxP0902mihyzAn
         W4Vw==
X-Gm-Message-State: APjAAAXqIRRjuo+l6hkAjvYtuCKSLNWkr8LL13CBeXvbHtleNmeTBtqX
        dFF039+w68AJhqoCXeITPs22LQ37BuTyVCeQ2+WZlqvN4D6IM1f+h2uRTaKQr5dGWD0an5OVag3
        EUV/7l8X+4peK
X-Received: by 2002:a5d:4b8f:: with SMTP id b15mr4576331wrt.100.1581693838436;
        Fri, 14 Feb 2020 07:23:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqyEsRgrDbKnjcfgR9lDPSEoSKOriucCtEohrps9YfWdlgtB6fQX0/qf4KhWIZUlpeSTZR/PFw==
X-Received: by 2002:a5d:4b8f:: with SMTP id b15mr4576320wrt.100.1581693838195;
        Fri, 14 Feb 2020 07:23:58 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id n8sm7130643wrx.42.2020.02.14.07.23.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 07:23:57 -0800 (PST)
Subject: Re: [PATCH 00/13] KVM: selftests: Various fixes and cleanups
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     bgardon@google.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, peterx@redhat.com
References: <20200214145920.30792-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8e6f6dad-6404-94b6-044f-156ab7647009@redhat.com>
Date:   Fri, 14 Feb 2020 16:23:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200214145920.30792-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/02/20 15:59, Andrew Jones wrote:
> This series has several parts:
> 
>  * First, a hack to get x86 to compile. The missing __NR_userfaultfd
>    define should be fixed a better way.
> 
>  * Then, fixups for several commits in kvm/queue. These fixups correspond
>    to review comments that didn't have a chance to get addressed before
>    the commits were applied.

Right, that's why they're in kvm/queue only. :)  Did you test this
series on aarch64?

Paolo

> 
>  * Next, a few unnecessary #define/#ifdef deletions.
> 
>  * Then, a rework of debug and info message printing.
> 
>  * Finally, an addition to the API, num-pages conversion utilities,
>    which cleans up all the num-pages calculations.

