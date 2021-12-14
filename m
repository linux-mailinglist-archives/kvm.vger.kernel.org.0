Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2318473EFC
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 10:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbhLNJKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 04:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbhLNJKC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 04:10:02 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57906C061574
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 01:10:02 -0800 (PST)
Received: from ip4d173d4a.dynamic.kabel-deutschland.de ([77.23.61.74] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1mx3ou-000566-DO; Tue, 14 Dec 2021 10:10:00 +0100
Message-ID: <7ac766c2-eb7b-3d4b-8c9f-40e9a7d3609e@leemhuis.info>
Date:   Tue, 14 Dec 2021 10:10:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [Bug 215317] New: Unable to launch QEMU Linux guest VM - "Guest
 has not initialized the display (yet)"
Content-Language: en-BS
To:     bugzilla-daemon@bugzilla.kernel.org, kvm@vger.kernel.org,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <bug-215317-28872@https.bugzilla.kernel.org/>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <bug-215317-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1639473002;68844e1f;
X-HE-SMSGID: 1mx3ou-000566-DO
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, this is your Linux kernel regression tracker speaking.

[TLDR: adding this regression to regzbot; most of this mail is compiled
from a few templates paragraphs some of you might have seen already.]

On 13.12.21 02:38, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=215317
> [...]
> Something changed between kernel 5.16.0-rc3 and -rc4, and remains unfixed
> between -rc4 and -rc5. Attempting to start a QEMU VM, the display is stuck at
> "Guest has not initialized the display (yet)". The QEMU version I'm trying is
> 6.2.0-rc4, but QEMU version 6.1.0 has also been tried. I noticed many changes
> in the KVM code between Linux 5.16.0-rc3 and 5.16.0-rc4, and I apologize for
> not being able to narrow it down.

Thanks for the report.

Adding the regression mailing list to the list of recipients, as it
should be in the loop for all regressions, as explained here:
https://www.kernel.org/doc/html/latest/admin-guide/reporting-issues.html

To be sure this issue doesn't fall through the cracks unnoticed, I'm
adding it to regzbot, my Linux kernel regression tracking bot:

#regzbot ^introduced v5.16-rc3..v5.16-rc4
#regzbot title Unable to launch QEMU Linux guest VM - "Guest has not
initialized the display (yet)"
#regzbot ignore-activity
#regzbot link: https://bugzilla.kernel.org/show_bug.cgi?id=215317

Reminder: when fixing the issue, please add a 'Link:' tag with the URL
to the report (the parent of this mail), then regzbot will automatically
mark the regression as resolved once the fix lands in the appropriate
tree. For more details about regzbot see footer.

Sending this to everyone that got the initial report, to make all aware
of the tracking. I also hope that messages like this motivate people to
directly get at least the regression mailing list and ideally even
regzbot involved when dealing with regressions, as messages like this
wouldn't be needed then.

Don't worry, I'll send further messages wrt to this regression just to
the lists (with a tag in the subject so people can filter them away), as
long as they are intended just for regzbot. With a bit of luck no such
messages will be needed anyway.

Ciao, Thorsten (wearing his 'Linux kernel regression tracker' hat).

P.S.: As a Linux kernel regression tracker I'm getting a lot of reports
on my table. I can only look briefly into most of them. Unfortunately
therefore I sometimes will get things wrong or miss something important.
I hope that's not the case here; if you think it is, don't hesitate to
tell me about it in a public reply. That's in everyone's interest, as
what I wrote above might be misleading to everyone reading this; any
suggestion I gave thus might sent someone reading this down the wrong
rabbit hole, which none of us wants.

BTW, I have no personal interest in this issue, which is tracked using
regzbot, my Linux kernel regression tracking bot
(https://linux-regtracking.leemhuis.info/regzbot/). I'm only posting
this mail to get things rolling again and hence don't need to be CC on
all further activities wrt to this regression.
