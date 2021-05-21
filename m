Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680FD38C8EF
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 16:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235464AbhEUOKh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 10:10:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57861 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232291AbhEUOKg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 10:10:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621606152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ae30da3lTczukBTtcyhtZQMh33Yk+JNXfJS9MzX8LNU=;
        b=WZjvjpCrG1OjkeLDSdQhNMGVHxQQcMYwUI9OsJguZHa6yG3A/+h7gEJc8kLu5M+QLu/q3v
        DCwIB7H3bV9ZpB1MJcEwFtFEPF8g/pLxgk+qkgg1hp3gGFNLPT/f8w4uCnTBshTNM0AzMK
        9hjVZ5FoqrQ4WSk2XQMrh+u6/paFMZ0=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-mY0Wcen1NTW_DHmANVOsXw-1; Fri, 21 May 2021 10:09:09 -0400
X-MC-Unique: mY0Wcen1NTW_DHmANVOsXw-1
Received: by mail-oo1-f71.google.com with SMTP id o1-20020a4adb610000b029020660e40b70so13370527ood.22
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 07:09:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ae30da3lTczukBTtcyhtZQMh33Yk+JNXfJS9MzX8LNU=;
        b=Ml75aGdQmriK+Ph8YWB0R8waOgvPw7pueykFnzIVAmX8NBA9nP/Wv7Z5OshRNiw6Mh
         8mJuLV/ZRe5abTBlEjDN9zR08V1RBmcEB6nuJBNhedAQV7jiAluts/BLOSI4JyucAs7w
         EW0txc3faz2K/+ePghpcFtdMOe9zRp96S8egaToAoDBREJOiUYLk1J9u4SSj/Ya2wBRZ
         JbIwLKTf07RE8r/p9eoTjNUWNkNmKlS0Ht6yY97XmRvu8wrYHqovbdnBzHgcVvXNRzAI
         usUYR8O2SgGT6QWm7SjluQF0vmqe8skJfArWYfwzAA02k4HMP7Xm0CelCstahtYMq4/+
         nSCw==
X-Gm-Message-State: AOAM533Ce4Wf8z4Ro1RmTQgwGM+/AH93OnfxxZUryGyI81E/iW5mcAAr
        KeQMI+4KSkY11AwraoGasaiCmG08u5/OI3zF6dJe01WJiBwylDPq+t9Qgr+4yhyzUdi2fWAdMyn
        Xar7UjK8mJytRiQB7+kRQZOjKEcjm7Yvzjyxz16OyRub4RZhf6HU9nvhiqT61JQ==
X-Received: by 2002:a05:6830:11d7:: with SMTP id v23mr1804180otq.44.1621606148796;
        Fri, 21 May 2021 07:09:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytWPQ63oi28CRsyVF44/qTyEPN8ADrsSFKajU2BxpMe/wub6EOk9B7M0fb5K9fgoUInh7NUA==
X-Received: by 2002:a05:6830:11d7:: with SMTP id v23mr1804151otq.44.1621606148538;
        Fri, 21 May 2021 07:09:08 -0700 (PDT)
Received: from [192.168.0.173] (ip68-103-222-6.ks.ok.cox.net. [68.103.222.6])
        by smtp.gmail.com with ESMTPSA id b18sm1321193otk.62.2021.05.21.07.09.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 May 2021 07:09:08 -0700 (PDT)
Subject: Re: [RFC PATCH 00/67] KVM: X86: TDX support
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1605232743.git.isaku.yamahata@intel.com>
 <3edc0fb2-d552-88df-eead-9e2b80e79be4@redhat.com>
 <20210520093155.GA3602295@private.email.ne.jp>
From:   Connor Kuehl <ckuehl@redhat.com>
Message-ID: <d584231c-96e8-ca98-6dd1-7763003d7fd3@redhat.com>
Date:   Fri, 21 May 2021 09:09:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210520093155.GA3602295@private.email.ne.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/21 4:31 AM, Isaku Yamahata wrote:
> On Wed, May 19, 2021 at 11:37:23AM -0500,
> Connor Kuehl <ckuehl@redhat.com> wrote:
> 
>> On 11/16/20 12:25 PM, isaku.yamahata@intel.com wrote:
>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>
>>> * What's TDX?
>>> TDX stands for Trust Domain Extensions which isolates VMs from
>>> the virtual-machine manager (VMM)/hypervisor and any other software on
>>> the platform. [1]
>>> For details, the specifications, [2], [3], [4], [5], [6], [7], are
>>> available.
>>>
>>>
>>> * The goal of this RFC patch
>>> The purpose of this post is to get feedback early on high level design
>>> issue of KVM enhancement for TDX. The detailed coding (variable naming
>>> etc) is not cared of. This patch series is incomplete (not working).
>>> Although multiple software components, not only KVM but also QEMU,
>>> guest Linux and virtual bios, need to be updated, this includes only
>>> KVM VMM part. For those who are curious to changes to other
>>> component, there are public repositories at github. [8], [9]
>>
>> Hi,
>>
>> I'm planning on reading through this patch set; but before I do, since
>> it's been several months and it's a non-trivially sized series, I just
>> wanted to confirm that this is the latest revision of the RFC that
>> you'd like comments on. Or, if there's a more recent series that I've
>> missed, I would be grateful for a pointer to it.
> 
> Hi. I'm planning to post rebased/updated v2 soon. Hopefully next week.
> So please wait for it. It will include non-trivial change and catch up for the updated spec.

That sounds great. I'll keep an eye out.

Thank you!

Connor

