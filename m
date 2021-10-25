Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738C6438EEB
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 07:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbhJYFkd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 01:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhJYFkc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Oct 2021 01:40:32 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0071DC061745;
        Sun, 24 Oct 2021 22:38:10 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id d20so1490300qvm.4;
        Sun, 24 Oct 2021 22:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yghFMz392uOcuB4Z/ZyQL4CAW2XIY00a8fp/sEUunw8=;
        b=Te2l8WbCdIy0NPNic3cx1mKh9kL346a9mF/exTlIRE515c+WwjvHk/ctAwzDCgl71k
         AZg8hkj/Fukk1IZOXz31L61DDMgWVIIaXoJLk9HKRY8YvROVTewUtMVuBlaoCTzw7TiX
         g3TS4TtCX7bMp8UNTKq5HW+nU3MRtyiGtJtP/4YnJOLQ3DKtbUg+WTbcp1TfUBqVm+0v
         Zgn1p/uvUtE5a034x38TKdA8BlkXeIH2Irn3+fXeGUChnhSyXYy0DlwhRqYqUZJIs2zY
         6kkf4OKf12rANFTUEemCFHndImyXXy+pq284JyGvbzKGaxdSwdizqlbX7N/runeFZc5l
         uJUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yghFMz392uOcuB4Z/ZyQL4CAW2XIY00a8fp/sEUunw8=;
        b=A/uCzX3MWtiGZXEXW3cCShD0cqguwUnORlgyCgYXKw2sPdOJz86lk9sIh3r9UC68XS
         uADInCkrO9Jq5sd6B2hhK/b+mpAVK0NUhUWEhJyFgEqgM5O+sPiB5/EW9kWZwZq508n8
         huBk2UhnAzN13iNnJFo+IN+W5RELlLUY1iTQzUNO2j6igRFSYWAq9yHZ/K0xG2r3w6Sb
         rPB6B41aNQGQ8thqgvxW0CSXgUosa0OW2mczuoYnxSJ0+8F2t8+as3lBcFyf4AOb6rHY
         664QvYbBsOSyRNhIiXbHCqljaAJ3Kp3Pele37eBIQarjdKfv0N5ietXnHOWfNDwzFzYK
         VQNw==
X-Gm-Message-State: AOAM532hlXn7s8VyApYRc4woG5UACKLgUiHMNXs/5/I74nTgO7HAhrnW
        sgjN/4y3xOpXJtK2Zi9U+Yc=
X-Google-Smtp-Source: ABdhPJzl+miwIXTdiRHRuM4tlyWv6vNT13hdYme3hmhR1GHzMk6+5mhO28hj7H/y0qwKQ00JLZVZRg==
X-Received: by 2002:ad4:4144:: with SMTP id z4mr13433062qvp.22.1635140290153;
        Sun, 24 Oct 2021 22:38:10 -0700 (PDT)
Received: from [192.168.1.49] (c-67-187-90-124.hsd1.tn.comcast.net. [67.187.90.124])
        by smtp.gmail.com with ESMTPSA id c7sm7913544qke.78.2021.10.24.22.38.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Oct 2021 22:38:09 -0700 (PDT)
Subject: Re: [PATCH 4/5] driver core: inhibit automatic driver binding on
 reserved devices
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Patrick Williams <patrick@stwcx.xyz>
Cc:     Zev Weiss <zev@bewilderbeest.net>, kvm@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Rajat Jain <rajatja@google.com>,
        Jianxiong Gao <jxgao@google.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Saravana Kannan <saravanak@google.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        openbmc@lists.ozlabs.org, devicetree@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        dmaengine@vger.kernel.org
References: <20211022020032.26980-1-zev@bewilderbeest.net>
 <20211022020032.26980-5-zev@bewilderbeest.net> <YXJeYCFJ5DnBB63R@kroah.com>
 <YXJ3IPPkoLxqXiD3@hatter.bewilderbeest.net> <YXJ88eARBE3vU1aA@kroah.com>
 <YXLWMyleiTFDDZgm@heinlein> <YXPOSZPA41f+EUvM@kroah.com>
From:   Frank Rowand <frowand.list@gmail.com>
Message-ID: <627101ee-7414-57d1-9952-6e023b8db317@gmail.com>
Date:   Mon, 25 Oct 2021 00:38:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YXPOSZPA41f+EUvM@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/23/21 3:56 AM, Greg Kroah-Hartman wrote:
> On Fri, Oct 22, 2021 at 10:18:11AM -0500, Patrick Williams wrote:
>> Hi Greg,
>>
>> On Fri, Oct 22, 2021 at 10:57:21AM +0200, Greg Kroah-Hartman wrote:
>>> On Fri, Oct 22, 2021 at 01:32:32AM -0700, Zev Weiss wrote:
>>>> On Thu, Oct 21, 2021 at 11:46:56PM PDT, Greg Kroah-Hartman wrote:
>>>>> On Thu, Oct 21, 2021 at 07:00:31PM -0700, Zev Weiss wrote:
>>
>>>> So we want the kernel to be aware of the device's existence (so that we
>>>> *can* bind a driver to it when needed), but we don't want it touching the
>>>> device unless we really ask for it.
>>>>
>>>> Does that help clarify the motivation for wanting this functionality?
>>>
>>> Sure, then just do this type of thing in the driver itself.  Do not have
>>> any matching "ids" for this hardware it so that the bus will never call
>>> the probe function for this hardware _until_ a manual write happens to
>>> the driver's "bind" sysfs file.
>>
>> It sounds like you're suggesting a change to one particular driver to satisfy
>> this one particular case (and maybe I'm just not understanding your suggestion).
>> For a BMC, this is a pretty regular situation and not just as one-off as Zev's
>> example.
>>
>> Another good example is where a system can have optional riser cards with a
>> whole tree of devices that might be on that riser card (and there might be
>> different variants of a riser card that could go in the same slot).  Usually
>> there is an EEPROM of some sort at a well-known address that can be parsed to
>> identify which kind of riser card it is and then the appropriate sub-devices can
>> be enumerated.  That EEPROM parsing is something that is currently done in
>> userspace due to the complexity and often vendor-specific nature of it.
>>
>> Many of these devices require quite a bit more configuration information than
>> can be passed along a `bind` call.  I believe it has been suggested previously
>> that this riser-card scenario could also be solved with dynamic loading of DT
>> snippets, but that support seems simple pretty far from being merged.
> 
> Then work to get the DT code merged!  Do not try to create
> yet-another-way of doing things here if DT overlays is the correct
> solution here (and it seems like it is.)

I don't think this is a case that fits the overlay model.

We know what the description of the device is (which is what devicetree
is all about), but the device is to be shared between the Linux kernel
and some other entity, such as the firmware or another OS.  The issue
to be resolved is how to describe that the device is to be shared (in
this case exclusively by the kernel _or_ by the other entity at any
given moment), and how to move ownership of the device between the
Linux kernel and the other entity.

In the scenario presented by Zev, it is suggested that a user space
agent will be involved in deciding which entity owns the device and
to tell the Linux kernel when to take ownership of the device (and
presumably when to relinquish ownership, although we haven't seen
the implementation of relinquishing ownership yet).  One could
imagine direct communication between the driver and the other
entity to mediate ownership.  That seems like a driver specific
defined choice to me, though if there are enough different drivers
facing this situation then eventually a shared framework would
make sense.

So to step back and think architecture, it seems to me that the
devicetree needs to specify in the node describing the shared
device that the device must be (1) owned exclusively by either
the Linux kernel or some other entity, with a signalling method
between the Linux kernel and the other entity being defined
(possibly by information in the node or possibly by the definition
of the driver) or (2) actively shared by both the Linux
kernel and the other entity.  Actively shared may or may not be
possible, based on the specific hardware.  For example, if a single
contains some bits controlled by the Linux kernel and other bits
controlled by the other entity, then it can be difficult for one
of the two entities to atomically modify the register in coordination
with the other entity.  Obviously case 1 is much simpler than case 2,
I'm just trying to create a picture of the potential cases.  In a
simpler version of case 2, each entity would have control of their
own set of registers.

Diverging away from the overlay question, to comment on the
"status" property mentioned elsewhere in this thread, I do not
think that a status value of "reserved" is an adequate method
of conveying all of the information needed by the above range
of scenarios.

-Frank

> 
> thanks,
> 
> greg k-h
> 

