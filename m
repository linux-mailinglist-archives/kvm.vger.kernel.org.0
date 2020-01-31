Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2EAF14F393
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 22:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgAaVIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 16:08:20 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55360 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726138AbgAaVIT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jan 2020 16:08:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580504899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PJqW6sEGELK0trBBJMQelpgP9cat66lBv2QLm4tjtU4=;
        b=KHTib/p7f/WFxc4pYQgjcaqOjjVEti4mA97CI68AGVoJmk4XEuvmAOutRULeG6T/6Yvf6G
        X0fU2nsA5y8E89M42gppbM0L2Bl7Gu2SILynJpmNbUqvhMJvzfWOkZR3CaO1W3fkVAOjcC
        t6ubFRLJ54Zc9INyFuKilvzazKst59o=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-IuFxvau0PCaO_fWWTlR5Iw-1; Fri, 31 Jan 2020 16:08:14 -0500
X-MC-Unique: IuFxvau0PCaO_fWWTlR5Iw-1
Received: by mail-wr1-f69.google.com with SMTP id t3so3937408wrm.23
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 13:08:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PJqW6sEGELK0trBBJMQelpgP9cat66lBv2QLm4tjtU4=;
        b=EeQlQ5vIgJjYVpL/D4/TqR5ke5QuPkhckX3saTfxqifs9DsP6pa1xRHIjQsFrJgZwF
         uYm/M/7F67cTYyRpaxcju3AtZoL3I+1cPGki4w0fX8MCtwm6mVcbSq8nL7VZ7leTaL6X
         k8T3jGUDClEXdrvNjDKwchqrxnTeSlo9S420IkdMf5OFUu/+tdK6sYQ4qi3sFuJ6oBp7
         WsmX0uCctasxnUrqGm/NKtpRcNavTsZxLUwpfMP4gSI0RX1UuRcNuOgXmvIRyw28X/Yx
         Qn/jZauOHFZc8S27Cr61KsENGJ5Tl5ZnhWrqxT9m3dUde7NG8Oq1ubahOx/aU38bPUzR
         ZERg==
X-Gm-Message-State: APjAAAXxQVNI2mbz8FfhSbNfFNNQ/GVkKF7th3MZV8pX/G6EsLelJEmy
        1YUAhW3oiwzDNz7sSW6fiH9O3ZsOo5dvUc6QSbH0dFIU4naAZvDRq2jRmw2xEbmOLonSXXlwU30
        THmFr35rNFyUE
X-Received: by 2002:adf:df83:: with SMTP id z3mr261609wrl.389.1580504893585;
        Fri, 31 Jan 2020 13:08:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqwO7/1pA3KrXtKIpuDB8xxaQ3mp9WxKZJ1bIVxYVH3uD7S6NgJR8bvKgUvAH/KQbMFzQnpgGw==
X-Received: by 2002:adf:df83:: with SMTP id z3mr261565wrl.389.1580504892780;
        Fri, 31 Jan 2020 13:08:12 -0800 (PST)
Received: from [192.168.42.35] (93-33-8-199.ip42.fastwebnet.it. [93.33.8.199])
        by smtp.gmail.com with ESMTPSA id m21sm12584692wmi.27.2020.01.31.13.08.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 13:08:12 -0800 (PST)
Subject: Re: [GIT PULL] First batch of KVM changes for 5.6 merge window
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@suse.de>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
References: <1580408442-23916-1-git-send-email-pbonzini@redhat.com>
 <CAHk-=wjZTUq8u0HZUJ1mKZjb-haBFhX+mKcUv3Kdh9LQb8rg4g@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a7038958-bbab-4c53-72f0-ece46dc99b4d@redhat.com>
Date:   Fri, 31 Jan 2020 22:08:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CAHk-=wjZTUq8u0HZUJ1mKZjb-haBFhX+mKcUv3Kdh9LQb8rg4g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/01/20 19:01, Linus Torvalds wrote:
> There are other (pre-existing) differences, but while fixing up the
> merge conflict I really got the feeling that it's confusing and wrong
> to basically use different naming for these things when they are about
> the same bit.

I was supposed to get a topic branch and fix everything up so that both
CPU_BASED_ and VMX_FEATURE_ constants would get the new naming.  When
Boris alerted me of the conflict and I said "thanks I'll sort it out",
he probably interpreted it as me not needing the topic branch anymore.
I then forgot to remind him, and here we are.

> I don't care much which way it goes (maybe the VMX_FATURE_xyz bits
> should be renamed instead of the other way around?) and I wonder what
> the official documentation names are? Is there some standard here or
> are people just picking names at random?

The official documentation names are the ones introduced by the KVM pull
request ("Table 24-6. Definitions of Primary Processor-Based
VM-Execution Controls").  In fact consistency with the documentation was
why we changed them.  On the other hand Sean wanted VMX_FEATURE_* to be
consistent with CPU_BASED_*, which made sense when he wrote the patch.

I'll change the names to match for next week's second batch of KVM changes.

Paolo

