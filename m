Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC74C2212CD
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 18:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgGOQo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 12:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbgGOQox (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 12:44:53 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8082C061755
        for <kvm@vger.kernel.org>; Wed, 15 Jul 2020 09:44:52 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id b6so3372373wrs.11
        for <kvm@vger.kernel.org>; Wed, 15 Jul 2020 09:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=scY49mbUNKHZrdbIfXTfGUb/BOXGOeiwdsMsfe7K8d0=;
        b=aQOagnfzn71psy5waK0/DWZOqsCBjOWbQuoEkV7AeBmaMomR6qyvxhHNDeyBUACad8
         tqygAJN5Qtl8z9xToOvRD7cL91pYyKJuXpdb270/TQ0Ycy0ifbnFk5+aYoJV74o7gUac
         RtWEuncBdvm+saUi4dQWlIGVeWLK4mSYZmnZ7VMooOuEOpbkvBXJ2OnYsFo4oM9wWK/d
         1HcLC+C4xbGcsqizCj5RbXY8IPJm8g4FS+mo5Hk9OTgWar4akTGyVGXBTdyjn7/XmWbY
         c+9qRMoCO4tFBdmxVAhD7/E1nBLTH/JEw7+8TllH1cHUia71PHpz46Zo+djuMP1SF5Y0
         J/1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=scY49mbUNKHZrdbIfXTfGUb/BOXGOeiwdsMsfe7K8d0=;
        b=UY9o8rWLinPMlDhfMzd5fdXk6Udy72xQa7S8xlxvE0wJu7ElUTbuk90cMTwXi7D2jE
         Rt2HvX10WRX+/oU2GrHnxadbfTEwayrmEfIvT6dLeJcEL3s7wvb3nNVdx/hghrFje7L2
         paZKfIOetx029wgV5gNlJBrsQTZFbeURqtrj4NOIvQhNk0hwzv2p2AxJTAguzUKTHy+3
         l49ielbe/ltTkTcvdYmnrdiU6r+qVtKPtjVK9A96q7f54h8+G3SlEJM4r7sf2bQJ6d+9
         nwFzOOHQYYkVJmn0AFIY0vPR+lMZqaLBA4v9LZ7ugraMp2f9Y6FQGeAiA7rw2e5lrVbG
         6apg==
X-Gm-Message-State: AOAM5305VQBtITq6XuoAum43C7i3dmNvLNvtg/QeK7sESzZ/YzpRK5DO
        OQ6lsb+PxAszOs4Y3GyhFHLomQ==
X-Google-Smtp-Source: ABdhPJxqCJAxO1Z/aM4Dkpxpe268YRDuzB0oQUo2Ktlydz81nlJFEhIipTm9uoq3YPYJU6WlyBbHNg==
X-Received: by 2002:adf:f889:: with SMTP id u9mr259344wrp.149.1594831491338;
        Wed, 15 Jul 2020 09:44:51 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id m4sm3991733wmi.48.2020.07.15.09.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 09:44:50 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 0BBF61FF7E;
        Wed, 15 Jul 2020 17:44:49 +0100 (BST)
References: <86d42090-f042-06a1-efba-d46d449df280@arrikto.com>
 <20200715112342.GD18817@stefanha-x1.localdomain>
 <deb5788e-c828-6996-025d-333cf2bca7ab@siemens.com>
 <20200715153855.GA47883@stefanha-x1.localdomain>
User-agent: mu4e 1.5.4; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Nikos Dragazis <ndragazis@arrikto.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        "John G. Johnson" <john.g.johnson@oracle.com>,
        Andra-Irina Paraschiv <andraprs@amazon.com>,
        Alexander Graf <graf@amazon.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Maxime Coquelin <maxime.coquelin@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: Inter-VM device emulation (call on Mon 20th July 2020)
In-reply-to: <20200715153855.GA47883@stefanha-x1.localdomain>
Date:   Wed, 15 Jul 2020 17:44:49 +0100
Message-ID: <87y2nkwwvy.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Stefan Hajnoczi <stefanha@redhat.com> writes:

> On Wed, Jul 15, 2020 at 01:28:07PM +0200, Jan Kiszka wrote:
>> On 15.07.20 13:23, Stefan Hajnoczi wrote:
>> > Let's have a call to figure out:
>> >=20
>> > 1. What is unique about these approaches and how do they overlap?
>> > 2. Can we focus development and code review efforts to get something
>> >    merged sooner?
>> >=20
>> > Jan and Nikos: do you have time to join on Monday, 20th of July at 15:=
00
>> > UTC?
>> > https://www.timeanddate.com/worldclock/fixedtime.html?iso=3D20200720T1=
500
>> >=20
>>=20
>> Not at that slot, but one hour earlier or later would work for me (so fa=
r).
>
> Nikos: Please let us know which of Jan's timeslots works best for you.

I'm in - the earlier slot would be preferential for me to avoid clashing wi=
th
family time.

--=20
Alex Benn=C3=A9e
