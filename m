Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2476166A8A
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 23:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbgBTWuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 17:50:14 -0500
Received: from cp80.sp-server.net ([195.30.85.80]:47821 "EHLO
        cp80.sp-server.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729150AbgBTWuO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 17:50:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=ziegi.de;
         s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version
        :Date:Message-ID:References:To:From:Subject:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Z5fO4TIbzBCDHkkoCsh7VYAFfx9xGbyscvH9NMTC4hA=; b=l6Ok4qWRNaXHaAMhKNsillJFIO
        pc0rvf6k17GJ6EDTAdGQ7KFqMNgRBm4aSB7eoFLSl+ybH4ceO1UrMvN/UPAgNUj/1qHRdwLX0qf3u
        oeo3S2exUwEcpmyWZNmUY8dMP1JPJ4Hd1GdkO6KlUE68/D25x+ptAtYjUo09u/REq/Z3i8J9Yy9KS
        xWnoyIFEhzS2RQV0Kwd1ebz5fNG93IaOf3zHiuFwXNbzjBbvSLbxofnOif/AGoZVhAEbwiE/uYS5+
        TIU+ZIBDrSQmeZa6h1qvV0ZhgZn92P/85bv/LOR0wsELNoVLEA6vgARpMXwJcczkBXLcdvLm36BMZ
        +R6uo8+Q==;
Received: from [213.147.165.110] (port=2846 helo=[192.168.43.146])
        by cp80.sp-server.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <info@ziegi.de>)
        id 1j4ue2-00030c-Or
        for kvm@vger.kernel.org; Thu, 20 Feb 2020 23:50:10 +0100
Subject: Re: strange segfaults in guest using usb stick wlan on the host
From:   Torsten Ziegler <info@ziegi.de>
To:     kvm@vger.kernel.org
References: <a3abe5ff-b1ce-16b9-768b-fb49993622dc@ziegi.de>
Message-ID: <84df7533-7b15-144c-fc50-38a46e1edc0f@ziegi.de>
Date:   Thu, 20 Feb 2020 23:50:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <a3abe5ff-b1ce-16b9-768b-fb49993622dc@ziegi.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: de-DE
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cp80.sp-server.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - ziegi.de
X-Get-Message-Sender-Via: cp80.sp-server.net: authenticated_id: info@ziegi.de
X-Authenticated-Sender: cp80.sp-server.net: info@ziegi.de
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Devs,

i was able to trace two of the segfaults
with the trace-cmd as describes on the KVM bug reporting website.

As I can not attach those big files here are the links to the files:

https://share.ziegi.de/compile_switch_wlan_on_segfault-1.txt.gz
https://share.ziegi.de/compile_switch_wlan_on_segfault-2.txt.gz

It would be great if someone could give me a feedback
on this, or direct me to where to post my question if this is not the right
place for it.

Thanks,
Torsten

Am 18.02.20 um 22:47 schrieb Torsten Ziegler:
> Dear KVM Developers,
>
> i have a strange problem with segfaults in a guest system
> while compiling a linux kernel.
>
> The basic setup (details below) is a ryzen cpu on a ab350 mainboard,
> the host running ubuntu linux and guests running also debian based
> linux.
> Now i am compiling a vanilla linux kernel in the guest.
> This will fail with random segfaults as soon as i enable a WLAN (USB
> RTL8187L) connection in
> the host system.
> Apart from this everything is working fine.
> As this WLAN is my default internet connection i did try different
> virtualization setups
> for almost a week until I could track down the problem.
>
>
> The details:
> CPU: Ryzen 7 2700X
> same result using a Ryzen 5 1600
>
> Mainboard: GA-AB350M-Gaming 3
> Bios: i tested with three versions:  F31, F41d, F50a
>
> host system:
> i tested with the following systems as host all x86_64
> ubuntu 19.10 kernel 5.3.0-26-generic
> ubuntu 19.10 kernel 5.3.0-29-generic
> ubuntu 20(development) kernel 5.4.0-14-generic
>
> kvm:
> 4.0 (ubutu 19.10) and 4.2.0 (ubuntu 19.10 installed from sources)
> 4.2.0 (ubuntu 20 dev)
>
> guest:
> ubuntu 18.10 kernel 4.18.0-10-generic
> debian 10 kernel 5.4.0-3-amd64
>
> I use libvirt to launch the guests, so two example XML files are attached,
> also the hypervisor info.
> I tried a lot of different settings for cpu type and and cpu pinning
> without much
> difference.
>
> task:
> Compile linux kernel on guest using debian linuc sources 5.4.8 or
> vanilla 5.5.2
>
> This works fine as long as I do not enable my WLAN internet connection
> on the host (USB stick: NetGear, Inc. WG111v2 54 Mbps Wireless [RealTek
> RTL8187L])
>
> If I enable the WLAN (in the host) the guest starts producing random
> compiler errors like these;
>
> ./include/linux/mm.h:2041:1: internal compiler error: Segmentation fault 
> static inline spinlock_t *pud_lockptr(struct mm_struct *mm, pud_t *pud)                                                                        
> ^~~~~~
>
> ./include/linux/quota.h:338:1: internal compiler error: in tree_to_uhwi, at tree.h:4278
>  };
>  ^
> ./arch/x86/include/asm/pgtable.h:163:1: internal compiler error: Segmentation fault
>  {
>  ^
> elf.c:685:1: internal compiler error: Segmentation fault
>  }
>  ^
>
> As soon as I disable the USB WLAN connection on the host (the USB stick
> still
> inserted) I can compile the kernels without any problem.
>
> No valuable messages in the log files of the host and the guest system.
>
> So I tested removing all Network Interfaces from the guest systems,
> but this had no effect. Even without any networking a guest fails
> compiling as soon as I
> start the WLAN on the host system.
>
> I checked for electrical interference by
> - using a long USB cable to get the WLAN stick away from the PC ->
> compilation fails
> - using a laptop operating the USB WLAN stick right beside the PC ->
> compilation works fine
>
> I intensely tested the hosts RAM with memtest86+
> stressed the host system with compile jobs,
> even did memtests on the guests.
> But everythings seems rock solid.
>
> Does anyone have a clue, whats going on here,
> or how i can debug this situation ?
>
> Thanks,
> Torsten
>
