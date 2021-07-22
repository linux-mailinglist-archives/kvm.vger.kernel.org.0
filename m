Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D1C3D22AD
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 13:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbhGVKqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 06:46:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39138 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231286AbhGVKqC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 06:46:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626953197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dS07Y/V11e6IrzCTBBUMMe6SQF4L0I4LjfL623uKcgM=;
        b=NjvBeRUtYKBVS3Oai+aai+iCKu2wuQvfVbMucLRtmav3TtLqdaX89bubDLGoXXiJaLNHwq
        Y4dtxh+g07CyMTpRZWvV75SzcYM4JcrzI14Wa2fciNd+DryIRpLYK/nwKTEilbHudG7+Uw
        f/QAeJIWmfm6OOqyKH5C32XwQC53Loo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-ORFMkZZcNpi9H24TCchz_A-1; Thu, 22 Jul 2021 07:26:35 -0400
X-MC-Unique: ORFMkZZcNpi9H24TCchz_A-1
Received: by mail-wr1-f70.google.com with SMTP id r6-20020a0560000146b0290150e4a5e7e0so2320650wrx.13
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 04:26:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dS07Y/V11e6IrzCTBBUMMe6SQF4L0I4LjfL623uKcgM=;
        b=M1GIS5dqzdGe+b82cFd+96ybOqcKDgkqpFclDnDyodZpgSHgBn0Ihq5wUclKCpZQb+
         jvHdTkd+xwCyqRsQcuA4oROZHe7Qvw6eFeM3MzLHqBzUJCcs98+FzaipL8+eLYxWrBYo
         1vwFu+C5jU+2SGOuqaaHYCPWCYZZ5Srt8uVp507xAdC+RsgD8JW6Qp17JIi0g+fxn13G
         X5l21NNB27qpwqD6a+dkRliN8WBYeF8fsspMlwgIH67hFDrJKz+tDxtAJIMxmDcTLQyV
         /qSZOD3X8zuaVUo1UeR/ALRgTkKVOzQAnOPt8iC36eSMEKvazFKvu6EwVNZPh95wBi+a
         n8aA==
X-Gm-Message-State: AOAM532g6ViS17weSzKlqwW9uOa+DbwDYw2ZwdcpcWtbClHLD7L+REPQ
        TyiDE/0on2rWT3zYYexBm3dWqQoBvboG1mide0OpCGhBn6wP3DD9WK5Pi+eIkLSbgQKj1/IScgv
        aVnXwMQUU84xc
X-Received: by 2002:adf:a183:: with SMTP id u3mr46940530wru.175.1626953194414;
        Thu, 22 Jul 2021 04:26:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwM9KeOC9Qtf8HOf3ALp8qZkcWSoa/llzKjGgDwP/c+MqpF8yQOTC8t9lI+Aa+rfb8g+aO3EA==
X-Received: by 2002:adf:a183:: with SMTP id u3mr46940517wru.175.1626953194165;
        Thu, 22 Jul 2021 04:26:34 -0700 (PDT)
Received: from thuth.remote.csb (pd9e83f5d.dip0.t-ipconnect.de. [217.232.63.93])
        by smtp.gmail.com with ESMTPSA id x8sm29622572wrt.93.2021.07.22.04.26.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 04:26:33 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] MAINTAINERS: s390x: remove myself as
 maintainer
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <20210721175157.4104-1-david@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <5e784067-dcb6-1bf1-8c4d-0f5a304348c8@redhat.com>
Date:   Thu, 22 Jul 2021 13:26:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210721175157.4104-1-david@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/07/2021 19.51, David Hildenbrand wrote:
> kvm-unit-tests for s390x is nowadays in a pretty good shape and in even
> better hands. As I've been mostly only reviewing selected patches
> lately because other projects are more important, and Thomas and Janosch
> have been handling PULL requests for a long time now without me, remove
> myself as maintainer.
> 
> But I want to know what's happening, so keep me added as a reviewer --
> so I can continue reviewing selected patches :)

David, thank you *very* much for your past work and on-going reviews of 
kvm-unit-test patches! If you ever reconsider, you're certainly welcomed 
back in the list of maintainers!

Patch pushed now.

  Thomas

