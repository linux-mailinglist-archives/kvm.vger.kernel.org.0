Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E13AC190773
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 09:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgCXI0V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 04:26:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52542 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726091AbgCXI0V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 04:26:21 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02O82jJB120554
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 04:26:19 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywf0nq52j-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 04:26:19 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <raspl@linux.ibm.com>;
        Tue, 24 Mar 2020 08:26:16 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 24 Mar 2020 08:26:14 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02O8QEB742860946
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 08:26:14 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A2B7A405F;
        Tue, 24 Mar 2020 08:26:14 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F388A4060;
        Tue, 24 Mar 2020 08:26:14 +0000 (GMT)
Received: from [9.145.65.250] (unknown [9.145.65.250])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Mar 2020 08:26:14 +0000 (GMT)
Subject: Re: [PATCH 0/7] tools/kvm_stat: add logfile support
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com
References: <20200306114250.57585-1-raspl@linux.ibm.com>
 <7f396df1-9589-6dd0-0adf-af4376aa8314@redhat.com>
 <d893c37d-705c-b9a1-cf98-db997edf3bce@linux.ibm.com>
 <5c350f55-64be-43fc-237d-7f71b4e9afdc@redhat.com>
From:   Stefan Raspl <raspl@linux.ibm.com>
Date:   Tue, 24 Mar 2020 09:26:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <5c350f55-64be-43fc-237d-7f71b4e9afdc@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20032408-0012-0000-0000-00000396B528
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032408-0013-0000-0000-000021D3A866
Message-Id: <7c8b614a-a7a1-d33e-8762-b06d4b2fd45b@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_01:2020-03-23,2020-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 impostorscore=0 malwarescore=0 mlxlogscore=950 spamscore=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240039
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-03-23 11:12, Paolo Bonzini wrote:
> On 23/03/20 10:58, Stefan Raspl wrote:
>> Thx!
>> As for SIGHUP: The problem that I see with logrotate and likewise approaches is
>> how the heading is being handled: If it is reprinted every x lines (like the
>> original logging format in kvmstat does), then it messes up any chance of
>> loading the output in external tools for further processing.
>> If the heading is printed once only, then it will get pushed out of the log
>> files at some time - which is fatal, since '-f <fields>' allows to specify
>> custom fields, so one cannot reconstruct what the fields were.
> 
> For CSV output, can't you print the heading immediately after SIGHUP
> reopens the files?  (Maybe I am missing something and this is a stupid
> suggestion, I don't know).

(Same for me LOL)
To be able to make use of the logfiles, we'd need to have the heading appear at
the top of each of the files.
Couldn't find much info on how logrotate works internally, but from what I
gathered, it seems it moves out the current logfile e.g. /var/log/kvm.log to
become /var/log/kvm.log.1, and sends a SIGHUP to kvm_stat so that it re-opens
/var/log/kvm.log - which would then start out with a header again.
That should work, but can you confirm that this is what you're suggesting?
If so: Keep the current semantics for the original logging mode, where we have
the heading printed every 20 lines? I would assume so, as that format is better
suited for console logs, but just in case you wanted that changed...

Ciao,
Stefan

