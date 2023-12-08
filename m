Return-Path: <kvm+bounces-3905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7F7F809F34
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 10:24:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E0061C209D0
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 09:24:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AED7B125CA;
	Fri,  8 Dec 2023 09:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AtTCDJOv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F47171C;
	Fri,  8 Dec 2023 01:24:39 -0800 (PST)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B886trX024659;
	Fri, 8 Dec 2023 09:24:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=JEAwVKDJqDLzP9w+newjcge67k65+TREqS2ks7je0ko=;
 b=AtTCDJOvj/19nSJWXCeGb4iQB/5NdIlPPkuidfMtuOJCxVaKgqOrYHcv47nmfH++6KHz
 r6Ldum6vLdBPuxKwaLt4fDPvMs451XHLcTcQXn2cR+eTz0PaCzpF8y78IuKwuYxYHSu9
 d1k+b1AVqrdGHUBm7w6+UGpONz0VOBo7nXrkbVa1n6vxWOM+uwjS1VUcU79AfAILyUcv
 8/Z4Z/w0ewI9neXkG9D33/S9jYUKLQYl8MXI3blxIPbg4tyZF2eFlo6KsSaVV6BvZ4zY
 MDQkcCQx6TDe680GqRBjGV+W1y6L5lHPttfgIF9mADw07BW+AGe36GfKuYG2N3vaR8kQ tg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uuxmnb1qm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 09:24:21 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B89MFGT019807;
	Fri, 8 Dec 2023 09:24:21 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uuxmnb1q7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 09:24:21 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B85umn7015437;
	Fri, 8 Dec 2023 09:24:20 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3utavkrrgf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 09:24:20 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B89OIYh21627458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 8 Dec 2023 09:24:18 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AD5132004B;
	Fri,  8 Dec 2023 09:24:18 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8177720043;
	Fri,  8 Dec 2023 09:24:18 +0000 (GMT)
Received: from DESKTOP-2CCOB1S. (unknown [9.171.204.69])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  8 Dec 2023 09:24:18 +0000 (GMT)
Date: Fri, 8 Dec 2023 10:24:16 +0100
From: Tobias Huschle <huschle@linux.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Abel Wu <wuyun.abel@bytedance.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, netdev@vger.kernel.org,
        jasowang@redhat.com
Subject: Re: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6
 sched/fair: Add lag based placement)
Message-ID: <ZXLgwLehNbaHy3yb@DESKTOP-2CCOB1S.>
References: <20231117092318.GJ8262@noisy.programming.kicks-ass.net>
 <ZVdbdSXg4qefTNtg@DESKTOP-2CCOB1S.>
 <20231117123759.GP8262@noisy.programming.kicks-ass.net>
 <46a997c2-5a38-4b60-b589-6073b1fac677@bytedance.com>
 <ZVyt4UU9+XxunIP7@DESKTOP-2CCOB1S.>
 <20231122100016.GO8262@noisy.programming.kicks-ass.net>
 <6564a012.c80a0220.adb78.f0e4SMTPIN_ADDED_BROKEN@mx.google.com>
 <d4110c79-d64f-49bd-9f69-0a94369b5e86@bytedance.com>
 <07513.123120701265800278@us-mta-474.us.mimecast.lan>
 <20231207014626-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231207014626-mutt-send-email-mst@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JiqueMXJHjz1wyoBIUbypaeXSzS3EqBo
X-Proofpoint-GUID: YLGCvY_lmzt3N6uVod2kg-9xSPS9GBBj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-08_04,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=568 priorityscore=1501 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312080077

On Thu, Dec 07, 2023 at 01:48:40AM -0500, Michael S. Tsirkin wrote:
> On Thu, Dec 07, 2023 at 07:22:12AM +0100, Tobias Huschle wrote:
> > 3. vhost looping endlessly, waiting for kworker to be scheduled
> > 
> > I dug a little deeper on what the vhost is doing. I'm not an expert on
> > virtio whatsoever, so these are just educated guesses that maybe
> > someone can verify/correct. Please bear with me probably messing up 
> > the terminology.
> > 
> > - vhost is looping through available queues.
> > - vhost wants to wake up a kworker to process a found queue.
> > - kworker does something with that queue and terminates quickly.
> > 
> > What I found by throwing in some very noisy trace statements was that,
> > if the kworker is not woken up, the vhost just keeps looping accross
> > all available queues (and seems to repeat itself). So it essentially
> > relies on the scheduler to schedule the kworker fast enough. Otherwise
> > it will just keep on looping until it is migrated off the CPU.
> 
> 
> Normally it takes the buffers off the queue and is done with it.
> I am guessing that at the same time guest is running on some other
> CPU and keeps adding available buffers?
> 

It seems to do just that, there are multiple other vhost instances
involved which might keep filling up thoses queues. 

Unfortunately, this makes the problematic vhost instance to stay on
the CPU and prevents said kworker to get scheduled. The kworker is
explicitly woken up by vhost, so it wants it to do something.

At this point it seems that there is an assumption about the scheduler
in place which is no longer fulfilled by EEVDF. From the discussion so
far, it seems like EEVDF does what is intended to do.

Shouldn't there be a more explicit mechanism in use that allows the
kworker to be scheduled in favor of the vhost?

It is also concerning that the vhost seems cannot be preempted by the
scheduler while executing that loop.

