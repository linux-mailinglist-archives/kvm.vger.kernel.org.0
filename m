Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5620728EE9C
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 10:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730383AbgJOIg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Oct 2020 04:36:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29495 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729723AbgJOIg1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Oct 2020 04:36:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602750986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F9w+zoR3mTh4DtIeByMLVWAPvOZriJCigcRbM/VP8aw=;
        b=bYVCaItHin9A++vES+AxBcm8jSdiwYf3P/i7idOnJg/l7l+pP/iaELOFqbtaSTj62hTivI
        yF+eebXQHL0lsuzxs9DucHJ0QV7TJ/aBxEItI6bDtSJ8cknSSFdspk0x+SWbMsxozWB+6i
        WPQE+Zr2lXo4Hf9Kpa84iomj4OcNwLg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-1Eef26uFM2W7wUK8FZWpQg-1; Thu, 15 Oct 2020 04:36:24 -0400
X-MC-Unique: 1Eef26uFM2W7wUK8FZWpQg-1
Received: by mail-wr1-f69.google.com with SMTP id r8so1363577wrp.5
        for <kvm@vger.kernel.org>; Thu, 15 Oct 2020 01:36:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=F9w+zoR3mTh4DtIeByMLVWAPvOZriJCigcRbM/VP8aw=;
        b=qcAYgRvskX6hMukCgS0zf0/IKe2rljd4FhxLQ+kW5la/X30Y2z6FpsEHsa5vDGZtLO
         uv7Nwt2t1ZpZOrpmFUOX4ibY45ihFuuVt/7zXGhdYU6TyN/YyeNkFwnmiWWKmjCpZJQc
         kjrG0AqBJrYU446cWWi3qjtaGGMZeXGTzijnMMLS3sulVek844jmLuXlGHvz1EYN8Irq
         qoF+GFNoJEt1r2cFnCcs4d3bvu1wp8Ow5zoptPeQXL20OjxArRe2oU6+SL4kzGosOmDJ
         sENthOjaoJnaEeDFRKzBVE4KcaS/dQrwA8ZisYErurYvrboc6yLgb/WnuVjuIXlKWSUP
         ogPw==
X-Gm-Message-State: AOAM533/SuKJMScd/THy8znaYHG0zFZ/gbGYecFTAY4wxH2JtbsJztp3
        HpH0cabTGf+xnq70GKgeAF3Syl8HoWB74j/LhUv3Z6fFpJEm0oAG+S8Ehw9E/o3Tda1H33cPsPt
        BViTTSeg1DrL6
X-Received: by 2002:a5d:4282:: with SMTP id k2mr2862901wrq.270.1602750982735;
        Thu, 15 Oct 2020 01:36:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyHhoAc7Dlx/JVvHBmD8h1cRTJzfpcSL2nHAdXTzwpVkG7rAkL9RB8EiqO0uzOZES6LPCgG3A==
X-Received: by 2002:a5d:4282:: with SMTP id k2mr2862887wrq.270.1602750982564;
        Thu, 15 Oct 2020 01:36:22 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t83sm3376042wmt.43.2020.10.15.01.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 01:36:21 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH kvm-unit-tests] runtime.bash: skip test when checked file doesn't exist
In-Reply-To: <849201e6-2c21-154d-cb5c-712bd9c3d3b4@redhat.com>
References: <20201014154258.2437510-1-vkuznets@redhat.com> <849201e6-2c21-154d-cb5c-712bd9c3d3b4@redhat.com>
Date:   Thu, 15 Oct 2020 10:36:20 +0200
Message-ID: <87o8l36g3f.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thomas Huth <thuth@redhat.com> writes:

> On 14/10/2020 17.42, Vitaly Kuznetsov wrote:
>> Currently, we have the following check condition in x86/unittests.cfg:
>> 
>> check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
>> 
>> the check, however, passes successfully on AMD because the checked file
>> is just missing. This doesn't sound right, reverse the check: fail
>> if the content of the file doesn't match the expectation or if the
>> file is not there.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  scripts/runtime.bash | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>> 
>> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
>> index 3121c1ffdae8..f94c094de03b 100644
>> --- a/scripts/runtime.bash
>> +++ b/scripts/runtime.bash
>> @@ -118,7 +118,10 @@ function run()
>>      for check_param in "${check[@]}"; do
>>          path=${check_param%%=*}
>>          value=${check_param#*=}
>> -        if [ -f "$path" ] && [ "$(cat $path)" != "$value" ]; then
>> +	if [ -z "$path" ]; then
>> +            continue
>> +	fi
>
> That runtime.bash script seems to use spaces for indentation, not tabs ...
> so could you please use spaces for your patch, too?
>

Yea, trusted my editior to do the right thing and it let me down... v2
is coming!

-- 
Vitaly

