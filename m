Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7BF042C950
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 21:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhJMTHm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 15:07:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59772 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230313AbhJMTHl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 15:07:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634151936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Eiv40w3h1hcVei6B4W9Y1LVqxQiJmLHN86qfNssdwM=;
        b=gMez3/KkYzuEsZC5aVkDXJI9pKgSYBqGlRH9UjcivXLlXj3qFswusDtLXlI3TLUZwNdFqr
        EuZO6Cdus/7HsAYdxPe4HXaSidvY3aIfwrsiFlAbG+czIHn2AcddFzHOMEzdvh2zcT2s8L
        CgbyixF/GgpJLZrDSW0qeXpVTiMzlXo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425--lvSa4OhPDa0AIJ_6p5nMQ-1; Wed, 13 Oct 2021 15:05:35 -0400
X-MC-Unique: -lvSa4OhPDa0AIJ_6p5nMQ-1
Received: by mail-ed1-f72.google.com with SMTP id u17-20020a50d511000000b003daa3828c13so3101899edi.12
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 12:05:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7Eiv40w3h1hcVei6B4W9Y1LVqxQiJmLHN86qfNssdwM=;
        b=cQ8kFoTCIviGGXJGJz6O4mlWsVydAnr/DemO2BUR9JtkeVV9RaO7uBvPRZxv4aQtCR
         C/YpXTg2c2d1OpYFhNrRPjy0h33gVFr3ZGkMH9PfAFTFcu9k1xTBxPGwF5SSXXNl+/w6
         iHBHgkh11fRETQ4EVVpisV7lGKeR6Zj3O/BR9116X02UPYnBjSQk1bTkEQ2cL5iyiIfz
         TOaeJoVGASxAACHwiRccL3kjXN2TsrFwJOFhjsAPOQxzGtw8u3TD+iSnJH+uDtGK4t+e
         Ex/OJVxEDn+ikp/urkoV6jfY+LakTBGTUtPff2m2NlH6msooDGFhl4gjv9rtyEb5UI+n
         VTOA==
X-Gm-Message-State: AOAM5324gVBqKF5yFc5zlnCWkn4RvNJoHVPvLi1Q9tJoa3TTVLpbJmka
        Qg5GoxorsF2HpWfURppr1F3hNF6vUwCdVpYKFXOd+GfjyO2LYadoZIwuSffZGOyUzPi5VQn+iZX
        gUMt0wWVCenZ/
X-Received: by 2002:a50:bf02:: with SMTP id f2mr1748870edk.226.1634151934582;
        Wed, 13 Oct 2021 12:05:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmcKV0CYPqwd/mDtR926wvJB++ZYNsP6Vx3CrliwDx64dKP6XU/wrZXnneZ49I7EzdutDhVQ==
X-Received: by 2002:a50:bf02:: with SMTP id f2mr1748397edk.226.1634151931214;
        Wed, 13 Oct 2021 12:05:31 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r22sm278778ejd.109.2021.10.13.12.05.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 12:05:30 -0700 (PDT)
Message-ID: <f430d53f-59cf-a658-a207-1f04adb32c56@redhat.com>
Date:   Wed, 13 Oct 2021 21:05:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: kvm crash in 5.14.1?
Content-Language: en-US
To:     Salvatore Bonaccorso <carnil@debian.org>,
        Stephen <stephenackerman16@gmail.com>
Cc:     djwong@kernel.org, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, seanjc@google.com, rppt@kernel.org,
        James.Bottomley@hansenpartnership.com, akpm@linux-foundation.org,
        david@redhat.com, hagen@jauu.net
References: <85e40141-3c17-1dff-1ed0-b016c5d778b6@gmail.com>
 <2cd8af17-8631-44b5-8580-371527beeb38@gmail.com>
 <YWcs3XRLdrvyRz31@eldamar.lan>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YWcs3XRLdrvyRz31@eldamar.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/21 21:00, Salvatore Bonaccorso wrote:
> Hi,
> 
> On Sat, Oct 09, 2021 at 12:00:39PM -0700, Stephen wrote:
>>> I'll try to report back if I see a crash; or in roughly a week if the
>> system seems to have stabilized.
>>
>> Just wanted to provide a follow-up here and say that I've run on both
>> v5.14.8 and v5.14.9 with this patch and everything seems to be good; no
>> further crashes or problems.
> 
> In Debian we got a report as well related to this issue (cf.
> https://bugs.debian.org/996175). Do you know did the patch felt
> through the cracks?

Yeah, it's not a KVM patch so the mm maintainers didn't see it.  I'll 
handle it tomorrow.

Paolo

