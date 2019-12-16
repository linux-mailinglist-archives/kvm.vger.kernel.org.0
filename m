Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D82B1200C0
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 10:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfLPJOW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 04:14:22 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25290 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727166AbfLPJOV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Dec 2019 04:14:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576487659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zgh8B5UVVhJ0kb2aJHbZhSX9CjHmzX3Tc0hUU8X+B0k=;
        b=dw3DA+QKWLJv+H/d1j+osckC/ggAZvEJHMXDI6q7YzkkGlJjETWBF9d+RheFcpPjlFIn8b
        DyJxmW1PBHkNk1vmxV8tpobFbHvaz/CaJbWB9u9+XJ3u7FG8k2+LE7v1GrS8ix+9SZLr0o
        ycPUvYwaLI68TyGuRMFIPqyHLJpKSd0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-MRTJvcWZOfCwwEpmZbNmSQ-1; Mon, 16 Dec 2019 04:14:18 -0500
X-MC-Unique: MRTJvcWZOfCwwEpmZbNmSQ-1
Received: by mail-wr1-f71.google.com with SMTP id f15so3463634wrr.2
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 01:14:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=zgh8B5UVVhJ0kb2aJHbZhSX9CjHmzX3Tc0hUU8X+B0k=;
        b=CQ3blf7YIgF8hXdC+Mx4ISsgOGEuQcLUmCuk4BxmuqEI7aeJor5v/u5jJGzjZKL5oc
         GsCjstmnngYSzS7yLQg7Yt9NbHPfIqfQJ2MjFogu8AeMh90WXXwh4ChhLSomzafsOVHT
         0JCqiMU+K0IMjAn+f1SvQan4L4oX/9GkJWuOpamJr8EO5OAt8E9fJTuiIZehbOJneMrl
         uAVImC+jyhx5kx/bnimT5JspP4n5XjLQbYNP0/oE0xY7dbs40GEPka4fi9A00o8NMOFA
         OQUcgDSbT9lN41Cf+2Q5MmHC8ZZnZtpeKcGWaRq7A/hXFDV2ZZZce4MAL2xGvEmkM4c7
         4MpQ==
X-Gm-Message-State: APjAAAWpunTETiZ6ctaCRg08BLg311r/OFAdKHObkZ4Sm2ik85IZYrYp
        BSHVwDPPdXeb+HtGUCtKe+N8v3bS1kbPnVcUMRGuOKuivKQLbLMFGqip3M/Q1YeOsNRyx5oBkst
        x48EaQ3FIAaAT
X-Received: by 2002:a05:600c:2549:: with SMTP id e9mr16935304wma.6.1576487657439;
        Mon, 16 Dec 2019 01:14:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqxXoQiyltOeC7M9BlpXK4XdsqqaREp6LjN+cHXuu5VqMmNwvD7OlJzLsprEYJzn+O3p3AgavQ==
X-Received: by 2002:a05:600c:2549:: with SMTP id e9mr16935286wma.6.1576487657225;
        Mon, 16 Dec 2019 01:14:17 -0800 (PST)
Received: from vitty.brq.redhat.com ([95.82.135.38])
        by smtp.gmail.com with ESMTPSA id k4sm20814513wmk.26.2019.12.16.01.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 01:14:16 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        paulus@ozlabs.org, jhogan@kernel.org, drjones@redhat.com,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 3/3] kvm/arm: Standardize kvm exit reason field
In-Reply-To: <b7b6b18c-1d51-b0c2-32df-95e0b7a7c1e5@redhat.com>
References: <20191212024512.39930-4-gshan@redhat.com> <2e960d77afc7ac75f1be73a56a9aca66@www.loen.fr> <f101e4a6-bebf-d30f-3dfe-99ded0644836@redhat.com> <30c0da369a898143246106205cb3af59@www.loen.fr> <b7b6b18c-1d51-b0c2-32df-95e0b7a7c1e5@redhat.com>
Date:   Mon, 16 Dec 2019 10:14:16 +0100
Message-ID: <87r214aazb.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gavin Shan <gshan@redhat.com> writes:

> On 12/13/19 8:47 PM, Marc Zyngier wrote:
>> On 2019-12-13 00:50, Gavin Shan wrote:
>>>
>>> Yeah, I think it is ABI change unfortunately, but I'm not sure how
>>> many applications are using this filter.
>> 
>> Nobody can tell. The problem is that someone will write a script that
>> parses this trace point based on an older kernel release (such as
>> what the distros are shipping today), and two years from now will
>> shout at you (and me) for having broken their toy.
>> 
>
> Well, I would like to receive Vitaly's comments here. Vitaly, it seems it's
> more realistic to fix the issue from kvm_stat side according to the comments
> given by Marc?
>

Sure, if we decide to treat tracepoints as ABI then fixing users is
likely the way to go. Personally, I think that we should have certain
freedom with them and consider only tools which live in linux.git when
making changes (and changing the tool to match in the same patch series
is OK from this PoV, no need to support all possible versions of the
tool). 

Also, we can be a bit more conservative and in this particular case
instead of renaming fields just add 'exit_reason' to all architectures
where it's missing. For ARM, 'esr_ec' will then stay with what it is and
'exit_reason' may contain something different (like the information why
the guest exited actually). But I don't know much about ARM specifics
and I'm not sure how feasible the suggestion would be.

-- 
Vitaly

