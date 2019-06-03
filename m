Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 879FB3282A
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 07:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfFCFxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 01:53:45 -0400
Received: from 5.mo69.mail-out.ovh.net ([46.105.43.105]:56043 "EHLO
        5.mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbfFCFxo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 01:53:44 -0400
Received: from player693.ha.ovh.net (unknown [10.108.57.226])
        by mo69.mail-out.ovh.net (Postfix) with ESMTP id 6DF025BFCC
        for <kvm@vger.kernel.org>; Mon,  3 Jun 2019 07:53:42 +0200 (CEST)
Received: from kaod.org (lfbn-1-10649-41.w90-89.abo.wanadoo.fr [90.89.235.41])
        (Authenticated sender: clg@kaod.org)
        by player693.ha.ovh.net (Postfix) with ESMTPSA id E4B4C65F84AB;
        Mon,  3 Jun 2019 05:53:35 +0000 (UTC)
Subject: Re: [PATCH] KVM: PPC: Book3S HV: XIVE: introduce a KVM device lock
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
References: <20190524132030.6349-1-clg@kaod.org>
 <20190531063543.GD26651@blackberry>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <76b15b5f-c8cf-04ee-a00a-064c97c762fe@kaod.org>
Date:   Mon, 3 Jun 2019 07:53:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190531063543.GD26651@blackberry>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 13107163766988639191
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrudefiedguddttdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/05/2019 08:35, Paul Mackerras wrote:
> On Fri, May 24, 2019 at 03:20:30PM +0200, Cédric Le Goater wrote:
>> The XICS-on-XIVE KVM device needs to allocate XIVE event queues when a
>> priority is used by the OS. This is referred as EQ provisioning and it
>> is done under the hood when :
>>
>>   1. a CPU is hot-plugged in the VM
>>   2. the "set-xive" is called at VM startup
>>   3. sources are restored at VM restore
>>
>> The kvm->lock mutex is used to protect the different XIVE structures
>> being modified but in some contextes, kvm->lock is taken under the
>> vcpu->mutex which is a forbidden sequence by KVM.
>>
>> Introduce a new mutex 'lock' for the KVM devices for them to
>> synchronize accesses to the XIVE device structures.
>>
>> Signed-off-by: Cédric Le Goater <clg@kaod.org>
> 
> Thanks, patch applied to my kvm-ppc-fixes branch (with the headline
> "KVM: PPC: Book3S HV: XIVE: Introduce a new mutex for the XIVE
> device").

Yes. That's a better tittle. Thanks for doing so.

C.
