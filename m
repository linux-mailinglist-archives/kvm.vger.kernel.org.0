Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A69E1C6C29
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 10:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgEFIqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 04:46:24 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:44582 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728511AbgEFIqX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 04:46:23 -0400
Received: from mxbackcorp1o.mail.yandex.net (mxbackcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::301])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id CF01F2E14AC;
        Wed,  6 May 2020 11:46:20 +0300 (MSK)
Received: from myt5-70c90f7d6d7d.qloud-c.yandex.net (myt5-70c90f7d6d7d.qloud-c.yandex.net [2a02:6b8:c12:3e2c:0:640:70c9:f7d])
        by mxbackcorp1o.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id 8lWMk1HLlf-kGb8PuG7;
        Wed, 06 May 2020 11:46:20 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1588754780; bh=tzipwafqwMZKcvDRA5wYvzE0sK16bTgRO8O/S+yW0cg=;
        h=In-Reply-To:Message-ID:Subject:To:From:References:Date:Cc;
        b=grlUZ1Uq7wY0xGJFbdO9mpus4qCf4hY98vTc8rTJc+TPBalL9J/HkfQ1wlsAjzi3m
         vN+XSBB+OaF9rtlSbnXIFJgjSvXSHP9lAt2GbR/ZxDvwypn8tFF+WrE0mql6tP9u88
         IKtnuVtXjTdNG2Dr0o1ZYuEfpfwvpG220dMDRTbw=
Authentication-Results: mxbackcorp1o.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-vpn.dhcp.yndx.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b080:6907::1:5])
        by myt5-70c90f7d6d7d.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 2GB9My1rM5-kGWSs5Qw;
        Wed, 06 May 2020 11:46:16 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Date:   Wed, 6 May 2020 11:46:15 +0300
From:   Roman Kagan <rvkagan@yandex-team.ru>
To:     Jon Doron <arilou@gmail.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v2 0/1] x86/kvm/hyper-v: Add support to SYNIC exit on EOM
Message-ID: <20200506084615.GA32841@rvkaganb>
Mail-Followup-To: Roman Kagan <rvkagan@yandex-team.ru>,
        Jon Doron <arilou@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org
References: <20200417104251.GA3009@rvkaganb>
 <20200418064127.GB1917435@jondnuc>
 <20200424133742.GA2439920@rvkaganb>
 <20200425061637.GF1917435@jondnuc>
 <20200503191900.GA389956@rvkaganb>
 <87a72nelup.fsf@vitty.brq.redhat.com>
 <20200505080158.GA400685@rvkaganb>
 <20200505103821.GB2862@jondnuc>
 <20200505200010.GB400685@rvkaganb>
 <20200506044929.GD2862@jondnuc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506044929.GD2862@jondnuc>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 06, 2020 at 07:49:29AM +0300, Jon Doron wrote:
> Thanks Roman, I see your point, it's important for me to get the EDK2
> working properly not sure why it's not working for me.

As I wrote a good deal of that code I hope I should be able to help (and
I'd be interested, too).  How exactly does the "not working" look like?

Also I'm a bit confused as to why UEFI is critical for the work you're
doing?  Can't it be made to work with BIOS first?

> Do you know by any chance if the EDK2 hyperv patches were submitted and if
> they were why they were not merged in?

I do, as I'm probably the only one who could have submitted them :)

No they were not submitted.  Neither were the ones for SeaBIOS nor iPXE.
The reason was that I had found no way to use alternative firmware with
HyperV, so the only environment where that would be useful and testable
was QEMU with VMBus.  Therefore I thought it made no sense to submit
them until VMBus landed in QEMU.

Thanks,
Roman.
