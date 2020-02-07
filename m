Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89BC915545A
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 10:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbgBGJQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 04:16:40 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:51488 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726999AbgBGJQk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 04:16:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581066998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3e6VGnl7p5aII5PG66IQC6em60bIEwWa13Qn8r4drow=;
        b=GyTxi4X0G4QdW/EatxE3KRRq9HHqEHLy3ZWslhR1TAgd/ALntY4p2ACdZ4AzajPXJ3SgjH
        oJMzBF3eXkSQs5+9a5JXV61MWaOV5CHj0s1puYVGYdttdiSf7MXkCJYvApWF0o45p0eUQy
        xrhKdXD16TauBV3eN27xqTQKEqJxQZM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-wpkXOpcrNYasF_BJ_es-Tg-1; Fri, 07 Feb 2020 04:16:37 -0500
X-MC-Unique: wpkXOpcrNYasF_BJ_es-Tg-1
Received: by mail-wm1-f69.google.com with SMTP id q125so488631wme.1
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 01:16:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=3e6VGnl7p5aII5PG66IQC6em60bIEwWa13Qn8r4drow=;
        b=dCo1Culf5tcIV0b8a4pZ9bRB+wqDXMb+dyE0noJN/sW4V5XqkTZudp72naWEySY100
         hpjqW3WtbeQnpYZBo60Lkwgk34IlSGkP67xv/BZOtD7zb7VdJqizwIss6MtjFpYccTki
         FgS3fIBsvzkamHwqVroDE9GhLRCxm7khDTjfWaEwK+B1d8DhCGJ57Jm7ue8LBubElabp
         r5cNlI7FyWlQyFKIpD3IybXhu8Yu3qKjtdZIgDr6PPJEErM0rPJrKQIssFaxdZfWLe/6
         Rn+6dY9Nrk0ZAuH5p6kfuugXR9sSI8H697AokkM6DMlkuYZmUpPpXoAN94ImkjwwfHs+
         AiMA==
X-Gm-Message-State: APjAAAWxVHuUjNmLflzn9uJDz4+auiQ+NH2v0GDARUZhUTEQIg1/MjNP
        5WoER7qHCzIGwLmOHJWN84qxro8jQFXz3gLRuYCGP2CMe9IjZtuUrPV99ftFSvyNX5BeQ8zlkmm
        F39iM8rPpk1iy
X-Received: by 2002:a1c:7f87:: with SMTP id a129mr3413211wmd.156.1581066996051;
        Fri, 07 Feb 2020 01:16:36 -0800 (PST)
X-Google-Smtp-Source: APXvYqxWo7rQpQBdxXn6bJTKzbF2UU/0mee8M38zNSRICzbl5n6q/+4CeKDtcLL8L2jb7RfK5OLSRg==
X-Received: by 2002:a1c:7f87:: with SMTP id a129mr3413176wmd.156.1581066995824;
        Fri, 07 Feb 2020 01:16:35 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id x132sm16326045wmg.0.2020.02.07.01.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 01:16:35 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     thuth@redhat.com, drjones@redhat.com, wei.huang2@amd.com,
        Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [PATCH v4 2/3] selftests: KVM: AMD Nested test infrastructure
In-Reply-To: <92106709-10ff-44d3-1fe8-2c77c010913f@oracle.com>
References: <20200206104710.16077-1-eric.auger@redhat.com> <20200206104710.16077-3-eric.auger@redhat.com> <92106709-10ff-44d3-1fe8-2c77c010913f@oracle.com>
Date:   Fri, 07 Feb 2020 10:16:34 +0100
Message-ID: <87blqag3kd.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Krish Sadhukhan <krish.sadhukhan@oracle.com> writes:

...
> +	asm volatile (
>> +		"vmload\n\t"
> Don't we need to set %rax before calling vmload ?
>

No, because it is already there

...
>> +		: : [vmcb] "r" (vmcb), [vmcb_gpa] "a" (vmcb_gpa)

"a" constraint in input operands does the job.

-- 
Vitaly

