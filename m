Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2118ED33
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 01:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbfD2XOI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 19:14:08 -0400
Received: from ip27.imatronix.com ([200.63.97.108]:56510 "EHLO
        cpanel.imatronix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729661AbfD2XOI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Apr 2019 19:14:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=imatronix.cl; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:Subject:From:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=68m7uT0bHosMUfaa1X4LgSKvrOkaYFrivyDHYBkavc4=; b=UF+cCNLhfl7bwjq3/OTfzbcjmX
        y0RvE39BR00Ln7RBBsfgHPdNbExKemT60ct7AWuZx+iUn2NvkyMx4D9/+AHBW3K8nKjGyKoPVXBJ4
        /5LpNQA2QUw4gCr2zDa1VPi6escw95+s/QNBuIQoaQL2+nK4dSYkOeKd/qdDkNFpq7a9eejn04peP
        R49F5JBvWuiRywkOhf5uH2s3Zt4RgeaIM1E1a0WJzg76LvZTm+SuLrYQH4qsZei5wCtATvKWat3tl
        hPNsb98dqbWb0lvinIOjPA7bvcJaiU3oDmX0kJpaJSG+9+kCS7qanEdCwkdCWepEb4dvkdD+xLxdS
        ahz09XBg==;
Received:    from [200.73.112.45]
           by cpanel.imatronix.com    with esmtpsa    (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
           (Exim 4.91)
           (envelope-from <kripper@imatronix.cl>)
           id 1hLFTG-0000Ig-89   ; Mon, 29 Apr 2019 19:14:02 -0400
From:   Christopher Pereira <kripper@imatronix.cl>
Subject: Re: "BUG: soft lockup" and frozen guest
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
References: <1798334f-3083-bb4d-410c-849dc306e6b2@imatronix.cl>
 <87muk958jn.fsf@vitty.brq.redhat.com>
Organization: IMATRONIX S.A.
Message-ID: <ba7deff9-6a29-9514-642f-99b3f7cd8fe1@imatronix.cl>
Date:   Mon, 29 Apr 2019 19:14:05 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <87muk958jn.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: de-DE
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel.imatronix.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - imatronix.cl
X-Get-Message-Sender-Via: cpanel.imatronix.com: authenticated_id: kripper@imatronix.cl
X-Authenticated-Sender: cpanel.imatronix.com: kripper@imatronix.cl
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On April 29, 2019 7:56:44 AM AST, Vitaly Kuznetsov <vkuznets@redhat.com> 
wrote:

    Christopher Pereira <kripper@imatronix.cl> writes:

        Hi, I have been experiencing some random guest crashes in the
        last years and would like to invest some time in trying to debug
        them with your help. Symptom is: 1) "BUG: soft lockup" & "CPU#*
        stuck for *s!" messages during high load on the guest 2) At some
        point later (eg. 12 hours later), the guest just hangs without
        any message and must be destroyed / rebooted. I attached the
        relevant kernel messages. Host (spec: Intel(R) Xeon(R) CPU
        E5645) is running: kernel-3.10.0-327.el7.x86_64
        libvirt-daemon-kvm-1.2.17-13.el7_2.5.x86_64
        qemu-kvm-ev-2.3.0-31.el7_2.10.1.x86_64
        qemu-kvm-common-ev-2.3.0-31.el7_2.10.1.x86_64 


    This is pretty old stuff, e.g. kernel-3.10.0-327.el7 was release with
    RHEL-7.2 (Nov 2015). As this is upstream mailing list, it would be great
    if you could build an upstream kernel (should work with EL7 userspace)
    and try to reproduce.

Hi Vitaly,

Yes, but it's a critical production environment and I haven't seen any 
related patch in the kernel changelog since 3.10. We will try to upgrade 
whenever possible.

I believe this bug could be related to overcommitting resources. Does 
qemu-kvm throw any log message when resources are overcommited? Is there 
some way to enable this?

We have seen this happening one in a while in the last 4 years on 
different production hardware and wanted to ask if this is a common 
issue and how to address/debug this issue.

Best regards.

