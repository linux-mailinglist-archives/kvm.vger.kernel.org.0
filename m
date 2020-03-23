Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAE418F242
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 10:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgCWJ6S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 05:58:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50282 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727761AbgCWJ6S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 05:58:18 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02N9XtO7097847
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 05:58:17 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywe7rm6d4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 05:58:16 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <raspl@linux.ibm.com>;
        Mon, 23 Mar 2020 09:58:14 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 23 Mar 2020 09:58:12 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02N9wBBn36962712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Mar 2020 09:58:11 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DB3E4203F;
        Mon, 23 Mar 2020 09:58:11 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 304FA42049;
        Mon, 23 Mar 2020 09:58:11 +0000 (GMT)
Received: from [9.145.48.138] (unknown [9.145.48.138])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 23 Mar 2020 09:58:11 +0000 (GMT)
Subject: Re: [PATCH 0/7] tools/kvm_stat: add logfile support
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com
References: <20200306114250.57585-1-raspl@linux.ibm.com>
 <7f396df1-9589-6dd0-0adf-af4376aa8314@redhat.com>
From:   Stefan Raspl <raspl@linux.ibm.com>
Date:   Mon, 23 Mar 2020 10:58:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <7f396df1-9589-6dd0-0adf-af4376aa8314@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20032309-0012-0000-0000-000003961EBC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032309-0013-0000-0000-000021D30E4B
Message-Id: <d893c37d-705c-b9a1-cf98-db997edf3bce@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_02:2020-03-21,2020-03-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003230054
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-03-19 12:54, Paolo Bonzini wrote:
> On 06/03/20 12:42, Stefan Raspl wrote:
>> This patch series provides a couple of new options to make logging to
>> files feasible.
>> Specifically, we add command line switches to specify an arbitrary time
>> interval for logging, and to toggle between a .csv and the previous
>> file format. Furthermore, we allow logging to files, where we utilize a
>> rotating set of 6 logfiles, each with its own header for easy post-
>> processing, especially when using .csv format.
>> Since specifying logfile size limits might be a non-trivial exercise,
>> we're throwing in yet another command line option that allows to
>> specify the minimum timeframe that should be covered by logs.
>> Finally, there's a minimal systemd unit file to deploy kvm_stat-based
>> logging in Linux distributions.
>> Note that the decision to write our own logfiles rather than to log to
>> e.g. systemd journal is a conscious one: It is effectively impossible to
>> write csv records into the systemd journal, the header will either
>> disappear after a while or has to be repeated from time to time, which
>> defeats the purpose of having a .csv format that can be easily post-
>> processed, etc.
>> See individual patch description for further details.
>>
>>
>> Stefan Raspl (7):
>>   tools/kvm_stat: rework command line sequence and message texts
>>   tools/kvm_stat: switch to argparse
>>   tools/kvm_stat: add command line switch '-s' to set update interval
>>   tools/kvm_stat: add command line switch '-c' to log in csv format
>>   tools/kvm_stat: add rotating log support
>>   tools/kvm_stat: add command line switch '-T'
>>   tools/kvm_stat: add sample systemd unit file
>>
>>  tools/kvm/kvm_stat/kvm_stat         | 434 +++++++++++++++++++++-------
>>  tools/kvm/kvm_stat/kvm_stat.service |  15 +
>>  tools/kvm/kvm_stat/kvm_stat.txt     |  59 ++--
>>  3 files changed, 384 insertions(+), 124 deletions(-)
>>  create mode 100644 tools/kvm/kvm_stat/kvm_stat.service
>>
> 
> I queued patches 1-4.  For the others, however, I would prefer to add
> support for SIGHUP instead (to reopen the logfile), so that one can use
> the usual logrotate services.

Thx!
As for SIGHUP: The problem that I see with logrotate and likewise approaches is
how the heading is being handled: If it is reprinted every x lines (like the
original logging format in kvmstat does), then it messes up any chance of
loading the output in external tools for further processing.
If the heading is printed once only, then it will get pushed out of the log
files at some time - which is fatal, since '-f <fields>' allows to specify
custom fields, so one cannot reconstruct what the fields were.
That's why I did things as I did - which works great for .csv output.
I'd really like to preserve the use-case where a user has a chance to
post-process the output, especially .csv, in other tools. So how how about we do
both, add support for SIGHUP for users who want to use logrotate (I imagine this
would be used with the original logging format only), and keep the suggested
support for 'native' log-rotation for .csv users?

Ciao,
Stefan

