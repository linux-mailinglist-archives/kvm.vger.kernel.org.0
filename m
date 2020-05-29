Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B811E8179
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgE2PPX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:15:23 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55754 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbgE2PPW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 11:15:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590765321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SeLeCv9vM3H3I2JGP8/MuPPL1KTuklsFQ2TP2p7JQJw=;
        b=M9FTDzYyiSGCscIyg3j9iomddOYugXT391Tq3iJpjLdPY8Q9yPwtIasz0fdBRNPbDyiAlq
        7qO87TOdE8SPd5sRrzI0ri7EF4OSoS+DrgzxqrtSrWK26LGEpfwEfkYh9XOuSPK0NR8Wek
        nJr8Uf74Px4XBx6fCiOOxE9OnkZgKvg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-Ki1FLLcuOG-w91ioKf5AJQ-1; Fri, 29 May 2020 11:15:20 -0400
X-MC-Unique: Ki1FLLcuOG-w91ioKf5AJQ-1
Received: by mail-wm1-f72.google.com with SMTP id o8so2664702wmd.0
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 08:15:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SeLeCv9vM3H3I2JGP8/MuPPL1KTuklsFQ2TP2p7JQJw=;
        b=YZ1WcF664OGxmGMkkplR+82+YnbbClkTUlyq5pvmegufUxCeeBmGbkF32WlTbjcD39
         Sx+yXKDo7ZIKKlCoQRuMd8dObfpHvVFjNpEH7/nWKznfL+eTGCoFKWu5xrt4x1sfa/Ym
         mQNtr5iBw+N8RSbZu0CC+pX8cBJDS2mF4GmivL3eDQ44WXHMTruiiAO2zq3vls5p8PYg
         B0zEIkm3nTZ1yOaDPypMTcRZXc69MWuQf318iHU7h9FCpwwurygpXjhFeLphBaoICIoH
         nBg8RllPo/Me1OqjmYtE1TQb8XsUWKPBHflGbNurF0vXDdGjWLKcsZHHPLgEFzk/VxpS
         Ig1w==
X-Gm-Message-State: AOAM53114TdOh1fQyHLt8JCMtiuyUWeE5OoxW4mtMcOlHr3cLjKosr4z
        6F8W5VtpkHhtVYtey6cPevn2MtioUaYyYa7SzsvVe4BdGXBbC1xeNWCVwR7cL6tpZLjY7XWdzGZ
        GdsQTPFo779Ep
X-Received: by 2002:adf:ea90:: with SMTP id s16mr9045583wrm.299.1590765318894;
        Fri, 29 May 2020 08:15:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFgImluB9qe30SAnUY3gzbPTIKDHRP1THMFSMSV9kPen4yCHH/tgLWt4HMERiYDaS6qGoKuA==
X-Received: by 2002:adf:ea90:: with SMTP id s16mr9045561wrm.299.1590765318672;
        Fri, 29 May 2020 08:15:18 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.160.89])
        by smtp.gmail.com with ESMTPSA id w3sm1919464wmg.44.2020.05.29.08.15.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 08:15:18 -0700 (PDT)
Subject: Re: [PATCH v12 0/6] x86/kvm/hyper-v: add support for synthetic
To:     Jon Doron <arilou@gmail.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, rvkagan@yandex-team.ru
References: <20200529134543.1127440-1-arilou@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d4c0a79c-6048-43d2-a111-f206032ffbb6@redhat.com>
Date:   Fri, 29 May 2020 17:15:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200529134543.1127440-1-arilou@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/05/20 15:45, Jon Doron wrote:
> Add support for the synthetic debugger interface of hyper-v, the synthetic
> debugger has 2 modes.
> 1. Use a set of MSRs to send/recv information (undocumented so it's not
>    going to the hyperv-tlfs.h)
> 2. Use hypercalls
> 
> The first mode is based the following MSRs:
> 1. Control/Status MSRs which either asks for a send/recv .
> 2. Send/Recv MSRs each holds GPA where the send/recv buffers are.
> 3. Pending MSR, holds a GPA to a PAGE that simply has a boolean that
>    indicates if there is data pending to issue a recv VMEXIT.
> 
> The first mode implementation is to simply exit to user-space when
> either the control MSR or the pending MSR are being set.
> Then it's up-to userspace to implement the rest of the logic of sending/recving.
> 
> In the second mode instead of using MSRs KNet will simply issue
> Hypercalls with the information to send/recv, in this mode the data
> being transferred is UDP encapsulated, unlike in the previous mode in
> which you get just the data to send.
> 
> The new hypercalls will exit to userspace which will be incharge of
> re-encapsulating if needed the UDP packets to be sent.
> 
> There is an issue though in which KDNet does not respect the hypercall
> page and simply issues vmcall/vmmcall instructions depending on the cpu
> type expecting them to be handled as it a real hypercall was issued.
> 
> It's important to note that part of this feature has been subject to be
> removed in future versions of Windows, which is why some of the
> defintions will not be present the the TLFS but in the kvm hyperv header
> instead.
> 
> v12:
> - Rebased on latest origin/master
> - Make the KVM_CAP_HYPERV_SYNDBG always enabled, in previous version
>   userspace was required to explicitly enable the syndbg capability just
>   like with the EVMCS feature.

I removed the capability altogether; the CPUID interface was added
exactly to avoid a proliferation of capabilities.

Otherwise it's great; queued, thanks.

Paolo

