Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD83231C07
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 11:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbgG2JWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 05:22:51 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:38367 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726548AbgG2JWv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Jul 2020 05:22:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596014569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cleKEEqa/Yi8QZ9Y9pY/hJ9mwP+xc/IFgNkiTAzi7w4=;
        b=doXSmJ/D/QyWLvuQdG1J3Bhb85vvhp+8+7itYpTpldr6xgEKYrHnuZSAgPbHJgsLKkZQEF
        Quw1TybqNAq74FOtTaUqPgGxJBXm2f6qJiwhgvCrU0QsvSNhBSA0QQf6Zj9TCAIBhvMvz3
        YNl4GcxeOduXiJ4HyLc/KX1jPVuGf08=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-CZ3g7Ix3NnKxf-6ZiSUG4Q-1; Wed, 29 Jul 2020 05:22:48 -0400
X-MC-Unique: CZ3g7Ix3NnKxf-6ZiSUG4Q-1
Received: by mail-ej1-f69.google.com with SMTP id bx27so3552075ejc.15
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 02:22:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=cleKEEqa/Yi8QZ9Y9pY/hJ9mwP+xc/IFgNkiTAzi7w4=;
        b=kuNZrm4lHCY13uIGen0DjDzTEsVxdTMwHP56zayP6JO7HXHKu29jNNs3msH9bSaS16
         T1EAWvETnRwxZgmdS1Uoa7r9cAwq/UiDS0cL1Bftwfss6snGe3yAQnjb216bwfQ9NwyO
         lO1ICC510iFefoiTsPUcsiYUdIO0bYsBpz5mZbVN4WCQikuDLJyVCCtiajNJgzWulvSl
         SYtp8xRvu8aEVXjE+Gi80bzvRpZ4nyF3l0oSX2daZPvgQgHu5SpB2ZN0+jFImZPYqMcK
         3djpkJiI9qCORRPwCk4a69fLyPK8+VD8jOGBo63/uOD3qzpxSOXb3vx6YdotrPD8ij9p
         +3yg==
X-Gm-Message-State: AOAM531wnbKiC238xPELQATKOub3MrubX3LFhG7VB4dUKRHWLDDuFyG/
        JAfHoDJhuTAy2Rp8wIFadw/V8O0IREblZWYr1nhu+JaHBkHwDu9p4KwquYx3X2Q1ebcPKstO+qg
        um8gJI7d3G8V4
X-Received: by 2002:aa7:c885:: with SMTP id p5mr31451500eds.100.1596014566900;
        Wed, 29 Jul 2020 02:22:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCfeK5XNoFAzUDf6eYvR8YIVLMGH++FnVZqU3fYGpDuVRQRBQL15uPpm5p2erVWzHIwOY8Cg==
X-Received: by 2002:aa7:c885:: with SMTP id p5mr31451482eds.100.1596014566725;
        Wed, 29 Jul 2020 02:22:46 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id c15sm1343755edm.47.2020.07.29.02.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 02:22:46 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Alexander Graf <graf@amazon.com>, Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH] KVM: x86: Deflect unknown MSR accesses to user space
In-Reply-To: <173948e8-4c7a-6dc4-de17-99151bc56d91@amazon.com>
References: <20200728004446.932-1-graf@amazon.com> <87d04gm4ws.fsf@vitty.brq.redhat.com> <a1f30fc8-09f5-fe2f-39e2-136b881ed15a@amazon.com> <CALMp9eQ3OxhQZYiHPiebX=KyvjWQgxQEO-owjSoxgPKsOMRvjw@mail.gmail.com> <87y2n2log7.fsf@vitty.brq.redhat.com> <173948e8-4c7a-6dc4-de17-99151bc56d91@amazon.com>
Date:   Wed, 29 Jul 2020 11:22:45 +0200
Message-ID: <87pn8ellp6.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alexander Graf <graf@amazon.com> writes:

> On 29.07.20 10:23, Vitaly Kuznetsov wrote:
>> 
>> 
>> 
>> Jim Mattson <jmattson@google.com> writes:
>> 
>>> On Tue, Jul 28, 2020 at 5:41 AM Alexander Graf <graf@amazon.com> wrote:
>>>>
>> 
>> ...
>> 
>>>> While it does feel a bit overengineered, it would solve the problem that
>>>> we're turning in-KVM handled MSRs into an ABI.
>>>
>>> It seems unlikely that userspace is going to know what to do with a
>>> large number of MSRs. I suspect that a small enumerated list will
>>> suffice.
>> 
>> The list can also be 'wildcarded', i.e.
>> {
>>   u32 index;
>>   u32 mask;
>>   ...
>> }
>> 
>> to make it really short.
>
> I like the idea of wildcards, but I can't quite wrap my head around how 
> we would implement ignore_msrs in user space with them?
>

For that I think we can still deflect all unknown MSR accesses to
userspace (when the CAP is enabled of course ) but MSRs which are on the
list will *have to be deflected*, i.e. KVM can't handle them internally
without consulting with userspace.

We can make it tunable through a parameter for CAP enablement if needed.

-- 
Vitaly

