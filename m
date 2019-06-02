Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B936324A1
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2019 21:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfFBTTj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Jun 2019 15:19:39 -0400
Received: from ahs5.r4l.com ([158.69.52.156]:44603 "EHLO ahs5.r4l.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbfFBTTj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Jun 2019 15:19:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=extremeground.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:References:To:Subject:From:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=einUaDVW6dPnJ7mag7X5Esj5XQiIHdB1nDhZlFtYq6o=; b=mZouBK2H56+xVaFVl16dumBuro
        AYMzqz2KvwkekFEob76wyE9oH3cvC0PmsIz0tehTob+5FcoJH2P7dM7oVYTAD0a43GISvqT7afay5
        90Yszwbf+zGbh+CilWMFsupvyPkNDeRtLGnOFw0omQkftBJ0ecFoXcN1SqSZOSBeFuRi8WEhkm1VU
        oBvwat+1Cj7IRI9Yq6MGnEa0/A0JWigm2+UBwJaIIgdY4436yFBDMT1WXMr2vv3aU5JAnsrVFjjy3
        wfSEDZ2oOAIZDYG3qVMzU+qPh706t0T5YQ74+t4feM1txKRnIWcHrPCGus+fBcSnIS8p/lGito6YQ
        wsXWfJFQ==;
Received: from cpeac202ed5e073-cmac202ed5e070.cpe.net.cable.rogers.com ([99.237.87.227]:56012 helo=[192.168.1.20])
        by ahs5.r4l.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <gary@extremeground.com>)
        id 1hXW13-0000Wt-18
        for kvm@vger.kernel.org; Sun, 02 Jun 2019 15:19:37 -0400
From:   Gary Dale <gary@extremeground.com>
Subject: Re: Windows 7 VM CPU core count
To:     kvm@vger.kernel.org
References: <b338a718-28b9-98b9-7560-04c8edbde65e@extremeground.com>
 <EA057763-BC27-4E94-96A1-8846B34EDE0E@redhat.com>
Message-ID: <be64d75c-3458-8fb0-1945-32061d0bec40@extremeground.com>
Date:   Sun, 2 Jun 2019 15:19:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <EA057763-BC27-4E94-96A1-8846B34EDE0E@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
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

Now I seem to have a worse problem. When I set the number of sockets to 
1 and specify, for example, 4 cores and 1 thread per core, Windows 7 
appears to see just a single-core processor.

I noticed something else too. KVM also doesn't have a CPU listing for 
the AMD FX series of processors which were definitely around well before 
Debian/Stretch. However my host with an FX processor shows up as an 
Opteron G4 while the Ryzen shows up as an Opteron G3.


----------------------

I checked with a Windows 7 VM set up from scratch and you seem to be 
correct. A quick check suggests that Windows 10 has the same limitation.


My real problem was that I needed to manually configure the topology to 
set the CPU count, cores and threads. Unfortunately the version of KVM I 
am using (Debian/Stretch) doesn't recognize the Ryzen processor so I 
seem to be limited to one thread per core. Presumably that will be fixed 
in Debian/Buster.

Thanks for your help!



