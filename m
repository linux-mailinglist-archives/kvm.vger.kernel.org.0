Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B750146C44
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 16:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbgAWPFI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 10:05:08 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57542 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726232AbgAWPFH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Jan 2020 10:05:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579791906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vri1PiNggc4kMFOyjNBBzvcf8kkA+0uO3Ck4TLEP00Y=;
        b=fUBs/DqD+jSq16YTkx9azaiOWmjQvUIXeiFw4yYJKEEHxZBSwlwy1MBqo84LigISAJkf/g
        JUUmyRRTEQfwtv5jxwca+JGFb72+cqgdshIL8vbOkJidtQMo5s0eW/zEkVUeqbwU/A/TGe
        mt/VTInlIesix2EqdVk4u9nB9SuIjvE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-iJ1eXOiQN7a8-IOVdqj0MQ-1; Thu, 23 Jan 2020 10:05:03 -0500
X-MC-Unique: iJ1eXOiQN7a8-IOVdqj0MQ-1
Received: by mail-wm1-f70.google.com with SMTP id y125so839613wmg.1
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 07:05:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vri1PiNggc4kMFOyjNBBzvcf8kkA+0uO3Ck4TLEP00Y=;
        b=naeaZt5qxwjkJgk/EzrgA6LyyQR77fFfir5vX6UZezc5lJ4oUWwEae1OmXFVZm2n1P
         7/7k4wT2EKjRiOsmuaVKTaNyKJDFcWqBNoTtWA+/ddJXhIRsvnqdrU7626NuznK4jq8X
         yI0g7E4AdZE7CczYLlphpz5+hHAwqpTGC88LhJ3B52HOH/3CHQBIPSwUCuICar3rJjUK
         Tgsq73DtgigFbqyYJ+aegKJS7NGM1NDxJBWPKdEmQtLwCFzeoTTN4lKzN04LjmJxE5Y5
         pXnCHp5Zdr3uP5zzSq0Mndr4Ze35c9m5tQDBDO0ZHbvMMfBEK+mamfwU77M3hgXEmlsQ
         9K2w==
X-Gm-Message-State: APjAAAVSWEvH9A7BKms5/iBEIYp+QQP7e7pyeTNcbtrH8us/8eA7g7I4
        Nu04qdu9ApVZKe75tBHko+YEYi6y0tXaKreNL9RSE3ICLhy6HTjG2KkcQ6i+sNcwta7K4iAjOux
        cr7kYHEp6CNhf
X-Received: by 2002:a1c:9a56:: with SMTP id c83mr4710494wme.79.1579791902852;
        Thu, 23 Jan 2020 07:05:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqwyzmBgLo2X+QxowpQ8W2rLbvoB593D5jfFwLuoy6KhhwN4Ns7zQHLLaFbW0YhjgklXIQ8fWw==
X-Received: by 2002:a1c:9a56:: with SMTP id c83mr4710479wme.79.1579791902646;
        Thu, 23 Jan 2020 07:05:02 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id d16sm3807788wrg.27.2020.01.23.07.05.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 07:05:02 -0800 (PST)
Subject: Re: [PATCH 2/2] kvm: Add ioctl for gathering debug counters
To:     Alexander Graf <graf@amazon.de>, milanpa@amazon.com,
        Milan Pandurov <milanpa@amazon.de>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, borntraeger@de.ibm.com
References: <20200115134303.30668-1-milanpa@amazon.de>
 <18820df0-273a-9592-5018-c50a85a75205@amazon.de>
 <8584d6c2-323c-14e2-39c0-21a47a91bbda@amazon.com>
 <ab84ee05-7e2b-e0cc-6994-fc485012a51a@amazon.de>
 <668ea6d3-06ae-4586-9818-cdea094419fe@redhat.com>
 <e77a2477-6010-ae1d-0afd-0c5498ba2117@amazon.de>
 <30358a22-084c-6b0b-ae67-acfb7e69ba8e@amazon.com>
 <7f206904-be2b-7901-1a88-37ed033b4de3@amazon.de>
 <7e6093f1-1d80-8278-c843-b4425ce098bf@redhat.com>
 <6f13c197-b242-90a5-3f53-b75aa8a0e5aa@amazon.de>
 <b69546be-a25c-bbea-7e37-c07f019dcf85@redhat.com>
 <c3b61fff-b40e-07f8-03c4-b177fbaab1a3@amazon.de>
 <3d3d9374-a92b-0be0-1d6c-82b39fe7ef16@redhat.com>
 <25821210-50c4-93f4-2daf-5b572f0bcf31@amazon.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2e2cd423-ab6c-87ec-b856-2c7ca191d809@redhat.com>
Date:   Thu, 23 Jan 2020 16:05:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <25821210-50c4-93f4-2daf-5b572f0bcf31@amazon.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/01/20 15:58, Alexander Graf wrote:
>> the case, of course it would be fine for me to use ONE_REG on a VM.  The
>> part which I don't like is having to make all ONE_REG part of the
>> userspace ABI/API.
> 
> We don't have all of ONE_REG as part of the user space ABI today.

Still those that exist cannot change their id.  This makes them a part
of the userspace ABI.

> But I like the idea of a ONE_REG query interface that gives you the list
> of available registers and a string representation of them. It would
> make programming kvm from Python so easy!

Yeah, wouldn't it?  Milan, what do you think about it?

Paolo

