Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F6F4224C9
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 13:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234354AbhJELQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 07:16:14 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7998 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234343AbhJELQN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 07:16:13 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195BBx2d011453;
        Tue, 5 Oct 2021 07:14:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=vCjJ2YrlkR9bjpLgeUhEuc8Gnba+/UctVQLQu2d6i0A=;
 b=SjNvgV5ceAh6rv5j9OQtzB9PdLtVJOiOEoSvtyMDUAqDb8x8d0rnfJNM64NuT/KIwuo5
 sfiQu/iiOBKtCFCx6ASVUUXK/fg1MTZHxw/Ii04wno2mI+xS8rB6IjdesucBhEmUc2DQ
 NpAu0guJZKUQn4+BGiRJZlftssPfHR+wmvDzEBdnDlAebPhDaA4Kqk1dk858bjHfnOUa
 btzRbGsh8quFNA+7eKw0Fz2WD00+1i9Yz0krNeOI4WAXo0f+KuxN6if9wLLr9QMCNPRU
 xdS22DAjTolmEhUmxGGregoaN9fHGc8IROgYKAl4sm4aSNON58NfMn5Kuqmo2sPHU1dJ oQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bgnm9814y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 07:14:22 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 195BCWcD006329;
        Tue, 5 Oct 2021 11:14:21 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3beepjhh8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 11:14:20 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 195BEHgE40108452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 11:14:17 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55DA911C07B;
        Tue,  5 Oct 2021 11:14:17 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CFEA11C07A;
        Tue,  5 Oct 2021 11:14:17 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.51.33])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Oct 2021 11:14:17 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 1/5] [kvm-unit-tests PATCH v2 0/5] Add
 specification exception tests
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20211005090921.1816373-1-scgl@linux.ibm.com>
 <20211005090921.1816373-2-scgl@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
Message-ID: <a06c6df1-3da1-da43-3549-18f3abe6020d@linux.vnet.ibm.com>
Date:   Tue, 5 Oct 2021 13:14:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211005090921.1816373-2-scgl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _06z9OJd2X7vRndOZz-zu9pOS9eiLELn
X-Proofpoint-ORIG-GUID: _06z9OJd2X7vRndOZz-zu9pOS9eiLELn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-04_05,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1011 impostorscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 spamscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050065
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Oops, forgot to Cc the lists on the cover letter, see below.


Test that specification exceptions cause the correct interruption code
during both normal and transactional execution.

The last three patches are cosmetic only and could be dropped.

Unrelated: There should not be * in the file patterns in MAINTAINERS,
should there?

v1 -> v2
	Add license and test description
	Split test patch into normal test and transactional execution test
	Add comments to
		invalid PSW fixup function
		with_transaction
	Rename some variables/functions
	Pass mask as single parameter to asm
	Get rid of report_info_if macro
	Introduce report_pass/fail and use them

Janis Schoetterl-Glausch (5):
  s390x: Add specification exception test
  s390x: Test specification exceptions during transaction
  lib: Introduce report_pass and report_fail
  Use report_fail(...) instead of report(0/false, ...)
  Use report_pass(...) instead of report(1/true, ...)

 s390x/Makefile           |   1 +
 lib/s390x/asm/arch_def.h |   1 +
 lib/libcflat.h           |   6 +-
 lib/report.c             |  20 ++-
 lib/s390x/css_lib.c      |  30 ++--
 x86/vmx.h                |  31 ++--
 arm/psci.c               |   2 +-
 arm/timer.c              |   2 +-
 s390x/css.c              |  22 +--
 s390x/diag288.c          |   2 +-
 s390x/selftest.c         |   2 +-
 s390x/smp.c              |  16 +-
 s390x/spec_ex.c          | 345 +++++++++++++++++++++++++++++++++++++++
 x86/asyncpf.c            |  11 +-
 x86/emulator.c           |   2 +-
 x86/hyperv_stimer.c      |  24 ++-
 x86/hyperv_synic.c       |   2 +-
 x86/svm_tests.c          | 180 ++++++++++----------
 x86/syscall.c            |   2 +-
 x86/taskswitch2.c        |   2 +-
 x86/tsc_adjust.c         |   2 +-
 x86/vmx.c                |  23 ++-
 x86/vmx_tests.c          | 172 ++++++++++---------
 s390x/unittests.cfg      |   3 +
 24 files changed, 630 insertions(+), 273 deletions(-)
 create mode 100644 s390x/spec_ex.c

base-commit: fe26131eec769cef7ad7e2e1e4e192aa0bdb2bba
-- 
2.31.1

