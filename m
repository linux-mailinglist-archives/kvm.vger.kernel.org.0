Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04051A82C2
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 17:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439825AbgDNPaP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 11:30:15 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50433 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2439777AbgDNPaL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 11:30:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586878210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aukyKsacBlKSwzv6rHsqRBqct1XsBo0VpIQvasyukxI=;
        b=AJgoEa5fXIANWUqV3msYAcC9VvdGdHop5BPOOFilmpxxz79682AVo/Kv8HGmF/9NihEbqD
        Cp+nuJjtd5hADWdeHKMt/08lH5u7FLGHS3Vm0gOB/IhN09O1nfl6gxGxPYIx94tLzTSNSU
        GmRUPHyejmKNId5naHW7BDR4iGewjq4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-wMTkz8FbO8yvxx8UvuoQZg-1; Tue, 14 Apr 2020 11:30:08 -0400
X-MC-Unique: wMTkz8FbO8yvxx8UvuoQZg-1
Received: by mail-wm1-f70.google.com with SMTP id f17so3943678wmm.5
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 08:30:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=aukyKsacBlKSwzv6rHsqRBqct1XsBo0VpIQvasyukxI=;
        b=Gi2fFcH3QLwa/KHI+PRRRFB3kc+pnEnj4JkPWHau0lYpp+s2Z9cj+3BLAinasXkwY8
         Zfv3mrkPKVgXuvKqhLRVGiyIJs1zfKrAy2DzCiMcwgyKYcGIdGZhP3wUWbVxkh7rH7LP
         VXk/j4wfJ1zjY0/7v9bHH3r6PJLcgGEFKccbTeuNTYG9a5l2xz5l4chkGrxfv5TGpklx
         JTEEaAc5KxsV0jGCuOg4i6Wbmywg69zfRrhLxwol/VTVPmBeE5V53yVLfXyRdFyjJode
         RHtHzOGoMF/ePcqBIfOw3pTXkwTieu7D66tzNKvsK014z3j1ygyNY+LVLhPsxCnTEGmR
         cn6A==
X-Gm-Message-State: AGi0PuajyqRqfpU/i6YGORilMg0uRh6vOnShbfczEem0X7E3smsFMlZY
        m5pzv0tzDUn5j5Vy81ax5FhntpIIle78n4MHKqU1Jze3vhy4rYA8BfajyW/g7f529kXD0GkXi3M
        c2b1EbTShNRgc
X-Received: by 2002:a1c:3985:: with SMTP id g127mr431543wma.102.1586878206757;
        Tue, 14 Apr 2020 08:30:06 -0700 (PDT)
X-Google-Smtp-Source: APiQypIJ7FbOhsssx2BmeTXq75geDrECdXs6uz2DvT3DYK8Tz+BGWU3KnYBxzQMVMdeGDbf38MSjLQ==
X-Received: by 2002:a1c:3985:: with SMTP id g127mr431532wma.102.1586878206585;
        Tue, 14 Apr 2020 08:30:06 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u16sm19299088wro.23.2020.04.14.08.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 08:30:06 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>, thuth@redhat.com,
        nilal@redhat.com, kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [Patch v1] x86: Fix the logical destination mode test
In-Reply-To: <b0482ffb-a1e0-7d00-8883-53936487b955@redhat.com>
References: <1583795750-33197-1-git-send-email-nitesh@redhat.com> <20200310140323.GA7132@fuller.cnet> <4993e419-5eef-46ba-5dd0-e35c7103190b@redhat.com> <878siyyxng.fsf@vitty.brq.redhat.com> <b0482ffb-a1e0-7d00-8883-53936487b955@redhat.com>
Date:   Tue, 14 Apr 2020 17:30:05 +0200
Message-ID: <87wo6ixeyq.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nitesh Narayan Lal <nitesh@redhat.com> writes:

> On 4/14/20 10:01 AM, Vitaly Kuznetsov wrote:
>>
>> Also, this patch could've been split.
>
> I can divide it 2 parts:
> 1. support for logical destination mode.
> 2. support for physical destination mode. I can also fix  the above issue in
> this patch itself.
> Does that make sense?

Too late, it's already commited :-) I just meant to say that
e.g. spinlock part could've been split into its own patch, unittests.cfg
- another one,...

-- 
Vitaly

