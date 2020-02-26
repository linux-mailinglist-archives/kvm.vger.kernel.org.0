Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4A5716FFB0
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 14:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgBZNLC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 08:11:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57525 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726765AbgBZNLC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 08:11:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582722661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m0TtEHDHCO42Q9GTo9Ybh1BaRZcDi57GOxuE4MyXihQ=;
        b=YhcZ/SVniwnPR0FpE/39Z05byIhdWGlwZk9h49NPknYlavhltgpfsl5bFIlZeGDu4HGDBI
        h9E86CRus83qQGjTx9aGLOWDqYu+1F4bZizvYLsV+feU1KuR4pNIX4WjTtp8VfOUg6IWxj
        YuHXFL692m7F1xqZ8AEQ4gb21mfhos8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-3pOqwPTtPR6aSK2-41ifbg-1; Wed, 26 Feb 2020 08:10:59 -0500
X-MC-Unique: 3pOqwPTtPR6aSK2-41ifbg-1
Received: by mail-wm1-f72.google.com with SMTP id j130so678439wmj.9
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 05:10:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=m0TtEHDHCO42Q9GTo9Ybh1BaRZcDi57GOxuE4MyXihQ=;
        b=GtesMndCOVg6I2bNPEEXpbDRmkkEfblu1XqZ7aLCjWaGWJUhFGDUkSRU4zi3K3n0fl
         TAssIy+BbueXkui7iP7ghTsx5aflk4FLUJSDYvYWFZWrC+a+tqjuQ01nBivQTn8Wbkj4
         3c+jff1RxfQJWM3aEAPLf9uRtLnfgmfQi3fSxvlQ372Y51cvnq4115A4TrLdJZF7yaLE
         iqadN5TtJOVMyZYcO0jfygWvcvfR88K9+FL5WHeYSSUkg/i6zFNOZPvS/xS27G1+fmED
         6cRfRMhA7v1ezKxRv04KjBtya1su2+Q1wS508cWrRnbltiJLhXQOxMHjcTB5map+CdA0
         c4vw==
X-Gm-Message-State: APjAAAVUFE2mZwU+6ajOr4htYg1HNdXFtkZJ7NJHnAl7MIL+CY14WxbT
        l5quPNoR9YGUIpIQo2EJMHMHz4Gmxb47A8vzkNzbgHkDXupqiArRu1vFVPh/mtWiZjlmyNnTifw
        s70v7wA+jpVau
X-Received: by 2002:adf:ee4c:: with SMTP id w12mr5484067wro.310.1582722658316;
        Wed, 26 Feb 2020 05:10:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqxqfgaBcw9P54nxu0njwaxXrTFvBjiwsyYYA1AskRRYgdt+S83CzUmE04FqC5v5uQVR5VjdlA==
X-Received: by 2002:adf:ee4c:: with SMTP id w12mr5484050wro.310.1582722658112;
        Wed, 26 Feb 2020 05:10:58 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id z1sm2777575wmf.42.2020.02.26.05.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 05:10:57 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>
Subject: Re: [PATCH RESEND v2 2/2] KVM: Pre-allocate 1 cpumask variable per cpu for both pv tlb and pv ipis
In-Reply-To: <CAKwvOd=bDW6K3PC7S5fiG5n_kwgqhbnVsBHUSGgYaPQY-L_YmA@mail.gmail.com>
References: <1581988104-16628-1-git-send-email-wanpengli@tencent.com> <1581988104-16628-2-git-send-email-wanpengli@tencent.com> <CANRm+CyHmdbsw572x=8=GYEOw-YQCXhz89i9+VEmROBVAu+rvg@mail.gmail.com> <CAKwvOd=bDW6K3PC7S5fiG5n_kwgqhbnVsBHUSGgYaPQY-L_YmA@mail.gmail.com>
Date:   Wed, 26 Feb 2020 14:10:56 +0100
Message-ID: <87mu95jxy7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nick Desaulniers <ndesaulniers@google.com> writes:

> (putting Paolo in To: field, in case email filters are to blame.
> Vitaly, maybe you could ping Paolo internally?)
>

I could, but the only difference from what I'm doing right now would
proabbly be the absence of non-@redaht.com emails in To/Cc: fields of
this email :-)

Do we want this fix for one of the last 5.6 RCs or 5.7 would be fine?
Personally, I'd say we're not in a great hurry and 5.7 is OK.

-- 
Vitaly

