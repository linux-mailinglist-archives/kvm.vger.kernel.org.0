Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 338BF1A241D
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 16:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbgDHOcY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 10:32:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29656 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726605AbgDHOcY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Apr 2020 10:32:24 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 038E33Gx134967
        for <kvm@vger.kernel.org>; Wed, 8 Apr 2020 10:32:24 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 309205f6f0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 08 Apr 2020 10:32:23 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <raspl@linux.ibm.com>;
        Wed, 8 Apr 2020 15:32:02 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 Apr 2020 15:32:00 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 038EWIB452691184
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Apr 2020 14:32:18 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37C2CA4065;
        Wed,  8 Apr 2020 14:32:18 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14E1EA4054;
        Wed,  8 Apr 2020 14:32:18 +0000 (GMT)
Received: from [9.145.70.147] (unknown [9.145.70.147])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Apr 2020 14:32:18 +0000 (GMT)
Subject: Re: [PATCH v2 0/3] tools/kvm_stat: add logfile support
From:   Stefan Raspl <raspl@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
References: <20200402085705.61155-1-raspl@linux.ibm.com>
Date:   Wed, 8 Apr 2020 16:32:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200402085705.61155-1-raspl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20040814-0008-0000-0000-0000036CE82D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040814-0009-0000-0000-00004A8E85E6
Message-Id: <c6cd27e3-3af2-faa1-a375-f97490a9e078@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_10:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=1 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080117
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-04-02 10:57, Stefan Raspl wrote:
> Next attempt to come up with support for logfiles that can be combined
> with a solution for rotating logs.
> Adding another patch to skip records with all zeros to preserve space.
> 
> Changes in v2:
> - Addressed feedback from patch review
> - Beefed up man page descriptions of --csv and --log-to-file (fixing
>   a glitch in the former)
> - Use a metavar for -L in the --help output
> 
> 
> Stefan Raspl (3):
>   tools/kvm_stat: add command line switch '-z' to skip zero records
>   tools/kvm_stat: Add command line switch '-L' to log to file
>   tools/kvm_stat: add sample systemd unit file
> 
>  tools/kvm/kvm_stat/kvm_stat         | 84 ++++++++++++++++++++++++-----
>  tools/kvm/kvm_stat/kvm_stat.service | 16 ++++++
>  tools/kvm/kvm_stat/kvm_stat.txt     | 15 +++++-
>  3 files changed, 101 insertions(+), 14 deletions(-)
>  create mode 100644 tools/kvm/kvm_stat/kvm_stat.service

*ping*

