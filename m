Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9647132492
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2019 20:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfFBSis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Jun 2019 14:38:48 -0400
Received: from ahs5.r4l.com ([158.69.52.156]:52668 "EHLO ahs5.r4l.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbfFBSis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Jun 2019 14:38:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=extremeground.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:References:To:Subject:From:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=glXmhaL92oSB2arryjVOx7d7czNc7W+pqAt7Tko2urQ=; b=J/jCSTKjKsmqW4JYO89c5JbuJR
        5ixC5/pOQmFSBYFysbI+Js6wA5FuJePV5nrwhczo+K3HFUMovyO/B9S7ezivq6zCqCsanpOKS0/Vd
        H2cuf3iNPeUHgn/s+K2a036TOgk5eEHTij4vrmACyAB+4UDHQkoQ3YKdqzKrfsF6JjRY6SuhN1lUU
        LWZFMrnoi8VmMSoknLNOLotaJP+77tQR1FlzkvM4AgPeCRuFmAVnyQusKVJib6MzjsBZimJFqzmkf
        J4qQnxJXW+tMNhFfSYdPXn4GnfAOpCbXoQVr1IPFquc3qjDDl0q2GATLPK7y9mo36bCNhqTaR3Waw
        jbny0rGA==;
Received: from cpeac202ed5e073-cmac202ed5e070.cpe.net.cable.rogers.com ([99.237.87.227]:53820 helo=[192.168.1.20])
        by ahs5.r4l.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <gary@extremeground.com>)
        id 1hXVNW-00029W-1A
        for kvm@vger.kernel.org; Sun, 02 Jun 2019 14:38:46 -0400
From:   Gary Dale <gary@extremeground.com>
Subject: Re: Windows 7 VM CPU core count
To:     kvm@vger.kernel.org
References: <b338a718-28b9-98b9-7560-04c8edbde65e@extremeground.com>
 <EA057763-BC27-4E94-96A1-8846B34EDE0E@redhat.com>
Message-ID: <d961d6b4-7a2a-b41e-9e6a-5f3208e83f10@extremeground.com>
Date:   Sun, 2 Jun 2019 14:38:46 -0400
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

I checked with a Windows 7 VM set up from scratch and you seem to be 
correct. A quick check suggests that Windows 10 has the same limitation.

My real problem was that I needed to manually configure the topology to 
set the CPU count, cores and threads. Unfortunately the version of KVM I 
am using (Debian/Stretch) doesn't recognize the Ryzen processor so I 
seem to be limited to one thread per core. Presumably that will be fixed 
in Debian/Buster.

Thanks for your help!


