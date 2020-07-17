Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3162237C0
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 11:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgGQJFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 05:05:33 -0400
Received: from mx0.arrikto.com ([212.71.252.59]:57316 "EHLO mx0.arrikto.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbgGQJFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 05:05:32 -0400
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Jul 2020 05:05:32 EDT
Received: from troi.prod.arr (mail.arr [10.99.0.5])
        by mx0.arrikto.com (Postfix) with ESMTP id 8E3F819E0B0;
        Fri, 17 Jul 2020 11:58:41 +0300 (EEST)
Received: from [10.89.50.23] (naxos.vpn.arr [10.89.50.23])
        by troi.prod.arr (Postfix) with ESMTPSA id 2C1552AD;
        Fri, 17 Jul 2020 11:58:41 +0300 (EEST)
Subject: Re: Inter-VM device emulation (call on Mon 20th July 2020)
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     "John G. Johnson" <john.g.johnson@oracle.com>,
        Andra-Irina Paraschiv <andraprs@amazon.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, qemu-devel@nongnu.org,
        Maxime Coquelin <maxime.coquelin@redhat.com>,
        Alexander Graf <graf@amazon.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>
References: <86d42090-f042-06a1-efba-d46d449df280@arrikto.com>
 <20200715112342.GD18817@stefanha-x1.localdomain>
 <deb5788e-c828-6996-025d-333cf2bca7ab@siemens.com>
 <20200715153855.GA47883@stefanha-x1.localdomain> <87y2nkwwvy.fsf@linaro.org>
From:   Nikos Dragazis <ndragazis@arrikto.com>
Message-ID: <b3efd773-c07e-8095-c1ca-5ffb894ac2ac@arrikto.com>
Date:   Fri, 17 Jul 2020 11:58:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87y2nkwwvy.fsf@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/7/20 7:44 μ.μ., Alex Bennée wrote:

> Stefan Hajnoczi <stefanha@redhat.com> writes:
>
>> On Wed, Jul 15, 2020 at 01:28:07PM +0200, Jan Kiszka wrote:
>>> On 15.07.20 13:23, Stefan Hajnoczi wrote:
>>>> Let's have a call to figure out:
>>>>
>>>> 1. What is unique about these approaches and how do they overlap?
>>>> 2. Can we focus development and code review efforts to get something
>>>>     merged sooner?
>>>>
>>>> Jan and Nikos: do you have time to join on Monday, 20th of July at 15:00
>>>> UTC?
>>>> https://www.timeanddate.com/worldclock/fixedtime.html?iso=20200720T1500
>>>>
>>> Not at that slot, but one hour earlier or later would work for me (so far).
>> Nikos: Please let us know which of Jan's timeslots works best for you.
> I'm in - the earlier slot would be preferential for me to avoid clashing with
> family time.
>

I'm OK with all timeslots.
