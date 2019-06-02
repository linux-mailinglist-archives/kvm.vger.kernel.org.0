Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF671321AC
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2019 05:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfFBDPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jun 2019 23:15:43 -0400
Received: from ahs5.r4l.com ([158.69.52.156]:40538 "EHLO ahs5.r4l.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbfFBDPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jun 2019 23:15:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=extremeground.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:Subject:From:To:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IC47J/PJDVNSFTo1N8gRVr6VWUlLjcmjhhUuYJ93cvI=; b=SqMu/U9Kv7OLuzrD8NE1tdJ3mw
        x7cCnytmdl3CRdBDVUh/3v3BkMTaUPr1S5uOwWobajARsUx7Q3i9APwVJLDNCtwe+87n8BsBzEpYS
        QrczjwnKNB4h/4yVSR806ZLQI8Eo5Ucg1Wqf+drOXN9zxktxV97crNTNmdXw/r+MpcsCM/oXrMCyu
        slpWkFipyuuzTTMKDxUalJeQIatJfhqXXzAd/o0XQ7fOO/Y8OozxgLCcU4A9UhyXINPydBSZsqE0y
        4fOl21901cxiWpaIMb4eKGGYnyuOX0bHZwfifeqbiYG9dKQyM2c+JffwmXigGDsJesCNT6BPoLfcj
        +H2APgQg==;
Received: from cpeac202ed5e073-cmac202ed5e070.cpe.net.cable.rogers.com ([99.237.87.227]:53626 helo=[192.168.1.20])
        by ahs5.r4l.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <gary@extremeground.com>)
        id 1hXGyE-0003UD-JC
        for kvm@vger.kernel.org; Sat, 01 Jun 2019 23:15:42 -0400
To:     kvm@vger.kernel.org
From:   Gary Dale <gary@extremeground.com>
Subject: Windows 7 VM CPU core count
Message-ID: <b338a718-28b9-98b9-7560-04c8edbde65e@extremeground.com>
Date:   Sat, 1 Jun 2019 23:15:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-CA
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ahs5.r4l.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - extremeground.com
X-Get-Message-Sender-Via: ahs5.r4l.com: authenticated_id: gary@extremeground.com
X-Authenticated-Sender: ahs5.r4l.com: gary@extremeground.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I noticed on the KVM documentation wiki on supported OSs (which they 
note is out of date) that Windows 7 Pro is listed as only supporting 2 
CPUs (see https://www.linux-kvm.org/page/Guest_Support_Status).

I have a VM with 16G of RAM (the documention mentions on 2G) but I'm not 
able to get it to use more than 2 cores/threads.  I suspect that this 
has to do with it being a disk copy from an actual machine that had only 
2 cores, but can someone please verify that qemu-kvm can actually 
support more cores in Windows 7 Pro?

