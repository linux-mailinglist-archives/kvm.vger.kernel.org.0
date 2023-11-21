Return-Path: <kvm+bounces-2190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 94F767F2E26
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 14:18:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FB682819D3
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 13:18:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22E034A9BE;
	Tue, 21 Nov 2023 13:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IbHNwDvv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193FEF9;
	Tue, 21 Nov 2023 05:17:49 -0800 (PST)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ALDCEiQ019148;
	Tue, 21 Nov 2023 13:17:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=3Oo7oATBI3XF9jXxnCUBzOPtA7AbjEeahZao0eNi8vk=;
 b=IbHNwDvvzbKDkxSHR77VaWlNycvzS+WHoaqZGaOsA3H96VR6zp7LxYv6IUuDYsp5l4ky
 01Z1vX7fXC/mZo3OQZAQZhMAZKVtWZjiGuIlIsFwDkuGPrFF+D7j5lPDAqYNv8tvNLh3
 oytGChXo8AkRNmU/nz9Psbyjp7LZLyd8alZenE621XNogiJomqnUZS87pbclKfxYxx+O
 UW6vf47k9+ezUnMwjhyf7ciVa/tWSEkQO0sHrEoC8HsO+LeSlhAeCfywebglsfkk2mQN
 VbyBP8/8kVw7P8MI4c6IHRpFjVPuuI2DjsEMs/d7i5uAolocu263+9aUqt5qKWybb207 Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ugw7k84mq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Nov 2023 13:17:26 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3ALDCdEU021113;
	Tue, 21 Nov 2023 13:17:25 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ugw7k84m3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Nov 2023 13:17:25 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3ALD4Rjv005166;
	Tue, 21 Nov 2023 13:17:24 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3uf93krmdt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Nov 2023 13:17:24 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3ALDHM4l44696188
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Nov 2023 13:17:22 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 40EE520043;
	Tue, 21 Nov 2023 13:17:22 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1800820040;
	Tue, 21 Nov 2023 13:17:22 +0000 (GMT)
Received: from DESKTOP-2CCOB1S. (unknown [9.171.163.26])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 21 Nov 2023 13:17:22 +0000 (GMT)
Date: Tue, 21 Nov 2023 14:17:21 +0100
From: Tobias Huschle <huschle@linux.ibm.com>
To: Abel Wu <wuyun.abel@bytedance.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, netdev@vger.kernel.org, mst@redhat.com,
        jasowang@redhat.com
Subject: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6 sched/fair:
 Add lag based placement)
Message-ID: <ZVyt4UU9+XxunIP7@DESKTOP-2CCOB1S.>
References: <c7b38bc27cc2c480f0c5383366416455@linux.ibm.com>
 <20231117092318.GJ8262@noisy.programming.kicks-ass.net>
 <ZVdbdSXg4qefTNtg@DESKTOP-2CCOB1S.>
 <20231117123759.GP8262@noisy.programming.kicks-ass.net>
 <46a997c2-5a38-4b60-b589-6073b1fac677@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46a997c2-5a38-4b60-b589-6073b1fac677@bytedance.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5YBp4P-kD02aHi5UlT31PYUTe0EushCl
X-Proofpoint-ORIG-GUID: 6ItqPxzkG1YAF1ND0FGe09wiYZP3k9Y4
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-21_05,2023-11-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=653 clxscore=1011
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 adultscore=0 spamscore=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311210104

On Fri, Nov 17, 2023 at 09:07:55PM +0800, Abel Wu wrote:
> On 11/17/23 8:37 PM, Peter Zijlstra Wrote:

[...]

> > Ah, so if this is a cgroup issue, it might be worth trying this patch
> > that we have in tip/sched/urgent.
> 
> And please also apply this fix:
> https://lore.kernel.org/all/20231117080106.12890-1-s921975628@gmail.com/
> 

We applied both suggested patch options and ran the test again, so 

sched/eevdf: Fix vruntime adjustment on reweight
sched/fair: Update min_vruntime for reweight_entity() correctly

and

sched/eevdf: Delay dequeue

Unfortunately, both variants do NOT fix the problem.
The regression remains unchanged.


I will continue getting myself familiar with how cgroups are scheduled to dig 
deeper here. If there are any other ideas, I'd be happy to use them as a 
starting point for further analysis.

Would additional traces still be of interest? If so, I would be glad to
provide them.

[...]

