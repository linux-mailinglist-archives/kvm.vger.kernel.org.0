Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61FF3F9500
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 09:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244255AbhH0HU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 03:20:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31844 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231592AbhH0HUz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 03:20:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630048806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M8VasvezmSl84LxW/Gp2bxkUkiZuhYPO9+N7tbIG3zY=;
        b=Ukft8AyyQdHvZsMsVfmAo5kK41gYoliekqjx+2/G9L9tZz1ynD87tDugwXmTWFSUBfG2X1
        Bm/ZLd9URa6hmUUwKyXILm84FWteLpLHU+I2oN9bKC5CLsuCfCK9lokVr0Xo9ptkXG3q5s
        ZcX+jrgwYLoxVvYalNCcxw+t4gQ2G9U=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-hN8eFI-YMSSsJy5a4Rgslw-1; Fri, 27 Aug 2021 03:20:05 -0400
X-MC-Unique: hN8eFI-YMSSsJy5a4Rgslw-1
Received: by mail-wr1-f71.google.com with SMTP id z15-20020adff74f000000b001577d70c98dso1580801wrp.12
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 00:20:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M8VasvezmSl84LxW/Gp2bxkUkiZuhYPO9+N7tbIG3zY=;
        b=FcJttW5z1uC2Ejx4sWhj9lXW3NyufEw6CFVwmVlrJmMUf54ge6IC0bJrlTfwKjn1Uv
         dima6oBR0qpV6hEtc3AcQL5KDHMsNnvBO1RZc9nKTp0OHTwTF5LHhO7wV2lQwh+KWWgy
         dTSmTncj6+3HDZOe4X2DEGEmsJ0XTRYFLU/ZIQBJJZRUu1CxLLGGlzZjbclyYXGiPK65
         T/lWuypmt5CrsiNGXhEkEdwvu43JxiSevHmjmWyfoYTrKaNwwii9IaY0nGDHrL27E57R
         kFN3mXrRAwrJlI6QOLpmVfDHNKSSoKY8M/OD8JGHcK/wb5q9YBv965c2iK26/HFT+PW7
         wrXA==
X-Gm-Message-State: AOAM530vnJmIIbOdMYMa297/U1L+SXC/sC85BJBDSktMDEvReteP+vSz
        UJxFikD/Z4aiLst7HhD/TigP+AxATFbsTzYdzBEJmljVxDMg0qNQ3te2GwqerDneJVbivcB0ueV
        nZAYVZrGF9fYY
X-Received: by 2002:a5d:58e7:: with SMTP id f7mr8684511wrd.51.1630048804263;
        Fri, 27 Aug 2021 00:20:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTl9i5nBeoXpyrIICHyuDAVdEjoMlEzjsx5J+YiYXGLf74oC1sYlJ6u79cx1FXoWewoLtWBw==
X-Received: by 2002:a5d:58e7:: with SMTP id f7mr8684494wrd.51.1630048804134;
        Fri, 27 Aug 2021 00:20:04 -0700 (PDT)
Received: from thuth.remote.csb (dynamic-046-114-148-182.46.114.pool.telefonica.de. [46.114.148.182])
        by smtp.gmail.com with ESMTPSA id n20sm4115941wms.15.2021.08.27.00.20.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 00:20:03 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 3/3] lib: s390x: Control register
 constant cleanup
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210820114000.166527-1-frankja@linux.ibm.com>
 <20210820114000.166527-4-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <a8302c3a-1bd6-7dbe-62d8-85601f28301e@redhat.com>
Date:   Fri, 27 Aug 2021 09:20:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210820114000.166527-4-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/08/2021 13.40, Janosch Frank wrote:
> We had bits and masks defined and don't necessarily need both.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/asm/arch_def.h | 28 ++++++++++++----------------
>   lib/s390x/smp.c          |  3 ++-
>   s390x/skrf.c             |  3 ++-
>   3 files changed, 16 insertions(+), 18 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

