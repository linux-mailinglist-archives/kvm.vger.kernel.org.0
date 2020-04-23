Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BDD1B5C29
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 15:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgDWNJ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 09:09:58 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57503 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726670AbgDWNJ5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 09:09:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587647397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IdinXCqJfRCZgVfA06mXMGWP27voGlnnDgqPkPUuXHQ=;
        b=hTyQQDvygMqaOtjUCpC3iC5DgfoPqvg5HttX1fdkhaZwEDITrHsJ8QLjp3k7MCz3TDEpbt
        rxWHnc1RpoDpB/laA5QQ+qOFYeiqPLgGXF5VFjcYmUzB4mSJq5XtOKaISy4NHSuawonTjF
        wylkI4iUupXm83gCZzcn/5aXHgoRKrQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-npgfCqAZNQGWMxbxITBGdA-1; Thu, 23 Apr 2020 09:09:55 -0400
X-MC-Unique: npgfCqAZNQGWMxbxITBGdA-1
Received: by mail-wm1-f71.google.com with SMTP id q5so1969735wmc.9
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 06:09:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IdinXCqJfRCZgVfA06mXMGWP27voGlnnDgqPkPUuXHQ=;
        b=Q3ACWs73i+2NbGYpjwKm3f68Rm3IXOxXLXDR8pES9Xo4bcZrrekTYUdDdtBIBueMs6
         FgGDpveO9MkVACYxtzec6XO6+LTy3g+NbF3aQS6yQKr+PjpX3Qy4CmTyZKGioZpNd933
         ep43crGR5QR64Gz+tMxFWi73vLFLwS35KbDU5v1JN2Xt23DZx+sUlwQLiukDdxvune6n
         iD1iS+NiXi5Atecs2aPcVfHMpEmf6Nqk7eLuFpXQyn8gd0TCBV3K1r6Tps0G0GUhPB1N
         Kq47UBoLjzkrhhVPtRAWdQVani66hR1IcQ9pY9w6ho2RUQRpp8QbfzYQMtfjrb9IgSGy
         82yw==
X-Gm-Message-State: AGi0PuaHb3jdNDt0Gt6qJ1WQE3ruuRKUqztNvuG9dpxtzN8+4a8sUss3
        jNpktOSE5wEDkpAxCnhWvRTn7/VvNcrSc6ufvQ89+BvCvnKcqmHvwDKcjjxYaNebDJhikZP/2nm
        Iwwl1UC1xPQTz
X-Received: by 2002:a5d:420d:: with SMTP id n13mr5326778wrq.204.1587647392803;
        Thu, 23 Apr 2020 06:09:52 -0700 (PDT)
X-Google-Smtp-Source: APiQypKUZdILxUxEUY9M3uIZZlX5wYN9iQ9hZggVqr6R47Bv4L1KltPEiyeTOqSHqyMh/e7XQZ2P5Q==
X-Received: by 2002:a5d:420d:: with SMTP id n13mr5326746wrq.204.1587647392575;
        Thu, 23 Apr 2020 06:09:52 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id b22sm11920460wmj.1.2020.04.23.06.09.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 06:09:51 -0700 (PDT)
Subject: Re: [PATCH] kvm: add capability for halt polling
To:     Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Jon Cargille <jcargill@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20200417221446.108733-1-jcargill@google.com>
 <87d083td9f.fsf@vitty.brq.redhat.com>
 <CALMp9eREdS=nfdtvfNhW87G20Tfdwy69Phdbdmo=NzAw_tavzw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cea84a43-e400-54b9-a6bc-3ad834c17880@redhat.com>
Date:   Thu, 23 Apr 2020 15:09:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eREdS=nfdtvfNhW87G20Tfdwy69Phdbdmo=NzAw_tavzw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/20 23:36, Jim Mattson wrote:
>>> +     case KVM_CAP_HALT_POLL: {
>>> +             if (cap->flags || cap->args[0] != (unsigned int)cap->args[0])
>>> +                     return -EINVAL;
>>> +
>>> +             kvm->max_halt_poll_ns = cap->args[0];
>> Is it safe to allow any value from userspace here or would it maybe make
>> sense to only allow [0, global halt_poll_ns]?
> Would that restriction help to get this change accepted?
> 

No, in the sense that I'm applying it already.

Paolo

