Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFF218B241
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 12:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgCSLVu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 07:21:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37010 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725787AbgCSLVt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 07:21:49 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02JBAWfB135771
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 07:21:48 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yu7ad7vu7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 07:21:48 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <raspl@linux.ibm.com>;
        Thu, 19 Mar 2020 11:21:46 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 19 Mar 2020 11:21:43 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02JBLgQ444630230
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Mar 2020 11:21:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3CB2AE053;
        Thu, 19 Mar 2020 11:21:42 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1709AE04D;
        Thu, 19 Mar 2020 11:21:42 +0000 (GMT)
Received: from [9.145.6.140] (unknown [9.145.6.140])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 19 Mar 2020 11:21:42 +0000 (GMT)
Subject: Re: [PATCH 0/7] tools/kvm_stat: add logfile support
From:   Stefan Raspl <raspl@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
References: <20200306114250.57585-1-raspl@linux.ibm.com>
Date:   Thu, 19 Mar 2020 12:21:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200306114250.57585-1-raspl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20031911-0016-0000-0000-000002F3CE29
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031911-0017-0000-0000-00003357578E
Message-Id: <d1c5e601-f7e3-4fa1-3418-4bc2679f3204@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-19_02:2020-03-19,2020-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=1 clxscore=1015 adultscore=0 spamscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003190048
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-03-06 12:42, Stefan Raspl wrote:
> This patch series provides a couple of new options to make logging to
> files feasible.
> Specifically, we add command line switches to specify an arbitrary time
> interval for logging, and to toggle between a .csv and the previous
> file format. Furthermore, we allow logging to files, where we utilize a
> rotating set of 6 logfiles, each with its own header for easy post-
> processing, especially when using .csv format.
> Since specifying logfile size limits might be a non-trivial exercise,
> we're throwing in yet another command line option that allows to
> specify the minimum timeframe that should be covered by logs.
> Finally, there's a minimal systemd unit file to deploy kvm_stat-based
> logging in Linux distributions.
> Note that the decision to write our own logfiles rather than to log to
> e.g. systemd journal is a conscious one: It is effectively impossible to
> write csv records into the systemd journal, the header will either
> disappear after a while or has to be repeated from time to time, which
> defeats the purpose of having a .csv format that can be easily post-
> processed, etc.
> See individual patch description for further details.
> 
> 
> Stefan Raspl (7):
>   tools/kvm_stat: rework command line sequence and message texts
>   tools/kvm_stat: switch to argparse
>   tools/kvm_stat: add command line switch '-s' to set update interval
>   tools/kvm_stat: add command line switch '-c' to log in csv format
>   tools/kvm_stat: add rotating log support
>   tools/kvm_stat: add command line switch '-T'
>   tools/kvm_stat: add sample systemd unit file
> 
>  tools/kvm/kvm_stat/kvm_stat         | 434 +++++++++++++++++++++-------
>  tools/kvm/kvm_stat/kvm_stat.service |  15 +
>  tools/kvm/kvm_stat/kvm_stat.txt     |  59 ++--
>  3 files changed, 384 insertions(+), 124 deletions(-)
>  create mode 100644 tools/kvm/kvm_stat/kvm_stat.service
> 

Any consideration yet...?

Ciao,
Stefan

