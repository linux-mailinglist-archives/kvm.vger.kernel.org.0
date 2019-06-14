Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 937AD459AB
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 11:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbfFNJyr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 14 Jun 2019 05:54:47 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:33007 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbfFNJyr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 05:54:47 -0400
Received: by mail-wr1-f46.google.com with SMTP id n9so1869307wru.0
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2019 02:54:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=BKOmSvAQqs7e+hmjUgq+iWzt8I9C5915KyAol3sisdI=;
        b=KJYPkdCAQ1FjvKHTcme4WihK2M8iJIK2bmSPwVXJbc465RCwHZeYE++vx53E8EppIj
         iGW4if/mxpskaPX9aM7BG5o+8R60CjOAyAQnTayotev7bskkw7oHjoD8HI6136En3+TA
         cd11JtmRvMB3Qv0F8D7fjzVe+GgYEaNi2XpykOEiSpnefjBHT4OU4cbbGlWqxDsJ8+vR
         9FTYKhsyYTxUYRTBQ+eodLsLf0/FSA92ES0BAGfXoQleA6Aey5HjMwd5iT5fYyx3dUsA
         18hNrcTaXMS/qmQgNmQ+51OnlD9CnExwGkfapJ28BC4myixGbSpjewyAHpMjj/xSa0Wd
         jV1w==
X-Gm-Message-State: APjAAAW0OUBrRvwu1P7ka6adZF8pHLniPbnnTVdQRyaBGIfQjlVEpIf+
        E7UOMyc7g0ZKgihylM7dIPldKQ==
X-Google-Smtp-Source: APXvYqzKFGUDa5/YIKgWbD65aAxLH11Th9p9SPCvxDkXtuzlQdTuJWp+yPPMs28jm91qwG/RrGAAPQ==
X-Received: by 2002:a5d:49c4:: with SMTP id t4mr6458363wrs.318.1560506085030;
        Fri, 14 Jun 2019 02:54:45 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b6a:1220:f9e9:3f02:38a3:837b? ([2a01:e35:8b6a:1220:f9e9:3f02:38a3:837b])
        by smtp.gmail.com with ESMTPSA id d10sm3548311wrp.74.2019.06.14.02.54.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 02:54:44 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [libvirt] mdevctl: A shoestring mediated device management and
 persistence utility
From:   Christophe de Dinechin <cdupontd@redhat.com>
In-Reply-To: <20190613103555.3923e078@x1.home>
Date:   Fri, 14 Jun 2019 11:54:42 +0200
Cc:     Sylvain Bauza <sbauza@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Skultety <eskultet@redhat.com>,
        Libvirt Devel <libvir-list@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Erik Skultety <eskultet@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <4C4B64A0-E017-436C-B13E-E60EABC6F5F1@redhat.com>
References: <20190523172001.41f386d8@x1.home>
 <0358F503-E2C7-42DC-8186-34D1DA31F6D7@redhat.com>
 <20190613103555.3923e078@x1.home>
To:     Alex Williamson <alex.williamson@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 13 Jun 2019, at 18:35, Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> On Thu, 13 Jun 2019 18:17:53 +0200
> Christophe de Dinechin <cdupontd@redhat.com> wrote:
> 
>>> On 24 May 2019, at 01:20, Alex Williamson <alex.williamson@redhat.com> wrote:
>>> 
>>> Hi,
>>> 
>>> Currently mediated device management, much like SR-IOV VF management,
>>> is largely left as an exercise for the user.  This is an attempt to
>>> provide something and see where it goes.  I doubt we'll solve
>>> everyone's needs on the first pass, but maybe we'll solve enough and
>>> provide helpers for the rest.  Without further ado, I'll point to what
>>> I have so far:
>>> 
>>> https://github.com/awilliam/mdevctl  
>> 
>> While it’s still early, what about :
>> 
>> 	mdevctl create-mdev <parent-device> <mdev-type> [<mdev-uuid>]
>> 
>> where if the mdev-uuid is missing, you just run uuidgen within the script?
>> 
>> I sent a small PR in case you think it makes sense.
> 
> It sounds racy.  If the user doesn't provide the UUID then they need to
> guess that an mdev device with the same parent and type is theirs.

That is true irrespective of the usage, isn’t it? In other words, when you
invoke `mdevctl create-mdev`, you assert “I own that specific parent/type”.
At least, that’s how I read the way the script behaves today. Whether you
invoke uuidgen inside or outside the script does not change that assertion
(at least with today’s code).

>  How do you resolve two instances of this happening in parallel and both
> coming to the same conclusion which is their device.  If a user wants
> this sort of headache they can call mdevctl with `uuidgen` but I don't
> think we should encourage it further.

I agree there is a race, but if anything, having a usage where you don’t
pass the UUID on the command line is a step in the right direction.
It leaves the door open for the create-mdev script to do smarter things,
like deferring the allocation of the mdevs to an entity that has slightly
more knowledge of the global system state than uuidgen.

In other words, in my mind, `mdevctl create-mdev parent type` does not
imply “this will use uuidgen” but rather, if anything, implies “this will do the
right thing to prevent the race in the future, even if that’s more complex
than just calling uuidgen”.

However, I believe that this means we should reorder the args further.
I would suggest something like:

	mdevctl create-mdev <mdev-type> [<parent-device> [<mdev-uuid>]]

where

1 arg means you let mdevctl choose the parent device for you (future)
   (e.g. I want a VGPU of this type, I don’t really care where it comes from)
2 args mean you want that specific type/parent combination
3 args mean you assert you own that device

That also implies that mdevctl create-mdev should output what it allocated
so that some higher-level software can tell “OK, that’s the instance I got”.

> BTW, I've moved the project to https://github.com/mdevctl/mdevctl, the
> latest commit in the tree above makes that change, I've also updated
> the description on my repo to point to the new location.  Thanks,

Done.

> 
> Alex
> 
> --
> libvir-list mailing list
> libvir-list@redhat.com
> https://www.redhat.com/mailman/listinfo/libvir-list

