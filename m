Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5A62A77BF
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 08:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgKEHJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 02:09:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14600 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725861AbgKEHJA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Nov 2020 02:09:00 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A572RZP041963
        for <kvm@vger.kernel.org>; Thu, 5 Nov 2020 02:08:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=UDiX4zEiceQcz3chjBfTp17e39rM6Gg1sA3aS9s7els=;
 b=MBv6gxWeEhrxRaCsaQ3ZkQVyuTxpNItx8qeSw2XtMFhl6LGtPl4KFy7FJtehdGpZ5eu0
 i/+rNGXXsnBtysrPBRzfvWHaXHK3I4oNP43QBYEnMKdg2sGAQfs99WPbl4E77Yn684Ol
 fcABdpDAq/6IZvBrrWIFqtJ8q8kgbSAD09V0eDF189LHHkGn/WmTjHrFfM2edSoe7bZR
 PBx9BIACDXovuLTjTihjVjSaaALDb8xqm/0lissj0W7jR1mTF3MPtwOay7HLBKsyv33C
 Bg4PvdZNbjL/XZ8sekZcqJC93GEO/xBgsdmckozsXt269eQgsfzY/W078K2GlheWB0N8 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34m7tdeyhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 05 Nov 2020 02:08:59 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A572Rd5041993
        for <kvm@vger.kernel.org>; Thu, 5 Nov 2020 02:08:53 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34m7tdeygs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 02:08:53 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A5782K2015328;
        Thu, 5 Nov 2020 07:08:52 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 34hm6hcbyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 07:08:52 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A578nfi4260496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Nov 2020 07:08:50 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5DFCA4089;
        Thu,  5 Nov 2020 07:08:49 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7232EA404D;
        Thu,  5 Nov 2020 07:08:49 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.167.78])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 Nov 2020 07:08:49 +0000 (GMT)
Subject: Re: [PATCH 00/11] KVM: selftests: Cleanups
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, frankja@linux.ibm.com, bgardon@google.com,
        peterx@redhat.com
References: <20201104212357.171559-1-drjones@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <92d2428b-4532-0f3d-7922-5fee962c4543@de.ibm.com>
Date:   Thu, 5 Nov 2020 08:08:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201104212357.171559-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_02:2020-11-05,2020-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 clxscore=1015 mlxscore=0 malwarescore=0 mlxlogscore=993 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011050051
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.20 22:23, Andrew Jones wrote:
> This series attempts to clean up demand_paging_test and dirty_log_test
> by factoring out common code, creating some new API along the way. It's
> main goal is to prepare for even more factoring that Ben and Peter want
> to do. The series would have a nice negative diff stat, but it also
> picks up a few of Peter's patches for his new dirty log test. So, the
> +/- diff stat is close to equal. It's not as close as an electoral vote
> count, but it's close.
> 
> I've tested on x86 and AArch64 (one config each), but not s390x.

I see no regression when I run 
make TARGETS=kvm kselftest

on an s390 system with these patches applied.

Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>


> Thanks,
> drew
> 
> 
> Andrew Jones (8):
>   KVM: selftests: Add x86_64/tsc_msrs_test to .gitignore
>   KVM: selftests: Drop pointless vm_create wrapper
>   KVM: selftests: Make the per vcpu memory size global
>   KVM: selftests: Make the number of vcpus global
>   KVM: selftests: Factor out guest mode code
>   KVM: selftests: Make vm_create_default common
>   KVM: selftests: Introduce vm_create_[default_]vcpus
>   KVM: selftests: Remove create_vm
> 
> Peter Xu (3):
>   KVM: selftests: Always clear dirty bitmap after iteration
>   KVM: selftests: Use a single binary for dirty/clear log test
>   KVM: selftests: Introduce after_vcpu_run hook for dirty log test
> 
>  tools/testing/selftests/kvm/.gitignore        |   2 +-
>  tools/testing/selftests/kvm/Makefile          |   4 +-
>  .../selftests/kvm/clear_dirty_log_test.c      |   6 -
>  .../selftests/kvm/demand_paging_test.c        | 213 +++-------
>  tools/testing/selftests/kvm/dirty_log_test.c  | 372 ++++++++++--------
>  .../selftests/kvm/include/aarch64/processor.h |   3 +
>  .../selftests/kvm/include/guest_modes.h       |  21 +
>  .../testing/selftests/kvm/include/kvm_util.h  |  20 +-
>  .../selftests/kvm/include/s390x/processor.h   |   4 +
>  .../selftests/kvm/include/x86_64/processor.h  |   4 +
>  .../selftests/kvm/lib/aarch64/processor.c     |  17 -
>  tools/testing/selftests/kvm/lib/guest_modes.c |  70 ++++
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  62 ++-
>  .../selftests/kvm/lib/s390x/processor.c       |  22 --
>  .../selftests/kvm/lib/x86_64/processor.c      |  32 --
>  15 files changed, 445 insertions(+), 407 deletions(-)
>  delete mode 100644 tools/testing/selftests/kvm/clear_dirty_log_test.c
>  create mode 100644 tools/testing/selftests/kvm/include/guest_modes.h
>  create mode 100644 tools/testing/selftests/kvm/lib/guest_modes.c
> 
