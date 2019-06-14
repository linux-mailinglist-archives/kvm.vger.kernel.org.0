Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7539946207
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 17:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbfFNPGT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 14 Jun 2019 11:06:19 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35547 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfFNPGT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 11:06:19 -0400
Received: by mail-wr1-f65.google.com with SMTP id m3so2924429wrv.2
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2019 08:06:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=sAbfmNlGZcqdC06EujdxeQVFX7IsMJP2GyAAggzBakA=;
        b=LvH8f6MGdSlYs12UeMSdE97y0ia7VGPsMLaQmgFHS/jeYZRFpzOxDfJZp2xEFkK2jZ
         nXn0TsSx/K5XzNJCAI4iEQEUJZJZPFn8Sz/+34/O95kX06YgwPY/Bgp/b8eR5ELFCrXP
         KzDBfExXwVFUbapyhUAmtS4SkTNLc2IzHjLFQuQpDSLLLJpTOqhamw9RvtqDCECrbhAI
         lFANJCPjdRJYCNw7guBQmKNEYm0aoTPiTlF3UIlWrJG7v0k3/HIIQKizvHkiVog+mhkt
         ckSiUgXk1Q3HSNXbH3H4lS5guryg/8pCFTo/k6zptg+4Th6uSxE2na78TPbFOKtW6StV
         6TBg==
X-Gm-Message-State: APjAAAVfu8onQTFABcCalDEbER0MiIDJ2ieUFD0nTT8TylpUvGQRCXBf
        Qnn9U8JbST44MmBYnKarZN7kzWf9pC8=
X-Google-Smtp-Source: APXvYqze++Y5HgDD5pKQnnHmsgnDI6TIxUHowFlYXE6/jPii7vUm15KZewoW70lSOnmXPRhX/Hms/w==
X-Received: by 2002:adf:ec4c:: with SMTP id w12mr45002029wrn.160.1560524777337;
        Fri, 14 Jun 2019 08:06:17 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b6a:1220:6d3d:67e2:9fc4:cd4e? ([2a01:e35:8b6a:1220:6d3d:67e2:9fc4:cd4e])
        by smtp.gmail.com with ESMTPSA id s12sm2957180wmh.34.2019.06.14.08.06.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 08:06:16 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [libvirt] mdevctl: A shoestring mediated device management and
 persistence utility
From:   Christophe de Dinechin <cdupontd@redhat.com>
In-Reply-To: <20190614082328.540a04ea@x1.home>
Date:   Fri, 14 Jun 2019 17:06:15 +0200
Cc:     Sylvain Bauza <sbauza@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Skultety <eskultet@redhat.com>,
        Libvirt Devel <libvir-list@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <7CA32921-CEF3-4AE9-BA80-DD422C5F0E7F@redhat.com>
References: <20190523172001.41f386d8@x1.home>
 <0358F503-E2C7-42DC-8186-34D1DA31F6D7@redhat.com>
 <20190613103555.3923e078@x1.home>
 <4C4B64A0-E017-436C-B13E-E60EABC6F5F1@redhat.com>
 <20190614082328.540a04ea@x1.home>
To:     Alex Williamson <alex.williamson@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 14 Jun 2019, at 16:23, Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> On Fri, 14 Jun 2019 11:54:42 +0200
> Christophe de Dinechin <cdupontd@redhat.com> wrote:
> 
>> That is true irrespective of the usage, isn’t it? In other words, when you
>> invoke `mdevctl create-mdev`, you assert “I own that specific parent/type”.
>> At least, that’s how I read the way the script behaves today. Whether you
>> invoke uuidgen inside or outside the script does not change that assertion
>> (at least with today’s code).
> 
> What gives you this impression?

That your code does nothing to avoid any race today?

Maybe I was confused with the existing `uuidgen` example in you README,
but it looks to me like the usage model involves much more than just
create-mdev, and that any race that might exist is not in create-mdev itself
(or in uuidgen for that matter).

> Where is the parent/type ownership implied?

I did not imply it, but I read some concern about ownership
on your part in "they need to guess that an mdev device
with the same parent and type is *theirs*.” (emphasis mine)

I personally see no change on the “need to guess” implied
by the fact that you run uuidgen inside the script, so
that’s why I tried to guess what you meant.


> The intended semantics are
> "try to create this type of device under this parent”.

Agreed. Which is why I don’t see why trying to create
with some new UUID introduces any race (as long as
the script prints out that UUID, which I admit my patch
entirely failed to to)
> 

>>> How do you resolve two instances of this happening in parallel and both
>>> coming to the same conclusion which is their device.  If a user wants
>>> this sort of headache they can call mdevctl with `uuidgen` but I don't
>>> think we should encourage it further.  
>> 
>> I agree there is a race, but if anything, having a usage where you don’t
>> pass the UUID on the command line is a step in the right direction.
>> It leaves the door open for the create-mdev script to do smarter things,
>> like deferring the allocation of the mdevs to an entity that has slightly
>> more knowledge of the global system state than uuidgen.
> 
> A user might (likely) require a specific uuid to match their VM
> configuration.  I can only think of very niche use cases where a user
> doesn't care what uuid they get.

They do care. But I typically copy-paste my UUIDs, and then

1. copy-pasting at the end is always faster than between
the command and other arguments (3-args case). 

2. copy-pasting the output of the previous command is faster
than having one extra step where I need to copy the same thing twice
(2-args case).

So to me, if the script is intended to be used by humans, my
proposal makes it slightly more comfortable to use. Nothing more.

> 
>> In other words, in my mind, `mdevctl create-mdev parent type` does not
>> imply “this will use uuidgen” but rather, if anything, implies “this will do the
>> right thing to prevent the race in the future, even if that’s more complex
>> than just calling uuidgen”.
> 
> What race are you trying to prevent, uuid collision?

Of course not ;-)

I only added the part of the discussion below trying to figure out what
race you were seeing that was present only with my proposed changes.

I (apparently incorrectly) supposed that you had some kind of mdev
management within the script in mind. Obviously I misinterpreted.
That will teach me to guess when I don’t understand instead of just
ask…

> 
>> However, I believe that this means we should reorder the args further.
>> I would suggest something like:
>> 
>> 	mdevctl create-mdev <mdev-type> [<parent-device> [<mdev-uuid>]]
>> 
>> where
> 
> Absolutely not, now you've required mdevctl to implement policy in mdev
> placement.

No, I’m not requiring it. I’m leaving the door open if one day, say, we decide
to have libvirt tell us about the placement. That usage needs not go in right away,
I marked it as “(future)”.

Basically, all I’m saying is that since it’s early, we can reorder the
arguments so that the one you are most likely to change when you reuse
the command are the one that are last on the command-line, so that it
makes editing or copy-pasting easier. There isn’t more to it, and that’s
why I still do not see any new race introduced by that change.


>  mdevctl follows the unix standard, do one thing and do it
> well.  If someone wants to layer placement policy on top of mdevctl,
> great, but let's not impose that within mdevctl.

I’m not imposing anything (I believe). I was only trying to guess
where you saw things going that would imply there was a race with
my proposal that was not there without :-)

> 
>> 1 arg means you let mdevctl choose the parent device for you (future)
>>   (e.g. I want a VGPU of this type, I don’t really care where it comes from)
>> 2 args mean you want that specific type/parent combination
>> 3 args mean you assert you own that device
>> 
>> That also implies that mdevctl create-mdev should output what it allocated
>> so that some higher-level software can tell “OK, that’s the instance I got”.
> 
> I don't think we're aligned on what mdevctl is attempting to provide.
> Maybe you're describing a layer you'd like to see above mdevctl?
> Thanks,

No, again, I’m just trying to understand where you see a race.

Maybe instead of guessing, I should just ask: where is the race in
the two-args variant (assuming it prints the UUID it used) that does not
exist with the three-args variant?


Thanks
Christophe

> 
> Alex
> 
>>> BTW, I've moved the project to https://github.com/mdevctl/mdevctl, the
>>> latest commit in the tree above makes that change, I've also updated
>>> the description on my repo to point to the new location.  Thanks,  
>> 
>> Done.
>> 
>>> 
>>> Alex
>>> 
>>> --
>>> libvir-list mailing list
>>> libvir-list@redhat.com
>>> https://www.redhat.com/mailman/listinfo/libvir-list  

