Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA17043CBAD
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 16:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238064AbhJ0OOJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 10:14:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46332 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232901AbhJ0OOI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 10:14:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635343902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rPlcjmpRh7lIBb9ysHvcn9Jm3y0keBJttZPoQy9XWeU=;
        b=SA5KFqhjOi5AFneriUuPW2/VvZ4XL+2NyCh9cSCyj5kvc8wehhQ5Su4xgwMwRzaGs1nDz2
        iUuXxYpl5G1VgMPID4YP60l1kKZn7B9iTRJKX1oVqQMmJWhCqb/TVVo+6mdXaSZrV+ekFo
        3QZqQomv9/AQ6BfHwjiag6iAo15w/Rw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-Y2fEDSvSOEC0LwXzMDUk0g-1; Wed, 27 Oct 2021 10:11:41 -0400
X-MC-Unique: Y2fEDSvSOEC0LwXzMDUk0g-1
Received: by mail-wm1-f70.google.com with SMTP id y12-20020a1c7d0c000000b0032ccaad73d0so1312933wmc.5
        for <kvm@vger.kernel.org>; Wed, 27 Oct 2021 07:11:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rPlcjmpRh7lIBb9ysHvcn9Jm3y0keBJttZPoQy9XWeU=;
        b=mkJqJfRASkxHQltKJvO0SzsCiGfUUqKUlvFUUP4Odn8aeBZzpL98BTTe7qwclqm2HU
         2YedGmEEh+JuPW3GVPtwHrkawT6D7JaqwdkcVunWbrqNbiS6jLmFzk2wO3IC1T5svvOA
         z57i+QYtTxFCfnE2aRtNMwVAnAwEWEYHC2l5+k2GedrpJsWiTP6A9AMGhsFPtBb9iILp
         wx+hrU9OblETpQOFBqW6D5Sa+CsJKszxzc1fE8iHyX++jzeypuHowHiNyRCM91FscAWO
         L4bPMKnxH7DqKTguv8g9Yzv6c2i/ypxcZpeQPaWhdyvf0/ClWpNoEb+lIGE/4y9yp0rE
         TJ8g==
X-Gm-Message-State: AOAM532lRIN5BO37QrICkcml4VVk/ud18P7Q6qUB2M8VbInuANtLiG9c
        3Plk1YfJH9EI/G9q2UweQZpovB6c4VSRy69CRvIFAoWmAGeBg9oTD9dIGAyCjekCWx5dtO+5wEn
        fTJTW8PY70mQL
X-Received: by 2002:a05:600c:3b89:: with SMTP id n9mr5942154wms.7.1635343900274;
        Wed, 27 Oct 2021 07:11:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1FjwOf1e6IdsT5TMePNBMDiAYa24+2CFNIXTvefxpkQihLhiTxR4JuhEFTMrIeN+uxEoKeQ==
X-Received: by 2002:a05:600c:3b89:: with SMTP id n9mr5942126wms.7.1635343900116;
        Wed, 27 Oct 2021 07:11:40 -0700 (PDT)
Received: from [192.168.1.36] (62.red-83-57-168.dynamicip.rima-tde.net. [83.57.168.62])
        by smtp.gmail.com with ESMTPSA id j7sm4782010wmq.32.2021.10.27.07.11.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 07:11:39 -0700 (PDT)
Message-ID: <8fc703aa-a256-fdef-36a5-6faad3da47d6@redhat.com>
Date:   Wed, 27 Oct 2021 16:11:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v1 02/12] vhost: Return number of free memslots
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Hui Zhu <teawater@gmail.com>
References: <20211027124531.57561-1-david@redhat.com>
 <20211027124531.57561-3-david@redhat.com>
 <4ce74e8f-080d-9a0d-1b5b-6f7a7203e2ab@redhat.com>
 <7f1ee7ea-0100-a7ac-4322-316ccc75d85f@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
In-Reply-To: <7f1ee7ea-0100-a7ac-4322-316ccc75d85f@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/27/21 16:04, David Hildenbrand wrote:
> On 27.10.21 15:36, Philippe Mathieu-Daudé wrote:
>> On 10/27/21 14:45, David Hildenbrand wrote:
>>> Let's return the number of free slots instead of only checking if there
>>> is a free slot. Required to support memory devices that consume multiple
>>> memslots.
>>>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>> ---
>>>  hw/mem/memory-device.c    | 2 +-
>>>  hw/virtio/vhost-stub.c    | 2 +-
>>>  hw/virtio/vhost.c         | 4 ++--
>>>  include/hw/virtio/vhost.h | 2 +-
>>>  4 files changed, 5 insertions(+), 5 deletions(-)

>>> -bool vhost_has_free_slot(void)
>>> +unsigned int vhost_get_free_memslots(void)
>>>  {
>>>      return true;
>>
>>        return 0;
> 
> Oh wait, no. This actually has to be
> 
> "return ~0U;" (see real vhost_get_free_memslots())
> 
> ... because there is no vhost and consequently no limit applies.

Indeed.

Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

