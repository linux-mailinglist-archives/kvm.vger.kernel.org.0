Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA11A412290
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 20:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358661AbhITSQI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 14:16:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25145 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358183AbhITSFg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 14:05:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632161047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SWVwHRq14ilsQLOc2MssbVuHnIq/hySiCsUjJjq23mo=;
        b=H4hCN7xE9GZptnUJuBtZQ9819Gc4gNuEx50wwtFNlZnVkJFW9/a3fD+XJ2fDVKL0U6T7eS
        vi+231gV2Q95KfgSBKDY4M6qWASh+lojeUyonkeEu+34Z+zyCJokxNYwevxnm8SxS7fdEU
        ZZk1gLUr41cEIrZafRGZFNDhOIvOmgQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-BHcSuFZRPperNC7fr9N1EA-1; Mon, 20 Sep 2021 14:04:06 -0400
X-MC-Unique: BHcSuFZRPperNC7fr9N1EA-1
Received: by mail-wr1-f71.google.com with SMTP id c2-20020adfa302000000b0015e4260febdso5432667wrb.20
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 11:04:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SWVwHRq14ilsQLOc2MssbVuHnIq/hySiCsUjJjq23mo=;
        b=AxlFAtu0nSFTvOmy0IhIYaleBQzASxeq8sLfnb/dqsTjjBYNCCm7CysVVB0N4u4qDZ
         CWM5Zheoyk7zfYm4MTsOoEkJIltom58LoJTbJY7yuSBdSJ7HxGmzqkOmpMC/Ij1tVE0o
         44MxhILv5PWNcJNvkxtt6+sSaMskluGOo8dpNOhRvns9JVaycYqsUtf5hnAvGrqqRBuI
         P8hEwCWWI7t2zG5ijnjh0Vk5f3R629eavh5UVi99SKcQcgwEWoXNeZY2YfyVJzIFJmVM
         RiuSH5uCDSR6v3owkvqQO84dOpAbmSThKiHdsIyGyDmVpPWhI4wAf/aO63V8ElVSaQnJ
         EI+A==
X-Gm-Message-State: AOAM532ulPvQTAmRi6Z48ASOcA+/XMB6Ax0f3F+SHxrJrJX/APiViYZE
        DZGBR9bGeTaooKatXZW2dQbz36NFKzbeOL8CwjPxlbfuOsO5Px+ljR6KsAb2/1mVpRVdoooHSkp
        nJKiiyxa9GHUm
X-Received: by 2002:a1c:4b15:: with SMTP id y21mr316150wma.183.1632161044728;
        Mon, 20 Sep 2021 11:04:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsiXlWpB/5J0lr5JzRS5MkeXcdzSbANExZMY5rVvhRsi9JXbEvgdzcU/Xcv1j0BqCSxQP6vg==
X-Received: by 2002:a1c:4b15:: with SMTP id y21mr316126wma.183.1632161044523;
        Mon, 20 Sep 2021 11:04:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j134sm287087wmj.27.2021.09.20.11.04.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 11:04:03 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/2] Makefile: Fix cscope
To:     Andrew Jones <drjones@redhat.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1629908421-8543-1-git-send-email-pmorel@linux.ibm.com>
 <1629908421-8543-2-git-send-email-pmorel@linux.ibm.com>
 <1dd4c64e-3866-98c9-8178-dbff90dca55f@redhat.com>
 <2aaffea2-0a20-1a6d-eebb-69b6cfe6e83c@linux.ibm.com>
 <20210827102204.3y6gdpchn77cz7yo@gator.home>
 <327ff7e0-82d8-a12d-7565-e476b1dbcca8@redhat.com>
 <20210920141039.jfb2iektdzdjldy5@gator>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7b2d795b-a65c-1983-868c-b4ae38d939f8@redhat.com>
Date:   Mon, 20 Sep 2021 20:04:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210920141039.jfb2iektdzdjldy5@gator>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/09/21 16:10, Andrew Jones wrote:
> Hi Paolo,
> 
> You'll get a conflict when you go to merge because I already did it :-)
> 
> commit 3d4eb24cb5b4de6c26f79b849fe2818d5315a691 (origin/misc/queue, misc/queue)
> Author: Andrew Jones <drjones@redhat.com>
> Date:   Fri Aug 27 12:25:27 2021 +0200
> 
>      Makefile: Don't trust PWD
>      
>      PWD comes from the environment and it's possible that it's already
>      set to something which isn't the full path of the current working
>      directory. Use the make variable $(CURDIR) instead.
>      
>      Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
>      Reviewed-by: Thomas Huth <thuth@redhat.com>
>      Suggested-by: Thomas Huth <thuth@redhat.com>
>      Signed-off-by: Andrew Jones <drjones@redhat.com>
> 
> 
> 
> misc/queue is something I recently invented for stuff like this in order
> to help lighten your load a bit.

Ok, are you going to create a merge request?

