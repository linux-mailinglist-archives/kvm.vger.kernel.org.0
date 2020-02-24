Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0EDC16B0C0
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 21:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgBXUC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 15:02:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53111 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726628AbgBXUC7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 15:02:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582574578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7nmRzELnjOBKrmHiiZnoo0p+6969f+WrcXpfFGggGK8=;
        b=ZOrju4mc4A2NAKbF2IOqPdPFumzLzGW4kP6SoOAiP4nVPPPfDCDPtwCLVMOkLlaXmo16By
        oLtvX5bGJGpd4pFFFW9ecw+BGMs7dvWWO6J0lr7729iA9xsaHtrPME7UMeGVnqNPOTXAzQ
        jDGoY1RL0hIQV9z2m0AuFtE45djDTUU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-uRJ7E1x6Oyaey7aomEglBA-1; Mon, 24 Feb 2020 15:02:56 -0500
X-MC-Unique: uRJ7E1x6Oyaey7aomEglBA-1
Received: by mail-wm1-f72.google.com with SMTP id b205so198129wmh.2
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 12:02:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7nmRzELnjOBKrmHiiZnoo0p+6969f+WrcXpfFGggGK8=;
        b=cc2jtM6iLxe9aqcQaHmOIuVd5od3mqC+i1NPlrZNn94HIH+z0gszDuBVx/U95tuaIY
         MT3VGfAgnH3aBtSewdeHDNzSdvGdqke+YKOnwo6K3giPFA9dX2y+z0T6bs0dE/M/gAIE
         7yjXKiftjDFExt+RGuxe9mt+ozplmQ/U2pgdCNsUM+VtuohpuIpVXyX7OT1ZQJUKR8l3
         fXA3BbwzXvzrCOfkPDMJSz+lDEDWX2W87qjia7NoxnyF3l99LuB624VsDFe0WMmxsV1J
         b1nNtkPmss7vZB90BgbvGxu/IednVQyOKqXWg1GpCuYhDBpDs+/KJdQBedbO9JJuzNLJ
         UmuA==
X-Gm-Message-State: APjAAAU6daCHfMjj9gNkjxRGjQU222VRMTNezn7YsVm6juU6nVirrvlF
        w6Kymw9KjyJQXTuWxhfjUlJDXeoTs86oDWrJTD4LtR6lyvAxS+9qmUph3yDuwPJKSjrI6NoTO6c
        n2lm0Bc40M2yZ
X-Received: by 2002:a1c:39d7:: with SMTP id g206mr660314wma.111.1582574575631;
        Mon, 24 Feb 2020 12:02:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqwKY8fbmmcRZxTFA8kGuX8Z+N6j5P0KwJYtfE7EvA0pJrpltEQtRy+7lFo9iaeiodouVWClaw==
X-Received: by 2002:a1c:39d7:: with SMTP id g206mr660293wma.111.1582574575393;
        Mon, 24 Feb 2020 12:02:55 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:3577:1cfe:d98a:5fb6? ([2001:b07:6468:f312:3577:1cfe:d98a:5fb6])
        by smtp.gmail.com with ESMTPSA id a9sm21163974wrn.3.2020.02.24.12.02.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 12:02:54 -0800 (PST)
Subject: Re: kvm-unit-tests : Kconfigs and extra kernel args for full coverage
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        kvm list <kvm@vger.kernel.org>, lkft-triage@lists.linaro.org
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, yzt356@gmail.com,
        jmattson@google.com, namit@vmware.com,
        sean.j.christopherson@intel.com,
        Basil Eljuse <Basil.Eljuse@arm.com>,
        Andrew Jones <drjones@redhat.com>, alexandru.elisei@arm.com
References: <CA+G9fYvx=WzyJqS4fUFLq8qXT8nbFQoFfXZoeL9kP-hvv549EA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9cb2dbed-356d-31cd-22aa-fa99beada9f7@redhat.com>
Date:   Mon, 24 Feb 2020 21:02:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CA+G9fYvx=WzyJqS4fUFLq8qXT8nbFQoFfXZoeL9kP-hvv549EA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/02/20 13:53, Naresh Kamboju wrote:
> FAIL  vmx (408624 tests, 3 unexpected failures, 2 expected
> failures, 5 skipped)

This is fixed in the latest kvm-unit-tests.git.

Paolo

