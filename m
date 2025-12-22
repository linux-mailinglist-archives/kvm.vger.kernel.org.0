Return-Path: <kvm+bounces-66513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 341BBCD6D69
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 18:36:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E31D33016B8C
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E60C633E35D;
	Mon, 22 Dec 2025 17:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pooladkhay.com header.i=@pooladkhay.com header.b="QY1bWC8h"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.ms.icloud.com (p-west3-cluster4-host3-snip4-2.eps.apple.com [57.103.74.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775D233D6CB
	for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 17:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.74.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766424437; cv=none; b=UKx0G0lgWXvqg/ZhX+s8Q+dZytbkNAYK40VuKEsAVgZxUo6KflQkz8MtU4lef3PC2n+/r6qBgV1ppoc3nyLmYFSfOPjArItCQGoCitQNjcB/poJnEDv3rOBrxKJb0c6ccI5HD23ZmhwEGDgsUQgogjzE0+neGVpOVb2DMnpBZDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766424437; c=relaxed/simple;
	bh=b30wTRdphI7VfWN2pv1ewBN4/YxpnmW2vwgGHjMKnms=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jmOB9H5LgaXgxhd+rqiqLzv+Bf96IdQRSkxxBe+ctvT/wayhGAj2t/PFRJ9+pxqwDO94lPGEgaon3Zb0AVc2GC0CKKH2MH114hGFJLuWSCk6bkqipaN7mtt8gjmnc47lZuYGnj8UkB/W0uu7u7DlE9BYR5Jf53HcR4ZQZguuUtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pooladkhay.com; spf=pass smtp.mailfrom=pooladkhay.com; dkim=pass (2048-bit key) header.d=pooladkhay.com header.i=@pooladkhay.com header.b=QY1bWC8h; arc=none smtp.client-ip=57.103.74.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pooladkhay.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pooladkhay.com
Received: from outbound.ms.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-3a-60-percent-7 (Postfix) with ESMTPS id CA7C01800B58;
	Mon, 22 Dec 2025 17:27:13 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pooladkhay.com; s=sig1; bh=TNqeP4jt6qTJRqZPAZSjH3QpkPsxCwi4JkvYPIRvm+U=; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:x-icloud-hme; b=QY1bWC8hUJSakIfvJCoc2I1koI98j/yOw+4kl9Wis/yeGLLbEyVQV7To3KjTgpLE77szBmxwTWtKV+5RSL0ryh/ttY3aD24w/1FZZoErNvNy5M010ZfJZx2fGqUjnvwRHZaX7dMp7wruWsFscvMU/WB9ffJsUqoe7jgBxh+DffHLv29EYNuzLHzyoqEaROo6Jko3fONheWOsc0jBZtGpSaTQEt2OXWWlHVW8FZ9kHN7WrZ2A/8yiRRLuXTG+MskWLSutFY4YKxruYOAuemvUwx07w7VmFDFCiyZGEeZycCXQtbXyuFz8yyOHouG4r29WVebVfWMppeqfv8l9fWpuQw==
mail-alias-created-date: 1721833214903
Received: from [192.168.1.131] (unknown [17.57.154.37])
	by p00-icloudmta-asmtp-us-west-3a-60-percent-7 (Postfix) with ESMTPSA id 0EE231800377;
	Mon, 22 Dec 2025 17:27:11 +0000 (UTC)
Message-ID: <c70edd09-f8fe-4266-abc6-5911c13c9159@pooladkhay.com>
Date: Mon, 22 Dec 2025 17:27:10 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: selftests: Fix sign extension bug in
 get_desc64_base()
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251220021050.88490-1-mj@pooladkhay.com>
 <aUlt4zOuyQ2WNiRe@google.com>
Content-Language: en-US
From: MJ Pooladkhay <mj@pooladkhay.com>
In-Reply-To: <aUlt4zOuyQ2WNiRe@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: Ld0Pq_sLSRqnMJCUKbWtCoC8eSwLIoX6
X-Proofpoint-ORIG-GUID: Ld0Pq_sLSRqnMJCUKbWtCoC8eSwLIoX6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE2MCBTYWx0ZWRfXwyNcpu1p122y
 H23OtJTn5ZMQt2ATh9voGPlpYAf8k7vSLFQkU1SJoaApgbt1yGBQxfY/w3wh+jCeinH8Povwxev
 qgXIrX3DWjOBGDfM/ZLayOPUJtOI1iRHVAlVudOBxym9UpVXPzOdr/p3MBDYHJcsWp15kEOWbmN
 Evq70bll1fT0YJHX6CtgcQZR4yP1vhh5+4iGolnWAxU4Usca7ESpkDqPgKZk62P7Ybz3IiZHuF3
 4kooMFGIWKOzG9azOju1Q0u7lyLQsUXYUn+BK8DTvitKrpWLsZJPJd+QBc3DjyUIsw70bFk6VLi
 5C66QZOumwyonTq1k8S
X-Authority-Info: v=2.4 cv=PcbyRyhd c=1 sm=1 tr=0 ts=69497f72 cx=c_apl:c_pps
 a=qkKslKyYc0ctBTeLUVfTFg==:117 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7lkYn2qxqkAejb1e7jUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1030
 phishscore=0 suspectscore=0 mlxscore=0 adultscore=0 malwarescore=0
 mlxlogscore=664 spamscore=0 bulkscore=0 classifier=spam authscore=0 adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512220160
X-JNJ: AAAAAAAB5MssJdbbQ0322a/+hmY15+Mp/oZwGeciArMLj3hLM7uKkE8a30+LZjTIcx8LoWSK3r85wxzd/qa5F9oFdftSVijhkOWG/uj2vO2COuXn1kvLGgKcqW2h9Y/d7yj/+NrYur+JewBeu57a8pCUuMONQ4KjKXov5s4be2x3MJfOqpWFIR4hiL8+aA5gf1un0Z/fKcCmKizam80GWYj2kJLtcGaO9Vh7fU+UzOeuIJ5SfEqg5B0zQw7+9BF0vyQ1HXGAWdaurzghQX9X67fPeushhaWxFkze+3l2r2gVvD5MP1uRYuczNVGJHgzJmw7xd5XlIAJ9+d6GMXjUPzvgyOhTrayJyRQnjzRNj0aTxDzw6u16gVvOM2Xsv2K9UZF1Z8keNaRcpgwvMe5bzVODWV23LtuljPOFaNxdFThojleaFkHYi7nC709O7LQpkJGkqhnSyEkSKq6pfaRj7cboAmoIofv+D9nBjBXIaWb0g4BJ7fKuDlfmFs6ot79LY1SbYLGLrzLS4dHz9JLniPd6eS32zKE62HwE5m2k4AYxdh0d5LmgNhah4CryuWwe+ccw+M17wPEzC6S7GoDM/AdHpi6DPF0mSJUV/4d0VA9cSypAi1Gbiytp88RRg60n7gfyIzSitMnDU74n3DrKxBNcUs9FYIItS0Jp4R9dADfWi1Mkb3Bfx9g=

On Mon, Dec 22, 2025, Sean Christopherson wrote:

> Ugh, I hate integer promotion rules.  I wish there was a more useful version of
> -Wconversion :-/
True! It caused me weeks of grief tracking down these triple faults!
> I don't see any reason to have an intermediate "low", it just makes it harder
> to piece the entire thing together.  My vote is for:
>
> 	return (uint64_t)desc->base3 << 32 |
> 	       (uint64_t)desc->base2 << 24 |
> 	       (uint64_t)desc->base1 << 16 |
> 	       (uint64_t)desc->base0;

Thanks for the review. I agree, your version is much cleaner. I will 
send a v2 with this change shortly.

Best,
MJ Pooladkhay


