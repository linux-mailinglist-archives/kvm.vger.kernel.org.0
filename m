Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4397F151CE
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 18:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfEFQmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 12:42:07 -0400
Received: from 6.mo5.mail-out.ovh.net ([178.32.119.138]:43271 "EHLO
        6.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfEFQmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 May 2019 12:42:07 -0400
X-Greylist: delayed 1863 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 May 2019 12:42:06 EDT
Received: from player687.ha.ovh.net (unknown [10.109.143.72])
        by mo5.mail-out.ovh.net (Postfix) with ESMTP id BF9CA22B38A
        for <kvm@vger.kernel.org>; Mon,  6 May 2019 18:22:07 +0200 (CEST)
Received: from kaod.org (lfbn-1-10649-41.w90-89.abo.wanadoo.fr [90.89.235.41])
        (Authenticated sender: clg@kaod.org)
        by player687.ha.ovh.net (Postfix) with ESMTPSA id 3D92356E2917;
        Mon,  6 May 2019 16:21:59 +0000 (UTC)
Subject: Re: [PATCH v5 00/16] KVM: PPC: Book3S HV: add XIVE native
 exploitation mode
To:     Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>
References: <20190410170448.3923-1-clg@kaod.org>
 <20190429080506.GA9070@sathnaga86.in.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <827f230f-1b56-db89-be21-1b2dbd44ef08@kaod.org>
Date:   Mon, 6 May 2019 18:21:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190429080506.GA9070@sathnaga86.in.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 6858700759159049190
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrjeekgddtvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Satheesh,

On 4/29/19 10:05 AM, Satheesh Rajendran wrote:
> On Wed, Apr 10, 2019 at 07:04:32PM +0200, Cédric Le Goater wrote:
>> Hello,
>>
>> GitHub trees available here :
>>
>> QEMU sPAPR:
>>
>>   https://github.com/legoater/qemu/commits/xive-next
>>   
>> Linux/KVM:
>>
>>   https://github.com/legoater/linux/commits/xive-5.1
> 
> Hi,
> 
> Xive(both ic-mode=dual and ic-mode=xive) guest fails to boot with 
> guest memory > 64G, till 64G it boots fine.
>
> Note: xics(ic-mode=xics) guest with the same configuration boots fine

Indeed. The guest hangs because IPIs are not correctly received. The guest 
sees the EQ page as being filled with zeroes and discards the interrupt 
whereas the host, KVM and QEMU, sees the correct entries.

I haven't spotted anything bizarre from guest side. Do we have a 64GB 
frontier somewhere in KVM ? 

Thanks,

C.   
